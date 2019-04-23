local check_click = require'menu/check_click'
local button_rectangle = {mode = 'fill', x = 200, y = 200, width = 120, height = 80, red = 100}
local button_text = {
    string = 'play',
    font = 'big_font',
    x = button_rectangle.x + (button_rectangle.width / 2),
    y = button_rectangle.y + (button_rectangle.height / 2),
    blue = 100
}
local logo_text = {font = 'big_font', x = 700, y = 100, red = 25, blue = 100}

return function(release_event, datamodel, file_manager)

    local current_file_location
    local function datamodel_on_change(label, data)
        if label == 'current level number' then
            local file_name = 'level' .. data
            current_file_location = file_manager.open(file_name)
            datamodel.write('current file location', file_name)
        end
    end

    datamodel.subscribe_to_on_change(datamodel_on_change)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    local function add_logo(text)
        text.string = 'Getting Buckets'
        return text
    end

    return {
    get_current_screen = function()
        return {drawables = {
            button_rectangle,
            button_text,
            add_logo(logo_text)
        }}
    end,
    click_occurred = function(click)
        if check_click(button_rectangle, click) then
            done_with_screen()
        end
    end
    }
end
