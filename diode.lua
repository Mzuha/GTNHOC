local component = require("component")
local diode = component.proxy(component.list("bec_diode")())
local io = component.proxy(component.list("bec_io_node")())

local requiredCondensate = io.getRequiredCondensate()

local function getKeys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

local fluids = getKeys(requiredCondensate)

diode.setCondensateFilters(fluids)