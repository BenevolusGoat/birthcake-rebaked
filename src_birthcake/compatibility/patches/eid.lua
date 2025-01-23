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
	[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X]
		---@param descObj EID_DescObj
		---@param str string
		_modifier = function(descObj, str, strMult)
			local mult = BIRTHCAKE_EID:TrinketMulti(EID.player, descObj.ObjSubType)

			if mult > 1 then
				return "{{ColorGold}}" .. mult .. "{{CR}}" .. strMult
			end
			return str
		end,
		en_us = {
			"Spawns ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "a {{Card" .. Card.CARD_DICE_SHARD .."}}Dice Shard", " {{Card" .. Card.CARD_DICE_SHARD .."}}Dice Shards")
			end,
			" on pickup and in the starting room of every floor"
		},
		ru = {
			"Создает ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "{{Card" .. Card.CARD_DICE_SHARD .."}}Осколок Кости", " {{Card" .. Card.CARD_DICE_SHARD .."}}Осколков Кости")
			end,
			" при подьеме и в стартовой комнате каждого этажа"
		}
	},
	[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = {
		"{{Heart}} Hearts have a ",
			function(descObj)
				return tostring(100 * Mod:GetBalanceApprovedLuckChance(Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE, BIRTHCAKE_EID:TrinketMulti(EID.player, descObj.ObjSubType)))
			end,
		"% chance to be doubled"
		},
		ru = {
		"{{Heart}} Сердца имеют ",
			function(descObj)
				return tostring(100 * Mod:GetBalanceApprovedLuckChance(Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE, BIRTHCAKE_EID:TrinketMulti(EID.player, descObj.ObjSubType)))
			end,
		"% шанс удвоиться"
		},
	},
	[PlayerType.PLAYER_CAIN] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X]
		---@param descObj EID_DescObj
		---@param str string
		_modifier = function(descObj, baseChance)
			local mult = BIRTHCAKE_EID:TrinketMulti(EID.player, descObj.ObjSubType)
			local chance = baseChance * (1 + 0.3 * (mult - 1))
			
			if mult > 1 then
				return "{{ColorGold}}" .. tostring(chance * 100) .. "{{CR}}"
			end
			
			return tostring(chance * 100)
		end,
		en_us = {
			"#{{Slotmachine}} Slot Machines and {{FortuneTeller}} Fortune Telling Machines have a ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, 0.33)
			end,
			"% chance to refund money",
			"#{{CraneGame}} Crane Games have a ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, 0.25)
			end,
			"% chance to refund money"
		},
		ru = {
			"{{Slotmachine}} Игровые автоматы и {{FortuneTeller}} Автоматы для предсказаний имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, 0.33)
			end,
			"% шанс возвратить деньги",
			"#{{CraneGame}} Кран-машины имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, 0.25)
			end,
			"% шанс возвратить деньги"
		},

	},
	[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = {
		"{{ArrowUp}}{{Damage}} x0.1 damage multiplier", --number might be wrong? i got it directly from judas' code
		"#{{DevilRoom}} If taking a Devil Deal item were to kill Judas, this trinket is consumed instead."
		},

	},
	[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { --will probably have to havei t dynamically change depending on the active being held
		"{{Collectible36}} The Poop spawns 2 additional poops at both sides of the original on use.", 
		"#The sides the poop appear on depend on the direction ??? is facing.",
		"#{{Collectible}} With other active items, fires out 3 poop projectiles in random directions that create a poop on contact."
		},
	},
	[PlayerType.PLAYER_EVE] = {					-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { --maybe add bffs here?
		"{{Collectible117}} Turns Dead Bird into Blood Bird.", 
		"#Blood Bird periodically leaves behind small damaging pools of red creep.",
		"#Blood Bird's damage scales with Eve's damage."
		},
	},
	[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible157}} Reaching the maximum damage increase with Bloody Lust drops a {{Heart}} red heart.", 
		"#Drops two red hearts if Samson's health is low enough",
		"#{{SoulHeart}} Drops a soul heart if at full health"
		},
	},
	[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Brimstone blasts last longer while damaging enemies."
		},
	},
	[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible332}} If Lazarus Risen dies, this trinket is consumed and he is revived again.", 
		"#The revive grants another damage increase and removes a heart container."
		},
	},
	[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Trinket}} Gulps three random trinkets while held.", 
		"#The trinket effects are lost when Birthcake is dropped."
		},
	},
	[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible677}} Temporarily slows down enemies and grants a decaying fire rate increase when Holy Mantle is broken."
		},
	},
	[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Familiars have a chance to mimic Lilith's tear effects."
		},
	},
	[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Shop}} Shops and {{DevilRoom}} Devil Rooms contain a nickel."
		},
	},
	[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible477}} Void can absorb trinkets.", 
		"#Voided trinkets are gulped, retaining their effects permanently as long as Void is held."
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {		-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Firing at the skeleton as the soul will cause bone fragment tears to fire out of it in random directions.", 
		"#Returning to the skeleton will grant a decaying fire rate increase depending on how much it was shot at." --could be worded better
		},
	},
	[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Using an active item has a chance to spawn an additional wisp"
		},
	},
	[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{ArrowUp}}{{Damage}} The holder will grant a portion of their damage to the other brother" --word this better?
		},
	},
	[PlayerType.PLAYER_ISAAC_B] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Grants an additional item slot"
		},
	},
	[PlayerType.PLAYER_MAGDALENE_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Dropped hearts eventually explode into pools of red creep",
		"#Explosion damage scales with Magdalene's damage"
		},
	},
	[PlayerType.PLAYER_CAIN_B] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Double pickups that spawn are split into two." 
		},
	},
	[PlayerType.PLAYER_JUDAS_B] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible705}} Passing through enemies with Dark Arts slightly decreases its charge time." 
		},
	},
	[PlayerType.PLAYER_BLUEBABY_B] = {			-- EN: [X] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]

	},
	[PlayerType.PLAYER_EVE_B] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Blood clots leave behind a small pool of damaging creep on death.",
		"#The damage and effects of the creep depend on the type of clot killed."
		},
	},
	[PlayerType.PLAYER_SAMSON_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible704}} Clearing a room while in Berserk has a chance to extend its length by 5 seconds and spawn a {{HalfHeart}} half red heart." 
		},
	},
	[PlayerType.PLAYER_AZAZEL_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Sneezing fires out a cluster of 6 tears that deal a portion of Azazel's damage",
		"#{{Collectible459}} Tears have a chance to stick onto enemies to damage them over time"
		},
	},
	[PlayerType.PLAYER_LAZARUS_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible711}} When using Flip, item pedestals have a chance to split into both collectibles displayed." 
		},
	},
	[PlayerType.PLAYER_EDEN_B] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Taking damage has a chance to not reroll Eden's items.",
		"#Birthcake is always immune to being rerolled."
		},
	},
	[PlayerType.PLAYER_THELOST_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Card51}} Spawns a Holy Card when first picked up.",
		"#Increases the chance for Holy Cards to appear"
		},
	},
	[PlayerType.PLAYER_LILITH_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Whipping out Lilith's Gello has a chance to spawn another Gello",
		"#The additional Gello deals halved damage"
		},
	},
	[PlayerType.PLAYER_KEEPER_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Spawns an item and two pickups for sale at the start of each floor"
		},
	},
	[PlayerType.PLAYER_APOLLYON_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible706}} Trinkets can be converted into locusts by Abyss",
		"#Locusts made from trinkets deal 50% damage"
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {		-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Killing enemies will spawn stationary bone fragments that damage enemies on contact",
		"#Holding the skeleton will cause all bone fragments to fly towards the Soul, damaging enemies in the way"
		},
	},
	[PlayerType.PLAYER_BETHANY_B] = {			-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"{{Collectible712}} Lemegeton wisps have doubled health"
		},
	},
	[PlayerType.PLAYER_JACOB_B] = {				-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = { 
		"Dark Esau leaves behind small flames when flying, blocking tears and enemy projectiles.",
		"#The flames can damage both Jacob and enemies."
		},
	},
}

