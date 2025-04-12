local util = require("util")
local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local tree_definitions = zen_utils.tree_definitions
local colors = zen_utils.colors
local create_zen_garden_graphics = zen_utils.create_zen_garden_graphics

-- **Common Pipe Layers Definition**
local pipe_to_ground_pictures = data.raw["pipe-to-ground"]["pipe-to-ground"].pictures

local pipe_layers_back = {
    util.copy(pipe_to_ground_pictures.north), -- North left
    util.copy(pipe_to_ground_pictures.north), -- North right
    util.copy(pipe_to_ground_pictures.east),  -- East top
    util.copy(pipe_to_ground_pictures.west),  -- West top
}

local pipe_layers_front = {
    util.copy(pipe_to_ground_pictures.south), -- South left
    util.copy(pipe_to_ground_pictures.south), -- South right
    util.copy(pipe_to_ground_pictures.east),  -- East bottom
    util.copy(pipe_to_ground_pictures.west),  -- West bottom
}

local pipe_shifts = {
    back = {
        { -1.5, -3.5 }, -- North left
        { 1.5,  -3.5 }, -- North right
        { 3.5,  -1.5 }, -- East top
        { -3.5, -1.5 }, -- West top
    },
    front = {
        { -1.5, 3.5 },  -- South left
        { 1.5,  3.5 },  -- South right
        { 3.5,  1.5 },  -- East bottom
        { -3.5, 1.5 },  -- West bottom
    }
}

local common_fluid_boxes = {
    {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        volume = 500,
        pipe_connections = {
            { flow_direction = "input-output", direction = defines.direction.north, position = { -1.5, -3.5 } },
            { flow_direction = "input-output", direction = defines.direction.north, position = { 1.5, -3.5 } },
            { flow_direction = "input-output", direction = defines.direction.south, position = { -1.5, 3.5 } },
            { flow_direction = "input-output", direction = defines.direction.south, position = { 1.5, 3.5 } },
            { flow_direction = "input-output", direction = defines.direction.east,  position = { 3.5, -1.5 } },
            { flow_direction = "input-output", direction = defines.direction.east,  position = { 3.5, 1.5 } },
            { flow_direction = "input-output", direction = defines.direction.west,  position = { -3.5, -1.5 } },
            { flow_direction = "input-output", direction = defines.direction.west,  position = { -3.5, 1.5 } }
        },
        secondary_draw_orders = { north = -1 }
    }
}

for i, layer in ipairs(pipe_layers_back) do layer.shift = pipe_shifts.back[i] end
for i, layer in ipairs(pipe_layers_front) do layer.shift = pipe_shifts.front[i] end

-- **Dome Layers for Zen Garden**
local dome_shift = -24 -- Adjust as needed

local dome_back = {
    filename = "__zen-garden__/graphics/entity/dome-back.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 1,
    shift = util.by_pixel(0, dome_shift)
}

local dome_front = {
    filename = "__zen-garden__/graphics/entity/dome-front.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 1,
    shift = util.by_pixel(0, dome_shift)
}

local water_features_layer_shifted = {
    filename = "__zen-garden__/graphics/entity/fountain.png",
    priority = "extra-high",
    width = 256,
    height = 256,
    frame_count = 1,
    line_length = 1,
    scale = 0.35,
    shift = util.by_pixel(0, dome_shift)
}

-- **Water Features Layer**
local water_features_layer = {
    filename = "__zen-garden__/graphics/entity/fountain.png",
    priority = "extra-high",
    width = 256,
    height = 256,
    frame_count = 1,
    line_length = 1,
    scale = 0.35,
    shift = util.by_pixel(0, 0)
}

-- **Tree Generation Utilities**
local stretch_factor = 0.8

local function stretch(position)
    return { position[1] / stretch_factor, position[2] * stretch_factor }
end

local function generate_ring(radius, tree_count)
    local positions = {}
    local angle_step = 360 / tree_count
    for i = 0, tree_count - 1 do
        local angle = i * angle_step
        local rad = math.rad(angle)
        local x = radius * math.cos(rad)
        local y = radius * math.sin(rad)
        table.insert(positions, { x, y })
    end
    return positions
end

local function generate_teeth(radius, teeth_size)
    local positions = {}
    local offset = teeth_size / 2
    for i = 0, 7 do
        local angle = i * 45
        local rad = math.rad(angle)
        local central_x = radius * math.cos(rad)
        local central_y = radius * math.sin(rad)
        local tangential_dx = -math.sin(rad)
        local tangential_dy = math.cos(rad)
        local x1 = central_x + offset * tangential_dx
        local y1 = central_y + offset * tangential_dy
        local x2 = central_x - offset * tangential_dx
        local y2 = central_y - offset * tangential_dy
        table.insert(positions, { x1, y1 })
        table.insert(positions, { x2, y2 })
    end
    return positions
end

-- Centralized function to generate tree ring positions
local function generate_tree_rings(radii, tree_counts)
    local positions = {}
    for i, radius in ipairs(radii) do
        for _, pos in ipairs(generate_ring(radius, tree_counts[i])) do
            table.insert(positions, pos)
        end
    end
    local stretched_positions = {}
    for _, pos in ipairs(positions) do
        table.insert(stretched_positions, stretch(pos))
    end
    return stretched_positions
end

-- Function to create tree table from positions
local function create_tree_table(positions, tree_type, tint, scale)
    local trees = {}
    for _, pos in ipairs(positions) do
        table.insert(trees, {
            position = pos,
            tree_type = tree_type,
            tint = tint,
            scale = scale
        })
    end
    return trees
