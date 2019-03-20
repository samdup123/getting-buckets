describe('draw various drawables', function()
    local mach = require'mach'
    
    local graphics = {
        rectangle = function() end,
        print = function() end,
        circle = function() end,
        polygon = function() end,
        setColor = function() end,
        setFont = function() end
    }

    local font = {}
    function font.getWidth() end
    function font.getHeight() end
    local font_mock = mach.mock_object(font, 'font')
    local fonts = {['flip'] = font_mock}
    local graphics_mock = mach.mock_table(graphics, 'graphics')

    local draw = require'menu/draw_various_drawables'(graphics_mock, fonts)
    
    it('should correctly draw a rectangle', function()
        local rect = {mode = 'fill', x = 30, y = 40, width = 100, height = 120, red = 2, green = 3, blue = 4, alpha = 5}

        graphics_mock.setColor.should_be_called_with(2, 3, 4, 5)
        .and_also(graphics_mock.rectangle.should_be_called_with('fill', 30, 40, 100, 120))
        .when(
            function() draw(rect) end
        )
    end)

    it('should correctly draw text', function()
        local text = {string = 'floop', font = 'flip', x = 45, y = 87, red = 3, green = 4, blue = 5, alpha = 6}

        graphics_mock.setColor.should_be_called_with(3, 4, 5, 6)
        .and_also(graphics_mock.setFont.should_be_called_with(font_mock))
        .and_also(font_mock.getWidth.should_be_called_with('floop').and_will_return(64))
        .and_also(font_mock.getHeight.should_be_called().and_will_return(66))
        .and_also(graphics_mock.print.should_be_called_with('floop', 45, 87, nil, nil, nil, 64/2, 66/2))
        .when(
            function() draw(text) end
        )
    end)

    it('should correctly draw a circle', function()
        local circle = {mode = 'fill', x = 2, y = 3, r = 4, red = 6, green = 7, blue = 8, alpha = 9}

        graphics_mock.setColor.should_be_called_with(6, 7, 8, 9)
        .and_also(graphics_mock.circle.should_be_called_with('fill', 2, 3, 4))
        .when(
            function() draw(circle) end
        )
    end)

    it('should correctly draw a polygon', function()
        local polygon = {
            mode = 'fill',
            x1 = 1,
            y1 = 2,
            x2 = 3,
            y2 = 4,
            x3 = 5,
            y3 = 6,
            red = 7,
            green = 8,
            blue = 9,
            alpha = 10
        }

        graphics_mock.setColor.should_be_called_with(7, 8, 9, 10)
        .and_also(graphics_mock.polygon.should_be_called_with('fill', 1, 2, 3, 4, 5, 6))
        .when(
            function() draw(polygon) end
        )
    end)

    it('should use correct default values for color and alpha', function()
        graphics_mock.setColor.should_be_called_with(0, 0, 0, 100)
        .and_other_calls_should_be_ignored()
        .when(
            function() draw(nil) end
        )
    end)
end)