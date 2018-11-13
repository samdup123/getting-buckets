-- set the package path to collect source code
package.path = './love/src/?.lua;' .. package.path

math.randomseed(os.time())
local Chutes = require'chutes'
local Ball_Dropper = require'ball_dropper_random'
local Bucket = require'bucket'
local player_function = require'player'
local game_player = require'game_player'

function love.load()
    num_chutes = 9
    local length_of_chutes = 16
    local number_of_balls_that_will_fall = 10000
    local tocks_between_drops = 15
    local starting_chute = 1

    local chutes = Chutes(num_chutes, length_of_chutes)
    local random_func = function() return math.random(num_chutes) end
    local ball_dropper = Ball_Dropper(random_func, num_chutes, number_of_balls_that_will_fall, tocks_between_drops)
    local bucket = Bucket(num_chutes, starting_chute)
    local controller = bucket.controller()

    local player_coroutine = coroutine.create(player_function)
    local status, err
    local played_at_least_once = false
    function run_user_code()
        if not played_at_least_once then
            status, err = coroutine.resume(player_coroutine, controller)
        else
            status, err = coroutine.resume(player_coroutine)
        end
        if not status then print('ERROR!!!\n\t' .. err) end
        played_at_least_once = true
    end

    game_history, player_won = game_player(ball_dropper, chutes, bucket, run_user_code)
    print('game player ran', game_history, player_won and "player won!" or "player lost!")

    width_of_chute = 35
    distance_unit = width_of_chute
    chute_rect = {start_x = 10, start_y = 10, width = width_of_chute * num_chutes, height = distance_unit * length_of_chutes}
    bucket_rect = {start_y = chute_rect.start_y + chute_rect.height, width = width_of_chute, height = distance_unit}
    ball = {radius = width_of_chute / 2}
    time = 0

    game_time_state = 1
end

function love.update(dt)
    time = time + dt
    if time > .03 then
        time = 0
        game_time_state = game_time_state + 1
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

    love.graphics.setColor(1,1,1)

    if game_time_state <= #game_history then
        local moment = game_history[game_time_state]
    
        for _,ball in ipairs(moment.balls_in_play) do
            draw_ball(ball.chute, ball.location)
        end
    
        -- draw bucket
        love.graphics.rectangle(
            'fill', 
            chute_rect.start_x + ((moment.bucket_position - 1) * width_of_chute), 
            bucket_rect.start_y, 
            bucket_rect.width, 
            bucket_rect.height
        )
    end
end