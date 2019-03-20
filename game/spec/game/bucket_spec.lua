describe('bucket', function()
    local Bucket = require'game/bucket'

    it('should return initial position until time is passed', function()
        local number_of_chutes = 10
        local starting_chute = 4
        local bucket = Bucket(number_of_chutes, starting_chute)
        assert.is.equal(starting_chute, bucket.initial_position())
    end)

    it('should return current position on a tock', function()
        local number_of_chutes = 10
        local starting_chute = 4
        local bucket = Bucket(number_of_chutes, starting_chute)
        assert.is.equal(starting_chute, bucket.tock())
    end)

    it('should be able to move left', function()
        local number_of_chutes = 10
        local starting_chute = 3
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        controller.move_left()

        assert.is.equal(starting_chute - 1, bucket.tock())
    end)

    it('should be able to move right', function()
        local number_of_chutes = 10
        local starting_chute = 3
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        controller.move_right()

        assert.is.equal(starting_chute + 1, bucket.tock())
    end)

    it('should not be able to move left when the bucket is at the leftmost chute', function()
        local number_of_chutes = 10
        local starting_chute = 1
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        assert.has.errors(function() controller.move_left() end)
    end)

    it('should not be able to move right when the bucket is at the rightmost chute', function()
        local number_of_chutes = 10
        local starting_chute = 10
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        assert.has.errors(function() controller.move_right() end)
    end)

    it('should offer current position to the controller', function()
        local number_of_chutes = 10
        local starting_chute = 4
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        assert.is.equal(starting_chute, controller.current_chute())
        controller.move_right()
        assert.is.equal(starting_chute + 1, controller.current_chute())
    end)

    it('should offer number of chutes to the controller', function()
        local number_of_chutes = 10
        local starting_chute = 4
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        assert.is.equal(number_of_chutes, controller.number_of_chutes())
    end)

    it('should have singleton controller', function()
        local number_of_chutes = 10
        local starting_chute = 10
        local bucket = Bucket(number_of_chutes, starting_chute)
        assert.are.same(bucket.controller(), bucket.controller())
    end)

    it('should not be able to move more than once between tocks', function()
        local number_of_chutes = 10
        local starting_chute = 3
        local bucket = Bucket(number_of_chutes, starting_chute)
        local controller = bucket.controller()

        controller.move_right()
        assert.has.errors(function() controller.move_right() end)

        bucket.tock()

        controller.move_left()
        assert.has.errors(function() controller.move_left() end)
    end)

    it('should correctly report whether or not a ball is in the chute it is under', function()
        local number_of_chutes = 10
        local starting_chute = 8
        local bucket = Bucket(number_of_chutes, starting_chute)

        bucket.tock({{chute = starting_chute}})

        local controller = bucket.controller()
        assert.is.equal(true, controller.ball_in_chute())

        controller.move_left()
        bucket.tock({{chute = starting_chute}})
        assert.is.equal(false, controller.ball_in_chute())
    end)

    it('should not allow the controller to move and then check if a ball is in the chute in the same tock', function()
        local number_of_chutes = 10
        local starting_chute = 8
        local bucket = Bucket(number_of_chutes, starting_chute)

        local controller = bucket.controller()

        controller.move_left()
        assert.has.errors(function() controller.ball_in_chute() end)
    end)
end)