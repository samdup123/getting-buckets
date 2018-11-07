describe('random ball dropper', function()
    math.randomseed(os.time())
    local Dropper = require'ball_dropper_random'

    it('should drop a random ball every time', function()
        local number_of_chutes = 10
        local number_of_balls_to_drop = 30
        local dropper = Dropper(number_of_chutes, number_of_balls_to_drop)

        for i = 1, 10 do
            local chutes_in_which_balls_are_dropped = dropper.tock()
            assert.is_true(1 <= chutes_in_which_balls_are_dropped and chutes_in_which_balls_are_dropped <= 10)
        end
    end)

    it('should implement tock method but that should do nothing', function()
        local number_of_chutes = 10
        local number_of_balls_to_drop = 30
        local dropper = Dropper(number_of_chutes, number_of_balls_to_drop)

        for i = 1, number_of_balls_to_drop do
            dropper.tock()
        end

        assert.is.same({}, dropper.tock())
    end)
end)