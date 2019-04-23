return function(controller, debug)
    local current_chute = controller.current_chute()
    local last_chute = controller.number_of_chutes()
    local direction_of_movement = 'right'
    local function move()
        controller['move_' .. direction_of_movement]()
    end
    local shoot = 1
    local direction = 1
    local oscillating_func = function()
        local next_chute = 1
        if direction == 1 then
            direction = 2
            next_chute = shoot
        else
            direction = 1
            next_chute = (last_chute - shoot) + 1
            shoot = shoot + 1
        end

        if shoot > last_chute then
            shoot = 1
        end

        return next_chute
    end

    local next_chute = oscillating_func()

    return function()
        if current_chute < next_chute then
            direction_of_movement = 'right'
        elseif current_chute > next_chute then
            direction_of_movement = 'left'
        end

        if current_chute ~= next_chute then
            move()
        else
            if not controller.ball_in_chute() then
                next_chute = oscillating_func()
            end
        end

        current_chute = controller.current_chute()
    end
end
