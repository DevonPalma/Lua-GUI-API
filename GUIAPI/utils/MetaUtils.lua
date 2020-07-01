local MU = {}


-- creates a new table that __index's itself
function MU.newSelfIndexedTable(table)
  table = table or {}
  table.__index = table
  return table
end


-- Creates a new metatable for table arg
-- if table-arg is nil then creates a new table and returns it and its meta
-- if override is true then override any existing metatable
-- returns the new metatable (or if table-arg is nil returns table, metatable)
function MU.newMetatable(table, override)
  if table == nil then
    local newTable = {}
    return newTable, MU.newMetatable(newTable)
  end

  local curMeta = getmetatable(table)

  if curMeta == nil or override then
    curMeta = {}
    setmetatable(table, curMeta)
  end

  return curMeta
end

-- Creates a new metatable that __index's itself
-- if table-arg is nil then creates a new table and returns it and its meta
-- if override is true then override any existing metatable
-- returns the new metatable (or if table-arg is nil returns table, metatable)
function MU.newSelfIndexedMetatable(table, override)
  if table == nil then
    local newTable = {}
    return newTable, MU.newSelfIndexedMetatable(newTable)
  end
  local curMeta = MU.newMetatable(table, override)
  curMeta = MU.newSelfIndexedTable(curMeta)
  return curMeta
end


function MU.metatableToMetatable(table, metatable, override)
  local tableMeta = getmetatable(table)
  if tableMeta == nil then
    tableMeta = {}
    setmetatable(table, tableMeta)
  end

  for index, data in pairs(metatable) do
    local curDat = tableMeta[index];
    if curDat == nil or override then
      tableMeta[index] = data
    end
  end

  return table
end

-- A function wrapper to remove the first arg from a function
-- Usually used for __call to make it static
function MU.static(func)
  return function(self, ...) return func(...) end
end


local MU_meta = MU.newSelfIndexedMetatable(MU, true)
MU_meta.__call = MU.static(MU.genMeta)

return MU