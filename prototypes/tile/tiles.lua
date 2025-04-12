local util = require('util')


-- Create artificial-grass based on grass-1
local artificial_grass = util.table.deepcopy(data.raw["tile"]["grass-1"])
artificial_grass.name = "artificial-grass"
artificial_grass.minable = { mining_time = 0.5, result = "artificial-grass" }
artificial_grass.mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.8 }
artificial_grass.map_color = { r = 55 / 255, g = 69 / 255, b = 11 / 255 }
artificial_grass.is_foundation = true
artificial_grass.subgroup = "gardening-tiles"
artificial_grass.order = "a[artificial]-d[utility]-a[grass]"

data:extend({ artificial_grass })