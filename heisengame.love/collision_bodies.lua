local utils = require("utils")
local rules = require("rules")

-- The Tile class
local Tile = {}
Tile.__index = Tile

setmetatable(Tile, {
    __call = function (cls, ...) return cls.new(...) end
})

function Tile.new(data)
    local self = setmetatable({}, Tile)
    self.x = data[1]
    self.y = data[2]
    self.tile = data[3]
    self.width = utils.tileSizeX
    self.height = utils.tileSizeY
    self.seen = false
    return self
end

-- The FOV class
local FOV = {}
FOV.__index = FOV

setmetatable(FOV, {
    __call = function (cls, ...) return cls.new(...) end
})

function FOV.new(character)
    local self = setmetatable({}, FOV)
    self.x = 0
    self.y = 0
    self.character = character

    -- love.physics.newPolygonShape takes a max of 8 points
    local angleSpread = rules.maxAngle - rules.minAngle
    local points = {0.0, 0.0}
    for i = 0, 6 do
        local angle = rules.minAngle + angleSpread*i/6
        local x, y = utils.angleToVector(angle, rules.maxSightDistance)
        table.insert(points, #points+1, x)
        table.insert(points, #points+1, y)
    end
    self.points = points
    return self
end

function FOV:collisionPoints()
    return self.points
end

return {
    Tile = Tile,
    FOV = FOV
}
