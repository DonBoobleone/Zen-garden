local item_sounds = require("__base__.prototypes.item_sounds")
local seconds = 60
local minutes = 60 * seconds

data:extend({
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
})