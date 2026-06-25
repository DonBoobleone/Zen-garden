-- prototypes/zen-tree.lua
if not settings.startup["zen-trees-enabled"].value then return end

local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local util = require("util")
local tree_definitions = zen_utils.tree_definitions
local ordered_tree_types = zen_utils.ordered_tree_types
local tree_order_indices = zen_utils.tree_order_indices
local base_tree_types = zen_utils.base_tree_types
local all_tree_types = zen_utils.all_tree_types

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

--TODO: Refact into craftingmachineprototype with fixed recipe
local function create_base_zen_tree_entity(tree_type)
    local def = tree_definitions[tree_type]
    local tree_layers = create_zen_tree_layers(def.variation, def.tint)
    local extra_layers = { planting_box_layer_shadow, planting_box_layer }
    local tree_icon = util.copy(def.icons[1])

    for _, layer in ipairs(tree_layers) do
        layer.shift = {
            layer.shift[1] - planting_box_shift[1],
            layer.shift[2] - planting_box_shift[2]
        }
    end
    for i, layer in ipairs(extra_layers) do
        table.insert(tree_layers, i, layer)
    end
    return
    {
        type = "assembling-machine", --"simple-entity-with-owner",
        name = "zen-tree-" .. tree_type,
        icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = { 0, 8 } },
            tree_icon
        },
        icon_size = 64,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = "zen-tree-" .. tree_type },
        max_health = 100,
        corpse = "small-remnants",
        fast_replaceable_group = "zen-tree",
        --emissions_per_second = { pollution = -0.001 },
        resistances = {},
        collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
        selection_box = { { -1, -1 }, { 1, 1 } },
        graphics_set = {
            animation =
            {
                layers = tree_layers
            }
        },
        --animations = { layers = tree_layers },
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
        bottleneck_ignore = true, -- Bottleneck Lite compat
        allowed_effects = {}
    }
end

local function create_base_zen_tree_item(tree_type)
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

local function create_base_zen_tree_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local seed_name = use_basic_recipe and "tree-seed" or def.seed_name
    return {
        type = "recipe",
        name = "zen-tree-" .. tree_type,
        categories = {"crafting"},
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

local base_entities = {}
local base_items = {}
local base_recipes = {}

for _, tree_type in ipairs(base_tree_types) do
    table.insert(base_entities, create_base_zen_tree_entity(tree_type))
    table.insert(base_items, create_base_zen_tree_item(tree_type))
    table.insert(base_recipes, create_base_zen_tree_recipe(tree_type))
end

local base_effects = {}
for _, tree_type in ipairs(base_tree_types) do
    table.insert(base_effects, { type = "unlock-recipe", recipe = "zen-tree-" .. tree_type })
end

local base_technology = {
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
            { "logistic-science-pack",   1 }
        },
        time = 30
    }
}

data:extend(base_entities)
data:extend(base_items)
data:extend(base_recipes)
data:extend({ base_technology })

if mods["alien-biomes"] then
    local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
    local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')

    local function create_alien_zen_tree_entity(treedata)
        local tree = data.raw["tree"][treedata.name]
        if not tree then return nil end
        local variation = tree.variations[1]
        local tree_layers = create_zen_tree_layers(variation, treedata.colors[1])
        local extra_layers = { planting_box_layer_shadow, planting_box_layer }
        -- Icon prep
        local model_data = tree_models[treedata.model]
        if not model_data then return nil end
        local item_icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png",                                                icon_size = 64, scale = 0.5,  shift = { 0, 8 } },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png",  icon_size = 64, scale = 0.65, shift = { 0, -14 } },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, scale = 0.65, shift = { 0, -14 }, tint = treedata.colors[1] }
        }

        for _, layer in ipairs(tree_layers) do
            layer.shift = {
                layer.shift[1] - planting_box_shift[1],
                layer.shift[2] - planting_box_shift[2]
            }
        end
        for i, layer in ipairs(extra_layers) do
            table.insert(tree_layers, i, layer)
        end
        return
        {
            type = "assembling-machine",
            name = "zen-tree-" .. treedata.name,
            icons = item_icons,
            icon_size = 64,
            flags = { "placeable-neutral", "placeable-player", "player-creation" },
            minable = { mining_time = 0.2, result = "zen-tree-" .. treedata.name },
            max_health = 100,
            corpse = "small-remnants",
            fast_replaceable_group = "zen-tree",
            resistances = { { type = "fire", percent = -50 } },
            collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
            selection_box = { { -1, -1 }, { 1, 1 } },
            graphics_set = {
                animation = {
                    layers = tree_layers
                }
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
            bottleneck_ignore = true, -- Bottleneck Lite compat
            allowed_effects = {},
            localised_name = { "entity-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. tree_models[treedata.model].locale } }
        }
    end

    local function create_alien_zen_tree_item(treedata)
        local model_data = tree_models[treedata.model]
        if not model_data then return nil end
        local item_icons = {
            { icon = "__base__/graphics/icons/wooden-chest.png",                                                icon_size = 64, scale = 0.5,  shift = { 0, 8 } },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png",  icon_size = 64, scale = 0.65, shift = { 0, -14 } },
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, scale = 0.65, shift = { 0, -14 }, tint = treedata.colors[1] }
        }
        return {
            type = "item",
            name = "zen-tree-" .. treedata.name,
            icons = item_icons,
            subgroup = "gardening",
            order = "b[alien-zen-tree]-" .. treedata.model,
            place_result = "zen-tree-" .. treedata.name,
            stack_size = 50,
            localised_name = { "item-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. model_data.locale } }
        }
    end

    local function create_alien_zen_tree_recipe(treedata)
        local model_data = tree_models[treedata.model]
        local specific_seed_name = string.lower(treedata.locale) ..
            "-" .. string.lower(model_data.locale) .. "-tree-seed"
        local seed_name = use_basic_recipe and "tree-seed" or specific_seed_name
        return {
            type = "recipe",
            name = "zen-tree-" .. treedata.name,
            categories = {"crafting"},
            energy_required = 1,
            enabled = false,
            ingredients = {
                { type = "item", name = "wooden-chest",     amount = 1 },
                { type = "item", name = "artificial-grass", amount = 1 },
                { type = "item", name = seed_name,          amount = 1 }
            },
            results = { { type = "item", name = "zen-tree-" .. treedata.name, amount = 1 } }
        }
    end

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
                    { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-trunk.png",  icon_size = 64, scale = 1, shift = { -8, -4 } },
                    { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-leaves.png", icon_size = 64, scale = 1, shift = { -8, -4 }, tint = rep_treedata.colors[1] }
                },
                effects = {},
                prerequisites = { "zen-gardening" },
                unit = {
                    count = 100,
                    ingredients = {
                        { "automation-science-pack", 1 },
                        { "logistic-science-pack",   1 },
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

    data:extend(alien_entities)
    data:extend(alien_items)
    data:extend(alien_recipes)
    data:extend(alien_technologies)
end
