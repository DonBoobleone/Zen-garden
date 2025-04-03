local util = require("util")

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

-- Define mapping for Zen garden tree types, extending the base tree_mapping
local zen_tree_mapping = {
    pine = "tree-01",
    birch = "tree-02",
    acacia = "tree-03",
    elm = "tree-04",
    maple = "tree-05",
    oak = "tree-07",
    juniper = "tree-08", -- Included for Zen garden, even if excluded elsewhere
    redwood = "tree-09"
}

-- Generate tree variations dynamically for the Zen garden
local tree = {}
for tree_type, tree_name in pairs(zen_tree_mapping) do
    -- Use variation[4] for tree-09 (redwood), otherwise use variation[1]
    local variation_index = (tree_name == "tree-09") and 4 or 1
    -- Deep copy the selected variation from the base game
    local variation = util.table.deepcopy(data.raw["tree"][tree_name].variations[variation_index])
    -- Simplify components to use a single frame (static image)
    for _, component in pairs({"leaves", "shadow", "trunk"}) do
        if variation[component] and variation[component].frame_count then
            variation[component].frame_count = 1
        end
    end
    -- Remove normal map as it’s not needed for Zen garden
    variation.normal = nil
    tree[tree_type] = variation
end

-- Creates layers for a single tree variation with the specified tint
-- @param tree_variation The tree variation table (e.g., tree["pine"])
-- @param tint The color tint to apply to the leaves
-- @return A table of layers (shadow, trunk, leaves)
function create_single_zen_tree_layers(tree_variation, tint)
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

-- Creates layers for a single tree with position, scale, and draw order adjustments
-- @param tree_variation The tree variation table (e.g., tree["pine"])
-- @param position The {x, y} position to place the tree
-- @param tint The color tint to apply to the leaves
-- @param scale The scale factor for the tree
-- @param draw_order The secondary draw order for rendering
-- @return A table of adjusted layers
function create_zen_tree_layers(tree_variation, position, tint, scale, draw_order)
    local layers = create_single_zen_tree_layers(tree_variation, tint)
    for _, layer in ipairs(layers) do
        if layer.shift then
            if layer.draw_as_shadow and tree_variation.trunk then
                -- Adjust shadow shift relative to trunk position
                local trunk_shift = tree_variation.trunk.shift or {0, 0}
                layer.shift = {
                    (layer.shift[1] - trunk_shift[1]) * scale + position[1],
                    (layer.shift[2] - trunk_shift[2]) * scale + position[2]
                }
            else
                -- Set trunk and leaves shifts directly to the position
                layer.shift = {position[1], position[2]}
            end
            layer.scale = layer.scale * scale
        end
        layer.secondary_draw_order = draw_order
    end
    return layers
end

-- Creates the graphics set for the Zen garden by sorting trees and generating layers
-- @param tree_table A table of trees, each with {tree_type = tree_variation, position = {x, y}, tint = color, scale = number}
-- @return A graphics set with all tree layers
function create_zen_garden_graphics(tree_table)
    -- Sort trees by Y position (north to south) for correct rendering order
    table.sort(tree_table, function(a, b)
        return a.position[2] < b.position[2]
    end)
    local all_layers = {}
    for _, tree in ipairs(tree_table) do
        local scale = tree.scale or 1
        -- Calculate draw order based on Y position, clamped to int8 range (-128 to 127)
        local draw_order = math.min(math.max(math.floor(tree.position[2] * 10), -128), 127)
        local tree_layers = create_zen_tree_layers(tree.tree_type, tree.position, tree.tint, scale, draw_order)
        for _, layer in ipairs(tree_layers) do
            table.insert(all_layers, layer)
        end
    end
    return {layers = all_layers}
end

-- Export the utilities
return {
    tree = tree,
    colors = colors,
    zen_tree_mapping = zen_tree_mapping,
    create_single_zen_tree_layers = create_single_zen_tree_layers,
    create_zen_tree_layers = create_zen_tree_layers,
    create_zen_garden_graphics = create_zen_garden_graphics
}