-- artificial-grass.lua
local item_sounds = require("__base__.prototypes.item_sounds")

-- Tile definition
local artificial_grass_tile = util.table.deepcopy(data.raw["tile"]["grass-1"])
artificial_grass_tile.name = "artificial-grass"
artificial_grass_tile.minable = { mining_time = 0.5, result = "artificial-grass" }
artificial_grass_tile.mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.8 }
artificial_grass_tile.map_color = { r = 55 / 255, g = 69 / 255, b = 11 / 255 }
artificial_grass_tile.is_foundation = true
artificial_grass_tile.layer_group = "ground-artificial"
artificial_grass_tile.subgroup = "gardening-tiles"
artificial_grass_tile.order = "a[artificial]-d[utility]-a[grass]"
artificial_grass_tile.decorative_removal_probability = 0.5
artificial_grass_tile.collision_mask = data.raw["tile"]["landfill"].collision_mask
artificial_grass_tile.check_collision_with_entities = true

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

local artificial_grass_item = {
        type = "item",
        name = "artificial-grass",
        icon = "__space-age__/graphics/technology/artificial-soil.png",
        icon_size = 256,
        subgroup = "gardening-tiles",
        order = "a[artificial-grass]",
        inventory_move_sound = item_sounds.landfill_inventory_move,
        pick_sound = item_sounds.landfill_inventory_pickup,
        drop_sound = item_sounds.landfill_inventory_move,
        stack_size = 100,
        weight = 10 * kg,
        auto_recycle = true,
        default_import_location = "nauvis",
        place_as_tile =
        {
            result = "artificial-grass",
            condition_size = 1,
            condition = { layers = { lava_tile = true, empty_space = true, out_of_map = true } }, -- this excludes anything with collision layer set to true
            tile_condition = create_list_of_nauvis_and_gleba_tiles()                              -- This is an inclusive list of all allowed tiles
        }
    }

data:extend({ artificial_grass_tile, artificial_grass_item })