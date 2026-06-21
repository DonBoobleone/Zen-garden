-- settings.lua
data:extend({
    -- new content or recipes
    {
        type = "bool-setting",
        name = "zen-tower-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a[content]-a",
        localised_description = {"mod-setting-description.zen-tower-enabled"}
    },
    {
        type = "bool-setting",
        name = "zen-garden-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a[content]-b",
        localised_description = {"mod-setting-description.zen-garden-enabled"}
    },
    {
        type = "bool-setting",
        name = "bonsai-seed-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a[content]-c",
        localised_description = {"mod-setting-description.bonsai-seed-enabled"}
    },
    {
        type = "bool-setting",
        name = "charcoal-burning-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a[content]-d",
        localised_description = {"mod-setting-description.charcoal-burning-enabled"}
    },
    -- QoL, Gui, modifications
    {
        type = "bool-setting",
        name = "move-artificial-tiles",
        setting_type = "startup",
        default_value = true,
        order = "c[gui]-a",
        localised_description = {"mod-setting-description.move-artificial-tiles"}
    },
    {
        type = "bool-setting",
        name = "move-tree-seed",
        setting_type = "startup",
        default_value = true,
        order = "c[gui]-b",
        localised_description = {"mod-setting-description.move-tree-seed"}
    },
    {
        type = "bool-setting",
        name = "fuel-pollution-overhaul",
        setting_type = "startup",
        default_value = true,
        order = "d[overhaul]-a",
        localised_description = {"mod-setting-description.fuel-pollution-overhaul"}
    },
    {
        type = "bool-setting",
        name = "invasive-forestry",
        setting_type = "startup",
        default_value = true,
        order = "d[overhaul]-b",
        localised_description = {"mod-setting-description.invasive-forestry"}
    },
    -- Cosmetics
    {
        type = "bool-setting",
        name = "zen-seeds-enabled",
        setting_type = "startup",
        default_value = true,
        order = "z[cosmetic]-a",
        localised_description = {"mod-setting-description.zen-seeds-enabled"}
    },
    {
        type = "bool-setting",
        name = "zen-trees-enabled",
        setting_type = "startup",
        default_value = true,
        order = "z[cosmetic]-b",
        localised_description = {"mod-setting-description.zen-trees-enabled"}
    },
    {
        type = "bool-setting",
        name = "force-basic-zen-tree-recipe",
        setting_type = "startup",
        default_value = false,
        order = "z[cosmetic]-c",
        localised_description = {"mod-setting-description.force-basic-zen-tree-recipe"}
    },
    {
        type = "bool-setting",
        name = "zen-bonsai-decor-enabled",
        setting_type = "startup",
        default_value = true,
        order = "z[cosmetic]-d",
        localised_description = {"mod-setting-description.zen-bonsai-decor-enabled"}
    },
    {
        type = "bool-setting",
        name = "enable-extended-grass-selection",
        setting_type = "startup",
        default_value = true,
        order = "z[cosmetic]-e",
        localised_description = {"mod-setting-description.enable-extended-grass-selection"}
    },
    {
        type = "bool-setting",
        name = "zen-grenade-enabled",
        setting_type = "startup",
        default_value = true,
        order = "z[cosmetic]-f",
        localised_description = {"mod-setting-description.zen-grenade-enabled"}
    }
})