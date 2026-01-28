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
            { "grass", "dirt", "sand", "frozen" }))
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

    -- Depths of Nauvis compatibility
    if mods["depths_of_nauvis"] and settings.startup["deep-sea-mechanic"] and settings.startup["deep-sea-mechanic"].value then
        for i = #allowed_grass_placement_tiles, 1, -1 do
            local tile_name = allowed_grass_placement_tiles[i]
            if string.find(tile_name, "deepwater") then
                table.remove(allowed_grass_placement_tiles, i)
            end
        end
    end

    return allowed_grass_placement_tiles
end

local function create_artificial_grass_tile(base_tile_name, new_tile_name, order_suffix)
    local tile = util.table.deepcopy(data.raw["tile"][base_tile_name])
    tile.name = new_tile_name
    tile.minable = { mining_time = 0.25, result = new_tile_name }
    tile.mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.8 }
    tile.map_color = { r = 55 / 255, g = 69 / 255, b = 11 / 255 }
    tile.is_foundation = true
    tile.subgroup = "gardening-tiles"
    tile.order = "a[artificial]-d[utility]-a[grass]" .. order_suffix
    tile.decorative_removal_probability = 0.25
    tile.collision_mask = data.raw["tile"]["landfill"].collision_mask
    tile.check_collision_with_entities = true
    return tile
end

local function create_artificial_grass_item(name, tile_name, badge_number)
    local item = {
        type = "item",
        name = name,
        subgroup = "gardening-tiles",
        order = badge_number and "a[artificial-grass]-a[" .. badge_number .. "]" or "a[" .. name .. "]",
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
            condition = { layers = { lava_tile = true, empty_space = true, out_of_map = true } },
            tile_condition = create_list_of_nauvis_and_gleba_tiles()
        }
    }

    if badge_number then
        item.icons = {
            { icon = "__space-age__/graphics/technology/artificial-soil.png", icon_size = 256, scale = 0.125, shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/signal/signal_" .. badge_number .. ".png", icon_size = 64, scale = 0.25, shift = { 8, -8 } },
        }
    else
        item.icon = "__space-age__/graphics/technology/artificial-soil.png"
        item.icon_size = 256
    end

    return item
end

local function create_artificial_grass_conversion_recipe(to_item, badge_number)
    return {
        type = "recipe",
        name = "artificial-grass-conversion-" .. badge_number,
        category = "crafting",
        enabled = false,
        energy_required = 1,
        icons = {
            { icon = "__space-age__/graphics/technology/artificial-soil.png",                    icon_size = 256, scale = 0.125, shift = { 0, 0 } },
            { icon = "__base__/graphics/icons/signal/signal_" .. badge_number .. ".png",         icon_size = 64,  scale = 0.2,   shift = { 8, -8 } },
            { icon = "__core__/graphics/icons/technology/constants/constant-movement-speed.png", icon_size = 128, scale = 0.25,  shift = { 4, 8 } },
        },
        ingredients = {
            { type = "item", name = "artificial-grass", amount = 10 },
        },
        results = {
            { type = "item", name = to_item, amount = 10 }
        },
        auto_recycle = false,
        allow_productivity = false,
        allow_quality = false,
        subgroup = "gardening-tiles",
        order = "a[artificial-grass]-c[" .. badge_number .. "]",
    }
end

-- Base tile & item (always present)
local artificial_grass_tile = create_artificial_grass_tile("grass-1", "artificial-grass", "")
local artificial_grass_item = create_artificial_grass_item("artificial-grass", "artificial-grass", nil)

data:extend({
    artificial_grass_tile,
    artificial_grass_item,
})

-- Grass variants settings
-- Known issue:removing them in a save replaces tiles with grass-1, if alien biomes is present which removes this tile, the tile_restrictions for seeds will not work
if settings.startup["enable-extended-grass-selection"] and settings.startup["enable-extended-grass-selection"].value then
    -- Variant 2
    local artificial_grass_2_tile = create_artificial_grass_tile("grass-1", "artificial-grass-2", "-2")
    artificial_grass_2_tile.variants = util.table.deepcopy(data.raw.tile["grass-2"].variants)

    local artificial_grass_2_item = create_artificial_grass_item("artificial-grass-2", "artificial-grass-2", "2")
    local artificial_grass_2_recipe = create_artificial_grass_conversion_recipe("artificial-grass-2", "2")

    -- Variant 3
    local artificial_grass_3_tile = create_artificial_grass_tile("grass-1", "artificial-grass-3", "-3")
    artificial_grass_3_tile.variants = util.table.deepcopy(data.raw.tile["grass-3"].variants)

    local artificial_grass_3_item = create_artificial_grass_item("artificial-grass-3", "artificial-grass-3", "3")
    local artificial_grass_3_recipe = create_artificial_grass_conversion_recipe("artificial-grass-3", "3")

    data:extend({
        artificial_grass_2_tile,
        artificial_grass_2_item,
        artificial_grass_2_recipe,
        artificial_grass_3_tile,
        artificial_grass_3_item,
        artificial_grass_3_recipe
    })
end