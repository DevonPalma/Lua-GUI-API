local MetaUtils = require("GUIAPI/utils/MetaUtils")

local UDim, UDim_meta = MetaUtils.newSelfIndexedMetatable()
local UDim_objMeta = MetaUtils.newSelfIndexedTable()


-- Constructor --
local function new_scale_offset(scale, offset)
  local newUDim = {}
  setmetatable(newUDim, UDim_objMeta)

  newUDim.scale = scale
  newUDim.offset = offset

  return newUDim
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

-- End Constructor --


-- Adding UDims
function UDim_meta.add(UDimA, UDimB, UDimT)
  if UDimT == nil then
    return UDim_meta.add(UDimA, UDimB, UDim.new())
  end

  UDimT.scale = UDimA.scale + UDimB.scale
  UDimT.offset = UDimA.offset + UDimB.offset

  return UDimT
end

UDim_objMeta.__add = UDim_meta.add


-- Subtracting UDims
function UDim_meta.sub(UDimA, UDimB, TargetUDim)
  if TargetUDim == nil then
    return UDim_meta.sub(UDimA, UDimB, UDim.new())
  end

  TargetUDim.scale = UDimA.scale - UDimB.scale
  TargetUDim.offset = UDimA.offset - UDimB.offset

  return TargetUDim
end

UDim_objMeta.__sub = UDim_meta.sub


-- Checking if UDims are equal
function UDim_meta.equal(UDimA, UDimB)
  return UDimA.scale == UDimB.scale and UDimA.offset == UDimB.offset
end

UDim_objMeta.__eq = UDim_meta.equal



-- convert UDim to a string
function UDim_meta.tostring(UDimA)
  return UDimA.scale .. ", " .. UDimA.offset
end

UDim_objMeta.__tostring = UDim_meta.tostring



return UDim