local check_click = require'check_click'
local level_number_rectangle = 
    function(number, x, y, width, height) 
        local box = {mode = 'fill', x = x, y = y, width = width, height = height, red = 100}
        local label = {
            string = tostring(number),
            font = 'main_font',
            x = x + (width / 2),
            y = y + (height / 2)
        }
        return box, label
    end

local level_number_width = 100
local level_number_height = 100
local level_1_box, one = level_number_rectangle(1, 100, 200, level_number_width, level_number_height)
local level_2_box, two = level_number_rectangle(2, 300, 200, level_number_width, level_number_height)
local level_3_box, three = level_number_rectangle(3, 500, 200, level_number_width, level_number_height)

local boxes = {
    level_1_box,
    level_2_box,
    level_3_box
}

local drawables = {
    level_1_box, one,
    level_2_box, two,
    level_3_box, three
}

return function(release_event, datamodel)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    return {
    get_current_screen = function()
        return {drawables = drawables}
    end,
    click_occurred = function(click)
        for _,box in ipairs(boxes) do
            if check_click(box, click) then
                done_with_screen()
            end
        end
    end
    }
end