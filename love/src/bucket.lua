return function(number_of_chutes, starting_chute)

    local current_chute = starting_chute

    local balls_in_play = {}

    local function clear_balls_in_play()
        for chute = 1, number_of_chutes do
            balls_in_play[chute] = false
        end
    end
    clear_balls_in_play()

    local a_move_has_happened_since_a_tock = false

    local function move(direction)
        if not a_move_has_happened_since_a_tock then
            a_move_has_happened_since_a_tock = true
            if starting_chute == 1 and direction == 'left' then
                error('can not move left from the first chute')
            elseif starting_chute == number_of_chutes and direction == 'right' then
                error('can not move right from the last chute')
            else
                current_chute = current_chute + ((direction == 'left') and -1 or 1)
            end
        else
            error('can not move twice between tocks')
        end
    end

    local controller = {
        move_left = function()
            move('left')
        end,
        move_right = function()
            move('right')
        end,
        ball_in_chute = function()
            return balls_in_play[current_chute]
        end
    }

    return {
        tock = function(balls)
            clear_balls_in_play()
            for _,ball in ipairs(balls or {}) do
                balls_in_play[ball.chute] = true
            end

            a_move_has_happened_since_a_tock = false
            return current_chute
        end,
        controller = function() 
            return controller
        end
    }
end