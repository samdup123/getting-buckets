local instantiated = false
local Fsm = require'menu/fsm'

return function (menus)
    if instantiated then error('the menu engine is a singleton') end
    instantiated = true

    local fsm, state

    state = {
        level_selection = {
            entry = function()
                current_menu = menus.level_selection
            end,
            job_complete = function()
                fsm.transition(state.display_file_location)
            end
        },

        display_file_location = {
            entry = function()
                current_menu = menus.display_file_location
            end,
            job_complete = function()
                fsm.transition(state.game)
            end,
        },

        game = {
            entry = function()
                current_menu = menus.game
            end,
            job_complete = function()
                current_menu = menus.null
            end,
        },
    }

    fsm = Fsm(state.level_selection)

    return {
        pass_menu_state_event = function(event) fsm.signal(event) end,
        pass_click_event = function(event) current_menu.click_occurred(event) end,
        get_current_screen = function() return current_menu.get_current_screen() end
    }
end
