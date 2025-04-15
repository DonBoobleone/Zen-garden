data:extend(
{
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
        subgroup = "gardening-tiles",
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
    {
        type = "recipe",
        name = "gear-garden",
        category = "crafting",
        energy_required = 10,
        enabled = false,
        ingredients = {
            { type = "item", name = "artificial-grass", amount = 32 },
            { type = "item", name = "tree-seed", amount = 20 },
            { type = "item", name = "pipe-to-ground", amount = 8 },
        },
        results = { { type = "item", name = "gear-garden", amount = 1 } }
    },
    {
        type = "recipe",
        name = "zen-garden",
        category = "crafting",
        energy_required = 10,
        enabled = false,
        ingredients = {
            { type = "item", name = "artificial-grass", amount = 100 },
            { type = "item", name = "low-density-structure", amount = 50 },
            { type = "item", name = "tree-seed", amount = 20 }, -- Alternately use gear garden?
            { type = "item", name = "electric-engine-unit", amount = 20 },
            { type = "item", name = "processing-unit", amount = 20 }
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
    -- Hidden Recipe
    {
        type = "recipe",
        name = "water-the-plants",
        icons = {
            { icon = "__base__/graphics/icons/tree-01.png", icon_size = 64, scale = 0.25, shift = { -4, -4 } },
            { icon = "__base__/graphics/icons/fluid/water.png", icon_size = 64, scale = 0.25, shift = { 4, 4 } }
        },
        category = "gardening",
        energy_required = 60,
        ingredients = {
            { type = "fluid", name = "water", amount = 120 }
        },
        results = {},
        hidden = true,
        enabled = false
    }
})