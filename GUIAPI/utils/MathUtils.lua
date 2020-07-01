local MathUtils = {}

function MathUtils.lerp(x, y, a)
  return x + a * (y - x)
end

function MathUtils.inRange(x, rangeMin, rangeMax, rangeType)
  if rangeType == nil or rangeType == 1 then
    return rangeMin < x and x < rangeMax
  elseif rangeType == 2 then
    return rangeMin <= x and x < rangeMax
  elseif rangeType == 3 then
    return rangeMin < x and x <= rangeMax
  elseif rangeType == 4 then
    return rangeMin <= x and x <= rangeMax
  end
  return true
end


function MathUtils.map(x, inMin, inMax, outMin, outMax)
  return (x - inMin) * (outMax - outMin) / (inMax - inMin)
end


function MathUtils.round(x)
  return math.floor(x + 0.5)
end



return MathUtils