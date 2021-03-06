-- local Chutes = require'chutes'
-- local Ball_Dropper = require'ball_dropper_random'
-- local ApproximatelySequentialRandom = require'random_number_approximately_sequential'
-- local Bucket = require'bucket'
-- local game_player = require'game_player'

-- return function(player_function)

--     local number_of_chutes = 40
--     local length_of_chutes = 5
--     local number_of_balls_that_will_fall = 2000
--     local tocks_between_drops = 9
--     local starting_chute = 14

--     local chutes = Chutes(number_of_chutes, length_of_chutes)
--     local random_func = ApproximatelySequentialRandom(number_of_chutes, 7, 1, starting_chute, math.random)
--     local ball_dropper = Ball_Dropper(random_func, number_of_chutes, number_of_balls_that_will_fall, tocks_between_drops)
--     local bucket = Bucket(number_of_chutes, starting_chute)
--     local controller = bucket.controller()

--     local player_coroutine = coroutine.create(player_function)
--     local status, err
--     local played_at_least_once = false
--     function run_user_code(debug)
--         if not played_at_least_once then
--             status, err = coroutine.resume(player_coroutine, controller, debug)
--         else
--             status, err = coroutine.resume(player_coroutine)
--         end
--         if not status and err:sub(1,1) ~= 'c' then 
--             print('ERROR!!!\n\t' .. err)
--         end
--         played_at_least_once = true
--     end

--     local game_history, board_info, player_won = game_player(ball_dropper, chutes, bucket, run_user_code)

--     local history_of_losses = require('game_history_parser')(game_history, 28)

--     -- for i = 1, 29 do
--     --     local moment = history_of_losses[i]
--     --     io.write('i' .. moment.moment_number .. ' ')
--     --     io.write('bucketpos' .. moment.bucket_position)
--     --     if #moment.balls_in_play > 0 then
--     --         io.write(' ball' .. moment.balls_in_play[1].chute .. ':' .. moment.balls_in_play[1].location .. ' ')
--     --     end
--     --     io.write(' ' .. (moment.debug or ''))
--     --     io.write('\n')
--     -- end

--     return game_history, board_info, player_won
-- end
