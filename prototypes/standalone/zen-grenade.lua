--prototypes.standalone.zen-grenade.lua
local item_sounds = require("__base__.prototypes.item_sounds")

-- Holy Zen Grenade (Decal-Only Remover)
local holy_zen_grenade_item = {
    type = "capsule",
    name = "zen-grenade",
    icon = "__zen-garden__/graphics/icons/zen-grenade.png",
    icon_size = 64,
    subgroup = "terrain",
    order = "z[zen]",
    inventory_move_sound = item_sounds.grenade_inventory_move,
    pick_sound = item_sounds.grenade_inventory_pickup,
    drop_sound = item_sounds.grenade_inventory_move,
    stack_size = 100,
    weight = 10 * kg,
    capsule_action = {
        type = "throw",
        attack_parameters = {
            type = "projectile",
            activation_type = "throw",
            ammo_category = "grenade",
            cooldown = 60,
            range = 20,
            projectile_creation_distance = 0.1,
            damage_modifier = 0,
            lead_target = false,
            ammo_type = {
                category = "grenade",
                target_type = "position",
                action = {
                    type = "direct",
                    action_delivery = {
                        type = "projectile",
                        projectile = "zen-grenade",
                        starting_speed = 0.25,
                        source_effects = {
                            type = "create-entity",
                            entity_name = "explosion-gunshot"
                        },
                        starting_speed_deviation = 0.1,
                        direction_deviation = 0.1,
                    }
                }
            }
        }
    }
}

--Testing command that destroys decals around player

-- 1. LIST UNIQUE DECAL NAMES & COUNTS around player
-- /c local p=game.player.position local a={{p.x-4,p.y-4},{p.x+4,p.y+4}} local decals=game.player.surface.find_decoratives_filtered{area=a,from_layer="decals",to_layer="decals"} local names={} for _,decal in pairs(decals) do local n=decal.decorative and decal.decorative.name or "NIL" if n then names[n]=true end end local keylist={} for name in pairs(names) do table.insert(keylist,name) end local out=table.concat(keylist,", ") game.print("Decal names ("..#decals.."): "..out)
-- Destroy
-- /c local p=game.player.position local a={{p.x-4,p.y-4},{p.x+4,p.y+4}} game.player.surface.destroy_decoratives{area=a, from_layer="decals", to_layer="decals", exclude_soft=true}


-- Projectile
local holy_zen_grenade_projectile = {
    type = "projectile",
    name = "zen-grenade",
    flags = { "not-on-map" },
    hidden = true,
    acceleration = 0.005,
    action = {
        {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "create-entity",
                        entity_name = "ground-explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "wooden-chest-explosion"
                    },
                    {
                        type = "destroy-decoratives",
                        radius = 6.9,
                        from_render_layer = "decals",
                        to_render_layer = "decals",
                        include_soft_decoratives = false,
                        include_decals = true,
                        invoke_decorative_trigger = true,
                        decoratives_with_trigger_only = false,
                        repeat_count = 1,
                        probability = 1
                    }
                }
            }
        }
    },
    light = { intensity = 0.5, size = 4 },
    animation = {
        filename = "__zen-garden__/graphics/entity/zen-grenade/zen-grenade.png",
        draw_as_glow = true,
        frame_count = 15,
        line_length = 8,
        animation_speed = 0.250,
        width = 48,
        height = 54,
        shift = util.by_pixel(0.5, 0.5),
        priority = "high",
        scale = 0.5
    },
    shadow = {
        filename = "__zen-garden__/graphics/entity/zen-grenade/zen-grenade-shadow.png",
        frame_count = 15,
        line_length = 8,
        animation_speed = 0.250,
        width = 50,
        height = 40,
        shift = util.by_pixel(2, 6),
        priority = "high",
        draw_as_shadow = true,
        scale = 0.5
    }
}

local holy_zen_grenade_recipe = {
    type = "recipe",
    name = "zen-grenade",
    enabled = false,
    category = "crafting",
    energy_required = 2.5,
    auto_recycle = false,
    allow_decomposition = false,
    ingredients = {
        { type = "item", name = "artificial-grass", amount = 1 },
        { type = "item", name = "grenade",          amount = 1 },
        { type = "item", name = "wooden-chest",     amount = 1 }
    },
    results = {
        { type = "item", name = "zen-grenade", amount = 1 }
    }
}

local holy_zen_tech = {
    type = "technology",
    name = "zen-maintenance",
    localised_name = { "technology-name.zen-maintenance" },
    icon_size = 256,
    icon = "__zen-garden__/graphics/technology/zen-grenade.png",
    prerequisites = { "composting", "concrete", "military-2" },
    unit = {
        count = 50,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 }
        },
        time = 30
    },
    effects = {
        {
            type = "unlock-recipe",
            recipe = "zen-grenade"
        }
    }
}

data:extend({
    holy_zen_grenade_item,
    holy_zen_grenade_projectile,
    holy_zen_grenade_recipe,
    holy_zen_tech
})
