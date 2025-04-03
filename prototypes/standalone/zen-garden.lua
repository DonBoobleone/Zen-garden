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
    scale = .7,
    shift = util.by_pixel(0, -16)
}

local zen_trees =
{
    { position = { 0.5, -1 },    tree_type = tree.pine, tint = colors.olive_green,  scale = 0.8 },
    { position = { -0.5, -1 },   tree_type = tree.pine, tint = colors.olive_green,  scale = 0.8 },
    { position = { 1.5, -0.5 },  tree_type = tree.pine, tint = colors.light_green,  scale = 0.9 },
    { position = { -1.5, -0.5 }, tree_type = tree.pine, tint = colors.light_green,  scale = 0.9 },
    { position = { 2, 0.5 },     tree_type = tree.pine, tint = colors.forest_green, scale = 0.8 },
    { position = { -2, 0.5 },    tree_type = tree.pine, tint = colors.forest_green, scale = 0.8 },
    { position = { 2, 2 },       tree_type = tree.pine, tint = colors.olive_green,  scale = 0.5 },
    { position = { -2, 2 },      tree_type = tree.pine, tint = colors.olive_green,  scale = 0.5 },
}

local tree_layers = create_zen_garden_graphics(zen_trees).layers

-- Combine the graphics set
local all_layers = {}
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
                volume = 6000,
                pipe_connections = {
                    { flow_direction = "input-output", direction = defines.direction.north, position = { -1.5, -3.5 } },
                    { flow_direction = "input-output", direction = defines.direction.north, position = { 1.5, -3.5 } },
                    { flow_direction = "input-output", direction = defines.direction.south, position = { -1.5, 3.5 } },
                    { flow_direction = "input-output", direction = defines.direction.south, position = { 1.5, 3.5 } }
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
        stack_size = 1
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
            { type = "item", name = "artificial-grass",      amount = 64 }, 
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
        icons =
        {
            {
                icon = "__space-age__/graphics/icons/space-platform-surface.png",
                icon_size = 64,
                scale = 0.5,
                shift = { 0, 8 }
            },
            {
                icon = "__base__/graphics/icons/tree-01.png",
                icon_size = 64,
                scale = 0.5,
                shift = { -1, -8 }
            }
        },
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
