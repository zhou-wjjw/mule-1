local bit32_found,bit32 = pcall(require,"bit32")
local bit_found,bit = pcall(require,"bit")
local _,_ = pcall(require,"lightningmdb")

local nop = function() end

local M = {
  PNS = 4, -- Packed Number Size
  to_binary = nop,
  to_binary3 = nop,
  from_binary = nop,
  from_binary3 = nop,
  concat_three_strings = nop
}

local function set_pack_lib(lib_)
  local function helper()
    local bits_lib = (bit32_found and bit32) or (bit_found and bit)

    if lib_=="lpack" then
      if not bpack or not bunpack then
        return nil,"purepack - lpack not found"
      end

      M.to_binary = function(int_)
        return bpack(">I",int_)
      end

      M.to_binary3 = function(a_,b_,c_)
        return bpack(">III",a_,b_,c_)
      end

      M.from_binary = function(str_,s)
        local _,value = bunpack(str_,">I",s or 1)
        return value
      end

      M.from_binary3 = function(str_,s)
        local _,a,b,c = bunpack(str_,">III",s or 1)
        return a,b,c
      end

      M.concat_three_strings = function(a_,b_,c_)
        return bpack("AAA",a_ or "",b_ or "",c_ or "")
      end

      return true
    end

    if lib_=="bits" then
      if not bits_lib then
        return nil,"purepack - bits not found"
      end

      M.to_binary = function(int_)
        local sh = bits_lib.rshift
        local an = bits_lib.band
        local i = sh(int_,16)
        return string.char(an(sh(i,8),255),an(i,255),
                           an(sh(int_,8),255),an(int_,255))
      end

      M.to_binary3 = function(a_,b_,c_)
        local sh = bits_lib.rshift
        local an = bits_lib.band
        local i,j,k = sh(a_,16),sh(b_,16),sh(c_,16)

        return string.char(an(sh(i,8),255),an(i,255),an(sh(a_,8),255),an(a_,255),
                           an(sh(j,8),255),an(j,255),an(sh(b_,8),255),an(b_,255),
                           an(sh(k,8),255),an(k,255),an(sh(c_,8),255),an(c_,255)
                          )
      end

      M.from_binary = function(str_,s)
        s = s or 1
        local a,b,c,d = string.byte(str_,s,s+3)
        local sh = bits_lib.lshift
        return (d or 0) + (c and sh(c,8) or 0) + (b and sh(b,16) or 0) + (a and sh(a,24) or 0)
      end

      M.from_binary3 = function(str_,s)
        s = s or 1
        local a,b,c,d,e,f,g,h,i,j,k,l = string.byte(str_,s,s+11)
        local sh = bits_lib.lshift
        return (d or 0) + (c and sh(c,8) or 0) + (b and sh(b,16) or 0) + (a and sh(a,24) or 0),
        (h or 0) + (g and sh(g,8) or 0) + (f and sh(f,16) or 0) + (e and sh(e,24) or 0),
        (l or 0) + (k and sh(k,8) or 0) + (j and sh(j,16) or 0) + (i and sh(i,24) or 0)
      end

      M.concat_three_strings = function(a_,b_,c_)
        return table.concat({a_ or "",b_ or "",c_ or ""})
      end

      return true
    end

    if lib_=="purepack" then
      M.to_binary = function(int_)
        local fl = math.floor
        local i = fl(int_/65536)
        return string.char((i~=0 and fl(i/256)%256) or 0,
                           (i~=0 and i%256) or 0,
                           fl(int_/256)%256,
                           int_%256)
      end
      M.to_binary3 = function(a_,b_,c_)
        return M.to_binary(a_)..M.to_binary(b_)..M.to_binary(c_)
      end

      M.from_binary = function(str_,s)
        s = s or 1
        if not str_ then
          logi(s,"traceback",debug.traceback())
          return 0
        end

        local a,b,c,d = string.byte(str_,s,s+3)
        return (d or 0) +
          (c and c*256 or 0) +
          (b and b*65536 or 0) +
          (a and a*16777216 or 0)
      end

      M.from_binary3 = function(str_,s)
        s = s or 1
        return M.from_binary(str_,s),M.from_binary(str_,s+4),M.from_binary(str_,s+8)
      end

      M.concat_three_strings = function(a_,b_,c_)
        return table.concat({a_ or "",b_ or "",c_ or ""})
      end

      return true
    end
    return nil,"unknown lib"
  end

  local rv,err = helper()
  if not rv then
    loge("set_pack_lib - unable to load",lib_,err)
  end
  return rv
