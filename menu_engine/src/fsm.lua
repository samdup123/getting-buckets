local function null_state() end

return function(initial_state) 
    local current_state = initial_state

    local function signal(signal)

        (current_state[signal] or null_state)()
    end

    local function transition(target)
        current_state.exit()
        current_state = target
        current_state.entry()
    end

    signal('entry')

    return {
        transition = transition,
        signal = signal
    }
end
