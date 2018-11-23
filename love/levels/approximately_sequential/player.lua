return function(controller, print)
    local function current_chute() return controller.current_chute() end
    local function ball_in_chute() return controller.ball_in_chute() end
    local last_chute = controller.number_of_chutes()
    local direction_of_movement = 'right'

    local function flip_dir() direction_of_movement = (direction_of_movement == 'right' and 'left' or 'right') end

    local function no_move(num)
        coroutine.yield()
    end
    local function move(spaces)
        if space == 0 then coroutine.yield() end
        for i = 1, spaces do
            if current_chute() == 1 then direction_of_movement = 'right' end
            if current_chute() == last_chute then direction_of_movement = 'left' end
            controller['move_' .. direction_of_movement]()
            coroutine.yield()
        end
    end

    local locale = 1
    local function scan_until_ball_found()
        if not controller.ball_in_chute() then

        end
    end


    while ball_in_chute() do
        coroutine.yield()
    end

    while true do
        ::loop_start::
        if ball_in_chute() then 
            no_move()
        else
            local chute_before_big_move = current_chute()
            local at_beginning_moving_left = (chute_before_big_move == 2) and (direction_of_movement == 'left')
            local at_end_moving_right = (chute_before_big_move == last_chute - 1) and (direction_of_movement == 'right')
            if at_beginning_moving_left or at_end_moving_right then
                flip_dir()
                move(4)
                no_move()
            else
                move(6)
            end

            if not ball_in_chute() then
                move(1)
            else
                goto loop_start
            end
            if not ball_in_chute() then
                move(1)
            else
                goto loop_start
            end

            if at_beginning_moving_left or at_end_moving_right then
                if not ball_in_chute() then
                    move(1)
                else
                    goto loop_start
                end
                if not ball_in_chute() then
                    move(1)
                else
                    goto loop_start
                end
            end
        end
    end

end