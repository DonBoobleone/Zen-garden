local util = require('util')
local item_sounds = require("__base__.prototypes.item_sounds")
local seconds = 60
local minutes = 60 * seconds

data:extend
({
    {
        type = "item",
        name = "compost",
        icon = "__zen-garden__/graphics/icons/compost.png",
        icon_size = 256,
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
    },
    {
        type = "recipe",
        name = "compost-from-wood",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 256, scale = 0.25, shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/wood.png",               icon_size = 64,  scale = 0.5,  shift = { 16, 16 } }
        },
        ingredients = {
            { type = "item",  name = "wood",  amount = 100 },
            { type = "fluid", name = "water", amount = 1000 }
        },
        results = {
            { type = "item", name = "compost", amount = 1 }
        },
        allow_productivity = true,
        subgroup = "gardening-tiles",
        order = "a[compost]-a[wood]"
    },
    {
        type = "recipe",
        name = "compost-from-spoilage",
        category = "crafting-with-fluid",
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 256, scale = 0.25, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/spoilage.png",      icon_size = 64,  scale = 0.5,  shift = { 16, 16 } }
        },
        ingredients = {
            { type = "item",  name = "spoilage", amount = 200 },
            { type = "fluid", name = "water",    amount = 1000 }
        },
        results = {
            { type = "item", name = "compost", amount = 1 }
        },
        allow_productivity = true,
        subgroup = "gardening-tiles",
        order = "a[compost]-b[spoilage]"
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
        prerequisites = { "basic-gardening", "advanced-material-processing" },
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
    }
})

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
