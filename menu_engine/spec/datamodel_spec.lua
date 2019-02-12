describe('datamodel', function()
    local Datamodel = require'datamodel'
    local mach = require'mach'
    local event_subscription_callback = mach.mock_function('callback')

    it('should allow for storage and retrieval of information from a label', function()
        local datamodel = Datamodel({'data'})
        assert.is_nil(datamodel.read('data'))
        datamodel.write('data', 4)
        assert.are.equal(datamodel.read('data'), 4)
    end)

    it('should allow for default data', function()
        local datamodel = Datamodel({{'data', 0}})
        assert.are.equal(0, datamodel.read('data'))
    end)

    it('should allow for some labels with default data and some without', function()
        local datamodel = Datamodel({{'data', 0}, 'otherdata'})
        assert.are.equal(0, datamodel.read('data'))
        assert.is_nil(datamodel.read('otherdata'))
    end)

    it('should not allow for retrieval of an unspecified label', function()
        local datamodel = Datamodel()
        assert.has_error(function() datamodel.read('data') end, 'label "data" is not specified')
    end)

    it('should not allow for storage of an unspecified label', function()
        local datamodel = Datamodel()
        assert.has_error(function() datamodel.write('data', 4) end, 'label "data" is not specified')
    end)

    it('should produce an on-change event when data is changed', function()
        local datamodel = Datamodel({'data'})
        datamodel.subscribe_to_on_change(event_subscription_callback)
        event_subscription_callback:should_be_called_with('data', 4):when(
            function() datamodel.write('data', 4) end)
    end)
end)