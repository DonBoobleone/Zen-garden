local utils = require("__zen-garden__/prototypes/zen-utils")
local tile_restrictions = utils.tile_restrictions

data.raw.plant["tree-plant"].autoplace.tile_restriction = tile_restrictions

for _, plant in pairs(data.raw.plant) do
    if plant.name:find("tree-plant", 1, true) then
        plant.autoplace = plant.autoplace or {}
        plant.autoplace.tile_restriction = tile_restrictions
    end
end

data.raw.recipe["wood-processing"].subgroup = "wood-processing"
data.raw.recipe["wood-processing"].order = "a[wood-processing]-a[base]"

data.raw.item["tree-seed"].subgroup = "seeds"
data.raw.item["tree-seed"].order = "a[base]"

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