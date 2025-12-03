-- prototypes/zen-tower.lua
if not settings.startup["zen-tower-enabled"].value then return end
local util = require("util")

function create_scaled_agricultural_tower_graphics_set(scale)
    local graphics_set = util.table.deepcopy(data.raw["agricultural-tower"]["agricultural-tower"].graphics_set)

    -- Check if graphics_set exists
    if not graphics_set then
        return nil
    end

    -- Scale animation layers
    for _, layer in pairs(graphics_set.animation.layers) do
        if layer.scale then
            layer.scale = layer.scale * scale
        end
    end

    -- Scale working visualisations
    for _, vis in pairs(graphics_set.working_visualisations) do
        -- Scale fog mask
        if vis.fog_mask and vis.fog_mask.rect then
            for i, point in pairs(vis.fog_mask.rect) do
                vis.fog_mask.rect[i] = { point[1] * scale, point[2] * scale }
            end
        end

        -- Scale animation in visualisations
        if vis.animation and vis.animation.scale then
            vis.animation.scale = vis.animation.scale * scale
        end

        -- Scale light properties
        if vis.light then
            vis.light.size = vis.light.size * scale
            if vis.light.shift then
                vis.light.shift = { vis.light.shift[1] * scale, vis.light.shift[2] * scale }
            end
        end
    end

    -- Scale water reflection
    if graphics_set.water_reflection and graphics_set.water_reflection.pictures then
        graphics_set.water_reflection.pictures.scale = graphics_set.water_reflection.pictures.scale * scale
        if graphics_set.water_reflection.pictures.shift then
            graphics_set.water_reflection.pictures.shift = util.by_pixel(
                graphics_set.water_reflection.pictures.shift[1] * scale,
                graphics_set.water_reflection.pictures.shift[2] * scale
            )
        end
    end

    return graphics_set
end

function create_scaled_agricultural_tower_crane(scale)
    local crane = util.table.deepcopy(data.raw["agricultural-tower"]["agricultural-tower"].crane)

    -- Check if crane exists
    if not crane then
        return nil
    end

    -- Scale origin
    if crane.origin then
        crane.origin = {
            crane.origin[1] * scale,
            crane.origin[2] * scale,
            crane.origin[3] * scale
        }
    end

    -- Scale shadow direction
    if crane.shadow_direction then
        crane.shadow_direction = {
            crane.shadow_direction[1] * scale,
            crane.shadow_direction[2] * scale,
            crane.shadow_direction[3] * scale
        }
    end

    -- Scale parts
    for _, part in pairs(crane.parts) do
        -- Scale sprite scales
        if part.rotated_sprite and part.rotated_sprite.scale then
            part.rotated_sprite.scale = part.rotated_sprite.scale * scale
        end
        if part.rotated_sprite_shadow and part.rotated_sprite_shadow.scale then
            part.rotated_sprite_shadow.scale = part.rotated_sprite_shadow.scale * scale
        end
        if part.rotated_sprite_reflection and part.rotated_sprite_reflection.scale then
            part.rotated_sprite_reflection.scale = part.rotated_sprite_reflection.scale * scale
        end
        if part.sprite and part.sprite.scale then
            part.sprite.scale = part.sprite.scale * scale
        end
        if part.sprite_shadow and part.sprite_shadow.scale then
            part.sprite_shadow.scale = part.sprite_shadow.scale * scale
        end
        if part.sprite_reflection and part.sprite_reflection.scale then
            part.sprite_reflection.scale = part.sprite_reflection.scale * scale
        end

        -- Scale relative position
        if part.relative_position then
            part.relative_position = {
                part.relative_position[1] * scale,
                part.relative_position[2] * scale,
                part.relative_position[3] * scale
            }
        end

        -- Scale static length
        if part.static_length then
            part.static_length = {
                part.static_length[1] * scale,
                part.static_length[2] * scale,
                part.static_length[3] * scale
            }
        end

        -- Scale extendable length
        if part.extendable_length then
            part.extendable_length = {
                part.extendable_length[1] * scale,
                part.extendable_length[2] * scale,
                part.extendable_length[3] * scale
            }
        end

        -- Scale static length grappler
        if part.static_length_grappler then
            part.static_length_grappler = {
                part.static_length_grappler[1] * scale,
                part.static_length_grappler[2] * scale,
                part.static_length_grappler[3] * scale
            }
        end

        -- Scale extendable length grappler
        if part.extendable_length_grappler then
            part.extendable_length_grappler = {
                part.extendable_length_grappler[1] * scale,
                part.extendable_length_grappler[2] * scale,
                part.extendable_length_grappler[3] * scale
            }
        end
    end

    return crane
