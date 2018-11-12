return function(controller, gantt)
    local function move(direction)
        local dir
        if direction == 'l' then
            controller.move_left()
        elseif direction == 'r' then
            controller.move_right()
        end
    end

    coroutine.yield()

    local i = 1

    while true do
        
        if i <= #gantt then
            move(gantt[i])
            i = i + 1
        end

        coroutine.yield()
    end
end