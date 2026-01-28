-- settings.lua
data:extend({
    {
        type = "bool-setting",
        name = "zen-seeds-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a",
        localised_description = {"mod-setting-description.zen-seeds-enabled"}
    },
    {
        type = "bool-setting",
        name = "zen-trees-enabled",
        setting_type = "startup",
        default_value = true,
        order = "b",
        localised_description = {"mod-setting-description.zen-trees-enabled"}
    },
    {
        type = "bool-setting",
        name = "force-basic-zen-tree-recipe",
        setting_type = "startup",
        default_value = false,
        order = "c",
        localised_description = {"mod-setting-description.force-basic-zen-tree-recipe"}
    },
    {
        type = "bool-setting",
        name = "bonsai-seed-enabled",
        setting_type = "startup",
        default_value = true,
        order = "d",
        localised_description = {"mod-setting-description.bonsai-seed-enabled"}
    },
    {
        type = "bool-setting",
        name = "zen-bonsai-decor-enabled",
        setting_type = "startup",
        default_value = true,
        order = "e",
        localised_description = {"mod-setting-description.zen-bonsai-decor-enabled"}
    },
    {
        type = "bool-setting",
        name = "zen-garden-enabled",
        setting_type = "startup",
        default_value = true,
        order = "f",
        localised_description = {"mod-setting-description.zen-garden-enabled"}
    },
    {
        type = "bool-setting",
        name = "zen-tower-enabled",
        setting_type = "startup",
        default_value = true,
        order = "g",
        localised_description = {"mod-setting-description.zen-tower-enabled"}
    },
    --[[ {
        type = "bool-setting",
        name = "zen-fountain-enabled",
        setting_type = "startup",
        default_value = true,
        order = "h",
        localised_description = {"mod-setting-description.zen-fountain-enabled"}
    }, ]]
    {
        type = "bool-setting",
        name = "move-artificial-tiles",
        setting_type = "startup",
        default_value = true,
        order = "i",
        localised_description = {"mod-setting-description.move-artificial-tiles"}
    },
    {
        type = "bool-setting",
        name = "move-tree-seed",
        setting_type = "startup",
        default_value = true,
        order = "j",
        localised_description = {"mod-setting-description.move-tree-seed"}
    },
    {
        type = "bool-setting",
        name = "invasive-forestry",
        setting_type = "startup",
        default_value = true,
        order = "k",
        localised_description = {"mod-setting-description.invasive-forestry"}
    },
    {
        type = "bool-setting",
        name = "fuel-pollution-overhaul",
        setting_type = "startup",
        default_value = true,
        order = "l",
        localised_description = {"mod-setting-description.fuel-pollution-overhaul"}
    },
    {
        type = "bool-setting",
        name = "charcoal-burning-enabled",
        setting_type = "startup",
        default_value = true,
        order = "m",
        localised_description = {"mod-setting-description.charcoal-burning-enabled"}
    },
    {
        type = "bool-setting",
        name = "enable-extended-grass-selection",
        setting_type = "startup",
        default_value = true,
        order = "n",
        localised_description = {"mod-setting-description.enable-extended-grass-selection"}
    }
})