return function(number_of_chutes, length_of_chutes)

    local chutes = {}
    local leaving_chutes = {}

    for i = 1,number_of_chutes do 
        local chute = {}
        for j = 1,length_of_chutes do
            table.insert(chute, false)
        end
        table.insert(chutes, chute)
    end

    local function balls_in_play()
        local balls = {}

        for chute_num,chute in ipairs(chutes) do
            for location_num,location in ipairs(chute) do
                if location then 
                    table.insert(balls, {chute = chute_num, location = location_num})
                end 
            end
        end
        return balls
    end

    return {
        tock = function(entering_chutes)
            if type(entering_chutes) ~= 'table' then entering_chutes = {entering_chutes} end
            leaving_chutes = {}
            for chute = 1,number_of_chutes do
                if chutes[chute][length_of_chutes] then
                    table.insert(leaving_chutes, chute)
                end
            end

            for chute = 1,number_of_chutes do
                table.remove(chutes[chute], #chutes[chute])
                table.insert(chutes[chute], 1, false)
            end

            for _,chute_in_which_a_ball_was_dropped in ipairs(entering_chutes or {}) do
                (chutes[chute_in_which_a_ball_was_dropped] or {})[1] = true
            end

            return balls_in_play(), leaving_chutes
        end
    }
end