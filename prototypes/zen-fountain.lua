-- zen-fountain.lua
-- TODO: - needs water animation, and color mask for different fluids
-- Idea: fluid level somehow affect animation? sprinkled water height might be the whole fluid level meter, only visible to height it is filled.

if not settings.startup["zen-fountain-enabled"].value then return end

local sounds = require("__base__/prototypes/entity.sounds")

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
                underground_collision_mask = {layers={lava_tile=true, empty_space=true}}
            },
            {
                flow_direction = "input-output",
                position = { 0, 0 },
                direction = defines.direction.south,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = {layers={lava_tile=true, empty_space=true}}
            },
            {
                flow_direction = "input-output",
                position = { -0, 0 },
                direction = defines.direction.west,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = {layers={lava_tile=true, empty_space=true}}
            },
            {
                flow_direction = "input-output",
                position = { 0, 0 },
                direction = defines.direction.east,
                connection_type = "underground",
                max_underground_distance = 10,
                underground_collision_mask = {layers={lava_tile=true, empty_space=true}}
            }
        }
    }
}

local pipe_to_ground_pictures = util.table.deepcopy(data.raw["pipe-to-ground"]["pipe-to-ground"].pictures)
local pipe_pictures = util.table.deepcopy(data.raw.pipe.pipe.pictures.cross)

local function add_shift(sprite, dx, dy)
    if not sprite.shift then
        sprite.shift = {0, 0}
    end
    sprite.shift[1] = sprite.shift[1] + dx
    sprite.shift[2] = sprite.shift[2] + dy
    if sprite.hr_version then
        if not sprite.hr_version.shift then
            sprite.hr_version.shift = {0, 0}
        end
        sprite.hr_version.shift[1] = sprite.hr_version.shift[1] + dx
        sprite.hr_version.shift[2] = sprite.hr_version.shift[2] + dy
    end
end

local function create_4way_pipe_conection_layer()
    -- creates the animation layers
    -- uses copies of underground pipes and the 4 way normal pipe picture
    -- layers ordering from north to south from west to east.
    -- should mimic a 4 way intersection of undergroudn pipes and a way pipe in the middle, on a 3x3 area.
    -- the fluid boxes are 0,0 by a design choice, the underground pipe pictures should be , 1,0 -1,0 0,1, 0,-1
    local pipe_layers = {}

    -- North (shift 0, -1)
    local north_layer = util.table.deepcopy(pipe_to_ground_pictures.north)
    for _, layer in ipairs(north_layer.layers) do
        add_shift(layer, 0, -1)
        table.insert(pipe_layers, layer)
    end

    -- Center cross
    for _, layer in ipairs(pipe_pictures.layers) do
        table.insert(pipe_layers, util.table.deepcopy(layer))
    end

    -- West (shift -1, 0)
    local west_layer = util.table.deepcopy(pipe_to_ground_pictures.west)
    for _, layer in ipairs(west_layer.layers) do
        add_shift(layer, -1, 0)
        table.insert(pipe_layers, layer)
    end

    -- East (shift 1, 0)
    local east_layer = util.table.deepcopy(pipe_to_ground_pictures.east)
    for _, layer in ipairs(east_layer.layers) do
        add_shift(layer, 1, 0)
        table.insert(pipe_layers, layer)
    end

        -- South (shift 0, 1)
    local south_layer = util.table.deepcopy(pipe_to_ground_pictures.south)
    for _, layer in ipairs(south_layer.layers) do
        add_shift(layer, 0, 1)
        table.insert(pipe_layers, layer)
    end


    return pipe_layers
end

local fountain_layer = {
    filename = "__zen-garden__/graphics/entity/zen-fountain/zen-fountain.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 0.3,
}
local fountain_shadow = {
    filename = "__zen-garden__/graphics/entity/zen-fountain/zen-fountain-shadow.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    line_length = 1,
    scale = 0.3,
    draw_as_shadow = true,
}

local all_layers = create_4way_pipe_conection_layer()
table.insert(all_layers, fountain_shadow)
table.insert(all_layers, fountain_layer)

local fountain_entity = {
    type = "storage-tank",
    name = "zen-fountain",
    icon = "__zen-garden__/graphics/icons/zen-fountain.png",
    flags = { "placeable-player", "player-creation" },
    minable = { mining_time = 0.5, result = "zen-fountain" },
    max_health = 200,
    corpse = "storage-tank-remnants",
    dying_explosion = "storage-tank-explosion",
    collision_box = { { -1.3, -1.3 }, { 1.3, 1.3 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    fast_replaceable_group = "zen-decor", 
    fluid_box = {
        volume = 10000,
        -- pipe_covers = pipecoverspictures(),
        pipe_connections = common_fluid_boxes[1].pipe_connections,
        hide_connection_info = true, -- should we?
    },
    two_direction_only = true,
    window_bounding_box = {{-0.125, 0.6875}, {0.1875, 1.1875}}, -- TODO
    pictures = {
        picture = {
            layers = all_layers
        },
        window_background = {
            filename = "__core__/graphics/empty.png",
            priority = "extra-high-no-scale",
            width = 1,
            height = 1,
            scale = 1
        },
        fluid_background = {
            filename = "__core__/graphics/empty.png",
            priority = "extra-high-no-scale",
            width = 1,
            height = 1,
            scale = 1
        },
        flow_sprite = {
            filename = "__core__/graphics/empty.png",
            priority = "extra-high-no-scale",
            width = 1,
            height = 1,
            scale = 1
        },
        gas_flow = {
            filename = "__core__/graphics/empty.png",
            priority = "extra-high-no-scale",
            axially_symmetrical = false,
            direction_count = 1,
            frame_count = 1,
            width = 1,
            height = 1,
            scale = 1,
            animation_speed = 0
        }
    },
    working_sound = {
        sound = { filename = "__base__/sound/pipe.ogg", volume = 0.55, audible_distance_modifier = 0.5 },
        fade_in_ticks = 4,
        fade_out_ticks = 20
    },
    vehicle_impact_sound = sounds.generic_impact,
}

local fountain_item = {
    type = "item",
    name = "zen-fountain",
    icon = "__zen-garden__/graphics/icons/zen-fountain.png",
    subgroup = "advanced-gardening",
    order = "a[zen-fountain]",
    place_result = "zen-fountain",
    stack_size = 20,
    localised_description = {"item-description.zen-fountain"}
}

local fountain_recipe = {
    type = "recipe",
    name = "zen-fountain",
    category = "crafting",
    energy_required = 2,
    enabled = false,
    ingredients = {
        { type = "item", name = "stone-brick", amount = 12 },
        { type = "item", name = "pipe-to-ground", amount = 4 },
        { type = "item", name = "pipe", amount = 2 }
    },
    results = { { type = "item", name = "zen-fountain", amount = 1 } }
}

local fountain_technology = {
    type = "technology",
    name = "zen-fountain",
    icon = "__zen-garden__/graphics/technology/zen-fountain.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "zen-fountain" }
    },
    prerequisites = { "zen-bonsai" },
    unit = {
        count = 50,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    }
}

data:extend({ fountain_entity })
data:extend({ fountain_item })
data:extend({ fountain_recipe })
data:extend({ fountain_technology })