return function(range_max, range, random)
    
    local function minimum(a,b) return a < b and a or b end
    local last_value

    return function()
        if last_value == nil then
            last_value = random(range_max)
        else
            local one_less = last_value - 1
            local one_more = last_value + 1

            local min, max

            if one_less > range_max - one_more then
                if one_less > range then
                    last_value = random(one_less - range + 1, one_less)
                else
                    last_value = random(one_less)
                end
            else
                last_value = random(one_more, minimum(one_more + range - 1, range_max))
            end
        end

        return last_value
    end
end