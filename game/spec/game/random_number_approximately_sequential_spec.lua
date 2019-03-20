describe('random number approximately sequential', function()
    local Random = require'game/random_number_approximately_sequential'
    local mach = require'mach'

    local f = mach.mock_function('f')

    it('should work', function()
        local max, approximate_seq, band, starting_num = 20, 7, 1, 11
        local rand = Random(max, approximate_seq, band, starting_num, f)

        local new_val
        new_val = rand()
        assert.are.equal(11, new_val)

        f.should_be_called_with(6, 8).and_will_return(7).when(function() new_val = rand() end)
        assert.are.equal(18, new_val)

        f.should_be_called_with(6, 8).and_will_return(8).when(function() new_val = rand() end)
        assert.are.equal(14, new_val)

        f.should_be_called_with(6, 8).and_will_return(6).when(function() new_val = rand() end)
        assert.are.equal(8, new_val)

        f.should_be_called_with(6, 8).and_will_return(6).when(function() new_val = rand() end)
        assert.are.equal(2, new_val)

        f.should_be_called_with(6, 8).and_will_return(6).when(function() new_val = rand() end)
        assert.are.equal(6, new_val)

        f.should_be_called_with(6, 8).and_will_return(6).when(function() new_val = rand() end)
        assert.are.equal(12, new_val)

        f.should_be_called_with(6, 8).and_will_return(7).when(function() new_val = rand() end)
        assert.are.equal(19, new_val)

        f.should_be_called_with(6, 8).and_will_return(7).when(function() new_val = rand() end)
        assert.are.equal(14, new_val)
    end)
end)