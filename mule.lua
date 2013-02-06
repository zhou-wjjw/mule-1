require "helpers"
require "mulelib"
require "tc_store"
require "migrations"
require "httpd"

pcall(require, "profiler")

if not tokyo then
  print("unable to load tokyocabinet or tokyotyrant. Aborting")
  os.exit(-1)
end

local function with_mule(db_path_,readonly_,callback_)
  local m = tc_mule()
  logi("loading",db_path_,readonly_ and "read" or "write")
  m.load(db_path_,readonly_)
  local success,rv = pcall(callback_,m)

  if not success then
    loge("error",rv)
    m.close()
    return nil
  end
  if not readonly_ then
    logi("saving",db_path_)
    m.save()
  end
  logi("closing",db_path_)
  m.close()
  return rv
end

local function backup(db_path_)
  function helper()
    local bak = string.format("%s.bak.%s",db_path_,os.date("%y%m%d-%H%M%S"))
    os.execute(string.format("cp %s %s",db_path_,bak))
    return bak
  end

  return helper
end

local function usage()
  return [[
        -h (help) -v (verbose) -y profile -l <log-path> -d <db-path> [-c (configure) <cfg-file>] [-r (create)] [-f (force)] [-n <line>] [-u <gc-timestamp> (dump; compatible with restore)] [-g <path|*> (graph)] [-p <path> (piechart)] [-k <path|*> (keys)] [-s <path|*> (slot)] [-a <path|*> (latest)] [-m <migrate_name>] [-t <host:port> (http daemon)] [-x (httpd stoppable)] [-e (extra params)] files....

      If -c is given the database is (re)created but if it exists, -f is required to prevent accidental overwrite. Otherwise load is performed.
      Files are processed in order
  ]]

end

function main(opts,out_)
  if opts["h"] then
    out_.write_string(usage())
    return true
  end

  if opts["v"] then
    verbose_log(true)
  end

  if opts["l"] then
    log_file(opts["l"])
  end

  if not opts["d"] then
    logf("no database given. exiting")
    return false
  end

  local function writable_mule(callback_)
    return with_mule(opts["d"],false,function(m) return callback_(m) end)
  end

  local function readonly_mule(callback_)
    return with_mule(opts["d"],true,function(m) return callback_(m) end)
  end

  if opts["t"] then
    logi("http daemon",opts["t"])
    local stopped = false
    local httpd_can_be_stopped = opts["x"]
    http_loop(opts["t"],writable_mule,
              backup(opts["d"]),
              function(token_)
                -- this is confusing: when the function is called with param we match
                -- it against the stop shared secret
                -- when it is called without a param we simply return the flag
                -- BUT we check that the stop functionality is supported at all
                stopped = stopped or httpd_can_be_stopped and token_==httpd_can_be_stopped
                return stopped
              end)
  end

  local db_exists = file_exists(opts["d"])

  if opts["r"] and db_exists and not opts["f"] then
    logf("database exists and may be overwriten. use -f to force re-creation. exiting")
    return false
  end

  if not opts["c"] and not db_exists then
    logf("database does not exist and no configuration is provided. existing")
    return false
  end

  if opts["m"] then
    if opts["m"]=="0to1" then
      migrate_0_to_1(opts["d"])
    end
    if opts["m"]=="1to2" then
      migrate_1_to_2(opts["d"])
    end
    return true
  end



  if opts["r"] then
    logi("creating",opts["d"],"using configuration",opts["r"])
    local m = tc_mule()
    m.create(opts["d"])
    m.close()
  end


  if opts["c"] then
    logi("configure",opts["c"])
    writable_mule(function(m)
                    return m.config_file(opts["c"])
                  end)
  end

  if opts["n"] then
    writable_mule(function(m)
                    return m.process(opts["n"])
                  end)
  end

  if opts["u"] then
    readonly_mule(function(m)
                    return m.dump("*",tonumber(opts["u"]))
                  end)
  end

  local function generic_process(opt_,command_)
    if not opts[opt_] then
      return false
    end
    readonly_mule(function(m)
                    local arg = string.match(opts[opt_] or "","^([^%?]+)")
                    local qs = string.match(opts[opt_],"?(.+)$") or ""
                    local rv = m.process({string.format(".%s %s %s",command_,arg or "*",qs)})
                    if rv then
                      out_.write_string(rv)
                    end
                  end)
    return true
  end

  generic_process("g","graph")
  generic_process("p","piechart")
  generic_process("k","keys")
  generic_process("s","slot")
  generic_process("a","latest")

  if opts["rest"] then
    writable_mule(function(m)
                    for _,f in ipairs(opts["rest"]) do
                      logi("processing",f)
                      m.process(f)
                    end
                  end)
  end

  return true
end


if not lunit then
  opts = getopt(arg,"ldcngksamotxpeuy")

  if opts.y then
    logd("starting profiler")
    profiler.start("profiler.out")
  end

  local rv = main(opts,stdout("\n"))

  if opts.y then
    logd("stopping profiler")
    profiler.stop()
  end

  os.exit(rv and 0 or -1)
end
