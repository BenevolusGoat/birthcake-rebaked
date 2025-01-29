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
---@param ignoreBox? boolean
function BIRTHCAKE_EID:TrinketMulti(player, trinketId, ignoreBox)
	local multi = 1
	if not ignoreBox and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
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
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS_B,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN_B,
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

---@param chance number
function BIRTHCAKE_EID:AdjustNumberValue(chance)
	chance = chance * 100
	local floored = math.floor(chance)

	if floored - chance == 0 then
		chance = floored
	end
	return chance
end

function BIRTHCAKE_EID:GoldConditional(str, mult)
	if mult > 1 then
		return "{{ColorGold}}" .. str .. "{{CR}}"
	end
	return tostring(str)
end

---@param descObj EID_DescObj
---@param baseMult number
function BIRTHCAKE_EID:BalanceChanceModifier(descObj, baseMult)
	local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
	local chance = Mod:GetBalanceApprovedChance(baseMult, trinketMult)
	chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

	return BIRTHCAKE_EID:GoldConditional(chance, trinketMult)
end

function BIRTHCAKE_EID:NormalChanceModifier(descObj, baseMult)
	local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
	local chance = baseMult * trinketMult
	chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

	return BIRTHCAKE_EID:GoldConditional(chance, trinketMult)
end

