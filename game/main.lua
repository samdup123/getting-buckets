love.window.setFullscreen(true)

local os_process_file = assert(io.popen('pwd', 'r'))
local working_directory = os_process_file:read('*all')
working_directory = working_directory:sub(1, #working_directory - 1)
os_process_file:close()

os_process_file = assert(io.popen('mkdir user_code'))
os_process_file:close()

-- set the package path to collect source code
package.path = 'Users/ryanpetit/Dropbox/2019_SRING/550_CECS/getting-buckets/?.lua;' .. package.path
package.path = 'Users/ryanpetit/Dropbox/2019_SRING/550_CECS/getting-buckets/game/src/?.lua;' .. package.path

local main_font = love.graphics.newFont(24)
local big_font = love.graphics.newFont(48)
local console_font = love.graphics.newFont(14)
local draw = require'menu/draw_various_drawables'(love.graphics, {main_font = main_font, console_font = console_font, big_font = big_font})
local datamodel = require'datamodel/volatile'(
  {
    {'current window size',
      {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
      }},
     'current level environment',
     'current user code',
     'current level number',
     'current game history',
     'player won last game',
     'current file location',
     {'file separator', '/'},
     {'lua version', tonumber(_VERSION:sub(#_VERSION - 2, #_VERSION))},
     'current mouse position',
     'debounced current mouse position'
  }
)

local file_manager = require'menu/file_manager'(working_directory .. '/user_code', datamodel)

local Time = require'utils/time'()
local timer_dispensary = Time.timer_dispensary()

local Debouncer = require'utils/data_debouncer'
Debouncer(datamodel, timer_dispensary, .1, 'current mouse position', 'debounced current mouse position')

local menu_engine = require'menu/engine'({
    display_file_location = require'menu/presenters/display_file_location'(
        function(...) love.event.push(...) end,
        datamodel,
        file_manager),
    splash = require'menu/presenters/splash'(function(...) love.event.push(...) end, datamodel),
    level_selection = require'menu/presenters/level_selection'(function(...) love.event.push(...) end, datamodel),
    game = require'menu/presenters/game'(function(...) love.event.push(...) end, datamodel, timer_dispensary),
    null = require'menu/presenters/null'
})

local game_engine = require'game/engine'(require'game/player', datamodel)

math.randomseed(os.time())

function love.load(arg)
  love.handlers.menu_event = love.menu_event
  love.handlers.game_play_event = love.game_play_event

  local random_level_environment = require'levels/random/environment'
  datamodel.write('current level environment', random_level_environment)
end


local time = 0
local last_time = time
function love.update(dt)
    time = time + dt
    if time - last_time >= .01 then
        last_time = time
        Time.update(time)
    end
end

function love.draw()
  local screen = menu_engine.get_current_screen()
  for i,drawable in ipairs(screen.drawables) do
      draw(drawable)
  end
end

function love.mousepressed(x,y)
    menu_engine.pass_click_event({x = x, y = y, type = 'press'})
end

function love.mousereleased(x,y)
    menu_engine.pass_click_event({x = x, y = y, type = 'release'})
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
     love.event.quit()
  end
end

function love.mousemoved(x, y, dx, dy)
    datamodel.write('current mouse position', {x = x, y = y})
end

function love.menu_event(event)
    menu_engine.pass_menu_state_event(event)
end

function love.game_play_event(event)
    local location = datamodel.read('current file location')
    current_user_code = require('user_code/' .. location)
    datamodel.write('current user code', current_user_code)
    game_engine.game_play_requested()
end
