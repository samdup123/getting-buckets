describe('game player', function()
    local GamePlayer = require'game/player'
    local BallDropper = require'game/ball_dropper'
    local Chutes = require'game/chutes'
    local Bucket = require'game/bucket'
    local user_code_fake = require'fakes/user_code'

    it('should play a simple game', function()

        local ball_drop_gantt =
            {{1,3}, {}, {}, 2, 2, {}, {}, {1,2}}
        local ball_dropper = BallDropper(ball_drop_gantt)
        local number_of_chutes, length_of_chutes = 10, 2
        local chutes = Chutes(number_of_chutes, length_of_chutes)
        local bucket = Bucket(number_of_chutes, 1)

        history, board_info, player_won_game = GamePlayer(ball_dropper, chutes, bucket, user_code_fake)

        assert.are.equal(number_of_chutes, board_info.number_of_chutes)
        assert.are.equal(length_of_chutes, board_info.length_of_chutes)

        local expected_bucket_positions = {1, 1, 2, 1, 1, 2, 3, 3, 3, 3, 3, 3}
        local expected_chute_snapshots = {
            nil,
            {
                {chute = 1, location = 1},
                {chute = 3, location = 1}
            },
            {
                {chute = 1, location = 2},
                {chute = 3, location = 2}
            },
            nil,
            {
                {chute = 2, location = 1}
            },
            {
                {chute = 2, location = 1},
                {chute = 2, location = 2}
            },
            {
                {chute = 2, location = 2}
            },
            nil,
            {
                {chute = 1, location = 1},
                {chute = 2, location = 1}
            },
            {
                {chute = 1, location = 2},
                {chute = 2, location = 2}
            },
        }
        local expected_lost_balls = {
            nil,
            nil,
            nil,
            {1, 3},
            nil,
            nil,
            {2},
            {2},
            nil,
            nil,
            {1,2}
        }

        local expected_debug_outputs = {
            nil,
            'hi',
            'hey',
            'hello',
            'howdy',
            'holla'
        }

        local i = 1
        for _,moment in ipairs(history) do
            -- io.write('bucketpos ' .. moment.bucket_position .. '  ')
            assert.are.equal(expected_bucket_positions[i], moment.bucket_position)
            for _,ball in ipairs(moment.balls_in_play) do
                -- io.write(ball.chute .. '-' .. ball.location .. '  ')
            end
            assert.are.same(expected_chute_snapshots[i] or {}, moment.balls_in_play)
            for _,ball in ipairs(moment.lost_balls) do
                -- io.write('lost ' .. ball .. ' ')
            end
            assert.are.same(expected_lost_balls[i] or {}, moment.lost_balls)

            -- io.write('debug ' .. (moment.debug or ''))
            assert.are.same(expected_debug_outputs[i] or '', moment.debug or '')

            -- print('')
            i = i + 1
        end
    end)
end)
