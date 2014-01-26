local utils = require("utils")

local rules = {}

-- Some constants that outside code might need.
rules.minAngle = (-math.pi/6.0)
rules.maxAngle = (math.pi/6.0)
rules.minSightDistance = 30
rules.maxSightDistance = 300
rules.goalTile = 19

-- Private functions
local function canSee(char, pos)
    -- Return true if char can see pos
    local xTowards = pos[1] - char.x
    local yTowards = pos[2] - char.y
    local dist = utils.length(xTowards, yTowards)
    local angle = math.atan2(utils.normalize(yTowards, xTowards))
    local angleDiff = utils.clampAngle(math.abs(angle-char.facing))

    return (dist <= rules.maxSightDistance and dist >= rules.minSightDistance
            and angleDiff <= rules.maxAngle and angleDiff >= rules.minAngle)
end

-- The Ruler class
rules.Ruler = {}
rules.Ruler.__index = rules.Ruler

setmetatable(rules.Ruler, {
    __call = function (cls, ...) return cls.new(...) end
})

function rules.Ruler.new(tab)
    local self = setmetatable({}, rules.Ruler)
    self.characters = tab.characters
    self.map = tab.map
    self.magic_tiles = tab.magic_tiles
    self.gameWon = false
    return self
end

function rules.Ruler:update(dt)
    local terrain = self.map.layers["Terrain"]
    local special_positions = self.magic_tiles:getSpecialPositions()
    local goals = 0
    for i, chr in pairs(self.characters) do
        local tx, ty = utils.screenToTileCoordinate(chr.x, chr.y)
        if ty > 0 and ty <= utils.tilesHeight and tx > 0 and tx <= utils.tilesWidth then
            if terrain.data[ty][tx] ~= nil and terrain.data[ty][tx].gid == rules.goalTile then
                goals = goals + 1
            end
        end
    end
    
    for i, pos in ipairs(special_positions) do
        local tile_seen = false
        for i, chr in pairs(self.characters) do
            if canSee(chr, pos) then
                tile_seen = true
            end
        end
        self.magic_tiles:setTileState(i, tile_seen)
    end

    if goals == #self.characters then
        self.gameWon = true
    end
end

return rules
