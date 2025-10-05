-- prototypes/zen-tower.lua
if not settings.startup["zen-tower-enabled"].value then return end

local util = require("util")

local zen_tower_graphics =
{
    animation =
    {
        layers =
        {
            util.sprite_load("__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base",
                {
                    priority = "high",
                    animation_speed = 0.25,
                    frame_count = 64,
                    scale = 0.3333 -- 0.5 * 2/3
                }),
            util.sprite_load("__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-shadow",
                {
                    priority = "high",
                    frame_count = 1,
                    repeat_count = 64,
                    draw_as_shadow = true,
                    scale = 0.3333 -- 0.5 * 2/3
                })
        }
    },
    recipe_not_set_tint = { primary = { r = 0.6, g = 0.6, b = 0.5, a = 1 }, secondary = { r = 0.6, g = 0.6, b = 0.5, a = 1 } },
    working_visualisations =
    {
        {
            always_draw = true,
            fog_mask = { rect = { { -20, -20 }, { 20, -1.8333 } }, falloff = 1 }, -- rect scaled by 2/3 (30 * 2/3 = 20, 2.75 * 2/3 = 1.8333)
            animation = util.sprite_load(
                "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base",
                {
                    frame_count = 1,
                    scale = 0.3333 -- 0.5 * 2/3
                }),
        },
        {
            always_draw = true,
            apply_recipe_tint = "primary",
            animation = util.sprite_load(
                "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-plant-mask",
                {
                    priority = "high",
                    frame_count = 64,
                    animation_speed = 0.25,
                    tint_as_overlay = true,
                    scale = 0.3333 -- 0.5 * 2/3
                }),
        },
        {
            apply_recipe_tint = "secondary",
            effect = "flicker",
            fadeout = true,
            animation = util.sprite_load(
                "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-light",
                {
                    priority = "high",
                    frame_count = 64,
                    animation_speed = 0.25,
                    blend_mode = "additive",
                    scale = 0.3333 -- 0.5 * 2/3
                }),
        },
        {
            effect = "flicker",
            fadeout = true,
            light = { intensity = 1.0, size = 4, shift = { -0.3, -0.1667 }, color = { r = 1, g = 1, b = 1 } } -- size 6 * 2/3 = 4, shift (-0.45 * 2/3, -0.25 * 2/3)
        },
        {
            apply_recipe_tint = "secondary",
            effect = "flicker",
            fadeout = true,
            light = { intensity = 1.0, size = 10.6667, shift = { -0.8, -0.3333 }, color = { r = 1, g = 1, b = 1 } } -- size 16 * 2/3 = 10.6667, shift (-1.2 * 2/3, -0.5 * 2/3)
        }
    },
    water_reflection =
    {
        pictures =
        {
            filename = "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-reflection.png",
            priority = "extra-high",
            width = 24,
            height = 36,
            shift = util.by_pixel(0, 13.3333), -- 20 * 2/3 = 13.3333
            variation_count = 1,
            scale = 3.3333                     -- 5 * 2/3
        },
        rotate = false,
        orientation_to_variation = false
    }
}

local zen_tower_entity = util.table.deepcopy(data.raw["agricultural-tower"]["agricultural-tower"])

zen_tower_entity.name = "zen-tower"
zen_tower_entity.icon = "__space-age__/graphics/icons/agricultural-tower.png"
zen_tower_entity.minable = { mining_time = 0.5, result = "zen-tower" }
zen_tower_entity.fast_replaceable_group = nil
zen_tower_entity.corpse = "big-remnants"
zen_tower_entity.input_inventory_size = 2
zen_tower_entity.output_inventory_size = 1
zen_tower_entity.radius = 3
zen_tower_entity.growth_grid_tile_size = 2
zen_tower_entity.growth_area_radius = 0.45
zen_tower_entity.random_growth_offset = 0.1
zen_tower_entity.collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } }
zen_tower_entity.selection_box = { { -1, -1 }, { 1, 1 } }
zen_tower_entity.surface_conditions =
{
    {
        property = "pressure",
        min = 1000,
        max = 1000
    }
}
zen_tower_entity.energy_source =
{
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = -5 }
}
zen_tower_entity.graphics_set = zen_tower_graphics
zen_tower_entity.crane = require("prototypes.zen-crane")

