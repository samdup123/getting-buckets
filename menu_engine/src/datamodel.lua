local model = {}

return {
    read = function(label) return model[label] end,
    write = function(label, data) model[label] = data end
}