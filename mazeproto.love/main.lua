character = require('character')
rules = require('rules')

local characters, ruler

function love.load()
    characters = {character.Character({color = {255, 0, 0, 255},
                                       keys = {'w', 's', 'a', 'd'}}),
                  character.Character({color = {0, 0, 255, 255},
                                       keys = {'up', 'down', 'left', 'right'}})}
    ruler = rules.Ruler(characters)
end

function love.update(dt)
    for k,v in pairs(characters) do
        v:update()
    end
    ruler:update()
end

function love.draw()
    local width, height = love.window.getDimensions()

    love.graphics.push()
    love.graphics.translate(width/2.0, height/2.0)
    for k,v in pairs(characters) do
        v:draw()
    end
    love.graphics.pop()
end
