describe('nonvolatile datamodel', function()
    local mach = require'mach'
    local json = mach.mock_table({encode = function() end, decode = function() end}, 'json')
    local zipper = mach.mock_table({zip = function() end, unzip = function() end}, 'zipper')
    local io = mach.mock_table({open = function() end}, 'io')
    local proxyquire = require'proxyquire'

    local Datamodel = proxyquire('datamodel_nonvolatile', 
        {
            json = json,
            zipper = zipper,
            io = io
        })
    
    local f = mach.mock_function('callback1')
    local g = mach.mock_function('callback2')

    local file_mock_object = {}
    function file_mock_object:read() end
    function file_mock_object:write() end
    function file_mock_object:close() end
    local file_mock = mach.mock_object(file_mock_object, 'file_mock')

    it('should store default data on init if storage file is empty', function()
        local default_data = {1, 2, 3}
        local model = {data = default_data}
        local json_string = '[1, 2, 3]'
        local compressed_string = 'e5;'

        io.open.should_be_called_with('~/file', 'r').and_will_return(file_mock)
        .and_also(file_mock.read.should_be_called_with('a').and_will_return(nil))
        .and_also(json.encode.should_be_called_with(mach.match(model)).and_will_return(json_string))
        .and_also(zipper.zip.should_be_called_with(json_string).and_will_return(compressed_string))

        .and_also(file_mock.close.should_be_called())
        .and_also(io.open.should_be_called_with('~/file', 'w+').and_will_return(file_mock))
        .and_also(file_mock.write.should_be_called_with(compressed_string))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() Datamodel({file = '~/file', items = {{'data', default_data}}}) end
        )
    end)

    it('should allow data to be read', function()
        local default_data = {1, 2, 3}
        local model = {data = default_data}
        local json_string = '[1, 2, 3]'
        local compressed_string = 'e5;'
        local datamodel

        io.open.should_be_called_with('~/file', 'r').and_will_return(file_mock)
        .and_also(file_mock.read.should_be_called_with('a').and_will_return(nil))
        .and_also(json.encode.should_be_called_with(mach.match(model)).and_will_return(json_string))
        .and_also(zipper.zip.should_be_called_with(json_string).and_will_return(compressed_string))

        .and_also(file_mock.close.should_be_called())
        .and_also(io.open.should_be_called_with('~/file', 'w+').and_will_return(file_mock))
        .and_also(file_mock.write.should_be_called_with(compressed_string))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() datamodel = Datamodel({file = '~/file', items = {{'data', default_data}}}) end
        )

        assert.are.same(default_data, datamodel.read('data'))
    end)

    it('should not allow for retrieval of an unspecified label', function()
        local default_data = {1, 2, 3}
        local model = {data = default_data}
        local json_string = '[1, 2, 3]'
        local compressed_string = 'e5;'
        local datamodel

        io.open.should_be_called_with('~/file', 'r').and_will_return(file_mock)
        .and_also(file_mock.read.should_be_called_with('a').and_will_return(nil))
        .and_also(json.encode.should_be_called_with(mach.match(model)).and_will_return(json_string))
        .and_also(zipper.zip.should_be_called_with(json_string).and_will_return(compressed_string))

        .and_also(file_mock.close.should_be_called())
        .and_also(io.open.should_be_called_with('~/file', 'w+').and_will_return(file_mock))
        .and_also(file_mock.write.should_be_called_with(compressed_string))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() datamodel = Datamodel({file = '~/file', items = {{'data', default_data}}}) end
        )

        assert.has_error(function() datamodel.read('otherData') end, 'label "otherData" is not specified')
    end)

    it('should allow for data to be written', function()
        local default_data = {1, 2, 3}
        local model = {data = default_data}
        local json_string = '[1, 2, 3]'
        local compressed_string = 'e5;'
        local datamodel

        io.open.should_be_called_with('~/file', 'r').and_will_return(file_mock)
        .and_also(file_mock.read.should_be_called_with('a').and_will_return(nil))
        .and_also(json.encode.should_be_called_with(mach.match(model)).and_will_return(json_string))
        .and_also(zipper.zip.should_be_called_with(json_string).and_will_return(compressed_string))

        .and_also(file_mock.close.should_be_called())
        .and_also(io.open.should_be_called_with('~/file', 'w+').and_will_return(file_mock))
        .and_also(file_mock.write.should_be_called_with(compressed_string))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() datamodel = Datamodel({file = '~/file', items = {{'data', default_data}}}) end
        )

        local new_data = {3, 2, 1}
        local new_model = {data = new_data}

        json.encode.should_be_called_with(mach.match(new_model)).and_will_return(json_string)
        .and_also(zipper.zip.should_be_called_with(json_string).and_will_return(compressed_string))
        .and_also(io.open.should_be_called_with('~/file', 'w+').and_will_return(file_mock))
        .and_also(file_mock.write.should_be_called_with(compressed_string))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() datamodel.write('data', new_data) end
        )

        assert.are.same(new_data, datamodel.read('data'))
    end)

    it('should read storage file into model on init if file contains data', function()
        local default_data = {1, 2, 3}
        local model = {data = default_data}
        local json_string = '[1, 2, 3]'
        local compressed_string = 'e5;'

        io.open.should_be_called_with('~/file', 'r').and_will_return(file_mock)
        .and_also(file_mock.read.should_be_called_with('a').and_will_return(compressed_string))
        .and_also(zipper.unzip.should_be_called_with(compressed_string).and_will_return(json_string))
        .and_also(json.decode.should_be_called_with(json_string).and_will_return(model))
        .and_also(file_mock.close.should_be_called())
        .when(
            function() datamodel = Datamodel({file = '~/file', items = {{'data', default_data}}}) end
        )

        assert.are.same(default_data, datamodel.read('data'))
    end)
end)