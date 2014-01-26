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

    special_positions = {}
    special_states = {}
    for ty = 1, #self.data do
        for tx = 1, #self.data[ty] do
            if self.data[ty][tx] == 9 then
                local rx, ry = utils.tileToScreenCoordinate(tx, ty)
                table.insert(special_positions, #special_positions+1, {rx, ry})
                table.insert(special_states, #special_states+1, false)
            end
        end
    end
    self.special_positions = special_positions
    self.special_states = special_states

    return self
end

function special.Special:getSpecialPositions()
    return self.special_positions
end

function special.Special:setTileState(index, state)
    self.special_states[index] = state
end

function special.Special:draw()
    love.graphics.push()
    love.graphics.setColor(255, 0, 255, 128)
    for i, pos in ipairs(self.special_positions) do
        if self.special_states[i] then
            love.graphics.circle("fill", pos[1], pos[2], 20, 10)
        end
    end
    love.graphics.pop()
end

return special
