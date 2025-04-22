data:extend
({
    {
        type = "technology",
        name = "basic-gardening",
        icon = "__zen-garden__/graphics/technology/landscaping.png",
        icon_size = 256,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "crude-wood-processing"
            }
        },
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
})
