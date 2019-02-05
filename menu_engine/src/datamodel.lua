return function(labels)
    labels = labels or {}
    local label_map = {}

    for _,label in ipairs(labels) do label_map[label] = true end

    local model = {}

    return {
        read = function(label)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            return model[label]
        end,
        write = function(label, data)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            model[label] = data
        end
    }
end