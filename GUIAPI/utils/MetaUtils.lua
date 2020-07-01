local MU = {}

function MU.newSelfIndexedTable(t)
  t = t or {}
  t.__index = t
  return t
end

function MU.newMetatable(t, o)
  if t == nil then
    t = {}
    return t, MU.newMetatable(t)
  end

  local meta = getmetatable(table)

  if meta == nil or o then
    meta = {}
    setmetatable(table, meta)
  end

  return meta
end

function MU.newSelfIndexedMetatable(t, o)
  if t == nil then
    t = {}
    return t, MU.newSelfIndexedMetatable(t)
  end
  local meta = MU.newMetatable(t, o)
  meta = MU.newSelfIndexedTable(meta)
  return meta
end


function MU.metatableToMetatable(t, m, o)
  local meta = getmetatable(t)
  if meta == nil then
    meta = {}
    setmetatable(table, meta)
  end

  for i, data in pairs(m) do
    local curDat = meta[i];
    if curDat == nil or o then
      meta[i] = data
    end
  end

  return table
end

function MU.static(func)
  return function(_, ...) return func(...) end
end


local MU_meta = MU.newSelfIndexedMetatable(MU, true)
MU_meta.__call = MU.static(MU.genMeta)

return MU