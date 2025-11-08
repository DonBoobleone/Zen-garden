-- zen-bonsai-plant.lua
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
bonsai_tree_plant.collision_box = {{-0.4, -0.4}, {0.4, 0.4}}
bonsai_tree_plant.map_color = { 0.39, 0.39, 0.09, 0.40 }
bonsai_tree_plant.agricultural_tower_tint = {
    primary = { r = 0.5, g = 1.0, b = 0.2, a = 1 },
    secondary = { r = 0.561, g = 0.613, b = 0.308, a = 1.000 },
}
bonsai_tree_plant.minable = {
    mining_particle = "wooden-particle",
    mining_time = 0.5,
    results = { { type = "item", name = "wood", amount = 12 } },
}
bonsai_tree_plant.variation_weights = { 1 }
bonsai_tree_plant.growth_ticks = 15 * 60 * 60
bonsai_tree_plant.surface_conditions = { { property = "pressure", min = 100, max = 2900 } }
bonsai_tree_plant.autoplace = {
    probability_expression = 0,
    tile_restriction = tile_restrictions
}
bonsai_tree_plant.max_health = 50
bonsai_tree_plant.healing_per_tick = 0.01
bonsai_tree_plant.emissions_per_second = { pollution = -0.002 }
-- bonsai_tree_plant.remains_when_mined = nil  -- TODO: Add custom stump
bonsai_tree_plant.variations = {
    {
        leaf_generation = {
            type = "create-particle",
            particle_name = "leaf-particle",
            offset_deviation = { {-0.3, -0.3}, {0.3, 0.3} },
            initial_height = 1,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.01,
            initial_vertical_speed_deviation = 0.02,
            speed_from_center = 0.02,
            speed_from_center_deviation = 0.03
        },
        branch_generation = {
            type = "create-particle",
            particle_name = "branch-particle",
            offset_deviation = { {-0.3, -0.3}, {0.3, 0.3} },
            initial_height = 1,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.01,
            initial_vertical_speed_deviation = 0.02,
            speed_from_center = 0.02,
            speed_from_center_deviation = 0.03,
            frame_speed = 0.5,
            frame_speed_deviation = 0.5
        },
        leaves_when_damaged = 100,
        leaves_when_destroyed = 35,
        leaves_when_mined_manually = 40,
        leaves_when_mined_automatically = 16,
        branches_when_damaged = 20,
        branches_when_destroyed = 16,
        branches_when_mined_manually = 15,
        branches_when_mined_automatically = 8,
        trunk = {
            filename = "__zen-garden__/graphics/entity/zen-bonsai/zen-bonsai-tree-01.png",
            width = 384,
            height = 384,
            frame_count = 1,
            line_length = 1,
            shift = util.by_pixel(0, -32),
            scale = 0.5,
            priority = "extra-high"
        },
        leaves = {
            filename = "__zen-garden__/graphics/entity/zen-bonsai/zen-bonsai-tree-01.png",
            width = 384,
            height = 384,
            frame_count = 1,
            line_length = 1,
            shift = util.by_pixel(0, -32),
            scale = 0.5,
            priority = "extra-high"
        },
        shadow = {
            filename = "__zen-garden__/graphics/entity/zen-bonsai/zen-bonsai-tree-01-shadow.png",
            width = 384,
            height = 384,
            frame_count = 2,
            flags = { "mipmap", "shadow" },
            shift = util.by_pixel(0, -32),
            draw_as_shadow = true,
            scale = 0.5,
        },
        normal = nil,
        water_reflection = {
            pictures = {
                filename = "__zen-garden__/graphics/entity/zen-bonsai/zen-bonsai-tree-01-reflection.png",
                width = 384,
                height = 384,
                scale = 0.5,
                shift = util.by_pixel(16, 0),
                variation_count = 1,
            },
            rotate = false,
            orientation_to_variation = false,
        }
    }
}

-- Bonsai seed item
local seed_icons = {
    { icon = "__zen-garden__/graphics/icons/zen-bonsai.png", icon_size = 64, scale = 0.5,  shift = { 0, 0 } },
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
    energy_required = 5,
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
        { icon = "__space-age__/graphics/icons/tree-seed.png",        icon_size = 64,  scale = 0.5, shift = { 16, -16 } }
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