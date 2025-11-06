--SA copy

local tree_plant = util.table.deepcopy(data.raw["tree"]["tree-08"])
tree_plant.type = "plant"
tree_plant.name = "tree-plant"
tree_plant.flags = plant_flags
tree_plant.hidden_in_factoriopedia = false
tree_plant.factoriopedia_alternative = nil
tree_plant.map_color = { 0.19, 0.39, 0.19, 0.40 }
tree_plant.agricultural_tower_tint =
{
    primary = { r = 0.7, g = 1.0, b = 0.2, a = 1 },
    secondary = { r = 0.561, g = 0.613, b = 0.308, a = 1.000 }, -- #8f4f4eff
}
tree_plant.minable =
{
    mining_particle = "wooden-particle",
    mining_time = 0.5,
    results = { { type = "item", name = "wood", amount = 4 } },
}
tree_plant.variation_weights = { 1, 1, 1, 1, 1, 1, 1, 1, 0.3, 0.3, 0.0, 0.0 }
tree_plant.growth_ticks = 10 * minutes
tree_plant.surface_conditions = { { property = "pressure", min = 1000, max = 1000 } } -- only Nauvis (doesn't work yet)
tree_plant.autoplace =
{
    probability_expression = 0,
    -- required to show agricultural tower plots
    tile_restriction =
    {
        "grass-1", "grass-2", "grass-3", "grass-4",
        "dry-dirt", "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7",
        "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"
    }
}

-- data:extend({ tree_plant })

local ashland_tree_example = {
    type = "tree",
    name = "ashland-lichen-tree",
    icon = "__space-age__/graphics/icons/ashland-lichen-tree.png",
    flags = { "placeable-neutral", "placeable-off-grid", "breaths-air" },
    minable =
    {
        mining_particle = "wooden-particle",
        mining_time = 0.5,
        results =
        {
            { type = "item", name = "carbon", amount = 2 }
        }
    },
    mining_sound = sound_variations("__space-age__/sound/mining/axe-mining-ashland-lichen-tree", 5, 0.4),
    mined_sound = sound_variations("__space-age__/sound/mining/mined-ashland-lichen-tree", 5, 0.4),
    corpse = "ashland-lichen-tree-stump",
    remains_when_mined = "ashland-lichen-tree-stump",
    max_health = 50,
    collision_box = { { -0.5, -0.6 }, { 0.5, 0.4 } },
    selection_box = { { -0.9, -2.4 }, { 0.9, 0.3 } },
    subgroup = "trees",
    order = "a[tree]-b[vulcanus]-a[ashland-lichen-tree]",
    impact_category = "tree",
    factoriopedia_simulation = simulations.factoriopedia_ashland_lichen_tree,
    autoplace =
    {
        order = "b[tree]-b[normal]",
        --control = "trees", -- makes it appear on Nauvis
        probability_expression = "vulcanus_tree"
    },
    pictures = ashland_lichen_tree_pictures,
}
