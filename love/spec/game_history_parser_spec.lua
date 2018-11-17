describe('game history parser', function()
    local parser = require'game_history_parser'

    local game_history = {
        {
            bucket_position = 4,
            balls_in_play = {
                {chute = 1, location = 1},
            }
        },
        {
            bucket_position = 5,
            balls_in_play = {
                {chute = 1, location = 2},
                {chute = 3, location = 1},
            }
        },
        {
            bucket_position = 6,
            balls_in_play = {
                {chute = 1, location = 3},
                {chute = 3, location = 2},
            }
        },
        {
            bucket_position = 7,
            balls_in_play = {
                {chute = 1, location = 4},
                {chute = 3, location = 3},
            },
        },
        {
            bucket_position = 8,
            balls_in_play = {
                {chute = 3, location = 4},
            },
            lost_balls = {1}
        },
        {
            bucket_position = 9,
            balls_in_play = {},
            lost_balls = {3}
        }
    }

    it('should work', function()
        local partial_game_history = {
            {
                bucket_position = 6,
                balls_in_play = {
                    {chute = 1, location = 3},
                    {chute = 3, location = 2},
                }
            },
            {
                bucket_position = 7,
                balls_in_play = {
                    {chute = 1, location = 4},
                    {chute = 3, location = 3},
                },
            },
            {
                bucket_position = 8,
                balls_in_play = {
                    {chute = 3, location = 4},
                },
                lost_balls = {1}
            },
            {
                bucket_position = 9,
                balls_in_play = {},
                lost_balls = {3}
            }
        }

        assert.are.same(partial_game_history, parser(game_history, 2))
    end)


end)