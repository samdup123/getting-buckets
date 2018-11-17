return function(game_history, memory_length)
    local partial_game_history = {}

    local anything_saved = false

    local last_moment_unsaved_within_memory_length = 1

    for i = 1, #game_history do
        if i - last_moment_unsaved_within_memory_length > memory_length then
            last_moment_unsaved_within_memory_length = last_moment_unsaved_within_memory_length + 1
        end

        if (#(game_history[i].lost_balls or {}) > 0) then
            for j = last_moment_unsaved_within_memory_length, i do
                table.insert(partial_game_history, game_history[j])
                last_moment_unsaved_within_memory_length = j
            end
            last_moment_unsaved_within_memory_length = last_moment_unsaved_within_memory_length + 1
        end
    end
    return partial_game_history
end