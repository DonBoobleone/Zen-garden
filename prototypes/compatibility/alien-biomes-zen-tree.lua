-- prototypes/compatibility/alien-biomes-zen-tree.lua
if not settings.startup["zen-trees-enabled"].value then return end

local util = require("util")

local trees_data = require('__alien-biomes__/prototypes/entity/tree-data')
local tree_models = require('__alien-biomes__/prototypes/entity/tree-models')

local tree_data_lookup = {}
for _, td in pairs(trees_data) do
    if td and td.name then
        tree_data_lookup[td.name] = td
    end
end

local function get_clean_zen_name(tree_proto, name)
    if tree_proto and tree_proto.localised_name then
        if type(tree_proto.localised_name) == "string" then
            -- trim trailing " Tree" / " tree" so we get clean base-style names
            -- e.g. "Cactuar Elder Tree" → "Cactuar Elder"
            return tree_proto.localised_name:gsub("%s*[Tt]ree%s*$", "")
        else
            return tree_proto.localised_name
        end
    end
    return name
end

local planting_box_shift = util.by_pixel(0, 9)

local planting_box_layer = {
    filename = "__zen-garden__/graphics/entity/planting-box/planting-box.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    direction_count = 1,
    shift = planting_box_shift,
    scale = 0.33
}

local planting_box_layer_shadow = {
    filename = "__zen-garden__/graphics/entity/planting-box/planting-box-shadow.png",
    priority = "extra-high",
    width = 512,
    height = 512,
    frame_count = 1,
    direction_count = 1,
    shift = planting_box_shift,
    scale = 0.33,
    draw_as_shadow = true
}

local function create_zen_tree_layers(variation, tint)
    local layers = {}
    if variation.shadow then
        local shadow = util.copy(variation.shadow)
        shadow.draw_as_shadow = true
        shadow.frame_count = 1
        table.insert(layers, shadow)
    end
    if variation.trunk then
        local trunk = util.copy(variation.trunk)
        trunk.frame_count = 1
        table.insert(layers, trunk)
    end
    if variation.leaves then
        local leaves = util.copy(variation.leaves)
        leaves.frame_count = 1
        leaves.tint = tint
        table.insert(layers, leaves)
    end
    return layers
end

local function create_alien_zen_tree_icons(tree_proto)
    if not tree_proto then return nil end

    local base_icons = tree_proto.icons or
        (tree_proto.icon and {{ icon = tree_proto.icon, icon_size = tree_proto.icon_size or 64 }})
    if not base_icons then return nil end

    local item_icons = {
        { icon = "__base__/graphics/icons/wooden-chest.png", icon_size = 64, scale = 0.5, shift = { 0, 8 } }
    }

    for _, layer in ipairs(base_icons) do
        local l = util.copy(layer)
        l.scale = (l.scale or 1) * 0.65
        local sx = (l.shift and l.shift[1]) or 0
        local sy = (l.shift and l.shift[2]) or 0
        l.shift = { sx, sy - 14 }
        table.insert(item_icons, l)
    end

    return item_icons
end