end

-- **Gear Garden Tree Generation**
local function generate_gear_trees()
    local ring_positions = generate_tree_rings({1.3, 1.6, 2.1}, {8, 16, 32})
    for _, pos in ipairs(generate_teeth(2.5, 0.38)) do
        table.insert(ring_positions, stretch(pos))
    end
    return create_tree_table(ring_positions, tree_definitions["pine"].variation, colors.forest_green, 0.33)
end

local gear_tree_layers = create_zen_garden_graphics(generate_gear_trees()).layers

-- **Zen Garden Tree Generation**
local function generate_zen_trees()
    local ring_positions = generate_tree_rings({1.3, 1.6, 2.1}, {8, 16, 32})
    return create_tree_table(ring_positions, tree_definitions["pine"].variation, colors.forest_green, 0.33)
end

local zen_tree_layers = create_zen_garden_graphics(generate_zen_trees()).layers

-- **Shift Adjustment Function**
local function adjust_layers_shift(layers, shift_vector)
    for _, layer in ipairs(layers) do
        if layer.shift then
            layer.shift = {
                layer.shift[1] + shift_vector[1],
                layer.shift[2] + shift_vector[2]
            }
        end
    end
end

-- **Combine Layers for Zen Garden**
local zen_all_layers = {}
for _, layer in ipairs(pipe_layers_back) do table.insert(zen_all_layers, layer) end
table.insert(zen_all_layers, dome_back)
table.insert(zen_all_layers, water_features_layer_shifted)

-- Apply shift adjustment to Zen Garden layers
adjust_layers_shift(zen_tree_layers, util.by_pixel(0, dome_shift))

for _, layer in ipairs(zen_tree_layers) do table.insert(zen_all_layers, layer) end
table.insert(zen_all_layers, dome_front)
for _, layer in ipairs(pipe_layers_front) do table.insert(zen_all_layers, layer) end

-- **Combine Layers for Gear Garden**
local gear_all_layers = {}
for _, layer in ipairs(pipe_layers_back) do table.insert(gear_all_layers, layer) end
table.insert(gear_all_layers, water_features_layer)
for _, layer in ipairs(gear_tree_layers) do table.insert(gear_all_layers, layer) end
for _, layer in ipairs(pipe_layers_front) do table.insert(gear_all_layers, layer) end

-- **Define Entities**
data:extend({
    -- **Zen Garden Entity**
    {
        type = "assembling-machine",
        name = "zen-garden",
        icon = "__zen-garden__/graphics/icons/zen-garden.png",
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 1, result = "zen-garden" },
        max_health = 1000,
        corpse = "assembling-machine-3-remnants",
        dying_explosion = "assembling-machine-3-explosion",
        icon_draw_specification = { shift = { 0, -0.3 } },
        alert_icon_shift = util.by_pixel(0, -12),
        resistances = {
            { type = "fire",   percent = 99 },
            { type = "impact", percent = 80 }
        },
        fluid_boxes = common_fluid_boxes,
        fluid_boxes_off_when_no_fluid_recipe = false,
        impact_category = "metal",
        working_sound = {
            sound = { filename = "__base__/sound/assembling-machine-t3-1.ogg", volume = 0.45, audible_distance_modifier = 0.5 },
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        collision_box = { { -3.9, -3.9 }, { 3.9, 3.9 } },
        selection_box = { { -4, -4 }, { 4, 4 } },
        drawing_box_vertical_extension = 0.2,
        graphics_set = {
            animation = { layers = zen_all_layers }
        },
        crafting_categories = { "advanced-gardening" },
        crafting_speed = 1,
        output_inventory_size = 2,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = -10 }
        },
        energy_usage = "690kW",
        module_slots = 4,
        allowed_effects = { "consumption", "speed", "productivity", "pollution", "quality" }
    },
    -- **Gear Garden Entity**
    {
        type = "assembling-machine",
        name = "gear-garden",
        icon = "__zen-garden__/graphics/icons/favourite.png",
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 1, result = "gear-garden" },
        max_health = 1000,
        corpse = "assembling-machine-3-remnants",
        dying_explosion = "assembling-machine-3-explosion",
        icon_draw_specification = { shift = { 0, -0.3 } },
        alert_icon_shift = util.by_pixel(0, -12),
        resistances = {
            { type = "fire", percent = 99 }
        },
        fluid_boxes = common_fluid_boxes,
        fixed_recipe = "water-the-plants",
        show_recipe_icon = false,
        fluid_boxes_off_when_no_fluid_recipe = false,
        impact_category = "metal",
        working_sound = {
            sound = { filename = "__base__/sound/world/trees/tree-ambient-leaves-1.ogg", volume = 0.55, audible_distance_modifier = 0.5 },
            fade_in_ticks = 4,
            fade_out_ticks = 20
        },
        collision_box = { { -3.9, -3.9 }, { 3.9, 3.9 } },
        selection_box = { { -4, -4 }, { 4, 4 } },
        drawing_box_vertical_extension = 0.2,
        fast_replaceable_group = "zen-garden",
        graphics_set = {
            animation = { layers = gear_all_layers }
        },
        crafting_categories = { "gardening" },
        crafting_speed = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = { pollution = -10 }
        },
        energy_usage = "100kW",
        module_slots = nil,
        allowed_effects = {}
    }
})