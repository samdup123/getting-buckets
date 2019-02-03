describe('datamodel', function()
    local datamodel = require'datamodel'

    it('should allow for storage and retrieval of information', function()
        assert.is_nil(datamodel.read('data'))
        datamodel.write('data', 4)
        assert.are.equal(datamodel.read('data'), 4)
    end)
end)