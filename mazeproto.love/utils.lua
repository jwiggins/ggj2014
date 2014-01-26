local utils = {}

function utils.angleToVector(angle, mag)
    return mag * math.cos(angle), mag * math.sin(angle)
end

function utils.clampAngle(angle)
    local circle = math.pi*2.0
    if angle > math.pi then
        return angle - circle
    elseif angle < -math.pi then
        return angle + circle
    end
    return angle
end

function utils.clampValue(value, min, max)
    return math.min(math.max(value, min), max)
end

function utils.length(x, y)
    return math.sqrt(x*x + y*y)
end

function utils.normalize(x, y)
    local mag = utils.length(x, y)
    return x/mag, y/mag
end

function utils.randomInRange(start, stop)
    local size = stop-start
    return start + math.random(size)
end

return utils
