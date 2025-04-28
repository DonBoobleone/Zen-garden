local base_tile_restrictions =
{
    "grass-1", "grass-2", "grass-3", "grass-4",
    "dry-dirt", "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7",
    "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"
}

local artificial_tile_restrictions = { "artificial-grass" }
local ab_tile_restrictions = {}
if mods["alien-biomes"] then
    ab_tile_restrictions = alien_biomes.list_tiles(alien_biomes.require_tag(alien_biomes.all_tiles(), { "grass", "dirt" }))
end

local tile_restrictions = {}

-- Merge base tile restrictions
for _, tile in ipairs(base_tile_restrictions) do
    table.insert(tile_restrictions, tile)
end

-- Merge artificial tile restrictions
for _, tile in ipairs(artificial_tile_restrictions) do
    table.insert(tile_restrictions, tile)
end

-- Merge alien biomes tile restrictions if available
if mods["alien-biomes"] then
    for _, tile in ipairs(ab_tile_restrictions) do
        table.insert(tile_restrictions, tile)
    end
end

-- Update base-game tree-seed tile restricitons
data.raw.plant["tree-plant"].autoplace.tile_restriction = tile_restrictions

-- Update all plants to be plantable on Artificial-grass
for _, plant in pairs(data.raw.plant) do
    if plant.type == "plant" and plant.name:find("tree-plant", 1, true) then
        plant.autoplace = plant.autoplace or {}
        plant.autoplace.tile_restriction = plant.autoplace.tile_restriction or {}
        for _, restriction in ipairs(artificial_tile_restrictions) do
            table.insert(plant.autoplace.tile_restriction, restriction)
        end
    end
end

-- Update base-game wood processing subgroup
data.raw.recipe["wood-processing"].subgroup = "wood-processing"
data.raw.recipe["wood-processing"].order = "a[wood-processing]-a[base]"

-- Move base game tree-seed to custom subgroup and set order
data.raw.item["tree-seed"].subgroup = "seeds"
data.raw.item["tree-seed"].order = "a[base]"

-- Move Terrain from logistics to landscaping
if settings.startup["move-artificial-tiles"] then
    data.raw["item-subgroup"]["terrain"].group = "landscaping"

    -- Process tiles: move those with "artificial" or "overgrowth" in their name to gardening-tiles subgroup
    for tile_name, tile in pairs(data.raw.tile) do
        if tile_name:find("artificial") or tile_name:find("overgrowth") then
            tile.subgroup = "gardening-tiles"
        end
    end

    -- Process recipes: move those with "artificial" or "overgrowth" in their name to gardening-tiles subgroup
    for recipe_name, recipe in pairs(data.raw.recipe) do
        if recipe_name:find("artificial") or recipe_name:find("overgrowth") then
            recipe.subgroup = "gardening-tiles"
        end
    end
end
