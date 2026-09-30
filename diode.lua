local component = require("component")
local sides = require("sides")
local diode = component.proxy(component.list("bec_diode")())
local io = component.proxy(component.list("bec_io_node")())
local redstone = component.proxy(component.list("redstone")())

local function getKeys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end

while true do
    if(redstone.getInput(sides.front) > 0) then
        local req = io.getRequiredCondensate()
        local fluids = getKeys(req)
        diode.setCondensateFilters(fluids)
        print("Condensate filters set to: " .. table.concat(fluids, ", "))
    end
    os.sleep(0.5)
end