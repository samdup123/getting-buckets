describe('indirect datamodel', function()
    local Datamodel = require'datamodel/datamodel_indirect'
    local mach = require'mach'

    local read_func = mach.mock_function('read')
    local write_func = mach.mock_function('write')
    local f = mach.mock_function('f')
    local g = mach.mock_function('g')

    local function nothing_should_happen_when(func) func() end

    it('should be able to read data from a data-label', function()
        local datamodel = Datamodel(read_func, write_func, {'data'})
        local data

        read_func.should_be_called_with('data').and_will_return(1000)
        .when(
            function() data = datamodel.read('data') end
        )

        assert.are.equal(1000, data)
    end)

    it('should not allow for retrieval of an unspecified label', function()
        local datamodel = Datamodel(read_func, write_func, {'data'})
        assert.has_error(function() datamodel.read('otherData') end, 'label "otherData" is not specified')
    end)


    it('should be able to write data to a data-label', function()
        local datamodel = Datamodel(read_func, write_func, {'data'})

        write_func.should_be_called_with('data', 5)
        .when(
            function() datamodel.write('data', 5) end
        )
    end)

    it('should not allow for storage to an unspecified label', function()
        local datamodel = Datamodel(read_func, write_func, {'data'})
        assert.has_error(function() datamodel.write('otherData', 4) end, 'label "otherData" is not specified')
    end)

    it('should allow user to check if data exists', function()
        local datamodel = Datamodel(read_func, write_func, {'data'})
        assert.is_true(datamodel.has('data'))
        assert.is_false(datamodel.has('otherData'))
    end)

    it('should have dummy subscribe to on change method', function()
        local datamodel = Datamodel(read_func, write_func, {'data'})

        datamodel.subscribe_to_on_change(f)
        datamodel.subscribe_to_on_change(g)

        write_func.should_be_called_with('data', 5)
        .when(
            function() datamodel.write('data', 5) end
        )
    end)
end)