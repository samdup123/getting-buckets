return function(number_of_chutes, number_of_balls_to_drop, number_of_zig_zags, tocks_between_zig_zags)
    tocks_between_zig_zags = tocks_between_zig_zags or 0
    number_of_zig_zags = number_of_zig_zags or number_of_balls_to_drop / 8
    local num_dropped = 0
    local tocks_since_last_zig_zag = tocks_between_zig_zags

    local balls_left_to_drop = true
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
    