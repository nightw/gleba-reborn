
require("util")


local RECYCLING_FRACTION = 0.25  -- Fixed recycling return rate from Factorio (hardcoded in game data)

local one_minute_ticks = 3600
local spoil_times = {
	["1-min"] = one_minute_ticks,
	["2-min"] = 2 * one_minute_ticks,
	["3-min"] = 3 * one_minute_ticks,
	["5-min"] = 5 * one_minute_ticks,
	["10-min"] = 10 * one_minute_ticks,
	["15-min"] = 15 * one_minute_ticks,
	["30-min"] = 30 * one_minute_ticks,
	["45-min"] = 45 * one_minute_ticks,
	["1-hr"] = 60 * one_minute_ticks,
	["2-hr"] = 120 * one_minute_ticks,
	["never"] = "never"
}

-- vanilla result-units = {
--	{ "small-wriggler-pentapod", {{ 0, 0.4 }, { 0.1, 0.4 }, { 0.6, 0 }} },
--	{ "small-strafer-pentapod", {{ 0, 0.4 }, { 0.1, 0.4 }, { 0.6, 0 }} },
--	{ "small-stomper-pentapod", {{ 0, 0.2 }, { 0.1, 0.2 }, { 0.6, 0 }} },
--	{ "medium-wriggler-pentapod", {{ 0.1, 0 }, { 0.6, 0.4 }, { 0.95, 0 }} },
--	{ "medium-strafer-pentapod", {{ 0.1, 0 }, { 0.6, 0.4 }, { 0.95, 0 }} },
--	{ "medium-stomper-pentapod", {{ 0.1, 0 }, { 0.6, 0.2 }, { 0.95, 0 }} },
--	{ "big-wriggler-pentapod", {{ 0.6, 0 }, { 0.95, 0.4 }, { 1, 0.4 }} },
--	{ "big-strafer-pentapod", {{ 0.6, 0 }, { 0.95, 0.4 }, { 1, 0.4 }} },
--	{ "big-stomper-pentapod", {{ 0.6, 0 }, { 0.95, 0.2 }, { 1, 0.2 }} }
-- }

pentapod_spawns_start_less = {
	["small-wriggler-pentapod"] =	{ "small-wriggler-pentapod", {{ 0, 0.85 }, { 0.1, 0.85 }, { 0.6, 0 }} },
	["small-strafer-pentapod"] =	{ "small-strafer-pentapod", {{ 0, 0.1 }, { 0.1, 0.1 }, { 0.6, 0 }} },
	["small-stomper-pentapod"] =	{ "small-stomper-pentapod", {{ 0, 0.05 }, { 0.1, 0.05 }, { 0.6, 0 }} },
	["medium-wriggler-pentapod"] =	{ "medium-wriggler-pentapod", {{ 0.1, 0 }, { 0.6, 0.4 }, { 0.95, 0 } }},
	["medium-strafer-pentapod"] =	{ "medium-strafer-pentapod", {{ 0.1, 0 }, { 0.6, 0.4 }, { 0.95, 0 } }},
	["medium-stomper-pentapod"] =	{ "medium-stomper-pentapod", {{ 0.1, 0 }, { 0.6, 0.2 }, { 0.95, 0 } }},
	["big-wriggler-pentapod"] =		{ "big-wriggler-pentapod", {{ 0.6, 0 }, { 0.95, 0.4 }, { 1, 0.4 }} },
	["big-strafer-pentapod"] =		{ "big-strafer-pentapod", {{ 0.6, 0 }, { 0.95, 0.4 }, { 1, 0.4 }} },
	["big-stomper-pentapod"] =		{ "big-stomper-pentapod", {{ 0.6, 0 }, { 0.95, 0.2 }, { 1, 0.2 }} }
}

pentapod_spawns_always_less = {
	["small-wriggler-pentapod"] =	{ "small-wriggler-pentapod", {{ 0, 0.85 }, { 0.1, 0.85 }, { 0.6, 0 }} },
	["small-strafer-pentapod"] =	{ "small-strafer-pentapod", {{ 0, 0.1 }, { 0.1, 0.1 }, { 0.6, 0 }} },
	["small-stomper-pentapod"] =	{ "small-stomper-pentapod", {{ 0, 0.05 }, { 0.1, 0.05 }, { 0.6, 0 }} },
	["medium-wriggler-pentapod"] =	{ "medium-wriggler-pentapod", {{ 0.1, 0 }, { 0.6, 0.85 }, { 0.95, 0 }} },
	["medium-strafer-pentapod"] =	{ "medium-strafer-pentapod", {{ 0.1, 0 }, { 0.6, 0.1 }, { 0.95, 0 }} },
	["medium-stomper-pentapod"] =	{ "medium-stomper-pentapod", {{ 0.1, 0 }, { 0.6, 0.05 }, { 0.95, 0 }} },
	["big-wriggler-pentapod"] =		{ "big-wriggler-pentapod", {{ 0.6, 0 }, { 0.95, 0.85 }, { 1, 0.85 }} },
	["big-strafer-pentapod"] =		{ "big-strafer-pentapod", {{ 0.6, 0 }, { 0.95, 0.1 }, { 1, 0.1 }} },
	["big-stomper-pentapod"] =		{ "big-stomper-pentapod", {{ 0.6, 0 }, { 0.95, 0.05 }, { 1, 0.1 }} }
}


