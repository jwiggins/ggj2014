local utils = {}

function utils.clampAngle(angle)
    local circle = math.pi*2.0
    if angle > math.pi then
        return angle - circle
    elseif angle < -math.pi then
        return angle + circle
    end
    return angle
end

function utils.normalize(x, y)
    local mag = math.sqrt(x*x + y*y)
    return x/mag, y/mag
end

function utils.randomInRange(start, stop)
    local size = stop-start
    return start + math.random(size)
end

return utils
