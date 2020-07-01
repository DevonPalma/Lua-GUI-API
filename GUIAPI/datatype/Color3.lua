local MathUtils = require("GUIAPI/utils/MathUtils")
  local lerp = MathUtils.lerp
  local inRange = MathUtils.inRange
local MetaUtils = require("GUIAPI/utils/MetaUtils")



local Color3, Color3_meta = MetaUtils.newSelfIndexedMetatable()
local Color3_objMeta = MetaUtils.newSelfIndexedTable()

local function new_fromRGB(r, g, b)
  assert(inRange(r, 0, 255, 4), "R Channel (" .. r .. ") not in range [0, 255]")
  assert(inRange(g, 0, 255, 4), "G Channel (" .. g .. ") not in range [0, 255]")
  assert(inRange(b, 0, 255, 4), "B Channel (" .. b .. ") not in range [0, 255]")

  local obj = {}
  setmetatable(obj, Color3_objMeta)

  obj.r = math.floor(r)
  obj.g = math.floor(g)
  obj.b = math.floor(b)

  return obj
end

local function new_fromHSV(h, s, v)
  assert(inRange(h, 0, 360, 4), "Hue (" .. h .. ") not in range [0, 360]")
  assert(inRange(s, 0, 1, 4), "Saturation (" .. s .. ") not in range [0, 1]")
  assert(inRange(v, 0, 1, 4), "Value (" .. v .. ") not in range [0, 1]")
  local c = v * s
  local h_ = h / 60
  local X = c * (1 - math.abs(h_ % 2 - 1))

  local r_, g_, b_
  if inRange(h_, 0, 1, 4) then
    r_, g_, b_ = c, X, 0
  elseif inRange(h_, 1, 2, 3) then
    r_, g_, b_ = X, c, 0
  elseif inRange(h_, 2, 3, 3) then
    r_, g_, b_ = 0, c, X
  elseif inRange(h_, 3, 4, 3) then
    r_, g_, b_ = 0, X, c
  elseif inRange(h_, 4, 5, 3) then
    r_, g_, b_ = X, 0, c
  elseif inRange(h_, 5, 6, 3) then
    r_, g_, b_ = c, 0, X
  end

  local m = v - c
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

function Color3_meta.tostring(obj)
  return obj.r .. ", " .. obj.g .. ", " .. obj.b
end
Color3_objMeta.__tostring = Color3_meta.tostring

function Color3_meta.lerp(obj, obj2, a, target)
  if target == nil then
    return Color3_meta.lerp(obj, obj2, a, Color3_meta.new())
  end

  target.r = lerp(obj.r, obj2.r, a)
  target.g = lerp(obj.g, obj2.g, a)
  target.b = lerp(obj.b, obj2.b, a)
end

Color3_objMeta.lerp = Color3_meta.lerp

function Color3_meta.toHSV(obj)
  local r_, g_, b_ = obj.r/255, obj.g/255, obj.b/255
  local c_max, c_min = math.max(r_, g_, b_), math.min(r_, g_, b_)
  local d = c_max - c_min

  local h
  if d == 0 then
    h = 0
  elseif c_max == r_ then
    h = 60 * (((g_ - b_) / d) % 6)
  elseif c_max == g_ then
    h = 60 * (((b_ - r_) / d) + 2)
  elseif c_max == b_ then
    h = 60 * (((r_ - g_) / d) + 4)
  end

  local s
  if c_max == 0 then
    s = 0
  else
    s = d / c_max
  end

  return h, s, c_max
end

Color3_objMeta.toHSV = Color3_meta.toHSV

function Color3_meta.toHex(obj)
  return obj.r * 0x10000 + obj.g * 0x100 + obj.b
end
Color3_objMeta.toHex = Color3_meta.toHex

return Color3