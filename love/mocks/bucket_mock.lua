local controller_mock = {
    move_left = function() end,
    move_right = function() end,
    ball_in_chute = function() end,
    current_chute = function() end,
    number_of_chutes = function() end
}

return {
    tock = function() end,
    controller = function() 
        return controller_mock
    end
}