describe('random number look', function()
    local mach = require'mach'
    local Rand = require'game/random_number_look'
    local f = mach.mock_function('f')

    it('should work with one call that is closer to 1', function()
        local rand = Rand(10, 9, f)

        f.should_be_called_with(10).and_will_return(4).when(function() rand() end)
        f.should_be_called_with(5, 10).when(function() rand() end)
    end)

    it('should work with one call that is closer to 1 (again)', function()
        local rand = Rand(10, 4, f)

        f.should_be_called_with(10).and_will_return(2).when(function() rand() end)
        f.should_be_called_with(3, 6).when(function() rand() end)
    end)

    it('should work with one call that is closer to max', function()
        local rand = Rand(10, 9, f)

        f.should_be_called_with(10).and_will_return(6).when(function() rand() end)
        f.should_be_called_with(5).when(function() rand() end)
    end)

    it('should work with one call that is closer to max (again)', function()
        local rand = Rand(10, 4, f)

        f.should_be_called_with(10).and_will_return(8).when(function() rand() end)
        f.should_be_called_with(4, 7).when(function() rand() end)
    end)

    it('should work with multiple calls', function()
        local rand = Rand(10, 8, f)

        f.should_be_called_with(10).and_will_return(6).when(function() rand() end)
        f.should_be_called_with(5).and_will_return(3).when(function() rand() end)
        f.should_be_called_with(4, 10).and_will_return(8).when(function() rand() end)
        f.should_be_called_with(7).and_will_return(1).when(function() rand() end)
        f.should_be_called_with(2, 9).and_will_return(6).when(function() rand() end)
    end)

    it('should work with multiple calls (with a smaller range', function()
        local rand = Rand(10, 4, f)

        f.should_be_called_with(10).and_will_return(6).when(function() rand() end)
        f.should_be_called_with(2, 5).and_will_return(3).when(function() rand() end)
        f.should_be_called_with(4, 7).and_will_return(7).when(function() rand() end)
        f.should_be_called_with(3, 6).and_will_return(5).when(function() rand() end)
        f.should_be_called_with(6, 9).and_will_return(8).when(function() rand() end)
    end)
end)