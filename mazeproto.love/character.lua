-- Private functions
local function clampDirection(direction)
    local circle = math.pi*2.0
    if direction > circle then
        return direction - circle
    elseif direction < 0.0 then
        return direction + circle
    end
    return direction
end

local function movementVector(self)
    return self.speed * math.cos(self.facing), self.speed * math.sin(self.facing)
end

local function randomInRange(start, stop)
    local size = stop-start
    return start + math.random(size)
end

-- The Character class
local Character = {}
Character.__index = Character

setmetatable(Character, {
    __call = function (cls, ...) return cls.new(...) end
})

local movementFunctions = {'forward', 'backward', 'rotateLeft', 'rotateRight'}

function Character.new(tab)
    local self = setmetatable({}, Character)
    local width, height = love.window.getDimensions()
    self.x = randomInRange(-100, 100)
    self.y = randomInRange(-100, 100)
    self.facing = math.pi / 2.0
    self.speed = 1.0
    self.keys = tab.keys
    self.color = tab.color
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
    love.graphics.setColor(self.color)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(-self.facing)
    love.graphics.scale(10.0, 10.0)
    love.graphics.polygon("fill", 1.0, 0.0, -0.5, 0.866025, -0.5, -0.866025)
    love.graphics.pop()
end

function Character:forward()
    local dX, dY = movementVector(self)
    self.x = self.x + dX
    self.y = self.y - dY
end

function Character:backward()
    local dX, dY = movementVector(self)
    self.x = self.x - dX
    self.y = self.y + dY
end

function Character:rotateLeft()
    self.facing = clampDirection(self.facing + math.pi/128.0)
end

function Character:rotateRight()
    self.facing = clampDirection(self.facing - math.pi/128.0)
end


return {
    Character = Character,
}