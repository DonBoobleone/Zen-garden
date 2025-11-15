-- zen-bonsai-plant.lua
if not settings.startup["bonsai-seed-enabled"].value then return end

local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local tile_restrictions = zen_utils.tile_restrictions

-- Bonsai plant definition
local bonsai_tree_plant = {
    type = "plant",
    name = "tree-plant-bonsai",
    flags = { "placeable-neutral", "placeable-off-grid", "breaths-air" },
    order = "a[tree]-z[zen]-a[bonsai-tree]",
    icon = "__zen-garden__/graphics/icons/bonsai-tree.png",
    icon_size = 64,
    hidden_in_factoriopedia = false,
    factoriopedia_alternative = nil, -- TODO: other trees have their entity with shadow
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    selection_box = { { -0.9, -2.2 }, { 0.9, 0.6 } },  -- From tree-08; adjust if bonsai visuals are smaller
    drawing_box_vertical_extension = 2.2,  -- From tree-08 for proper rendering
    map_color = { 0.39, 0.39, 0.09, 0.40 },
    agricultural_tower_tint = {
        primary = { r = 0.5, g = 1.0, b = 0.2, a = 1 },
        secondary = { r = 0.561, g = 0.613, b = 0.308, a = 1.000 },
    },
    minable = {
        mining_particle = "wooden-particle",
        mining_time = 0.5,
        results = {{ type = "item", name = "wood", amount = 12 }},
    },
    harvest_emissions = { pollution = -1 },
    variation_weights = { 0.7, 0.6, 0.5, 0.7, 0.6, 1, 0.9, 0.7, 0.6, 1, 0.9 },
    colors = { { r = 1, g = 1, b = 1, a = 1 } },
    growth_ticks = 15 * 60 * 60,
    surface_conditions = { { property = "pressure", min = 500, max = 2900 } },
    autoplace = {
        probability_expression = 0,
        tile_restriction = tile_restrictions
    },
    max_health = 50,
    healing_per_tick = 0.01,
    emissions_per_second = { pollution = -0.002 },
    -- remains_when_mined = {}  -- TODO: Add custom stump
    variations = require("__zen-garden__/prototypes/zen-bonsai-variations"),
    subgroup = "trees",
    impact_category = "tree",
}

-- Bonsai seed item
local bonsai_seed_item = {
    type = "item",
    name = "tree-seed-bonsai",
    localised_name = { "item-name.tree-seed-bonsai" },
    plant_result = "tree-plant-bonsai",
    place_result = "tree-plant-bonsai",
    subgroup = "seeds",
    order = "z[zen]-a[bonsai]",
    icons = {
        { icon = "__zen-garden__/graphics/icons/bonsai-tree.png", icon_size = 64, scale = 0.33,  shift = { -4, 4 } },
        { icon = "__space-age__/graphics/icons/tree-seed.png",   icon_size = 64, scale = 0.25, shift = { 4, -4 } }
    },
    stack_size = 100,
    weight = 10 * kg,
    fuel_value = "5MJ",
    fuel_category = "chemical",
}

-- Bonsai seed recipe
local bonsai_seed_recipe = {
    type = "recipe",
    name = "tree-seed-bonsai",
    category = "organic-or-assembling",
    energy_required = 10,
    ingredients = {
        { type = "item", name = "tree-seed",          amount = 10 },
        { type = "item", name = "space-science-pack", amount = 1 },
    },
    results = { { type = "item", name = "tree-seed-bonsai", amount = 10 } },
    enabled = false,
    auto_recycle = false,
}

-- Bonsai seed technology
local bonsai_seed_tech = {
    type = "technology",
    name = "zen-bonsai-seeding",
    icons = {
        { icon = "__zen-garden__/graphics/technology/zen-bonsai.png", icon_size = 256, scale = 0.25, shift = { -16, 16 } },
        { icon = "__space-age__/graphics/icons/tree-seed.png",        icon_size = 64,  scale = 0.5,  shift = { 16, -16 } }
    },
    prerequisites = { "basic-gardening", "space-science-pack" },
    effects = {
        { type = "unlock-recipe", recipe = "tree-seed-bonsai" }
    },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "space-science-pack",      1 }
        },
        time = 60
    },
    localised_description = { "technology-description.zen-bonsai-seeding" },
    order = "z[zen]-a[bonsai]"
}

data:extend({
    bonsai_tree_plant,
    bonsai_seed_item,
    bonsai_seed_recipe,
    bonsai_seed_tech
})