BIRTHCAKE_EID.Descs = {
	[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		---@param str string
		_modifier = function(descObj, str, strMult)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)

			if trinketMult > 1 then
				return "{{ColorGold}}" .. trinketMult .. "{{CR}}" .. strMult
			end

			return str
		end,
		en_us = {
			"Spawns ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "a {{Card49}}Dice Shard", " {{Card49}}Dice Shards")
			end,
			" on pickup and in the starting room of every floor"
		},
		ru = {
			"Создаёт ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "{{Card49}}Осколок Кости", " {{Card49}}Осколка Кости")
			end,
			" при подьёме и в стартовой комнате каждого этажа"
		}
	},
	[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Heart}} Heart pickups have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% chance to be upgraded",
			"#Possible upgrades are:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
		ru = {
			"{{Heart}} Сердца имеют ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% шанс удвоиться"
		},
	},
	[PlayerType.PLAYER_CAIN] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		---@param baseChance number | fun(player: EntityPlayer): number
		_modifier = function(descObj, baseChance)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			baseChance = type(baseChance) == "function" and baseChance(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)) or baseChance
			---@cast baseChance number
			local chance = Mod:GetBalanceApprovedChance(baseChance, mult)
			chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

			return BIRTHCAKE_EID:GoldConditional(chance, mult)
		end,
		en_us = {
			"{{Slotmachine}} Slot Machines and {{FortuneTeller}} Fortune Telling Machines have a ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance) --used regular slot chance cuz they're the same
			end,
			"% chance to refund money",
			"#{{CraneGame}} Crane Games have a ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% chance to refund money"
		},
		ru = {
			"{{Slotmachine}} Игровые автоматы и {{FortuneTeller}} Автоматы для предсказаний имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)
			end,
			"% шанс возвратить деньги",
			"#{{CraneGame}} Кран-машины имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% шанс возвратить деньги"
		},

	},
	[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		_modifier = function(descObj)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			local chance = BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.JUDAS.DAMAGE_MULT_UP * mult)

			return BIRTHCAKE_EID:GoldConditional(chance, mult)
		end,
		en_us = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% damage multiplier",
			"#{{DevilRoom}} If taking a Devil Deal item were to kill Judas, this trinket is consumed instead"
		},
		ru = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% множитель урона",
			"#{{DevilRoom}} Если взятие предмета Дьявольской Сделки убьёт Иуду, то вместо этого будет использован брелок"
		},
	},
	[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj, poopStr, activeStr, noActiveStr, invalidActiveStr)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local activeItem = player:GetActiveItem(ActiveSlot.SLOT_PRIMARY)
			if activeItem == CollectibleType.COLLECTIBLE_POOP then
				return poopStr
			elseif activeItem ~= CollectibleType.COLLECTIBLE_NULL then
				local maxCharge = Mod.ItemConfig:GetCollectible(activeItem).MaxCharges
				if maxCharge > 0 then
					if maxCharge > 12 then
						maxCharge = 1
					end
					local poopSpawns = math.max(1, math.ceil(maxCharge / 2))
					return activeStr:format("{{Battery}}{{ColorYellow}}" .. poopSpawns .. "{{CR}}")
				else
					return invalidActiveStr
				end
			else
				return activeStr:format("X") .. noActiveStr
			end
		end,
		en_us = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
				"{{Collectible36}} The Poop spawns 2 additional poops at both sides of the original on use, orientation based on head direction"
				.."#{{Collectible}} Has a different effect with other actives",
				"#{{Collectible}} Fires out %s poop projectile(s) in random directions that spawn a poop when landing",
				"#{{Battery}} X is half your max active charge rounded down",
				"{{Collectible}} No effect for current active"
			) end
		},
		ru = {
			"{{Collectible36}} Какашка создаёт 2 дополнительные какашки по обеим сторонам от оригинальной при использовании",
			"#Стороны, по которым создаются какашки, зависят от того, куда смотрит ???",
			"#{{Collectible}} С другими активными предметами, выстреливает 3 снаряда-какашки в случайных направлениях, которые создают какашку при контакте"
		},
	},
	[PlayerType.PLAYER_EVE] = {					-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj, str)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
				return "#{{Collectible247}} {{BlinkPink}}" .. str .. "{{CR}}"
			end
			return ""
		end,
		en_us = {
			"{{Collectible117}} Turns Dead Bird into Blood Bird",
			"#Blood Bird periodically leaves behind small damaging pools of red creep",
			"#Blood Bird's damage scales with Eve's damage",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "Double damage")
			end
		},
		ru = {
			"{{Collectible117}} Превращает Мертвую Птицу в Кровавую Птицу",
			"#Кровавая Птица переодически оставляет позади себя красные лужи, наносящие небольшой урон",
			"#Урон Кровавой Птицы зависит от урона Евы"
		},
	},
	[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		---@param strNoMult string
		---@param strMult string
		_modifier = function(descObj, defaultStr, strNoMult, strMult, birthrightStr)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(player, descObj.ObjSubType)
			local finalStr = defaultStr
			if trinketMult > 1 then
				finalStr = finalStr .. strMult
			else
				finalStr = finalStr .. strNoMult
			end
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
				finalStr = finalStr .. birthrightStr
			end
			return finalStr
		end,
		en_us = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
				"{{Collectible157}} Reaching the maximum damage increase with Bloody Lust drops ",
				"2 {{Heart}} Red Hearts",
				"2 hearts based on your current health"
				.. "#{{Heart}} Double Red Hearts below half red health, and Red Hearts above or equal to half red health"
				.. "#{{SoulHeart}} Drops Soul Hearts otherwise",
				"#{{Collectible619}} Triggers at both 6 and 10 hits"

			) end
		},
		ru = {
			"{{Collectible157}} Достижение максимального увеличения урона от Жажды Крови создаёт {{Heart}} красное сердце",
			"#Создает 2 красных сердца, если здоровье Самсона достаточно низкое",
			"#{{SoulHeart}} Создает сердце души при полном здоровье"
		},
	},
	[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Brimstone blasts last longer while damaging enemies"
		},
		ru = {
			"Луч Серы длится дольше во время нанесения урона врагам"
		},
	},
	[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible332}} If Lazarus Risen dies, this trinket is consumed and he is revived again",
			"#The revive grants another damage increase and removes a heart container"
		},
		ru = {
			"{{Collectible332}} Если Воскресший Лазарь умрет, этот брелок будет использован, и он возродится снова",
			"#Возрождение также даёт увеличение урона и забирает контейнер сердца"
		},
	},
	[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			local num = 2 + trinketMult

			return BIRTHCAKE_EID:GoldConditional(num, trinketMult)
		end,
		en_us = {
			"{{Trinket}} Gulps ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" random trinkets while held",
			"#The trinket effects are lost when Birthcake is dropped"
		},
		ru = {
			"{{Trinket}} Проглатывает ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" случайных брелка при подборе",
			"#Еффекты брелков пропадают когда Пироженое выбрасывается"
		},
	},
	[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj, str, ...)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			if trinketMult > 1 then
				local multWord = {...}
				return "#{{ColorGold}}" .. str:format(multWord[math.min(3, trinketMult - 1)]) .. "{{CR}}"
			end
			return ""
		end,
		en_us = {
			"{{Collectible677}} Temporarily slows down enemies and grants a decaying fire rate increase when Holy Mantle is broken",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
				"Additionally petrifies enemies in a %s radius for 5 seconds",
				"small",
				"medium",
				"large"
			) end
		},
		ru = {
			"{{Collectible677}} Временно замедляет врагов и даёт убывающее повышение скорострельности при потере Святой Мантии"
		},
	},
	[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Familiars have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% chance to mimic Lilith's tear effects"
		},
		ru = {
			"Спутники имеют шанс скопировать эффекты слёз Лилит"
		},
	},
	[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		---@param str string
		---@param strMult string
		_modifier = function(descObj, str, strMult)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)

			if mult > 1 then
				return BIRTHCAKE_EID:GoldConditional(mult, mult) .. strMult
			end
			return str
		end,
		en_us = {
			"{{Shop}} Shops and {{DevilRoom}} Devil Rooms contain ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "a nickel", " nickels")
			end
		},
		ru = {
			"{{Shop}} Магазины и комнаты {{DevilRoom}} Сделки с Дьяволом содержат ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "пятак", " пятака")
			end
		},
	},
	[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj, str)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType, true)
			local chance = Mod:GetBalanceApprovedChance(Mod.Birthcake.APOLLYON.DOUBLE_VOID_CHANCE, mult - 1)
			chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

			if mult > 1 then
				return "#" .. BIRTHCAKE_EID:GoldConditional(str:format(chance .. "%"), mult)
			end
			return str
		end,
		en_us = {
			"{{Collectible477}} Void can absorb trinkets",
			"#Voided trinkets are gulped, retaining their effects permanently as long as Void is held",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
				"%s chance to duplicate the voided trinket"
			) end
		},
		ru = {
			"{{Collectible477}} Пустота может поглощать брелки",
			"#Поглощённые брелки проглатываются, сохраняя свои еффекты до тех пор, пока Пустота удерживается в руках"
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {		-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Firing at {{Player16}}The Forgotten's body as {{Player17}}The Soul will cause bone fragment tears to fire out of it in random directions and fill it with \"soul charge\"",
			"#Returning to The Forgotten will grant a fading fire rate increase depending on how much soul charge they were filled with"
		},
		ru = {
			"Стреляя в тело {{Player16}}Забытого {{Player17}}Душой приведёт к выстреливании из него осколков костей в случайных направлениях и заполнении его \"зарядом души\"",
			"#Возращение в Забытого даст убывающее повышение скорострельности в зависимости от того, насколько много заряда души он имеет"
		},
	},
	[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Using an active item has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% chance to spawn an additional wisp of the same type"
		},
		ru = {
			"Использование активного предмета имеет ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% шанс создания дополнительного огонька того же типа"
		},
	},
	[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"The holder will reflect all damage they take onto the other brother"
		},
		ru = {
			"Держащий брат будет перенаправлять весь получаемый урон на другого брата"
		},
	},
	[PlayerType.PLAYER_ISAAC_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Grants an additional inventory slot"
		},
		ru = {
			"Даёт дополнительный слот инвентаря"
		},
	},
	[PlayerType.PLAYER_MAGDALENE_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Dropped hearts eventually explode into pools of red creep",
			"#Explosion damage depends on the heart type and the current stage"
		},
		ru = {
			"Выпавшие сердца в конце концов взрываются и оставляют лужи крови",
			"#Урон от взрыва зависит от типа сердца и текущего этажа"
		},
	},
	[PlayerType.PLAYER_CAIN_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Double pickups that spawn are split into their halves"
		},
		ru = {
			"Двойные подбираемые предметы распадаются на их половины"
		},
	},
	[PlayerType.PLAYER_JUDAS_B] = {				-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(player, descObj.ObjSubType)
			local amount = (Mod.Birthcake.JUDAS.DARK_ARTS_CHARGE_BONUS * trinketMult) / 180
			amount = BIRTHCAKE_EID:AdjustNumberValue(amount)

			return BIRTHCAKE_EID:GoldConditional(amount, trinketMult) .. "%"
		end,
		en_us = {
			"{{Collectible705}} Passing through enemies with Dark Arts decreases its charge time by ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
		ru = {
			"{{Collectible705}} Прохождение сквозь врагов под Темными Искусствами немного уменьшает их время зарядки"
		},
	},
	[PlayerType.PLAYER_BLUEBABY_B] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Thrown poops have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% chance to not be damaged when hit by projectiles"
		},
		ru = {
			"Бросаемые какашки имеют шанс не повредиться, когда в них попадают снаряды"
		},
	},
	[PlayerType.PLAYER_EVE_B] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Blood clots leave behind a small pool of damaging creep on death",
			"#The damage and effects of the creep depend on the type of clot killed"
		},
		ru = {
			"Кровяные сгустки оставляют маленькую наносящую урон лужу при смерти",
			"#Урон и эффекты лужи зависят от типа умершего сгустка"
		},
	},
	[PlayerType.PLAYER_SAMSON_B] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible704}} Clearing a room while in Berserk has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% chance to extend its length by 5 seconds and spawn a {{HalfHeart}} half red heart"
		},
		ru = {
			"{{Collectible704}} Зачистка комнаты под действием Берсерка имеет шанс увеличить его длительность на 5 секунд и создать {{HalfHeart}} половину красного сердца"
		},
	},
	[PlayerType.PLAYER_AZAZEL_B] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Sneezing fires out a cluster of 6 tears that deal a portion of Azazel's damage",
			"#{{Collectible459}} Tears have a ",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% chance to stick onto enemies to damage them over time"
		},
		ru = {
			"При чихании выстреливает скопление из 6 слёз, наносящих часть урона Азазеля ",
			"#{{Collectible459}} Слёзы имеют шанс прилипнуть к врагам для нанесения урона со временем"
		},
	},
	[PlayerType.PLAYER_LAZARUS_B] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible711}} When using Flip, item pedestals have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.LAZARUS.ITEM_SPLIT_CHANCE)
			end,
			"% chance to split into both collectibles displayed"
		},
		ru = {
			"{{Collectible711}} При использовании Переворота пьедесталы с предметами имеют шанс разделиться на оба отображаемых предмета"
		},
	},
	[PlayerType.PLAYER_EDEN_B] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Taking damage has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% chance to not reroll Eden's items",
			"#Birthcake is mostly immune to being rerolled, having a "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% chance of being rerolled on hit"
		},
		ru = {
			"Получение урона имеет ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN_B]._modifier(descObj)
			end,
			"% шанс не изменить предметы Эдема",
			"#Пироженое в основном невосприимчиво к изменению и имеет "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% шанс измениться при получении урона"
		},
	},
	[PlayerType.PLAYER_THELOST_B] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Card51}} Spawns a Holy Card when first picked up",
			"#Cards have another ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% chance of becoming a Holy Card"

		},
		ru = {
			"{{Card51}} Создаёт Святую Карту при первом подборе",
			"#Увеличивает шанс появления Святых Карт"
		},
	},
	[PlayerType.PLAYER_LILITH_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Whipping out Lilith's Gello has a",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"chance to spawn another Gello",
			"#The additional Gello deals 50% damage"
		},
		ru = {
			"Выхлёстывание Гелло Лилит имеет шанс создать ещё одного Гелло",
			"#Дополнительный Гелло наносит 50% урона"
		},
	},
	[PlayerType.PLAYER_KEEPER_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Spawns an item and 2 pickups for sale at the start of each floor"
		},
		ru = {
			"Создаёт предмет и 2 подбираемых предмета на продажу в начале каждого этажа"
		},
	},
	[PlayerType.PLAYER_APOLLYON_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			local dmg = "50%"
			if trinketMult > 1 then
				dmg = "100%"
			end
			return BIRTHCAKE_EID:GoldConditional(dmg, trinketMult)
		end,
		en_us = {
			"{{Collectible706}} Trinkets can be converted into locusts by Abyss",
			"#Locusts made from trinkets deal ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" damage"
		},
		ru = {
			"{{Collectible706}} Брелки могут быть превращены в саранчу с помощью Бездны",
			"#Саранча, полученная из брелков, наносит ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" урона"
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {		-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Killing enemies will spawn stationary bone fragments that damage enemies on contact",
			"#Holding {{Player35}}The Forgotten will cause all bone fragments to fly towards {{Player40}}The Soul, becoming orbitals"
		},
		ru = {
			"Убийство врагов создаст неподвижные осколки костей, наносящие урон врагам при контакте",
			"#Подбирание {{Player35}}Забытого заставит все осколки костей полететь к {{Player40}}Душе, нанося урон врагам по пути"
		},
	},
	[PlayerType.PLAYER_BETHANY_B] = {			-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(player, descObj.ObjSubType)
			local baseHP = Mod.Birthcake.BETHANY.WISP_HEALTH_UP
			local hpMultAdd = Mod.Birthcake.BETHANY.WISP_HEALTH_MULT_ADD
			local hp = baseHP + (hpMultAdd * (trinketMult - 1))

			return BIRTHCAKE_EID:GoldConditional(hp, trinketMult)
		end,
		en_us = {
			"{{Collectible712}} Lemegeton wisps can take an additional ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" hits"
		},
		ru = {
			"{{Collectible712}} Огоньки Лемегетона имеют удвоенное здоровье"
		},
	},
	[PlayerType.PLAYER_JACOB_B] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Dark Esau leaves behind small flames when flying, blocking tears and enemy projectiles",
			"#The flames can damage both Jacob and enemies"
		},
		ru = {
			"Тёмный Исав оставляет за собой огонь при полете, блокирующий слёзы и снаряды врагов",
			"#Огонь может наносить урон и Иакову, и врагам"
		},
	},
}

