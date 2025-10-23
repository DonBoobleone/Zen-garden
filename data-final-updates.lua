local utils = require("__zen-garden__/prototypes/zen-utils")
local tile_restrictions = utils.tile_restrictions

-- Apply tile restrictions to tree-plant autoplace settings
for _, plant in pairs(data.raw.plant) do
    if plant.name:find("tree-plant", 1, true) then
        -- Ensure autoplace exists and is a table, create if nil -- needed for mod compatibility who nil the value.
        if plant.autoplace == nil then
            plant.autoplace = data.raw.plant["tree-plant"].autoplace
        end
        if type(plant.autoplace) == "table" then
            plant.autoplace.tile_restriction = tile_restrictions
        end
    end
end