local zen_tower_item =
{
    type = "item",
    name = "zen-tower",
    icon = "__zen-garden__/graphics/icons/zen-tower.png",
    icon_size = 64,
    subgroup = "advanced-gardening",
    order = "a[zen-tower]",
    place_result = "zen-tower",
    stack_size = 10,
    weight = 100 * kg
}

local zen_tower_recipe =
{
    type = "recipe",
    name = "zen-tower",
    category = "crafting",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item", name = "wood",               amount = 20 },
        { type = "item", name = "iron-gear-wheel",    amount = 8 },
        { type = "item", name = "electronic-circuit", amount = 4 }
    },
    results = { { type = "item", name = "zen-tower", amount = 1 } }
}

local zen_tower_technology =
{
    type = "technology",
    name = "zen-tower",
    icon = "__zen-garden__/graphics/technology/zen-tower.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "zen-tower"
        }
    },
    prerequisites = { "basic-gardening" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 }
        },
        time = 30
    }
}

data:extend({ zen_tower_entity })
data:extend({ zen_tower_item })
data:extend({ zen_tower_recipe })
data:extend({ zen_tower_technology })

-- base game copy for educational purposes
--[[ local agricultural_tower =
{
    {
        type = "agricultural-tower",
        name = "agricultural-tower",
        icon = "__space-age__/graphics/icons/agricultural-tower.png",
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = "agricultural-tower" },
        fast_replaceable_group = "agricultural-tower",
        max_health = 500,
        corpse = "agricultural-tower-remnants",
        dying_explosion = "agricultural-tower-explosion",
        open_sound = sounds.mech_large_open,
        close_sound = sounds.mech_large_close,
        input_inventory_size = 3,
        radius_visualisation_picture =
        {
            filename = "__core__/graphics/white-square.png",
            priority = "extra-high-no-scale",
            width = 10,
            height = 10
        },
        radius = 3,
        crane = require("__space-age__.prototypes.entity.agricultural-tower-crane"), -- IMPORTANT
        planting_procedure_points =                                                  -- ???????
        {
            { 0.0,        0.0,        0.75 },
            { 0.0,        0.0,        0.0 },
            { 0.0,        0.05,       -0.05 },
            { 0.0353553,  0.0353553,  -0.1 },
            { 0.05,       0.0,        -0.15 },
            { 0.0353553,  -0.0353553, -0.2 },
            { 0.0,        -0.05,      -0.25 },
            { -0.0353553, -0.0353553, -0.3 },
            { -0.05,      0.0,        -0.35 },
            { -0.0353553, 0.0353553,  -0.4 },
            { 0.0,        0.0,        -0.45 },
            { 0.0,        0.0,        0.0 }
        },
        harvesting_procedure_points =
        {
            { 0.0, 0.0, 1.0 }
        },
        drawing_box_vertical_extension = 2.5,
        heating_energy = "100kW",
        energy_usage = "100kW",
        crane_energy_usage = "100kW",
        working_sound =
        {
            sound =
            {
                filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-hub-loop.ogg",
                volume = 0.7,
                audible_distance_modifier = 0.7,
            },
            max_sounds_per_prototype = 4,
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        central_orienting_sound =
        {
            sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-rotation-loop.ogg", volume = 0.3 },
            stopped_sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-rotation-stop.ogg", volume = 0.5 }
        },
        central_orienting_sound_source = "hub",
        arm_extending_sound =
        {
            sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-arm-extend-loop.ogg", volume = 0.25 },
            stopped_sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-arm-extend-stop.ogg", volume = 0.6 }
        },
        arm_extending_sound_source = "arm_central_joint",
        grappler_orienting_sound =
        {
            sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-grappler-orient-loop.ogg", volume = 0.25 },
            stopped_sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-grappler-orient-stop.ogg", volume = 0.4 }
        },
        grappler_orienting_sound_source = "grappler-hub",
        grappler_extending_sound =
        {
            sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-grappler-extend-loop.ogg", volume = 0.4 },
            stopped_sound = { filename = "__space-age__/sound/entity/agricultural-tower/agricultural-tower-grappler-extend-stop.ogg", volume = 0.45 }
        },
        grappler_extending_sound_source = "grappler-hub",
        planting_sound = sound_variations("__space-age__/sound/entity/agricultural-tower/agricultural-tower-planting", 5,
            0.7),
        harvesting_sound = sound_variations(
            "__space-age__/sound/entity/agricultural-tower/agricultural-tower-harvesting", 6, 0.6),
        resistances =
        {
            {
                type = "fire",
                percent = 100
            }
        },
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        collision_mask = { layers = { item = true, object = true, player = true, water_tile = true, elevated_rail = true, is_object = true, is_lower_object = true } },
        surface_conditions =
        {
            {
                property = "pressure",
                min = 1000,
                max = 2000
            }
        },
        damaged_trigger_effect = hit_effects.entity(),
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { spores = 4 } -- necessary so attack groups find the entity
        },
        circuit_connector = circuit_connector_definitions["agricultural-tower"],
        circuit_wire_max_distance = 30,
        graphics_set =
        {
            animation =
            {
                layers =
                {
                    util.sprite_load("__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base",
                        {
                            priority = "high",
                            animation_speed = 0.25,
                            frame_count = 64,
                            scale = 0.5
                        }),
                    util.sprite_load("__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-shadow",
                        {
                            priority = "high",
                            frame_count = 1,
                            repeat_count = 64,
                            draw_as_shadow = true,
                            scale = 0.5
                        })
                }
            },
            recipe_not_set_tint = { primary = { r = 0.6, g = 0.6, b = 0.5, a = 1 }, secondary = { r = 0.6, g = 0.6, b = 0.5, a = 1 } },
            working_visualisations =
            {
                {
                    always_draw = true,
                    fog_mask = { rect = { { -30, -30 }, { 30, -2.75 } }, falloff = 1 },
                    animation = util.sprite_load(
                        "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base",
                        {
                            frame_count = 1,
                            scale = 0.5
                        }),
                },

                {
                    --constant_speed = true,
                    always_draw = true,
                    apply_recipe_tint = "primary",
                    animation = util.sprite_load(
                        "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-plant-mask",
                        {
                            priority = "high",
                            frame_count = 64,
                            animation_speed = 0.25,
                            tint_as_overlay = true,
                            scale = 0.5
                        }),
                },
                {
                    --constant_speed = true,
                    apply_recipe_tint = "secondary",
                    effect = "flicker",
                    fadeout = true,
                    animation = util.sprite_load(
                        "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-light",
                        {
                            priority = "high",
                            frame_count = 64,
                            animation_speed = 0.25,
                            blend_mode = "additive",
                            scale = 0.5
                        }),
                },
                {
                    effect = "flicker",
                    fadeout = true,
                    light = { intensity = 1.0, size = 6, shift = { -0.45, -0.25 }, color = { r = 1, g = 1, b = 1 } }
                },
                {
                    apply_recipe_tint = "secondary",
                    effect = "flicker",
                    fadeout = true,
                    light = { intensity = 1.0, size = 16, shift = { -1.2, -0.5 }, color = { r = 1, g = 1, b = 1 } }
                }
            },
            water_reflection =
            {
                pictures =
                {
                    filename = "__space-age__/graphics/entity/agricultural-tower/agricultural-tower-base-reflection.png",
                    priority = "extra-high",
                    width = 24,
                    height = 36,
                    shift = util.by_pixel(0, 20),
                    variation_count = 1,
                    scale = 5
                },
                rotate = false,
                orientation_to_variation = false
            }
        }
    }
}
 ]]
