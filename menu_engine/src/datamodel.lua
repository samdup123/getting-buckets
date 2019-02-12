return function(items)
    items = items or {}
    local label_map = {}
    local model = {}

    for _,item in ipairs(items) do
        if type(item) == 'string' then
            label_map[item] = true
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
        write = function(label, data)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end  
            model[label] = data
            
            for _,cb in ipairs(callbacks) do
                cb(label, data)
            end
        end,
        subscribe_to_on_change = function(cb)
            table.insert(callbacks, cb)
        end
    }
end