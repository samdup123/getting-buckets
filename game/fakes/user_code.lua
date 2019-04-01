return function(controller, debug)
    local movement_gantt =
        {'r', 'l', '', 'r', 'r'}
    local debug_gantt =
        {'hi', 'hey', 'hello', 'howdy', 'holla'}

    local i = 1

    return function()
        local function move(direction)
            local dir
            if direction == 'l' then
                controller.move_left()
            elseif direction == 'r' then
                controller.move_right()
            end
        end

        if i <= #movement_gantt then
            move(movement_gantt[i])
            debug(debug_gantt[i])
            i = i + 1
        end
    end
end
