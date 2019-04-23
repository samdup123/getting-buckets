local Chutes = require'game/chutes'
local Ball_Dropper = require'game/ball_dropper_random'
local Bucket = require'game/bucket'
local game_player = require'game/player'
local number_of_chutes = 9
local length_of_chutes = 16
local number_of_balls_that_will_fall = 50
local tocks_between_drops = 9
local starting_chute = 1
local chutes = Chutes(number_of_chutes, length_of_chutes)
local bucket = Bucket(number_of_chutes, starting_chute)
local controller = bucket.controller()
local current_chute = 1
local direction = 1
local oscillating_func = function()
    local next_chute = 1
    if direction == 1 then
        direction = 2
        next_chute = current_chute
    else
        direction = 1
        next_chute = (number_of_chutes - current_chute) + 1
        current_chute = current_chute + 1
    end

    if current_chute > number_of_chutes then
        current_chute = 1
    end

    return next_chute
end

local ball_dropper = Ball_Dropper(oscillating_func, number_of_chutes, number_of_balls_that_will_fall, tocks_between_drops)

return {
    ball_dropper = ball_dropper,
    chutes = chutes,
    bucket = bucket,
}
