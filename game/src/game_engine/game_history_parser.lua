local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

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
                local moment = deepcopy(game_history[j])
                moment.moment_number = j
                table.insert(partial_game_history, moment)
                last_moment_unsaved_within_memory_length = j
            end
            last_moment_unsaved_within_memory_length = last_moment_unsaved_within_memory_length + 1
        end
    end
    return partial_game_history
end