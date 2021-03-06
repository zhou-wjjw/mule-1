local l = require "lightning_mdb"
require "tests.strict"
local lunit = require "lunit"
if _VERSION >= 'Lua 5.2' then
  _ENV = lunit.module('test_lightning_mdb','seeall')
else
  module( "test_lightning_mdb", lunit.testcase,package.seeall )
end
require "helpers"

local function lightning_mdb_factory(name_,num_pages_)
  local dir = create_test_directory(name_.."_mdb")
  return l.lightning_mdb(dir,false,num_pages_)
end

function test_meta()
  local db = lightning_mdb_factory("l_meta")
  db.set_increment(function() end)
  db.put("metadata=hello","cruel world")
  assert_equal("cruel world",db.get("metadata=hello"))
  assert_nil(db.get("hello"))

  for k in db.matching_keys("metadata=hello",1,true) do
    assert_equal("metadata=hello",k)
    local v = db.get(k)
    assert_equal("cruel world",v)
  end
  db.del("metadata=hello")
  assert_nil(db.get("metadata=hello"))

  for k,v in db.matching_keys("metadata=hello",1,true) do
    -- this will fail
    assert_not_nil(k)
  end

end

function test_payload()
  local function helper(num_pages_,count_,index_)
    local db = lightning_mdb_factory("l_payload."..index_,num_pages_)
    db.set_increment(function() end)
    for i=1,count_ do
      db.put(tostring(i),tostring(i))
    end
    for i=1,count_ do
      local k = tostring(i)
      assert_equal(k,db.get(k),index_)
      db.del(k)
      assert_nil(db.get(k),index_)
    end
    for i=1,count_ do
      assert_nil(db.get(tostring(i)),index_)
    end
  end

  -- for some reason less than 7 pages won't suffice
  helper(7,1,1)
  helper(40,10,2)
  helper(40,200,3)
  helper(40,2000,4)
end


function test_matchingkeys()
  local db = lightning_mdb_factory("l_matchingkeys")
  local count = 10

  db.set_increment(function() end)
  for i=count*2,0,-1 do
    db.native_put(string.format("%04d",i),i,true)
  end

  assert_equal("0000",db.search("000"))

  for _,prefix in ipairs({"000","001"}) do
    local num = 0
    local last_key = db.search(prefix)
    for i in db.matching_keys(prefix,1) do
      assert(last_key<=i,last_key)
      last_key = i
      num = num + 1
    end
    assert_equal(10,num,prefix)
  end
end

--verbose_log(true)