end

function shift_graphics_set(graphics_set, tile_x, tile_y)
    if not graphics_set then
        return
    end

    -- Shift animation layers
    for _, layer in pairs(graphics_set.animation.layers) do
        if layer.shift then
            layer.shift[1] = layer.shift[1] + tile_x
            layer.shift[2] = layer.shift[2] + tile_y
        end
    end

    -- Shift working visualisations
    for _, vis in pairs(graphics_set.working_visualisations) do
        if vis.fog_mask and vis.fog_mask.rect then
            for _, point in pairs(vis.fog_mask.rect) do
                point[1] = point[1] + tile_x
                point[2] = point[2] + tile_y
            end
        end

        if vis.animation and vis.animation.shift then
            vis.animation.shift[1] = vis.animation.shift[1] + tile_x
            vis.animation.shift[2] = vis.animation.shift[2] + tile_y
        end

        if vis.light and vis.light.shift then
            vis.light.shift[1] = vis.light.shift[1] + tile_x
            vis.light.shift[2] = vis.light.shift[2] + tile_y
        end
    end

    -- Shift water reflection
    if graphics_set.water_reflection and graphics_set.water_reflection.pictures and graphics_set.water_reflection.pictures.shift then
        graphics_set.water_reflection.pictures.shift[1] = graphics_set.water_reflection.pictures.shift[1] + tile_x
        graphics_set.water_reflection.pictures.shift[2] = graphics_set.water_reflection.pictures.shift[2] + tile_y
    end
end

function merge_graphics_sets(main, extension)
    if not main or not extension then
        return main
    end

    local merged = util.table.deepcopy(main)

    -- Merge animation layers
    for _, layer in pairs(extension.animation.layers) do
        table.insert(merged.animation.layers, util.table.deepcopy(layer))
    end

    -- Merge working visualisations
    for _, vis in pairs(extension.working_visualisations) do
        table.insert(merged.working_visualisations, util.table.deepcopy(vis))
    end

    return merged
end

-- Zen-Tower
local zen_tower_entity = util.table.deepcopy(data.raw["agricultural-tower"]["agricultural-tower"])
local zen_tower_scale = 2 / 3

zen_tower_entity.name = "zen-tower"
zen_tower_entity.icon = nil
zen_tower_entity.icons ={
    { icon = "__space-age__/graphics/icons/agricultural-tower.png",         icon_size = 64,  scale = 0.5,   shift = { 0, 0 } },
    { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -12, 8 } }
}
zen_tower_entity.minable = { mining_time = 0.2, result = "zen-tower" }
zen_tower_entity.fast_replaceable_group = nil
zen_tower_entity.corpse = "small-remnants"
zen_tower_entity.input_inventory_size = 2
zen_tower_entity.output_inventory_size = 2
zen_tower_entity.radius = 3
zen_tower_entity.growth_grid_tile_size = 2
zen_tower_entity.growth_area_radius = 0.45
zen_tower_entity.random_growth_offset = 0.1
zen_tower_entity.randomize_planting_tile = false
zen_tower_entity.collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } }
zen_tower_entity.selection_box = { { -1, -1 }, { 1, 1 } }
zen_tower_entity.surface_conditions = {
    {
        property = "pressure",
        min = 1000,
        max = 1000 -- Nauvis only
    }
}
zen_tower_entity.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = -5 } -- TODO: rebalance to 2-4? base tower is 4
}
zen_tower_entity.drawing_box_vertical_extension = zen_tower_entity.drawing_box_vertical_extension * zen_tower_scale

zen_tower_entity.graphics_set = create_scaled_agricultural_tower_graphics_set(zen_tower_scale)
zen_tower_entity.crane = create_scaled_agricultural_tower_crane(zen_tower_scale)

