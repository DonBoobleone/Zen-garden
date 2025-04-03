--Category
require("__zen-garden__/prototypes/categories/recipe-category")
--Item-groups
require("__zen-garden__/prototypes/item-groups")
--Technology
require("__zen-garden__/prototypes/technology")

--Standalone /might be optionalised later
require("__zen-garden__/prototypes/standalone/artificial-grass")
require("__zen-garden__/prototypes/standalone/zen-tree")
require("__zen-garden__/prototypes/standalone/zen-seed")
require("__zen-garden__/prototypes/standalone/zen-garden")
require("__zen-garden__/prototypes/standalone/gear-garden")

-- Behind Options
if settings.startup["charcoal-burning-enabled"].value then
    require("__zen-garden__/prototypes/standalone/charcoal-burning")
end