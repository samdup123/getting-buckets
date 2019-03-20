describe('testing the LibDeflate library wrapper called zipper', function()

    it('should work', function() 
        local zipper = require'utils/zipper'

        local zipped = zipper.zip('howdy pardner')

        assert.are.same('howdy pardner', zipper.unzip(zipped))
    end)
end)