local function create_zen_tree_entity_from_tree(name, tree_proto, treedata, model_data)
    if not tree_proto or not tree_proto.variations or not tree_proto.variations[1] then
        return nil
    end

    local variation = tree_proto.variations[1]
    local tint = (tree_proto.colors and tree_proto.colors[1]) or { r = 1, g = 1, b = 1, a = 1 }

    local tree_layers = create_zen_tree_layers(variation, tint)
    local extra_layers = { planting_box_layer_shadow, planting_box_layer }

    for _, layer in ipairs(tree_layers) do
        local current = layer.shift or { 0, 0 }
        layer.shift = {
            (current[1] or 0) - planting_box_shift[1],
            (current[2] or 0) - planting_box_shift[2]
        }
    end

    for i, layer in ipairs(extra_layers) do
        table.insert(tree_layers, i, layer)
    end

    local icons = create_alien_zen_tree_icons(tree_proto)
    if not icons then return nil end

    local zen_name = "zen-tree-" .. name

    -- Always produce "Zen Tree - XXX" style (nice path or cleaned fallback)
    local localised_name = (treedata and model_data)
        and { "entity-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. model_data.locale } }
        or { "entity-name.zen-tree", get_clean_zen_name(tree_proto, name) }

    return {
        type = "assembling-machine",
        name = zen_name,
        icons = icons,
        icon_size = 64,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { mining_time = 0.2, result = zen_name },
        max_health = 100,
        corpse = "small-remnants",
        fast_replaceable_group = "zen-tree",
        resistances = { { type = "fire", percent = -50 } },
        collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
        selection_box = { { -1, -1 }, { 1, 1 } },
        graphics_set = {
            animation = { layers = tree_layers }
        },
        crafting_categories = { "gardening" },
        fixed_recipe = "zen-chi",
        show_recipe_icon = false,
        show_recipe_icon_on_map = false,
        crafting_speed = 1,
        energy_source = {
            type = "void",
            emissions_per_minute = { pollution = -0.06 }
        },
        energy_usage = "1kW",
        module_slots = nil,
        bottleneck_ignore = true,
        allowed_effects = {},
        localised_name = localised_name
    }
end

local function create_zen_tree_item_from_tree(name, tree_proto, treedata, model_data)
    local icons = create_alien_zen_tree_icons(tree_proto)
    if not icons then return nil end

    local zen_name = "zen-tree-" .. name

    -- Always produce "Zen Tree - XXX" style (nice path or cleaned fallback)
    local localised_name = (treedata and model_data)
        and { "item-name.zen-tree", { "alien-biomes." .. treedata.locale }, { "alien-biomes." .. model_data.locale } }
        or { "item-name.zen-tree", get_clean_zen_name(tree_proto, name) }

    return {
        type = "item",
        name = zen_name,
        icons = icons,
        subgroup = "gardening",
        order = "b[alien-zen]-" .. name,
        place_result = zen_name,
        stack_size = 50,
        localised_name = localised_name
    }
end

local function create_zen_tree_recipe(name)
    local zen_name = "zen-tree-" .. name
    local seed_name = use_basic_recipe and "tree-seed" or ("tree-seed-" .. name)

    return {
        type = "recipe",
        name = zen_name,
        categories = { "crafting" },
        energy_required = 1,
        enabled = false,
        ingredients = {
            { type = "item", name = "wooden-chest",     amount = 1 },
            { type = "item", name = "artificial-grass", amount = 1 },
            { type = "item", name = seed_name,          amount = 1 }
        },
        results = { { type = "item", name = zen_name, amount = 1 } }
    }
end

-- === Main Execution ===

local alien_entities = {}
local alien_items = {}
local alien_recipes = {}

for name, tree_proto in pairs(data.raw.tree) do
    if tree_proto.factoriopedia_alternative
        and name ~= "tree-01"
        and not string.match(name, "^tree%-0[0-9]$") then

        local treedata = tree_data_lookup[name]
        local model_data = treedata and tree_models[treedata.model]

        if treedata then   -- ← This is the key filter that skips the 6 bad trees
            local entity = create_zen_tree_entity_from_tree(name, tree_proto, treedata, model_data)
            if entity then
                table.insert(alien_entities, entity)

                local item = create_zen_tree_item_from_tree(name, tree_proto, treedata, model_data)
                if item then table.insert(alien_items, item) end

                local recipe = create_zen_tree_recipe(name)
                if recipe then table.insert(alien_recipes, recipe) end
            end
        end
    end
end

log("[zen-garden] Alien zen trees created: " .. #alien_entities)

if #alien_entities > 0 then
    data:extend(alien_entities)
    data:extend(alien_items)
    data:extend(alien_recipes)
end

if #alien_recipes > 0 then
    local effects = {}
    for _, recipe in ipairs(alien_recipes) do
        table.insert(effects, { type = "unlock-recipe", recipe = recipe.name })
    end

    data:extend({
        {
            type = "technology",
            name = "zen-gardening",
            icon = "__zen-garden__/graphics/technology/zen-gardening.png",
            icon_size = 256,
            effects = effects,
            prerequisites = { "composting" },
            unit = {
                count = 50,
                ingredients = {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack",   1 }
                },
                time = 30
            }
        }
    })
end