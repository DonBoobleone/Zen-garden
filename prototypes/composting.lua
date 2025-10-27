local util = require('util')
local item_sounds = require("__base__.prototypes.item_sounds")
local seconds = 60
local minutes = 60 * seconds

-- Tile definition
local artificial_grass = util.table.deepcopy(data.raw["tile"]["grass-1"])
artificial_grass.name = "artificial-grass"
artificial_grass.minable = { mining_time = 0.5, result = "artificial-grass" }
artificial_grass.mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.8 }
artificial_grass.map_color = { r = 55 / 255, g = 69 / 255, b = 11 / 255 }
artificial_grass.is_foundation = true
artificial_grass.layer_group = "ground-artificial"
artificial_grass.subgroup = "gardening-tiles"
artificial_grass.order = "a[artificial]-d[utility]-a[grass]"
artificial_grass.decorative_removal_probability = 0.5
artificial_grass.collision_mask = data.raw["tile"]["landfill"].collision_mask
artificial_grass.check_collision_with_entities = true

local function create_list_of_nauvis_and_gleba_tiles()
    local tile_condition = {}

    -- Nauvis land tiles (dynamic search by subgroup for mod compatibility)
    for name, tile in pairs(data.raw.tile) do
        if tile.subgroup == "nauvis-tiles" then
            table.insert(tile_condition, name)
        end
    end
    -- Alien biomes tiles by biome
    if mods["alien-biomes"] then
        local ab_tiles = alien_biomes.list_tiles(alien_biomes.require_tag(alien_biomes.all_tiles(),
            { "grass", "dirt", "sand", "frozen" }))
        for _, tile in ipairs(ab_tiles) do
            table.insert(tile_condition, tile)
        end
    end
    
    if settings.startup["invasive-forestry"].value then
        -- Gleba land tiles (dynamic search by subgroup)
        for name, tile in pairs(data.raw.tile) do
            if tile.subgroup == "gleba-tiles" then
                table.insert(tile_condition, name)
            end
        end
        -- Gleba water tiles (dynamic search by subgroup)
        for name, tile in pairs(data.raw.tile) do
            if tile.subgroup == "gleba-water-tiles" then
                table.insert(tile_condition, name)
            end
        end
    end
    -- Additional tiles
    table.insert(tile_condition, "landfill")
    return tile_condition
end

data:extend({ artificial_grass })

local composting_items = {
    {
        type = "item",
        name = "compost",
        icon = "__zen-garden__/graphics/icons/compost.png",
        icon_size = 64,
        subgroup = "gardening-tiles",
        order = "a[compost]",
        stack_size = 100,
        spoil_result = "artificial-grass",
        spoil_ticks = 5 * minutes,
        weight = 10 * kg,
        inventory_move_sound = item_sounds.wood_inventory_move,
        pick_sound = item_sounds.wood_inventory_pickup,
        drop_sound = item_sounds.wood_inventory_move
    },
    {
        type = "item",
        name = "artificial-grass",
        icon = "__space-age__/graphics/technology/artificial-soil.png",
        icon_size = 256,
        subgroup = "gardening-tiles",
        order = "a[artificial-grass]",
        inventory_move_sound = item_sounds.brick_inventory_move,
        pick_sound = item_sounds.brick_inventory_pickup,
        drop_sound = item_sounds.brick_inventory_move,
        stack_size = 100,
        weight = 10 * kg,
        auto_recycle = true,
        default_import_location = "nauvis",
        place_as_tile =
        {
            result = "artificial-grass",
            condition_size = 1,
            condition = { layers = { lava_tile = true, empty_space = true, out_of_map = true } }, -- this excludes anything with collision layer set to true removed--artificial_grass_exclusion = true
            tile_condition = create_list_of_nauvis_and_gleba_tiles()                              -- This is an inclusive list of allowed tiles
        }
    }
}

local common_recipe_properties = {
    type = "recipe",
    category = "organic-or-assembling",
    subgroup = "wood-processing",
    enabled = false,
    allow_productivity = true,
    auto_recycle = false,
    crafting_machine_tint = {
        primary = { r = 0.442, g = 0.205, b = 0.090, a = 1.000 },
        secondary = { r = 1.000, g = 0.500, b = 0.000, a = 1.000 }
    }
}

