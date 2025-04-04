local util = require('util')
local item_sounds = require("__base__.prototypes.item_sounds")

-- Define constants and mappings
local seconds = 60
local minutes = 60 * seconds
local plant_flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"}
local tree_mapping = {
    pine = "tree-01",
    birch = "tree-02",
    acacia = "tree-03",
    elm = "tree-04",
    maple = "tree-05",
    oak = "tree-07",
    redwood = "tree-09"
}
local tree_types = {"pine", "birch", "acacia", "elm", "maple", "oak", "redwood"}

-- Common properties for plant entities
local plant_overrides = {
    type = "plant",
    flags = plant_flags,
    hidden_in_factoriopedia = false,
    factoriopedia_alternative = nil,
    map_color = {0.19, 0.39, 0.19, 0.40},
    agricultural_tower_tint = {
        primary = {r = 0.7, g = 1.0, b = 0.2, a = 1},
        secondary = {r = 0.561, g = 0.613, b = 0.308, a = 1.000}
    },
    minable = {
        mining_particle = "wooden-particle",
        mining_time = 0.5,
        results = {{type = "item", name = "wood", amount = 4}}
    },
    growth_ticks = 10 * minutes,
    surface_conditions = {{property = "pressure", min = 1000, max = 1000}},
    autoplace = {
        probability_expression = 0,
        tile_restriction = {
            "grass-1", "grass-2", "grass-3", "grass-4", "artificial-grass",
            "dry-dirt", "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7",
            "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"
        }
    }
}

-- Create plant entities
local new_plants = {}
for tree_type, tree_name in pairs(tree_mapping) do
    local new_plant = util.table.deepcopy(data.raw["tree"][tree_name])
    new_plant.name = "tree-plant-" .. tree_type
    new_plant.variation_weights = {}
    local variation_count = #new_plant.variations
    for i = 1, variation_count do
        new_plant.variation_weights[i] = (i <= variation_count - 2) and 1 or 0
    end
    for key, value in pairs(plant_overrides) do
        new_plant[key] = value
    end
    table.insert(new_plants, new_plant)
end
data:extend(new_plants)

-- Create seed items
local function create_seed_item(tree_type, tree_name, order_index)
    local order_letter = string.char(string.byte("c") + order_index)
    local tint = (tree_name == "tree-09") and {r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1} or nil
    return {
        type = "item",
        name = "tree-seed-" .. tree_type,
        localised_name = {"item-name.tree-seed-" .. tree_type},
        icons = {
            {icon = "__space-age__/graphics/icons/tree-seed.png", icon_size = 64, scale = 0.5, shift = {0, 0}},
            {icon = "__base__/graphics/icons/" .. tree_name .. ".png", icon_size = 64, scale = 0.25, shift = {-8, 8}, tint = tint}
        },
        subgroup = "seeds",
        order = "a[seeds]-" .. order_letter .. "[tree-seed-" .. tree_type .. "]",
        plant_result = "tree-plant-" .. tree_type,
        place_result = "tree-plant-" .. tree_type,
        inventory_move_sound = item_sounds.wood_inventory_move,
        pick_sound = item_sounds.wood_inventory_pickup,
        drop_sound = item_sounds.wood_inventory_move,
        stack_size = 10,
        weight = 10 * kg,
        fuel_category = "chemical",
        fuel_value = "100kJ"
    }
end

local new_items = {}
for index, tree_type in ipairs(tree_types) do
    local tree_name = tree_mapping[tree_type]
    table.insert(new_items, create_seed_item(tree_type, tree_name, index))
end
data:extend(new_items)

-- Create recipes
local common_recipe_properties = {
    type = "recipe",
    category = "organic-or-assembling",
    subgroup = "wood-processing",
    enabled = false,
    allow_productivity = true,
    surface_conditions = {{property = "pressure", min = 1000, max = 1000}},
    auto_recycle = false,
    crafting_machine_tint = {
        primary = {r = 0.442, g = 0.205, b = 0.090, a = 1.000},
        secondary = {r = 1.000, g = 0.500, b = 0.000, a = 1.000}
    }
}

-- Primitive recipe
local all_seed_names = {"tree-seed"}
for _, tree_type in ipairs(tree_types) do
    table.insert(all_seed_names, "tree-seed-" .. tree_type)
end
local primitive_results = {}
for _, seed_name in ipairs(all_seed_names) do
    table.insert(primitive_results, {type = "item", name = seed_name, amount_min = 1, amount_max = 2})
end
local primitive_recipe = util.table.deepcopy(common_recipe_properties)
primitive_recipe.name = "primitive-wood-processing"
primitive_recipe.icon = "__base__/graphics/icons/tree-01-stump.png"
primitive_recipe.order = "z[primitive-wood-processing]"
primitive_recipe.energy_required = 10
primitive_recipe.ingredients = {{type = "item", name = "wood", amount = 24}}
primitive_recipe.results = primitive_results

-- Function for specific recipes
local function create_specific_recipe(tree_type, tree_name, index)
    local letter = string.char(string.byte("a") + index - 1)
    local icon = tree_type == "redwood" and "__base__/graphics/icons/tree-09-red.png" or "__base__/graphics/icons/" .. tree_name .. ".png"
    local recipe = util.table.deepcopy(common_recipe_properties)
    recipe.name = "wood-processing-" .. tree_type
    recipe.icon = icon
    recipe.order = "b[nauvis-agriculture]-" .. letter .. "[wood-processing-" .. tree_type .. "]"
    recipe.energy_required = 2
    recipe.ingredients = {{type = "item", name = "wood", amount = 2}}
    recipe.results = {{type = "item", name = "tree-seed-" .. tree_type, amount = 1}}
    return recipe
end

local new_recipes = {primitive_recipe}
for index, tree_type in ipairs(tree_types) do
    local tree_name = tree_mapping[tree_type]
    table.insert(new_recipes, create_specific_recipe(tree_type, tree_name, index))
end
data:extend(new_recipes)

-- Create technologies
local function create_technology(tree_type, tree_name)
    local tech_name = "tree-seeding-" .. tree_type
    local recipe_name = "wood-processing-" .. tree_type
    local tree_icon = "__base__/graphics/icons/" .. tree_name .. ".png"
    return {
        type = "technology",
        name = tech_name,
        icons = {
            {icon = tree_icon, icon_size = 64, scale = 1, shift = {-16, -16}},
            {icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256, scale = 0.25, shift = {16, 16}}
        },
        effects = {{type = "unlock-recipe", recipe = recipe_name}},
        prerequisites = {"tree-seeding"},
        unit = {
            count = 50,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"space-science-pack", 1},
                {"agricultural-science-pack", 1}
            },
            time = 60
        }
    }
end

local new_technologies = {}
for _, tree_type in ipairs(tree_types) do
    local tree_name = tree_mapping[tree_type]
    table.insert(new_technologies, create_technology(tree_type, tree_name))
end
data:extend(new_technologies)