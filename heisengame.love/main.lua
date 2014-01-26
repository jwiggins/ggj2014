local character = require('character')
local rules = require('rules')
local tileloader = require('sti')

local characters, ruler, map

-- GLOBALS --
drawGrid = 0
drawTerrain = 1

function love.load()
    characters = {character.Character({color = {255, 0, 0, 255},
                                       keys = {'w', 's', 'a', 'd'}}),
                  character.Character({color = {0, 0, 255, 255},
                                       keys = {'up', 'down', 'left', 'right'}})}
    ruler = rules.Ruler(characters)

    map = tileloader.new("maps/heisenberg")
    map:setCollisionMap("Collision")
    map.layers["Collision"].opacity = 0.0
end

function love.update(dt)
    for k,v in pairs(characters) do
        v:update(dt)
    end
    ruler:update(dt)
    map:update(dt)
end

function love.draw()
    local width, height = love.window.getDimensions()

    if drawTerrain == 1 then
        map:setDrawRange(0, 0, width, height)
        map:draw()
    end

    if drawGrid == 1 then
        map:drawCollisionMap()
    end

    love.graphics.push()
    love.graphics.translate(width/2.0, height/2.0)

    for k,v in pairs(characters) do
        v:drawSight()
    end
    for k,v in pairs(characters) do
        v:draw()
    end
    love.graphics.pop()

end
