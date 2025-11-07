--zen-bonsai-plant.lua
local zen_utils = require("__zen-garden__/prototypes/zen-utils")
local util = require("util")
local tile_restrictions = zen_utils.tile_restrictions

local bonsai_tree_plant = util.table.deepcopy(data.raw["tree"]["tree-08"])
bonsai_tree_plant.type = "plant"
bonsai_tree_plant.name = "tree-plant-bonsai"
bonsai_tree_plant.flags = { "placeable-neutral", "placeable-off-grid", "breaths-air" }
bonsai_tree_plant.hidden_in_factoriopedia = false
bonsai_tree_plant.factoriopedia_alternative = nil
bonsai_tree_plant.map_color = { 0.39, 0.39, 0.09, 0.40 }
bonsai_tree_plant.agricultural_tower_tint =
{
    primary = { r = 0.5, g = 1.0, b = 0.2, a = 1 },
    secondary = { r = 0.561, g = 0.613, b = 0.308, a = 1.000 }, -- #8f4f4eff
}
bonsai_tree_plant.minable =
{
    mining_particle = "wooden-particle",
    mining_time = 0.5,
    results = { { type = "item", name = "wood", amount = 12 } },                            -- high yield, slower growth time.
}
bonsai_tree_plant.variation_weights = { 1, 1, 1, 1, 1, 1, 1, 1, 0.3, 0.3, 0.0, 0.0 }
bonsai_tree_plant.growth_ticks = 15 * 60 * 60                                               -- 15 min
bonsai_tree_plant.surface_conditions = { { property = "pressure", min = 100, max = 2900 } } -- to include misc planets if tiles allow it.
bonsai_tree_plant.autoplace =
{
    probability_expression = 0,
    tile_restriction = tile_restrictions
}

-- data:extend({ bonsai_tree_plant })

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
