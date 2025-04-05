-- Update base-game wood processing subgroup
data.raw.recipe["wood-processing"].subgroup = "wood-processing"
data.raw.recipe["wood-processing"].order = "a[wood-processing]-a[base]"

-- Move base game tree-seed to custom subgroup and set order
data.raw.item["tree-seed"].subgroup = "seeds"
data.raw.item["tree-seed"].order = "a[base]"

-- Move Terrain from logistics to landscaping
--data.raw["item-subgroup"]["terrain"].group = "landscaping"