-----------------------
-- Utility Functions --
-----------------------


local function compatible_name(name)
	return "gleba-reborn-compatable-" .. name
end

local function check_replace_ingredient(ingredient, old_ingredient, new_ingredient, new_amount)
	if ingredient.name then
		if ingredient.name == old_ingredient then
			ingredient.name = new_ingredient
			ingredient.amount = new_amount
		end
	elseif ingredient[1] == old_ingredient then
		ingredient[1] = new_ingredient
	end
end

local function check_remove_ingredient(ingredients, i, ingredient, old_ingredient)
	if ingredient.name then
		if ingredient.name == old_ingredient then
			table.remove(ingredients, i)
		end
	elseif ingredient[1] == old_ingredient then
		table.remove(ingredient, 1)
	end
end

local function update_ingredient(ingredients, old_ingredient, new_ingredient, new_amount)
	for i,ingredient in pairs(ingredients) do
		if new_amount == 0 then
			check_remove_ingredient(ingredients, i, ingredient, old_ingredient)
		else
			check_replace_ingredient(ingredient, old_ingredient, new_ingredient, new_amount)
		end
	end
end

local function update_recycling_recipe(recipe, old_ingredient, new_ingredient, new_amount)
	-- Thanks to tabr for the help with this fix!
	local recycling_name = recipe .. "-recycling"
	local recycling_recipe = data.raw.recipe[recycling_name]
	if recycling_recipe and recycling_recipe.results then
		update_ingredient(recycling_recipe.results, old_ingredient, new_ingredient, (new_amount * RECYCLING_FRACTION))
	end
end


----------------------
-- Shared Functions --
----------------------


function set_item_spoil_time(item_name, new_spoil_time)
	for _,category in pairs({"item", "tool"}) do
		local item = data.raw[category][item_name]
		if item and spoil_times[new_spoil_time] then
			if spoil_times[new_spoil_time] == "never" then
				item.spoil_ticks = nil
				item.spoil_result = nil
			else
				item.spoil_ticks = spoil_times[new_spoil_time]
			end
		end
	end
end

function set_item_spoil_result(item_name, new_spoil_result)
	for _,category in pairs({"item", "tool"}) do
		local item = data.raw[category][item_name]
		if item then
			item.spoil_result = new_spoil_result
		end
	end
end

function update_recipe(recipe, old_ingredient, new_ingredient, new_amount)
	local recipe_name = recipe
	if settings.startup["gleba-reborn-compatability-mode"].value then
		recipe_name = compatible_name(recipe)
		
		if not data.raw.recipe[recipe_name] then
			local new_recipe = util.table.deepcopy(data.raw.recipe[recipe])
			new_recipe.name = recipe_name
			data.raw.recipe[recipe_name] = new_recipe
			if data.raw.technology[old_recipe] then
				table.insert(data.raw.technology[old_recipe].effects, { type = "unlock-recipe", recipe = recipe_name })
			end
		end
	end
	
	if data.raw.recipe[recipe_name].ingredients then
		update_ingredient(data.raw.recipe[recipe_name].ingredients, old_ingredient, new_ingredient, new_amount)
	end
	if data.raw.recipe[recipe_name].normal then
		update_ingredient(data.raw.recipe[recipe_name].normal.ingredients, old_ingredient, new_ingredient, new_amount)
	end
	if data.raw.recipe[recipe_name].expensive then
		update_ingredient(data.raw.recipe[recipe_name].expensive.ingredients, old_ingredient, new_ingredient, new_amount)
	end
	
	-- This always uses the original recipe name, not the compatible name
	update_recycling_recipe(recipe, old_ingredient, new_ingredient, new_amount)
end

function set_recipe_category(recipe, new_category)
	if data.raw.recipe[recipe] then
		data.raw.recipe[recipe].category = new_category
	end
end

function update_enemy_spawns(enemy_spawns, replacement_spawns)
	for i,spawn in pairs(enemy_spawns) do
		local enemy_name = spawn[1]
		if replacement_spawns[enemy_name] then
			enemy_spawns[i] = replacement_spawns[enemy_name]
		end
	end
end

function update_result_probability(recipe_name, result_name, new_probability)
	local recipe = data.raw.recipe[recipe_name]
	if recipe and recipe.results then
		for _,result in pairs(recipe.results) do
			if result.name == result_name then
				result.probability = new_probability
			end
		end
	end
end



