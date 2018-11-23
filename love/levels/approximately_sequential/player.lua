return function(controller, print)
    local function current_chute() return controller.current_chute() end
    local function ball_in_chute() return controller.ball_in_chute() end
    local last_chute = controller.number_of_chutes()
    local direction_of_movement = 'right'

    local function opposite_dir() return direction_of_movement == 'right' and 'left' or 'right' end

    local function no_move()
        coroutine.yield()
    end
    local function move(spaces)
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
        print(' loop start ')
        if ball_in_chute() then 
            no_move()
        else
            local chute_before_6_move = current_chute()

            print('before 6 move')
            move(6)
            print('after 6 move')


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

            print(' about to do if before special moves' .. chute_before_6_move .. ' ')
            if chute_before_6_move == 2 or chute_before_6_move == last_chute - 1 then
                print(' in the special moves')
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