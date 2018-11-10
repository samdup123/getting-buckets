return function(total_number_of_chutes, number_of_balls_to_drop, starting_chute, first_direction, number_of_direction_changes, direction_change_points)
    
    local balls_dropped = 0
    
    local gantt = {}

    local running_change_points = {direction_change_points[1]}
    for i = 2, #direction_change_points do
        table.insert(running_change_points, direction_change_points[i] - direction_change_points[i-1])
    end
    table.insert(running_change_points, number_of_balls_to_drop - direction_change_points[#direction_change_points])
   
    local last_spot_dropped = starting_chute
    local step do
        if starting_chute == 1 then
            step = 1
        elseif starting_chute == total_number_of_chutes then
            step = -1
        else
            step = first_direction
        end
    end
    for _,run in ipairs(running_change_points) do
        local start = last_spot_dropped
        local finish = start + (step*(run-step))
        
        for _ = 1,run do
            
            table.insert(gantt, last_spot_dropped)
            if _ ~= run then
                last_spot_dropped = last_spot_dropped + step
            end
        end
        table.insert(gantt, '')
        step = -step
    end

    return gantt
end