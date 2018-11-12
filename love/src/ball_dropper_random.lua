local ball_dropper = require'ball_dropper'

return function(number_of_chutes, number_of_balls_to_drop, tocks_between_drops)
    tocks_between_drops = tocks_between_drops or 0
    local gantt = {}

    for i = 1, number_of_balls_to_drop do
        table.insert(gantt, math.random(number_of_chutes))

        if i == number_of_balls_to_drop then 
            break
        end

        for _ = 1, tocks_between_drops do
            table.insert(gantt, {})
        end
    end

    for _,thing in ipairs(gantt) do print(thing) end

    return ball_dropper(gantt)
end
    