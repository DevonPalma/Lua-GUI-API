local MathUtils = require("GUIAPI/utils/MathUtils")
  local lerp = MathUtils.lerp
local MetaUtils = require("GUIAPI/utils/MetaUtils")


local Vector2, Vector2_meta = MetaUtils.newSelfIndexedMetatable()
local Vector2_objMeta = MetaUtils.newSelfIndexedTable()


local function new_fromCoord(x, y)
  local newVector2 = {}
  setmetatable(newVector2, Vector2_objMeta)

  newVector2.x = x
  newVector2.y = y

  return newVector2
end

function Vector2_meta.new(...)
  local args = {...}
  if #args == 0 then
    return new_fromCoord(0, 0)
  elseif #args == 2 then
    return new_fromCoord(args[1], args[2])
  end
end
Vector2_meta.__call = MetaUtils.static(Vector2_meta.new)


function Vector2_meta.lerp(V2A, V2B, alpha)
  return new_fromCoord(
    lerp(V2A.x, V2B.x, alpha),
    lerp(V2A.y, V2B.y, alpha)
  )
end
Vector2_objMeta.lerp = Vector2_meta.lerp


function Vector2_meta.dot(V2A, V2B)
  return V2A.x * V2B.x + V2A.y * V2B.y
end
Vector2_objMeta.dot = Vector2_meta.dot


function Vector2_meta.cross(V2A, V2B)
  return V2A.x * V2B.y - V2A.y * V2B.x
end
Vector2_objMeta.cross = Vector2_meta.cross


function Vector2_meta.add(V2A, V2B)
  return new_fromCoord(
    V2A.x + V2B.x,
    V2A.y + V2B.y
  )
end
Vector2_objMeta.add = Vector2_meta.add
Vector2_objMeta.__add = Vector2_meta.add


function Vector2_meta.sub(V2A, V2B)
  return new_fromCoord(
    V2A.x - V2B.x,
    V2A.y - V2B.y
  )
end
Vector2_objMeta.sub = Vector2_meta.sub
Vector2_objMeta.__sub = Vector2_meta.sub


local function vector_mult_vector(V2A, V2B)
  return new_fromCoord(
    V2A.x * V2B.x,
    V2A.y * V2B.y
  )
end
local function vector_mult_scalar(V2A, scalar)
  return new_fromCoord(
    V2A.x * scalar,
    V2A.y * scalar
  )
end

function Vector2_meta.mult(V2A, multer)
  if type(multer) == "number" then
    return vector_mult_scalar(V2A, multer)
  elseif type(multer) == "table" then
    return vector_mult_vector(V2A, multer)
  end
end
Vector2_objMeta.mult = Vector2_meta.mult
Vector2_objMeta.__mul = Vector2_meta.mult


local function vector_div_vector(V2A, V2B)
  return new_fromCoord(
    V2A.x / V2B.x,
    V2A.y / V2B.y
  )
end
local function vector_div_scalar(V2A, scalar)
  return new_fromCoord(
    V2A.x / scalar,
    V2A.y / scalar
  )
end

function Vector2_meta.div(V2A, divisor)
  if type(divisor) == "number" then
    return vector_div_scalar(V2A, divisor)
  elseif type(divisor) == "table" then
    return vector_div_vector(V2A, divisor)
  end
end
Vector2_objMeta.div = Vector2_meta.div
Vector2_objMeta.__div = Vector2_meta.div



function Vector2_meta.tostring(V2A)
  return V2A.x .. ", " .. V2A.y
end
Vector2_objMeta.__tostring = Vector2_meta.tostring


function Vector2_meta.floor(V2A, precision)
  if precision == nil or precision == 0 then
    return Vector2(
      math.floor(V2A.x),
      math.floor(V2A.y)
    )
  end

  local scale = math.exp(10, precision)
  return Vector2_meta.floor(V2A * scale) / scale
end
Vector2_objMeta.floor = Vector2_meta.floor


function Vector2_meta.round(V2A, precision)
  if precision == nil or precision == 0 then
    return Vector2(
      MathUtils.round(V2A.x),
      MathUtils.round(V2A.y)
    )
  end

  local scale = math.exp(10, precision)
  return Vector2_meta.floor(V2A * scale) / scale
end
Vector2_objMeta.round = Vector2_meta.round

return Vector2