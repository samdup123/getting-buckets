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
        end
        current_chute = controller.current_chute()
        
        coroutine.yield()
    end
end