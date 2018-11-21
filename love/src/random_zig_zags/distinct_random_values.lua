return function(min, max, count, diff)
    diff = diff or 1

    local vals_lookup = {}
    local count_of_vals = 0
    for i = min, max do 
        count_of_vals = count_of_vals + 1
        vals_lookup[i] = true 
    end

    if count_of_vals - (diff * 2) * count < count then
        print('count of vals', count_of_vals, (diff * 2) * count, count)
        error('the parameters passed into the distinct number generator are impossible to satisfy')
    end

    local random_vals = {}
    
    for i = 1, count do
        local rand_num = math.random(count_of_vals)
        local new_val

        local c = 0
        for val,_ in pairs(vals_lookup) do
            c = c + 1
            new_val = val
            if c == rand_num then 
                vals_lookup[val] = nil
                count_of_vals = count_of_vals - 1
                break 
            end
        end

        local min_deletion, max_deletion = new_val - diff, new_val + diff

        for other_val = min_deletion, max_deletion do
            if vals_lookup[other_val] then
                vals_lookup[other_val] = nil
                count_of_vals = count_of_vals - 1
            end
        end

        table.insert(random_vals, new_val)
    end

    return random_vals
end