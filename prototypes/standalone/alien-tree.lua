if not mods["alien-biomes"] or not settings.startup["zen-trees-enabled"].value then return end

local util = require("util")
local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')

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

-- Function to create zen-tree layers from a tree variation with tint
local function create_alien_zen_tree_layers(variation, tint)
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
        leaves.tint = tint  -- Apply the tint to the leaves
        table.insert(layers, leaves)
    end
    return layers
end

-- Function to create zen-tree entity
local function create_alien_zen_tree_entity(treedata)
    local tree = data.raw["tree"][treedata.name]
    if not tree then
        log("Tree entity not found: " .. treedata.name)
        return nil
    end
    local variation = tree.variations[1]  -- Pick the first variation
    local tree_layers = create_alien_zen_tree_layers(variation, treedata.colors[1])  -- Pass the tint
    local extra_layers = { planting_box_layer_shadow, planting_box_layer }
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
        name = "zen-tree-" .. treedata.name,
        icon = "__zen-garden__/graphics/icons/zen-garden.png",
        icon_size = 64,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = "zen-tree-" .. treedata.name },
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

-- Function to create zen-tree item
local function create_alien_zen_tree_item(treedata)
    -- Get the tree model data
    local model_data = tree_models[treedata.model]
    if not model_data then
        log("Model data not found for tree: " .. treedata.name)
        return nil  -- Skip item creation if model data is missing
    end

    -- Construct the icons array
    local item_icons = {
        { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = {0, 8} },
        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png", icon_size = 64, scale = 0.65, shift = {0, -14} },
        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, scale = 0.65, shift = {0, -14}, tint = treedata.colors[1] }
    }

    -- Define the item prototype
    return {
        type = "item",
        name = "zen-tree-" .. treedata.name,
        icons = item_icons,
        subgroup = "gardening",
        order = "b[alien-zen-tree]-" .. treedata.name,
        place_result = "zen-tree-" .. treedata.name,
        stack_size = 50
    }
end

-- Function to create zen-tree recipe
local function create_alien_zen_tree_recipe(treedata)
    local model_data = tree_models[treedata.model]
    local seed_name = string.lower(treedata.locale) .. "-" .. string.lower(model_data.locale) .. "-tree-seed"
    return {
        type = "recipe",
        name = "zen-tree-" .. treedata.name,
        category = "crafting",
        energy_required = 1,
        enabled = false,
        ingredients = {
            { type = "item", name = "wooden-chest", amount = 1 },
            { type = "item", name = "artificial-grass", amount = 1 },
            { type = "item", name = seed_name, amount = 1 }
        },
        results = { { type = "item", name = "zen-tree-" .. treedata.name, amount = 1 } }
    }
end

-- Initialize tables for new prototypes
local new_entities = {}
local new_items = {}
local new_recipes = {}
local recipes_by_biome = {}
local representative_tree_by_biome = {}

-- Process each tree from trees_data
for _, treedata in pairs(trees_data) do
    if not (treedata.enabled == false) then
        local model_data = tree_models[treedata.model]
        if model_data then
            local biome_type = string.match(treedata.name, "tree%-(%w+)%-")
            if biome_type then
                if not representative_tree_by_biome[biome_type] then
                    representative_tree_by_biome[biome_type] = treedata
                end
                local entity = create_alien_zen_tree_entity(treedata)
                if entity then
                    -- Set localized name for entity
                    entity.localised_name = { "entity-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. model_data.locale } }
                    table.insert(new_entities, entity)
                    local item = create_alien_zen_tree_item(treedata)
                    -- Set localized name for item
                    item.localised_name = { "item-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. model_data.locale } }
                    table.insert(new_items, item)
                    local recipe = create_alien_zen_tree_recipe(treedata)
                    table.insert(new_recipes, recipe)
                    if not recipes_by_biome[biome_type] then
                        recipes_by_biome[biome_type] = {}
                    end
                    table.insert(recipes_by_biome[biome_type], recipe.name)
                end
            end
        end
    end
end

-- Create technologies for each biome type
local new_technologies = {}
for biome_type, recipes in pairs(recipes_by_biome) do
    local rep_treedata = representative_tree_by_biome[biome_type]
    if rep_treedata then
        local rep_model_data = tree_models[rep_treedata.model]
        local technology = {
            type = "technology",
            name = "alien-zen-gardening-" .. biome_type,
            localised_name = { "technology-name.alien-zen-gardening", { "technology-name.biome-" .. biome_type } },
            icons = {
                { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-trunk.png", icon_size = 64, scale = 1, shift = { -8, -4 }},
                { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-leaves.png", icon_size = 64, scale = 1, shift = { -8, -4 }, tint = rep_treedata.colors[1] },
                { icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256, scale = 0.25, shift = { 16, 16 } }
            },
            effects = {},
            prerequisites = { "zen-gardening", "tree-seeding-" .. biome_type },
            unit = {
                count = 100,
                ingredients = {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 }
                },
                time = 30
            }
        }
        for _, recipe_name in ipairs(recipes) do
            table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe_name })
        end
        table.insert(new_technologies, technology)
    end
end

-- Extend game data
data:extend(new_entities)
data:extend(new_items)
data:extend(new_recipes)
data:extend(new_technologies)