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

data.raw.recipe["tree-seed"].subgroup = "wood-processing"
data.raw.recipe["tree-seed"].order = "a[tree-seed]-a[base]"
data.raw.recipe["tree-seed"].surface_conditions = nil -- allow processing on any surface

-- Inasive Forsetry Setting
if settings.startup["invasive-forestry"].value then
    data.raw.plant["tree-plant"].surface_conditions = { { property = "pressure", min = 800, max = 2000 } } -- Adds Gleba // sub 1000 for Lignumis
end

-- Move tree-seed to landscaping
if settings.startup["move-tree-seed"].value then
    data.raw.item["tree-seed"].subgroup = "seeds"
    data.raw.item["tree-seed"].order = "a[base]"
end
-- Move artificial tiles settings
if settings.startup["move-artificial-tiles"].value then
    data.raw["item-subgroup"]["terrain"].group = "landscaping"

    for tile_name, tile in pairs(data.raw.tile) do
        if tile_name:find("artificial") or tile_name:find("overgrowth") then
            tile.subgroup = "gardening-tiles"
        end
    end

    for recipe_name, recipe in pairs(data.raw.recipe) do
        if recipe_name:find("artificial") or recipe_name:find("overgrowth") then
            recipe.subgroup = "gardening-tiles"
        end
    end
end

-- Fuel Emission override

if settings.startup["fuel-pollution-overhaul"].value then
    data.raw.item["wood"].fuel_emissions_multiplier = 0.5 -- decrease wood to 50%
    data.raw.item["coal"].fuel_emissions_multiplier = 1.5 -- increase coal to 150%
    -- solid fuel can stay 100%
    -- decrease rocket fuel to 80% ??
    -- decrease nuclear fuel to 10% ??
end

-- COMPATIBILITY

if mods["alien-biomes"] then
    require("__zen-garden__/prototypes/compatibility/alien-biomes-zen-seed")
    require("__zen-garden__/prototypes/compatibility/alien-biomes-zen-tree")
end