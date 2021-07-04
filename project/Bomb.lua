Bomb = Class{}

function Bomb:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variable is for keeping track of our velocity on the
    -- Y axis
    self.dy = 200

end

--[[
    Places the ball in the middle of the screen, with an initial random velocity
    on both axes.
]]
function Bomb:reset()
    self.x = math.random(0, VIRTUAL_WIDTH - 5)
    self.y = -5
    self.dy = 200
    self.dx = 0
end

--[[
    Simply applies velocity to position, scaled by deltaTime.
]]
function Bomb:update(dt)
    self.y = self.y + self.dy * dt
end

function Bomb:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
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

function Bomb:render()
    love.graphics.circle('fill', math.random(0, VIRTUAL_WIDTH - 5), -5, 3)
end