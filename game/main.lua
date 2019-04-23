love.window.setFullscreen(true)

local os_process_file = assert(io.popen('pwd', 'r'))
local working_directory = os_process_file:read('*all')
working_directory = working_directory:sub(1, #working_directory - 1)
os_process_file:close()

os_process_file = assert(io.popen('mkdir user_code'))
os_process_file:close()

-- set the package path to collect source code
package.path = '/Users/samduplessis/APLACE/getting-buckets/?.lua;' .. package.path
package.path = '/Users/samduplessis/APLACE/getting-buckets/game/src/?.lua;' .. package.path

local images = {
    logo = love.graphics.newImage('res/logo.png'),
    background = love.graphics.newImage('res/background.png')
}

local draw = require'menu/draw_various_drawables'(love.graphics, {
        main_font = love.graphics.newFont(24),
        console_font = love.graphics.newFont(14),
        big_font = love.graphics.newFont(34)
    }, images)

local levels = {
    require'levels/random/environment',
    require'levels/oscillating/environment',
}

local datamodel_vol = require'datamodel/volatile'(
  {
    {'current window size',
      {
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
      }},
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

local datamodel_indirect = require'datamodel/indirect'(
    {
        ['current level environment'] = {
            read = function()
                local index = datamodel_vol.read('current level number')
                return levels[index]
            end,
            write = function() end
        }
    }
)

local datamodel = require'datamodel/combined'({datamodel_vol, datamodel_indirect})

local file_manager = require'menu/file_manager'(working_directory .. '/user_code', datamodel)

local Time = require'utils/time'()
local timer_dispensary = Time.timer_dispensary()

local Debouncer = require'utils/data_debouncer'
Debouncer(datamodel, timer_dispensary, .1, 'current mouse position', 'debounced current mouse position')

local menu_engine = require'menu/engine'({
    splash = require'menu/presenters/splash'(function(...) love.event.push(...) end, datamodel),
    display_file_location = require'menu/presenters/display_file_location'(
        function(...) love.event.push(...) end,
        datamodel,
        file_manager),
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

local clicked = false

function love.draw()
    if clicked then
        local screen = menu_engine.get_current_screen()
        for i,drawable in ipairs(screen.drawables) do
          draw(drawable)
        end
    else
        love.graphics.draw(images.background, 0, 0)
        love.graphics.draw(images.logo, 450, 25)
    end
end

function love.mousepressed(x,y)
    clicked = true
    menu_engine.pass_click_event({x = x, y = y, type = 'press'})
end

function love.mousereleased(x,y)
    menu_engine.pass_click_event({x = x, y = y, type = 'release'})
end

function love.mousemoved(x, y, dx, dy)
    datamodel.write('current mouse position', {x = x, y = y})
end

function love.menu_event(event)
    menu_engine.pass_menu_state_event(event)
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
     love.event.quit()
  end
end

function love.game_play_event(event)
    local location = datamodel.read('current file location')
    current_user_code = require('user_code/' .. location)
    datamodel.write('current user code', current_user_code)
    game_engine.game_play_requested()
end
