local check_click = require'check_click'

local game_rectangle = {
    mode = 'fill',
    x = 10,
    y = 10,
    width = 1100,
    height = 700,

    red = 255,
    green = 255,
    blue = 255
}

local console_rectangle = {
    mode = 'fill',
    x = game_rectangle.x + game_rectangle.width + 10,
    y = game_rectangle.y,
    width = 650,
    height = 700,

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

local play_back_button = button(game_rectangle.x + 400, game_rectangle.y + game_rectangle.height + 30)
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

local play_back_triangle_1 = triangle({x = 50, y = 50}, 30, 30, -1, false)
local play_back_triangle_2 = triangle({x = 62.5, y = 50}, 30, 30, -1, true)
local play_back_triangle_3 = triangle({x = 72.5, y = 50}, 30, 30, -1, false)
local play_back_triangle_4 = triangle({x = 85, y = 50}, 30, 30, -1, true)

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
            play_back_button,
            play_back_triangle_1,
            play_back_triangle_2,
            play_back_triangle_3,
            play_back_triangle_4
        }}
    end,
    click_occurred = function(click)
    end
    }
end