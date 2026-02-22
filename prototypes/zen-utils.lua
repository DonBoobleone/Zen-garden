local util = require("util")
local item_sounds = require("__base__.prototypes.item_sounds")

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

local base_tile_restrictions = {
    "grass-1", "grass-2", "grass-3", "grass-4",
    "dry-dirt", "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7",
    "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"
}

local artificial_tile_restrictions = { "artificial-grass"}
if settings.startup["enable-extended-grass-selection"] and settings.startup["enable-extended-grass-selection"].value then
    table.insert(artificial_tile_restrictions, "artificial-grass-2")
    table.insert(artificial_tile_restrictions, "artificial-grass-3")
end


local tile_restrictions = {}
for _, tile in ipairs(base_tile_restrictions) do
    table.insert(tile_restrictions, tile)
end
for _, tile in ipairs(artificial_tile_restrictions) do
    table.insert(tile_restrictions, tile)
end

if mods["alien-biomes"] then
    local ab_tile_restrictions = alien_biomes.list_tiles(alien_biomes.require_tag(alien_biomes.all_tiles(),
        { "grass", "dirt" }))
    for _, tile in ipairs(ab_tile_restrictions) do
        table.insert(tile_restrictions, tile)
    end
end

if mods["lignumis"] then
    local lignumis_special_tile = { "natural-gold-soil" }
    for _, tile in ipairs(lignumis_special_tile) do
        table.insert(tile_restrictions, tile)
    end
end

if mods["moon-eneas"] then
    local eneas_tiles = {"dry-dirt-eneas", "path-dirt-eneas", "main-grass-eneas"}
    for _, tile in ipairs(eneas_tiles) do
        table.insert(tile_restrictions, tile)
    end
end

local base_tree_types = { "pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood", "willow" }
local all_tree_types = util.table.deepcopy(base_tree_types)
local ab_tree_types = {}

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

if mods["alien-biomes"] and settings.startup["zen-seeds-enabled"].value then
    local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
    local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')
    for _, treedata in pairs(trees_data) do
        if not (treedata.enabled == false) then
            local model_data = tree_models[treedata.model]
            if model_data then
                local tint = treedata.colors[1]
                tree_definitions[treedata.name] = {
                    base_tree = treedata.name,
                    variation_index = 1,
                    tint = tint,
                    seed_name = string.lower(treedata.locale) .. "-" .. string.lower(model_data.locale) .. "-tree-seed",
                    icons = {
                        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png",  icon_size = 64 },
                        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, tint = tint }
                    }
                }
                table.insert(all_tree_types, treedata.name)
                table.insert(ab_tree_types, treedata.name)
            end
        end
    end
end

local ordered_tree_types = { "juniper" }
for _, tree_type in ipairs(all_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(ordered_tree_types, tree_type)
    end
end

local tree_order_indices = {}
for index, tree_type in ipairs(ordered_tree_types) do
    tree_order_indices[tree_type] = index
end

-- Pre-generate variations
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
            layer.scale = (layer.scale or 1) * scale
        end
        layer.secondary_draw_order = draw_order
    end
    return layers
end

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

return {
    colors = colors,
    tile_restrictions = tile_restrictions,
    base_tree_types = base_tree_types,
    all_tree_types = all_tree_types,
    ab_tree_types = ab_tree_types,
    ordered_tree_types = ordered_tree_types,
    tree_order_indices = tree_order_indices,
    tree_definitions = tree_definitions,
    item_sounds = item_sounds,
    create_single_zen_tree_layers = create_single_zen_tree_layers,
    create_zen_tree_layers = create_zen_tree_layers,
    create_zen_garden_graphics = create_zen_garden_graphics
}
