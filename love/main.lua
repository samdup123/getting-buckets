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

    local balls_that_fell_in_trough = 0
    
    local bucket_position = starting_chute
    local balls_in_play, balls_exiting = {}, {}

    function bucket_is_under(chute_num)
        return chute_num == bucket_position
    end

    function tock()
        local new_ball = ball_dropper.tock()
        balls_in_play, balls_exiting = chutes.tock(new_ball)
        bucket_position = bucket.tock(balls_in_play)

        for _,chute_in_which_ball_exits in ipairs(balls_exiting) do
            if not bucket_is_under(chute_in_which_ball_exits) then
                balls_that_fell_in_trough = balls_that_fell_in_trough + 1
            end
        end
    end

    function get_balls_in_play()
        return balls_in_play
    end

    function get_bucket_position()
        return bucket_position
    end

    width_of_chute = 50
    distance_unit = width_of_chute
    chute_rect = {start_x = 10, start_y = 10, width = width_of_chute * num_chutes, height = distance_unit * length_of_chutes}
    bucket_rect = {start_y = chute_rect.start_y + chute_rect.height, width = width_of_chute, height = distance_unit}
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

    local balls = get_balls_in_play()

    love.graphics.setColor(1,1,1)
    for _,ball in ipairs(balls) do
        draw_ball(ball.chute, ball.location)
    end

    local bucket_position = get_bucket_position()

    love.graphics.rectangle(
        'fill', 
        chute_rect.start_x + (bucket_position * width_of_chute), 
        bucket_rect.start_y, 
        bucket_rect.width, 
        bucket_rect.height
    )
end