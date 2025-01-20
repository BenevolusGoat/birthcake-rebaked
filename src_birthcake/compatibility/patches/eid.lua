--Huge credit to Epiphany for this fluid EID support
local Mod = BirthcakeRebaked
local game = Mod.Game

local BIRTHCAKE_EID = {}
BirthcakeRebaked.EID = BIRTHCAKE_EID

function BIRTHCAKE_EID:ClosestPlayerTo(entity) --This seems to error for some people sooo yeah
	if not entity then return EID.player end

	if EID.ClosestPlayerTo then
		return EID:ClosestPlayerTo(entity)
	else
		return EID.player
	end
end

--#region Helper functions

---@function
function BIRTHCAKE_EID:GetTranslatedString(strTable)
	local lang = EID.getLanguage() or "en_us"
	--Default to english description if there's no translation
	local desc = strTable[lang] or strTable["en_us"]

	--Default to english if the corresponding translation doesn't exist and is blank
	if desc == '' then
		desc = strTable["en_us"];
	end

	return desc
end

--#endregion

--#region Changing mod's name and indicator for EID

EID._currentMod = Mod.Name
EID:setModIndicatorName(Mod.Name)
local birthcakeModSprite = Sprite()
birthcakeModSprite:Load("gfx/ui/eid_birthcake_icon.anm2", true)
EID:addIcon("Birthcake: Rebaked ModIcon", "Idle", 0, 10, 11, 5, 5, birthcakeModSprite)
EID:setModIndicatorIcon("Birthcake: Rebaked ModIcon")

--#endregion

--#region Icons

--#endregion

--#region Snipped Dynamic Description stuff from Epiphany

local DD = {} ---@class DynamicDescriptions

