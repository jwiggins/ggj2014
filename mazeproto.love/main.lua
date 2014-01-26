character = require('character')
rules = require('rules')
tileloader = require('sti')

local characters, ruler

function love.load()
    characters = {character.Character({color = {255, 0, 0, 255},
                                       keys = {'w', 's', 'a', 'd'}}),
                  character.Character({color = {0, 0, 255, 255},
                                       keys = {'up', 'down', 'left', 'right'}})}
    ruler = rules.Ruler(characters)

    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    map = tileloader.new("maps/heisenberg")
end

function love.update(dt)
    for k,v in pairs(characters) do
        v:update()
    end
    ruler:update()
    map:update(dt)
end

function love.draw()
    local width, height = love.window.getDimensions()

    map:setDrawRange(0, 0, windowWidth, windowHeight)
    map:draw()

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
