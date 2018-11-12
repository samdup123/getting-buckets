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

        local lost_balls = {}
        for _,chute_in_which_ball_exits in ipairs(balls_exiting) do
            if not bucket_is_under(chute_in_which_ball_exits) then
                table.insert(lost_balls, chute_in_which_ball_exits)
                player_won_game = false
            end
        end

        table.insert(history, {
            balls_in_play = balls_in_play,
            bucket_position = bucket_position,
            lost_balls = lost_balls
        })

        print('end game stuff', #balls_in_play, #balls_exiting, ball_dropper.done(), #history)
        if (#balls_in_play == 0 and ball_dropper.done()) then
             print(debug.traceback())
        end

        return (#balls_in_play == 0 and ball_dropper.done())
    end

    local done_playing = false

    while not done_playing do
        done_playing = tock()
        print('done playing', done_playing)
    end

    return history, player_won_game
end