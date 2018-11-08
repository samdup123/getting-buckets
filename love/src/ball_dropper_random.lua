return function(number_of_chutes, number_of_balls_to_drop)
    local num_dropped = 0
    local done_dropping = false
    return {
        tock = function()
            if not done_dropping then
                local chute_to_drop_ball = math.random(number_of_chutes)

                num_dropped = num_dropped + 1

                if num_dropped == number_of_balls_to_drop then 
                    done_dropping = true
                end
                
                return chute_to_drop_ball
            else
                done_dropping = true
                return {}
            end
        end,
        done = function() return done_dropping end
    }
end
    