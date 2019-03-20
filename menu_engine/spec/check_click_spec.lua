local check_click = require'check_click'

describe('check click', function()

    local area = {x = 25, y = 40, width = 3, height = 12}

    local corners = {{x = 25, y = 40}, {x = 25, y = 52}, {x = 28, y = 40}, {x = 28, y = 52}}
    local center = {x = 26.5, y = 46}
    local way_off_clicks = {{x = 67, y = 34}, {x = 1, y = 1}, {x = 100, y = 100}, {x = 25, y = 39.9}, {x = 24.9, y = 40}}

    it('should correctly check clicks for corners and center', function()
        for _,corner in ipairs(corners) do
            assert.is_true(check_click(area, corner))
        end

        assert.is_true(check_click(area, center))
    end)

    it('should correctly check clicks from outside', function()
        for _,way_off_click in ipairs(way_off_clicks) do
            assert.is_false(check_click(area, way_off_click))
        end
    end)
end)