local _,lr = require "luarocks.require"
local url = require "socket.url"
local pp = require "purepack"
local posix_fcntl = require "posix.fcntl"
local posix_glob = require "posix.glob"
local posix_unistd = require "posix.unistd"
local posix_errno = require "posix.errno"
local posix_sys_stat = require "posix.sys.stat"
local posix_sys_wait = require "posix.sys.wait"
local posix_time = require "posix.sys.time"
local stp_exists,stp = pcall(require,"StackTracePlus")
require "conf"

if stp_exists then
  if lunit then
    stp = nil
  else
    debug.traceback = stp.stacktrace
  end
end

-- file/stdout logging
local logfile = nil
local logfile_name = nil
local verbose_logging = false
local logfile_rotation_day = nil
local rotation_counter = 0
local floor = math.floor

local function mantissa(num)
  return num-floor(num)
end

function verbose_log(on_)
  verbose_logging = on_
end

local function rotate_log_file(name)
  rotation_counter = rotation_counter + 1
  if rotation_counter%10~=1 then
    return
  end

  local today = os.date("%y%m%d")
  if logfile_rotation_day==today then
    return
  end

  if logfile then
    local rotated_file_name = logfile_name.."-"..logfile_rotation_day
    logfile:flush()
    logfile:close()
    if not file_exists(rotated_file_name) then
      os.rename(logfile_name,rotated_file_name)
    end
  end

  logfile_rotation_day = today
  name = name or logfile_name
  if not name then return nil end

  local f = io.open(name,"a")
  if not f then
    io.stderr:write(name,"\n")
    return nil, string.format("can't open `%s' for writing",name)
  end
  f:setvbuf ("line")
  logfile = f
  logfile_name = name
end

function log_file(path_)
  local name = string.find(path_,"%.log$") and path_ or string.format("%s.log",path_)
  rotate_log_file(name)
end

local function flog(level,...)
  rotate_log_file()
  local pid = posix_unistd and posix_unistd.getpid() or "-"
  local sarg = {pid,os.date("%y%m%d:%H:%M:%S"),level," "}
  for _,v in ipairs({...}) do
    table.insert(sarg,tostring(v))
  end
  local msg = table.concat(sarg," ")
  if verbose_logging then
    io.stderr:write(msg,"\n")
  end
  if logfile then
    logfile:write(msg,"\n")
  end
  return true
end

function close_log_file()
  if logfile then
    logfile:close()
    logfile = nil
  end
end


function logd(...)
  return ((logfile or verbose_logging) and flog("d",...))
end

function logi(...)
  return ((logfile or verbose_logging) and flog("i",...))
end

function logw(...)
  return ((logfile or verbose_logging) and flog("w",...))
end

function loge(...)
  return ((logfile or verbose_logging) and flog("e",...))
end

function logf(...)
  return ((logfile or verbose_logging) and flog("f",...))
end


local function nop()
end

function tablein(tbl_)
  local current = 0

  local function read()
    current = current + 1
    return tbl_[current]
  end

  return {
    read = read,
  }

end

function ioout_generic(writer_,delim_)
  local function write(...)
    for _,v in ipairs({...}) do
      writer_(tostring(v))
      writer_(delim_)
    end
  end

  return {
    write = write,
  }
end

function ioout(io_,delim_)
  return ioout_generic(function(o_)
      io_:write(o_)
                       end,delim_)
end

function stdout(delim_)
  return ioout(io.output(),delim_)
end

function ioin_generic(lines_itr_,delim_)
  local read = coroutine.wrap(function()
      for l in lines_itr_() do
        for p in split_helper(l,delim_) do
          -- as our arrays write the delimiter after every
          -- item, we have to skip the last, empty, one
          if #p~=0 then
            coroutine.yield(p)
          end
        end
      end
  end)


  return {
    read = read,
  }


end

function ioin(io_,delim_)
  return ioin_generic(io_.lines,delim_)
end

function strout(delim_)
  local str = {}
  local out = ioout_generic(function(o_)
      table.insert(str,o_)
                            end,delim_ or ",")
  out.get_string = function()
    return table.concat(str,"")
  end
  return out
end


function strin(str_)
  return ioin_generic(function() return string_lines(str_) end,",")
end


