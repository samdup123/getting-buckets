describe('time', function()
    local Time = require'utils/time'()
    local timer_dispensary = Time.timer_dispensary()
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

    describe('singleton', function()
        it('should be able to update time', function()
            assert.are.equal(0, Time.current())

            Time.update(8)

            assert.are.equal(8, Time.current())
        end)

        it('should be able to reset', function()
            Time.update(100)

            assert.are.equal(100, Time.current())

            Time.reset()

            assert.are.equal(0, Time.current())
        end)
    end)

    before_each(function()
        Time.reset()
        time = 0
    end)

    it('should allow a one time timer to be created', function()
        timer_dispensary.one_time(8, f)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .when(function() after(1) end)
    end)

    it('should allow multiple one time timers to be created (out of order)', function()
        timer_dispensary.one_time(8, f)
        timer_dispensary.one_time(5, g)

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
        timer_dispensary.repeating(8, f)

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
        timer_dispensary.one_time(8, f)
        timer_dispensary.one_time(8, g)

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called()
        .and_also(g.should_be_called())
        .when(function() after(1) end)
    end)

    it('should allow one time and repeating timers to be executed at once', function()
        timer_dispensary.one_time(16, f)
        timer_dispensary.repeating(8, g)
        timer_dispensary.repeating(8, h)

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
        timer_dispensary.one_time(8, f)
        timer_dispensary.one_time(9, g)

        f.should_be_called()
        .and_also(g.should_be_called())
        .when(function() after(10) end)
    end)

    it('should still have working repeating timers when time happens irregularly', function()
        timer_dispensary.repeating(8, f)
        timer_dispensary.repeating(9, g)

        f.should_be_called()
        .and_also(g.should_be_called())
        .when(function() after(10) end)

        f.should_be_called()
        .when(function() after(8) end)

        g.should_be_called()
        .when(function() after(1) end)
    end)

    it('should allow one time timers to be stopped', function()
        local timer = timer_dispensary.one_time(8, f)
        timer.stop()

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow timers that have already stopped to be stopped (to no effect)', function()
        local timer = timer_dispensary.one_time(8, f)

        f.should_be_called()
        .when(function() after(8) end)

        timer.stop()

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow repeating timers to be stopped immediately', function()
        local timer = timer_dispensary.repeating(8, f)
        timer.stop()

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow repeating timers to be stopped after some time', function()
        local timer = timer_dispensary.repeating(8, f)

        f.should_be_called()
        .when(function() after(8) end)

        f.should_be_called()
        .when(function() after(8) end)

        timer.stop()

        nothing_should_happen_when(function() after(100) end)
    end)

    it('should allow timers to be created with contexts', function()
        timer_dispensary.one_time(8, f, 'context')
        timer_dispensary.repeating(9, g, 'CONTEXT')

        nothing_should_happen_when(function() after(7) end)

        f.should_be_called_with('context')
        .when(function() after(1) end)

        g.should_be_called_with('CONTEXT')
        .when(function() after(1) end)
    end)

    it('should allow one time timers to be restarted with new parameters', function()
        local timer = timer_dispensary.one_time(8, f, 'context')

        f.should_be_called_with('context')
        .when(function() after(8) end)

        timer.start(80, g, 'CONTEXT')

        g.should_be_called_with('CONTEXT')
        .when(function() after(80) end)
    end)

    it('should allow repeating timers to be restarted with new parameters', function()
        local timer = timer_dispensary.repeating(8, f, 'context')

        f.should_be_called_with('context')
        .when(function() after(8) end)

        timer.start(80, g, 'CONTEXT')

        g.should_be_called_with('CONTEXT')
        .when(function() after(80) end)
    end)

    it('should give timers that offer their information', function()
        local timer1 = timer_dispensary.repeating(8, f, 'hotdog')
        local timer2 = timer_dispensary.one_time(12, g, 'pizza')

        assert.are.same({context = 'hotdog', period = 8, callback = f, type = 'repeating'}, timer1.info())
        assert.are.same({context = 'pizza', period = 12, callback = g, type = 'one time'}, timer2.info())

        timer1.start(9, g, 'cake')
        timer2.start(13, f, 'popsicle')

        assert.are.same({context = 'cake', period = 9, callback = g, type = 'repeating'}, timer1.info())
        assert.are.same({context = 'popsicle', period = 13, callback = f, type = 'one time'}, timer2.info())
    end)
end)
