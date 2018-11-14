describe('random number look', function()
    local mach = require'mach'
    local Rand = require'random_number_look'

    it('should work with one call that is closer to 1', function()
        local f = mach.mock_function('f')

        local rand = Rand(10, 9, f)

        f:should_be_called_with(10):and_will_return(4):when(function() rand() end)
        f:should_be_called_with(5, 10):when(function() rand() end)
    end)

    it('should work with one call that is closer to max', function()
        local f = mach.mock_function('f')

        local rand = Rand(10, 9, f)

        f:should_be_called_with(10):and_will_return(6):when(function() rand() end)
        f:should_be_called_with(5):when(function() rand() end)
    end)

    it('should work with multiple calls', function()
        local f = mach.mock_function('f')

        local rand = Rand(10, 9, f)

        f:should_be_called_with(10):and_will_return(6):when(function() rand() end)
        f:should_be_called_with(5):and_will_return(3):when(function() rand() end)
        f:should_be_called_with(4, 10):and_will_return(8):when(function() rand() end)
        f:should_be_called_with(7):and_will_return(1):when(function() rand() end)
        f:should_be_called_with(2, 9):and_will_return(6):when(function() rand() end)
    end)

    it('should never allow consecutive numbers to span the range of numbers (range_max to one)', function()
        local f = mach.mock_function('f')

        local rand = Rand(10, 9, f)

        f:should_be_called_with(10):and_will_return(10):when(function() rand() end)
        f:should_be_called_with(2, 9):when(function() rand() end)
    end)

    it('should never allow consecutive numbers to span the range of numbers (one to range_max)', function()
        local f = mach.mock_function('f')

        local rand = Rand(10, 9, f)

        f:should_be_called_with(10):and_will_return(1):when(function() rand() end)
        f:should_be_called_with(2, 9):when(function() rand() end)
    end)
end)