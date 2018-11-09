return function(number_of_chutes, number_of_balls_to_drop, tocks_between_drops)
    tocks_between_drops = tocks_between_drops or 0
    local num_dropped = 0
    local done_dropping = false
    local tocks_since_last_drop = tocks_between_drops

    return {
        tock = function()
            
            local enough_tocks_passed = tocks_since_last_drop == tocks_between_drops
            local still_dropping = not done_dropping

            if still_dropping and enough_tocks_passed then

                tocks_since_last_drop = 0

                local chute_to_drop_ball = math.random(number_of_chutes)

                num_dropped = num_dropped + 1

                if num_dropped == number_of_balls_to_drop then 
                    done_dropping = true
                end

                return chute_to_drop_ball

            elseif still_dropping and not enough_tocks_passed then

                tocks_since_last_drop = tocks_since_last_drop + 1
                return {}

            elseif not still_dropping then
                done_dropping = true
                return {}
            end
        end,
        done = function() return done_dropping end
    }
end
    