end

local END_OF_TABLE_MARK = "end.of.table.mark"

-- for some reason using coroutines rather than standard functions seems slightly
-- faster. Perhaps the profiler distorts the real picture ?
local function pack_helper(obj_,visited_,id_,out)
  local insert = table.insert
  local yield = coroutine.yield

  local push = coroutine.wrap(function(type,len,val)
                                while true do
                                  insert(out,type)
                                  insert(out,M.to_binary(len))
                                  if val then
                                    insert(out,val)
                                  end
                                  type,len,val = yield(true)
                                end
                              end)
  local literal = coroutine.wrap(
    function(lit_)
      while true do
        local t = type(lit_)
        if lit_==nil then -- nil and false are NOT the same thing
          insert(out,"l")
          lit_ = yield(true)
        elseif t=="string" then
          if not visited_[lit_] then
            push("s",#lit_,lit_)
            insert(out,M.to_binary(id_))
            visited_[lit_] = id_
            id_ = id_ + 1
          else
            push("r",visited_[lit_])
          end
          lit_ = yield(true)
        elseif t=="number" then
          push("i",lit_)
          lit_ = yield(true)
        elseif lit_==true or lit_==false then
          insert(out,lit_ and "T" or "F")
          lit_ = yield(true)
        else
          lit_ = yield(false)
        end
      end
    end)

  local function helper(o_)
    if not literal(o_) and type(o_)=="table" then
      push("t",id_)
      visited_[o_] = id_
      id_ = id_ + 1
      for k,v in pairs(o_) do
        if type(v)~="function" then
          literal(k)
          local _ = literal(v) or (visited_[v] and push("r",visited_[v])) or helper(v)
        end
      end
      insert(out,"e")
    end
  end

  helper(obj_)
end

local function pack(obj_)
  local out = {}
  pack_helper(obj_,{},0,out)
  return table.concat(out,"")
end

local function unpack_helper(str_,i,visited_)
  local s = string.sub(str_,i,i)
  local pns = M.PNS

  i = i + 1
  if s=="l" then
    return nil,i
  end

  if s=="s" then
    local len = M.from_binary(str_,i)
    local f = i+pns
    local e = f+len
    local str = string.sub(str_,f,e-1)
    local id = M.from_binary(str_,e)
    visited_[id] = str
    return str,e+pns
  end
  if s=="i" then
    return M.from_binary(str_,i),i+pns
  end
  if s=="r" then
    return visited_[M.from_binary(str_,i)],i+pns
  end
  if s=="T" or s=="F" then
    return s=="T",i
  end
  if s=="e" then
    return END_OF_TABLE_MARK,i
  end
  local e = #str_
  if s=="t" then
    local t = {}
    local k,v
    visited_[M.from_binary(str_,i)] = t
    i = i + pns
    repeat
      k,i = unpack_helper(str_,i,visited_)
      if k==END_OF_TABLE_MARK then
        return t,i
      end
      v,i = unpack_helper(str_,i,visited_)
      t[k] = v
    until i>=e
    return t,i
  end
end

local function unpack(str_)
  return str_ and unpack_helper(str_,1,{})
end

M.set_pack_lib = set_pack_lib
M.pack = pack
M.unpack = unpack

return M
