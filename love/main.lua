-- set the package path to collect source code
package.path = './love/src/?.lua;' .. package.path

math.randomseed(os.time())
local Chutes = require'chutes'
local Ball_Dropper = require'ball_dropper_random'
local Bucket = require'bucket'

function love.load()
    local num_chutes = 10
    local length_of_chutes = 10
    local number_of_balls_that_will_fall = 30
    local tocks_between_drops = 12
    local starting_chute = 1

    local chutes = Chutes(num_chutes, length_of_chutes)
    local ball_dropper = Ball_Dropper(num_chutes, number_of_balls_that_will_fall, tocks_between_drops)
    local bucket = Bucket(num_chutes, starting_chute)

    local bucket_location = 1
    local balls_that_fell_in_trough = 0
    
    
    function ball_exits(chute_num)
        if not chute_num == bucket_location then
            balls_that_fell_in_trough = balls_that_fell_in_trough + 1
        end
    end
    
    function balls_in_play()
        return chutes.balls_in_play()
    end
    
    bucket_position = starting_chute
    function tock()
        local new_ball = ball_dropper.tock()
        chutes.tock(new_ball)
    end

    width_of_chute = 50
    distance_unit = width_of_chute
    chute_rect = {start_x = 10, start_y = 10, width = width_of_chute * num_chutes, height = distance_unit * length_of_chutes}
    bucket_rect = {width = width_of_chute, height = distance_unit}
    ball = {radius = width_of_chute / 2}
    time = 0
end

function love.update(dt)
    time = time + dt
    if time > .09 then
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

    local balls = balls_in_play()

    love.graphics.setColor(1,1,1)
    for _,ball in ipairs(balls) do
        draw_ball(ball.chute, ball.location)
    end
end