package.path = '/home/sam/Dropbox/college/seanior/coding-game/menu_engine/src/?.lua;' .. package.path
local main_font = love.graphics.newFont(24)
local draw = require'draw_various_drawables'(love.graphics, {main_font = main_font})
local datamodel = require'datamodel'

local menu_engine = require'menu_engine'({
    display_file_location = require'display_file_location'(function(...) love.event.push(...) end, datamodel),
    null = require'null'
})

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
