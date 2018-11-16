local function min(a,b) return a<b and a or b end
local function max(a,b) return a<b and b or a end
return function(controller)
    local current_chute = controller.current_chute()
    local last_chute = controller.number_of_chutes()
    local direction_of_movement = 'left'

    local function move()
        controller['move_' .. direction_of_movement]()
    end

    while true do
        if current_chute == 1 then
            direction_of_movement = 'right'
        elseif current_chute == last_chute then
            direction_of_movement = 'left'
        end

        if not controller.ball_in_chute() then
            move()
        else
            break
        end
        current_chute = controller.current_chute()
        
        coroutine.yield()
    end

    local limit_low
    local limit_high

    while true do

        if current_chute <= math.floor(last_chute / 2) then
            limit_high = current_chute - 1
            limit_low = max(1, current_chute - last_chute + 2)
        else
            limit_low = current_chute + 1
            limit_high = min(last_chute, current_chute + last_chute - 2)
        end

        while true do
            if current_chute == limit_low then
                direction_of_movement = 'right'
            elseif current_chute == limit_high then
                direction_of_movement = 'left'
            end
    
            if not controller.ball_in_chute() then
                move()
            else
                break
            end
            current_chute = controller.current_chute()
            
            coroutine.yield()
        end
    end
end