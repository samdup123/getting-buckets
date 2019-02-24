local zipper = require'zipper'
local json = require'json'
local io = require'io'


return function(config)
    items = config.items or {}
    local label_map = {}
    local model = {}

    for _,item in ipairs(items) do
        local label = item[1]
        local default = item[2]
        label_map[label] = true
        model[label] = default
    end

    local file = io.open(config.file, 'r')
    local data = file:read('a')

    if not data then
        file:close()
        file = io.open(config.file, 'w+')
        file:write(zipper.zip(json.encode(model)))
        file:close()
    else
        model = json.decode(zipper.unzip(data))
        file:close()
    end
    
    return {
        read = function(label)
            if not label_map[label] then error('label "' .. label .. '" is not specified') end
            return model[label]
        end,
        write = function(label, new_data)
            model[label] = new_data
            file = io.open(config.file, 'w+')
            file:write(zipper.zip(json.encode(model)))
            file:close()
        end
    }
end