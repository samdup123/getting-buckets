local instantiated = false
local Fsm = require'fsm'

return function (menus)
    if instantiated then error('the menu engine is a singleton') end
    instantiated = true

    local state = {
        display_file_location = {
            entry = function()
                current_menu = menus.display_file_location
            end,
            job_complete = function()
                current_menu = menus.null
            end,
        },
    }

    local fsm = Fsm(state.display_file_location)

    return {
        pass_menu_state_event = function(event) fsm.signal(event) end,
        pass_click_event = function(event) current_menu.click_occurred(event) end,
        get_current_screen = function() return current_menu.get_current_screen() end
    }
end
