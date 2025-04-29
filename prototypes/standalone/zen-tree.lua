local util = require("util")

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

-- Function to create zen tree layers with tint
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

-- Check if zen-trees are enabled
if not settings.startup["zen-trees-enabled"].value then return end

-- Determine whether to use the basic recipe
local use_basic_recipe = settings.startup["force-basic-zen-tree-recipe"].value or not settings.startup["zen-seeds-enabled"].value

-- Base trees
local base_tree_types = { "pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood", "willow" }
local ordered_tree_types = { "juniper" }
for _, tree_type in ipairs(base_tree_types) do
    if tree_type ~= "juniper" then
        table.insert(ordered_tree_types, tree_type)
    end
end
local tree_order_indices = {}
for index, tree_type in ipairs(ordered_tree_types) do
    tree_order_indices[tree_type] = index
end

local tree_definitions = {
    pine = {
        base_tree = "tree-01",
        variation_index = 1,
        tint = { r = 131 / 255, g = 242 / 255, b = 90 / 255, a = 1 },
        seed_name = "tree-seed-pine",
        icons = {{icon = "__base__/graphics/icons/tree-01.png", icon_size = 64}}
    },
    birch = {
        base_tree = "tree-02",
        variation_index = 1,
        tint = { r = 179 / 255, g = 255 / 255, b = 143 / 255, a = 1 },
        seed_name = "tree-seed-birch",
        icons = {{icon = "__base__/graphics/icons/tree-02.png", icon_size = 64}}
    },
    acacia = {
        base_tree = "tree-03",
        variation_index = 1,
        tint = { r = 156 / 255, g = 255 / 255, b = 224 / 255, a = 1 },
        seed_name = "tree-seed-acacia",
        icons = {{icon = "__base__/graphics/icons/tree-03.png", icon_size = 64}}
    },
    elm = {
        base_tree = "tree-04",
        variation_index = 1,
        tint = { r = 107 / 255, g = 224 / 255, b = 108 / 255, a = 1 },
        seed_name = "tree-seed-elm",
        icons = {{icon = "__base__/graphics/icons/tree-04.png", icon_size = 64}}
    },
    maple = {
        base_tree = "tree-05",
        variation_index = 1,
        tint = { r = 255 / 255, g = 153 / 255, b = 51 / 255, a = 1 },
        seed_name = "tree-seed-maple",
        icons = {{icon = "__base__/graphics/icons/tree-05.png", icon_size = 64}}
    },
    oak = {
        base_tree = "tree-07",
        variation_index = 1,
        tint = { r = 153 / 255, g = 102 / 255, b = 51 / 255, a = 1 },
        seed_name = "tree-seed-oak",
        icons = {{icon = "__base__/graphics/icons/tree-07.png", icon_size = 64}}
    },
    juniper = {
        base_tree = "tree-08",
        variation_index = 1,
        tint = { r = 192 / 255, g = 255 / 255, b = 97 / 255, a = 1 },
        seed_name = "tree-seed",
        icons = {{icon = "__base__/graphics/icons/tree-08.png", icon_size = 64}}
    },
    redwood = {
        base_tree = "tree-09",
        variation_index = 4,
        tint = { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 },
        seed_name = "tree-seed-redwood",
        icons = {{icon = "__base__/graphics/icons/tree-09.png", icon_size = 64, tint = { r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1 }}}
    },
    willow = {
        base_tree = "tree-06",
        variation_index = 1,
        tint = { r = 179 / 255, g = 255 / 255, b = 143 / 255, a = 1 },
        seed_name = "tree-seed-willow",
        icons = {{icon = "__base__/graphics/icons/tree-06.png", icon_size = 64}}
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

-- Function to create base zen tree entity
local function create_base_zen_tree_entity(tree_type)
    local def = tree_definitions[tree_type]
    local tree_layers = create_zen_tree_layers(def.variation, def.tint)
    local extra_layers = { planting_box_layer_shadow, planting_box_layer }
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

-- Function to create base zen tree item
local function create_base_zen_tree_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1)
    local tree_icon = util.copy(def.icons[1])
    tree_icon.scale = (tree_icon.scale or 1) * 0.65
    tree_icon.shift = {0, -14}
    tree_icon.tint = def.tint
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

-- Function to create base zen tree recipe
local function create_base_zen_tree_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local seed_name = use_basic_recipe and "tree-seed" or def.seed_name
    return {
        type = "recipe",
        name = "zen-tree-" .. tree_type,
        category = "crafting",
        energy_required = 1,
        enabled = false,
        ingredients = {
            { type = "item", name = "wooden-chest", amount = 1 },
            { type = "item", name = "artificial-grass", amount = 1 },
            { type = "item", name = seed_name, amount = 1 }
        },
        results = { { type = "item", name = "zen-tree-" .. tree_type, amount = 1 } }
    }
end

-- Generate base tree prototypes
local base_entities = {}
local base_items = {}
local base_recipes = {}
for _, tree_type in ipairs(base_tree_types) do
    table.insert(base_entities, create_base_zen_tree_entity(tree_type))
    table.insert(base_items, create_base_zen_tree_item(tree_type))
    table.insert(base_recipes, create_base_zen_tree_recipe(tree_type))
end

-- Base technology
local base_effects = {}
for _, tree_type in ipairs(base_tree_types) do
    table.insert(base_effects, { type = "unlock-recipe", recipe = "zen-tree-" .. tree_type })
end

local base_technology = {
    {
        type = "technology",
        name = "zen-gardening",
        icon = "__zen-garden__/graphics/technology/zen-gardening.png",
        icon_size = 256,
        effects = base_effects,
        prerequisites = { "composting", "automation-2" },
        unit = {
            count = 50,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 }
            },
            time = 30
        }
    }
}

