

return function(total_number_of_chutes, number_of_balls_to_drop, starting_chute, first_direction, direction_change_points)
    direction_change_points = direction_change_points or {}

    local balls_dropped = 0
    
    local gantt = {}

    local step do
        if starting_chute == 1 then
            step = 1
        elseif starting_chute == total_number_of_chutes then
            step = -1
        else
            step = first_direction
        end
    end
    
    local running_change_points
    if #direction_change_points > 0 then
        running_change_points = {direction_change_points[1]}
        for i = 2, #direction_change_points do
            table.insert(running_change_points, direction_change_points[i] - direction_change_points[i-1])
        end
        table.insert(running_change_points, number_of_balls_to_drop - direction_change_points[#direction_change_points])
    else
        running_change_points = {number_of_balls_to_drop}
    end
    
    local last_spot_dropped = starting_chute
    for run_index,run in ipairs(running_change_points) do
        
        for _ = 1,run do
            
            table.insert(gantt, last_spot_dropped)
            if _ ~= run then
                if last_spot_dropped + step > total_number_of_chutes or 
                   last_spot_dropped + step < 1 then
                    step = -step
                   end
                last_spot_dropped = last_spot_dropped + step
            end
        end
        if run_index == #running_change_points then
            break
        end
        table.insert(gantt, {})
        step = -step
        last_spot_dropped = last_spot_dropped + step
    end

    return gantt
end