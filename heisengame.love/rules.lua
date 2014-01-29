local collision_detector = require("collision_detector")
local utils = require("utils")

local rules = {}

-- Some constants that outside code might need.
rules.minAngle = (-math.pi/6.0)
rules.maxAngle = (math.pi/6.0)
rules.minSightDistance = 30
rules.maxSightDistance = 300
rules.goalTile = 19
rules.wallTile = 8

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

local function gatherCharacterFovs(characters)
    -- avoid a circular dependency
    local collision_bodies = require("collision_bodies")

    local characterFovs = {}
    for i, chr in ipairs(characters) do
        local body = collision_bodies.FOV(chr)
        table.insert(characterFovs, #characterFovs+1, body)
    end
    return characterFovs
end

local function gatherWallTiles(map)
    -- avoid a circular dependency
    local collision_bodies = require("collision_bodies")

    local wallTiles = {}
    local terrain = map.layers["Terrain"]
    for ty = 1, utils.tilesHeight do
        for tx = 1, utils.tilesWidth do
            if terrain.data[ty][tx] ~= nil then
                local tile = terrain.data[ty][tx]
                if tile.gid == rules.wallTile then
                    local x, y = utils.tileToScreenCoordinate(tx, ty)
                    local body = collision_bodies.Tile({x, y, tile})
                    table.insert(wallTiles, #wallTiles+1, body)
                end
            end
        end
    end
    return wallTiles
end

local function buildCollisionDetector(map, characters)
    local wallTiles = gatherWallTiles(map)
    local fovs = gatherCharacterFovs(characters)
    return collision_detector.CollisionDetector(wallTiles, fovs)
end


-- The Ruler class
local Ruler = class()
function Ruler:__init(tab)
    self.characters = tab.characters
    self.map = tab.map
    self.collision = buildCollisionDetector(self.map, self.characters)
    self.gameWon = false
end

function Ruler:update(dt)
    -- Update the collision detection
    self.collision:update(dt)

    -- Check for the goal condition
    local terrain = self.map.layers["Terrain"]
    local goals = 0
    for i, chr in pairs(self.characters) do
        local tx, ty = utils.screenToTileCoordinate(chr.x, chr.y)
        if ty > 0 and ty <= utils.tilesHeight and tx > 0 and tx <= utils.tilesWidth then
            if terrain.data[ty][tx] ~= nil and terrain.data[ty][tx].gid == rules.goalTile then
                goals = goals + 1
            end
        end
    end
    if goals == #self.characters then
        self.gameWon = true
    end
end

function Ruler:draw()
    local width, height = love.window.getDimensions()

    self.collision:draw()

    if self.gameWon then
        local textScale = 6
        local winText = "YOU WIN!!"
        local font = love.graphics.getFont()
        local strWidth = font:getWidth(winText) * textScale
        local strHeight = font:getHeight() * textScale
        love.graphics.setStencil(nil)
        love.graphics.print(winText, width/2 - strWidth/2, height/2 - strHeight/2,
                            0, textScale, textScale)
    end
end

rules.Ruler = Ruler
return rules
