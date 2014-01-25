utils = require("utils")

-- Private functions
local function canSee(char1, char2)
    -- Return true if char1 can see char2
    local xTowards = char2.x - char1.x
    local yTowards = char2.y - char1.y
    local angle = math.atan2(utils.normalize(yTowards, xTowards))
    local angleDiff = utils.clampAngle(math.abs(angle-char1.facing))

    return angleDiff <= math.pi/4.0 and angleDiff >= -math.pi/4.0
end

-- The Rules class
local Rules = {}
Rules.__index = Rules

setmetatable(Rules, {
    __call = function (cls, ...) return cls.new(...) end
})

function Rules.new(tab)
    local self = setmetatable({}, Rules)
    self.characters = tab
    return self
end

function Rules:update()
    local char1 = self.characters[1]
    local char2 = self.characters[2]

    if canSee(char1, char2) then
        char2:unfreeze()
    else
        char2:freeze()
    end
    if canSee(char2, char1) then
        char1:unfreeze()
    else
        char1:freeze()
    end
end

return {
    Rules = Rules,
}