local zen_utils = require("__zen-garden__/prototypes/zen-tree-utils")
local tree = zen_utils.tree
local colors = zen_utils.colors
local create_zen_garden_graphics = zen_utils.create_zen_garden_graphics

local dome_layers =
{
    filename = "__zen-garden__/graphics/entity/dome.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = .6,
    shift = util.by_pixel(0, -12)
}

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

-- Apply the shifts to each layer, including hr_version if present
for i, layer in ipairs(pipe_layers) do
    layer.shift = shifts[i]
end

local zen_trees =
{
    { position = { 0.5, -1 },    tree_type = tree.pine, tint = colors.olive_green,  scale = 0.5 },
    { position = { -0.5, -1 },   tree_type = tree.pine, tint = colors.olive_green,  scale = 0.5 },
    { position = { 1.5, -0.5 },  tree_type = tree.pine, tint = colors.light_green,  scale = 0.5 },
    { position = { -1.5, -0.5 }, tree_type = tree.pine, tint = colors.light_green,  scale = 0.5 },
    { position = { 1.8, 0.5 },   tree_type = tree.pine, tint = colors.forest_green, scale = 0.5 },
    { position = { -1.8, 0.5 },  tree_type = tree.pine, tint = colors.forest_green, scale = 0.5 },--[[ 
    { position = { 1.8, 1.8 },   tree_type = tree.pine, tint = colors.olive_green,  scale = 0.5 },
    { position = { -1.8, 1.8 },  tree_type = tree.pine, tint = colors.olive_green,  scale = 0.5 }, ]]
}

local tree_layers = create_zen_garden_graphics(zen_trees).layers

-- Combine the graphics set
local all_layers = {}
for _, layer in ipairs(pipe_layers) do
    table.insert(all_layers, layer)
end
for _, layer in ipairs(tree_layers) do
    table.insert(all_layers, layer)
end
table.insert(all_layers, dome_layers)

-- Zen-Garden
-- Any Surface, Water => Wood, Seed and nutrition recycling included (crafting cost/technology)
data:extend({
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
        fluid_boxes = {
            {
                production_type = "input",
                pipe_covers = pipecoverspictures(),
                volume = 500,
                pipe_connections =
                {
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
        graphics_set =
        {
            animation = { layers = all_layers }
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
    -- Item
    {
        type = "item",
        name = "zen-garden",
        icon = "__zen-garden__/graphics/icons/zen-garden.png",
        icon_size = 64,
        subgroup = "advanced-gardening",
        order = "a[zen-garden]",
        place_result = "zen-garden",
        stack_size = 1,
        weight = 1000 * kg
    },
    -- Recipe
    {
        type = "recipe",
        name = "zen-garden",
        category = "crafting",
        energy_required = 10,
        enabled = false,
        ingredients =
        {
            { type = "item", name = "artificial-grass",      amount = 100 }, 
            { type = "item", name = "low-density-structure", amount = 50 },
            { type = "item", name = "tree-seed",             amount = 20 },
            { type = "item", name = "electric-engine-unit",  amount = 20 },
            { type = "item", name = "processing-unit",       amount = 20 }
        },
        results = { { type = "item", name = "zen-garden", amount = 1 } }
    },
    {
        type = "recipe",
        name = "zen-wood",
        category = "advanced-gardening",
        energy_required = 200,
        ingredients = { { type = "fluid", name = "water", amount = 2000 } },
        results = { { type = "item", name = "wood", amount = 100 } }
    },
    -- Technology
    {
        type = "technology",
        name = "space-gardening",
        icon = "__zen-garden__/graphics/technology/space-garden.png",
        icon_size = 512,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "zen-garden"
            },
            {
                type = "unlock-recipe",
                recipe = "zen-wood"
            }
        },
        prerequisites = { "composting", "space-science-pack" },
        unit =
        {
            count = 500,
            ingredients =
            {
                { "automation-science-pack",   1 },
                { "logistic-science-pack",     1 },
                { "chemical-science-pack",     1 },
                { "space-science-pack",        1 }
            },
            time = 60
        }
    }
})