BIRTHCAKE_EID.ShortDescriptions = {
	DEFAULT_EFFECT = {							-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			local statMult = Mod.Birthcake.DEFAULT_EFFECT:GetStatMult(trinketMult)
			statMult = BIRTHCAKE_EID:AdjustNumberValue(statMult)

			return BIRTHCAKE_EID:GoldConditional(statMult, trinketMult)
		end,
		en_us = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.DefaultDescription._modifier(descObj)
			end,
			"% to all stats"
		},
		ru = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.DefaultDescription._modifier(descObj)
			end,
			"% ко всем характеристикам"
		},
	},
	APOLLYON_B_APPEND = {						-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj, strNoMult, strMult)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local objTrinketMult = BIRTHCAKE_EID:TrinketMulti(player, descObj.ObjSubType)
			local cakeTrinketMult = Mod:GetTrinketMult(player)
			local str = strNoMult
			if objTrinketMult > 1 or cakeTrinketMult > 1 then
				str = strMult
			end
			return "{{Collectible706}} {{ColorRed}}" .. str .. "{{CR}}"
		end,
		en_us = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
				"Grey locust that deals half damage",
				"Red locust that deals full damage"
				)
			end
		}
	}
}

BIRTHCAKE_EID.LegacyDescriptions = {}

BIRTHCAKE_EID.TwinShare = {
	[PlayerType.PLAYER_JACOB] = PlayerType.PLAYER_ESAU
}

