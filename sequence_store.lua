local pp = require "purepack"
require "helpers"

function sequence_storage(db_,name_,numslots_)
  local _data = nil

  local function internal_get_slot(idx_,offset_)
    return get_slot(_data,idx_,offset_)
  end


  local function internal_set_slot(idx_,offset_,a_,b_,c_)
    local a,b,c = set_slot(_data,idx_,offset_,a_,b_,c_)
    _data = pp.concat_three_strings(a,b,c)
  end

  local function save()
    db_.put(name_,_data)
  end

  local function cache()
    db_.cache()
  end

  local function reset()
    _data = string.rep(pp.to_binary(0),3*numslots_+1)
    return _data
  end


  _data = db_.get(name_) or reset()

  return {
    get_slot = internal_get_slot,
    set_slot = internal_set_slot,
    save = save,
    cache = cache,
    reset = reset
         }
end
