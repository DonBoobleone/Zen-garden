data:extend(
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
    },
})