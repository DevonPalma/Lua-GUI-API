local MetaUtils = require("GUIAPI/utils/MetaUtils")

local UDim, UDim_meta = MetaUtils.newSelfIndexedMetatable()
local UDim_objMeta = MetaUtils.newSelfIndexedTable()

local function new_scale_offset(s, o)
  local obj = {}
  setmetatable(obj, UDim_objMeta)

  obj.scale = s
  obj.offset = o

  return obj
end

function UDim_meta.new(...)
  local args = {...}
  local argSize = #args
  if argSize == 0 then
    return new_scale_offset(0, 0)
  elseif argSize == 1 then
    return new_scale_offset(args[1], 0)
  elseif argSize == 2 then
    return new_scale_offset(args[1], args[2])
  else
    error("Invalid number of args " .. #args)
  end
end
UDim_meta.__call = MetaUtils.static(UDim_meta.new)

function UDim_meta.add(obj, obj2, target)
  if target == nil then
    return UDim_meta.add(obj, obj2, UDim.new())
  end

  target.scale = obj.scale + obj2.scale
  target.offset = obj.offset + obj2.offset

  return target
end
UDim_objMeta.__add = UDim_meta.add

function UDim_meta.sub(obj, obj2, target)
  if target == nil then
    return UDim_meta.sub(obj, obj2, UDim.new())
  end

  target.scale = obj.scale - obj2.scale
  target.offset = obj.offset - obj2.offset

  return target
end
UDim_objMeta.__sub = UDim_meta.sub

function UDim_meta.equal(obj, obj2)
  return obj.scale == obj2.scale and obj.offset == obj2.offset
end
UDim_objMeta.__eq = UDim_meta.equal

function UDim_meta.tostring(obj)
  return obj.scale .. ", " .. obj.offset
end
UDim_objMeta.__tostring = UDim_meta.tostring

return UDim