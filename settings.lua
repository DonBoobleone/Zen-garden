-- settings.lua
data:extend({
    {
        type = "bool-setting",
        name = "zen-seeds-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a",
        localised_description = {"", "Creates a seed for each tree."}
    },
    {
        type = "bool-setting",
        name = "zen-trees-enabled",
        setting_type = "startup",
        default_value = true,
        order = "b",
        localised_description = {"", "A portable planting box version of each tree"}
    },
    {
        type = "bool-setting",
        name = "force-basic-zen-tree-recipe",
        setting_type = "startup",
        default_value = false,
        order = "c",
        localised_description = {"", "Zen-trees will use basic tree-seed\nWill be forced if 'Zen-seeds' are disabled."}
    },
    {
        type = "bool-setting",
        name = "zen-garden-enabled",
        setting_type = "startup",
        default_value = true,
        order = "c",
    },
    {
        type = "bool-setting",
        name = "zen-tower-enabled",
        setting_type = "startup",
        default_value = true,
        order = "d",
        localised_description = {"", "Alternative agricultural tower mk1/mk2"}
    },
    {
        type = "bool-setting",
        name = "charcoal-burning-enabled",
        setting_type = "startup",
        default_value = true,
        order = "e"
    },
    {
        type = "bool-setting",
        name = "move-artificial-tiles",
        setting_type = "startup",
        default_value = true,
        order = "f",
        localised_description = {"", "Bricks and friends move to landscaping tab."}
    },
    {
        type = "bool-setting",
        name = "invasive-forestry",
        setting_type = "startup",
        default_value = true,
        order = "g",
        localised_description = {"", "Nauvis trees can be planted on gleba if artificial grass is present"}
    },
    {
        type = "bool-setting",
        name = "fuel-pollution-overhaul",
        setting_type = "startup",
        default_value = true,
        order = "h",
        localised_description = {"", "Wood has 50% pollution as fuel, while coal has 150%"}
    }
})