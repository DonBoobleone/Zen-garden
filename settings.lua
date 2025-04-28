data:extend(
{
    {
        type = "bool-setting",
        name = "zen-seeds-enabled",
        setting_type = "startup",
        default_value = true,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "zen-trees-enabled",
        setting_type = "startup",
        default_value = true,
        order = "b",
        localised_description = {"", "Requires 'zen-seeds-enabled' to be true."}
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
        name = "charcoal-burning-enabled",
        setting_type = "startup",
        default_value = true,
        order = "d"
    },
    {
        type = "bool-setting",
        name = "move-artificial-tiles",
        setting_type = "startup",
        default_value = true,
        order = "d"
    }
})