local util = require("util")
local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local all_tree_types = zen_utils.all_tree_types
local tree_definitions = zen_utils.tree_definitions
local item_sounds = zen_utils.item_sounds
local tile_restrictions = zen_utils.tile_restrictions

-- Alien Biomes Compatibility
--[[ if mods["alien-biomes"] then
    -- List of chosen tree types from alien biomes
    local ab_tree_types = { "palm", "pear"}
    --local ab_tree_data = require("__alien-biomes__/prototypes/entity/tree-data")
end ]]

-- Common properties for recipes
local common_recipe_properties = {
    type = "recipe",
    category = "organic-or-assembling",
    subgroup = "wood-processing",
    enabled = false,
    allow_productivity = true,
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 } },
    auto_recycle = false,
    crafting_machine_tint = {
        primary = { r = 0.442, g = 0.205, b = 0.090, a = 1.000 },
        secondary = { r = 1.000, g = 0.500, b = 0.000, a = 1.000 }
    }
}

-- Common properties for plant entities
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
    growth_ticks = 10 * 60 * 60, -- 10 minutes
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 } },
    autoplace = {
        probability_expression = 0,
        tile_restriction = tile_restrictions
    }
}

-- Generate seed plant entity
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

-- Generate seed item
local function create_seed_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = zen_utils.tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("b") + order_index - 1)
    local tint = (def.base_tree == "tree-09") and { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 } or nil
    return {
        type = "item",
        name = "tree-seed-" .. tree_type,
        localised_name = { "item-name.tree-seed-" .. tree_type },
        icons = {
            { icon = "__space-age__/graphics/icons/tree-seed.png", icon_size = 64, scale = 0.5,  shift = { 0, 0 } },
            { icon = def.icon,                                     icon_size = 64, scale = 0.25, shift = { -8, 8 }, tint = tint }
        },
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

-- Generate specific recipe for tree type
local function create_specific_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = zen_utils.tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    local icon = (tree_type == "redwood") and "__base__/graphics/icons/tree-09-red.png" or def.icon
    local recipe = util.table.deepcopy(common_recipe_properties)
    recipe.name = "wood-processing-" .. tree_type
    recipe.icon = icon
    recipe.order = "a[wood-processing]-" .. order_letter .. "[" .. tree_type .. "]"
    recipe.energy_required = 2
    recipe.ingredients = { { type = "item", name = "wood", amount = 2 } }
    if tree_type == "juniper" then
        recipe.results = { { type = "item", name = "tree-seed", amount = 1 } }
    else
        recipe.results = { { type = "item", name = "tree-seed-" .. tree_type, amount = 1 } }
    end
    return recipe
end

-- Generate technology for tree type
local function create_technology(tree_type)
    local def = tree_definitions[tree_type]
    local tech_name = "tree-seeding-" .. tree_type
    local recipe_name = "wood-processing-" .. tree_type
    return {
        type = "technology",
        name = tech_name,
        icons = {
            { icon = def.icon,                                            icon_size = 64,  scale = 1,    shift = { -16, -16 } },
            { icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256, scale = 0.25, shift = { 16, 16 } }
        },
        effects = { { type = "unlock-recipe", recipe = recipe_name } },
        prerequisites = { "tree-seeding" },
        unit = {
            count = 50,
            ingredients = {
                { "automation-science-pack",   1 },
                { "logistic-science-pack",     1 },
                { "chemical-science-pack",     1 },
                { "space-science-pack",        1 },
                { "agricultural-science-pack", 1 }
            },
            time = 60
        }
    }
end

-- Create plant entities
local new_plants = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(new_plants, create_seed_plant(tree_type))
end

-- Create seed items, excluding juniper
local new_items = {}
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(new_items, create_seed_item(tree_type))
    end
end

-- Create specific recipes
local new_recipes = {}
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(new_recipes, create_specific_recipe(tree_type))
    end
end

-- Create crude recipe
local crude_recipe = util.table.deepcopy(common_recipe_properties)
crude_recipe.name = "crude-wood-processing"
crude_recipe.icon = "__base__/graphics/icons/tree-02-stump.png"
crude_recipe.subgroup = "basic-wood-processing"
crude_recipe.order = "a[crude-wood-processing]"
crude_recipe.energy_required = 2
crude_recipe.ingredients = { { type = "item", name = "wood", amount = 2 } }
crude_recipe.results = { { type = "item", name = "tree-seed", amount = 1, probability = 0.8 } }
data:extend({ crude_recipe })

-- Create primitive recipe
local all_seed_names = { "tree-seed" }
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(all_seed_names, "tree-seed-" .. tree_type)
    end
end
local primitive_results = {}
for _, seed_name in ipairs(all_seed_names) do
    table.insert(primitive_results, { type = "item", name = seed_name, amount_min = 1, amount_max = 2 })
end
local primitive_recipe = util.table.deepcopy(common_recipe_properties)
primitive_recipe.name = "primitive-wood-processing"
primitive_recipe.icon = "__base__/graphics/icons/tree-04-stump.png"
primitive_recipe.subgroup = "basic-wood-processing"
primitive_recipe.order = "b[primitive-wood-processing]"
primitive_recipe.energy_required = 10
primitive_recipe.ingredients = { { type = "item", name = "wood", amount = 24 } }
primitive_recipe.results = primitive_results
table.insert(new_recipes, primitive_recipe)

-- Create technologies
local new_technologies = {}
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(new_technologies, create_technology(tree_type))
    end
end

if settings.startup["zen-seeds-enabled"].value then
    data:extend(new_plants)
    data:extend(new_items)
    data:extend(new_recipes)
    data:extend(new_technologies)
end
