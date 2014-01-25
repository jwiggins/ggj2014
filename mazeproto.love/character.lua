-- Private movement functions
local function upFunc(self)
    self.y = self.y - 1
end
local function downFunc(self)
    self.y = self.y + 1
end
local function leftFunc(self)
    self.x = self.x - 1
end
local function rightFunc(self)
    self.x = self.x + 1
end

local moveFuctions = {upFunc, downFunc, leftFunc, rightFunc}

-- The Character class
local Character = {}
Character.__index = Character

setmetatable(Character, {
    __call = function (cls, ...) return cls.new(...) end
})

function Character.new(tab)
    local self = setmetatable({}, Character)
    self.x = tab.x
    self.y = tab.y
    self.keys = tab.keys
    self.color = tab.color
    return self
end

function Character:update()
    local keys = self.keys
    for index, code in pairs(keys) do
        if love.keyboard.isDown(code) then
            moveFuctions[index](self)
        end
    end
end

function Character:draw()
    local x = self.x
    local y = self.y
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", x-10, y-10, 20, 20)
end


return {
    Character = Character,
}