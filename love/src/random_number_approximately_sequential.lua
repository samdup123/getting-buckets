return function(range_max, target_sequence, band, random)
    
    local last_value
    local sign = 1
    return function()
        if last_value == nil then
            last_value = random(range_max)
        else
            last_value = last_value + (sign * random(target_sequence - band, target_sequence + band))
            if last_value > range_max then
                local ammount_over = last_value - range_max
                last_value = range_max - ammount_over
                sign = -1
            elseif last_value < 1 then
                local ammount_under = -last_value
                last_value = ammount_under
                sign = 1
            end
        end
        return last_value
    end
end