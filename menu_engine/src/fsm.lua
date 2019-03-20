local function null_state() end

return function(initial_state) 
    local current_state = initial_state

    local function signal(signal)

        (current_state[signal] or null_state)()
    end

    local function transition(target)
        if current_state.exit then
            current_state.exit()
        end
        current_state = target
        if current_state.entry then
            current_state.entry()
        end
    end

    signal('entry')

    return {
        transition = transition,
        signal = signal
    }
end
