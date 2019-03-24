love.window.setFullscreen(true)

-- set the package path to collect source code
package.path = '/Users/samduplessis/APLACE/getting-buckets/game/src/?.lua;' .. package.path

local main_font = love.graphics.newFont(24)
local draw = require'menu/draw_various_drawables'(love.graphics, {main_font = main_font})
local datamodel = require'datamodel/volatile'(
  {
    'current file location',
    {'current window size',
      {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
      }},
     'current user code',
     'current level environment',
     'current game history',
     'player won last game',
     {'time', 0}
  }
)

local menu_engine = require'menu/engine'({
    display_file_location = require'menu/presenters/display_file_location'(function(...) love.event.push(...) end, datamodel),
    level_selection = require'menu/presenters/level_selection'(function(...) love.event.push(...) end, datamodel),
    game = require'menu/presenters/game'(function(...) love.event.push(...) end, datamodel),
    null = require'menu/presenters/null'
})

local game_engine = require'game/engine'(require'game/player', datamodel)

math.randomseed(os.time())

local current_user_code =
    [[return function(controller, debug)
        local current_chute = controller.current_chute()
        local last_chute = controller.number_of_chutes()
        local direction_of_movement = 'left'

        local function move()
            controller['move_' .. direction_of_movement]()
        end

        return function()
            if current_chute == 1 then
                direction_of_movement = 'right'
            elseif current_chute == last_chute then
                direction_of_movement = 'left'
            end

            if not controller.ball_in_chute() then
                move()
            end
            current_chute = controller.current_chute()
        end
    end]]

function love.load(arg)
  datamodel.write('current file location', '/sam/homie-zone/level1_code.lua')

  love.handlers.menu_event = love.menu_event
  love.handlers.game_play_event = love.game_play_event

  datamodel.write('current user code', current_user_code)
  local random_level_environment = require'levels/random/environment'
  local user_function = load(current_user_code)()
  local env = random_level_environment(user_function)
  datamodel.write('current level environment', env)
end


local time = 0
local last_time = time
function love.update(dt)
    time = time + dt
    if time - last_time >= .01 then
        last_time = time
        datamodel.write('time', time)
    end
end

function love.draw()
  local screen = menu_engine.get_current_screen()
  for i,drawable in ipairs(screen.drawables) do
      draw(drawable)
  end
end

function love.mousepressed(x,y)
    menu_engine.pass_click_event({x = x, y = y})
end

function love.menu_event(event)
    menu_engine.pass_menu_state_event(event)
end

function love.game_play_event(event)
    game_engine.game_play_requested()
end
