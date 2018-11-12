describe('game player', function()
    local GamePlayer = require'game_player'
    local BallDropper = require'fakes/ball_dropper'
    local Chutes = require'chutes'
    local Bucket = require'bucket'
    local user_code = require'fakes/user_code'

    it('should play a simple game', function()

        local ball_drop_gantt = 
            {{1,3}, {}, {}, 2, 2, {}, {}, {1,2}}
        local ball_dropper = BallDropper(ball_drop_gantt)
        local chutes = Chutes(10, 2)
        local bucket = Bucket(10, 1)

        local user_code_gantt = 
        {'r', 'l', 'r', 'r'}
        local user_code_coroutine = coroutine.create(user_code)
        coroutine.resume(user_code_coroutine, bucket.controller(), user_code_gantt)
        
        local run_user_code = function()
            coroutine.resume(user_code_coroutine)
        end

        history, player_won_game = GamePlayer(ball_dropper, chutes, bucket, run_user_code)

        local expected_bucket_positions = {1, 2, 1, 2, 3, 3, 3, 3, 3, 3}
        local expected_chute_snapshots = {
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
            {3},
            nil,
            nil,
            {2},
            {2},
            nil,
            nil,
            {1,2}
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
            -- print('')
            i = i + 1
        end
    end)
end)