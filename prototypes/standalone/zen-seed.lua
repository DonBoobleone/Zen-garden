local util = require("util")
local item_sounds = require("__base__.prototypes.item_sounds")

-- Define colors
local colors = {
    very_light_green = { r = 252 / 255, g = 255 / 255, b = 133 / 255, a = 1 },
    lime_green = { r = 192 / 255, g = 255 / 255, b = 97 / 255, a = 1 },
    pale_green = { r = 179 / 255, g = 255 / 255, b = 143 / 255, a = 1 },
    light_green = { r = 191 / 255, g = 255 / 255, b = 111 / 255, a = 1 },
    forest_green = { r = 131 / 255, g = 242 / 255, b = 90 / 255, a = 1 },
    olive_green = { r = 156 / 255, g = 255 / 255, b = 224 / 255, a = 1 },
    yellow_green = { r = 210 / 255, g = 230 / 255, b = 85 / 255, a = 1 },
    deep_green = { r = 107 / 255, g = 224 / 255, b = 108 / 255, a = 1 },
    dark_green = { r = 102 / 255, g = 204 / 255, b = 102 / 255, a = 1 },
    orange = { r = 255 / 255, g = 153 / 255, b = 51 / 255, a = 1 },
    red = { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 },
    brown = { r = 153 / 255, g = 102 / 255, b = 51 / 255, a = 1 }
}

-- Define base tile restrictions
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


--[[ based on alien biomes, will rename later
old variants:
01 oaktapus
02 greypine
03 ash
04 scarecrow
05 specter
06 willow
07 mangrove
08 pear
09 baobab
]] --

-- Define base tree types
local base_tree_types = { "pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood", "willow" }
local all_tree_types = base_tree_types

-- Define tree definitions
local tree_definitions = {
    pine = {
        base_tree = "tree-01",
        variation_index = 1,
        tint = colors.forest_green,
        seed_name = "tree-seed-pine",
        icons = { { icon = "__base__/graphics/icons/tree-01.png", icon_size = 64 } }
    },
    birch = {
        base_tree = "tree-02",
        variation_index = 1,
        tint = colors.pale_green,
        seed_name = "tree-seed-birch",
        icons = { { icon = "__base__/graphics/icons/tree-02.png", icon_size = 64 } }
    },
    acacia = {
        base_tree = "tree-03",
        variation_index = 1,
        tint = colors.olive_green,
        seed_name = "tree-seed-acacia",
        icons = { { icon = "__base__/graphics/icons/tree-03.png", icon_size = 64 } }
    },
    elm = {
        base_tree = "tree-04",
        variation_index = 1,
        tint = colors.deep_green,
        seed_name = "tree-seed-elm",
        icons = { { icon = "__base__/graphics/icons/tree-04.png", icon_size = 64 } }
    },
    maple = {
        base_tree = "tree-05",
        variation_index = 1,
        tint = colors.orange,
        seed_name = "tree-seed-maple",
        icons = { { icon = "__base__/graphics/icons/tree-05.png", icon_size = 64 } }
    },
    willow = {
        base_tree = "tree-06",
        variation_index = 1,
        tint = colors.pale_green,
        seed_name = "tree-seed-willow",
        icons = { { icon = "__base__/graphics/icons/tree-06.png", icon_size = 64 } }
    },
    oak = {
        base_tree = "tree-07",
        variation_index = 1,
        tint = colors.brown,
        seed_name = "tree-seed-oak",
        icons = { { icon = "__base__/graphics/icons/tree-07.png", icon_size = 64 } }
    },
    juniper = {
        base_tree = "tree-08",
        variation_index = 1,
        tint = colors.lime_green,
        seed_name = "tree-seed", -- Exception: uses generic seed
        icons = { { icon = "__base__/graphics/icons/tree-08.png", icon_size = 64 } }
    },
    redwood = {
        base_tree = "tree-09",
        variation_index = 4,
        tint = colors.red,
        seed_name = "tree-seed-redwood",
        icons = { { icon = "__base__/graphics/icons/tree-09.png", icon_size = 64, tint = colors.red } }
    }
}

-- Define ordered tree types with juniper first
local ordered_tree_types = { "juniper" }
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(ordered_tree_types, tree_type)
    end
end

-- Define tree order indices
local tree_order_indices = {}
for index, tree_type in ipairs(ordered_tree_types) do
    tree_order_indices[tree_type] = index
end

-- Common properties for recipes
local common_recipe_properties = {
    type = "recipe",
    category = "organic-or-assembling",
    subgroup = "wood-processing",
    enabled = false,
    allow_productivity = true,
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
            new_layer.tint = { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 }
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

-- Generate specific recipe for tree type
local function create_specific_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    local recipe = util.table.deepcopy(common_recipe_properties)
    recipe.name = "wood-processing-" .. tree_type
    recipe.icons = def.icons
    recipe.order = "a[wood-processing]-" .. order_letter .. "[" .. tree_type .. "]"
    recipe.energy_required = 2
    recipe.ingredients = { { type = "item", name = "wood", amount = 2 } }
    recipe.results = { { type = "item", name = "tree-seed-" .. tree_type, amount = 1 } }
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
            { icon = def.icons[1].icon,                                   icon_size = def.icons[1].icon_size, scale = 1,    shift = { -8, -4 } },
            { icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256,                    scale = 0.25, shift = { 16, 16 } }
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
    if tree_type ~= "juniper" then
        table.insert(new_plants, create_seed_plant(tree_type))
    end
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
crude_recipe.subgroup = "basic-gardening"
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
primitive_recipe.subgroup = "basic-gardening"
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
