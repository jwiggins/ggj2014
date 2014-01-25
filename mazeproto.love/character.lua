utils = require("utils")
rules = require("rules")

-- The Character class
local Character = {}
Character.__index = Character

setmetatable(Character, {
    __call = function (cls, ...) return cls.new(...) end
})

local movementFunctions = {'forward', 'backward', 'rotateLeft', 'rotateRight'}

function Character.new(tab)
    local self = setmetatable({}, Character)
    self.x = utils.randomInRange(-100, 100)
    self.y = utils.randomInRange(-100, 100)
    self.facing = math.pi / 2.0
    self.speed = 1.0
    self.keys = tab.keys
    self.color = tab.color
    self.frozen = false
    return self
end

function Character:update()
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
    self:drawSight()
    love.graphics.scale(10.0, -10.0)
    love.graphics.setColor(self.color)
    love.graphics.polygon("fill", 1.0, 0.0, -0.5, 0.866025, 0.0, 0.0, -0.5, -0.866025)
    love.graphics.pop()
end

function Character:drawSight()
    local angles = {rules.minAngle, rules.maxAngle}

    love.graphics.setColor(255, 255, 255, 255)
    for i, face in pairs(angles) do
        local x, y = utils.angleToVector(face, rules.sightDistance)
        love.graphics.line(0.0, 0.0, x, y)
    end
    love.graphics.arc("line", 0.0, 0.0, rules.sightDistance, rules.minAngle, rules.maxAngle)
end

function Character:forward()
    if not self.frozen then
        local dX, dY = utils.angleToVector(self.facing, self.speed)
        self.x = self.x + dX
        self.y = self.y + dY
    end
end

function Character:backward()
    if not self.frozen then
        local dX, dY = utils.angleToVector(self.facing, self.speed)
        self.x = self.x - dX
        self.y = self.y - dY
    end
end

function Character:rotateLeft()
    self.facing = utils.clampAngle(self.facing - math.pi/128.0)
end

function Character:rotateRight()
    self.facing = utils.clampAngle(self.facing + math.pi/128.0)
end

function Character:freeze()
    self.frozen = true
end

function Character:unfreeze()
    self.frozen = false
end



return {
    Character = Character,
}