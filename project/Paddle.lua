Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.height = height
    self.width = width

    self.dx = 0
end

function Paddle:update(dt)

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)

    elseif self.dx > 0 then
    
        self.x = math.min(VIRTUAL_WIDTH - 20, self.x + self.dx * dt)
    end
end

function Paddle:render()
    -- left padle
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end