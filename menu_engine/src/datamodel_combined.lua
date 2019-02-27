return function(datamodels)
    return {
        write = function(label, new_data)
            for _,datamodel in ipairs(datamodels) do
                if datamodel.has(label) then
                    datamodel.write(label, new_data)
                    return
                end
            end
            error('label "' .. label .. '" is not specified')
        end,
        read = function(label)
            for _,datamodel in ipairs(datamodels) do
                if datamodel.has(label) then
                    return datamodel.read(label)
                end
            end
            error('label "' .. label .. '" is not specified')
        end,
        has = function(label)
            for _,datamodel in ipairs(datamodels) do
                if datamodel.has(label) then
                    return true
                end
            end
            return false
        end,
        subscribe_to_on_change = function(callback)
            for _,datamodel in ipairs(datamodels) do
                datamodel.subscribe_to_on_change(callback)
            end
        end
    }
end
