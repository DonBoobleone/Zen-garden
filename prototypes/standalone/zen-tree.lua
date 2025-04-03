local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local tree = zen_utils.tree
local colors = zen_utils.colors
local zen_tree_mapping = zen_utils.zen_tree_mapping  -- Mapping for tree icons (e.g., "pine" -> "tree-01")

-- Define tree types and their tints using colors from zen-tree-utils.lua
local tree_types = {"pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood"}
local tree_tints = {
    pine = colors.forest_green,
    birch = colors.pale_green,
    acacia = colors.olive_green,
    elm = colors.deep_green,
    maple = colors.orange,
    oak = colors.brown,
    juniper = colors.lime_green,
    redwood = colors.red
}

-- Define the planting box layer (static image, rendered behind the tree)
local planting_box_layer = {
    filename = "__zen-garden__/graphics/entity/planting-box.png",
    priority = "extra-high",
    width = 256,
    height = 256,
    frame_count = 1,
    direction_count = 1,
    shift = {0, 0.2},
    scale = 0.36
}

-- Tables to store new prototypes
local new_entities = {}
local new_items = {}
local new_recipes = {}

-- Generate prototypes for each tree type
for index, tree_type in ipairs(tree_types) do
    local tint = tree_tints[tree_type]
    local order_letter = string.char(string.byte("a") + index - 1) -- "a" for pine, "b" for birch, etc.
    local tree_layers = zen_utils.create_single_zen_tree_layers(tree[tree_type], tint)
    local tree_icon_name = zen_tree_mapping[tree_type]  -- e.g., "tree-01" for pine

    -- Add the planting box layer as the first layer (rendered behind the tree)
    table.insert(tree_layers, 1, planting_box_layer)
    -- TODO: Refine for Soil Layer, Tree layer, Planting box layer (Order: Soil back, tree middle, box top)

    -- Entity: Zen tree with tinted layers and planting box
    table.insert(new_entities, {
        type = "simple-entity-with-owner",
        name = "zen-tree-" .. tree_type,
        icon = "__zen-garden__/graphics/icons/zen-garden.png",
        icon_size = 64,
        flags = {"placeable-neutral", "placeable-player", "player-creation"},
        minable = {mining_time = 0.2, result = "zen-tree-" .. tree_type},
        max_health = 100,
        corpse = "small-remnants",
        fast_replaceable_group = "zen-tree",
        emissions_per_second = {pollution = -0.001},
        resistances = {{type = "fire", percent = -50}},
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        animations = {layers = tree_layers}
    })

    -- Item: Placeable tree item with correct base game icon
    table.insert(new_items, {
        type = "item",
        name = "zen-tree-" .. tree_type,
        icons = {
            {icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = {0, 8}},
            {icon = "__base__/graphics/icons/" .. tree_icon_name .. ".png", icon_size = 64, scale = 0.75, shift = {0, -8}, tint = tint}
        },
        subgroup = "gardening",
        order = "a[zen-tree]-" .. order_letter .. "[" .. tree_type .. "]",
        place_result = "zen-tree-" .. tree_type,
        stack_size = 50
    })

    -- Recipe: Handle juniper seed exception
    local seed_name = (tree_type == "juniper") and "tree-seed" or "tree-seed-" .. tree_type
    table.insert(new_recipes, {
        type = "recipe",
        name = "zen-tree-" .. tree_type,
        category = "crafting",
        energy_required = 1,
        enabled = false,
        ingredients = {
            {type = "item", name = "wooden-chest", amount = 1},
            {type = "item", name = "artificial-grass", amount = 1},
            {type = "item", name = seed_name, amount = 1}
        },
        results = {{type = "item", name = "zen-tree-" .. tree_type, amount = 1}}
    })
end

-- Add all new prototypes to the game
data:extend(new_entities)
data:extend(new_items)
data:extend(new_recipes)

-- Create effects table for the technology
local effects = {}
for _, tree_type in ipairs(tree_types) do
    table.insert(effects, {type = "unlock-recipe", recipe = "zen-tree-" .. tree_type})
end

-- Define the technology
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