local component = require("component")
local sides = require("sides")
local diode = component.proxy(component.list("bec_diode")())
local io = component.proxy(component.list("bec_io_node")())
local redstone = component.proxy(component.list("redstone")())
local entang = component.proxy(component.list("gt_machine")())

if(not diode or not io or not redstone or not entang) then
    print("Required components not found. Make sure you have a BEC Diode, BEC IO Node, Redstone component, and BEC Entangler component.")
    return
end

local function getKeys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys
end


while true do

    if(entang.hasWork()) then
        print("Entangler is currently working. Waiting...")
        redstone.setOutput(sides.top, 15)
    else
        redstone.setOutput(sides.top, 0)
    end

    local signal = redstone.getInput(sides.front) > 0

    if(signal) then
        local req = io.getRequiredCondensate()
        if(req == nil) then
            diode.setWorkAllowed(false)
            diode.setCondensateFilters({})
            goto continue
        end
        local fluids = getKeys(req)
        diode.setCondensateFilters(fluids)
        print("Condensate filters set to: " .. table.concat(fluids, ", "))
        diode.setWorkAllowed(true)
    else
        diode.setWorkAllowed(false)
        diode.setCondensateFilters({})
        print("Diode deactivated.")
    end

    ::continue::
    os.sleep(2)
end