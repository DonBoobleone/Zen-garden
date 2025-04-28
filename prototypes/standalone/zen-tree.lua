local util = require("util")

-- Define base tree types
local base_tree_types = { "pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood", "willow" }

-- Define ordered tree types with juniper first
local ordered_tree_types = { "juniper" }
for _, tree_type in ipairs(base_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(ordered_tree_types, tree_type)
    end
end

-- Create tree order indices
local tree_order_indices = {}
for index, tree_type in ipairs(ordered_tree_types) do
    tree_order_indices[tree_type] = index
end

-- Define tree definitions with hardcoded tints and icons
local tree_definitions = {
    pine = {
        base_tree = "tree-01",
        variation_index = 1,
        tint = { r = 131 / 255, g = 242 / 255, b = 90 / 255, a = 1 },  -- forest_green
        seed_name = "tree-seed-pine",
        icons = {{icon = "__base__/graphics/icons/tree-01.png", icon_size = 64}}
    },
    birch = {
        base_tree = "tree-02",
        variation_index = 1,
        tint = { r = 179 / 255, g = 255 / 255, b = 143 / 255, a = 1 },  -- pale_green
        seed_name = "tree-seed-birch",
        icons = {{icon = "__base__/graphics/icons/tree-02.png", icon_size = 64}}
    },
    acacia = {
        base_tree = "tree-03",
        variation_index = 1,
        tint = { r = 156 / 255, g = 255 / 255, b = 224 / 255, a = 1 },  -- olive_green
        seed_name = "tree-seed-acacia",
        icons = {{icon = "__base__/graphics/icons/tree-03.png", icon_size = 64}}
    },
    elm = {
        base_tree = "tree-04",
        variation_index = 1,
        tint = { r = 107 / 255, g = 224 / 255, b = 108 / 255, a = 1 },  -- deep_green
        seed_name = "tree-seed-elm",
        icons = {{icon = "__base__/graphics/icons/tree-04.png", icon_size = 64}}
    },
    maple = {
        base_tree = "tree-05",
        variation_index = 1,
        tint = { r = 255 / 255, g = 153 / 255, b = 51 / 255, a = 1 },  -- orange
        seed_name = "tree-seed-maple",
        icons = {{icon = "__base__/graphics/icons/tree-05.png", icon_size = 64}}
    },
    willow = {
        base_tree = "tree-06",
        variation_index = 1,
        tint = { r = 179 / 255, g = 255 / 255, b = 143 / 255, a = 1 },  -- pale_green
        seed_name = "tree-seed-willow",
        icons = {{icon = "__base__/graphics/icons/tree-06.png", icon_size = 64}}
    },
    oak = {
        base_tree = "tree-07",
        variation_index = 1,
        tint = { r = 153 / 255, g = 102 / 255, b = 51 / 255, a = 1 },  -- brown
        seed_name = "tree-seed-oak",
        icons = {{icon = "__base__/graphics/icons/tree-07.png", icon_size = 64}}
    },
    juniper = {
        base_tree = "tree-08",
        variation_index = 1,
        tint = { r = 192 / 255, g = 255 / 255, b = 97 / 255, a = 1 },  -- lime_green
        seed_name = "tree-seed",  -- Exception: uses generic seed
        icons = {{icon = "__base__/graphics/icons/tree-08.png", icon_size = 64}}
    },
    redwood = {
        base_tree = "tree-09",
        variation_index = 4,
        tint = { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 },  -- red
        seed_name = "tree-seed-redwood",
        icons = {{icon = "__base__/graphics/icons/tree-09.png", icon_size = 64, tint = { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 }}}
    }
}

-- Generate tree variations
for tree_type, def in pairs(tree_definitions) do
    local variation = util.table.deepcopy(data.raw["tree"][def.base_tree].variations[def.variation_index])
    for _, component in pairs({ "leaves", "shadow", "trunk" }) do
        if variation[component] and variation[component].frame_count then
            variation[component].frame_count = 1
        end
    end
    variation.normal = nil
    def.variation = variation
end

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
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    -- Copy the first icon layer and adjust its properties
    local tree_icon = util.copy(def.icons[1])
    tree_icon.scale = (tree_icon.scale or 1) * 0.65  -- Apply scale, defaulting to 1 if not present
    tree_icon.shift = {0, -14}                        -- Set shift
    tree_icon.tint = def.tint                         -- Apply the tree's tint
    return {
        type = "item",
        name = "zen-tree-" .. tree_type,
        icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = {0, 8} },
            tree_icon
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
for _, tree_type in ipairs(base_tree_types) do
    table.insert(new_entities, create_zen_tree_entity(tree_type))
    table.insert(new_items, create_zen_tree_item(tree_type))
    table.insert(new_recipes, create_zen_tree_recipe(tree_type))
end

-- Technology effects unlocks a zen-tree for each seed
local effects = {}
for _, tree_type in ipairs(base_tree_types) do
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