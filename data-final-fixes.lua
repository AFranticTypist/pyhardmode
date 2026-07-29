data.raw.technology["tar-processing"].ignore_tech_cost_multiplier = true
data.raw.technology["engine"].ignore_tech_cost_multiplier = true
data.raw.technology["ash-separation"].ignore_tech_cost_multiplier = true
data.raw.technology["concrete"].ignore_tech_cost_multiplier = true
data.raw.technology["crusher"].ignore_tech_cost_multiplier = true

for name, recipe in pairs(data.raw.recipe) do

	local is_incineration = false
	local is_runoff = false
	local is_venting = false
	
	if recipe.categories then
		for _, cat in pairs(recipe.categories) do
			if cat == "py-incineration" then is_incineration = true end
			if cat == "py-runoff" then is_runoff = true end
			if cat == "py-venting" then is_venting = true end
		end
	end

    if is_incineration or is_runoff then
        if name == "water-pyvoid-fluid" then
            recipe.energy_required = 20
        elseif name == "zipir1-pyvoid" or name == "zipir1-pyvoid-hatchery" then
            recipe.enabled = false
            recipe.categories = {"hpf"}
            recipe.flags = {}
            recipe.hidden = nil
        else
            data.raw.recipe[name] = nil
        end
    elseif is_venting then
        recipe.ingredients[1].amount = 50
        RECIPE(name):add_ingredient {name = "filtration-media", amount = 1, type = "item"}:add_unlock("filtration")
        data.raw.recipe[name].energy_required = 0.5
        recipe.enabled = false
        recipe.flags = {}
        recipe.hidden = nil
    end
end

if type(data.data_crawler) == "string" and string.sub(data.data_crawler, 1, 5) == "yafc " then
    data.script_enabled = data.script_enabled or {}
    table.insert(data.script_enabled, {
        type = "item",
        name = "burner-mining-drill",
    })
    table.insert(data.script_enabled, {
        type = "item",
        name = "offshore-pump",
    })
end

RECIPE("zipir1-pyvoid"):add_unlock("zipir")