BIRTHCAKE_EID.DefaultDescription = {
	en_us = {
		"↑ +5% to all stats"
	},
	ru = {
		"↑ +5% ко всем характеристикам"
	},
}
BIRTHCAKE_EID.Names = {
	en_us = "Birthcake",
	ru = "Пироженое",
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

for language, descData in pairs(BIRTHCAKE_EID.DefaultDescription) do
	if language:match('^_') or not DD:IsValidDescription(descData) then goto continue end -- skip helper private fields
	local newDesc = DD:MakeMinimizedDescription(descData)
	BIRTHCAKE_EID.DefaultDescription[language] = newDesc
	::continue::
end

---@param player EntityPlayer
function BIRTHCAKE_EID:GetBirthcakeName(player)
	local playerType = player:GetPlayerType()
	local name = Mod.BirthcakeNames[playerType][EID.getLanguage()] or Mod.BirthcakeNames[playerType].en_us
	--[[local nameResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.GET_BIRTHCAKE_ITEMTEXT_NAME, playerType, player, name) idk if we need that, but uncomment, if we do
	name = (nameResult ~= nil and tostring(nameResult)) or name]]
	return name
end

local lastRenderedPlayerType

EID:addDescriptionModifier(
	"Birthcake Description",
	-- condition
	function(descObj)
		local subtype = descObj.ObjSubType
		if descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
			subtype = (subtype & ~TrinketType.TRINKET_GOLDEN_FLAG)
			if subtype == Mod.Birthcake.ID and EID.player then
				return true
			end
		end
		return false
	end,
	-- modifier
	---@param descObj EID_DescObj
	function(descObj)
		local playerType = EID.player:GetPlayerType()
		local descTable = BIRTHCAKE_EID.Descs[EID.player:GetPlayerType()]
		local desc = BIRTHCAKE_EID:GetTranslatedString(BIRTHCAKE_EID.DefaultDescription)
		if descTable and BIRTHCAKE_EID:GetTranslatedString(descTable) then
			desc = BIRTHCAKE_EID:GetTranslatedString(descTable)
		end
		local name = BIRTHCAKE_EID:GetBirthcakeName(EID.player)
		if lastRenderedPlayerType ~= playerType then
			local spriteConfig = Mod.BirthcakeSprite[playerType]
			local sprite = descObj.Icon[7]
			if spriteConfig then
				sprite:ReplaceSpritesheet(1, spriteConfig.SpritePath)
			elseif not spriteConfig and Birthcake.BirthcakeDescs[playerType] then
				sprite:ReplaceSpritesheet(1, "gfx/items/trinkets" .. EID.player:GetName():lower() .. "_birthcake.png")
			end

			sprite:LoadGraphics()
			lastRenderedPlayerType = playerType
		end
		descObj.Description = "#{{Player" .. playerType .. "}} {{ColorGray}}" .. name .. "#" .. desc.Func(descObj)
		descObj.Name = BIRTHCAKE_EID.Names[EID.getLanguage()] or BIRTHCAKE_EID.Names.en_us

		return descObj
	end
)