--[[ -- zen-bonsai-plant.lua
if not settings.startup["bonsai-seed-enabled"].value then return end

local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local util = require("util")
local tile_restrictions = zen_utils.tile_restrictions

-- Bonsai tree plant entity
local bonsai_tree_plant = util.table.deepcopy(data.raw["tree"]["tree-08"])
bonsai_tree_plant.type = "plant"
bonsai_tree_plant.name = "tree-plant-bonsai"
bonsai_tree_plant.flags = { "placeable-neutral", "placeable-off-grid", "breaths-air" }
bonsai_tree_plant.order = "a[tree]-z[zen]-a[bonsai-tree]"
bonsai_tree_plant.hidden_in_factoriopedia = false
bonsai_tree_plant.factoriopedia_alternative = nil
bonsai_tree_plant.collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } }
bonsai_tree_plant.map_color = { 0.39, 0.39, 0.09, 0.40 }
bonsai_tree_plant.agricultural_tower_tint = {
    primary = { r = 0.5, g = 1.0, b = 0.2, a = 1 },
    secondary = { r = 0.561, g = 0.613, b = 0.308, a = 1.000 },
}
bonsai_tree_plant.minable = {
    mining_particle = "wooden-particle",
    mining_time = 0.5,
    results = {{ type = "item", name = "wood", amount = 12 }},
}
bonsai_tree_plant.harvest_emissions = { pollution = -1 }
bonsai_tree_plant.variation_weights = { 0.7, 0.6, 0.5, 0.7, 0.6, 1, 0.9, 0.7, 0.6, 1, 0.9 }
bonsai_tree_plant.colors = { { r = 1, g = 1, b = 1, a = 1 } }
bonsai_tree_plant.growth_ticks = 15 * 60 * 60
bonsai_tree_plant.surface_conditions = { { property = "pressure", min = 500, max = 2900 } }
bonsai_tree_plant.autoplace = {
    probability_expression = 0,
    tile_restriction = tile_restrictions
}
bonsai_tree_plant.max_health = 50
bonsai_tree_plant.healing_per_tick = 0.01
bonsai_tree_plant.emissions_per_second = { pollution = -0.002 }
-- bonsai_tree_plant.remains_when_mined = nil  -- TODO: Add custom stump
bonsai_tree_plant.variations = require("__zen-garden__/prototypes/zen-bonsai-variations")

-- Bonsai seed item
local seed_icons = {
    { icon = "__zen-garden__/graphics/icons/bonsai-tree.png", icon_size = 64, scale = 0.33,  shift = { -4, 4 } },
    { icon = "__space-age__/graphics/icons/tree-seed.png",   icon_size = 64, scale = 0.25, shift = { 4, -4 } }
}
local bonsai_seed = util.table.deepcopy(data.raw.item["tree-seed"])
bonsai_seed.name = "tree-seed-bonsai"
bonsai_seed.localised_name = { "item-name.tree-seed-bonsai" }
bonsai_seed.plant_result = "tree-plant-bonsai"
bonsai_seed.place_result = "tree-plant-bonsai"
bonsai_seed.subgroup = "seeds"
bonsai_seed.order = "z[zen]-a[bonsai]"
bonsai_seed.icons = seed_icons
bonsai_seed.stack_size = 100
bonsai_seed.weight = 10 * kg
bonsai_seed.fuel_value = "5MJ"

-- Bonsai seed recipe
local bonsai_seed_recipe = {
    type = "recipe",
    name = "tree-seed-bonsai",
    category = "organic-or-assembling",
    energy_required = 10,
    ingredients = {
        { type = "item", name = "tree-seed",          amount = 10 },
        { type = "item", name = "space-science-pack", amount = 1 },
    },
    results = { { type = "item", name = "tree-seed-bonsai", amount = 10 } },
    enabled = false,
    auto_recycle = false,
}
-- Bonsai technology
local bonsai_tech = {
    type = "technology",
    name = "zen-bonsai-seeding",
    icons = {
        { icon = "__zen-garden__/graphics/technology/zen-bonsai.png", icon_size = 256, scale = 0.25, shift = { -16, 16 } },
        { icon = "__space-age__/graphics/icons/tree-seed.png",        icon_size = 64,  scale = 0.5,  shift = { 16, -16 } }
    },
    prerequisites = { "basic-gardening", "space-science-pack" },
    effects = {
        { type = "unlock-recipe", recipe = "tree-seed-bonsai" }
    },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "space-science-pack",      1 }
        },
        time = 60
    },
    localised_description = { "technology-description.zen-bonsai-seeding" },
    order = "z[zen]-a[bonsai]"
}

data:extend({
    bonsai_tree_plant,
    bonsai_seed,
    bonsai_seed_recipe,
    bonsai_tech
})
 ]]