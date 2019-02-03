package.path = '/home/sam/Dropbox/college/seanior/coding-game/menu_engine/src/?.lua;' .. package.path
local draw = require'draw_various_drawables'(love.graphics)

local menu_engine = require'menu_engine'({
    require'display_file_location'(function(...) love.event.push(...) end)
})

function love.load()
end
 
function love.update(dt)
end
 
function love.draw()
    local screen = menu_engine.get_current_screen()
    for i,drawable in ipairs(screen.drawables) do
        draw(drawable)
    end
end
