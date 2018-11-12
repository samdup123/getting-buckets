describe('game player', function()
    local GamePlayer = require'game_player'
    local BallDropper = require'fakes/ball_dropper'
    local Chutes = require'chutes'
    local Bucket = require'bucket'
    local user_code = require'fakes/user_code'

    it('should play a simple game', function()

        local ball_drop_gantt = 
            {1, {}, {}, 8, {}, 2}
        local ball_dropper = BallDropper(ball_drop_gantt)
        local chutes = Chutes(10, 10)
        local bucket = Bucket(10, 1)

        local user_code_gantt = 
        {'r', '', '', '', '', '', '', '', 'l'}
        local user_code_coroutine = coroutine.create(user_code)
        coroutine.resume(user_code_coroutine, bucket.controller(), user_code_gantt)
        
        local run_user_code = function()
            coroutine.resume(user_code_coroutine)
        end

        history, player_won_game = GamePlayer(ball_dropper, chutes, bucket, run_user_code)
    end)
end)