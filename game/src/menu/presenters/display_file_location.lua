local check_click = require'menu/check_click'
local button_rectangle = {mode = 'fill', x = 200, y = 200, width = 100, height = 100, red = 100}
local button_text = {string = 'done', font = 'main_font', x = 250, y = 250, blue = 100}
local file_location_text = {font = 'main_font', x = 400, y = 100, red = 25, blue = 100}

return function(release_event, datamodel, file_manager)

    local current_file_location
    local function datamodel_on_change(label, data)
        if label == 'current level number' then
            current_file_location = file_manager.open('level' .. data .. '.lua')
        end
    end

    datamodel.subscribe_to_on_change(datamodel_on_change)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    local function add_file_location(text)
        text.string = 'Your file is located at ' .. (current_file_location or '')
        return text
    end

    return {
    get_current_screen = function()
        return {drawables = {
            button_rectangle,
            button_text,
            add_file_location(file_location_text)
        }}
    end,
    click_occurred = function(click)
        if check_click(button_rectangle, click) then
            done_with_screen()
        end
    end
    }
end
