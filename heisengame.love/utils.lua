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


utils.tileSizeX = 40
utils.tileSizeY = 40
utils.tilesHeight = 15
utils.tilesWidth = 20

function utils.screenToTileCoordinate(x, y)
    local width, height = love.graphics.getDimensions()
    local tileX = math.floor(x / utils.tileSizeX)
    local tileY = math.floor(y / utils.tileSizeY)
    return tileX+1, tileY+1
end

function utils.tileToScreenCoordinate(x, y)
    -- return the center of the tile
    local screenX = math.floor((x-1) * utils.tileSizeX + utils.tileSizeX / 2)
    local screenY = math.floor((y-1) * utils.tileSizeY + utils.tileSizeY / 2)
    return screenX, screenY
end

return utils
