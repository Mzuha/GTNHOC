local component = require("component")
local sides = require("sides")
local redstone = component.proxy(component.list("redstone")())

local bec_io_node = component.proxy(component.list("bec_io_node")())
local bec_diode = component.proxy(component.list("bec_diode")())
local bec_storage = component.proxy(component.list("bec_storage")())

if(not bec_diode or not bec_io_node or not redstone or not bec_storage) then
    print("Required components not found. Make sure you have a BEC Diode, BEC IO Node, Redstone component, and BEC Storage component.")
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
     local signal = redstone.getInput(sides.front) > 0

    if(signal) then

        local reqCondensate = bec_io_node.getRequiredCondensate()

        if(reqCondensate == nil) then
            bec_diode.setWorkAllowed(false)
            bec_diode.setCondensateFilters({})
            goto continue
        end

        local availableCondensate = bec_storage.getStoredCondensate()

        for rFluid, rAmount in pairs(reqCondensate) do
            local aAmount = availableCondensate[rFluid] or 0
            if(aAmount < rAmount) then
                print("Not enough " .. rFluid .. ". Required: " .. rAmount .. ", Available: " .. aAmount)
                bec_diode.setWorkAllowed(false)
                bec_diode.setCondensateFilters({})
                redstone.setOutput(sides.top, 15)
                goto continue
            end
        end

        local filters = getKeys(reqCondensate)

        bec_diode.setCondensateFilters(filters)
        print("Condensate filters set to: " .. table.concat(filters, ", "))
        bec_diode.setWorkAllowed(true)
        redstone.setOutput(sides.top, 0)
    else
        bec_diode.setWorkAllowed(false)
        bec_diode.setCondensateFilters({})
    end

    ::continue::
    os.sleep(2)
end