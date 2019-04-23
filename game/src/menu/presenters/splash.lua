local check_click = require'menu/check_click'

local logo = {
    x = 25,
    y = 25,
    image = 'logo'
}

local background = {
    x = 100,
    y = 100,
    image = 'background'
}

return function(release_event, datamodel)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    return {
    get_current_screen = function()
        return {drawables = {
            -- background,
            logo
        }}
    end,
    click_occurred = function(click)
    end
    }
end
