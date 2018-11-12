return function(gantt)
    local i = 1
    local done_dropping = false

    return {
        tock = function()
            local droppings = gantt[i]
            if droppings == nil then
                done_dropping = true
                return {}
            else
                i = i + 1
                return droppings
            end
        end,
        done = function() return done_dropping end
    }
end