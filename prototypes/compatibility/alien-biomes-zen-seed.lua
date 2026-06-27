-- prototypes/compatibility/alien-biomes-zen-seed.lua
if not settings.startup["zen-seeds-enabled"].value then return end

local util = require("util")
local item_sounds = require("__base__.prototypes.item_sounds")

local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local tile_restrictions = zen_utils.tile_restrictions

local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')

local tree_data_lookup = {}
for _, td in pairs(trees_data) do
    if td and td.name then
        tree_data_lookup[td.name] = td
    end
end

data:extend({
    { type = "item-subgroup", name = "alien-seeds", group = "landscaping", order = "x" },
    { type = "item-subgroup", name = "alien-wood-processing", group = "landscaping", order = "y" }
})

local surface_conditions = { { property = "pressure", min = 1000, max = 1000 } }
if settings.startup["invasive-forestry"].value then
    surface_conditions = { { property = "pressure", min = 900, max = 2000 } }
end

local plant_overrides = {
    type = "plant",
    flags = { "placeable-neutral", "placeable-off-grid", "breaths-air" },
    hidden_in_factoriopedia = false,
    factoriopedia_alternative = nil,
    map_color = { 0.19, 0.39, 0.19, 0.40 },
    agricultural_tower_tint = {
        primary = { r = 0.7, g = 1.0, b = 0.2, a = 1 },
        secondary = { r = 0.561, g = 0.613, b = 0.308, a = 1.000 }
    },
    minable = {
        mining_particle = "wooden-particle",
        mining_time = 0.5,
        results = { { type = "item", name = "wood", amount = 4 } }
    },
    growth_ticks = 10 * 60 * 60,
    surface_conditions = surface_conditions,
    autoplace = {
        probability_expression = 0,
        tile_restriction = tile_restrictions
    }
}

local common_recipe_properties = {
    type = "recipe",
    categories = { "organic", "crafting" },
    subgroup = "alien-wood-processing",
    enabled = false,
    allow_productivity = true,
    auto_recycle = false,
    crafting_machine_tint = {
        primary = { r = 0.442, g = 0.205, b = 0.090, a = 1.000 },
        secondary = { r = 1.000, g = 0.500, b = 0.000, a = 1.000 }
    }
}

local function create_alien_seed_plant(name, tree_proto)
    if not tree_proto or not tree_proto.variations or not tree_proto.variations[1] then
        return nil
    end

    local new_plant = util.table.deepcopy(tree_proto)
    new_plant.name = "tree-plant-" .. name
    new_plant.variation_weights = {}

    local variation_count = #new_plant.variations
    for i = 1, variation_count do
        new_plant.variation_weights[i] = (i <= variation_count - 2) and 1 or 0
    end

    for key, value in pairs(plant_overrides) do
        new_plant[key] = value
    end

    return new_plant
end

local function create_alien_seed_item(name, treedata, model_data)
    local icons
    local item_name = "tree-seed-" .. name
    local localised_name

    if model_data and model_data.type_name then
        -- Nice naming + icons (same style as zen-tree)
        local tint = (treedata.colors and treedata.colors[1]) or {r=1,g=1,b=1,a=1}
        icons = {
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png", icon_size = 64 },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, tint = tint },
            { icon = "__space-age__/graphics/icons/tree-seed.png", icon_size = 64, scale = 0.25, shift = { 6, -6 } }
        }
        localised_name = {
            "item-name.alien-tree-seed",
            { "alien-biomes." .. treedata.locale },
            { "alien-biomes." .. model_data.locale }
        }
    else
        -- Fallback (same style as zen-tree) - use pretty tree name if available
        local tree_proto = data.raw["tree"][name]
        if tree_proto and tree_proto.icons then
            icons = util.table.deepcopy(tree_proto.icons)
        else
            return nil
        end
        if tree_proto and tree_proto.localised_name then
            localised_name = { "item-name.tree-seed", tree_proto.localised_name }
        else
            localised_name = { "item-name.tree-seed", name }
        end
    end

    return {
        type = "item",
        name = item_name,
        localised_name = localised_name,
        icons = icons,
        subgroup = "alien-seeds",
        order = "b[alien-seed]-" .. (model_data and treedata.model or name),
        plant_result = "tree-plant-" .. name,
        place_result = "tree-plant-" .. name,
        inventory_move_sound = item_sounds.wood_inventory_move,
        pick_sound = item_sounds.wood_inventory_pickup,
        drop_sound = item_sounds.wood_inventory_move,
        stack_size = 10,
        weight = 10000,
        fuel_category = "chemical",
        fuel_value = "100kJ"
    }
end

local function create_alien_seed_recipe(name, treedata, model_data)
    local recipe_name = "tree-seed-" .. name
    local item_name = recipe_name
    local localised_name
    local icons = nil

    if model_data and model_data.type_name then
        local tint = (treedata.colors and treedata.colors[1]) or {r=1,g=1,b=1,a=1}
        icons = {
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png", icon_size = 64 },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, tint = tint }
        }
        localised_name = {
            "recipe-name.alien-tree-seed",
            { "alien-biomes." .. treedata.locale },
            { "alien-biomes." .. model_data.locale }
        }
    else
        -- Fallback (same style as zen-tree) - use pretty tree name if available
        local tree_proto = data.raw["tree"][name]
        if tree_proto and tree_proto.localised_name then
            localised_name = { "recipe-name.tree-seed", tree_proto.localised_name }
        else
            localised_name = { "recipe-name.tree-seed", name }
        end
    end

    local recipe = util.table.deepcopy(common_recipe_properties)
    recipe.name = recipe_name
    recipe.localised_name = localised_name
    if icons then recipe.icons = icons end
    recipe.energy_required = 2
    recipe.ingredients = { { type = "item", name = "wood", amount = 2 } }
    recipe.results = { { type = "item", name = item_name, amount = 1 } }

    return recipe
end

-- === Main Execution ===

local alien_plants = {}
local alien_items = {}
local alien_recipes = {}

for name, tree_proto in pairs(data.raw.tree) do
    if tree_proto.factoriopedia_alternative
        and name ~= "tree-01"
        and not string.match(name, "^tree%-0[0-9]$") then

        local treedata = tree_data_lookup[name]
        local model_data = treedata and tree_models[treedata.model]

        if treedata then   -- ← Same as working zen-tree
            local plant = create_alien_seed_plant(name, tree_proto)
            if plant then table.insert(alien_plants, plant) end

            local seed_item = create_alien_seed_item(name, treedata, model_data)
            if seed_item then table.insert(alien_items, seed_item) end

            local recipe = create_alien_seed_recipe(name, treedata, model_data)
            if recipe then table.insert(alien_recipes, recipe) end
        end
    end
end

if #alien_plants > 0 then data:extend(alien_plants) end
if #alien_items > 0 then data:extend(alien_items) end
if #alien_recipes > 0 then data:extend(alien_recipes) end

if #alien_recipes > 0 then
    local effects = {}
    for _, recipe in ipairs(alien_recipes) do
        table.insert(effects, { type = "unlock-recipe", recipe = recipe.name })
    end

    data:extend({
        {
            type = "technology",
            name = "alien-tree-seeding",
            icon = "__space-age__/graphics/technology/agriculture.png",
            icon_size = 256,
            effects = effects,
            prerequisites = { "basic-gardening", "tree-seeding" },
            unit = {
                count = 150,
                ingredients = {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 }
                },
                time = 60
            }
        }
    })
end

log("[zen-garden] Alien seeds created: " .. #alien_items)