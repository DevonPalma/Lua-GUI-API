local MathUtils = require("GUIAPI/utils/MathUtils")
  local lerp = MathUtils.lerp
local MetaUtils = require("GUIAPI/utils/MetaUtils")
local Vector2 = require("GUIAPI/datatype/Vector2")
local UDim = require("GUIAPI/datatype/UDim")




local UDim2, UDim2_meta = MetaUtils.newSelfIndexedMetatable()
local UDim2_objMeta = MetaUtils.newSelfIndexedTable()

-----------------
-- Constructor --
-----------------

-- private default constructor to create a UDim2 from two UDims
local function new_fromDim(xUDim, yUDim)
  local newUDim2 = {}
  setmetatable(newUDim2, UDim2_objMeta)

  newUDim2.x = xUDim
  newUDim2.y = yUDim

  return newUDim2
end

-- private alternative constructor to create a UDim2 from 4 numbers (2 scales and 2 offsets)
local function new_fromNumbers(xScale, xOffset, yScale, yOffset)
  return new_fromDim(
    UDim(xScale, xOffset),
    UDim(yScale, yOffset)
  )
end

-- chooses constructor from above based on # of args
-- if two args are provided, choose fromDim
-- if four args are provided, choose fromNumber
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

-- Creates a UDim2 with provided scales, offsets default to 0
function UDim2_meta.fromScale(xScale, yScale)
  return new_fromNumbers(xScale, 0, yScale, 0)
end

-- Creates a UDim2 with provided offsets, scales default to 0
function UDim2_meta.fromOffset(xOffset, yOffset)
  return new_fromNumbers(0, xOffset, 0, yOffset)
end

-- __call binding
UDim2_meta.__call = MetaUtils.static(UDim2_meta.new)

---------------------
-- End Constructor --
---------------------


-- Lerp
-- Private Function to Lerp two UDims together
local function lerp_UDim(UDimA, UDimB, alpha, UDimT)
  if UDimT == nil then
    lerp_UDim(UDimA, UDimB, alpha, UDim2_meta.new())
  end

  UDimT.scale = lerp(UDimA.scale, UDimB.scale, alpha)
  UDimT.offset = lerp(UDimA.offset, UDimB.offset, alpha)

  return UDimT
end

-- Public function to lerp two UDim2s together
function UDim2_meta.lerp(UDim2A, UDim2B, alpha, UDim2T)
  if UDim2T == nil then
    UDim2_meta.lerp(UDim2A, UDim2B, alpha, UDim2_meta.new())
  end

  lerp_UDim(UDim2A.x, UDim2B.x, UDim2T.x)
  lerp_UDim(UDim2A.y, UDim2B.y, UDim2T.y)

  return UDim2T
end

UDim2_objMeta.lerp = UDim2_meta.lerp




-- Adding 2 UDim2 Objects (UDim2 + UDim2)
function UDim2_meta.add(UDim2A, UDim2B, UDim2T)
  if UDim2T == nil then
    return UDim2_meta.add(UDim2A, UDim2B, UDim2.new())
  end

  UDim2T.x = UDim2A.x + UDim2B.x
  UDim2T.y = UDim2A.y + UDim2B.y

  return UDim2T
end

UDim2_objMeta.__add = UDim2_meta.add


-- Subtracting 2 UDim2 Objects (UDim2 - UDim2)
function UDim2_meta.sub(UDim2A, UDim2B, UDim2T)
  if UDim2T == nil then
    return UDim2_meta.sub(UDim2A, UDim2B, UDim2.new())
  end

  UDim2T.x = UDim2A.x - UDim2B.x
  UDim2T.y = UDim2A.y - UDim2B.y

  return UDim2T
end

UDim2_objMeta.__sub = UDim2_meta.sub


-- Checking if 2 UDim2 objects are equal

function UDim2_meta.equal(UDim2A, UDim2B)
  return UDim2A.x == UDim2B.x and UDim2A.y == UDim2B.y
end

UDim2_objMeta.__eq = UDim2_meta.equal


-- UDim2 to string
function UDim2_meta.tostring(UDim2A)
  return "(" .. tostring(UDim2A.x) .. "), (" .. tostring(UDim2A.y) .. ")"
end

UDim2_objMeta.tostring = UDim2_meta.tostring





function UDim2_meta.getScaleVector(UDim2A)
  return Vector2(
    UDim2A.x.scale,
    UDim2A.y.scale
  )
end
UDim2_objMeta.getScaleVector = UDim2_meta.getScaleVector

function UDim2_meta.getOffsetVector(UDim2A)
  return Vector2(
    UDim2A.x.offset,
    UDim2A.y.offset
  )
end
UDim2_objMeta.getOffsetVector = UDim2_meta.getOffsetVector



return UDim2