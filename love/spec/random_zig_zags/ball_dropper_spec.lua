describe('ball dropper', function() 
    local ball_dropper = require'random_zig_zags/ball_dropper'

    it('should work', function()
        local number_of_chutes = 10
        local number_of_balls_to_drop = 36
        local number_of_zig_zags = 4
        local approximate_balls_per_zig_zag = 9
        local tocks_between_zig_zags = 11
        local random = math.random
        local gantt = ball_dropper(
            number_of_chutes,
            number_of_balls_to_drop, 
            number_of_zig_zags, 
            approximate_balls_per_zig_zag, 
            tocks_between_zig_zags, 
            random
        )

        for i = 1, #gantt do
            print(gantt[i])
        end
    end)
end)