-- Alien trees if mod is present
if mods["alien-biomes"] then
    local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
    local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')

    -- Function to create alien zen tree entity
    local function create_alien_zen_tree_entity(treedata)
        local tree = data.raw["tree"][treedata.name]
        if not tree then
            log("Tree entity not found: " .. treedata.name)
            return nil
        end
        local variation = tree.variations[1]
        local tree_layers = create_zen_tree_layers(variation, treedata.colors[1])
        local extra_layers = { planting_box_layer_shadow, planting_box_layer }
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
            animations = { layers = tree_layers },
            localised_name = { "entity-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. tree_models[treedata.model].locale } }
        }
    end

    -- Function to create alien zen tree item
    local function create_alien_zen_tree_item(treedata)
        local model_data = tree_models[treedata.model]
        if not model_data then
            log("Model data not found for tree: " .. treedata.name)
            return nil
        end
        local item_icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = {0, 8} },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png", icon_size = 64, scale = 0.65, shift = {0, -14} },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, scale = 0.65, shift = {0, -14}, tint = treedata.colors[1] }
        }
        return {
            type = "item",
            name = "zen-tree-" .. treedata.name,
            icons = item_icons,
            subgroup = "gardening",
            order = "b[alien-zen-tree]-" .. treedata.name,
            place_result = "zen-tree-" .. treedata.name,
            stack_size = 50,
            localised_name = { "item-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. model_data.locale } }
        }
    end

    -- Function to create alien zen tree recipe
    local function create_alien_zen_tree_recipe(treedata)
        local model_data = tree_models[treedata.model]
        local specific_seed_name = string.lower(treedata.locale) .. "-" .. string.lower(model_data.locale) .. "-tree-seed"
        local seed_name = use_basic_recipe and "tree-seed" or specific_seed_name
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

    -- Generate alien tree prototypes
    local alien_entities = {}
    local alien_items = {}
    local alien_recipes = {}
    local recipes_by_biome = {}
    local representative_tree_by_biome = {}
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
                        table.insert(alien_entities, entity)
                        local item = create_alien_zen_tree_item(treedata)
                        table.insert(alien_items, item)
                        local recipe = create_alien_zen_tree_recipe(treedata)
                        table.insert(alien_recipes, recipe)
                        if not recipes_by_biome[biome_type] then
                            recipes_by_biome[biome_type] = {}
                        end
                        table.insert(recipes_by_biome[biome_type], recipe.name)
                    end
                end
            end
        end
    end

    -- Create technologies for each biome
    local alien_technologies = {}
    for biome_type, recipes in pairs(recipes_by_biome) do
        local rep_treedata = representative_tree_by_biome[biome_type]
        if rep_treedata then
            local rep_model_data = tree_models[rep_treedata.model]
            local technology = {
                type = "technology",
                name = "alien-zen-gardening-" .. biome_type,
                localised_name = { "technology-name.alien-zen-gardening", { "technology-name.biome-" .. biome_type } },
                icons = {
                    { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-trunk.png", icon_size = 64, scale = 1, shift = { -8, -4 } },
                    { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-leaves.png", icon_size = 64, scale = 1, shift = { -8, -4 }, tint = rep_treedata.colors[1] }
                },
                effects = {},
                prerequisites = { "zen-gardening", },
                unit = {
                    count = 100,
                    ingredients = {
                        { "automation-science-pack", 1 },
                        { "logistic-science-pack", 1 },
                    },
                    time = 30
                }
            }
            for _, recipe_name in ipairs(recipes) do
                table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe_name })
            end
            table.insert(alien_technologies, technology)
        end
    end

    -- Extend data with alien prototypes
    data:extend(alien_entities)
    data:extend(alien_items)
    data:extend(alien_recipes)
    data:extend(alien_technologies)
end

-- Extend data with base prototypes
data:extend(base_entities)
data:extend(base_items)
data:extend(base_recipes)
data:extend(base_technology)