local zen_tower_item =
{
    type = "item",
    name = "zen-tower",
    icons = {
        { icon = "__space-age__/graphics/icons/agricultural-tower.png",         icon_size = 64,  scale = 0.5,   shift = { 0, 0 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -12, 8 } }
    },
    subgroup = "advanced-gardening",
    order = "a[zen-tower-mk1]",
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
    --[[ icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png",
    icon_size = 256, ]]
    icons = {
        { icon = "__space-age__/graphics/icons/agricultural-tower.png",         icon_size = 64,  scale = 0.5,   shift = { 0, 0 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -10, 6 } }
    },
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

-- Zen-Tower-MK2
-- Universal 6x6 agricultural tower, Compact 2x2 grid, 30x30 coverage
local zen_tower_mk2_entity = util.table.deepcopy(data.raw["agricultural-tower"]["agricultural-tower"])
local zen_tower_mk2_scale = 4 / 3

zen_tower_mk2_entity.name = "zen-tower-mk2"
zen_tower_mk2_entity.icon = nil
zen_tower_mk2_entity.icons = {
        { icon = "__space-age__/graphics/icons/agricultural-tower.png",         icon_size = 64,  scale = 0.5,   shift = { 0, 0 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -14, 6 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -8, 8 } }
    }
zen_tower_mk2_entity.minable = { mining_time = 0.5, result = "zen-tower-mk2" }
zen_tower_mk2_entity.fast_replaceable_group = nil
zen_tower_mk2_entity.corpse = "agricultural-tower-remnants"
zen_tower_mk2_entity.input_inventory_size = 5
zen_tower_mk2_entity.output_inventory_size = 3
zen_tower_mk2_entity.radius = 6
zen_tower_mk2_entity.growth_grid_tile_size = 2
zen_tower_mk2_entity.growth_area_radius = 0.45
zen_tower_mk2_entity.random_growth_offset = 0.1
zen_tower_mk2_entity.randomize_planting_tile = false
zen_tower_mk2_entity.collision_box = { { -2.7, -2.7 }, { 2.7, 2.7 } }
zen_tower_mk2_entity.selection_box = { { -3.0, -3.0 }, { 3.0, 3.0 } }
zen_tower_mk2_entity.surface_conditions = {
    {
        property = "pressure",
        min = 1000,
        max = 2000
    }
}
zen_tower_mk2_entity.energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    emissions_per_minute = { pollution = -10, spores = 10 }
}
zen_tower_mk2_entity.heating_energy = "200kW"
zen_tower_mk2_entity.energy_usage = "800kW"
zen_tower_mk2_entity.crane_energy_usage = "200kW"
zen_tower_mk2_entity.drawing_box_vertical_extension = zen_tower_mk2_entity.drawing_box_vertical_extension *
zen_tower_mk2_scale

-- Create graphics sets for each position
local nw_graphics = create_scaled_agricultural_tower_graphics_set(1.0)
shift_graphics_set(nw_graphics, -1.5, -1.5)                                                -- Northwest corner
local ne_graphics = create_scaled_agricultural_tower_graphics_set(1.0)
shift_graphics_set(ne_graphics, 1.5, -1.5)                                                 -- Northeast corner
local sw_graphics = create_scaled_agricultural_tower_graphics_set(1.0)
shift_graphics_set(sw_graphics, -1.5, 1.5)                                                 -- Southwest corner
local se_graphics = create_scaled_agricultural_tower_graphics_set(1.0)
shift_graphics_set(se_graphics, 1.5, 1.5)                                                  -- Southeast corner
local center_graphics = create_scaled_agricultural_tower_graphics_set(zen_tower_mk2_scale) -- Center mk2 tower

-- Initialize merged graphics set with center's water reflection
local merged = {
    animation = { layers = {} },
    working_visualisations = {},
    water_reflection = util.table.deepcopy(center_graphics.water_reflection),
    recipe_not_set_tint = util.table.deepcopy(center_graphics.recipe_not_set_tint)
}

-- Append animation layers and working visualisations in specified order: NW, NE, Center, SW, SE
local function append_layers(source_graphics, target_graphics)
    for _, layer in pairs(source_graphics.animation.layers) do
        table.insert(target_graphics.animation.layers, util.table.deepcopy(layer))
    end
    for _, vis in pairs(source_graphics.working_visualisations) do
        table.insert(target_graphics.working_visualisations, util.table.deepcopy(vis))
    end
end

append_layers(nw_graphics, merged)
--append_layers(ne_graphics, merged)
append_layers(center_graphics, merged)
--append_layers(sw_graphics, merged) -- animation layer render order is still making problem like this
append_layers(se_graphics, merged)

