describe('game player', function()
    local GamePlayer = require'game_engine/game_player'
    local BallDropper = require'game_engine/ball_dropper'
    local Chutes = require'game_engine/chutes'
    local Bucket = require'game_engine/bucket'
    local user_code = require'fakes/user_code'

    it('should play a simple game', function()

        local ball_drop_gantt = 
            {{1,3}, {}, {}, 2, 2, {}, {}, {1,2}}
        local ball_dropper = BallDropper(ball_drop_gantt)
        local number_of_chutes, length_of_chutes = 10, 2
        local chutes = Chutes(number_of_chutes, length_of_chutes)
        local bucket = Bucket(number_of_chutes, 1)

        local user_code_gantt = 
        {'r', 'l', '', 'r', 'r'}
        local user_code_debug_gantt = 
        {'hi', 'hey', 'hello', 'howdy', 'holla'}

        local user_code_coroutine = coroutine.create(user_code)

        local played_at_least_once = false
        local function run_user_code(debug_function)
            if not played_at_least_once then
                status, err = coroutine.resume(user_code_coroutine, bucket.controller(), debug_function, user_code_gantt, user_code_debug_gantt)
            else
                status, err = coroutine.resume(user_code_coroutine)
            end
            if not status and err:sub(1,1) ~= 'c' then 
                print('ERROR!!!\n\t' .. err)
            end
            played_at_least_once = true
        end

        history, board_info, player_won_game = GamePlayer(ball_dropper, chutes, bucket, run_user_code)

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