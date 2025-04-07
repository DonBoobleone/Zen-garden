local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local tree_definitions = zen_utils.tree_definitions
local colors = zen_utils.colors
local create_zen_garden_graphics = zen_utils.create_zen_garden_graphics

-- Gear garden generator
local stretch_factor = 0.9 -- Slightly stretches Y and X for a more oval shape

local function stretch(position)
    return { position[1] / stretch_factor, position[2] * stretch_factor }
end

function generate_ring(radius, tree_count)
    local positions = {}
    local angle_step = 360 / tree_count
    for i = 0, tree_count - 1 do
        local angle = i * angle_step
        local rad = math.rad(angle) -- Convert degrees to radians for Lua's math functions
        local x = radius * math.cos(rad)
        local y = radius * math.sin(rad)
        table.insert(positions, { x, y })
    end
    return positions
end

function generate_teeth(radius, teeth_size)
    local positions = {}
    local offset = teeth_size / 2 -- Half the distance between the two trees per tooth
    for i = 0, 7 do               -- 8 teeth at 0°, 45°, 90°, ..., 315°
        local angle = i * 45
        local rad = math.rad(angle)
        -- Central position of the tooth
        local central_x = radius * math.cos(rad)
        local central_y = radius * math.sin(rad)
        -- Tangential direction (perpendicular to radial)
        local tangential_dx = -math.sin(rad)
        local tangential_dy = math.cos(rad)
        -- Position of the first tree
        local x1 = central_x + offset * tangential_dx
        local y1 = central_y + offset * tangential_dy
        -- Position of the second tree
        local x2 = central_x - offset * tangential_dx
        local y2 = central_y - offset * tangential_dy
        table.insert(positions, { x1, y1 })
        table.insert(positions, { x2, y2 })
    end
    return positions
end

function generate_gear_trees()
    local positions = {}

    -- Inner ring: Radius 1.3, 8 trees
    for _, pos in ipairs(generate_ring(1.3, 8)) do
        table.insert(positions, pos)
    end

    -- Middle ring: Radius 1.5, 16 trees
    for _, pos in ipairs(generate_ring(1.5, 16)) do
        table.insert(positions, pos)
    end

    -- Outer ring: Radius 2.2, 32 trees
    for _, pos in ipairs(generate_ring(2.2, 32)) do
        table.insert(positions, pos)
    end

    -- Teeth: Radius 2.8, teeth_size 0.35
    local teeth_size = 0.35
    for _, pos in ipairs(generate_teeth(2.8, teeth_size)) do
        table.insert(positions, pos)
    end

    -- Apply stretch to all positions
    local stretched_positions = {}
    for _, pos in ipairs(positions) do
        table.insert(stretched_positions, stretch(pos))
    end

    -- Create the gear_trees table with tree properties
    local gear_trees = {}
    for _, pos in ipairs(stretched_positions) do
        table.insert(gear_trees, {
            position = pos,
            tree_type = tree_definitions["pine"].variation,
            tint = colors.forest_green,
            scale = 0.33
        })
    end

    return gear_trees
end

-- Retrieve pipe-to-ground sprite definitions from the base game
local pipe_to_ground_pictures = data.raw["pipe-to-ground"]["pipe-to-ground"].pictures

-- Define pipe layers using copies of the appropriate directional sprites
local pipe_layers = {
    util.copy(pipe_to_ground_pictures.north), -- North left
    util.copy(pipe_to_ground_pictures.north), -- North right
    util.copy(pipe_to_ground_pictures.south), -- South left
    util.copy(pipe_to_ground_pictures.south), -- South right
    util.copy(pipe_to_ground_pictures.east),  -- East top
    util.copy(pipe_to_ground_pictures.east),  -- East bottom
    util.copy(pipe_to_ground_pictures.west),  -- West top
    util.copy(pipe_to_ground_pictures.west),  -- West bottom
}

-- Define the shifts corresponding to each pipe connection position
local shifts = {
    { -1.5, -3.5 }, -- North left
    { 1.5,  -3.5 }, -- North right
    { -1.5, 3.5 },  -- South left
    { 1.5,  3.5 },  -- South right
    { 3.5,  -1.5 }, -- East top
    { 3.5,  1.5 },  -- East bottom
    { -3.5, -1.5 }, -- West top
    { -3.5, 1.5 },  -- West bottom
}

-- Apply the shifts to each layer
for i, layer in ipairs(pipe_layers) do
    layer.shift = shifts[i]
end

local water_features_layers = {
    filename = "__zen-garden__/graphics/entity/fountain.png",
    priority = "extra-high",
    width = 256,
    height = 256,
    frame_count = 1,
    line_length = 1,
    scale = 0.4,
    shift = util.by_pixel(0, 5),
}

local gear_trees = generate_gear_trees()

local tree_layers = create_zen_garden_graphics(gear_trees).layers

-- Combine pipe and tree layers, with pipes drawn beneath trees
local all_layers = {}
for _, layer in ipairs(pipe_layers) do
    table.insert(all_layers, layer)
end
table.insert(all_layers, water_features_layers)
for _, layer in ipairs(tree_layers) do
    table.insert(all_layers, layer)
end


data:extend({
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
        fluid_boxes = {
            {
                production_type = "input",
                pipe_covers = pipecoverspictures(),
                volume = 500,
                pipe_connections = {
                    -- North connections (top)
                    { flow_direction = "input-output", direction = defines.direction.north, position = { -1.5, -3.5 } },
                    { flow_direction = "input-output", direction = defines.direction.north, position = { 1.5, -3.5 } },
                    -- South connections (bottom)
                    { flow_direction = "input-output", direction = defines.direction.south, position = { -1.5, 3.5 } },
                    { flow_direction = "input-output", direction = defines.direction.south, position = { 1.5, 3.5 } },
                    -- East connections (right)
                    { flow_direction = "input-output", direction = defines.direction.east,  position = { 3.5, -1.5 } },
                    { flow_direction = "input-output", direction = defines.direction.east,  position = { 3.5, 1.5 } },
                    -- West connections (left)
                    { flow_direction = "input-output", direction = defines.direction.west,  position = { -3.5, -1.5 } },
                    { flow_direction = "input-output", direction = defines.direction.west,  position = { -3.5, 1.5 } }
                },
                secondary_draw_orders = { north = -1 }
            }
        },
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
            animation = { layers = all_layers }
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
    },
    -- Item
    {
        type = "item",
        name = "gear-garden",
        icon = "__zen-garden__/graphics/icons/favourite.png",
        icon_size = 64,
        subgroup = "advanced-gardening",
        order = "a[gear-garden]",
        place_result = "gear-garden",
        stack_size = 1
    },
    -- Recipe
    {
        type = "recipe",
        name = "gear-garden",
        category = "crafting",
        energy_required = 10,
        enabled = true,
        ingredients = {
            { type = "item", name = "artificial-grass", amount = 32 },
            { type = "item", name = "tree-seed", amount = 20 },
            { type = "item", name = "pipe-to-ground", amount = 8 },
        },
        results = { { type = "item", name = "gear-garden", amount = 1 } }
    },
    -- Hidden Recipe
    {
        type = "recipe",
        name = "water-the-plants",
        icons = {
            { icon = "__base__/graphics/icons/tree-01.png", icon_size = 64, scale = 0.5, shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.5, shift = { 16, 16 } }
        },
        category = "gardening",
        energy_required = 60,
        ingredients = {
            { type = "fluid", name = "water", amount = 120 }
        },
        results = {},
        hidden = true,
        enabled = true
    }
})