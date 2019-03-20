return function(player, datamodel)
    return {
        game_play_requested = function()
            local env = datamodel.read('current_game_environment')
            local history, chutes_info, player_won_game = player(
                env.ball_dropper,
                env.chutes,
                env.bucket,
                env.user_function
            )
            datamodel.write('current_game_history', history)
            datamodel.write('player_won_last_game', player_won_game)
        end
    }
end