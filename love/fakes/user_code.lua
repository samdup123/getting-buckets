return function(controller, debug, movement_gantt, debug_output_gantt)
    local function move(direction)
        local dir
        if direction == 'l' then
            controller.move_left()
        elseif direction == 'r' then
            controller.move_right()
        end
    end

    local i = 1

    while true do
        
        if i <= #movement_gantt then
            move(movement_gantt[i])
            debug(debug_output_gantt[i])
            i = i + 1
        end

        coroutine.yield()
    end
end