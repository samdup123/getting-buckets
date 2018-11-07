return function(number_of_chutes)

    return {
        chute_in_which_ball_was_dropped = function()
            return math.random(number_of_chutes)
        end,
        tock = function() end
    }
end
    