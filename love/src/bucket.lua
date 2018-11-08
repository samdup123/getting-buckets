return function(number_of_chutes, starting_chute)

    local current_chute = starting_chute

    local balls_in_play = {}

    local function clear_balls_in_play()
        for chute = 1, number_of_chutes do
            balls_in_play[chute] = false
        end
    end
    clear_balls_in_play()

    return {
        tock = function(balls_in_play)
            clear_balls_in_play()
            for _,ball in ipairs(balls_in_play) do
                balls_in_play[ball.chute] = is_there_a_ball_in_the_chute
            end
            return current_chute
        end,
        controller = function() 
            return {
                move_left = function()
                    if starting_chute == 1 then
                        error('can not move left from the first chute')
                    else
                        current_chute = current_chute - 1
                    end
                end,
                move_right = function()
                    if starting_chute == number_of_chutes then
                        error('can not move right from last chute')
                    else
                        current_chute = current_chute + 1
                    end
                end,
                is_there_a_ball_in_the_chute = function()
                    return balls_in_play[current_chute]
                end
            }
        end
    }
end