-- concat all subsequent string elements of a dynamic description
-- into one string so we have to concat less stuff at runtime
--
-- this is very much a micro optimization but at worst it does nothing
---@param desc (string | function)[] | function
---@return (string | function)[]
function DD:MakeMinimizedDescription(desc)
	if type(desc) == "function" then
		return { desc }
	end

	local out = {}
	local builder = {}

	for _, strOrFunc in ipairs(desc) do
		if type(strOrFunc) == "string" then
			builder[#builder + 1] = strOrFunc
		elseif type(strOrFunc) == "function" then
			out[#out + 1] = table.concat(builder, "")
			builder = {}
			out[#out + 1] = strOrFunc
		end
	end

	out[#out + 1] = table.concat(builder, "")

	return {
		Func = function(descObj)
			return table.concat(
				Mod:Map(
					out,
					function(val)
						if type(val) == "function" then
							local ret = val(descObj)
							if type(ret) == "table" then
								return table.concat(ret, "")
							elseif type(ret) == "string" then
								return ret
							else
								return ""
							end
						end

						return val or ""
					end
				),
				""
			)
		end,
	}
end

---@param desc (string | function)[] | function
---@return boolean
function DD:IsValidDescription(desc)
	if type(desc) == "function" then
		return true
	elseif type(desc) == "table" then
		for _, val in ipairs(desc) do
			if type(val) ~= "string" and type(val) ~= "function" then
				return false
			end
		end
	end

	return true
end

BIRTHCAKE_EID.DynamicDescriptions = DD

--#endregion

---@param player EntityPlayer
---@param trinketId TrinketType
function BIRTHCAKE_EID:TrinketMulti(player, trinketId)
	local multi = 1
	if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
		multi = multi + 1
	end
	if Mod:HasBitFlags(trinketId, TrinketType.TRINKET_GOLDEN_FLAG) then
		multi = multi + 1
	end

	return multi
end

---@param multiplier integer
---@param ... any
function BIRTHCAKE_EID:TrinketMultiStr(multiplier, ...)
	return ({ ... })[multiplier] or ""
end

local DESCRIPTION_SHARE = {
	[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
}

---@class EID_DescObj
---@field ObjType integer
---@field ObjVariant integer
---@field ObjSubType integer
---@field fullItemString string
---@field Name string
---@field Description string
---@field Transformation string
---@field ModName string
---@field Quality integer
---@field Icon table @[see docs](https://github.com/wofsauge/External-Item-Descriptions/wiki/Description-Modifiers#description-object-attributes)
---@field Entity Entity?
---@field ShowWhenUndefined boolean

--Example of a number-replacement modifier
--[[
_modifier = function(descObj, str)
	local multiplier = trinketMulti(EID.player, descObj.ObjSubType)
	local brokenHeartsStr = tostring(Trinket.MOMS_GRIEF:GetBrokenHearts(multiplier))
	if multiplier > 1 then
		brokenHeartsStr = "{{ColorGold}}" .. brokenHeartsStr .. "{{CR}}"
	end
	return ("#" .. str):format(brokenHeartsStr)
end,
 ]]

--Example of a new string modifier
--[[
_modifier = function(descObj, str) ---@param descObj EID_DescObj
	if trinketMulti(EID.player, descObj.ObjSubType) > 1 then
		return "#{{ColorGold}}" .. str .. "{{CR}}"
	end
end,
 ]]

--Example of multiple string options
--[[
_modifier = function(descObj, descStr, ...)
	local multiplier = trinketMulti(EID.player, descObj.ObjSubType)
	if multiplier > 1 then
		return ("#{{ColorGold}}" .. descStr):format(
			trinketMultiStr(multiplier - 1, ...)
		)
	end
end,
en_us = {
	Name = "Lucky Cat",
	Description = {
		"{{LuckSmall}} Grants a Luck bonus based on the amount of {{Coin}}Coins Isaac has",
		"#This bonus has diminishing returns",
		function(descObj) ---@param descObj EID_DescObj
			return EID_Trinkets[Trinket.LUCKY_CAT.ID]._modifier(
				descObj, "Luck bonus %s!", "doubled", "tripled", "quadrupled"
			)
		end
	}
},
 ]]

BIRTHCAKE_EID.Descs = {
	[PlayerType.PLAYER_ISAAC] = {
		---@param descObj EID_DescObj
		---@param str string
		_modifier = function(descObj, str, strMult)
			local mult = BIRTHCAKE_EID:TrinketMulti(EID.player, descObj.ObjType)

			if mult > 1 then
				return strMult:format(mult - 1)
			end
			return str
		end,
		en_us = {
			"{{Card" .. Card.CARD_DICE_SHARD .."}} ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "A Dice Shard", "%s Dice Shards")
			end,
			" spawns in the starting room of every floor"
		}
	},
	[PlayerType.PLAYER_MAGDALENE] = {
		en_us = {"Is cool and epic"}
	},
	[PlayerType.PLAYER_CAIN] = {

	},
	[PlayerType.PLAYER_JUDAS] = {

	},
	[PlayerType.PLAYER_BLUEBABY] = {

	},
	[PlayerType.PLAYER_EVE] = {

	},
	[PlayerType.PLAYER_SAMSON] = {

	},
	[PlayerType.PLAYER_AZAZEL] = {

	},
	[PlayerType.PLAYER_LAZARUS] = {

	},
	[PlayerType.PLAYER_EDEN] = {

	},
	[PlayerType.PLAYER_THELOST] = {

	},
	[PlayerType.PLAYER_LILITH] = {

	},
	[PlayerType.PLAYER_KEEPER] = {

	},
	[PlayerType.PLAYER_APOLLYON] = {

	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {

	},
	[PlayerType.PLAYER_BETHANY] = {

	},
	[PlayerType.PLAYER_JACOB] = {

	},
	[PlayerType.PLAYER_ISAAC_B] = {

	},
	[PlayerType.PLAYER_MAGDALENE_B] = {

	},
	[PlayerType.PLAYER_CAIN_B] = {

	},
	[PlayerType.PLAYER_JUDAS_B] = {

	},
	[PlayerType.PLAYER_BLUEBABY_B] = {

	},
	[PlayerType.PLAYER_EVE_B] = {

	},
	[PlayerType.PLAYER_SAMSON_B] = {

	},
	[PlayerType.PLAYER_AZAZEL_B] = {

	},
	[PlayerType.PLAYER_LAZARUS_B] = {

	},
	[PlayerType.PLAYER_EDEN_B] = {

	},
	[PlayerType.PLAYER_THELOST_B] = {

	},
	[PlayerType.PLAYER_LILITH_B] = {

	},
	[PlayerType.PLAYER_KEEPER_B] = {

	},
	[PlayerType.PLAYER_APOLLYON_B] = {

	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {

	},
	[PlayerType.PLAYER_BETHANY_B] = {

	},
	[PlayerType.PLAYER_JACOB_B] = {

	},
}

for sharedDescription, copyDescription in pairs(DESCRIPTION_SHARE) do
	BIRTHCAKE_EID.Descs[sharedDescription] = BIRTHCAKE_EID.Descs[copyDescription]
end

EID:addTrinket(Mod.Birthcake.ID, "", "Birthcake")

for _, trinketDescData in pairs(BIRTHCAKE_EID.Descs) do
	for language, descData in pairs(trinketDescData) do
		if language:match('^_') or not DD:IsValidDescription(descData) then goto continue end -- skip helper private fields
		local newDesc = DD:MakeMinimizedDescription(descData)
		trinketDescData[language] = newDesc
		::continue::
	end
end

EID:addDescriptionModifier(
	"Birthcake Description",
	-- condition
	function(descObj)
		local subtype = descObj.ObjSubType
		if descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
			subtype = (subtype & ~TrinketType.TRINKET_GOLDEN_FLAG)
			if subtype == Mod.Birthcake.ID and EID.player then
				local desc = BIRTHCAKE_EID.Descs[EID.player:GetPlayerType()]
				if desc	and BIRTHCAKE_EID:GetTranslatedString(desc) then
					return true
				end
			end
		end
		return false
	end,
	-- modifier
	---@param descObj EID_DescObj
	function(descObj)
		local playerType = EID.player:GetPlayerType()
		local desc = BIRTHCAKE_EID:GetTranslatedString(BIRTHCAKE_EID.Descs[playerType])
		local name = Mod:GetBirthcakeName(EID.player)
		local spriteConfig = Mod.BirthcakeSprite[playerType]
		local sprite = descObj.Icon[7]
		if spriteConfig then
			sprite:ReplaceSpritesheet(1, spriteConfig.SpritePath)
		elseif not spriteConfig and Birthcake.BirthcakeDescs[playerType] then
			sprite:ReplaceSpritesheet(1, "gfx/items/trinkets" .. EID.player:GetName():lower() .. "_birthcake.png")
		end

		sprite:LoadGraphics()
		descObj.Description = "#{{Player" .. playerType .. "}} {{ColorGray}}" .. name .. "#" .. desc.Func(descObj)

		return descObj
	end
)
