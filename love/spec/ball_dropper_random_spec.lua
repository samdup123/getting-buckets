describe('random ball dropper', function()
    math.randomseed(os.time())
    local Dropper = require'ball_dropper_random'

    it('should drop a random ball every few tocks', function()
        local number_of_chutes = 10
        local number_of_balls_to_drop = 30
        local tocks_between_drops = 4
        local dropper = Dropper(number_of_chutes, number_of_balls_to_drop, tocks_between_drops)
        
        
        for i = 1, (number_of_balls_to_drop // 2) do

            local chute_in_which_ball_is_dropped = dropper.tock()
            assert.is_true(1 <= chute_in_which_ball_is_dropped and chute_in_which_ball_is_dropped <= number_of_chutes)

            for j = 1,tocks_between_drops do
                assert.is.same({}, dropper.tock())
            end
        end
    end)

    it('should stop dropping balls after a time', function()
        local number_of_chutes = 10
        local number_of_balls_to_drop = 30
        local tocks_between_drops = 0
        local dropper = Dropper(number_of_chutes, number_of_balls_to_drop, tocks_between_drops)

        for i = 1, number_of_balls_to_drop do
            assert.is_false(dropper.done())
            dropper.tock()
        end

        assert.is_true(dropper.done())
        for i = 1,10 do
            assert.is.same({}, dropper.tock())
        end
    end)
end)