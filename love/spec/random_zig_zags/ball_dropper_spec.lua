describe('random zig zag ball dropper', function() 
    local ball_dropper = require'random_zig_zags/ball_dropper'

    it('should work', function()
        local number_of_chutes = 10
        local number_of_balls_to_drop = 150
        local number_of_zig_zags = 4
        local tocks_between_zig_zags = 11
        local random = math.random
        local gantt = ball_dropper(
            number_of_chutes,
            number_of_balls_to_drop, 
            number_of_zig_zags, 
            tocks_between_zig_zags, 
            random
        )

        for i = 1, #gantt do
            -- print('fart', gantt[i])
        end
    end)
end)