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

                if i == #gantt + 1 then
                    done_dropping = true
                end

                return droppings
            end
        end,
        done = function() return done_dropping end
    }
end