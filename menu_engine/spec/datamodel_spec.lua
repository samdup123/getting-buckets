describe('datamodel', function()
    local Datamodel = require'datamodel'
    local mach = require'mach'
    local f = mach.mock_function('callback1')
    local g = mach.mock_function('callback2')

    local function nothing_should_happen_when(func) func() end

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
        datamodel.subscribe_to_on_change(f)
        f:should_be_called_with('data', 4):when(
            function() datamodel.write('data', 4) end)
    end)

    it('should allow multiple subscribers', function()
        local datamodel = Datamodel({'data'})
        datamodel.subscribe_to_on_change(f)
        datamodel.subscribe_to_on_change(f)
        f:should_be_called_with('data', 4):multiple_times(2):when(
            function() datamodel.write('data', 4) end)
    end)

    it('should allow user to check if data exists', function()
        local datamodel = Datamodel({'data'})
        assert.is_true(datamodel.has('data'))
        assert.is_false(datamodel.has('otherData'))
    end)

    -- it('should allow unsubscriptions', function()
    --     local datamodel = Datamodel({'data'})
    --     local token1 = datamodel.subscribe_to_on_change(f)
    --     local token2 = datamodel.subscribe_to_on_change(g)
    --     f:should_be_called_with('data', 4)
    --     :and_also(g:should_be_called_with('data', 4)):when(
    --         function() datamodel.write('data', 4) end)

    --     datamodel.unsubscribe_to_on_change(token2)

    --     f:should_be_called_with('data', 5):when(
    --         function() datamodel.write('data', 5) end)

    --     datamodel.unsubscribe_to_on_change(token1)

    --     nothing_should_happen_when(
    --         function() datamodel.write('data', 6) end)
    -- end)
end)