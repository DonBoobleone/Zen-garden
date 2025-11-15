-- zen-bonsai-variations.lua
local util = require("util")
local function create_variation(index)
    local formatted_index = string.format("%02d", index)
    local base_path = "__zen-garden__/graphics/entity/bonsai-tree/zen-bonsai-tree-"
    local png_suffix = ".png"
    local shadow_suffix = "-shadow.png"
    local reflection_suffix = "-reflection.png"
    return {
        leaf_generation = {
            type = "create-particle",
            particle_name = "leaf-particle",
            offset_deviation = { { -0.3, -0.3 }, { 0.3, 0.3 } },
            initial_height = 1,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.01,
            initial_vertical_speed_deviation = 0.02,
            speed_from_center = 0.02,
            speed_from_center_deviation = 0.03
        },
        branch_generation = {
            type = "create-particle",
            particle_name = "branch-particle",
            offset_deviation = { { -0.3, -0.3 }, { 0.3, 0.3 } },
            initial_height = 1,
            initial_height_deviation = 0.5,
            initial_vertical_speed = 0.01,
            initial_vertical_speed_deviation = 0.02,
            speed_from_center = 0.02,
            speed_from_center_deviation = 0.03,
            frame_speed = 0.5,
            frame_speed_deviation = 0.5
        },
        leaves_when_damaged = 100,
        leaves_when_destroyed = 35,
        leaves_when_mined_manually = 40,
        leaves_when_mined_automatically = 16,
        branches_when_damaged = 20,
        branches_when_destroyed = 16,
        branches_when_mined_manually = 15,
        branches_when_mined_automatically = 8,
        trunk = {
            filename = base_path .. formatted_index .. png_suffix,
            width = 384,
            height = 384,
            frame_count = 1,
            line_length = 1,
            shift = util.by_pixel(0, -32),
            scale = 0.5,
            priority = "extra-high"
        },
        leaves = {
            filename = base_path .. formatted_index .. png_suffix,
            width = 384,
            height = 384,
            frame_count = 1,
            line_length = 1,
            shift = util.by_pixel(0, -32),
            scale = 0.5,
            priority = "extra-high"
        },
        shadow = {
            filename = base_path .. formatted_index .. shadow_suffix,
            width = 384,
            height = 384,
            frame_count = 2,
            flags = { "mipmap", "shadow" },
            shift = util.by_pixel(0, -32),
            draw_as_shadow = true,
            scale = 0.5,
        },
        normal = nil,
        water_reflection = {
            pictures = {
                filename = base_path .. formatted_index .. reflection_suffix,
                width = 384,
                height = 384,
                scale = 0.5,
                shift = util.by_pixel(16, 0),
                variation_count = 1,
            },
            rotate = false,
            orientation_to_variation = false,
        }
    }
end
local total_variations = 11 -- Increase this to add more variations;
local variations = {}
for i = 1, total_variations do
    table.insert(variations, create_variation(i))
end
return variations
