local zig_zag_sequencer = require'random_zig_zags/sequence_generator'
local distinct_random_values = require'distinct_random_values'

local function random_direction()
    local rand_num = math.random()

    if rand_num < .5 then 
        return -1
    else
        return 1
    end
end

return function(number_of_chutes, number_of_balls_to_drop, number_of_zig_zags, approximate_balls_per_zig_zag, tocks_between_zig_zags)

    local function ZigZag(number_of_balls_to_drop, starting_chute)
        local direction = random_direction()
        local direction_change_points = distinct_random_values(1, number_of_balls_to_drop, 2, 2)
        return zig_zag_sequencer(number_of_chutes, number_of_balls_to_drop, starting_chute, direction, direction_change_points)
    end

    tocks_between_zig_zags = tocks_between_zig_zags or 0
    number_of_zig_zags = number_of_zig_zags or number_of_balls_to_drop / 8

    local num_dropped = 0
    local tocks_since_last_zig_zag = 0

    local balls_left_to_drop_in_zig_zag = math.max(approximate_balls_per_zig_zag, number_of_balls_to_drop - num_dropped)
    local zig_zag = zig_zag_sequencer()

    local still_dropping_current_zig_zag = true
    local dropping_position = math.random(number_of_chutes)

    return {
        tock = function()

            if still_dropping_current_zig_zag then


            end
        end,
        done = function() return done_dropping end
    }
end
    