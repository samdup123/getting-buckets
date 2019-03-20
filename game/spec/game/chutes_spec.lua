describe('chutes', function()

    local Chutes = require'game/chutes'

    it('should know how many chutes it has and how long they are', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        assert.is.same({
                number_of_chutes = number_of_chutes,
                length_of_chutes = length_of_chutes
            }, chutes.info())
    end)

    it('should return no balls to begin with', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local balls_in_play = chutes.tock()
        assert.is.same({}, balls_in_play)
    end)

    it('should allow a ball to be dropped from a tock', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local chute_to_drop_ball = 8
        local balls_in_play = chutes.tock(chute_to_drop_ball)

        assert.is.same({{chute = chute_to_drop_ball, location = 1}}, balls_in_play)
    end)

    it('should allow a ball to be dropped from a tock (when the argument passed into tock is a table)', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local chute_to_drop_ball = 8
        local dropped_balls_in_chute = {chute_to_drop_ball}
        local balls_in_play = chutes.tock(dropped_balls_in_chute)

        assert.is.same({{chute = chute_to_drop_ball, location = 1}}, balls_in_play)
    end)

    it('should move ball down chute as tocks occur', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local chute_to_drop_ball = 4
        local dropped_balls_in_chute = {chute_to_drop_ball}
        
        local balls_in_play = chutes.tock(dropped_balls_in_chute)
        for i = 1, length_of_chutes - 1 do
            assert.is.same({{chute = chute_to_drop_ball, location = i}}, balls_in_play)
            balls_in_play = chutes.tock()
        end
    end)

    it('should have no balls exiting the chutes until the correct time', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local chute_to_drop_ball = 4
        local dropped_balls_in_chute = {chute_to_drop_ball}

        local _,balls_exiting = chutes.tock(dropped_balls_in_chute)

        for i = 1, length_of_chutes do
            assert.is.same({}, balls_exiting)
            _,balls_exiting = chutes.tock()
        end

        assert.is.same({chute_to_drop_ball}, balls_exiting)
        chutes.tock()
        _,balls_exiting = chutes.tock()
        assert.is.same({}, balls_exiting    )
    end)

    it('should be able to move multiple balls down the chutes and drop them at the same time', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local dropped_balls_in_chute = {1, 10}
        local balls_in_play, balls_exiting = chutes.tock(dropped_balls_in_chute)

        for i = 1, length_of_chutes do
            assert.is.same({{chute = 1, location = i}, {chute = 10, location = i}}, balls_in_play)
            balls_in_play, balls_exiting = chutes.tock()
        end

        assert.is.same({}, balls_in_play)
        assert.is.same({1, 10}, balls_exiting)
        balls_in_play, balls_exiting = chutes.tock()
        assert.is.same({}, balls_exiting)
    end)

    it('should be able to move multiple balls down the same chute and drop them at different times', function()
        local number_of_chutes = 10
        local length_of_chutes = 10
        local chutes = Chutes(number_of_chutes, length_of_chutes)

        local balls_in_play, balls_exiting = chutes.tock({1})

        for i = 1, math.floor(length_of_chutes / 2) - 1 do
            balls_in_play, balls_exiting = chutes.tock()
        end

        chutes.tock({1})

        for i = 1, math.ceil(length_of_chutes / 2) do
            balls_in_play, balls_exiting = chutes.tock()
        end

        assert.is.same({1}, balls_exiting)

        for i = 1, math.floor(length_of_chutes / 2) do
            balls_in_play, balls_exiting = chutes.tock()
        end

        assert.is.same({1}, balls_exiting)
    end)
end)