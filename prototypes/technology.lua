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
                recipe = "primitive-wood-processing"
            },
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
    }
})
