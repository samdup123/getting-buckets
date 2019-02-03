describe('menu engine', function()
    local mach = require'mach'
    local menu = {
        click_occurred = function() end,
        get_current_screen = function() end
    }
    local menu_mock1 = mach.mock_table(menu, 'menu1')
    local menus = {menu_mock1}
    local menu_engine = require'menu_engine'(menus)

    it('should pass click events', function() 
        menu_mock1.click_occurred:should_be_called_with('blah'):when(
            function() menu_engine.pass_click_event('blah') end
        )
    end)

    it('should get screen from menu', function() 
        local screen
        menu_mock1.get_current_screen:should_be_called():and_will_return('bluh'):when(
            function() screen = menu_engine.get_current_screen() end
        )

        assert.are.same(screen, 'bluh')
    end)
end)