return function(_read, _write, labels)
    local label_map = {}
    for _,label in ipairs(labels) do
        label_map[label] = true
    end

    return {
        read = function(label) 
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            return _read(label) 
        end,
        write = function(label, new_data)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            _write(label, new_data)
        end,
        has = function(label)
            return label_map[label] == true
        end,
        subscribe_to_on_change = function() end
    }
end