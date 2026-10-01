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
    local signal = redstone.getInput(sides.front) > 0
    if(signal) then
        local req = io.getRequiredCondensate()
        if(req == nil) then
            diode.setWorkAllowed(false)
            diode.setCondensateFilters({})
            os.sleep(0.5)
            goto continue
        end
        local fluids = getKeys(req)
        diode.setCondensateFilters(fluids)
        print("Condensate filters set to: " .. table.concat(fluids, ", "))
        diode.setWorkAllowed(true)
        os.sleep(1)
    else
        diode.setWorkAllowed(false)
        diode.setCondensateFilters({})
        print("Diode deactivated.")
    end
    ::continue::
    os.sleep(1)
end