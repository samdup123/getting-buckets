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

        datamodel.read.should_be_called_with('current level environment')
        .and_will_return(env)
        .and_also(player.should_be_called_with(env.ball_dropper, env.chutes, env.bucket, env.user_function)
            .and_will_return(14, 15, 16))
        .and_also(datamodel.write.should_be_called_with('current game history', 14))
        .and_also(datamodel.write.should_be_called_with('player won last game', 16))
        .when(
            function() engine.game_play_requested() end
        )
    end)
end)
