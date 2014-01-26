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
    local typ1 = type(data1)
    local typ2 = type(data2)
    local tile, fov = nil, nil
    if typ1 == 'Tile' then
        tile = data1
    elseif typ2 == 'Tile' then
        tile = data2
    end
    if typ1 == 'FOV' then
        fov = data1
    elseif typ2 == 'FOV' then
        fov = data2
    end
    if tile ~= nil and fov ~= nil then
        tile.seen = true
    end
end

function CollisionDetector:contactEnded(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()
    local typ1 = type(data1)
    local typ2 = type(data2)
    local tile, fov = nil, nil
    if typ1 == 'Tile' then
        tile = data1
    elseif typ2 == 'Tile' then
        tile = data2
    end
    if typ1 == 'FOV' then
        fov = data1
    elseif typ2 == 'FOV' then
        fov = data2
    end
    if tile ~= nil and fov ~= nil then
        tile.seen = false
    end
end

return {
    CollisionDetector = CollisionDetector
}
