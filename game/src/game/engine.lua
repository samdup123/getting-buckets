return function(player, datamodel)
    return {
        game_play_requested = function()
            local env = datamodel.read('current level environment')
            local controller = env.bucket.controller()
            local user_function = datamodel.read('current user code')

            local history, chutes_info, player_won_game = player(
                env.ball_dropper,
                env.chutes,
                env.bucket,
                user_function or (function() end)
            )
            datamodel.write('current game history', history)
            datamodel.write('player won last game', player_won_game)
        end
    }
end
