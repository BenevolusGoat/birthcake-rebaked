local Mod = BirthcakeRebaked
local API = {}
BirthcakeRebaked.API = API

---@param playerType PlayerType
---@param name string | table
---@param desc string | table
function API:AddBirthcakePickupText(playerType, name, desc)
	if type(name) == "table" then
		Mod.BirthcakeNames[playerType] = name
	else
		Mod.BirthcakeNames[playerType] = {
			en_us = name
		}
	end
	if type(desc) == "table" then
		Mod.BirthcakeDescriptions[playerType] = desc
	else
		Mod.BirthcakeDescriptions[playerType] = {
			en_us = desc
		}
	end
end

---@param playerType PlayerType
---@param desc string | table
function API:AddAccurateBlurbcake(playerType, desc)
	if type(desc) == "table" then
		Mod.BirthcakeAccurateBlurbs[playerType] = desc
	else
		Mod.BirthcakeAccurateBlurbs[playerType] = {
			en_us = desc
		}
	end
end