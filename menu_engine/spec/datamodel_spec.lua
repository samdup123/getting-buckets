describe('datamodel', function()
    local Datamodel = require'datamodel'

    it('should allow for storage and retrieval of information from a label', function()
        local datamodel = Datamodel({'data'})
        assert.is_nil(datamodel.read('data'))
        datamodel.write('data', 4)
        assert.are.equal(datamodel.read('data'), 4)
    end)

    it('should not allow for retrieval of an unspecified label', function()
        local datamodel = Datamodel()
        assert.has_error(function() datamodel.read('data') end, 'label "data" is not specified')
    end)

    it('should not allow for storage of an unspecified label', function()
        local datamodel = Datamodel()
        assert.has_error(function() datamodel.write('data', 4) end, 'label "data" is not specified')
    end)
end)