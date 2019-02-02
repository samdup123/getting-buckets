-- set the package path to collect source code
package.path = '/Users/AndyUyeda/Documents/Spring 2019/550 - Software Engineering/getting-buckets/love/src/?.lua;' .. package.path

math.randomseed(os.time())

local player_code = require'levels/approximately_sequential/player'
local level1 = require'levels/approximately_sequential/level'

function love.load(arg)

end

function love.update(dt)

end

function love.keypressed(key)
   if key == 'f' then
      local f=io.open("level1.lua", "r")
      if f~=nil then
        print("There")
        io.close(f)
        os.execute("open level1.lua")
        return true
      else
        print("Not There")
        file = io.open("level1.lua","w")
        file:write("return function(controller, print)", "\n")
        file:write("", "\n")
        file:write("end", "\n")

        file:close()
        os.execute("open level1.lua")
        return false
      end
   elseif key == 'a' then
      print("The A key was pressed.")
   end
end

function love.draw()
    love.graphics.setColor(1,0,1)
end
