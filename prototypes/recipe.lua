--recipe.lua

--TODO: move zen-chi, and other fixed recipes here

data:extend({
    {
        type = "recipe",
        name = "crude-wood-processing",
        icon = "__base__/graphics/icons/tree-02-stump.png",
        categories = {"organic", "crafting"},
        subgroup = "wood-processing",
        order = "z[crude-wood-processing]",
        enabled = false,
        allow_productivity = true,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { r = 0.442, g = 0.205, b = 0.090, a = 1.000 },
            secondary = { r = 1.000, g = 0.500, b = 0.000, a = 1.000 }
        },
        energy_required = 2,
        ingredients = { { type = "item", name = "wood", amount = 2 } },
        results = { { type = "item", name = "tree-seed", amount = 1, independent_probability = 0.9 } }
    },
    {
        type = "recipe",
        name = "compost-from-wood",
        categories = {"organic", "crafting-with-fluid"},
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 64, scale = 0.5,  shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/wood.png",          icon_size = 64, scale = 0.25, shift = { 8, 8 } }
        },
        ingredients = {
            { type = "item",  name = "wood",  amount = 50 },
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
        categories = {"organic", "crafting-with-fluid"},
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 64, scale = 0.5,  shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64, scale = 0.25, shift = { 8, 8 } }
        },
        ingredients = {
            { type = "item",  name = "spoilage", amount = 100 },
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
        type = "recipe",
        name = "soil-mixing",
        categories = {"organic", "crafting"},
        enabled = false,
        energy_required = 10,
        icons = {
            { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.125, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/nutrients.png",            icon_size = 64,  scale = 0.25,  shift = { 8, 8 } },
            { icon = "__base__/graphics/icons/landfill.png",                  icon_size = 64,  scale = 0.25,  shift = { -8, 8 } }
        },
        ingredients = {
            { type = "item", name = "artificial-grass", amount = 5 },
            { type = "item", name = "landfill",         amount = 5 },
            { type = "item", name = "nutrients",        amount = 50 }
        },
        results = {
            { type = "item", name = "artificial-grass", amount = 10 }
        },
        auto_recycle = false,
        allow_productivity = false,
        subgroup = "gardening-tiles",
        order = "a[artificial-grass]-a[breeding]"
    },
    {
        type = "recipe",
        name = "water-the-plants",
        icons = {
            { icon = "__base__/graphics/icons/tree-01.png",     icon_size = 64, scale = 0.25, shift = { -4, -4 } },
            { icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.25, shift = { 4, 4 } }
        },
        categories = {"gardening"},
        energy_required = 60,
        ingredients = {
            { type = "fluid", name = "water", amount = 120 }
        },
        results = {},
        hidden = true,
        enabled = true
    },
    {
        type = "recipe",
        name = "zen-chi",
        icons = {
            { icon = "__zen-garden__/graphics/icons/zen-bonsai.png", icon_size = 64, scale = 0.5, shift = { 0, 0 } },
        },
        categories = {"gardening"},
        energy_required = 60,
        ingredients = {},
        results = {},
        hidden = true,
        enabled = true
    }
})
