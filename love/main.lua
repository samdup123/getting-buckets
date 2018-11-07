-- set the package path to collect source code
package.path = './love/src/?.lua;' .. package.path

local Chutes = require'chutes'
local Ball_Dropper = require'ball_dropper_random'

function love.load()
    num_chutes = 10
    length_of_chutes = 10

    chutes = Chutes(num_chutes, length_of_chutes)
    ball_dropper = Ball_Dropper(num_chutes)

    width_of_chute = 50
    distance_unit = width_of_chute
    chute_rect = {start_x = 10, start_y = 10, width = width_of_chute * num_chutes, height = distance_unit * length_of_chutes}
    ball = {radius = width_of_chute / 2}

    bucket_location = 1
    balls_that_fell_in_trough = 0

    number_of_balls_that_will_fall = 30
    fallen_balls = 0

    function tock()
        print('tocking')
        local new_ball = {}
        if fallen_balls ~= number_of_balls_that_will_fall then
            print('inserting a new ball')
            table.insert(new_ball, ball_dropper.chutes_in_which_balls_are_dropped())
            fallen_balls = fallen_balls + 1
        end
        chutes.tock(new_ball)
    end

    function ball_exits(chute_num)
        if not chute_num == bucket_location then
            balls_that_fell_in_trough = balls_that_fell_in_trough + 1
        end
    end

    time = 0
end

function love.update(dt)
    time = time + dt
    if time > .4 then
        time = 0
        tock()
    end
end

local function draw_rectangle(mode, rect)
    love.graphics.rectangle(mode, rect.start_x, rect.start_y, rect.width, rect.height)
end

local function draw_ball(chute_num, location)
    love.graphics.circle(
        'fill',
        chute_rect.start_x + (chute_num - .5) * width_of_chute,
        chute_rect.start_y + (location - .5) * distance_unit,
        ball.radius
    )
end

function love.draw()
    love.graphics.setColor(1,0,1)
    
    draw_rectangle('fill', chute_rect)

    local balls = chutes.balls_in_play()

    love.graphics.setColor(1,1,1)
    for _,ball in ipairs(balls) do
        draw_ball(ball.chute, ball.location)
    end
end