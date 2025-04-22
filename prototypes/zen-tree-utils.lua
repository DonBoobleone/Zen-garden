local util = require("util")
local item_sounds = require("__base__.prototypes.item_sounds")

-- Define color options for tree tints
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

local tile_restrictions = {
    "grass-1", "grass-2", "grass-3", "grass-4", "artificial-grass",
    "dry-dirt", "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7",
    "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"
}

-- Alien Biomes Compatibility
if mods["alien-biomes"] then
    -- List of chosen tree types from alien biomes
    local ab_tree_types = { "baobab", "conifer", "mangrove", "oaktapus", "palm", "pear", "scarecrow", "specter",}
    local ab_tree_data = require("__alien-biomes__/prototypes/entity/tree-data")
    local ab_tile_restrictions = alien_biomes.list_tiles(alien_biomes.require_tag(alien_biomes.all_tiles(), { "grass", "dirt" }))
    for _, tile in pairs(ab_tile_restrictions) do
        table.insert(tile_restrictions, tile)
    end
end


-- List of all tree types for Zen garden
local all_tree_types = { "pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood", "willow" }

-- Define the order for tree types with juniper first
local ordered_tree_types = { "juniper" }
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(ordered_tree_types, tree_type)
    end
end

-- Mapping from tree_type to its order index
local tree_order_indices = {}
for index, tree_type in ipairs(ordered_tree_types) do
    tree_order_indices[tree_type] = index
end

-- Base game tree definitions
local tree_definitions = {
    pine = {
        base_tree = "tree-01",
        variation_index = 1,
        tint = colors.forest_green,
        seed_name = "tree-seed-pine",
        icon = "__base__/graphics/icons/tree-01.png"
    },
    birch = {
        base_tree = "tree-02",
        variation_index = 1,
        tint = colors.pale_green,
        seed_name = "tree-seed-birch",
        icon = "__base__/graphics/icons/tree-02.png"
    },
    acacia = {
        base_tree = "tree-03",
        variation_index = 1,
        tint = colors.olive_green,
        seed_name = "tree-seed-acacia",
        icon = "__base__/graphics/icons/tree-03.png"
    },
    elm = {
        base_tree = "tree-04",
        variation_index = 1,
        tint = colors.deep_green,
        seed_name = "tree-seed-elm",
        icon = "__base__/graphics/icons/tree-04.png"
    },
    maple = {
        base_tree = "tree-05",
        variation_index = 1,
        tint = colors.orange,
        seed_name = "tree-seed-maple",
        icon = "__base__/graphics/icons/tree-05.png"
    },
    willow = {
        base_tree = "tree-06",
        variation_index = 1,
        tint = colors.pale_green,
        seed_name = "tree-seed-willow",
        icon = "__base__/graphics/icons/tree-06.png"
    },
    oak = {
        base_tree = "tree-07",
        variation_index = 1,
        tint = colors.brown,
        seed_name = "tree-seed-oak",
        icon = "__base__/graphics/icons/tree-07.png"
    },
    juniper = {
        base_tree = "tree-08",
        variation_index = 1,
        tint = colors.lime_green,
        seed_name = "tree-seed", -- Exception: uses generic seed
        icon = "__base__/graphics/icons/tree-08.png"
    },
    redwood = {
        base_tree = "tree-09",
        variation_index = 4,
        tint = colors.red,
        seed_name = "tree-seed-redwood",
        icon = "__base__/graphics/icons/tree-09.png"
    }
}

-- Pre-generate tree variations
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

-- Creates layers with position, scale, and draw order adjustments
local function create_zen_tree_layers(tree_variation, position, tint, scale, draw_order)
    local layers = create_single_zen_tree_layers(tree_variation, tint)
    for _, layer in ipairs(layers) do
        if layer.shift then
            if layer.draw_as_shadow and tree_variation.trunk then
                local trunk_shift = tree_variation.trunk.shift or { 0, 0 }
                layer.shift = {
                    (layer.shift[1] - trunk_shift[1]) * scale + position[1],
                    (layer.shift[2] - trunk_shift[2]) * scale + position[2]
                }
            else
                layer.shift = { position[1], position[2] }
            end
            layer.scale = layer.scale * scale
        end
        layer.secondary_draw_order = draw_order
    end
    return layers
end

-- Creates graphics set for Zen garden
local function create_zen_garden_graphics(tree_table)
    table.sort(tree_table, function(a, b) return a.position[2] < b.position[2] end)
    local all_layers = {}
    for _, tree in ipairs(tree_table) do
        local scale = tree.scale or 1
        local draw_order = math.min(math.max(math.floor(tree.position[2] * 10), -128), 127)
        local tree_layers = create_zen_tree_layers(tree.tree_type, tree.position, tree.tint, scale, draw_order)
        for _, layer in ipairs(tree_layers) do
            table.insert(all_layers, layer)
        end
    end
    return { layers = all_layers }
end

-- Export utilities
return {
    colors = colors,
    tile_restrictions = tile_restrictions,
    all_tree_types = all_tree_types,
    tree_definitions = tree_definitions,
    tree_order_indices = tree_order_indices,
    item_sounds = item_sounds,
    create_single_zen_tree_layers = create_single_zen_tree_layers,
    create_zen_tree_layers = create_zen_tree_layers,
    create_zen_garden_graphics = create_zen_garden_graphics
}