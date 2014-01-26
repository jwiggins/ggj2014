-- The Tile class
local Tile = {}
Tile.__index = Tile

setmetatable(Tile, {
    __call = function (cls, ...) return cls.new(...) end
})

function Tile.new()
    local self = setmetatable({}, Tile)
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
    self.seen = false
    return self
end

-- The FOV class
local FOV = {}
FOV.__index = FOV

setmetatable(FOV, {
    __call = function (cls, ...) return cls.new(...) end
})

function FOV.new()
    local self = setmetatable({}, FOV)
    self.x = 0
    self.y = 0
    self.points = {}
    return self
end

function FOV:collisionPoints()
    return self.points
end

return {
    Tile = Tile,
    FOV = FOV
}
