local check_click = require'check_click'
local button_rectangle = {mode = 'fill', x = 200, y = 200, width = 100, height = 100, red = 100}
local button_text = {string = 'done', x = 250, y = 250, blue = 100}

return function(release_event)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    return {
    get_current_screen = function()
        return {drawables = {
            button_rectangle,
            button_text
        }}
    end,
    click_occurred = function(click)
        if check_click(button_rectangle, click) then
            done_with_screen()
        end
    end
    }
end