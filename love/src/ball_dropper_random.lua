return function(number_of_chutes, number_of_balls_to_drop)
    local num_dropped = 0
    return {
        tock = function()
            if num_dropped < number_of_balls_to_drop then
                local chute_to_drop_ball = math.random(number_of_chutes)
                num_dropped = num_dropped + 1
                return chute_to_drop_ball
            else
                return {}
            end
        end
    }
end
    