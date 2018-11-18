return function(ball_dropper, chutes, bucket, run_user_code)

    local balls_in_play, balls_exiting, bucket_position

    local player_won_game = true
    local history = {}

    function bucket_is_under(chute_num)
        return chute_num == bucket_position
    end

    local user_debug_string = ''
    local function debug_function(...)
        local args = {...}
        for _,arg in ipairs(args) do
            user_debug_string = user_debug_string .. arg
        end
    end

    table.insert(history, {
        balls_in_play = {},
        bucket_position = bucket.initial_position(),
        lost_balls = {},
    })

    local function remove_balls_that_were_caught(balls_exiting)
        for i = #balls_exiting, 1, -1 do
            if balls_exiting[i] == bucket_position then
                table.remove(balls_exiting, i)
            end
        end
        if #balls_exiting > 0 then 
            player_won_game = false
        end
    end

    function tock()
        local new_ball = ball_dropper.tock()
        balls_in_play, balls_exiting = chutes.tock(new_ball)

        local old_bucket_position = bucket_position
        bucket_position = bucket.tock(balls_in_play)
        run_user_code(debug_function)
        
        if old_bucket_position == bucket_position then
            remove_balls_that_were_caught(balls_exiting)
        end

        table.insert(history, {
            balls_in_play = balls_in_play,
            bucket_position = bucket_position,
            lost_balls = balls_exiting,
            debug = user_debug_string
        })
        user_debug_string = ''

        return (#balls_in_play == 0 and ball_dropper.done())
    end

    local done_playing = false

    while not done_playing do
        done_playing = tock()
    end

    return history, chutes.info(), player_won_game
end