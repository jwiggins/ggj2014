local function closureCaller(self, func)
    return function (...) func(self, ...) end
end

-- The CollisionDetector class
local CollisionDetector = class()
function CollisionDetector:__init(tiles, fovs)
    -- No gravity or sleeping allowed!
    local world = love.physics.newWorld(0.0, 0.0, false)
    self:initTiles(world, tiles)
    self:initFovs(world, fovs)

    local contactBeganCB = closureCaller(self, CollisionDetector.contactBegan)
    local contactEndedCB = closureCaller(self, CollisionDetector.contactEnded)
    world:setCallbacks(contactBeganCB, contactEndedCB, nil, nil)

    self.world = world
end

function CollisionDetector:initTiles(world, tiles)
    local fixtures = {}
    for i, t in ipairs(tiles) do
        local body = love.physics.newBody(world, t.x, t.y, "static")
        local shape = love.physics.newRectangleShape(t.width, t.height)
        local fixture = love.physics.newFixture(body, shape, 0.0)
        fixture:setSensor(true)
        fixture:setUserData(t)
        table.insert(fixtures, i, fixture)
    end
    self.tile_fixtures = fixtures
end

function CollisionDetector:initFovs(world, fovs)
    local fixtures = {}
    for i, f in ipairs(fovs) do
        local body = love.physics.newBody(world, f.x, f.y, "dynamic")
        local pts = f:collisionPoints()
        local shape = love.physics.newPolygonShape(pts[1], pts[2], pts[3], pts[4],
                                                   pts[5], pts[6], pts[7], pts[8],
                                                   pts[9], pts[10], pts[11], pts[12],
                                                   pts[13], pts[14], pts[15], pts[16])
        local fixture = love.physics.newFixture(body, shape, 0.0)
        fixture:setSensor(true)
        fixture:setUserData(f)
        table.insert(fixtures, i, fixture)
    end
    self.fov_fixtures = fixtures
end

function CollisionDetector:update(dt)
    for i, fov in ipairs(self.fov_fixtures) do
        local chr = fov:getUserData().character
        local body = fov:getBody()
        body:setPosition(chr.x, chr.y)
        body:setAngle(chr.facing)
    end
    self.world:update(dt)
end

function CollisionDetector:draw()
    love.graphics.push()
    love.graphics.setColor(255, 0, 255, 128)
    for i, tile in ipairs(self.tile_fixtures) do
        local t = tile:getUserData()
        if t.seen > 0 then
            love.graphics.rectangle("fill", t.x-10, t.y-10, 20, 20)
        end
    end
    love.graphics.pop()
end

function CollisionDetector:contactBegan(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()
    if data1.kind ~= data2.kind then
        for i, dat in ipairs({data1, data2}) do
            if dat.seen ~= nil then
                dat.seen = dat.seen + 1
            end
        end
    end
end

function CollisionDetector:contactEnded(fixture1, fixture2, contact)
    local data1 = fixture1:getUserData()
    local data2 = fixture2:getUserData()
    if data1.kind ~= data2.kind then
        for i, dat in ipairs({data1, data2}) do
            if dat.seen ~= nil then
                dat.seen = dat.seen - 1
            end
        end
    end
end

return {
    CollisionDetector = CollisionDetector
}
