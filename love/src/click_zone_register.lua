return function()

    local register = {}

    return {
        test = function(x,y)
            for _,click_zone in ipairs(register) do
                local in_x = click_zone.x1 <= x and x <= click_zone.x2
                local in_y = click_zone.y1 <= y and y <= click_zone.y2
                if in_x and in_y then 
                    return click_zone.name
                end
            end
        end,
        add = function(x1,y1,x2,y2, name)
            table.insert(register, {name = name, x1 = x1, y1 = y1, x2 = x2, y2 = y2})
        end,
        remove = function(name)
            for i = 1, #register do
                if register[i].name == name then
                    table.remove(register, i)
                end
            end
        end
    }
end