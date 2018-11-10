-- set the package path to collect source code
package.path = './love/src/?.lua;' .. package.path

math.randomseed(os.time())
local Chutes = require'chutes'
local Ball_Dropper = require'ball_dropper_random'
local Bucket = require'bucket'
local player_function = require'player'

function love.load()
    num_chutes = 9
    local length_of_chutes = 16
    local number_of_balls_that_will_fall = 100
    local tocks_between_drops = 16
    local starting_chute = 1

    local chutes = Chutes(num_chutes, length_of_chutes)
    local ball_dropper = Ball_Dropper(num_chutes, number_of_balls_that_will_fall, tocks_between_drops)
    local bucket = Bucket(num_chutes, starting_chute)
    local controller = bucket.controller()

    local balls_that_fell_through = 0
    
    local bucket_position = starting_chute
    local balls_in_play, balls_exiting = {}, {}

    local player = coroutine.create(player_function)
    local status, err = coroutine.resume(player, controller)
    if not status then print(err) end
    function play()
        status, err = coroutine.resume(player)
        if not status then print(err) end
    end

    function bucket_is_under(chute_num)
        return chute_num == bucket_position
    end

    function tock()
        local new_ball = ball_dropper.tock()
        balls_in_play, balls_exiting = chutes.tock(new_ball)
        bucket_position = bucket.tock(balls_in_play)
        play()

        for _,chute_in_which_ball_exits in ipairs(balls_exiting) do
            if not bucket_is_under(chute_in_which_ball_exits) then
                balls_that_fell_through = balls_that_fell_through + 1
            end
        end
    end

    function get_balls_in_play()
        return balls_in_play
    end

    function get_bucket_position()
        return bucket_position
    end

    function get_balls_that_fell_through()
        return balls_that_fell_through
    end

    width_of_chute = 35
    distance_unit = width_of_chute
    chute_rect = {start_x = 10, start_y = 10, width = width_of_chute * num_chutes, height = distance_unit * length_of_chutes}
    bucket_rect = {start_y = chute_rect.start_y + chute_rect.height, width = width_of_chute, height = distance_unit}
    ball = {radius = width_of_chute / 2}
    time = 0
end

function love.update(dt)
    time = time + dt
    if time > .01 then
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

    local balls = get_balls_in_play()

    love.graphics.setColor(1,1,1)
    for _,ball in ipairs(balls) do
        draw_ball(ball.chute, ball.location)
    end

    local bucket_position = get_bucket_position()

    love.graphics.rectangle(
        'fill', 
        chute_rect.start_x + ((bucket_position - 1) * width_of_chute), 
        bucket_rect.start_y, 
        bucket_rect.width, 
        bucket_rect.height
    )

    --show balls that fell through
    for i = 1, get_balls_that_fell_through() do
        draw_ball(num_chutes + 1, i)
    end
end