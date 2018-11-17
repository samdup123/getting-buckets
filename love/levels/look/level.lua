local Chutes = require'chutes'
local Ball_Dropper = require'ball_dropper_random'
local LookRandom = require'random_number_look'
local Bucket = require'bucket'
local game_player = require'game_player'

return function(player_function)
    local number_of_chutes = 12
    local length_of_chutes = 16
    local number_of_balls_that_will_fall = 650
    local tocks_between_drops = 18
    local starting_chute = 1

    local chutes = Chutes(number_of_chutes, length_of_chutes)
    local random_func = LookRandom(number_of_chutes, number_of_chutes - 2, math.random)
    local ball_dropper = Ball_Dropper(random_func, number_of_chutes, number_of_balls_that_will_fall, tocks_between_drops)
    local bucket = Bucket(number_of_chutes, starting_chute)
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
        if not status and err:sub(1,1) ~= 'c' then 
            print('ERROR!!!\n\t' .. err)
        end
        played_at_least_once = true
    end

    local game_history, board_info, player_won = game_player(ball_dropper, chutes, bucket, run_user_code)

    local partial_game_history = require('game_history_parser')(game_history, 20)

    for _,moment in ipairs(partial_game_history) do
        io.write('i ' .. moment.moment_number .. '  pos ' .. moment.bucket_position .. ' balls in play    ')
        for _,ball in ipairs(moment.balls_in_play or {}) do
            io.write(ball.chute .. ':' .. ball.location .. ' ')
        end
        if #moment.lost_balls > 0 then 
            io.write('  lost ' .. moment.lost_balls[1] .. '\n')
        else
             io.write('\n')
        end
    end

    return game_history, board_info, player_won
end
