---@diagnostic disable: param-type-mismatch
local Mod = BirthcakeRebaked
local API = {}
BirthcakeRebaked.API = API

---Define a description, and optionally a name, for your character's Birthcake.
---@param playerType PlayerType
---@param desc string | table
---@param name? string | table
function API:AddBirthcakePickupText(playerType, desc, name)
	if type(desc) == "table" then
		Mod.BirthcakeDescriptions[playerType] = desc
	else
		Mod.BirthcakeDescriptions[playerType] = {
			en_us = desc
		}
	end
	if name then
		if type(name) == "table" then
			Mod.BirthcakeNames[playerType] = name
		else
			Mod.BirthcakeNames[playerType] = {
				en_us = name
			}
		end
	end
end

---Unique description that appears if Accurate Blurbs is enabled
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

---EID description for your character's birthcake
---@param playerType PlayerType
---@param desc string | table
function API:AddEIDDescription(playerType, desc)
	local descTable = desc
	if type(descTable) ~= "table" then
		descTable = {
			en_us = desc
		}
	end

	for language, descData in pairs(descTable) do
		if language:match('^_') or not Mod.EID.DynamicDescriptions:IsValidDescription(descData) then goto continue end -- skip helper private fields
		local newDesc = Mod.EID.DynamicDescriptions:MakeMinimizedDescription(descData)
		descTable[language] = newDesc
		::continue::
	end
	Mod.EID.Descs[playerType] = descTable
end