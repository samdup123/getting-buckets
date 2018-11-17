return function(game_history, moments_kept)
    local partial_game_history = {}
    for i = moments_kept + 1, #game_history do
        if (#(game_history[i].lost_balls or {}) > 0) then
            for j = i - moments_kept, i do
                table.insert(partial_game_history, game_history[j])
            end
        end
    end
    return partial_game_history
end