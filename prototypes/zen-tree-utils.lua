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

-- List of all tree types for Zen garden
local all_tree_types = {"pine", "birch", "acacia", "elm", "maple", "oak", "juniper", "redwood"}

-- Define the order for tree types with juniper first
local ordered_tree_types = {"juniper"}
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

-- Centralized tree definitions
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
    for _, component in pairs({"leaves", "shadow", "trunk"}) do
        if variation[component] and variation[component].frame_count then
            variation[component].frame_count = 1
        end
    end
    variation.normal = nil
    def.variation = variation
end

-- Define constants for seed-related prototypes
local seconds = 60
local minutes = 60 * seconds
local plant_flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"}

-- Common properties for plant entities
local plant_overrides = {
    type = "plant",
    flags = plant_flags,
    hidden_in_factoriopedia = false,
    factoriopedia_alternative = nil,
    map_color = {0.19, 0.39, 0.19, 0.40},
    agricultural_tower_tint = {
        primary = {r = 0.7, g = 1.0, b = 0.2, a = 1},
        secondary = {r = 0.561, g = 0.613, b = 0.308, a = 1.000}
    },
    minable = {
        mining_particle = "wooden-particle",
        mining_time = 0.5,
        results = {{type = "item", name = "wood", amount = 4}}
    },
    growth_ticks = 10 * minutes,
    surface_conditions = {{property = "pressure", min = 1000, max = 1000}},
    autoplace = {
        probability_expression = 0,
        tile_restriction = {
            "grass-1", "grass-2", "grass-3", "grass-4", "artificial-grass",
            "dry-dirt", "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7",
            "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"
        }
    }
}

-- Common properties for recipes
local common_recipe_properties = {
    type = "recipe",
    category = "organic-or-assembling",
    subgroup = "wood-processing",
    enabled = false,
    allow_productivity = true,
    surface_conditions = {{property = "pressure", min = 1000, max = 1000}},
    auto_recycle = false,
    crafting_machine_tint = {
        primary = {r = 0.442, g = 0.205, b = 0.090, a = 1.000},
        secondary = {r = 1.000, g = 0.500, b = 0.000, a = 1.000}
    }
}

-- Creates layers for a single tree variation with the specified tint
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

-- Creates layers with position, scale, and draw order adjustments
function create_zen_tree_layers(tree_variation, position, tint, scale, draw_order)
    local layers = create_single_zen_tree_layers(tree_variation, tint)
    for _, layer in ipairs(layers) do
        if layer.shift then
            if layer.draw_as_shadow and tree_variation.trunk then
                local trunk_shift = tree_variation.trunk.shift or {0, 0}
                layer.shift = {
                    (layer.shift[1] - trunk_shift[1]) * scale + position[1],
                    (layer.shift[2] - trunk_shift[2]) * scale + position[2]
                }
            else
                layer.shift = {position[1], position[2]}
            end
            layer.scale = layer.scale * scale
        end
        layer.secondary_draw_order = draw_order
    end
    return layers
end

-- Creates graphics set for Zen garden
function create_zen_garden_graphics(tree_table)
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
    return {layers = all_layers}
end

-- Planting box layer definition
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

-- Generate Zen tree entity
function create_zen_tree_entity(tree_type, extra_layers)
    local def = tree_definitions[tree_type]
    local tree_layers = create_single_zen_tree_layers(def.variation, def.tint)
    extra_layers = extra_layers or {planting_box_layer}
    for i, layer in ipairs(extra_layers) do
        table.insert(tree_layers, i, layer)
    end
    return {
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
    }
end

-- Generate Zen tree item
function create_zen_tree_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1) -- 'a' for juniper, 'b' for pine, etc.
    return {
        type = "item",
        name = "zen-tree-" .. tree_type,
        icons = {
            {icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = {0, 8}},
            {icon = def.icon, icon_size = 64, scale = 0.65, shift = {0, -14}, tint = def.tint}
        },
        subgroup = "gardening",
        order = "a[zen-tree]-" .. order_letter .. "[" .. tree_type .. "]",
        place_result = "zen-tree-" .. tree_type,
        stack_size = 50
    }
end

-- Generate Zen tree recipe
function create_zen_tree_recipe(tree_type)
    local def = tree_definitions[tree_type]
    return {
        type = "recipe",
        name = "zen-tree-" .. tree_type,
        category = "crafting",
        energy_required = 1,
        enabled = false,
        ingredients = {
            {type = "item", name = "wooden-chest", amount = 1},
            {type = "item", name = "artificial-grass", amount = 1},
            {type = "item", name = def.seed_name, amount = 1}
        },
        results = {{type = "item", name = "zen-tree-" .. tree_type, amount = 1}}
    }
