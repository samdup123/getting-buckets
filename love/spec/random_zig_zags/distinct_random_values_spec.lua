describe('distinct random values', function()
    math.randomseed(os.time())
    local func = require'random_zig_zags/distinct_random_values'

    local function assert_values_are_far_enough_apart(vals, diff)
        for i = 1, #vals do
            for j = 1, #vals do
                if i ~= j then
                    assert.is_true(math.abs(vals[i] - vals[j]) > diff)
                end
            end
        end
    end

    local function assert_values_are_in_range(vals, min, max)
        for _,val in ipairs(vals) do
            assert.is_true(min <= val and val >= max)
        end
    end

    it('should work for 1 to 50', function()
        local start, _end, count, diff = 1, 50, 4, 3
        local vals = func(start, _end, count, diff)
        
        assert_values_are_far_enough_apart(vals, diff)
        assert_values_are_in_range(1, 50)
    end)

    it('should work for 50 to 100', function()
        local start, _end, count, diff = 1, 50, 4, 3
        local vals = func(start, _end, count, diff)
        
        assert_values_are_far_enough_apart(vals, diff)
        assert_values_are_in_range(50, 100)
    end)

    it('should have a default diff of 1', function()
        local start, _end, count = 1, 50, 4
        local vals = func(start, _end, count)
        
        assert_values_are_far_enough_apart(vals, 1)
    end)

    it('should err when there is no possibility for distinct values with the given parameters', function()
        local start, _end, count = 1, 11, 4
        local cut = function() func(start, _end, count) end
        
        assert.has_error(cut)

        start, _end, count = 1, 12, 4
        assert_values_are_far_enough_apart(func(start, _end, count), 1)
    end)
end)