-- The CollisionDetector class
local CollisionDetector = {}
CollisionDetector.__index = CollisionDetector

setmetatable(CollisionDetector, {
    __call = function (cls, ...) return cls.new(...) end
})

function CollisionDetector.new(tiles, fovs)
    local self = setmetatable({}, CollisionDetector)
    self.tiles = tiles
    self.fovs = fovs
    self:initWorld()
    return self
end

function CollisionDetector:initWorld()
    -- No gravity or sleeping allowed!
    local world = love.physics.newWorld(0.0, 0.0, false)
    self:initTiles(world)
    self:initFovs(world)
    world:setCallbacks(world:contactBegan, world:contactEnded, nil, nil)
    self.world = world
end

function CollisionDetector:initTiles(world)
    local fixtures
    for i, t in pairs(self.tiles) do
        local body = love.physics.newBody(world, t.x, t.y, "static")
        local shape = love.physics.newRectangleShape(t.width, t.height)
        local fixture = love.physics.newFixture(body, shape, 0.0)
        fixture.setSensor(true)
        fixture.setUserData(t)
        fixtures.insert(#fixtures+1, fixture)
    end
    self.tile_fixtures = fixtures
end

function CollisionDetector:initFovs()
    local fixtures
    for i, f in pairs(self.fovs) do
        local body = love.physics.newBody(world, f.x, f.y, "dynamic")
        local shape = love.physics.newPolygonShape(f:collisionPoints())
        local fixture = love.physics.newFixture(body, shape, 0.0)
        fixture.setSensor(true)
        fixture.setUserData(f)
        fixtures.insert(#fixtures+1, fixture)
    end
    self.fov_fixtures = fixtures
end

function CollisionDetector:contactBegan(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()
    if type(data1) ~= type(data2) then
        for i, dat in ipairs({data1, data2}) do
            if dat.seen ~= nil then
                dat.seen = true
            end
        end
    end
end

function CollisionDetector:contactEnded(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()
    if type(data1) ~= type(data2) then
        for i, dat in ipairs({data1, data2}) do
            if dat.seen ~= nil then
                dat.seen = false
            end
        end
    end
end

return {
    CollisionDetector = CollisionDetector
}
