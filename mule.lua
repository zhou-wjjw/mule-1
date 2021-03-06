require "helpers"
require "mulelib"
local c = require "column_db"
local _,l = pcall(require,"lightning_mdb")
require "httpd"
local posix_libgen = require "posix.libgen"
local posix_dirent = require "posix.dirent"
local posix_sys_stat = require "posix.sys.stat"
local p = require "purepack"

pcall(require, "profiler")

local _can_fork = true -- depending on the db type we may choose to disable forking

local function strip_slash(path_)
  return string.match(path_,"^(.-)/?$")
end

-- this should be in helpers but actually collides with helpers disabling posix for lunit's sake
function first_files(path_,pattern_,max_)
  local num = 0
  return coroutine.wrap(
    function()
      for f in posix_dirent.files(path_) do
        if num==max_ then return end
        if string.match(f,pattern_) then
          num = num+1
          coroutine.yield(path_.."/"..f)
        end
      end
    end)
end


local function guess_db(db_path_,readonly_)
  logd("guess_db",db_path_)
  -- strip a trailing / if it exists
  db_path_ = strip_slash(db_path_)
  p.set_pack_lib("lpack")
  if string.find(db_path_,"[_.]mdb$") then
    _can_fork = false
    return l.lightning_mdb(db_path_,readonly_)
  elseif string.find(db_path_,"[_.]cdb$") then
    return c.column_db(db_path_,readonly_)
  end
  loge("can't guess db",db_path_)
  return nil
end

local function new_mule(db_path_,readonly_)
  local db = guess_db(db_path_,readonly_)
  local ind = nil -- indexer(db_path_.."/fts.sqlite3")
  if not db then
    return
  end
  local m = mule(db,ind,readonly_)
  logi("loading",db_path_,readonly_ and "read" or "write")
  m.load()
  return m,db
end

local function safe_mule_call(m,db,callback_)
  local success,rv = pcall_wrapper(function() return callback_(m) end)
  if not success then
    loge("error",rv)
    db.close()
    return nil
  end
  return rv
end

local function save_and_close(m,db,readonly_)
  if not readonly_ then
    logi("saving")
    m.save()
    m.close()
  end
  logi("closing")
  db.close()
  block_wait_for_children()
  m = nil
end

local function with_mule(db_path_,readonly_,callback_)
  local m,db = new_mule(db_path_,readonly_)
  if not m then
    loge("failed to create mule",db_path_)
    return
  end
  local rv = safe_mule_call(m,db,callback_)
  save_and_close(m,db,readonly_)
  return rv
end

local function backup(db_path_)
  -- TODO for mdb use the internal backup option
  function helper()
    local db_path = strip_slash(db_path_)
    local bak = string.format("%s.bak.%s",db_path,os.date("%y%m%d-%H%M%S"))
    logi("starting to backup to",bak)
    os.execute(string.format("cp -r %s %s",db_path_,bak))
    logi("backup completed",bak)
    return bak
  end

  return helper
end

local function incoming_queue(db_path_,incoming_queue_path_)
  if not incoming_queue_path_ then
    return function() end
  end

  local executing = false
  local minute_dir = nil
  local processed = string.gsub(incoming_queue_path_,"incoming","processed")
  local failed = string.gsub(incoming_queue_path_,"incoming","failed")

  local function helper(m,count,step_callback_)
    if executing then return 0 end
    local now = time_now()
    local num_files = 0
    executing = true
    for file in first_files(incoming_queue_path_,"%.mule$",count) do
      pcall_wrapper(
        function()
          local sz = posix_sys_stat.stat(file).st_size
          if sz==0 then
            logi("empty file",file)
            os.remove(file)
            return
          end
          if sz>LARGE_FILE_SIZE then
            logi("large file",file,sz)
            new_name = string.format("%s/%s",failed,posix_libgen.basename(file))
            os.rename(file,new_name)
            return
          end
          num_files = num_files + 1
          logi("incoming_queue file",file,sz)
          -- we DON'T want to process commands as we get raw data files from the clients (so we hope)
          local n = now_ms()
          logi("processing",file)
          m.process(file,true,true,step_callback_)
          local cm = os.date("%y/%m/%d/%H/%M")
          if minute_dir~=cm then
            minute_dir = cm
            os.execute(string.format("mkdir -p %s/%s",processed,minute_dir))
          end
          new_name = string.gsub(string.format("%s/%s/%s",processed,minute_dir,posix_libgen.basename(file)),"//","/")
          os.rename(file,new_name)
          local delta = now_ms()-n
          logi("processed",new_name,string.format("%.3f",delta),
               string.format("%.1f",delta>0 and sz/delta or 0))
      end)
    end
    executing = false
    return num_files
  end
  return helper
