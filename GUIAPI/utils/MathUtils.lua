local MathUtils = {}

function MathUtils.lerp(x, y, a)
  return x + a * (y - x)
end

function MathUtils.inRange(x, min, max, t)
  if t == nil or t == 1 then
    return min < x and x < max
  elseif t == 2 then
    return min <= x and x < max
  elseif t == 3 then
    return min < x and x <= max
  elseif t == 4 then
    return min <= x and x <= max
  end
  return true
end

function MathUtils.map(x, iMin, iMax, oMin, oMax)
  return (x - iMin) * (oMax - oMin) / (iMax - iMin)
end

function MathUtils.round(x)
  return math.floor(x + 0.5)
end

return MathUtils