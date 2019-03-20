local LibDeflate = require'datamodel/LibDeflate'

return {
    zip = function(s) return LibDeflate:CompressDeflate(s) end,
    unzip = function(compressed) return LibDeflate:DecompressDeflate(compressed) end
}