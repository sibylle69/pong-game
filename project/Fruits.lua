--[[
    Contains tile data and necessary code for rendering a tile map to the
    screen.
]]

require 'Util'

HALF_PEAR = 1
PEAR = 2
HALF_ORANGE = 3
ORANGE = 4
CHERRIES = 5
HALF_WATERMELON = 6
WATERMELON = 7
BANANAS = 8

Fruits = Class{}

function Fruits:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variable is for keeping track of our velocity on the
    -- Y axis
    self.dy = 100

    
    self.spritesheet = love.graphics.newImage('graphics/fruits.png')
    self.sprites = generateQuads(self.spritesheet, 19, 26)

    self.tileWidth = 19
    self.tileHeight = 26
    self.mapWidth = 30
    self.mapHeight = 28
    self.tiles = {}

        -- returns an integer value for the tile at a given x-y coordinate
    function Fruits:getTile(x, y)
        return self.tiles[(y - 1) * self.mapWidth + x]
    end

    -- sets a tile at a given x-y coordinate to an integer value
    function Fruits:setTile(x, y, id)
        self.tiles[(y - 1) * self.mapWidth + x] = id
    end

end

function Fruits:collides(paddle)

    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function Fruits:reset()
    self.x = math.random(0, VIRTUAL_WIDTH - 5)
    self.y = -5
    self.dy = 150
    self.dx = 0
end

function Fruits:update(dt)
    self.y = self.y + self.dy * dt
end

--function Fruits:render(item)
    --Fruits:setTile(self.x, self.y, item)
--end
