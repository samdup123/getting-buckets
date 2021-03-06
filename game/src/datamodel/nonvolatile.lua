local zipper = require'zipper'
local json = require'json'
local io = require'io'

return function(config)

    items = config.items or {}
    local label_map = {}
    local model = {}

    for label,defaultData in pairs(items) do
        label_map[label] = true
        model[label] = defaultData
    end

    local file = io.open(config.file, 'r')

    local data do
        if file then
            data = file:read('a')
        end
    end

    if not data then
        if file then file:close() end
        file = io.open(config.file, 'w+')
        file:write(zipper.zip(json.encode(model)))
        file:close()
    else
        model = json.decode(zipper.unzip(data))
        file:close()
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
            file = io.open(config.file, 'w+')
            file:write(zipper.zip(json.encode(model)))
            file:close()

            for _,callback in ipairs(callbacks) do
                callback(label, new_data)
            end
        end,
        subscribe_to_on_change = function(cb)
            table.insert(callbacks, cb)
        end,
        has = function(label)
            return label_map[label] == true
        end
    }
end
