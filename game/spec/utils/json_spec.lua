describe('tests for the json.lua library', function()
    local json = require'utils/json'

    it('should work', function() 
        local obj = {hey = 4, blah = {89, 90, 'yolo'}}
        local encoded = json.encode(obj)
        local one = '{"hey":4,"blah":[89,90,"yolo"]}' == encoded
        local two = '{"blah":[89,90,"yolo"],"hey":4}' == encoded
    
        assert.is_true(one or two)

        assert.are.same(obj, json.decode(encoded))
    end)
end)