end

local function fatal(msg_,out_)
  logf(msg_)
  out_.write(msg_)
end

local function usage()
  return [[
        -h (help) -v (verbose) -y profile -l <log-path> -d <db-path> [-c <cfg-file> (configure)] [-r (create)] [-f (force)] [-n <line>] [-w <writable>] [-t <address:port> (http daemon)] [-x (httpd stoppable)] [-R <static-files-root-path>] [-i <incoming-queue-path>] [-m <key-prefix> (write all lightningmdb keys)] [-a <key-prefix> (write all lightningmdb keys and values)] files....

      If -c is given the database is (re)created but if it exists, -f is required to prevent accidental overwrite. Otherwise load is performed.
      Files are processed in order
  ]]

end

function main(opts,out_)
  local read_only = true

  if opts["h"] then
    out_.write(usage())
    return true
  end

  if opts["v"] then
    verbose_log(true)
  end

  if opts["w"] then
    read_only = false
  end

  if opts.y then
    logd("starting profiler")
    profiler.start("profiler.out")
  end

  if opts["l"] then
    log_file(opts["l"])
  end

  if not opts["d"] then
    fatal("no database given. exiting",out_)
    return false
  end

  local function writable_mule(callback_)
    return with_mule(opts["d"],false,function(m) return callback_(m) end)
  end

  local function readonly_mule(callback_)
    return with_mule(opts["d"],true,function(m) return callback_(m) end)
  end

  local with_mule_wrapper = read_only and readonly_mule or writable_mule

  local db_exists = file_exists(opts["d"])
  if opts["r"] and db_exists and not opts["f"] then
    fatal("database exists and may be overwriten. use -f to force re-creation. exiting",out_)
    return false
  end

  if opts["r"] then
    logi("creating",opts["d"],"using configuration",opts["c"])
    local db = guess_db(opts["d"],false)
    if not db then
      logf("failed to create db")
      return
    end
    db:close()
  end


  if opts["c"] then
    logi("configure",opts["c"])
    local rv = with_mule_wrapper(
      function(m)
        return with_file(opts["c"],
                         function(f)
                           return m.configure(f:lines())
                         end
        )
      end
    )

    if not rv then
      loge("configure failed.")
      if not file_exists(opts["c"]) then
        loge("file does not exists ",opts["c"])
      end
      return
    end
  end

  if opts["t"] then
    logi("http daemon",opts["t"])
    local stopped = false
    local httpd_can_be_stopped = opts["x"]
    local m,db = new_mule(opts["d"],false)
    if not m then
      loge("failed to create mule",db_path_)
      return
    end

    http_loop(opts["t"],function(callback_) return safe_mule_call(m,db,callback_) end,
              backup(opts["d"]),
              incoming_queue(opts["d"],opts["i"]),
              function(token_)
                -- this is confusing: when the function is called with param we match
                -- it against the stop shared secret
                -- when it is called without a param we simply return the flag
                -- BUT we check that the stop functionality is supported at all
                stopped = stopped or httpd_can_be_stopped and token_==httpd_can_be_stopped
                if stopped then
                  logi("http stop",stopped)
                end
                return stopped
              end,
              opts["R"] and strip_slash(opts["R"]),
              _can_fork
             )
    save_and_close(m,db,false)
  end

  if opts["n"] then
    local rv = with_mule_wrapper(
      function(m)
        return m.process(opts["n"])
      end
    )
    out_.write(rv)
  end

  if opts["m"] or opts["a"] then
    local db = guess_db(opts["d"],true)
    if not db then
      logf("unable to guess db",db)
    else
      local function star(v_) return v_=="*" and "" or v_ end
      if opts["m"] then
        db.dump_keys(star(opts["m"]))
      elseif opts["a"] then
        db.dump_values(star(opts["a"]))
      end
      db:close()
    end
  end

  if opts["rest"] then
    with_mule_wrapper(
      function(m)
        for i,f in ipairs(opts["rest"]) do
          logi("processing",f)
          local rv = m.process(f,(i%100)>0) -- we update the DB every 100th file
          out_.write(rv)
        end
        while m.flush_cache() do
          -- nothing to do as update does all that we need
        end
    end)
  end

  if opts.y then
    logd("stopping profiler")
    profiler.stop()
  end

  return true
end


if not lunit then
  opts = getopt(arg,"ldcnmtxRiaw")
  local rv = main(opts,stdout("\n"))
  logd("done")
  os.exit(rv and 0 or -1)
end
