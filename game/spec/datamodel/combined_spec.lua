describe('combined datamodel', function()
    local Datamodel = require'datamodel/combined'
    local mach = require'mach'
    local datamodel_mock_table = {
        read = function() end,
        write = function() end,
        has = function() end,
        subscribe_to_on_change = function() end
    }

    local one = mach.mock_table(datamodel_mock_table, 'one')
    local two = mach.mock_table(datamodel_mock_table, 'two')

    local f = mach.mock_function('f')

    it('should be able to write to a datamodel', function()
        local datamodel = Datamodel({one, two})

        one.has.should_be_called_with('data').and_will_return(true)
        .and_also(one.write.should_be_called_with('data', 5))
        .when(
            function() datamodel.write('data', 5) end
        )

        one.has.should_be_called_with('data').and_will_return(false)
        .and_also(two.has.should_be_called_with('data').and_will_return(true))
        .and_also(two.write.should_be_called_with('data', 5))
        .when(
            function() datamodel.write('data', 5) end
        )
    end)

    it('should be able to read from a datamodel', function()
        local datamodel = Datamodel({one, two})
        local data

        one.has.should_be_called_with('data').and_will_return(true)
        .and_also(one.read.should_be_called_with('data').and_will_return(5))
        .when(
            function() data = datamodel.read('data') end
        )
        assert.are.equal(data, 5)

        one.has.should_be_called_with('data').and_will_return(false)
        .and_also(two.has.should_be_called_with('data').and_will_return(true))
        .and_also(two.read.should_be_called_with('data').and_will_return(6))
        .when(
            function() data = datamodel.read('data') end
        )
        assert.are.equal(data, 6)
    end)

    it('should be able to check if the datamodels have a label', function()
        local datamodel = Datamodel({one, two})
        local has

        one.has.should_be_called_with('data').and_will_return(true)
        .when(
            function() has = datamodel.has('data') end
        )
        assert.is_true(has)

        one.has.should_be_called_with('data').and_will_return(false)
        .and_also(two.has.should_be_called_with('data').and_will_return(true))
        .when(
            function() has = datamodel.has('data') end
        )
        assert.is_true(has)

        one.has.should_be_called_with('data').and_will_return(false)
        .and_also(two.has.should_be_called_with('data').and_will_return(false))
        .when(
            function() has = datamodel.has('data') end
        )
        assert.is_false(has)
    end)

    it('should be able to subscribe to the onchanges of all the datamodels', function()
        local datamodel = Datamodel({one, two})

        one.subscribe_to_on_change.should_be_called_with(mach.match(f))
        .and_also(two.subscribe_to_on_change.should_be_called_with(mach.match(f)))
        .when(
            function() datamodel.subscribe_to_on_change(f) end
        )
    end)

    it('should not be able to read from an unspecified label', function()
        local datamodel = Datamodel({one, two})

        local function the_data_is_read_and_throws_an_error()
            assert.has_errors(
                function() datamodel.read('data') end,
                'label "data" is not specified'
            )
        end

        one.has.should_be_called_with('data').and_will_return(false)
        .and_also(two.has.should_be_called_with('data').and_will_return(false))
        .when(
            the_data_is_read_and_throws_an_error
        )
    end)

    it('should not be able to write to an unspecified label', function()
        local datamodel = Datamodel({one, two})

        local function the_data_is_written_and_an_error_is_thrown()
            assert.has_errors(
                function() datamodel.write('data', 5) end,
                'label "data" is not specified'
            )
        end

        one.has.should_be_called_with('data').and_will_return(false)
        .and_also(two.has.should_be_called_with('data').and_will_return(false))
        .when(
            the_data_is_written_and_an_error_is_thrown
        )
    end)
end)