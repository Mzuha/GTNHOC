local component = require("component")
local sides = require("sides")
local transposer = component.proxy(component.list("transposer")())

local threshhold = 580688

while true do

    local amAmount = transposer.getTankLevel(sides.back)
    local mAmount = transposer.getTankLevel(sides.front)

    if(amAmount >= threshhold and mAmount >= threshhold) then
        transposer.transferFluid(sides.back, sides.down, threshhold)
        transposer.transferFluid(sides.front, sides.down, threshhold)
    end

    os.sleep(5)
end