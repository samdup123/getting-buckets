local Chutes = require'chutes'
local Ball_Dropper = require'ball_dropper_random'
local LookRandom = require'random_number_look'
local Bucket = require'bucket'
local game_player = require'game_player'

return function(player_function)
    local number_of_chutes = 12
    local length_of_chutes = 16
    local number_of_balls_that_will_fall = 650
    local tocks_between_drops = 19
    local starting_chute = 1

    local chutes = Chutes(number_of_chutes, length_of_chutes)
    local random_func = LookRandom(number_of_chutes, number_of_chutes - 2, math.random)
    local ball_dropper = Ball_Dropper(random_func, number_of_chutes, number_of_balls_that_will_fall, tocks_between_drops)
    local bucket = Bucket(number_of_chutes, starting_chute)
    local controller = bucket.controller()

    local player_coroutine = coroutine.create(player_function)
    local status, err
    local played_at_least_once = false
    function run_user_code(debug)
        if not played_at_least_once then
            status, err = coroutine.resume(player_coroutine, controller, debug)
        else
            status, err = coroutine.resume(player_coroutine)
        end
        if not status and err:sub(1,1) ~= 'c' then 
            print('ERROR!!!\n\t' .. err)
        end
        played_at_least_once = true
    end

    local game_history, board_info, player_won = game_player(ball_dropper, chutes, bucket, run_user_code)

    local history_of_losses = require('game_history_parser')(game_history, 28)

    return game_history, board_info, player_won
end