EID:addTrinket(Mod.Birthcake.ID, "", "Birthcake")

for _, trinketDescData in pairs(BIRTHCAKE_EID.Descs) do
	for language, descData in pairs(trinketDescData) do
		if language:match('^_') or not DD:IsValidDescription(descData) then goto continue end -- skip helper private fields
		local newDesc = DD:MakeMinimizedDescription(descData)
		trinketDescData[language] = newDesc
		::continue::
	end
end

for _, shortDesc in pairs(BIRTHCAKE_EID.ShortDescriptions) do
	for language, descData in pairs(shortDesc) do
		if language:match('^_') or not DD:IsValidDescription(descData) then goto continue end -- skip helper private fields
		local newDesc = DD:MakeMinimizedDescription(descData)
		shortDesc[language] = newDesc
		::continue::
	end
end

local lastRenderedPlayerType
local lastRenderedSubType

EID:addDescriptionModifier(
	"Birthcake Description",
	-- condition
	function(descObj)
		local subtype = descObj.ObjSubType
		if descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
			subtype = (subtype & ~TrinketType.TRINKET_GOLDEN_FLAG)
			if subtype == Mod.Birthcake.ID and BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity) then
				return true
			end
		end
		return false
	end,
	-- modifier
	---@param descObj EID_DescObj
	function(descObj)
		local players = EID.coopMainPlayers
		for _, player in ipairs(players) do
			local playerType = player:GetPlayerType()
			local descTable = BIRTHCAKE_EID.Descs[playerType]
			if DESCRIPTION_SHARE[playerType] then
				descTable = BIRTHCAKE_EID.Descs[DESCRIPTION_SHARE[playerType]]
			end
			local desc = BIRTHCAKE_EID:GetTranslatedString(BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT)
			if descTable and BIRTHCAKE_EID:GetTranslatedString(descTable) then
				desc = BIRTHCAKE_EID:GetTranslatedString(descTable)
			elseif Birthcake.TrinketDesc[playerType] and Birthcake.TrinketDesc[playerType].Normal then
				local legacyDesc = BIRTHCAKE_EID.LegacyDescriptions[playerType]
				if not legacyDesc then
					BIRTHCAKE_EID.LegacyDescriptions[playerType] = DD:MakeMinimizedDescription({Birthcake.TrinketDesc[playerType].Normal})
					legacyDesc = BIRTHCAKE_EID.LegacyDescriptions[playerType]
				end
				desc = legacyDesc
			end
			local icon = EID:GetPlayerIcon(playerType)
			local name = EID:getPlayerName(playerType)
			local twin = BIRTHCAKE_EID.TwinShare[playerType]
			if twin then
				name = name .. " & " .. EID:getPlayerName(twin)
				icon = icon .. " {{Player" .. twin .. "}}"
			end

			local sprite = descObj.Icon[7]

			if #players > 1 or (not Mod.BirthcakeSprite[playerType] and not Birthcake.BirthcakeDescs[playerType]) then
				if lastRenderedPlayerType ~= PlayerType.PLAYER_ISAAC or lastRenderedSubType ~= descObj.ObjSubType then
					sprite:ReplaceSpritesheet(1, "gfx/items/trinkets/0_isaac_birthcake.png")
					sprite:LoadGraphics()
					lastRenderedPlayerType = PlayerType.PLAYER_ISAAC
					lastRenderedSubType = descObj.ObjSubType
				end
			elseif lastRenderedPlayerType ~= playerType or lastRenderedSubType ~= descObj.ObjSubType then
				local spriteConfig = Mod.BirthcakeSprite[playerType]
				if spriteConfig then
					sprite:ReplaceSpritesheet(1, spriteConfig.SpritePath)
				elseif not spriteConfig and Birthcake.BirthcakeDescs[playerType] then
					sprite:ReplaceSpritesheet(1, "gfx/items/trinkets/" .. player:GetName():lower() .. "_birthcake.png")
				end

				sprite:LoadGraphics()
				lastRenderedPlayerType = playerType
				lastRenderedSubType = descObj.ObjSubType
			end
			EID:appendToDescription(descObj, icon .. " {{ColorIsaac}}" .. name .. "{{CR}}#" .. desc.Func(descObj) .. "#")
			descObj.Name = BIRTHCAKE_EID:GetTranslatedString(BirthcakeRebaked.BirthcakeOneLiners.BIRTHCAKE)
		end

		return descObj
	end
)

EID:addDescriptionModifier(
	"Apollyon B Bithcake",
	---@param descObj EID_DescObj
	function(descObj)
		if descObj.ObjVariant == PickupVariant.PICKUP_TRINKET then
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_APOLLYON_B) then
				return true
			end
		end
	end,
	---@param descObj EID_DescObj
	function(descObj)
		local desc = BIRTHCAKE_EID:GetTranslatedString(BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND)
		EID:appendToDescription(descObj, "#" .. desc.Func(descObj))
		return descObj
	end
)