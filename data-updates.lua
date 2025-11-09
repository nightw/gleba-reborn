
require("util")
require("prototypes/recipes")
require("control")


if settings.startup["gleba-reborn-egg-free-biochamber"].value then
	-- Update biochamber recipe
	update_recipe("biochamber", "nutrients", "yumako-mash", 10)
	update_recipe("biochamber", "pentapod-egg", "jelly", 10)
	
	-- Since biochamber recipe won't require nutrients, we unlock it by crafting yumako mash instead
	local biochamber_tech = data.raw.technology["biochamber"]
	biochamber_tech.research_trigger = {
		count = 1,
		item = "yumako-mash",
		type = "craft-item"
	}
end

if settings.startup["gleba-reborn-advanced-bacteria-recipes"].value then
	-- Add new recipes
	table.insert(data.raw.technology["biochamber"].effects, { type = "unlock-recipe", recipe = "gleba-reborn-iron-bacteria-extrusion" })
	table.insert(data.raw.technology["biochamber"].effects, { type = "unlock-recipe", recipe = "gleba-reborn-copper-bacteria-extrusion" })
	table.insert(data.raw.technology["bioflux-processing"].effects, { type = "unlock-recipe", recipe = "gleba-reborn-circuit-bacteria-extrusion" })
	table.insert(data.raw.technology["bioflux-processing"].effects, { type = "unlock-recipe", recipe = "gleba-reborn-steel-bacteria-extrusion" })
	table.insert(data.raw.technology["bioflux-processing"].effects, { type = "unlock-recipe", recipe = "gleba-reborn-bioexplosives" })
	table.insert(data.raw.technology["steel-plate-productivity"].effects, { change = 0.1, recipe = "gleba-reborn-steel-bacteria-extrusion", type = "change-recipe-productivity" })
	
	-- Add new subgroup to put all the bacteria recipes on their own line in the crafting recipe menu
	data.raw.recipe["iron-bacteria"].subgroup = "gleba-reborn-bacteria-processes"
	data.raw.recipe["copper-bacteria"].subgroup = "gleba-reborn-bacteria-processes"
	data.raw.recipe["iron-bacteria-cultivation"].subgroup = "gleba-reborn-bacteria-processes"
	data.raw.recipe["copper-bacteria-cultivation"].subgroup = "gleba-reborn-bacteria-processes"
	
	-- Move biolubricant recipe from bioflux processing to biochamber, since the recipe doesn't require bioflux
	table.insert(data.raw.technology["biochamber"].effects, { type = "unlock-recipe", recipe = "biolubricant" })
	local bioflux_processing_tech = data.raw.technology["bioflux-processing"]
	for i,effect in pairs(bioflux_processing_tech.effects) do
		if effect.recipe == "biolubricant" then
			table.remove(bioflux_processing_tech.effects, i)
			break
		end
	end
end

if settings.startup["gleba-reborn-useful-wood-fish"].value then
	-- Fish breeding
	update_recipe("fish-breeding", "nutrients", "tree-seed", 2)
	
	local fish_breeding = data.raw.technology["fish-breeding"]
	fish_breeding.unit = nil
	fish_breeding.research_trigger = {
		count = 1,
		item = "tree-seed",
		type = "craft-item"
	}

	-- Tree seeding
	local tree_seeding = data.raw.technology["tree-seeding"]
	tree_seeding.prerequisites = { "biochamber" }
	tree_seeding.unit = nil
	tree_seeding.research_trigger = {
		count = 25,
		item = "biochamber",
		type = "craft-item"
	}
	
	-- 250 seeds per rocket
	data.raw.item["tree-seed"].weight = 4000
	data.raw.item["jellynut-seed"].weight = 4000
	data.raw.item["yumako-seed"].weight = 4000
end

if settings.startup["gleba-reborn-extra-biochamber-recipes"].value then
	-- New crafting category for recipes that can be made in both the biochamber and the centrifuge
	table.insert(data.raw["assembling-machine"]["biochamber"].crafting_categories, "organic-or-centrifuging")
	table.insert(data.raw["assembling-machine"]["centrifuge"].crafting_categories, "organic-or-centrifuging")
	
	table.insert(data.raw.technology["biochamber"].effects, { type = "unlock-recipe", recipe = "gleba-reborn-synthetic-nutrients" })
	
	set_recipe_category("ice-melting", "organic-or-chemistry")
	set_recipe_category("thruster-fuel", "organic-or-chemistry")
	set_recipe_category("thruster-oxidizer", "organic-or-chemistry")
	set_recipe_category("advanced-thruster-fuel", "organic-or-chemistry")
	set_recipe_category("advanced-thruster-oxidizer", "organic-or-chemistry")
	set_recipe_category("solid-fuel-from-heavy-oil", "organic-or-chemistry")
	set_recipe_category("solid-fuel-from-light-oil", "organic-or-chemistry")
	set_recipe_category("solid-fuel-from-petroleum-gas", "organic-or-chemistry")
	set_recipe_category("lubricant", "organic-or-chemistry")
	set_recipe_category("biolab", "organic")
	set_recipe_category("uranium-processing", "organic-or-centrifuging")
	set_recipe_category("kovarex-enrichment-process", "organic-or-centrifuging")
	set_recipe_category("nuclear-fuel", "organic-or-centrifuging")
end

if settings.startup["gleba-reborn-hungry-biolab"].value then
	data.raw.lab.biolab.energy_source = {
		burner_usage = "nutrients",
		effectivity = 1,
		emissions_per_minute = {
			pollution = -1
		},
		fuel_categories = {
			"nutrients"
		},
		fuel_inventory_size = 1,
		type = "burner"
	}
end

if settings.startup["gleba-reborn-less-enemies"].value then
	local less_enemies_setting = settings.startup["gleba-reborn-less-enemies"].value
	if less_enemies_setting ~= "normal" then
		local pentapod_spawns = data.raw["unit-spawner"]["gleba-spawner"].result_units
		if settings.startup["gleba-reborn-less-enemies"].value == "start" then
			update_enemy_spawns(pentapod_spawns, pentapod_spawns_start_less)
		elseif settings.startup["gleba-reborn-less-enemies"].value == "always" then
			update_enemy_spawns(pentapod_spawns, pentapod_spawns_always_less)
		end
	end
end

if settings.startup["gleba-reborn-nutrient-spoil-time"].value then
	set_item_spoil_time("nutrients", settings.startup["gleba-reborn-nutrient-spoil-time"].value)
end

if settings.startup["gleba-reborn-bacteria-spoilage"].value then
	set_item_spoil_result("iron-bacteria", "spoilage")
	set_item_spoil_result("copper-bacteria", "spoilage")
end

if settings.startup["gleba-reborn-bacteria-spoil-time"].value then
	set_item_spoil_time("iron-bacteria", settings.startup["gleba-reborn-bacteria-spoil-time"].value)
	set_item_spoil_time("copper-bacteria", settings.startup["gleba-reborn-bacteria-spoil-time"].value)
end

if settings.startup["gleba-reborn-science-spoil-time"].value then
	set_item_spoil_time("agricultural-science-pack", settings.startup["gleba-reborn-science-spoil-time"].value)
end




