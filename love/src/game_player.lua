return function(ball_dropper, chutes, bucket, run_user_code)

    local balls_in_play, balls_exiting, bucket_position

    local player_won_game = true
    local history = {}

    function bucket_is_under(chute_num)
        return chute_num == bucket_position
    end

    function tock()
        local new_ball = ball_dropper.tock()
        balls_in_play, balls_exiting = chutes.tock(new_ball)
        bucket_position = bucket.tock(balls_in_play)
        run_user_code()

        -- write test case for this? don't know how
        for i = #balls_exiting, 1, -1 do
            if balls_exiting[i] == bucket_position then
                table.remove(balls_exiting, i)
            end
        end

        table.insert(history, {
            balls_in_play = balls_in_play,
            bucket_position = bucket_position,
            lost_balls = balls_exiting
        })

        return (#balls_in_play == 0 and ball_dropper.done())
    end

    local done_playing = false

    while not done_playing do
        done_playing = tock()
    end

    return history, chutes.info(), player_won_game
end