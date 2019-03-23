return function(player, datamodel)
    return {
        game_play_requested = function()
            local env = datamodel.read('current level environment')
            local history, chutes_info, player_won_game = player(
                env.ball_dropper,
                env.chutes,
                env.bucket,
                env.user_function
            )
            datamodel.write('current game history', history)
            datamodel.write('player won last game', player_won_game)
        end
    }
end
