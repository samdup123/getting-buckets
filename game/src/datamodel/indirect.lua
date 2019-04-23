return function(labels)
    local label_map = {}
    for label,_ in pairs(labels) do
        label_map[label] = true
    end

    return {
        read = function(label)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            return labels[label].read()
        end,
        write = function(label, new_data)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            labels[label].write(new_data)
        end,
        has = function(label)
            return label_map[label] == true
        end,
        subscribe_to_on_change = function() end
    }
end
