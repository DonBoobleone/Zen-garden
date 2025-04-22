local util = require("util")
local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local all_tree_types = zen_utils.all_tree_types
local tree_definitions = zen_utils.tree_definitions

-- Define planting box layers
local planting_box_shift = util.by_pixel(0, 12)
local planting_box_scale = 0.48
local planting_box_layer = {
    filename = "__zen-garden__/graphics/entity/planting-box/planting-box.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    direction_count = 1,
    shift = planting_box_shift,
    scale = planting_box_scale
}
local planting_box_layer_shadow = {
    filename = "__zen-garden__/graphics/entity/planting-box/planting-box-shadow.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    direction_count = 1,
    shift = planting_box_shift,
    scale = planting_box_scale,
    draw_as_shadow = true
}

-- Creates layers for a single tree variation with the specified tint
local function create_single_zen_tree_layers(tree_variation, tint)
    local layers = {}
    if tree_variation.shadow then
        local shadow = util.copy(tree_variation.shadow)
        shadow.draw_as_shadow = true
        shadow.frame_count = 1
        table.insert(layers, shadow)
    end
    if tree_variation.trunk then
        local trunk = util.copy(tree_variation.trunk)
        trunk.frame_count = 1
        table.insert(layers, trunk)
    end
    if tree_variation.leaves then
        local leaves = util.copy(tree_variation.leaves)
        leaves.frame_count = 1
        leaves.tint = tint
        table.insert(layers, leaves)
    end
    return layers
end

-- Generate Zen tree entity
local function create_zen_tree_entity(tree_type, extra_layers)
    local def = tree_definitions[tree_type]
    local tree_layers = create_single_zen_tree_layers(def.variation, def.tint)
    extra_layers = extra_layers or { planting_box_layer_shadow, planting_box_layer }
    -- Adjust tree layer shifts
    for _, layer in ipairs(tree_layers) do
        layer.shift = {
            layer.shift[1] - planting_box_shift[1],
            layer.shift[2] - planting_box_shift[2]
        }
    end
    for i, layer in ipairs(extra_layers) do
        table.insert(tree_layers, i, layer)
    end
    return {
        type = "simple-entity-with-owner",
        name = "zen-tree-" .. tree_type,
        icon = "__zen-garden__/graphics/icons/zen-garden.png",
        icon_size = 64,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = "zen-tree-" .. tree_type },
        max_health = 100,
        corpse = "small-remnants",
        fast_replaceable_group = "zen-tree",
        emissions_per_second = { pollution = -0.001 },
        resistances = { { type = "fire", percent = -50 } },
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animations = { layers = tree_layers }
    }
end

-- Generate Zen tree item
local function create_zen_tree_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = zen_utils.tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    return {
        type = "item",
        name = "zen-tree-" .. tree_type,
        icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5,  shift = { 0, 8 } },
            { icon = def.icon,                                   icon_size = 64, scale = 0.65, shift = { 0, -14 }, tint = def.tint }
        },
        subgroup = "gardening",
        order = "a[zen-tree]-" .. order_letter .. "[" .. tree_type .. "]",
        place_result = "zen-tree-" .. tree_type,
        stack_size = 50
    }
end

-- Generate Zen tree recipe
local function create_zen_tree_recipe(tree_type)
    local def = tree_definitions[tree_type]
    return {
        type = "recipe",
        name = "zen-tree-" .. tree_type,
        category = "crafting",
        energy_required = 1,
        enabled = false,
        ingredients = {
            { type = "item", name = "wooden-chest",     amount = 1 },
            { type = "item", name = "artificial-grass", amount = 1 },
            { type = "item", name = def.seed_name,      amount = 1 }
        },
        results = { { type = "item", name = "zen-tree-" .. tree_type, amount = 1 } }
    }
end

-- Generate prototypes
local new_entities = {}
local new_items = {}
local new_recipes = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(new_entities, create_zen_tree_entity(tree_type))
    table.insert(new_items, create_zen_tree_item(tree_type))
    table.insert(new_recipes, create_zen_tree_recipe(tree_type))
end


-- Technology effects unlocks a zen-tree for each seed
local effects = {}
for _, tree_type in ipairs(all_tree_types) do
    table.insert(effects, { type = "unlock-recipe", recipe = "zen-tree-" .. tree_type })
end
table.insert(effects, { type = "unlock-recipe", recipe = "primitive-wood-processing" })

local zen_technology = {
    {
        type = "technology",
        name = "zen-gardening",
        icon = "__zen-garden__/graphics/technology/zen-gardening.png",
        icon_size = 256,
        effects = effects,
        prerequisites = { "composting", "automation-2" },
        unit = {
            count = 50,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 }
            },
            time = 30
        }
    }
}

if settings.startup["zen-seeds-enabled"].value and settings.startup["zen-trees-enabled"].value then
    data:extend(new_entities)
    data:extend(new_items)
    data:extend(new_recipes)
    data:extend(zen_technology)
end
