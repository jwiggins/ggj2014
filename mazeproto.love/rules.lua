utils = require("utils")

local rules = {}

-- Some constants that outside code might need.
rules.minAngle = (-math.pi/6.0)
rules.maxAngle = (math.pi/6.0)
rules.sightDistance = 300

-- Private functions
local function canSee(char1, char2)
    -- Return true if char1 can see char2
    local xTowards = char2.x - char1.x
    local yTowards = char2.y - char1.y
    local dist = utils.length(xTowards, yTowards)
    local angle = math.atan2(utils.normalize(yTowards, xTowards))
    local angleDiff = utils.clampAngle(math.abs(angle-char1.facing))

    return (dist <= rules.sightDistance and angleDiff <= rules.maxAngle
            and angleDiff >= rules.minAngle)
end

-- The Ruler class
rules.Ruler = {}
rules.Ruler.__index = rules.Ruler

setmetatable(rules.Ruler, {
    __call = function (cls, ...) return cls.new(...) end
})

function rules.Ruler.new(tab)
    local self = setmetatable({}, rules.Ruler)
    self.characters = tab
    return self
end

function rules.Ruler:update()
end

return rules
