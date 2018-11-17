describe('game history parser', function()
    local parser = require'game_history_parser'

    local game_history = {
        {
            bucket_position = 2,
            balls_in_play = {chute = 1, location = 1}
        },
        {
            bucket_position = 2,
            balls_in_play = {chute = 1, location = 2}
        },
        {
            bucket_position = 2,
            balls_in_play = {chute = 1, location = 3}
        },
        {
            bucket_position = 2,
            balls_in_play = {chute = 1, location = 4}
        },
        {
            bucket_position = 2,
            balls_in_play = {},
            lost_balls = {1}
        }
    }

    it('should work with one lost ball', function()
        local partial_game_history = {
            {
                bucket_position = 2,
                balls_in_play = {chute = 1, location = 3}
            },
            {
                bucket_position = 2,
                balls_in_play = {chute = 1, location = 4}
            },
            {
                bucket_position = 2,
                balls_in_play = {},
                lost_balls = {1}
            }
        }

        assert.are.same(partial_game_history, parser(game_history, 2))
    end)
end)