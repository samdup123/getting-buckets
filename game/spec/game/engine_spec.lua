describe('engine', function()
    local Engine = require'game/engine'
    local mach = require'mach'
    local datamodel = mach.mock_table({read = function() end, write = function() end}, 'datamodel')
    local player = mach.mock_function('player')

    it('should work', function()
        local env = {
            ball_dropper = 'ball_dropper',
            chutes = 'chutes',
            bucket = 'bucket',
            user_function = 'user_function',
        }

        local engine = Engine(player, datamodel)

        datamodel.read.should_be_called_with('current_game_environment')
        .and_will_return(env)
        .and_also(player.should_be_called_with(env.ball_dropper, env.chutes, env.bucket, env.user_function)
            .and_will_return('history', 'info', 'player_won'))
        .and_also(datamodel.write.should_be_called_with('current_game_history', 'history'))
        .and_also(datamodel.write.should_be_called_with('player_won_last_game', 'player_won'))
        .when(
            function() engine.game_play_requested() end
        )
    end)
end)