return function(range_max, range)

    local last_value

    return function()
        if last_value == nil then
            last_value = math.random(range_max)
            return last_value
        else
            local one_less = last_value - 1
            local one_more = last_value + 1

            local min, max

            print('last value', last_value, 'one less-one', one_less - 1, 'range_max - one_more', range_max - one_more)

            if one_less - 1 > range_max - one_more then
                print('one less won')

                if one_less > range then
                    print('top')
                    print(one_less - range, one_less)
                    last_value = math.random(one_less - range, one_less)
                else
                    print(one_less)
                    last_value = math.random(one_less)
                end
                return last_value
            else
                print('one more won', range_max - one_more, range)
                if range_max - one_more > range then
                    print('top')
                    print(one_more, range_max - one_more)
                    last_value = math.random(one_more, range_max - one_more)
                else
                    print(one_more, range_max   )
                    last_value = math.random(one_more, range_max)
                end
                return last_value
            end
        end
    end
end