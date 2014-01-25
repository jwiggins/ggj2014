-- Private movement functions
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

local moveFuctions = {upFunc, downFunc, leftFunc, rightFunc}

-- The Character class
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
    for index, code in pairs(keys) do
        if love.keyboard.isDown(code) then
            moveFuctions[index](self.data)
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


return {
    Character = Character,
}