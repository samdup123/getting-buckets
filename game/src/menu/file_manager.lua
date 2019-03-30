local io = require'io'

return function(main_directory, datamodel)
    local root = main_directory .. datamodel.read('file separator')
    return {
        open = function(file_name)
            local file, error = io.open(root .. file_name, 'a+')
            if file then file:close() end
            return root .. file_name
        end,
        read = function(file_name)
            local file, error = io.open(root .. file_name, 'r')
            if not file then
                print(error)
            else
                local option = datamodel.read('lua version') == 5.1 and '*a' or 'a'
                local contents = file:read(option)
                file:close()
                return contents
            end
        end
    }
end
