local MathUtils = require("GUIAPI/utils/MathUtils")
  local lerp = MathUtils.lerp
local MetaUtils = require("GUIAPI/utils/MetaUtils")
local Vector2 = require("GUIAPI/datatype/Vector2")
local UDim = require("GUIAPI/datatype/UDim")


local UDim2, UDim2_meta = MetaUtils.newSelfIndexedMetatable()
local UDim2_objMeta = MetaUtils.newSelfIndexedTable()

local function new_fromDim(x, y)
  local obj = {}
  setmetatable(obj, UDim2_objMeta)

  obj.x = x
  obj.y = y

  return obj
end

local function new_fromNumbers(xs, xo, ys, yo)
  return new_fromDim(
    UDim(xs, xo),
    UDim(ys, yo)
  )
end

function UDim2_meta.new(...)
  local args = {...}
  if #args == 0 then
    return new_fromNumbers(0, 0, 0, 0)
  elseif #args == 2 then
    return new_fromDim(args[1], args[2])
  elseif #args == 4 then
    return new_fromNumbers(args[1], args[2], args[3], args[4])
  end
end

function UDim2_meta.fromScale(xScale, yScale)
  return new_fromNumbers(xScale, 0, yScale, 0)
end

function UDim2_meta.fromOffset(xOffset, yOffset)
  return new_fromNumbers(0, xOffset, 0, yOffset)
end
UDim2_meta.__call = MetaUtils.static(UDim2_meta.new)

local function lerp_UDim(obj1, obj2, a, target)
  if target == nil then
    lerp_UDim(obj1, obj2, a, UDim2_meta.new())
  end

  target.scale = lerp(obj1.scale, obj2.scale, a)
  target.offset = lerp(obj1.offset, obj2.offset, a)

  return target
end

function UDim2_meta.lerp(obj1, obj2, a, target)
  if target == nil then
    UDim2_meta.lerp(obj1, obj2, a, UDim2_meta.new())
  end

  lerp_UDim(obj1.x, obj2.x, a, target.x)
  lerp_UDim(obj1.y, obj2.y, a, target.y)

  return target
end
UDim2_objMeta.lerp = UDim2_meta.lerp

function UDim2_meta.add(obj1, obj2, target)
  if target == nil then
    return UDim2_meta.add(obj1, obj2, UDim2.new())
  end

  target.x = obj1.x + obj2.x
  target.y = obj1.y + obj2.y

  return target
end
UDim2_objMeta.__add = UDim2_meta.add

function UDim2_meta.sub(obj1, obj2, target)
  if target == nil then
    return UDim2_meta.sub(obj1, obj2, UDim2.new())
  end

  target.x = obj1.x - obj2.x
  target.y = obj1.y - obj2.y

  return target
end
UDim2_objMeta.__sub = UDim2_meta.sub

function UDim2_meta.equal(obj1, obj2)
  return obj1.x == obj2.x and obj1.y == obj2.y
end
UDim2_objMeta.__eq = UDim2_meta.equal

function UDim2_meta.tostring(obj)
  return "(" .. tostring(obj.x) .. "), (" .. tostring(obj.y) .. ")"
end
UDim2_objMeta.tostring = UDim2_meta.tostring

function UDim2_meta.getScaleVector(obj)
  return Vector2(
    obj.x.scale,
    obj.y.scale
  )
end
UDim2_objMeta.getScaleVector = UDim2_meta.getScaleVector

function UDim2_meta.getOffsetVector(obj)
  return Vector2(
    obj.x.offset,
    obj.y.offset
  )
end
UDim2_objMeta.getOffsetVector = UDim2_meta.getOffsetVector

return UDim2