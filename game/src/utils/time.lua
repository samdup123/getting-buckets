local initialized = false

local current_time = 0

local token_generation = 1

local timers = {}
local function add_timer(time, callback, context, token)
    local new_timer = {time = time, callback = callback, context = context, token = token}
    -- TODO: make this sorting better!
    if #timers == 0 then
        table.insert(timers, new_timer)
    else
        local inserted = false
        for index,timer in ipairs(timers) do
            if time <= timer.time then
                inserted = true
                table.insert(timers, index, new_timer)
                break
            end
        end
        if not inserted then
            table.insert(timers, new_timer)
        end
    end
end

local function create_timer(period, callback, context, token)
    if not token then
        token = token_generation
        token_generation = token_generation + 1
    end
    add_timer(current_time + period, callback, context, token)
    return token
end

local function remove_timer(token)
    for index,timer in ipairs(timers) do
        if timer.token == token then
            table.remove(timers, index)
            break
        end
    end
end

if not initialized then
    initialized = true
    return {

        update = function(new_time)
            current_time = new_time
            local index = 1
            while true do
                if timers[index] and (timers[index].time <= current_time) then
                    timers[index].callback(timers[index].context)
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

        timer_dispensary = function()
            return {
                one_time = function(period, callback, context) return create_timer(period, callback, context) end,
                repeating = function(period, callback, context)
                    local new_callback, token
                    new_callback = function(...)
                        callback(...)
                        create_timer(period, new_callback, context, token)
                    end
                    token = create_timer(period, new_callback, context)
                    return token
                end,
                stop = remove_timer
            }
        end
    }
end
