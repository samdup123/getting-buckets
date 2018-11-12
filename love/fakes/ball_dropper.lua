return function(gantt)
    local i = 1
    local done_dropping = false

    return {
        tock = function()
            local droppings = gantt[i]
            if droppings == nil then
                return {}
            else
                i = i + 1
                return droppings
            end
            if i == #gantt then
                done_dropping = true
            end
        end,
        done = function() return done_dropping end
    }
end