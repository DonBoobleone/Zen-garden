local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local all_tree_types = zen_utils.all_tree_types

-- Generate prototypes
local new_entities = {}
local new_items = {}
local new_recipes = {}

for _, tree_type in ipairs(all_tree_types) do
    table.insert(new_entities, zen_utils.create_zen_tree_entity(tree_type))
    table.insert(new_items, zen_utils.create_zen_tree_item(tree_type))
    table.insert(new_recipes, zen_utils.create_zen_tree_recipe(tree_type))
end

data:extend(new_entities)
data:extend(new_items)
data:extend(new_recipes)

-- Technology effects
local effects = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(effects, {type = "unlock-recipe", recipe = "zen-tree-" .. tree_type})
end

data:extend({
    {
        type = "technology",
        name = "zen-gardening",
        icon = "__zen-garden__/graphics/technology/zen-gardening.png",
        icon_size = 256,
        effects = effects,
        prerequisites = {"composting", "automation-2"},
        unit = {
            count = 100,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1}
            },
            time = 30
        }
    }
})