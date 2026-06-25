-- zen-bonsai.lua
if not settings.startup["zen-bonsai-decor-enabled"].value then return end

-- Common underground fluid box for 4-way connections
local common_fluid_boxes = {
    {
        production_type = "input",
        volume = 100,
        pipe_connections = {
            {
                flow_direction = "input-output",
                position = { 0, -0 },
                direction = defines.direction.north,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = { layers = { lava_tile = true, empty_space = true } }
            },
            {
                flow_direction = "input-output",
                position = { 0, 0 },
                direction = defines.direction.south,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = { layers = { lava_tile = true, empty_space = true } }
            },
            {
                flow_direction = "input-output",
                position = { -0, 0 },
                direction = defines.direction.west,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = { layers = { lava_tile = true, empty_space = true } }
            },
            {
                flow_direction = "input-output",
                position = { 0, 0 },
                direction = defines.direction.east,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = { layers = { lava_tile = true, empty_space = true } }
            }
        }
    }
}

-- Helper: Create main sprite + shadow layers
local function create_direction_layers(base_name, direction)
    local folder = "__zen-garden__/graphics/entity/" .. base_name .. "/"
    return {
        {
            filename = folder .. base_name .. "-" .. direction .. ".png",
            priority = "extra-high",
            width = 512,
            height = 512,
            frame_count = 1,
            line_length = 1,
            scale = 0.3,
        },
        {
            filename = folder .. base_name .. "-" .. direction .. "-shadow.png",
            priority = "extra-high",
            width = 512,
            height = 512,
            frame_count = 1,
            line_length = 1,
            scale = 0.3,
            draw_as_shadow = true,
        }
    }
end

-- Helper: Create water reflection with 4 directional variations
local function create_water_reflection(base_name)
    local folder = "__zen-garden__/graphics/entity/" .. base_name .. "/"
    return {
        pictures = {
            {
                filename = folder .. base_name .. "-n-reflection.png",
                priority = "extra-high",
                width = 512,
                height = 512,
                scale = 0.3,
            },
            {
                filename = folder .. base_name .. "-e-reflection.png",
                priority = "extra-high",
                width = 512,
                height = 512,
                scale = 0.3,
            },
            {
                filename = folder .. base_name .. "-s-reflection.png",
                priority = "extra-high",
                width = 512,
                height = 512,
                scale = 0.3,
            },
            {
                filename = folder .. base_name .. "-w-reflection.png",
                priority = "extra-high",
                width = 512,
                height = 512,
                scale = 0.3,
            }
        },
        orientation_to_variation = true,  -- Maps north=0, east=0.25, etc. to the 4 variations
    }
end

