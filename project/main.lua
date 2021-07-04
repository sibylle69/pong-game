WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

Class = require 'class'
push = require "push"

require 'Paddle'
require 'Ball'
require 'Fruits'
require 'Bomb'

PADDLE_SPEED = 200
gameState = "serve"

paddle = Paddle(VIRTUAL_WIDTH / 2 - 10, VIRTUAL_HEIGHT - 10, 20, 5)
ball = Ball(math.random(0, VIRTUAL_WIDTH), - 5, 4, 4)
bomb = Bomb(math.random(0, VIRTUAL_WIDTH), - 5, 6, 6)
fruit = Fruits(math.random(0, VIRTUAL_WIDTH), - 26, 19, 26)

function love.load()

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle('Zeubii')

    smallFont = love.graphics.newFont('font.TTF', 16)
    scoreFont = love.graphics.newFont('font.TTF', 32)
    myFont = love.graphics.newFont('font.TTF', 24)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sound/Pickup_Coin19.wav', 'static'),
        ['fail'] = love.audio.newSource('sound/fail.wav', 'static'),
        ['bomb_hit'] = love.audio.newSource('sound/Explosion.wav', 'static')
    }

    music = love.audio.newSource('sound/sax.mp3', 'static')

    score = 0

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    -- called whenever window is resized
    function love.resize(w, h)
        push:resize(w, h)
    end
end

function love.draw()

    push:apply('start')

    -- background color
    love.graphics.clear(68 / 255, 129 / 255, 200 / 255, 255 / 255)

    paddle:render()
    ball:render()
    love.graphics.setColor(1, 0, 0)
    bomb:render()
    love.graphics.setColor(1, 1, 1)

    --fruit:render(love.math.random(8))

    love.graphics.setFont(scoreFont)
    displayScore()
    love.graphics.setFont(smallFont)

    if gameState == "serve" then
        love.graphics.setFont(myFont)
        love.graphics.printf("Zeubii from Sibylle, Lyon, FRANCE", 0, 160, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to play", 0, 30, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'done' then
        love.graphics.setFont(scoreFont)
        love.graphics.printf('You did ' .. tostring(score) .. "!", 
        0, 10, VIRTUAL_WIDTH, 'center')
    end
    
    push:apply('end')

end

function love.update(dt)

    if gameState == "serve" then
        ball.dy = 150
        bomb.dy = 200

        if love.keyboard.isDown("right") then
            --move to the right
            paddle.dx = PADDLE_SPEED
    
        elseif love.keyboard.isDown("left") then
            --move to the left
            paddle.dx = -PADDLE_SPEED
        else
            paddle.dx = 0
        end
        
    elseif gameState == "play" then  

        --play music
        music:setLooping(true)
        music:play()

        --move paddle
        if love.keyboard.isDown("right") then
            --move to the right
            paddle.dx = PADDLE_SPEED
    
        elseif love.keyboard.isDown("left") then
            --move to the left
            paddle.dx = -PADDLE_SPEED
        else
            paddle.dx = 0
        end  

        --paddle crossing the edges
        if paddle.x == 0 then
            paddle.x = VIRTUAL_WIDTH - 20
        elseif paddle.x + 20 > VIRTUAL_WIDTH then
            paddle.x = 0
        end

        if ball:collides(paddle) then
            ball:reset()
            score = score + 1
            sounds['paddle_hit']:play()
        end

        if bomb:collides(paddle) then
            sounds['bomb_hit']:play()
            gameState = 'done'
        end

        if ball.y > VIRTUAL_HEIGHT then
            gameState = "done"
            sounds['fail']:play()
        end

    end

    if gameState == 'play' then
        ball:update(dt)
        bomb:update(dt)
    end

    if paddle.x == 0 then
        paddle.x = VIRTUAL_WIDTH - 20
    elseif paddle.x + 20 > VIRTUAL_WIDTH then
        paddle.x = 0
    end

    paddle:update(dt)

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            -- game is simply in a restart phase here, but will set the serving
            -- player to the opponent of whomever won for fairness!
            gameState = 'serve'
            ball:reset()
            bomb:reset()
            paddle.x = VIRTUAL_WIDTH / 2 - 10
            -- reset scores to 0
            score = 0
        end
    end
end

function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(score), VIRTUAL_WIDTH / 2 - 10, 
        VIRTUAL_HEIGHT / 3)
end