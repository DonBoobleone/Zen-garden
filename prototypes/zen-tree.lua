-- prototypes/zen-tree.lua
-- Base game only. Skips completely if alien-biomes is present.
if not settings.startup["zen-trees-enabled"].value then return end
if mods["alien-biomes"] then return end

local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local util = require("util")

local tree_definitions = zen_utils.tree_definitions
local ordered_tree_types = zen_utils.ordered_tree_types
local tree_order_indices = zen_utils.tree_order_indices
local base_tree_types = zen_utils.base_tree_types

local use_basic_recipe = settings.startup["force-basic-zen-tree-recipe"].value or
    not settings.startup["zen-seeds-enabled"].value

local planting_box_shift = util.by_pixel(0, 9)
local planting_box_scale = 0.33

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

local function create_zen_tree_layers(variation, tint)
    local layers = {}
    if variation.shadow then
        local shadow = util.copy(variation.shadow)
        shadow.draw_as_shadow = true
        shadow.frame_count = 1
        table.insert(layers, shadow)
    end
    if variation.trunk then
        local trunk = util.copy(variation.trunk)
        trunk.frame_count = 1
        table.insert(layers, trunk)
    end
    if variation.leaves then
        local leaves = util.copy(variation.leaves)
        leaves.frame_count = 1
        leaves.tint = tint
        table.insert(layers, leaves)
    end
    return layers
end

local function create_zen_tree_entity(tree_type)
    local def = tree_definitions[tree_type]
    local tree_layers = create_zen_tree_layers(def.variation, def.tint)
    local extra_layers = { planting_box_layer_shadow, planting_box_layer }

    for _, layer in ipairs(tree_layers) do
        layer.shift = {
            (layer.shift[1] or 0) - planting_box_shift[1],
            (layer.shift[2] or 0) - planting_box_shift[2]
        }
    end
    for i, layer in ipairs(extra_layers) do
        table.insert(tree_layers, i, layer)
    end

    return {
        type = "assembling-machine",
        name = "zen-tree-" .. tree_type,
        icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = { 0, 8 } },
            util.copy(def.icons[1])
        },
        icon_size = 64,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = "zen-tree-" .. tree_type },
        max_health = 100,
        corpse = "small-remnants",
        fast_replaceable_group = "zen-tree",
        collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
        selection_box = { { -1, -1 }, { 1, 1 } },
        graphics_set = {
            animation = { layers = tree_layers }
        },
        crafting_categories = { "gardening" },
        fixed_recipe = "zen-chi",
        show_recipe_icon = false,
        show_recipe_icon_on_map = false,
        crafting_speed = 1,
        energy_source = {
            type = "void",
            emissions_per_minute = { pollution = -0.06 }
        },
        energy_usage = "1kW",
        module_slots = nil,
        bottleneck_ignore = true,
        allowed_effects = {}
    }
end

local function create_zen_tree_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    local tree_icon = util.copy(def.icons[1])
    tree_icon.scale = (tree_icon.scale or 1) * 0.65
    tree_icon.shift = { 0, -14 }
    tree_icon.tint = def.tint

    return {
        type = "item",
        name = "zen-tree-" .. tree_type,
        icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = { 0, 8 } },
            tree_icon
        },
        subgroup = "gardening",
        order = "a[zen-tree]-" .. order_letter .. "[" .. tree_type .. "]",
        place_result = "zen-tree-" .. tree_type,
        stack_size = 50
    }
end

local function create_zen_tree_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local seed_name = use_basic_recipe and "tree-seed" or def.seed_name

    return {
        type = "recipe",
        name = "zen-tree-" .. tree_type,
        categories = { "crafting" },
        energy_required = 1,
        enabled = false,
        ingredients = {
            { type = "item", name = "wooden-chest",     amount = 1 },
            { type = "item", name = "artificial-grass", amount = 1 },
            { type = "item", name = seed_name,          amount = 1 }
        },
        results = { { type = "item", name = "zen-tree-" .. tree_type, amount = 1 } }
    }
end

-- === Base game trees only ===
local entities = {}
local items = {}
local recipes = {}

for _, tree_type in ipairs(base_tree_types) do
    table.insert(entities, create_zen_tree_entity(tree_type))
    table.insert(items, create_zen_tree_item(tree_type))
    table.insert(recipes, create_zen_tree_recipe(tree_type))
end

data:extend(entities)
data:extend(items)
data:extend(recipes)

-- Technology
local effects = {}
for _, tree_type in ipairs(base_tree_types) do
    table.insert(effects, { type = "unlock-recipe", recipe = "zen-tree-" .. tree_type })
end

data:extend({
    {
        type = "technology",
        name = "zen-gardening",
        icon = "__zen-garden__/graphics/technology/zen-gardening.png",
        icon_size = 256,
        effects = effects,
        prerequisites = { "composting" },
        unit = {
            count = 50,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 }
            },
            time = 30
        }
    }
})