---@diagnostic disable: param-type-mismatch
local Mod = BirthcakeRebaked
local API = {}
BirthcakeRebaked.API = API

local function assignText(tableName, playerType, tableOrString)
	if type(playerType) ~= "number" then
		error("[Birthcake: Rebaked]: Error: Provided PlayerType \"" .. playerType .. "\" type " .. type(playerType) .. "is not valid!")
	end
	if type(tableOrString) == "table" then
		Mod[tableName][playerType] = tableOrString
	elseif type(tableOrString) == "string" then
		Mod[tableName][playerType] = {
			en_us = tableOrString
		}
	else
		error("[Birthcake: Rebaked]: Error: Provided text \"" .. tableOrString .. "\" type " .. type(tableOrString) .. "is not valid!")
	end
end

---Define a description, and optionally a name, for your character's Birthcake.
---
---Keep in mind that for names, they're said as "Name's" rather than "Name" as to append "Cake" automatically
---@param playerType PlayerType
---@param desc string | table
---@param name? string | table
function API:AddBirthcakePickupText(playerType, desc, name)
	assignText("BirthcakeDescriptions", playerType, desc)
	if name then
		assignText("BirthcakeNames", playerType, name)
	end
end

---Define a description, and optionally a name, for your character's Birthcake.
---
---Keep in mind that for names, they're said as "Name's" rather than "Name" as to append "Cake" automatically.
---@param playerType PlayerType
---@param desc string | table
---@param nonTaintedPlayerType? PlayerType #Define the normal-side character associated with this character. Used for the "Default name" option for Tainted name pickup text. REPENTOGON detects this automatically, but is needed for non-RGON
---@param name? string | table #Have "Tainted" included in the name by default, if accurate. Used for the "Tainted prefix" option for Tainted name pickup text
---@param taintedTitle? string | table #Used for the "Tainted Title" option for Tainted name pickup text (i.e. "The Broken's")
function API:AddTaintedBirthcakePickupText(playerType, desc, nonTaintedPlayerType, name, taintedTitle)
	assignText("BirthcakeDescriptions", playerType, desc)
	if nonTaintedPlayerType then
		Mod.TaintedToNormal[playerType] = nonTaintedPlayerType
	end
	if name then
		assignText("BirthcakeNames", playerType, name)
	end
	if taintedTitle then
		assignText("BirthcakeTaintedTitle", playerType, name)
	end
end

---@param playerType PlayerType
---@param spriteInfo BirthcakeSprite
function API:AddBirthcakeSprite(playerType, spriteInfo)
	Mod.BirthcakeSprite[playerType] = spriteInfo
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