end

-- Generate seed plant entity
function create_seed_plant(tree_type)
    local def = tree_definitions[tree_type]
    local new_plant = util.table.deepcopy(data.raw["tree"][def.base_tree])
    new_plant.name = "tree-plant-" .. tree_type
    new_plant.variation_weights = {}
    local variation_count = #new_plant.variations
    for i = 1, variation_count do
        new_plant.variation_weights[i] = (i <= variation_count - 2) and 1 or 0
    end
    for key, value in pairs(plant_overrides) do
        new_plant[key] = value
    end
    return new_plant
end

-- Generate seed item
function create_seed_item(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("b") + order_index - 1) -- 'b' for juniper, 'c' for pine, etc.
    local tint = (def.base_tree == "tree-09") and {r = 230 / 255, g = 92 / 255, b = 92 / 255, a = 1} or nil
    return {
        type = "item",
        name = "tree-seed-" .. tree_type,
        localised_name = {"item-name.tree-seed-" .. tree_type},
        icons = {
            {icon = "__space-age__/graphics/icons/tree-seed.png", icon_size = 64, scale = 0.5, shift = {0, 0}},
            {icon = def.icon, icon_size = 64, scale = 0.25, shift = {-8, 8}, tint = tint}
        },
        subgroup = "seeds",
        order = order_letter .. "[" .. tree_type .. "]",
        plant_result = "tree-plant-" .. tree_type,
        place_result = "tree-plant-" .. tree_type,
        inventory_move_sound = item_sounds.wood_inventory_move,
        pick_sound = item_sounds.wood_inventory_pickup,
        drop_sound = item_sounds.wood_inventory_move,
        stack_size = 10,
        weight = 10,
        fuel_category = "chemical",
        fuel_value = "100kJ"
    }
end

-- Generate specific recipe for tree type
function create_specific_recipe(tree_type)
    local def = tree_definitions[tree_type]
    local order_index = tree_order_indices[tree_type]
    local order_letter = string.char(string.byte("a") + order_index - 1) -- 'a' for juniper, 'b' for pine, etc.
    local icon = (tree_type == "redwood") and "__base__/graphics/icons/tree-09-red.png" or def.icon
    local recipe = util.table.deepcopy(common_recipe_properties)
    recipe.name = "wood-processing-" .. tree_type
    recipe.icon = icon
    recipe.order = "a[wood-processing]-" .. order_letter .. "[" .. tree_type .. "]"
    recipe.energy_required = 2
    recipe.ingredients = {{type = "item", name = "wood", amount = 2}}
    -- Use base game tree-seed for juniper, custom seed for other tree types
    if tree_type == "juniper" then
        recipe.results = {{type = "item", name = "tree-seed", amount = 1}}
    else
        recipe.results = {{type = "item", name = "tree-seed-" .. tree_type, amount = 1}}
    end
    return recipe
end

-- Generate technology for tree type
function create_technology(tree_type)
    local def = tree_definitions[tree_type]
    local tech_name = "tree-seeding-" .. tree_type
    local recipe_name = "wood-processing-" .. tree_type
    return {
        type = "technology",
        name = tech_name,
        icons = {
            {icon = def.icon, icon_size = 64, scale = 1, shift = {-16, -16}},
            {icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256, scale = 0.25, shift = {16, 16}}
        },
        effects = {{type = "unlock-recipe", recipe = recipe_name}},
        prerequisites = {"tree-seeding"},
        unit = {
            count = 50,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"space-science-pack", 1},
                {"agricultural-science-pack", 1}
            },
            time = 60
        }
    }
end

-- Export utilities
return {
    tree = tree_definitions,
    colors = colors,
    all_tree_types = all_tree_types,
    tree_definitions = tree_definitions,
    create_single_zen_tree_layers = create_single_zen_tree_layers,
    create_zen_tree_layers = create_zen_tree_layers,
    create_zen_garden_graphics = create_zen_garden_graphics,
    create_zen_tree_entity = create_zen_tree_entity,
    create_zen_tree_item = create_zen_tree_item,
    create_zen_tree_recipe = create_zen_tree_recipe,
    create_seed_plant = create_seed_plant,
    create_seed_item = create_seed_item,
    create_specific_recipe = create_specific_recipe,
    create_technology = create_technology,
    common_recipe_properties = common_recipe_properties
}