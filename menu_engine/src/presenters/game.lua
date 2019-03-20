local check_click = require'check_click'

local game_rectangle = {
    mode = 'fill',
    x = 10,
    y = 10,
    width = 1100,
    height = 875,

    red = 255,
    green = 255,
    blue = 255
}

local console_rectangle = {
    mode = 'fill',
    x = game_rectangle.x + game_rectangle.width + 10,
    y = game_rectangle.y,
    width = 650,
    height = game_rectangle.height,

    red = 255,
    green = 255,
    blue = 255
}

local button = function(x,y) 
    return {
        mode = 'fill',
        x = x,
        y = y,
        width = 100,
        height = 100,

        red = 255,
        green = 255,
        blue = 255
    }
end

local play_back_button = button(game_rectangle.x + 500, game_rectangle.y + game_rectangle.height + 30)
local step_back_button = button(play_back_button.x + play_back_button.width + 30, play_back_button.y)
local pause_button = button(step_back_button.x + step_back_button.width + 30, play_back_button.y)
local compile_button = button(pause_button.x + pause_button.width + 30, play_back_button.y)
local step_button = button(compile_button.x + compile_button.width + 30, play_back_button.y)
local play_button = button(step_button.x + step_button.width + 30, play_back_button.y)

local triangle = function(top_corner, height, width, direction, white)
    return {
        mode = 'fill',

        x1 = top_corner.x,
        y1 = top_corner.y,

        x2 = top_corner.x,
        y2 = top_corner.y + height,

        x3 = top_corner.x + (direction * width),
        y3 = top_corner.y + (height/2),

        red   = white and 255 or nil,
        green = white and 255 or nil,
        blue  = white and 255 or nil,
    }
end

local height_of_icons = 30
local width_of_icons = 30
local pause_button_rectangle_1 = {
    mode = 'fill',
    x = pause_button.x + (pause_button.width/2) - (width_of_icons/2),
    y = pause_button.y + (pause_button.height/2) - (height_of_icons/2),
    width = width_of_icons/3,
    height = height_of_icons,
}

local pause_button_rectangle_2 = {
    mode = 'fill',
    x = pause_button_rectangle_1.x + pause_button_rectangle_1.width + (width_of_icons/3),
    y = pause_button_rectangle_1.y,
    width = width_of_icons / 3,
    height = height_of_icons,
}

local function center_x(area) return area.x + area.width/2 end
local function center_y(area) return area.y + area.height/2 end

local center_x_pb_button = center_x(play_back_button)
local center_y_pb_button = center_y(play_back_button) - height_of_icons/2

local play_back_triangle_1 = triangle({x = center_x_pb_button, y = center_y_pb_button}, width_of_icons, height_of_icons, -1, false)
local play_back_triangle_2 = triangle({x = center_x_pb_button + 12.5, y = center_y_pb_button}, width_of_icons, height_of_icons, -1, true)
local play_back_triangle_3 = triangle({x = center_x_pb_button + 22.5, y = center_y_pb_button}, width_of_icons, height_of_icons, -1, false)
local play_back_triangle_4 = triangle({x = center_x_pb_button + 35, y = center_y_pb_button}, width_of_icons, height_of_icons, -1, true)

local center_x_p_button = center_x(play_button) - 32.5
local center_y_p_button = center_y(play_button) - height_of_icons/2

local play_triangle_1 = triangle({x = center_x_p_button, y = center_y_p_button}, width_of_icons, height_of_icons, 1, true)
local play_triangle_2 = triangle({x = center_x_p_button + 12.5, y = center_y_p_button}, width_of_icons, height_of_icons, 1, false)
local play_triangle_3 = triangle({x = center_x_p_button + 22.5, y = center_y_p_button}, width_of_icons, height_of_icons, 1, true)
local play_triangle_4 = triangle({x = center_x_p_button + 35, y = center_y_p_button}, width_of_icons, height_of_icons, 1, false)

local center_x_sb_button = center_x(step_back_button) + width_of_icons/2
local center_y_sb_button = center_y(step_back_button) - height_of_icons/2

local step_back_triangle = triangle({x = center_x_sb_button, y = center_y_sb_button}, width_of_icons, height_of_icons, -1, false)

local center_x_s_button = center_x(step_button) - width_of_icons/2
local center_y_s_button = center_y(step_button) - height_of_icons/2

local step_triangle = triangle({x = center_x_s_button, y = center_y_s_button}, width_of_icons, height_of_icons, 1, false)

local compile_label = {
    string = 'compile',
    font = 'main_font',
    x = center_x(compile_button),
    y = center_y(compile_button)
}

return function(release_event, datamodel)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    return {
    get_current_screen = function()
        return {drawables = {
            game_rectangle,
            console_rectangle,
            play_back_button,
            step_back_button,
            pause_button,
            compile_button,
            step_button,
            play_button,
            pause_button_rectangle_1,
            pause_button_rectangle_2,
            play_back_triangle_1,
            play_back_triangle_2,
            play_back_triangle_3,
            play_back_triangle_4,
            play_triangle_4,
            play_triangle_3,
            play_triangle_2,
            play_triangle_1,
            step_back_triangle,
            step_triangle,
            compile_label
        }}
    end,
    click_occurred = function(click)
    end
    }
end