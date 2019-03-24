local check_click = require'menu/check_click'

local game_rect = {
    mode = 'fill',
    x = 10,
    y = 10,
    width = 875,
    height = 675,

    red = 255,
    green = 255,
    blue = 255
}

local console_rect = {
    mode = 'fill',
    x = game_rect.x + game_rect.width + 10,
    y = game_rect.y,
    width = 450,
    height = game_rect.height,

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

local play_back_button = button(game_rect.x + 350, game_rect.y + game_rect.height + 30)
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

local speed_bar = {
    mode = 'fill',
    x = game_rect.x + 325,
    y = game_rect.y + game_rect.height + 155,
    width = game_rect.width + console_rect.width - 535,
    height = 15,

    red = 255,
    green = 255,
    blue = 255
}

local speed_toggle = {
    mode = 'fill',
    x = speed_bar.x + 100,
    y = speed_bar.y,
    width = speed_bar.height,
    height = speed_bar.height,

    red = 255,
    blue = 1
}

local chutes_rect = {
    mode = 'fill',
    x = game_rect.x + 10,
    y = game_rect.y + 10,
    width = game_rect.width - 20,
    height = 0,

    red = 1,
    blue = 1
}

local bucket_rect = {
    mode = 'fill',
    x = chutes_rect.x,
    y = 0,
    width = 0,
    height = 0
}

local number_of_chutes
local ball_drop_ammount
local balls = {}
local history
local time_between_frames = .15
local current_timer_token
local current_fame = 0

local datamodel_on_change_callback = function(label, data)
    if label == 'current level environment' then
        number_of_chutes = data.chutes.info().number_of_chutes
        local length_of_chutes = data.chutes.info().length_of_chutes

        local width_of_balls = chutes_rect.width / number_of_chutes

        bucket_rect.width = width_of_balls
        bucket_rect.height = width_of_balls

        chutes_rect.height = game_rect.y + game_rect.height - 40 - width_of_balls
        bucket_rect.y = chutes_rect.y + chutes_rect.height

        ball_drop_ammount = chutes_rect.height / length_of_chutes
    elseif label == 'current game history' then
        history = data
    end
end

local function update_game_frame()
    if history then
        current_fame = current_fame + 1
        balls = {}
        for _,ball in ipairs(history[current_fame].balls_in_play) do
            table.insert(balls,
                {
                    mode = 'fill',
                    r = bucket_rect.width / 2,
                    x = (ball.chute - .5) * bucket_rect.width + chutes_rect.x,
                    y = (ball.location - .5) * ball_drop_ammount + chutes_rect.y,
                    red = 255, green = 255, blue = 255
                }
            )
        end
        bucket_rect.x = (history[current_fame].bucket_position - 1) * bucket_rect.width + chutes_rect.x
    end
end

return function(release_event, datamodel, timer_dispensary)
    datamodel.subscribe_to_on_change(datamodel_on_change_callback)

    local function done_with_screen()
        release_event('menu_event', 'job_complete')
    end

    return {
      get_current_screen = function()
          return {drawables = {
              game_rect,
              console_rect,
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
              compile_label,
              speed_bar,
              speed_toggle,
              chutes_rect,
              bucket_rect,
              unpack(balls)
          }}
      end,
      click_occurred = function(click)
          if check_click(compile_button, click) then
              release_event('game_play_event')
          elseif check_click(play_button, click) then
              current_timer_token = timer_dispensary.repeating(time_between_frames, update_game_frame)
          end
      end
      }
end
