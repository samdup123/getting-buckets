local io = require'io'

return function(main_directory, datamodel)
    local root = main_directory .. datamodel.read('file separator')
    return {
        open = function(file_name)
            local file, error = io.open(root .. file_name, 'w')
            if file then file:close() end
            return root .. file_name
        end,
        read = function(file_name)
            local file = io.open(root .. file_name, 'r')
            local contents = file:read('a')
            file:close()
            return contents
        end
    }
end
