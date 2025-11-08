
require("util")
require("prototypes/recipes")



-- Compatibility fixes

if mods["bobassembly"] and bobmods then
	bobmods.lib.machine.copy_categories_from("assembling-machine", "centrifuge", "bob-centrifuge-2")
	bobmods.lib.machine.copy_categories_from("assembling-machine", "centrifuge", "bob-centrifuge-3")
end

if mods["Age-of-Production"] then
	data.raw.recipe["gleba-reborn-iron-bacteria-extrusion"].category = "biochemistry-or-organic"
	data.raw.recipe["gleba-reborn-copper-bacteria-extrusion"].category = "biochemistry-or-organic"
	data.raw.recipe["gleba-reborn-steel-bacteria-extrusion"].category = "biochemistry-or-organic"
	data.raw.recipe["gleba-reborn-circuit-bacteria-extrusion"].category = "biochemistry-or-organic"
	data.raw.recipe["gleba-reborn-bioexplosives"].category = "biochemistry-or-organic"
end