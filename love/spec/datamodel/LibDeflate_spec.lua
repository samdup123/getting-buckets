describe('testing the LibDeflate library', function()

    it('should work', function() 
        local LibDeflate = require'datamodel/LibDeflate'

        local compressed = LibDeflate:CompressDeflate('howdy pardner')

        assert.are.same('howdy pardner', LibDeflate:DecompressDeflate(compressed))
    end)
end)
