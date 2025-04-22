if settings.startup["charcoal-burning-enabled"].value then
    local technology =
    {
        type = "technology",
        name = "charcoal-burning",
        icon = "__zen-garden__/graphics/technology/charcoal.png",
        icon_size = 256,
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "charcoal-burning"
            }
        },
        prerequisites = { "basic-gardening", "advanced-material-processing"},
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

    local recipe =
    {
        type = "recipe",
        name = "charcoal-burning",
        category = "smelting",
        energy_required = 16,
        enabled = false,
        ingredients = { { type = "item", name = "wooden-chest", amount = 5 } },
        results = { { type = "item", name = "coal", amount = 2 } },
        allow_productivity = true
    }

    data:extend({ recipe, technology})
end