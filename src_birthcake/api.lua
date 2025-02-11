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

---Define a description, and optionally a name, for your character's Birthcake. Having a description will prevent the mod from applying its "default effect" of an all stats up
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
---@param nonTaintedPlayerType? PlayerType #Define the normal-side character associated with this character. Used for the "Default name" option for Tainted name pickup text. REPENTOGON detects this automatically, but is needed for non-RGON. If for some reason there's a default name that isn't identical to the normal name, you can always use the GET_BIRTHCAKE_ITEMTEXT_NAME callback
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

---spriteInfo is a table with variables.
---
---SpritePath is required, a string filepath to your Birthcake png
---
---PickupSpritePath is optional, a string filepath to your Birthcake png only in pickup form
---
---Anm2 is optional, a string filepath to an anm2 file if you want it to be animated. Must copy the Trinket anm2
---@param playerType PlayerType
---@param spriteInfo BirthcakeSprite
function API:AddBirthcakeSprite(playerType, spriteInfo)
	Mod.BirthcakeSprite[playerType] = spriteInfo
end

---Unique description that appears if Accurate Blurbs is enabled
---@param playerType PlayerType
---@param desc string | table
function API:AddAccurateBlurbcake(playerType, desc)
	assignText("BirthcakeAccurateBlurbs", playerType, desc)
end

---EID description for your character's birthcake
---
---You can follow the "if not table" example below or the existing descriptions in the compatibility/patches/eid.lua file to learn how to make a description
---
---You cannot re-use the same description as it directly modifies it for later. Use API:ShareEIDDescription instead
---@param playerType PlayerType
---@param desc string | table
function API:AddEIDDescription(playerType, desc)
	local descTable = desc
	if type(descTable) ~= "table" then
		descTable = {
			en_us = {desc}
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

---For any PlayerTypes that have an identical description to another. This will prevent it rendering twice if both characters are present
---@param playerType PlayerType #The PlayerType that copies from the other
---@param parentPlayerType PlayerType #The PlayerType to copy from
function API:ShareEIDDescription(playerType, parentPlayerType)
	Mod.EID.SHARED_DESCRIPTIONS[playerType] = parentPlayerType
end