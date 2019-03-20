return function(items)
    items = items or {}
    local label_map = {}
    local model = {}

    for _,item in ipairs(items) do
        if type(item) == 'string' then
            local label = item
            label_map[label] = true
        elseif type(item) == 'table' then
            local label = item[1]
            local default = item[2]
            label_map[label] = true
            model[label] = default
        end
    end

    local callbacks = {}

    return {
        read = function(label)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            return model[label]
        end,
        write = function(label, new_data)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end  
            model[label] = new_data
            
            for _,cb in ipairs(callbacks) do
                cb(label, new_data)
            end
        end,
        has = function(label) 
            return label_map[label] == true 
        end,
        subscribe_to_on_change = function(cb)
            table.insert(callbacks, cb)
        end
    }
end