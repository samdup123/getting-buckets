describe('time', function()
    local Time = require'utils/time'
    local timer = Time.timer_dispenser()
    local mach = require'mach'

    local f = mach.mock_function('f')
    local g = mach.mock_function('g')
    local h = mach.mock_function('h')

    local time = 0
    local function after(new_time)
        time = time + new_time
        Time.update(time)
    end

    local function nothing_should_happen_when(f) f() end

    before_each(function()
        Time.reset()
        time = 0
    end)

    it('should allow a one time timer to be created', function()
        timer.one_time(8, f)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .when(function() after(1) end)
    end)

    it('should allow multiple one time timers to be created (out of order)', function()
        timer.one_time(8, f)
        timer.one_time(5, g)

        nothing_should_happen_when(
            function() after(4) end
        )

        g.should_be_called()
        .when(function() after(1) end)

        nothing_should_happen_when(
            function() after(2) end
        )

        f.should_be_called()
        .when(function() after(1) end)
    end)

    it('should allow a repeating timer to be created', function()
        timer.repeating(8, f)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .when(function() after(1) end)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .when(function() after(1) end)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .when(function() after(1) end)
    end)

    it('should allow one time timers to be executed at once', function()
        timer.one_time(8, f)
        timer.one_time(8, g)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .and_also(g.should_be_called())
        .when(function() after(1) end)
    end)

    it('should allow one time and repeating timers to be executed at once', function()
        timer.one_time(16, f)
        timer.repeating(8, g)
        timer.repeating(8, h)

        nothing_should_happen_when(function() after(7) end)

        g.should_be_called()
        .and_also(h.should_be_called())
        .when(function() after(1) end)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .and_also(g.should_be_called())
        .and_also(h.should_be_called())
        .when(function() after(1) end)

        nothing_should_happen_when(function() after(7) end)

        g.should_be_called()
        .and_also(h.should_be_called())
        .when(function() after(1) end)
    end)

    it('should still have working one time timers when time happens irregularly', function()
        timer.one_time(8, f)
        timer.one_time(9, g)

        f.should_be_called()
        .and_also(g.should_be_called())
        .when(function() after(10) end)
    end)

    it('should still have working repeating timers when time happens irregularly', function()
        timer.repeating(8, f)
        timer.repeating(9, g)

        f.should_be_called()
        .and_also(g.should_be_called())
        .when(function() after(10) end)

        f.should_be_called()
        .when(function() after(8) end)

        g.should_be_called()
        .when(function() after(1) end)
    end)

    it('should allow one time timers to be stopped', function()
        local token = timer.one_time(8, f)
        timer.stop(token)

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow timers that have already stopped to be stopped (to no effect)', function()
        local token = timer.one_time(8, f)

        f.should_be_called()
        .when(function() after(8) end)

        timer.stop(token)

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow repeating timers to be stopped immediately', function()
        local token = timer.repeating(8, f)
        timer.stop(token)

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow repeating timers to be stopped after some time', function()
        local token = timer.repeating(8, f)

        f.should_be_called()
        .when(function() after(8) end)

        f.should_be_called()
        .when(function() after(8) end)

        timer.stop(token)

        nothing_should_happen_when(function() after(100) end)
    end)
end)
