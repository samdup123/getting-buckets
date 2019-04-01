describe('engine', function()
    local Engine = require'game/engine'
    local mach = require'mach'
    local datamodel = mach.mock_table({read = function() end, write = function() end}, 'datamodel')
    local player = mach.mock_function('player')

    local bucket = mach.mock_table({ controller = function() end}, 'bucket')
    local user_code_string = "return function() return 'user function!' end"

    it('should work', function()
        local env = {
            ball_dropper = 'ball_dropper!',
            chutes = 'chutes!',
            bucket = bucket
        }

        local engine = Engine(player, datamodel)

        datamodel.read.should_be_called_with('current level environment').and_will_return(env)
        .and_also(bucket.controller.should_be_called().and_will_return('controller'))
        .and_also(datamodel.read.should_be_called_with('current user code').and_will_return(user_code_string))
        .and_also(player.should_be_called_with('ball_dropper!', 'chutes!', bucket, mach.any)
            .and_will_return(14, 15, 16))
        .and_also(datamodel.write.should_be_called_with('current game history', 14))
        .and_also(datamodel.write.should_be_called_with('player won last game', 16))
        .when(
            function() engine.game_play_requested() end
        )
    end)
end)
