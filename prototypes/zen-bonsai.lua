-- current prerequisite, uses the: fixed_recipe = "water-the-plants", from zen garden
if not settings.startup["zen-garden-enabled"].value then return end

local pipe_to_ground_pictures = data.raw["pipe-to-ground"]["pipe-to-ground"].pictures

--Common
local common_fluid_boxes =
{
    {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        volume = 100,
        pipe_connections =
        {
            { flow_direction = "input-output", direction = defines.direction.north, position = { 0, -1 } },
            { flow_direction = "input-output", direction = defines.direction.south, position = { 0, 1 } },
            { flow_direction = "input-output", direction = defines.direction.west,  position = { -1, 0 } },
            { flow_direction = "input-output", direction = defines.direction.east,  position = { 1, 0 } }
        },
        secondary_draw_orders = { north = -1 }
    }
}

local pipe_layers_back = {
    util.copy(pipe_to_ground_pictures.north), -- North
    util.copy(pipe_to_ground_pictures.east),  -- East
    util.copy(pipe_to_ground_pictures.west),  -- West
}

local pipe_layers_front = {
    util.copy(pipe_to_ground_pictures.south), -- South
}

local pipe_shifts = {
    back = {
        { 0,  -1 }, -- North
        { 1,  0 }, -- East
        { -1, 0 }, -- West
    },
    front = {
        { 0, 1 }, -- South
    }
}

for i, layer in ipairs(pipe_layers_back) do layer.shift = pipe_shifts.back[i] end
for i, layer in ipairs(pipe_layers_front) do layer.shift = pipe_shifts.front[i] end

-- Zen Bonsai
local zen_bonsai_layer = {
    filename = "__zen-garden__/graphics/entity/zen-bonsai/zen-bonsai.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 0.3,
}
local zen_bonsai_shadow = {
    filename = "__zen-garden__/graphics/entity/zen-bonsai/zen-bonsai-shadow.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 0.3,
    draw_as_shadow = true,
}
--TODO: Add glow, so it functions as a free big lamp as well
-- Zen Bonsai
local cherry_bonsai_layer = {
    filename = "__zen-garden__/graphics/entity/cherry-bonsai/cherry-bonsai.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 0.3,
}
local cherry_bonsai_shadow = {
    filename = "__zen-garden__/graphics/entity/cherry-bonsai/cherry-bonsai-shadow.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 0.3,
    draw_as_shadow = true,
}

local zen_bonsai_all_layers = {}
for _, layer in ipairs(pipe_layers_back) do table.insert(zen_bonsai_all_layers, layer) end
table.insert(zen_bonsai_all_layers, zen_bonsai_layer)
table.insert(zen_bonsai_all_layers, zen_bonsai_shadow)
for _, layer in ipairs(pipe_layers_front) do table.insert(zen_bonsai_all_layers, layer) end

local zen_bonsai_entity = {
    type = "assembling-machine",
    name = "zen-bonsai",
    icon = "__zen-garden__/graphics/icons/zen-bonsai.png",
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 0.2, result = "zen-bonsai" },
    max_health = 100,
    corpse = "assembling-machine-3-remnants",           -- TODO
    dying_explosion = "assembling-machine-3-explosion", -- TODO
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
        animation =
        {
            layers = zen_bonsai_all_layers
        }
    },
    crafting_categories = { "gardening" },
    crafting_speed = 1,
    energy_source = {
        type = "void",
        emissions_per_minute = { pollution = -1 }
    },
    energy_usage = "10kW",
    module_slots = nil,
    allowed_effects = {}
}

local cherry_bonsai_all_layers = {}
for _, layer in ipairs(pipe_layers_back) do table.insert(cherry_bonsai_all_layers, layer) end
table.insert(cherry_bonsai_all_layers, cherry_bonsai_layer)
table.insert(cherry_bonsai_all_layers, cherry_bonsai_shadow)
for _, layer in ipairs(pipe_layers_front) do table.insert(cherry_bonsai_all_layers, layer) end

local cherry_bonsai_entity =
{
    type = "assembling-machine",
    name = "cherry-bonsai",
    icon = "__zen-garden__/graphics/icons/cherry-bonsai.png",
    flags = { "placeable-neutral", "placeable-player", "player-creation" },
    minable = { mining_time = 0.2, result = "cherry-bonsai" },
    max_health = 100,
    corpse = "assembling-machine-3-remnants",           -- TODO
    dying_explosion = "assembling-machine-3-explosion", -- TODO
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
        animation =
        {
            layers = cherry_bonsai_all_layers
        }
    },
    crafting_categories = { "gardening" },
    crafting_speed = 1,
    energy_source = {
        type = "void",
        emissions_per_minute = { pollution = -1 }
    },
    energy_usage = "10kW",
    module_slots = nil,
    allowed_effects = {}
}

local zen_bonsai_seed_item ={}
local cherry_bonsai_seed_item ={}
local zen_bonsai_seed_processing_recipe ={}
local cherry_bonsai_seed_processing_recipe ={}

local zen_bonsai_item = {
    type = "item",
    name = "zen-bonsai",
    icon = "__zen-garden__/graphics/icons/zen-bonsai.png",
    subgroup = "advanced-gardening",
    order = "a[zen-bonsai]",
    place_result = "zen-bonsai",
    stack_size = 20,
    weight = 50 * kg
}
local cherry_bonsai_item = {
    type = "item",
    name = "cherry-bonsai",
    icon = "__zen-garden__/graphics/icons/cherry-bonsai.png",
    subgroup = "advanced-gardening",
    order = "a[cherry-bonsai]",
    place_result = "cherry-bonsai",
    stack_size = 20,
    weight = 50 * kg
}

local zen_bonsai_recipe = {
    type = "recipe",
    name = "zen-bonsai",
    category = "crafting",
    energy_required = 2,
    enabled = false,
    ingredients = {
        { type = "item", name = "artificial-grass", amount = 3 },
        { type = "item", name = "tree-seed",        amount = 2 },
        { type = "item", name = "iron-plate",       amount = 8 },
    },
    results = { { type = "item", name = "zen-bonsai", amount = 1 } }
}

local cherry_bonsai_recipe = {
    type = "recipe",
    name = "cherry-bonsai",
    category = "crafting",
    energy_required = 2,
    enabled = false,
    ingredients = {
        { type = "item", name = "artificial-grass", amount = 3 },
        { type = "item", name = "tree-seed",        amount = 2 },
        { type = "item", name = "iron-plate",       amount = 8 },
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
