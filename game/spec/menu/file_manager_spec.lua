describe('file manager', function()
    local proxyquire = require'proxyquire'
    local mach = require'mach'

    local datamodel = mach.mock_table({read = function() end}, 'datamodel')
    local io = mach.mock_table({open = function() end}, 'io')

    local FileManager = proxyquire('menu/file_manager', {
        io = io
    })

    local file_mock_object = {}
    function file_mock_object:read() end
    function file_mock_object:write() end
    function file_mock_object:close() end
    local file_mock = mach.mock_object(file_mock_object, 'file_mock')

    local file_manager
    before_each(function()
        datamodel.read.should_be_called_with('file separator').and_will_return('/')
        .when(function() file_manager = FileManager('directory', datamodel) end)
    end)

    it('should be able to create a file', function()
        local location
        io.open.should_be_called_with('directory/file', 'w').and_will_return(file_mock)
        .and_also(file_mock.close.should_be_called())
        .when(
            function() location = file_manager.open('file') end
        )

        assert.are.same(location, 'directory/file')
    end)

    it('should be able to read from a file', function()
        local contents
        io.open.should_be_called_with('directory/file', 'r').and_will_return(file_mock)
        .and_also(file_mock.read.should_be_called_with('a').and_will_return('happily ever after'))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() contents = file_manager.read('file') end
        )

        assert.are.same(contents, 'happily ever after')
    end)
end)
