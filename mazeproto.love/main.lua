character_lib = require('character')
Character = character_lib.Character

function love.load()
    characters = {Character({color = {255, 0, 0, 255},
                             keys = {'w', 's', 'a', 'd'}}),
                  Character({color = {0, 0, 255, 255},
                             keys = {'i', 'k', 'j', 'l'}})}
end

function love.update(dt)
    for k,v in pairs(characters) do
        v:update()
    end
end

function love.draw()
    for k,v in pairs(characters) do
        v:draw()
    end
end
