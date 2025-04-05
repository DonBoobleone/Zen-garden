local util = require('util')
local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local all_tree_types = zen_utils.all_tree_types

-- Create plant entities
local new_plants = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(new_plants, zen_utils.create_seed_plant(tree_type))
end
data:extend(new_plants)

-- Create seed items, excluding juniper
local new_items = {}
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(new_items, zen_utils.create_seed_item(tree_type))
    end
end
data:extend(new_items)

-- Create specific recipes
local new_recipes = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(new_recipes, zen_utils.create_specific_recipe(tree_type))
end

-- Create primitive recipe with exception for juniper
local all_seed_names = {"tree-seed"}
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(all_seed_names, "tree-seed-" .. tree_type)
    end
end
local primitive_results = {}
for _, seed_name in ipairs(all_seed_names) do
    table.insert(primitive_results, {type = "item", name = seed_name, amount_min = 1, amount_max = 2})
end
local primitive_recipe = util.table.deepcopy(zen_utils.common_recipe_properties)
primitive_recipe.name = "primitive-wood-processing"
primitive_recipe.icon = "__base__/graphics/icons/tree-01-stump.png"
primitive_recipe.order = "z[primitive-wood-processing]"
primitive_recipe.energy_required = 10
primitive_recipe.ingredients = {{type = "item", name = "wood", amount = 24}}
primitive_recipe.results = primitive_results
table.insert(new_recipes, primitive_recipe)

data:extend(new_recipes)

-- Create technologies
local new_technologies = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(new_technologies, zen_utils.create_technology(tree_type))
end
data:extend(new_technologies)