local crude_recipe = util.table.deepcopy(common_recipe_properties)
crude_recipe.name = "crude-wood-processing"
crude_recipe.icon = "__base__/graphics/icons/tree-02-stump.png"
crude_recipe.subgroup = "wood-processing"
crude_recipe.order = "z[crude-wood-processing]"
crude_recipe.energy_required = 2
crude_recipe.ingredients = { { type = "item", name = "wood", amount = 2 } }
crude_recipe.results = { { type = "item", name = "tree-seed", amount = 1, probability = 0.9 } }

data:extend({ crude_recipe })

local composting_recipes = {
    {
        type = "recipe",
        name = "compost-from-wood",
        category = "organic-or-assembling",
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 64, scale = 0.5,  shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/wood.png",          icon_size = 64, scale = 0.25, shift = { 8, 8 } }
        },
        ingredients = {
            { type = "item",  name = "wood",  amount = 50 },
            { type = "fluid", name = "water", amount = 1000 }
        },
        results = {
            { type = "item", name = "compost", amount = 1 }
        },
        allow_productivity = true,
        subgroup = "gardening-tiles",
        order = "a[compost]-a[wood]"
    },
    {
        type = "recipe",
        name = "compost-from-spoilage",
        category = "organic-or-assembling",
        enabled = false,
        energy_required = 120,
        icons = {
            { icon = "__zen-garden__/graphics/icons/compost.png", icon_size = 64, scale = 0.5,  shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/spoilage.png", icon_size = 64, scale = 0.25, shift = { 8, 8 } }
        },
        ingredients = {
            { type = "item",  name = "spoilage", amount = 100 },
            { type = "fluid", name = "water",    amount = 1000 }
        },
        results = {
            { type = "item", name = "compost", amount = 1 }
        },
        allow_productivity = true,
        subgroup = "gardening-tiles",
        order = "a[compost]-b[spoilage]"
    },
    {
        type = "recipe",
        name = "soil-mixing",
        category = "organic-or-assembling",
        enabled = false,
        energy_required = 10,
        icons = {
            { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.125, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/nutrients.png",            icon_size = 64,  scale = 0.25,  shift = { 8, 8 } },
            { icon = "__base__/graphics/icons/landfill.png",                  icon_size = 64,  scale = 0.25,  shift = { -8, 8 } }
        },
        ingredients = {
            { type = "item", name = "artificial-grass", amount = 5 },
            { type = "item", name = "landfill",         amount = 5 },
            { type = "item", name = "nutrients",        amount = 50 }
        },
        results = {
            { type = "item", name = "artificial-grass", amount = 10 }
        },
        auto_recycle = false,
        allow_productivity = false,
        subgroup = "gardening-tiles",
        order = "a[artificial-grass]-b[breeding]"
    }
}

local composting_technologies = {
    {
        type = "technology",
        name = "basic-gardening",
        icon = "__zen-garden__/graphics/technology/landscaping.png",
        icon_size = 256,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "crude-wood-processing"
            }
        },
        prerequisites = nil,
        research_trigger = {
            type = "craft-item",
            item = "wooden-chest",
            count = 50
        }
    },
    {
        type = "technology",
        name = "composting",
        icon = "__zen-garden__/graphics/technology/compost.png",
        icon_size = 256,
        effects = {
            {
                type = "unlock-recipe",
                recipe = "compost-from-wood"
            },
            {
                type = "unlock-recipe",
                recipe = "compost-from-spoilage"
            }
        },
        prerequisites = { "basic-gardening", "automation-2" },
        unit = {
            count = 100,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 }
            },
            time = 30
        }
    },
    {
        type = "technology",
        name = "soil-mixing",
        icons = {
            { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.25, shift = { 0, 0 } },
            { icon = "__space-age__/graphics/icons/nutrients.png",            icon_size = 64,  scale = 0.5,  shift = { 16, 16 } },
            { icon = "__base__/graphics/icons/landfill.png",                  icon_size = 64,  scale = 0.5,  shift = { -16, 16 } }
        },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "soil-mixing"
            }
        },
        prerequisites = { "composting", "artificial-soil" },
        unit = {
            count = 100,
            ingredients = {
                { "automation-science-pack",   1 },
                { "logistic-science-pack",     1 },
                { "chemical-science-pack",     1 },
                { "space-science-pack",        1 },
                { "agricultural-science-pack", 1 }
            },
            time = 60
        }
    }
}

data:extend(composting_items)
data:extend(composting_recipes)
data:extend(composting_technologies)
