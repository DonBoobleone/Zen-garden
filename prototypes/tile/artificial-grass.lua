-- prototypes.tile.artificial-grass.lua
local item_sounds = require("__base__.prototypes.item_sounds")

-- Helper function
local function create_list_of_nauvis_and_gleba_tiles()
    local allowed_grass_placement_tiles = {}

    -- Nauvis land tiles (dynamic search by item subgroup for mod compatibility)
    for name, tile in pairs(data.raw.tile) do
        if tile.subgroup == "nauvis-tiles" then
            table.insert(allowed_grass_placement_tiles, name)
        end
    end

    -- Alien biomes tiles by biome
    if mods["alien-biomes"] then
        local ab_tiles = alien_biomes.list_tiles(alien_biomes.require_tag(alien_biomes.all_tiles(),
            { "grass", "dirt", "sand", "frozen" })) -- TODO: check other biomes like volcanic, wetland
        for _, tile in ipairs(ab_tiles) do
            table.insert(allowed_grass_placement_tiles, tile)
        end
    end

    if settings.startup["invasive-forestry"].value then
        -- Gleba land tiles (dynamic search by subgroup)
        for name, tile in pairs(data.raw.tile) do
            if tile.subgroup == "gleba-tiles" then
                table.insert(allowed_grass_placement_tiles, name)
            end
        end
        -- Gleba water tiles (dynamic search by subgroup)
        for name, tile in pairs(data.raw.tile) do
            if tile.subgroup == "gleba-water-tiles" then
                table.insert(allowed_grass_placement_tiles, name)
            end
        end
    end

    -- Additional tiles
    table.insert(allowed_grass_placement_tiles, "landfill")

    -- Planet compatibility tiles
    if mods["lignumis"] then
        table.insert(allowed_grass_placement_tiles, "natural-gold-soil")
    end
    if mods["pelagos"] then
        table.insert(allowed_grass_placement_tiles, "pelagos-sand-3")
    end

    return allowed_grass_placement_tiles
end

local function create_artificial_grass_tile(base_tile_name, new_tile_name, order_suffix)
    local tile = util.table.deepcopy(data.raw["tile"][base_tile_name])
    tile.name = new_tile_name
    tile.minable = { mining_time = 0.5, result = new_tile_name }
    tile.mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.8 }
    tile.map_color = { r = 55 / 255, g = 69 / 255, b = 11 / 255 }
    tile.is_foundation = true
    --artificial_grass_tile.layer_group = "ground-artificial" -- if not ground-neutral as default, tile connections will look bad
    tile.subgroup = "gardening-tiles"
    tile.order = "a[artificial]-d[utility]-a[grass]" .. order_suffix
    tile.decorative_removal_probability = 0.25
    tile.collision_mask = data.raw["tile"]["landfill"].collision_mask
    tile.check_collision_with_entities = true
    return tile
end

local function create_artificial_grass_item(new_item_name, order_suffix, tile_name)
    return {
        type = "item",
        name = new_item_name,
        icon = "__space-age__/graphics/technology/artificial-soil.png",
        icon_size = 256,
        subgroup = "gardening-tiles",
        order = "a[" .. new_item_name .. "]",
        inventory_move_sound = item_sounds.landfill_inventory_move,
        pick_sound = item_sounds.landfill_inventory_pickup,
        drop_sound = item_sounds.landfill_inventory_move,
        stack_size = 100,
        weight = 10 * kg,
        auto_recycle = true,
        default_import_location = "nauvis",
        place_as_tile = {
            result = tile_name,
            condition_size = 1,
            condition = { layers = { lava_tile = true, empty_space = true, out_of_map = true } }, -- this excludes anything with collision layer set to true
            tile_condition = create_list_of_nauvis_and_gleba_tiles()                              -- This is an inclusive list of all allowed tiles
        }
    }
end

local artificial_grass_tile_conditions = create_list_of_nauvis_and_gleba_tiles()

-- Tile definition
local artificial_grass_tile = create_artificial_grass_tile("grass-1", "artificial-grass", "")

local artificial_grass_item = create_artificial_grass_item("artificial-grass", "", "artificial-grass")

local artificial_grass_2_tile = create_artificial_grass_tile("grass-2", "artificial-grass-2", "-2")

local artificial_grass_2_item = {
    type = "item",
    name = "artificial-grass-2",
    icons = {
        { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.125, shift = { 0, 0 } },
        { icon = "__base__/graphics/icons/signal/signal_2.png",           icon_size = 64,  scale = 0.25,  shift = { 8, -8 } },
    },
    subgroup = "gardening-tiles",
    order = "a[artificial-grass]-a[2]",
    inventory_move_sound = item_sounds.landfill_inventory_move,
    pick_sound = item_sounds.landfill_inventory_pickup,
    drop_sound = item_sounds.landfill_inventory_move,
    stack_size = 100,
    weight = 10 * kg,
    auto_recycle = true,
    default_import_location = "nauvis",
    place_as_tile = {
        result = "artificial-grass-2",
        condition_size = 1,
        condition = { layers = { lava_tile = true, empty_space = true, out_of_map = true } }, -- this excludes anything with collision layer set to true
        tile_condition =
            artificial_grass_tile_conditions                                                  -- This is an inclusive list of all allowed tiles
    }
}


local artificial_grass_3_tile = create_artificial_grass_tile("grass-3", "artificial-grass-3", "-3")

local artificial_grass_3_item = {
    type = "item",
    name = "artificial-grass-3",
    icons = {
        { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.125, shift = { 0, 0 } },
        { icon = "__base__/graphics/icons/signal/signal_3.png",           icon_size = 64,  scale = 0.25,  shift = { 8, -8 } },
    },
    subgroup = "gardening-tiles",
    order = "a[artificial-grass]-a[3]",
    inventory_move_sound = item_sounds.landfill_inventory_move,
    pick_sound = item_sounds.landfill_inventory_pickup,
    drop_sound = item_sounds.landfill_inventory_move,
    stack_size = 100,
    weight = 10 * kg,
    auto_recycle = true,
    default_import_location = "nauvis",
    place_as_tile = {
        result = "artificial-grass-3",
        condition_size = 1,
        condition = { layers = { lava_tile = true, empty_space = true, out_of_map = true } }, -- this excludes anything with collision layer set to true
        tile_condition =
            artificial_grass_tile_conditions                                                  -- This is an inclusive list of all allowed tiles
    }
}



data:extend({
    artificial_grass_tile,
    artificial_grass_item,
    artificial_grass_2_tile,
    artificial_grass_2_item,
    artificial_grass_3_tile,
    artificial_grass_3_item,
})
