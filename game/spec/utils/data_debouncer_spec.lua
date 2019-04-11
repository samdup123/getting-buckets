describe('data debouncer', function()
    local DataDebouncer = require'utils/data_debouncer'

    local mach = require'mach'

    local Time = require'utils/time'()
    local function after(new_time) Time.update( Time.current() + new_time) end
    local timer_dispensary = Time.timer_dispensary()

    local datamodel_mock = mach.mock_table({
        read = function() end,
        write = function() end,
        subscribe_to_on_change = function() end
    }, 'datamodel')

    local callback

    local datamodel_fake = setmetatable({}, {
        __index = function(_, name)
            if name == 'subscribe_to_on_change' then
                return function(cb)
                    callback = cb
                    datamodel_mock.subscribe_to_on_change(cb)
                end
            else
                return datamodel_mock[name]
            end
        end
    })

    local function the_data_model_calls_the_on_data_change_callback_with(new_data)
        callback('original label', new_data)
    end

    it('should write the latest value of the original data, when it settles', function()
        local debounce_delay = 8

        datamodel_mock.read.should_be_called_with('original label').and_will_return(1)
        .and_also(datamodel_mock.subscribe_to_on_change.should_be_called_with_any_arguments())
        .when(function()
            DataDebouncer(
                datamodel_fake,
                timer_dispensary,
                debounce_delay,
                'original label',
                'debounced label')
        end)

        the_data_model_calls_the_on_data_change_callback_with(2)
        after(7)

        the_data_model_calls_the_on_data_change_callback_with(3)
        after(7)

        the_data_model_calls_the_on_data_change_callback_with(4)
        after(7)

        datamodel_mock.write.should_be_called_with('debounced label', 4)
        .when(function()
            after(8)
        end)
    end)
end)
