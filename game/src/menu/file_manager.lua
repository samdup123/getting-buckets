local io = require'io'

return function(main_directory, datamodel)
    local root = main_directory .. datamodel.read('file separator')
    return {
        open = function(file_name)
            io.open(root .. file_name, 'w'):close()
        end,
        read = function(file_name)
            local file = io.open(root .. file_name, 'r')
            local contents = file:read('a')
            file:close()
            return contents
        end,
        location = function(file_name)
            return root .. file_name
        end
    }
end
