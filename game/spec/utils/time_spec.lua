describe('time', function()
    local Time = require'utils/time'
    local mach = require'mach'

    local f = mach.mock_function('f')
    local g = mach.mock_function('g')

    local function after(time)
        Time.update(Time.current_time() + time)
    end

    local function nothing_should_happen_when(f) f() end

    before_each(function()
        Time.reset()
    end)

    it('should allow a one time timer to be created', function()
        local timer = Time.timer_dispenser()
        timer.one_time(8, f)

        nothing_should_happen_when(
            function() after(7) end
        )

        f.should_be_called()
        .when(
            function() after(1) end
        )
    end)

    -- it('should allow multiple one time timers to be created (out of order)', function()
    --     local timer = Time.timer_dispenser()
    --     timer.one_time(8, f)
    --     timer.one_time(5, g)
    --
    --     nothing_should_happen_when(
    --         function() after(4) end
    --     )
    --
    --     g.should_be_called()
    --     .when(
    --         function() after(1) end
    --     )
    --
    --     nothing_should_happen_when(
    --         function() after(2) end
    --     )
    --
    --     f.should_be_called()
    --     .when(
    --         function() after(1) end
    --     )
    -- end)
end)
