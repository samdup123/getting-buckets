describe('random number look', function()
    local Rand = require'random_number_look'

    it('should work', function()
        local old_math_random = math.random
        local blah = 1

        math.random = function() return blah end

        local rand = Rand(10, 9)

        for i = 1, 35 do rand() end

        math.random = old_math_random
    end)
end)