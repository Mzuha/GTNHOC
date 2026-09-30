local component = require("component")
local diode = component.bec_diode

local fluids = {"entangled_neutronium", "entangled_phononmedium"}

diode.setCondensateFilters(fluids)