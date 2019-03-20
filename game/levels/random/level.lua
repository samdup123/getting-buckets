local Chutes = require'game_engine/chutes'
local Ball_Dropper = require'game_engine/ball_dropper_random'
local Bucket = require'game_engine/bucket'
local game_player = require'game_engine/game_player'

return function(player_function)
    local number_of_chutes = 9
    local length_of_chutes = 16
    local number_of_balls_that_will_fall = 50
    local tocks_between_drops = 15
    local starting_chute = 1

    local chutes = Chutes(number_of_chutes, length_of_chutes)
    local random_func = function() return math.random(number_of_chutes) end
    local ball_dropper = Ball_Dropper(random_func, number_of_chutes, number_of_balls_that_will_fall, tocks_between_drops)
    local bucket = Bucket(number_of_chutes, starting_chute)
    local controller = bucket.controller()

    local null_debug = function() end
    local run_user_code =  player_function(controller, null_debug)

    local game_history, board_info, player_won = game_player(ball_dropper, chutes, bucket, run_user_code)

    return game_history, board_info, player_won
end
