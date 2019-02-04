local instantiated = false

return function (menus)
    if instantiated then error('the menu engine is a singleton') end
    instantiated = true

    local current_menu = menus[1]

    return {
        pass_menu_state_event = function(event) print('hey') end,
        pass_click_event = function(event) current_menu.click_occurred(event) end,
        get_current_screen = function() return current_menu.get_current_screen() end
    }
end
