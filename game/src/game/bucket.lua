return function(number_of_chutes, starting_chute)

    local current_chute = starting_chute

    local balls_in_play = {}
    local balls_exiting = {}

    local function clear_balls()
        for chute = 1, number_of_chutes do
            balls_in_play[chute] = false
        end
        for chute = 1, number_of_chutes do
            balls_exiting[chute] = false
        end
    end
    clear_balls()

    local a_move_has_happened_since_a_tock = false

    local function move(direction)
        if a_move_has_happened_since_a_tock then
            error('can not move twice between time units')
            return
        end

        a_move_has_happened_since_a_tock = true
        if current_chute == 1 and direction == 'left' then
            error('can not move left from the first chute')
        elseif current_chute == number_of_chutes and direction == 'right' then
            error('can not move right from the last chute')
        else
            current_chute = current_chute + ((direction == 'left') and -1 or 1)
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
            if a_move_has_happened_since_a_tock then 
                error('if you try to move and check for a ball in the chute inside the same tock, you must check before moving')
            else
                return balls_in_play[current_chute]
            end
        end,
        current_chute = function() return current_chute end,
        number_of_chutes = function() return number_of_chutes end
    }

    return {
        tock = function(_balls_in_play, _balls_exiting)
            clear_balls()
            for _,ball in ipairs(_balls_in_play or {}) do
                balls_in_play[ball.chute] = true
            end
            for _,ball in ipairs(_balls_exiting or {}) do
                balls_exiting[ball.chute] = true
            end

            a_move_has_happened_since_a_tock = false
            return current_chute
        end,
        controller = function() 
            return controller
        end,
        initial_position = function() return starting_chute end
    }
end