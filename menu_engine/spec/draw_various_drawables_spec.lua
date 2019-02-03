describe('draw various drawables', function()
    local mach = require'mach'
    
    local graphics = {
        rectangle = function() end,
        print = function() end,
        circle = function() end,
        setColor = function() end
    }

    graphics_mocked = mach.mock_table(graphics, 'graphics')

    local draw = require'draw_various_drawables'(graphics_mocked)
    
    it('should correctly draw a rectangle', function()
        local rect = {mode = 'fill', x = 30, y = 40, width = 100, height = 120, red = 2, green = 3, blue = 4, alpha = 5}

        graphics_mocked.setColor:should_be_called_with(2, 3, 4, 5)
        :and_also(graphics_mocked.rectangle:should_be_called_with('fill', 30, 40, 100, 120))
        :when(
            function() draw(rect) end
        )
    end)

    it('should correctly draw text', function()
        local text = {string = 'floop', x = 45, y = 87, red = 3, green = 4, blue = 5, alpha = 6}

        graphics_mocked.setColor:should_be_called_with(3, 4, 5, 6)
        :and_also(graphics_mocked.print:should_be_called_with('floop', 45, 87))
        :when(
            function() draw(text) end
        )
    end)

    it('should correctly draw a circle', function()
        local circle = {mode = 'fill', x = 2, y = 3, r = 4, red = 6, green = 7, blue = 8, alpha = 9}

        graphics_mocked.setColor:should_be_called_with(6, 7, 8, 9)
        :and_also(graphics_mocked.circle:should_be_called_with('fill', 2, 3, 4))
        :when(
            function() draw(circle) end
        )
    end)

    it('should use correct default values for color and alpha', function()
        graphics_mocked.setColor:should_be_called_with(0, 0, 0, 100)
        :and_other_calls_should_be_ignored()
        :when(
            function() draw(nil) end
        )
    end)
end)