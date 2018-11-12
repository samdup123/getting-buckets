return function(range_max)

    local last_value

    return function()
        if last_value == nil then
            last_value = math.random(range_max)
            return last_value
        else
            local one_less = last_value - 1
            local one_more = last_value + 1

            local min, max

            if one_less - 1 > range_max - one_more then
                last_value = math.random(one_less)
                return last_value
            else
                last_value = math.random(one_more, range_max)
                return last_value
            end
        end
    end
end