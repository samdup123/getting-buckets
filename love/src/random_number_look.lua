return function(range_max, range, random)

    local last_value

    return function()
        if last_value == nil then
            last_value = random(range_max)
        else
            local one_less = last_value - 1
            local one_more = last_value + 1

            local min, max

            if last_value == range_max then
                last_value = random(2, one_less)
            elseif last_value == 1 then
                last_value = random(2, range_max - 1)
            elseif one_less > range_max - one_more then
                last_value = random(one_less)
            else
                last_value = random(one_more, range_max)
            end
        end

        return last_value
    end
end