function trim(str)
  if not str then return nil end
  local _,_,s = string.find(str,"^%s*(.-)%s*$")
  return s or ""
end

function collectionout(out_,bra_,ckt_)
  local first = true

  return {
    head = function()
      out_.write(bra_)
    end,
    tail = function()
      out_.write(ckt_)

    end,
    elem = function(...)
      if not first then out_.write(",") end
      first = false
      out_.write(...)
    end
  }

end

function shallow_clone_array(array_,max_idx_)
  local cloned = {}
  for i,a in ipairs(array_) do
    if i<=max_idx_ then
      cloned[i] = a
    end
  end
  return cloned
end

function split_helper(str_,delim_)
  return coroutine.wrap(
    function()
      local start = 1
      local t,s
      local ds = #delim_
      local find,sub = string.find,string.sub
      local yield = coroutine.yield
      while str_ and start do
        t = find(str_,delim_,start,true)
        if t then
          _,_,s = find(sub(str_,start,t-1),"^%s*(.-)%s*$")
          start = t+ds
        else
          _,_,s = find(sub(str_,start),"^%s*(.-)%s*$")
          start = nil
        end
        yield(s)
      end
  end)
end

function split(str_,delim_)
  local items = {}
  for p in split_helper(str_,delim_) do
    if #p>0 then
      items[#items+1] = p
    end
  end
  return items
end

function string_lines(str_)
  return split_helper(str_,"\n")
end


function remove_comment(line_)
  local hash = string.find(line_,"#",1,true)

  return trim(hash and string.sub(line_,1,hash-1) or line_)
end

function lines_without_comments(lines_iterator)
  return coroutine.wrap(function()
      for line in lines_iterator do
        line = remove_comment(line)
        if #line>0 then coroutine.yield(line) end
      end
  end)
end

function n_lines(n,lines_iterator)
  return coroutine.wrap(function()
      for line in lines_iterator do
        n = n - 1
        if n>=0 then coroutine.yield(line) end
      end
  end)
end

function concat_arrays(lhs_,rhs_,callback_)
  for _,v in ipairs(rhs_) do
    lhs_[#lhs_+1] = callback_ and callback_(v) or v
  end
  return lhs_
end


function t2s(tbl)
  if tbl==nil then
    return
  end
  if type(tbl)~='table' then return tostring(tbl) end
  local rep = {}
  for key,val in pairs(tbl) do
    if type(val)=='table' then
      table.insert(rep,string.format('"%s":{%s}',key,t2s(val)))
    else
      table.insert(rep,string.format('"%s":"%s"',key,t2s(val)))
    end
  end

  return table.concat(rep,',')
end

function po(...)
  for _,v in ipairs({...}) do
    print(t2s(v))
  end
end

function table_size(tbl_)
  if not tbl_ then return 0 end
  if #tbl_>0 then return #tbl_ end
  local current = 0
  local k = next(tbl_)
  while k do
    current = current + 1
    k = next(tbl_,k)
  end

  return current
end


function serialize_table_of_arrays(out_,tbl_,callback_)
  out_.write(table_size(tbl_))
  for key,items in pairs(tbl_) do
    out_.write(key)
    out_.write(#items)
    for _,i in ipairs(items) do
      callback_(out_,i)
    end
  end
end


function deserialize_table_of_arrays(in_,callback_)
  local size = tonumber(in_.read())
  local tbl = {}
  for i=1,size do
    local key = in_.read()
    local num_items = tonumber(in_.read())
    local items = {}
    for j=1,num_items do
      items[#items+1] = callback_(in_)
    end
    tbl[key] = items
  end
  return tbl
end


function with_file(file_,func_,mode_)
  local f = io.open(file_,mode_ or "r")
  if not f then return false end
  local success, rv = pcall_wrapper(function() return func_(f) end)
  f:close()
  if not success then
    loge("with_file callback error",rv)
    return nil
  end
  return rv
end

function directory_exists(dir)
  local st = posix_sys_stat.stat(dir)
  return st and posix_sys_stat.S_ISDIR(st.st_mode) > 0 or false
end

function file_exists(file_)
  return with_file(file_,function() return true end)
end

function file_size(file_)
  return with_file(file_,
                   function(f)
                     return f:seek("end")
                   end,"rb")
end

-- based on http://lua-users.org/wiki/AlternativeGetOpt
-- with slight modification - non '-' prefixed args are accumulated under the "rest" key
function getopt(arg,options)
  local tab = {}
  tab["rest"] = {}
  local prev_in_options = false

  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
      prev_in_options = false
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          prev_in_options = true
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    else
      if not prev_in_options then
        table.insert(tab["rest"],v)
      end
      prev_in_options = false
    end
  end
  return tab
end

function copy_table(from_,to_)
  if from_ then
    local key,val = next(from_)
    while key and val do
      to_[key] = val
      key,val = next(from_,key)
    end
  end
  return to_
end

local TIME_UNITS = {s=1, m=60, h=3600, d=3600*24, w=3600*24*7, y=3600*24*365}
local TIME_UNITS_SORTED = (function()
    local array = {}
    for u,f in pairs(TIME_UNITS) do
      table.insert(array,{f,u})
    end
    table.sort(array,function(a,b)
                 return a[1]>b[1]
    end)
    return array
                          end)()


-- to handle 5.3's integers
local tointeger = _VERSION>"Lua 5.2" and
function(num_) return math.tointeger(num_) end
  or
function(num_) return num_ end

local parse_time_unit_cache = {}

function parse_time_unit(str_)
  local secs = nil
  if not str_ then
    return nil
  end
  if not parse_time_unit_cache[str_] then
    string.gsub(str_,"^(%d+)([smhdwy])$",
                function(num,unit)
                  secs = tointeger(num*TIME_UNITS[unit])
    end)
    parse_time_unit_cache[str_] = secs or tonumber(str_) or 0
  end
  return parse_time_unit_cache[str_]
end


local secs_to_time_unit_cache = {}

function secs_to_time_unit(secs_)
  if secs_to_time_unit_cache[secs_] then
    return secs_to_time_unit_cache[secs_]
  end
  local fmod = math.fmod
  for _,v in pairs(TIME_UNITS_SORTED) do
    if secs_>=v[1] and fmod(secs_,v[1])==0 then
      local rv = string.format("%d%s",secs_/v[1],v[2])
      secs_to_time_unit_cache[secs_] = rv
      return rv
    end
  end

  return nil
end


function pp_timestamp(seconds_)
  local s = seconds_
  local output = {}
  for _,v in pairs(TIME_UNITS_SORTED) do
    local p = math.floor(s/v[1])
    local q = math.fmod(s,v[1])
    if p>0 then
      table.insert(output,p..v[2])
      s = q
    end
  end
  return table.concat(output)
end


function is_prefix(metric_,prefix_)
  return prefix_=="*" or string.find(metric_,prefix_,1,true)==1
end

function parse_time_pair(str_)
  local step,period = string.match(str_,"^(%w+):(%w+)$")
  return parse_time_unit(step),parse_time_unit(period)
end

function normalize_timestamp(timestamp_,step_,period_)
  return math.floor(timestamp_/step_)*step_
end

function calculate_idx(timestamp_,step_,period_)
  local idx = math.floor((timestamp_ % period_) / step_)
  -- adjust the timestamp so it'll be at the beginning of the step
  return idx,normalize_timestamp(timestamp_,step_,period_)
end

function to_timestamp_helper(expr_,now_,latest_)
  local interpolated = string.gsub(expr_,"(%l+)",{now=now_, latest=latest_})
  interpolated = string.gsub(interpolated,"(%w+)",parse_time_unit)
  if not string.match(interpolated,"^[%s%d%-%+]+$") then
    return nil
  end
  if _VERSION>="Lua 5.2" then
    return math.abs(load("return "..interpolated)())
  end
  return math.abs(loadstring("return "..interpolated)())
end

function to_timestamp(expr_,now_,latest_)
  if not expr_ then return nil end
  local from,to = string.match(expr_,"(.+)%.%.(.+)")
  if not from then
    return to_timestamp_helper(expr_,now_,latest_)
  end
  from = to_timestamp_helper(from,now_,latest_)
  to = to_timestamp_helper(to,now_,latest_)
  return {from,to}
end

if lunit then
  local hard_coded_time
  function set_hard_coded_time(v)
    hard_coded_time = v
  end
  function time_now()
    return hard_coded_time or os.time()
  end
else
  function time_now()
    return os.time()
  end
end

function parse_input_line(line_)
  local items = nil
  if string.sub(line_,1,1)=='.' then
    -- command
    items = split(line_,' ')
    items[1] = string.sub(items[1],2)
    return items,"command"
  end
  -- metrics
  items = split(line_,' ')
  return items
end

function legit_input_line(metric_,sum_,timestamp_,hits_)
  local typ,sum = string.match(sum_ or "","([=%^]?)([%d.]+)")

  if typ and #typ==0 then
    typ = nil
  end
  timestamp_ = timestamp_=="@now" and os.time() or tonumber(timestamp_)
  sum = tonumber(sum)

  if not metric_ or #metric_>MAX_METRIC_LEN or not sum or not timestamp_ or (hits_ and not tonumber(hits_)) then
    return
  end
  return timestamp_,tonumber(hits_) or 1,sum,typ
end

function metric_hierarchy(metric_)
  return coroutine.wrap(
    function()
      local format = string.format
      local current = ""
      for i,p in ipairs(split(metric_,'.')) do
        current = i==1 and p or format("%s.%s",current,p)
        coroutine.yield(current)
      end
  end)
end

TRUTH = { [true]=true,["true"]=true, yes=true, on=true, [1]=true }
function is_true(str_)
  return str_ and TRUTH[str_]
end

FALSEHOOD = { [false]=true,["false"]=true, no=true, off=true, [0]=true }
function is_false(str_)
  return str_ and FALSEHOOD[str_]
end

function qs_params(raw_qs_)
  local match = string.match
  local params = {}
  for _,p in ipairs(split(raw_qs_ or "","&")) do
    local k,v = match(p,"([^=]+)=(.+)$")
    if k then
      params[k] = url.unescape(v) or ""
    end
  end
  return params
end

function keys(table_)
  local ks = {}
  local insert = table.insert

  for k,_ in pairs(table_) do
    insert(ks,k)
  end

  return ks
end

function uniq(array_)
  local ks = {}
  local insert = table.insert

  for _,k in ipairs(array_) do
    ks[k] = true
  end

  local un = {}
  for k,_ in pairs(ks) do
    insert(un,k)
  end
  return un
end

function uniq_pairs(array_)
  local ks = {}

  for _,prs in ipairs(array_ or {}) do
    ks[prs[1]..":"..prs[2]] = true
  end

  local un = {}
  local match = string.match
  local insert = table.insert

  for prs,_ in pairs(ks) do
    local a,b = match(prs,"^([%d%.]+):([%d%.]+)$") -- TODO: consider caching
    insert(un,{tonumber(a),tonumber(b)})
  end
  table.sort(un,function(u,v) return u[1]<v[1] or (u[1]==v[1] and u[2]<v[2]) end)
  return un
end

function iterate_table(table_,start_,end_)
  return coroutine.wrap(
    function()
      if not table_ then return end

      for k,v in pairs(table_) do
        start_ = start_-1
        if start_<=0 then
          coroutine.yield(k,v)
        end
        end_ = end_ - 1
        if end_==0 then return end
      end
  end)
end

function split_name(name_)
  local metric,step,period = string.match(name_,"^(.+);(%w+):(%w+)$")
  return metric,step and parse_time_unit(step),period and parse_time_unit(period)
end


function get_slot(data_,idx_,offset_)
  -- idx_ is zero based
  local size = pp.PNS
  if offset_ then
    return pp.from_binary(data_,1+size*(idx_*3+offset_))
  end
  return pp.from_binary3(data_,1+size*idx_*3)
end


function set_slot(data_,idx_,offset_,a,b,c)
  -- idx_ is zero based and we work in 0 based indexing and then add some
  local sub = string.sub
  local size = pp.PNS
  if offset_ then
    local i = size*(idx_*3+offset_)
    return sub(data_,1,i),pp.to_binary(a),sub(data_,1+i+size)
  end
  local i = size*idx_*3
  return sub(data_,1,i),pp.to_binary3(a,b,c),sub(data_,1+i+size*3)
end

function printf(format_,...)
  print(string.format(format_,...))
end

function hex(s)
  return string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
end


-- based on http://en.wikibooks.org/wiki/Algorithm_implementation/Sorting/Insertion_sort#JavaScript


function insertion_sort(array_)
  for i,v in ipairs(array_) do
    local j = i-1
    while j>0 and array_[j]>v do
      array_[j+1] = array_[j]
      j = j - 1
    end
    array_[j+1] = v
  end
  return array_
end

function bounded_by_level(string_,prefix_,level_)
  if not level_ then return true end
  local num_dots = 0
  local s = #prefix_ or 0
  local find = string.find

  -- we count the number of dot ('.') separated components past the prefix.
  -- level_==0 means we accept no dots in the tail
  -- while level_==1 means we allow a single dot .
  repeat
    s = find(string_,".",s+1,true)
    if s then
      num_dots = num_dots + 1
    end
  until not s or num_dots>level_
  return num_dots<=level_
end

function trim_to_level(string_,prefix_,level_)
  local find = string.find
  if not level_ or not string_ or find(string_,prefix_,1,true)~=1 then return end
  local final_dot
  local s = #prefix_-1


  repeat
    s = find(string_,".",s+1,true)
    level_ = level_ - 1
    final_dot = (s or 0)-1 -- leveraging the use of -1 as the end of string position
  until not s or level_<0
  return final_dot and string.sub(string_,1,final_dot) or nil
end

function drop_one_level(string_)
  if not string_ then return end
  local count = 0
  local s = 0
  local find = string.find

  repeat
    local t = find(string_,".",s+1,true)
    if not t then
      if s==0 then return '' end
      return string.sub(string_,1,s-1)
    end
    s = t
  until not s
  return nil
end

-- from http://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function hex(s)
  return string.gsub(s,"(.)",function (x) return string.format("%02X",string.byte(x)) end)
end

function adler32(str_)
  local a = 1
  local b = 0
  for i=1,#str_ do
    a = math.fmod(a + string.byte(str_,i,i),65521)
    b = math.fmod(b + a,65521)
  end
  return b*65536 + a
end

function fork_and_exit(callback_)
  if not posix_unistd then
    return callback_()
  end

  local child = posix_unistd.fork()
  if child~=0 then
    logi("fork (parent)",posix_unistd.getpid(),child)
    return
  end
  logi("fork (child)",posix_unistd.getpid())
  pcall_wrapper(callback_)
  logi("exiting",posix_unistd.getpid())
  posix_unistd._exit(0)
end

-- based on http://luaposix.github.io/luaposix/docs/examples/lock.lua.html
function posix_lock(lock_file_,callback_)
  if not posix_fcntl then
    return callback_()
  end

  -- Set lock on file
  local fd = posix_fcntl.open(lock_file_, posix_fcntl.O_CREAT, tonumber("666", 8))
  if not fd then
    logw("posix_lock - unable to obtain lock",lock_file_)
    return
  end
  local lock = {
    l_type = posix_fcntl.F_WRLCK;     -- Exclusive lock
    l_whence = posix_unistd.SEEK_SET;  -- Relative to beginning of file
    l_start = 0;            -- Start from 1st byte
    l_len = 0;              -- Lock whole file
  }
  local result,err,err_str = posix_fcntl.fcntl(fd, posix_fcntl.F_SETLK, lock)
  logi("posix_lock acquire",lock_file_,fd,err,err_str)
  if result == -1 then
    loge("locked by another process")
    posix_unistd.close(fd)
    return
  end

  -- Do something with file while it's locked
  result = pcall_wrapper(callback_)

  -- Release the lock
  lock.l_type = posix_fcntl.F_UNLCK
  _,err,err_str = posix_fcntl.fcntl(fd, posix_fcntl.F_SETLK, lock)
  logi("posix_lock released",lock_file_,result,fd,err,err_str)
  posix_unistd.close(fd)
  return result
end

function noblock_wait_for_children()
  if posix_sys_wait then
    posix_sys_wait.wait(-1,posix_sys_wait.WNOHANG)
  end
end

function block_wait_for_children()
  if posix_sys_wait then
    posix_sys_wait.wait(-1,0)
  end
end


local use_stp = false
function pcall_wrapper(callback_)
  if not use_stp or not stp then
    return pcall(callback_)
  end
  return xpcall(function() return callback_() end ,use_stp and stp.stacktrace or nil)
end

function weak_hash(string_)
  -- this is used to tell whether two strings contain the same chars, i.e. compare them regardless of chars positions
  local c = 0
  local byte = string.byte
  string.gsub(string_,"(.)",
              function (x)
                c = c + byte(x)
  end)
  return c
end

function first_file(glob_pattern_)
  local files = posix_glob and posix_glob.glob(glob_pattern_)
  return files and files[1]
end

-- sparse sequences are expected to have very few (usually one) non empty slots, so we use
-- a plain (non sorted) array
function parse_name(name_)
  local metric,step,period = string.match(name_,"^(.+);(%w+):(%w+)$")
  step = parse_time_unit(step)
  period = parse_time_unit(period)
  return metric,step,period
end

function sparse_sequence(name_,slots_)
  local _metric,_step,_period
  local _slots = slots_ or {}
  local _latest_timestamp
  local _type

  _metric,_step,_period = parse_name(name_)

  -- we need to update the latest timestamp
  if slots_ then
    for i,s in ipairs(_slots) do
      _latest_timestamp = math.max(_latest_timestamp or 0,s._timestamp)
    end
  end

  local function update_latest(timestamp_)
    if not _latest_timestamp or _latest_timestamp<timestamp_ then
      _latest_timestamp = timestamp_
    end
  end

  local function add_slot(timestamp_,idx_)
    local s = { _timestamp = timestamp_, _hits = 0, _sum = 0, _idx = idx_}
    table.insert(_slots,1,s)
    update_latest(timestamp_)
    return s
  end

  local function find_slot(timestamp_)
    for i,s in ipairs(_slots) do
      if s._timestamp==timestamp_ then return s end
    end
    return add_slot(timestamp_)
  end

  local function find_by_index(idx_)
    -- there is only one timestamp that fits the index
    for _,s in ipairs(_slots) do
      local i = s._idx
      if not i then
        i,_ = calculate_idx(s._timestamp,_step,_period)
        s._idx = i
      end
      if i==idx_ then
        return s
      end
    end
    return nil
  end

  local function calc_idx(timestamp_)
    local idx,adjusted_timestamp = calculate_idx(timestamp_,_step,_period)

    -- we if the adjusted timestamp is too old, we can ignore it
    if _latest_timestamp and adjusted_timestamp<=_latest_timestamp-_period then
      return nil
    end
    return idx,adjusted_timestamp
  end

  local function set(timestamp_,hits_,sum_)
    local idx,adjusted_timestamp = calc_idx(timestamp_)

    if not idx then
      return nil
    end
    local slot = find_by_index(idx) or add_slot(adjusted_timestamp,idx)
    slot._sum = sum_
    slot._hits = hits_
    slot._timestamp = adjusted_timestamp
    update_latest(adjusted_timestamp)
    return adjusted_timestamp,slot._sum
  end

  local function update(timestamp_,hits_,sum_,type_)
    local idx,adjusted_timestamp = calc_idx(timestamp_)
    if not idx then
      return nil
    end
    local slot = find_slot(adjusted_timestamp)
    if type_ then
      if type_=='=' then
        slot._sum = sum_
      elseif type_=='^' then
        slot._sum = math.max(sum_,slot._sum)
      elseif type_=='_' then
        slot._sum = slot._hits==0 and sum_ or math.min(sum_,slot._sum)
      end
      slot._type = type_
      slot._hits = slot._hits+hits_
    else
      slot._sum = slot._sum+sum_
      slot._hits = slot._hits+hits_
    end
    update_latest(adjusted_timestamp)
    return adjusted_timestamp,slot._sum
  end

  return {
    set = set,
    update = update,
    find_by_index = find_by_index,
    latest_timestamp = function() return _latest_timestamp end,
    slots = function() return _slots end,
    metric = function() return _metric end
  }
end

function count_dots(string_)
  local dots = 0
  string.gsub(string_,"%.",function() dots = dots + 1 end)
  return dots
end

function random_table_region(table_,region_size_,table_size_)
  local size = table_size_ or table_size(table_)
  local st = 1
  local en = size
  if en==0 then
    return size
  end

  -- why bother with randomness? to avoid starvation
  if region_size_ and en>region_size_ then
    st = math.random(math.max(en-region_size_,1))
    en = st+region_size_
  end
  return size,st,en
  --return (next(table_)~=nil and 1 or 0),1,region_size_ or table_size(table_)
end

function every_nth_call(n_,callback_)
  local counter = 0

  return
    function()
      counter = counter + 1
      if counter%n_==0 then
        callback_(counter)
      end
    end
end

function delete_keys(table_,keys_)
  for _,k in ipairs(keys_) do
    table_[k] = nil
  end
end

function string_len(str_)
  return str_~=nil and #tostring(str_) or "nil"
end

function distinct_prefixes(array_)
  if not array_ then return nil end
  local prefixes = {}
  local last
  local insert = table.insert
  table.sort(array_)
  for i,v in ipairs(array_) do
    if not last or string.find(v,last,1,true)~=1 then
      insert(prefixes,v)
    end
    last = v
  end
  return prefixes
end

function arrays_equal(rhs_,lhs_)
  if not rhs_ and not lhs_ then return true end
  if not rhs_ or not lhs_ then return false end
  if #rhs_~=#lhs_ then return false end
  for i,v in ipairs(rhs_) do
    if v~=lhs_[i] then return false end
  end
  return true
end

function special_key(key_)
  local find = string.find
  return 1==find(key_,"metadata=",1,true) or 1==find(key_,"kvs=",1,true)
end

function test_directory()
  return IN_SLASH_TMP and "/tmp/mule_tests/" or "./tests/temp/"
end

function create_test_directory(name_)
  local dir = test_directory()..name_
  os.execute("rm -rf "..dir)
  os.execute("mkdir -p "..dir)
  return dir
end

function clean_test_file(file_)
  local f = (IN_SLASH_TMP and "/tmp/mule_tests/" or "./tests/temp/")..file_
  os.remove(f)
  return f
end

-- adapted from http://rosettacode.org/wiki/Binary_search#Lua but changed to return the item <= value
function binarySearch (list,value)
  local low = 1
  local high = #list
  local mid = 0
  while low <= high do
    mid = math.floor((low+high)/2)
    if list[mid] > value then high = mid - 1
    else if list[mid] < value then low = mid + 1
         else return mid
         end
    end
  end
  return low-1
end

local lua_version_number_memo
function lua_version_number()
  if not lua_version_number_memo then
    lua_version_number_memo = string.gsub(_VERSION,"Lua ","")
  end

  return lua_version_number_memo
end

function simple_cache(capacity_,page_size_,no_overflow_permitted_)
  local num_keys = 0
  local cache = {}
  local pages = {} -- array of pages of items. Fast to remove a
  page_size_ = page_size_ or UPDATE_AMOUNT

  local function key_value_list(start_,end_)
    local ks = {}
    local insert = table.insert

    for k,v in pairs(cache) do
      if start_ then
        start_ = start_-1
      end
      if not start_ or start_<=0 then
        insert(ks,k)
      end
      if end_ then
        end_ = end_ - 1
        if end_==0 then return ks end
      end
    end
    return ks
  end

  local function out(k)
    if cache[k] then
      -- note that the key is NOT extracted from the pages
      cache[k] = nil
      num_keys = num_keys - 1
    end
  end

  local function add_to_pages(key_)
    local page = pages[#pages]
    if not page or #page==page_size_ then
      table.insert(pages,{})
      page = pages[#pages]
    end
    table.insert(page,key_)
  end

  local function pop_page()
    local p = table.remove(pages,1)
    -- num_keys will be update when the key is removed
    return p
  end

  return {
    get = function(k)
      return cache[k]
    end,

    out = out,

    set = function(k,v)
      local overflow = false
      if num_keys==capacity_ then
        logw("simple_cache overflow",k)
        overflow = true
      end
      if overflow and no_overflow_permitted_ then
        out(next(cache))
      end

      if not cache[k] then
        num_keys = num_keys + 1
        add_to_pages(k)
      end
      cache[k] = v
      return overflow
    end,

    size = function() return num_keys end,

    keys = key_value_list,

    num_pages = function()
      return #pages
    end,
    pop_page = pop_page,

    flush = function()
      cache = {}
      num_keys = 0
      pages = {}
    end
  }
end

function array_contains(array_,element_)
  if not array_ then return false end
  for _,a in ipairs(array_) do
    if a==element_ then return true end
  end
  return false
end

function now_ms()
  local now = posix_time.gettimeofday()
  return now.tv_sec+now.tv_usec/1000000
end
