love.window.setFullscreen(true)
package.path = '/home/sam/Dropbox/college/seanior/coding-game/menu_engine/src/?.lua;' .. package.path
local main_font = love.graphics.newFont(24)
local draw = require'menu/draw_various_drawables'(love.graphics, {main_font = main_font})
local datamodel = require'datamodel/volatile'({'current file location'})

local menu_engine = require'menu/engine'({
    display_file_location = require'presenters/display_file_location'(function(...) love.event.push(...) end, datamodel),
    level_selection = require'presenters/level_selection'(function(...) love.event.push(...) end, datamodel),
    game = require'presenters/game'(function(...) love.event.push(...) end, datamodel),
    null = require'null'
})

-- local datamodel_nv = 
--     require'datamodel_nonvolatile'(
--         {file = '/home/sam/Dropbox/college/seanior/coding-game/bloop.txt', items = {go = 5, hey = {1,2,3}}}
--     )
    
-- datamodel_nv.write('go', 6)

function love.load()
    datamodel.write('current file location', '/sam/homie-zone/level1_code.lua')
    love.handlers.menu_event = love.menu_event
end
 
function love.update(dt)
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
