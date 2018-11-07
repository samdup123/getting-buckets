return function(number_of_chutes)

    return {
        chutes_in_which_balls_are_dropped = function()
            return math.random(number_of_chutes)
        end,
        tock = function() end
    }
end
    