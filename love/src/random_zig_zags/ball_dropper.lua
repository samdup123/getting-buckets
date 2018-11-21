local function min(a,b) return a<b and a or b end

package.path = './src/random_zig_zags/?.lua;' .. package.path

local zig_zag_sequencer = require'random_zig_zags/sequence_generator'
local distinct_random_values = require'distinct_random_values'

local function random_direction()
    local rand_num = math.random()

    if rand_num < .5 then 
        return -1
    else
        return 1
    end
end

return function(number_of_chutes, number_of_balls_to_drop, number_of_zig_zags, approximate_balls_per_zig_zag, tocks_between_zig_zags, random)

    local function ZigZag(number_of_balls_to_drop, starting_chute)
        local direction = random_direction()
        local direction_change_points = distinct_random_values(1, number_of_balls_to_drop, 2, 2)
        return zig_zag_sequencer(number_of_chutes, number_of_balls_to_drop, starting_chute, direction, direction_change_points)
    end

    local zig_zags = {}

    local number_dropped = 0

    while number_dropped < number_of_balls_to_drop - math.floor(number_of_balls_to_drop / approximate_balls_per_zig_zag) do
        table.insert(zig_zags, ZigZag(approximate_balls_per_zig_zag, random(number_of_chutes)))
        number_dropped = number_dropped + approximate_balls_per_zig_zag
    end
    
    local gantt = {}

    for i,zig_zag in ipairs(zig_zags) do
        for _,val in ipairs(zig_zag) do
            table.insert(gantt, val)
        end
        -- print(i, #zig_zags, i ~= #zig_zags)
        if i ~= #zig_zags then
            -- print('inserting floop')
            for _ = 1, tocks_between_zig_zags do
                table.insert(gantt, '')
            end
        end
    end

    return gantt
end
    