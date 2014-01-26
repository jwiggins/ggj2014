local utils = require("utils")

local specialData = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 6, 6, 6, 6},
    {6, 6, 6, 6, 6, 6, 6, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 6},
    {0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 6},
    {6, 0, 6, 0, 6, 0, 6, 0, 0, 6, 0, 0, 0, 6, 0, 0, 6, 0, 0, 6},
    {0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 6, 0, 0, 6, 0, 0, 6, 0, 0, 6},
    {0, 0, 0, 6, 0, 0, 0, 6, 6, 6, 6, 0, 0, 0, 6, 0, 6, 0, 0, 6},
    {0, 0, 0, 9, 0, 0, 0, 6, 0, 0, 0, 6, 6, 0, 0, 6, 6, 0, 0, 6},
    {0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 6},
    {0, 0, 0, 6, 0, 0, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 6, 0, 0, 6},
    {0, 0, 6, 6, 6, 0, 6, 6, 6, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 6},
    {0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 6, 6},
    {0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 6, 0, 0, 0, 0, 0},
    {0, 0, 0, 6, 6, 6, 6, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 0},
    {0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 0},
    {0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 6, 0, 0, 0, 0}
}

local special = {}

-- The Special class
special.Special = {}
special.Special.__index = special.Special

setmetatable(special.Special, {
    __call = function (cls, ...) return cls.new(...) end
})

function special.Special.new()
    local self = setmetatable({}, special.Special)
    self.data = specialData
    return self
end

function special.Special:draw()
    love.graphics.push()
    love.graphics.setColor(255, 0, 255, 128)
    for ty = 1, #self.data do
        for tx = 1, #self.data[ty] do
            if self.data[ty][tx] == 9 then
                local rx, ry = utils.tileToScreenCoordinate(tx, ty)
                love.graphics.circle("fill", rx, ry, 20, 10)
            end
        end
    end
    love.graphics.pop()
end

return special
