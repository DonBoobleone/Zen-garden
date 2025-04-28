if not mods["alien-biomes"] or not settings.startup["zen-seeds-enabled"].value then return end

local util = require("util")
local item_sounds = require("__base__.prototypes.item_sounds")
local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')

-- Define plant overrides (no growth stages needed, handled by plant prototype)
local plant_overrides = {
    type = "plant",
    flags = { "placeable-neutral", "placeable-off-grid", "breaths-air" },
    hidden_in_factoriopedia = false,
    map_color = { 0.19, 0.39, 0.19, 0.40 },
    minable = {
        mining_particle = "wooden-particle",
        mining_time = 0.5,
        results = { { type = "item", name = "wood", amount = 4 } }
    },
    growth_ticks = 10 * 60 * 60,                                                -- 10 minutes
    surface_conditions = { { property = "pressure", min = 1000, max = 1000 } }, -- for Nauvis
}

-- Define item subgroups
data:extend({
    {
        type = "item-subgroup",
        name = "alien-seeds",
        group = "landscaping",
        order = "x"
    },
    {
        type = "item-subgroup",
        name = "alien-wood-processing",
        group = "landscaping",
        order = "y"
    }
})

-- Function to create plant entity from existing tree entity
local function make_plant(treedata)
    local tree = data.raw["tree"][treedata.name]
    if not tree then
        log("Tree entity not found: " .. treedata.name)
        return
    end
    local plant = util.table.deepcopy(tree)
    plant.type = "plant"
    plant.name = "tree-plant-" .. treedata.name
    -- Apply plant overrides
    for key, value in pairs(plant_overrides) do
        plant[key] = value
    end
    -- Set autoplace for plant
    plant.autoplace = {
        probability_expression = 0,
        tile_restriction = tree.autoplace and tree.autoplace.tile_restriction or nil
    }
    data:extend({ plant })
end

-- Tables to store new prototypes
local new_items = {}
local new_recipes = {}
local recipes_by_biome = {}
local representative_tree_by_biome = {}

-- Process each tree from trees_data
for _, treedata in pairs(trees_data) do
    if not (treedata.enabled == false) then
        local model_data = tree_models[treedata.model]
        if model_data then
            make_plant(treedata)
            local seed_name = string.lower(treedata.locale) .. "-" .. string.lower(model_data.locale) .. "-tree-seed"
            local biome_type = string.match(treedata.name, "tree%-(%w+)%-")
            if biome_type then
                -- Group recipes by biome type
                if not recipes_by_biome[biome_type] then
                    recipes_by_biome[biome_type] = {}
                    representative_tree_by_biome[biome_type] = treedata
                end
                table.insert(recipes_by_biome[biome_type], "wood-processing-" .. treedata.name)

                -- Create seed item
                local seed_item = {
                    type = "item",
                    name = seed_name,
                    localised_name = { "item-name.alien-tree-seed",
                        { "alien-biomes." .. treedata.locale },
                        { "alien-biomes." .. model_data.locale } },
                    icons = {
                        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png",  icon_size = 64 },
                        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, tint = treedata.colors[1] },
                        { icon = "__space-age__/graphics/icons/tree-seed.png",                                              icon_size = 64, scale = 0.25,             shift = { 6, -6 } }
                    },
                    subgroup = "alien-seeds",
                    order = "a[" .. treedata.name .. "]",
                    place_result = "tree-plant-" .. treedata.name,
                    plant_result = "tree-plant-" .. treedata.name,
                    inventory_move_sound = item_sounds.wood_inventory_move,
                    pick_sound = item_sounds.wood_inventory_pickup,
                    drop_sound = item_sounds.wood_inventory_move,
                    stack_size = 10,
                    weight = 10000,
                    fuel_category = "chemical",
                    fuel_value = "100kJ"
                }
                table.insert(new_items, seed_item)

                -- Create wood processing recipe
                local recipe = {
                    type = "recipe",
                    name = "wood-processing-" .. treedata.name,
                    localised_name = { "recipe-name.wood-processing-alien",
                        { "alien-biomes." .. treedata.locale },
                        { "alien-biomes." .. model_data.locale } },
                    icons = {
                        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-trunk.png",  icon_size = 64 },
                        { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. model_data.type_name .. "-leaves.png", icon_size = 64, tint = treedata.colors[1] },
                    },
                    category = "organic-or-assembling",
                    subgroup = "alien-wood-processing",
                    order = "a[" .. treedata.name .. "]",
                    enabled = false,
                    allow_productivity = true,
                    energy_required = 2,
                    ingredients = { { type = "item", name = "wood", amount = 2 } },
                    results = { { type = "item", name = seed_name, amount = 1 } },
                    auto_recycle = false,
                    crafting_machine_tint = {
                        primary = { r = 0.442, g = 0.205, b = 0.090, a = 1.000 },
                        secondary = { r = 1.000, g = 0.500, b = 0.000, a = 1.000 }
                    }
                }
                table.insert(new_recipes, recipe)
            end
        end
    end
end

-- Create technologies for each biome type
local new_technologies = {}
for biome_type, recipes in pairs(recipes_by_biome) do
    local rep_treedata = representative_tree_by_biome[biome_type]
    local rep_model_data = tree_models[rep_treedata.model]
    local technology = {
        type = "technology",
        name = "tree-seeding-" .. biome_type,
        localised_name = { "technology-name.tree-seeding",
            { "technology-name.biome-" .. biome_type } },
        icons = {
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-trunk.png",  icon_size = 64, scale = 1, shift = { -8, -4 }},
            { icon = "__alien-biomes-graphics__/graphics/icons/tree-" .. rep_model_data.type_name .. "-leaves.png", icon_size = 64, scale = 1, shift = { -8, -4 }, tint = rep_treedata.colors[1] },
            { icon = "__space-age__/graphics/technology/agriculture.png", icon_size = 256, scale = 0.25, shift = { 16, 6 } }
        },
        effects = {},
        prerequisites = { "tree-seeding" },
        unit = {
            count = 50,
            ingredients = {
                { "automation-science-pack",   1 },
                { "logistic-science-pack",     1 },
                { "chemical-science-pack",     1 },
                { "space-science-pack",        1 },
                { "agricultural-science-pack", 1 }
            },
            time = 60
        }
    }
    for _, recipe_name in ipairs(recipes) do
        table.insert(technology.effects, { type = "unlock-recipe", recipe = recipe_name })
    end
    table.insert(new_technologies, technology)
end

-- Extend game data
data:extend(new_items)
data:extend(new_recipes)
data:extend(new_technologies)
