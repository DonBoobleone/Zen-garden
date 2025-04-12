--Category
require("__zen-garden__/prototypes/categories/recipe-category")
--Item-groups
require("__zen-garden__/prototypes/item-groups")
--Entity
require("__zen-garden__/prototypes/entity/zen-garden")
--Tile
require("__zen-garden__/prototypes/tile/tiles")
--Item
require("__zen-garden__/prototypes/item")
--Recipe
require("__zen-garden__/prototypes/recipe")
--Technology
require("__zen-garden__/prototypes/technology")

--Standalone /might be optionalised later
require("__zen-garden__/prototypes/standalone/zen-tree")
require("__zen-garden__/prototypes/standalone/zen-seed")

-- Behind Options
if settings.startup["charcoal-burning-enabled"].value then
    require("__zen-garden__/prototypes/standalone/charcoal-burning")
end