-- Zen Bonsai entity
local zen_bonsai_entity = {
    type = "assembling-machine",
    name = "zen-bonsai",
    icon = "__zen-garden__/graphics/icons/zen-bonsai.png",
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 0.2, result = "zen-bonsai" },
    max_health = 100,
    corpse = "assembling-machine-3-remnants",
    dying_explosion = "assembling-machine-3-explosion",
    fluid_boxes = common_fluid_boxes,
    fixed_recipe = "water-the-plants",
    show_recipe_icon = false,
    show_recipe_icon_on_map = false,
    fluid_boxes_off_when_no_fluid_recipe = false,
    impact_category = "metal",
    working_sound = {
        sound = { filename = "__base__/sound/world/trees/tree-ambient-leaves-1.ogg", volume = 0.55, audible_distance_modifier = 0.5 },
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    collision_box = { { -1.3, -1.3 }, { 1.3, 1.3 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    fast_replaceable_group = "zen-decor",
    graphics_set = {
        animation = {
            north = { layers = create_direction_layers("zen-bonsai", "n") },
            east  = { layers = create_direction_layers("zen-bonsai", "e") },
            south = { layers = create_direction_layers("zen-bonsai", "s") },
            west  = { layers = create_direction_layers("zen-bonsai", "w") },
        },
        water_reflection = create_water_reflection("zen-bonsai")
    },
    crafting_categories = { "gardening" },
    crafting_speed = 1,
    energy_source = {
        type = "void",
        emissions_per_minute = { pollution = -1 }
    },
    energy_usage = "10kW",
    module_slots = nil,
    bottleneck_ignore = true,
    allowed_effects = {}
}

-- Cherry Bonsai entity
local cherry_bonsai_entity = {
    type = "assembling-machine",
    name = "cherry-bonsai",
    icon = "__zen-garden__/graphics/icons/cherry-bonsai.png",
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 0.2, result = "cherry-bonsai" },
    max_health = 100,
    corpse = "assembling-machine-3-remnants",
    dying_explosion = "assembling-machine-3-explosion",
    fluid_boxes = common_fluid_boxes,
    fixed_recipe = "water-the-plants",
    show_recipe_icon = false,
    show_recipe_icon_on_map = false,
    fluid_boxes_off_when_no_fluid_recipe = false,
    impact_category = "metal",
    working_sound = {
        sound = { filename = "__base__/sound/world/trees/tree-ambient-leaves-1.ogg", volume = 0.55, audible_distance_modifier = 0.5 },
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    collision_box = { { -1.3, -1.3 }, { 1.3, 1.3 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    fast_replaceable_group = "zen-decor",
    graphics_set = {
        animation = {
            north = { layers = create_direction_layers("cherry-bonsai", "n") },
            east  = { layers = create_direction_layers("cherry-bonsai", "e") },
            south = { layers = create_direction_layers("cherry-bonsai", "s") },
            west  = { layers = create_direction_layers("cherry-bonsai", "w") },
        },
        water_reflection = create_water_reflection("cherry-bonsai")
    },
    crafting_categories = { "gardening" },
    crafting_speed = 1,
    energy_source = {
        type = "void",
        emissions_per_minute = { pollution = -1 }
    },
    energy_usage = "10kW",
    module_slots = nil,
    bottleneck_ignore = true,
    allowed_effects = {}
}

local zen_bonsai_item = {
    type = "item",
    name = "zen-bonsai",
    icon = "__zen-garden__/graphics/icons/zen-bonsai.png",
    subgroup = "advanced-gardening",
    order = "a[zen-bonsai]",
    place_result = "zen-bonsai",
    stack_size = 20,
    localised_description = { "item-description.zen-bonsai" }
}

local cherry_bonsai_item = {
    type = "item",
    name = "cherry-bonsai",
    icon = "__zen-garden__/graphics/icons/cherry-bonsai.png",
    subgroup = "advanced-gardening",
    order = "a[cherry-bonsai]",
    place_result = "cherry-bonsai",
    stack_size = 20,
    localised_description = { "item-description.cherry-bonsai" }
}

local zen_bonsai_recipe = {
    type = "recipe",
    name = "zen-bonsai",
    categories = {"crafting"},
    energy_required = 2,
    enabled = false,
    ingredients = {
        { type = "item", name = "artificial-grass", amount = 3 },
        { type = "item", name = "tree-seed",        amount = 2 },
        { type = "item", name = "pipe-to-ground",   amount = 4 },
    },
    results = { { type = "item", name = "zen-bonsai", amount = 1 } }
}

local cherry_bonsai_recipe = {
    type = "recipe",
    name = "cherry-bonsai",
    categories = {"crafting"},
    energy_required = 2,
    enabled = false,
    ingredients = {
        { type = "item", name = "artificial-grass", amount = 3 },
        { type = "item", name = "tree-seed",        amount = 2 },
        { type = "item", name = "pipe-to-ground",   amount = 4 },
    },
    results = { { type = "item", name = "cherry-bonsai", amount = 1 } }
}

local zen_bonsai_technology = {
    type = "technology",
    name = "zen-bonsai",
    icon = "__zen-garden__/graphics/technology/zen-bonsai.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "zen-bonsai" },
        { type = "unlock-recipe", recipe = "cherry-bonsai" }
    },
    prerequisites = { "composting" },
    unit = {
        count = 50,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    }
}

data:extend({ zen_bonsai_entity, cherry_bonsai_entity })
data:extend({ zen_bonsai_item, cherry_bonsai_item })
data:extend({ zen_bonsai_recipe, cherry_bonsai_recipe })
data:extend({ zen_bonsai_technology })