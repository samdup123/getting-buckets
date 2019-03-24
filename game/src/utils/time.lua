local initialized = false

local current_time = 0

local timers = {}
local function add_timer(time, callback)
    -- TODO: make this sorting better!
    if #timers == 0 then
        table.insert(timers, {time = time, callback = callback})
    else
        for index,timer in ipairs(timers) do
            if time <= timer.time then
                table.insert(timers, index, {time = time, callback = callback})
                break
            end
        end
    end

    -- print('all timers')
    -- for index,timer in ipairs(timers) do print(timer.time) end
end

if not initialized then
    initialized = true
    return {

        update = function(new_time)
            current_time = new_time
            local index = 1
            while true do
                if timers[index] and (timers[index].time <= current_time) then
                    timers[index].callback()
                    index = index + 1
                else
                    break
                end
            end
            for i = 1, index - 1 do
                table.remove(timers, 1)
            end
        end,

        reset = function()
            current_time = 0
            timers = {}
        end,

        current_time = function() return current_time end,

        timer_dispenser = function()
            return {
                one_time = function(period, callback)
                    add_timer(current_time + period, callback)
                end
            }
        end
    }
end
