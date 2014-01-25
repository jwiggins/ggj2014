local Character = {}
Character.__index = Character

setmetatable(Character, {
    __call = function (cls, ...) return cls.new(...) end
})

function Character.new(init)
    local self = setmetatable({}, Character)
    self.data = init
    return self
end

function Character:update()
    local keys = self.data.keys
    for code, func in pairs(keys) do
        if love.keyboard.isDown(code) then
            func(self.data)
        end
    end
end

function Character:draw()
    local data = self.data
    local x = data.x
    local y = data.y
    love.graphics.setColor(data.color)
    love.graphics.rectangle("fill", x-10, y-10, 20, 20)
end


local function upFunc(data)
    data.y = data.y - 1
end
local function downFunc(data)
    data.y = data.y + 1
end
local function leftFunc(data)
    data.x = data.x - 1
end
local function rightFunc(data)
    data.x = data.x + 1
end

local characters = {Character({x = 0, y = 0, color = {255, 0, 0, 255},
                      keys={w = upFunc, s = downFunc, a = leftFunc, d = rightFunc}}),
                    Character({x = 0, y = 0, color = {0, 0, 255, 255},
                      keys={i = upFunc, k = downFunc, j = leftFunc, l = rightFunc}}),
                    Character({x = 0, y = 0, color = {0, 255, 0, 255},
                      keys={up = upFunc, down = downFunc, left = leftFunc, right = rightFunc}})}


function love.load()
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

function love.keypressed(key)
end

function love.keyreleased(key)
end
