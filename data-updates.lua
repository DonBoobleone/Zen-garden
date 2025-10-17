data.raw.recipe["wood-processing"].subgroup = "wood-processing"
data.raw.recipe["wood-processing"].order = "a[wood-processing]-a[base]"
data.raw.recipe["wood-processing"].surface_conditions = nil -- allow processing on any surface

-- Inasive Forsetry Setting
if settings.startup["invasive-forestry"].value then
    data.raw.plant["tree-plant"].surface_conditions = { { property = "pressure", min = 1000, max = 2000 } } -- Adds Gleba
end

-- Seed placement
data.raw.item["tree-seed"].subgroup = "seeds"
data.raw.item["tree-seed"].order = "a[base]"

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