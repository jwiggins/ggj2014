local utils = require("utils")
local rules = require("rules")

-- The Character class
local Character = {}
Character.__index = Character

setmetatable(Character, {
    __call = function (cls, ...) return cls.new(...) end
})

local movementFunctions = {'forward', 'backward', 'rotateLeft', 'rotateRight'}

function Character.new(tab)
    local self = setmetatable({}, Character)
    self.x = tab.x
    self.y = tab.y
    self.facing = -math.pi / 2.0
    self.speed = 1.25
    self.keys = tab.keys
    self.color = tab.color
    return self
end

function Character:update(dt)
    local keys = self.keys
    for index, code in pairs(keys) do
        if love.keyboard.isDown(code) then
            Character[movementFunctions[index]](self)
        end
    end
end

function Character:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.facing)
    love.graphics.scale(10.0, -10.0)
    love.graphics.setColor(self.color)
    love.graphics.polygon("fill", 1.0, 0.0, -0.5, 0.866025, 0.0, 0.0, -0.5, -0.866025)
    love.graphics.pop()
end

function Character:drawSight()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.facing)
    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.arc("fill", 0.0, 0.0, rules.sightDistance, rules.minAngle, rules.maxAngle)
    love.graphics.pop()
end

function Character:forward()
    local dX, dY = utils.angleToVector(self.facing, self.speed)
    self.x = self.x + dX
    self.y = self.y + dY
    self:stayInBounds()
end

function Character:backward()
    local dX, dY = utils.angleToVector(self.facing, self.speed)
    self.x = self.x - dX
    self.y = self.y - dY
    self:stayInBounds()
end

function Character:rotateLeft()
    self.facing = utils.clampAngle(self.facing - math.pi/128.0)
end

function Character:rotateRight()
    self.facing = utils.clampAngle(self.facing + math.pi/128.0)
end

function Character:stayInBounds()
    local width, height = love.graphics.getDimensions()
    self.x = utils.clampValue(self.x, 0.0, width)
    self.y = utils.clampValue(self.y, 0.0, height)
end

return {
    Character = Character,
}