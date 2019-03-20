describe('finite state machine', function()
    local Fsm = require'fsm'
    local mach = require'mach'

    local signals = {entry = function() end, exit = function() end, a_signal = function() end}

    local state1 = mach.mock_table(signals, 'state 1')
    local state2 = mach.mock_table(signals, 'state 2')

    local function nothing_should_happen_when(f) f() end

    it('should enter initial state by sending the entry signal', function()
        state1.entry.should_be_called()
        .when(function() local fsm = Fsm(state1) end)
    end)

    it('should send exit and entry signals upon transition', function()
        local fsm
        state1.entry.should_be_called()
        .when(function() fsm = Fsm(state1) end)

        state1.exit.should_be_called()
        .and_also(state2.entry.should_be_called())
        .when(function() fsm.transition(state2) end)
    end)

    it('should not send exit and entry signals upon transition if they are not handled by the state', function()
        local fsm
        state1.entry.should_be_called()
        .when(function() fsm = Fsm(state1) end)

        state1.exit.should_be_called()
        .when(function() fsm.transition({}) end)

        state1.entry.should_be_called()
        .when(function() fsm.transition(state1) end)
    end)

    it('should be able to send signals', function()
        local fsm
        state1.entry.should_be_called()
        .when(function() fsm = Fsm(state1) end)

        state1.a_signal.should_be_called()
        .when(function() fsm.signal('a_signal') end)
    end)

    it('should not send signals that have no effect', function()
        local fsm
        state1.entry.should_be_called()
        .when(function() fsm = Fsm(state1) end)

        nothing_should_happen_when(function() fsm.signal('another_signal') end)
    end)
end)