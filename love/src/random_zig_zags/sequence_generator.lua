return function(total_number_of_chutes, number_of_balls_to_drop, starting_chute, number_of_direction_changes, direction_change_points)
    
    local balls_dropped = 0
    
    local gantt = {}

    local running_change_points = {direction_change_points[1]}
    for i = 2, #direction_change_points do
        table.insert(running_change_points, direction_change_points[i] - direction_change_points[i-1])
    end
    table.insert(running_change_points, number_of_balls_to_drop - direction_change_points[#direction_change_points])
   
    local last_spot_dropped = starting_chute
    local step = -1
    for _,run in ipairs(running_change_points) do
        step = -step
        local start = last_spot_dropped
        local finish = start + (step*(run-step))
        
        for _ = 1,run do
            
            table.insert(gantt, last_spot_dropped)
            if _ ~= run then
                last_spot_dropped = last_spot_dropped + step
            end
        end
        table.insert(gantt, '')
    end

    return gantt
end