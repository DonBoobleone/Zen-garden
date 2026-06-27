-- prototypes/zen-seed.lua
-- Base game only. Skips completely if alien-biomes is present.
if not settings.startup["zen-seeds-enabled"].value then return end
if mods["alien-biomes"] then return end

local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local util = require("util")
local item_sounds = require("__base__.prototypes.item_sounds")

local tree_definitions = zen_utils.tree_definitions
local tile_restrictions = zen_utils.tile_restrictions
local ordered_tree_types = zen_utils.ordered_tree_types
local tree_order_indices = zen_utils.tree_order_indices
local base_tree_types = zen_utils.base_tree_types

-- Fallback for Krastorio2-spaced-out (KSO2)
local kso2_mod_name = "Krastorio2-spaced-out"
local tree_seeding_prerequisites
if mods[kso2_mod_name] then
    tree_seeding_prerequisites = { "basic-gardening" }
else
    tree_seeding_prerequisites = { "basic-gardening", "tree-seeding" }
end

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
    subgroup = "wood-processing",
    enabled = false,
    allow_productivity = true,
    auto_recycle = false,
    surface_conditions = nil,
    crafting_machine_tint = {
        primary = { r = 0.442, g = 0.205, b = 0.090, a = 1.000 },
        secondary = { r = 1.000, g = 0.500, b = 0.000, a = 1.000 }
    }
}

local function create_seed_plant(tree_type)
    local def = tree_definitions[tree_type]
    local new_plant = util.table.deepcopy(data.raw["tree"][def.base_tree])
    new_plant.name = "tree-plant-" .. tree_type
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

local function create_seed_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("b") + order_index - 1)
    local seed_icons = {
        { icon = "__space-age__/graphics/icons/tree-seed.png", icon_size = 64, scale = 0.25, shift = { 4, -4 } }
    }
    for _, layer in ipairs(def.icons) do
        local new_layer = util.copy(layer)
        new_layer.scale = (new_layer.scale or 1) * 0.33
        new_layer.shift = { -4, 4 }
        if tree_type == "redwood" then
            new_layer.tint = def.tint
        end
        table.insert(seed_icons, new_layer)
    end
    return {
        type = "item",
        name = "tree-seed-" .. tree_type,
        localised_name = { "item-name.tree-seed-" .. tree_type },
        icons = seed_icons,
        subgroup = "seeds",
        order = order_letter .. "[" .. tree_type .. "]",
        plant_result = "tree-plant-" .. tree_type,
        place_result = "tree-plant-" .. tree_type,
        inventory_move_sound = item_sounds.wood_inventory_move,
        pick_sound = item_sounds.wood_inventory_pickup,
        drop_sound = item_sounds.wood_inventory_move,
        stack_size = 10,
        weight = 10,
        fuel_category = "chemical",
        fuel_value = "100kJ"
    }
end

local function create_specific_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    local recipe = util.table.deepcopy(common_recipe_properties)
    recipe.name = "tree-seed-" .. tree_type
    recipe.icons = def.icons
    recipe.order = "a[tree-seed]-" .. order_letter .. "[" .. tree_type .. "]"
    recipe.energy_required = 2
    recipe.ingredients = { { type = "item", name = "wood", amount = 2 } }
    recipe.results = { { type = "item", name = "tree-seed-" .. tree_type, amount = 1 } }
    return recipe
end

local function gather_recipes_to_unlock(tree_type)
    local recipe_name = "tree-seed-" .. tree_type
    return { type = "unlock-recipe", recipe = recipe_name }
end

local new_plants = {}
local new_items = {}
local new_recipes = {}
local unlock_effects = {}

for _, tree_type in ipairs(base_tree_types) do
    table.insert(new_plants, create_seed_plant(tree_type))
    table.insert(new_items, create_seed_item(tree_type))
    table.insert(new_recipes, create_specific_recipe(tree_type))
    table.insert(unlock_effects, gather_recipes_to_unlock(tree_type))
end

local new_technologies = {
    {
        type = "technology",
        name = "tree-seeding-selection",
        icons = {
            { icon = tree_definitions["pine"].icons[1].icon, icon_size = tree_definitions["pine"].icons[1].icon_size, scale = 1, shift = { -8, -4 } },
            { icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256, scale = 0.25, shift = { 16, 16 } }
        },
        effects = unlock_effects,
        prerequisites = tree_seeding_prerequisites,
        unit = {
            count = 100,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 }
            },
            time = 60
        }
    }
}

data:extend(new_plants)
data:extend(new_items)
data:extend(new_recipes)
data:extend(new_technologies)