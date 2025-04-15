local item_sounds = require("__base__.prototypes.item_sounds")
local seconds = 60
local minutes = 60 * seconds

data:extend(
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
    },
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
    }
})