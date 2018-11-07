describe('random ball dropper', function()
    math.randomseed(os.time())
    local Dropper = require'ball_dropper_random'

    it('should drop a random ball every time', function()
        local number_of_chutes = 10
        local dropper = Dropper(number_of_chutes)

        for i = 1, 10 do
            local chute_in_which_ball_was_dropped = dropper.chute_in_which_ball_was_dropped()
            assert.is_true(1 <= chute_in_which_ball_was_dropped and chute_in_which_ball_was_dropped <= 10)
        end
    end)

    it('should implement tock method but that should do nothing', function()
        local dropper = Dropper(number_of_chutes)
        dropper.tock()
    end)
end)