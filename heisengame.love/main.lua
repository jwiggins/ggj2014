local character = require('character')
local rules = require('rules')
local special = require('special_tiles')
local tileloader = require('sti')
local utils = require('utils')

local characters, ruler, map, magic_tiles

-- GLOBALS --
drawGrid = 0
drawTerrain = 1

function love.load()
    -- Load the map
    map = tileloader.new("maps/heisenberg")
    map:setCollisionMap("Collision")
    map.layers["Collision"].opacity = 0.0

    -- Create the characters
    local c1x, c1y = utils.tileToScreenCoordinate(1, 15)
    local c2x, c2y = utils.tileToScreenCoordinate(2, 15)
    characters = {
        character.Character({color = {255, 0, 0, 255},
                             keys = {'w', 's', 'a', 'd'},
                             x = c1x, y = c1y, map = map}),
        character.Character({color = {0, 0, 255, 255},
                             keys = {'up', 'down', 'left', 'right'},
                             x = c2x, y = c2y, map = map}),
    }

    magic_tiles = special.Special()

    -- Create the simulation
    ruler = rules.Ruler({characters = characters, map = map})
end

function love.update(dt)
    for k,v in pairs(characters) do
        v:update(dt)
    end
    ruler:update(dt)
    map:update(dt)
end

local function generateMask()
    for k,v in pairs(characters) do
        v:drawSightStencil()
    end
end

function love.draw()
    love.graphics.setStencil(generateMask)

    local width, height = love.window.getDimensions()

    if drawTerrain == 1 then
        map:setDrawRange(0, 0, width, height)
        map:draw()
    end

    if drawGrid == 1 then
        map:drawCollisionMap()
    end
    magic_tiles:draw()

    for k,v in pairs(characters) do
        v:drawSight()
    end
    for k,v in pairs(characters) do
        v:draw()
    end

    if ruler.gameWon then
        local textScale = 6
        local winText = "YOU WIN!!"
        local font = love.graphics.getFont()
        local strWidth = font:getWidth(winText) * textScale
        local strHeight = font:getHeight() * textScale
        love.graphics.print(winText, width/2 - strWidth/2, height/2 - strHeight/2, 0, textScale, textScale)
    end
end
