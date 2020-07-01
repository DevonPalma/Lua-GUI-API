local MathUtils = require("GUIAPI/utils/MathUtils")
  local lerp = MathUtils.lerp
  local inRange = MathUtils.inRange
local MetaUtils = require("GUIAPI/utils/MetaUtils")



local Color3, Color3_meta = MetaUtils.newSelfIndexedMetatable()
local Color3_objMeta = MetaUtils.newSelfIndexedTable()

-----------------
-- Constructor --
-----------------

-- create a new Color3 object using R, G, B values
-- R, G, and B should be in range [0, 255]
local function new_fromRGB(r, g, b)
  assert(inRange(r, 0, 255, 4), "R Channel (" .. r .. ") not in range [0, 255]")
  assert(inRange(g, 0, 255, 4), "G Channel (" .. g .. ") not in range [0, 255]")
  assert(inRange(b, 0, 255, 4), "B Channel (" .. b .. ") not in range [0, 255]")

  local newColor3 = {}
  setmetatable(newColor3, Color3_objMeta)

  newColor3.r = math.floor(r)
  newColor3.g = math.floor(g)
  newColor3.b = math.floor(b)

  return newColor3
end

-- Create a new Color3 object using H, S, V values
-- H should be in range [0, 360]
-- S should be in range [0, 1]
-- V should be in range [0, 1]
local function new_fromHSV(hue, saturation, value)
  assert(inRange(hue, 0, 360, 4), "Hue (" .. hue .. ") not in range [0, 360]")
  assert(inRange(saturation, 0, 1, 4), "Saturation (" .. saturation .. ") not in range [0, 1]")
  assert(inRange(value, 0, 1, 4), "Value (" .. value .. ") not in range [0, 1]")
  local chroma = value * saturation
  local hue_ = hue / 60
  local X = chroma * (1 - math.abs(hue_ % 2 - 1))

  local r_, g_, b_
  if inRange(hue_, 0, 1, 4) then
    r_, g_, b_ = chroma, X, 0
  elseif inRange(hue_, 1, 2, 3) then
    r_, g_, b_ = X, chroma, 0
  elseif inRange(hue_, 2, 3, 3) then
    r_, g_, b_ = 0, chroma, X
  elseif inRange(hue_, 3, 4, 3) then
    r_, g_, b_ = 0, X, chroma
  elseif inRange(hue_, 4, 5, 3) then
    r_, g_, b_ = X, 0, chroma
  elseif inRange(hue_, 5, 6, 3) then
    r_, g_, b_ = chroma, 0, X
  end

  local m = value - chroma
  local function f(n) return math.floor((n + m) * 255) end
  return new_fromRGB(f(r_), f(g_), f(b_))
end

function Color3_meta.new(...)
  local args = {...}
  if #args == 0 then
    return new_fromRGB(0, 0, 0)
  elseif #args == 3 then
    return new_fromRGB(args[1], args[2], args[3])
  end
end

Color3_meta.__call = MetaUtils.static(Color3_meta.new)

Color3_meta.fromRGB = new_fromRGB
Color3_meta.fromHSV = new_fromHSV

---------------------
-- End Constructor --
---------------------


-- Convert Color3 to string
function Color3_meta.tostring(Color3A)
  return Color3A.r .. ", " .. Color3A.g .. ", " .. Color3A.b
end
Color3_objMeta.__tostring = Color3_meta.tostring


-- Lerp between two Color3 objects, alpha is 0 to 1
function Color3_meta.lerp(Color3A, Color3B, alpha, Color3T)
  if Color3T == nil then
    return Color3_meta.lerp(Color3A, Color3B, alpha, Color3_meta.new())
  end

  Color3T.r = lerp(Color3A.r, Color3B.r, alpha)
  Color3T.g = lerp(Color3A.g, Color3B.g, alpha)
  Color3T.b = lerp(Color3A.b, Color3B.b, alpha)
end

Color3_objMeta.lerp = Color3_meta.lerp

-- To HSV
function Color3_meta.toHSV(Color3A)
  local r_, g_, b_ = Color3A.r/255, Color3A.g/255, Color3A.b/255
  local c_max, c_min = math.max(r_, g_, b_), math.min(r_, g_, b_)
  local delta = c_max - c_min

  local hue
  if delta == 0 then
    hue = 0
  elseif c_max == r_ then
    hue = 60 * (((g_ - b_) / delta) % 6)
  elseif c_max == g_ then
    hue = 60 * (((b_ - r_) / delta) + 2)
  elseif c_max == b_ then
    hue = 60 * (((r_ - g_) / delta) + 4)
  end

  local saturation
  if c_max == 0 then
    saturation = 0
  else
    saturation = delta / c_max
  end

  local value = c_max

  return hue, saturation, value
end

Color3_objMeta.toHSV = Color3_meta.toHSV



function Color3_meta.toHex(Color3A)
  return Color3A.r * 0x10000 + Color3A.g * 0x100 + Color3A.b
end
Color3_objMeta.toHex = Color3_meta.toHex

return Color3