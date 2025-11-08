
require("control")


local organic_centrifuging_category = {
	type = "recipe-category",
	name = "organic-or-centrifuging",
}

local bacteria_processes_subgroup = {
	group = "intermediate-products",
	name = "gleba-reborn-bacteria-processes",
	order = "mz", -- Display right before agriculture-processes which has order "n"
	type = "item-subgroup"
}

local bacteria_extrusion_iron = {
	type = "recipe",
	name = "gleba-reborn-iron-bacteria-extrusion",
	category = "organic",
	subgroup = "gleba-reborn-bacteria-processes",
	order = "f[bacteria]-a[bacteria]-a[iron]",
	icon = "__gleba-reborn__/graphics/icons/iron-bacteria-extrusion.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_machine_tint = {
		primary = {
			r = 101,
			g = 67,
			b = 33,
			a = 255,
		},
	},
	ingredients = {
		{ type = "item", name = "iron-bacteria", amount = 1 },
	},
	results = {
		{ type = "item", name = "iron-plate", amount = 1 },
	},
	energy_required = 2,
	enabled = false,
	allow_productivity = true,
}

local bacteria_extrusion_copper = {
	type = "recipe",
	name = "gleba-reborn-copper-bacteria-extrusion",
	category = "organic",
	subgroup = "gleba-reborn-bacteria-processes",
	order = "f[bacteria]-a[bacteria]-b[copper]",
	icon = "__gleba-reborn__/graphics/icons/copper-bacteria-extrusion.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_machine_tint = {
		primary = {
			r = 101,
			g = 67,
			b = 33,
			a = 255,
		},
	},
	ingredients = {
		{ type = "item", name = "copper-bacteria", amount = 1 },
	},
	results = {
		{ type = "item", name = "copper-plate", amount = 1 },
	},
	energy_required = 2,
	enabled = false,
	allow_productivity = true,
}

local bacteria_extrusion_steel = {
	type = "recipe",
	name = "gleba-reborn-steel-bacteria-extrusion",
	category = "organic",
	subgroup = "gleba-reborn-bacteria-processes",
	order = "f[bacteria]-a[bacteria]-c[steel]",
	icon = "__gleba-reborn__/graphics/icons/steel-bacteria-extrusion.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_machine_tint = {
		primary = {
			r = 101,
			g = 67,
			b = 33,
			a = 255,
		},
	},
	ingredients = {
		{ type = "item", name = "iron-bacteria", amount = 2 },
		{ type = "item", name = "bioflux", amount = 1 },
	},
	results = {
		{ type = "item", name = "steel-plate", amount = 2 },
	},
	energy_required = 8,
	enabled = false,
	allow_productivity = true,
}

local bacteria_extrusion_circuit = {
	type = "recipe",
	name = "gleba-reborn-circuit-bacteria-extrusion",
	category = "organic",
	subgroup = "gleba-reborn-bacteria-processes",
	order = "f[bacteria]-a[bacteria]-d[circuit]",
	icon = "__gleba-reborn__/graphics/icons/circuit-bacteria-extrusion.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_machine_tint = {
		primary = {
			r = 101,
			g = 67,
			b = 33,
			a = 255,
		},
	},
	ingredients = {
		{ type = "item", name = "iron-bacteria", amount = 1 },
		{ type = "item", name = "copper-bacteria", amount = 1 },
		{ type = "item", name = "bioflux", amount = 1 },
	},
	results = {
		{ type = "item", name = "electronic-circuit", amount = 4 },
	},
	energy_required = 2,
	enabled = false,
	allow_productivity = true,
	show_amount_in_title = true,
}

local bioexplosives = {
	type = "recipe",
	name = "gleba-reborn-bioexplosives",
	category = "organic",
	subgroup = "agriculture-products",
	order = "a[organic-products]-e[bioexplosives]",
	icon = "__gleba-reborn__/graphics/icons/bioexplosive.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_machine_tint = {
		primary = {
			a = 1,
			b = 0.31000000000000001,
			g = 0.006,
			r = 0.97599999999999998
		},
		secondary = {
			a = 1,
			b = 0.29299999999999997,
			g = 0.70099999999999998,
			r = 0.80500000000000007
		}
	},
	ingredients = {
		{ type = "item", name = "sulfur", amount = 1 },
		{ type = "item", name = "bioflux", amount = 1 },
	},
	results = {
		{ type = "item", name = "explosives", amount = 5 },
	},
	energy_required = 4,
	enabled = false,
	allow_productivity = true,
	show_amount_in_title = true,
}

local synthetic_nutrients = {
	type = "recipe",
	name = "gleba-reborn-synthetic-nutrients",
	category = "organic-or-chemistry",
	subgroup = "agriculture-processes",
	order = "c[nutrients]-c[synthetic-nutrients]",
	icon = "__gleba-reborn__/graphics/icons/synthetic-nutrients.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_machine_tint = {
		primary = {
			a = 1,
			b = 1,
			g = 0.9,
			r = 0.8
		},
		secondary = {
			a = 1,
			b = 0.8,
			g = 0.5,
			r = 0.5
		}
	},
	ingredients = {
		{ type = "item", name = "sulfur", amount = 1 },
		{ type = "item", name = "carbon", amount = 1 },
		{ type = "fluid", name = "water", amount = 10 },
	},
	results = {
		{ type = "item", name = "nutrients", amount = 4 },
	},
	energy_required = 3,
	enabled = false,
	allow_productivity = true,
	show_amount_in_title = true,
}


data:extend {
	organic_centrifuging_category,
	bacteria_processes_subgroup,
	bacteria_extrusion_iron,
	bacteria_extrusion_copper,
	bacteria_extrusion_steel,
	bacteria_extrusion_circuit,
	bioexplosives,
	synthetic_nutrients,
}