-- Assign merged graphics set to entity
zen_tower_mk2_entity.graphics_set = merged
zen_tower_mk2_entity.crane = create_scaled_agricultural_tower_crane(zen_tower_mk2_scale)

-- Double the crane speeds
local crane_mk2 = zen_tower_mk2_entity.crane
if crane_mk2 and crane_mk2.speed then
    if crane_mk2.speed.arm then
        if crane_mk2.speed.arm.turn_rate then
            crane_mk2.speed.arm.turn_rate = crane_mk2.speed.arm.turn_rate * 2
        else
            crane_mk2.speed.arm.turn_rate = 0.02  -- Double default (0.01)
        end
        if crane_mk2.speed.arm.extension_speed then
            crane_mk2.speed.arm.extension_speed = crane_mk2.speed.arm.extension_speed * 2
        else
            crane_mk2.speed.arm.extension_speed = 0.10  -- Double default (0.05)
        end
    end
    if crane_mk2.speed.grappler then
        if crane_mk2.speed.grappler.vertical_turn_rate then
            crane_mk2.speed.grappler.vertical_turn_rate = crane_mk2.speed.grappler.vertical_turn_rate * 2
        else
            crane_mk2.speed.grappler.vertical_turn_rate = 0.02  -- Double default (0.01)
        end
        if crane_mk2.speed.grappler.horizontal_turn_rate then
            crane_mk2.speed.grappler.horizontal_turn_rate = crane_mk2.speed.grappler.horizontal_turn_rate * 2
        else
            crane_mk2.speed.grappler.horizontal_turn_rate = 0.02  -- Double default (0.01)
        end
        if crane_mk2.speed.grappler.extension_speed then
            crane_mk2.speed.grappler.extension_speed = crane_mk2.speed.grappler.extension_speed * 2
        else
            crane_mk2.speed.grappler.extension_speed = 0.02  -- Double default (0.01)
        end
    end
end

local zen_tower_mk2_item =
{
    type = "item",
    name = "zen-tower-mk2",
    icons = {
        { icon = "__space-age__/graphics/icons/agricultural-tower.png",         icon_size = 64,  scale = 0.5,   shift = { 0, 0 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -14, 6 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.075, shift = { -8, 8 } }
    },
    subgroup = "advanced-gardening",
    order = "a[zen-tower-mk2]",
    place_result = "zen-tower-mk2",
    stack_size = 2,
    weight = 500 * kg
}

local zen_tower_mk2_recipe =
{
    type = "recipe",
    name = "zen-tower-mk2",
    category = "crafting",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item", name = "agricultural-tower",   amount = 2 },
        { type = "item", name = "zen-tower",            amount = 4 },
        { type = "item", name = "processing-unit",      amount = 20 },
        { type = "item", name = "electric-engine-unit", amount = 10 },
    },
    results = { { type = "item", name = "zen-tower-mk2", amount = 1 } }
}

local zen_tower_mk2_technology =
{
    type = "technology",
    name = "zen-agriculture",

    icons = {
        { icon = "__space-age__/graphics/technology/agriculture.png",           icon_size = 256, scale = 0.5,  shift = { 24, -24 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.25, shift = { -32, 14 } },
        { icon = "__zen-garden__/graphics/technology/zen-agriculture-glow.png", icon_size = 256, scale = 0.25, shift = { -12, 18 } }
    },
    effects = {
        {
            type = "unlock-recipe",
            recipe = "zen-tower-mk2"
        }
    },
    prerequisites = { "zen-tower", "agricultural-science-pack" },
    unit = {
        count = 2500,
        ingredients = {
            { "automation-science-pack",   1 },
            { "logistic-science-pack",     1 },
            { "chemical-science-pack",     1 },
            { "production-science-pack",   1 },
            { "utility-science-pack",      1 },
            { "space-science-pack",        1 },
            { "agricultural-science-pack", 1 }
        },
        time = 60
    }
}

data:extend({ zen_tower_mk2_entity })
data:extend({ zen_tower_mk2_item })
data:extend({ zen_tower_mk2_recipe })
data:extend({ zen_tower_mk2_technology })


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
        crane = require("__space-age__.prototypes.entity.agricultural-tower-crane"),
        planting_procedure_points =
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
            max_sounds_per_type = 4,
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
