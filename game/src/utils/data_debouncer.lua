return function(datamodel, timer_dispensary, debounce_delay, original_data_label, debounced_data_label)

    local data = datamodel.read(original_data_label)
    local current_timer

    local function debounce_callback()
        datamodel.write(debounced_data_label, data)
    end

    local function datamodel_on_change_callback(label, new_data)
        if label == original_data_label then
            data = new_data
            if not current_timer then
                current_timer = timer_dispensary.one_time(debounce_delay, debounce_callback)
            else
                current_timer.start()
            end
        end
    end

    datamodel.subscribe_to_on_change(datamodel_on_change_callback)
end
