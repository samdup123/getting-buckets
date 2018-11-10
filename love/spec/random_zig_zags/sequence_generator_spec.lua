describe('zig zag sequence generator', function()
    local generate = require'random_zig_zags/sequence_generator'

    it('should create a simple zig zag from the starting edge going away from the edge', function()
        local total_number_of_chutes, number_of_balls_to_drop = 10, 10
        local first_direction = 1
        local starting_chute = 1
        local direction_change_points = {3, 5, 7}

        local actual_gantt = generate(
            total_number_of_chutes,
            number_of_balls_to_drop,
            starting_chute,
            first_direction,
            direction_change_points
        )

        local expected_gantt = {
            1, 2, 3, '', 3, 2, '', 2, 3, '', 3, 2, 1, ''
        --  1, 2, 3,     4, 5,     6, 7      8, 9, 10
        }

        assert.are.same(expected_gantt, actual_gantt)
    end)

    it('should create a simple zig zag from the starting edge going into the edge (the direction should simply be switched to away)', function()
        local total_number_of_chutes, number_of_balls_to_drop = 10, 10
        local first_direction = -1
        local starting_chute = 1
        local direction_change_points = {3, 5, 7}

        local actual_gantt = generate(
            total_number_of_chutes,
            number_of_balls_to_drop,
            starting_chute,
            first_direction,
            direction_change_points
        )

        local expected_gantt = {
            1, 2, 3, '', 3, 2, '', 2, 3, '', 3, 2, 1, ''
        --  1, 2, 3,     4, 5,     6, 7      8, 9, 10
        }

        assert.are.same(expected_gantt, actual_gantt)
    end)

    it('should create a zig zag that has no direction changes', function()
        local total_number_of_chutes, number_of_balls_to_drop = 10, 6
        local first_direction = 1
        local starting_chute = 3
        local direction_change_points = nil

        local actual_gantt = generate(
            total_number_of_chutes,
            number_of_balls_to_drop,
            starting_chute,
            first_direction,
            direction_change_points
        )

        local expected_gantt = {
            3, 4, 5, 6, 7, 8, ''
        --  1, 2, 3, 4, 5, 6
        }

        assert.are.same(expected_gantt, actual_gantt)
    end)

    it('should create a zig zag with one direction changes', function()
        local total_number_of_chutes, number_of_balls_to_drop = 10, 6
        local first_direction = 1
        local starting_chute = 3
        local direction_change_points = {4}

        local actual_gantt = generate(
            total_number_of_chutes,
            number_of_balls_to_drop,
            starting_chute,
            first_direction,
            direction_change_points
        )

        local expected_gantt = {
            3, 4, 5, 6, '', 6, 5, ''
        --  1, 2, 3, 4,     5, 6
        }

        assert.are.same(expected_gantt, actual_gantt)
    end)
end)