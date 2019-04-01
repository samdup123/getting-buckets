local Chutes = require'game/chutes'
local Ball_Dropper = require'game/ball_dropper_random'
local Bucket = require'game/bucket'
local game_player = require'game/player'

local number_of_chutes = 9
local length_of_chutes = 16
local number_of_balls_that_will_fall = 50
local tocks_between_drops = 15
local starting_chute = 1

local chutes = Chutes(number_of_chutes, length_of_chutes)
local random_func = function() return math.random(number_of_chutes) end
local ball_dropper = Ball_Dropper(random_func, number_of_chutes, number_of_balls_that_will_fall, tocks_between_drops)
local bucket = Bucket(number_of_chutes, starting_chute)

    return {
        ball_dropper = ball_dropper,
        chutes = chutes,
        bucket = bucket
    }
