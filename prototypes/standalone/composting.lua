local util = require('util')
local item_sounds = require("__base__.prototypes.item_sounds")
local seconds = 60
local minutes = 60 * seconds


-- Create artificial-grass based on grass-1
local artificial_grass = util.table.deepcopy(data.raw["tile"]["grass-1"])
artificial_grass.name = "artificial-grass"
artificial_grass.minable = { mining_time = 0.5, result = "artificial-grass" }
artificial_grass.mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.8 }
artificial_grass.map_color = { r = 55 / 255, g = 69 / 255, b = 11 / 255 }
artificial_grass.is_foundation = true
artificial_grass.subgroup = "gardening-tiles"
artificial_grass.order = "a[artificial]-d[utility]-a[grass]"

data:extend({ artificial_grass })

local composting_items =
{
    {
        type = "item",
        name = "compost",
        icon = "__zen-garden__/graphics/icons/compost.png",
        icon_size = 64,
        subgroup = "gardening-tiles",
        order = "a[compost]",
        stack_size = 100,
        spoil_result = "artificial-grass",
        spoil_ticks = 5 * minutes,
        weight = 10 * kg,
        inventory_move_sound = item_sounds.wood_inventory_move,
        pick_sound = item_sounds.wood_inventory_pickup,
        drop_sound = item_sounds.wood_inventory_move
    },
    {
        type = "item",
        name = "artificial-grass",
        icon = "__space-age__/graphics/technology/artificial-soil.png",
        icon_size = 256,
        subgroup = "gardening-tiles",
        order = "a[artificial-grass]",
        inventory_move_sound = item_sounds.brick_inventory_move,
        pick_sound = item_sounds.brick_inventory_pickup,
        drop_sound = item_sounds.brick_inventory_move,
        stack_size = 100,
        weight = 10 * kg,
        place_as_tile =
        {
            result = "artificial-grass",
            condition_size = 1,
            condition = { layers = {} }
        }
    }
}

local composting_recipes =
{
    -- Composting
    {
        type = "recipe",
        name = "compost-from-wood",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 64, scale = 0.5, shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/wood.png",          icon_size = 64,  scale = 0.25,  shift = { 8, 8 } }
        },
        ingredients = {
            { type = "item",  name = "wood",  amount = 100 },
            { type = "fluid", name = "water", amount = 1000 }
        },
        results = {
            { type = "item", name = "compost", amount = 1 }
        },
        allow_productivity = true,
        subgroup = "basic-gardening",
        order = "a[compost]-a[wood]"
    },
    {
        type = "recipe",
        name = "compost-from-spoilage",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 64, scale = 0.5, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64,  scale = 0.25,  shift = { 8, 8 } }
        },
        ingredients = {
            { type = "item",  name = "spoilage", amount = 200 },
            { type = "fluid", name = "water",    amount = 1000 }
        },
        results = {
            { type = "item", name = "compost", amount = 1 }
        },
        allow_productivity = true,
        subgroup = "basic-gardening",
        order = "a[compost]-b[spoilage]"
    },
    {
        type = "recipe",
        name = "soil-mixing",
        category = "crafting",
        enabled = false,
        energy_required = 10,
        icons =
        {
            { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.125, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/nutrients.png",      icon_size = 64,  scale = 0.25,  shift = { 8, 8 } },
            { icon = "__base__/graphics/icons/landfill.png",      icon_size = 64,  scale = 0.25,  shift = { -8, 8 } }
        },
        ingredients =
        {
            { type = "item",  name = "artificial-grass", amount = 5 },
            { type = "item",  name = "landfill", amount = 5 },
            { type = "item",  name = "nutrients", amount = 50 }
        },
        results =
        {
            { type = "item", name = "artificial-grass", amount = 10 }
        },
        allow_productivity = false,
        subgroup = "gardening-tiles",
        order = "a[compost]-c[breeding]"
    }
}

local effects =
{
    {
        type = "unlock-recipe",
        recipe = "crude-wood-processing"
    }
}

if settings.startup["zen-seeds-enabled"].value then
    local primitive_effects =
    {
        {
            type = "unlock-recipe",
            recipe = "crude-wood-processing"
        },
        {
            type = "unlock-recipe",
            recipe = "primitive-wood-processing"
        }
    }
    effects = primitive_effects
end

local composting_technologies =
{
    {
        type = "technology",
        name = "basic-gardening",
        icon = "__zen-garden__/graphics/technology/landscaping.png",
        icon_size = 256,
        effects = effects,
        prerequisites = nil,
        research_trigger =
        {
            type = "craft-item",
            item = "wooden-chest",
            count = 50
        }
    },
    {
        type = "technology",
        name = "composting",
        icon = "__zen-garden__/graphics/technology/compost.png",
        icon_size = 256,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "compost-from-wood"
            },
            {
                type = "unlock-recipe",
                recipe = "compost-from-spoilage"
            }
        },
        prerequisites = { "basic-gardening", "automation-2" },
        unit =
        {
            count = 100,
            ingredients =
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 }
            },
            time = 30
        }
    },
    {
        type = "technology",
        name = "soil-mixing",
        icons =
        {
            { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.25, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/nutrients.png",      icon_size = 64,  scale = 0.5,  shift = { 16, 16 } },
            { icon = "__base__/graphics/icons/landfill.png",      icon_size = 64,  scale = 0.5,  shift = { -16, 16 } }
        },
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "soil-mixing"
            }
        },
        prerequisites = { "composting", "artificial-soil" },
        unit = {
            count = 100,
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"space-science-pack", 1},
                {"agricultural-science-pack", 1}
            },
            time = 60
        }
    }
}

data:extend(composting_items)
data:extend(composting_recipes)
data:extend(composting_technologies)