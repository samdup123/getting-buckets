return function(ball_dropper, chutes, bucket, user_function_generator)

    local balls_in_play, balls_exiting, bucket_position

    local player_won_game = true
    local history = {}

    function bucket_is_under(chute_num)
        return chute_num == bucket_position
    end

    local user_output = ''
    local function debug_function(...)
        local args = {...}
        for _,arg in ipairs(args) do
            user_output = user_output .. arg
        end
    end

    table.insert(history, {
        balls_in_play = {},
        bucket_position = bucket.initial_position(),
        lost_balls = {},
    })

    local function remove_balls_that_were_caught(balls_exiting, catching_position)
        for i = #balls_exiting, 1, -1 do
            if balls_exiting[i] == catching_position then
                table.remove(balls_exiting, i)
            end
        end
    end

    local function player_loses_game_if_any_balls_are_left(balls_exiting)
        if #balls_exiting > 0 then
            player_won_game = false
        end
    end

    local function player_loses_game_because_of_code_error()
        player_won_game = false
    end

    local user_function
    function tock()
        local game_is_over

        local new_ball = ball_dropper.tock()
        balls_in_play, balls_exiting = chutes.tock(new_ball)
        local old_bucket_position = bucket_position
        bucket_position = bucket.tock(balls_in_play)

        local success, error = xpcall(user_function, debug.traceback)
        if not success then
            player_loses_game_because_of_code_error()
            print('code failure ', error)
            debug_function(error)

            game_is_over = true
        else

            if old_bucket_position == bucket_position then
                remove_balls_that_were_caught(balls_exiting, bucket_position)
            end
            player_loses_game_if_any_balls_are_left(balls_exiting)

            game_is_over = (#balls_in_play == 0 and ball_dropper.done())
        end

        table.insert(history, {
            balls_in_play = balls_in_play,
            bucket_position = bucket_position,
            lost_balls = balls_exiting,
            debug = user_output
        })
        user_output = ''

        return game_is_over
    end

    local done_playing = false
    local status, error = pcall(
        function()
            user_function = user_function_generator(bucket.controller(), debug_function)
        end
    )
    if not status then
        done_playing = true
        history[1].debug = error
    elseif user_function == nil then
        done_playing = true
        history[1].debug = 'User function returned no function. User code must be a function that returns a function'
    end

    while not done_playing do
        done_playing = tock()
    end

    return history, chutes.info(), player_won_game
end
