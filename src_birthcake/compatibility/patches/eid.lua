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
	local lang = EID.getLanguage()
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
function BIRTHCAKE_EID:BalancedNumberModifier(descObj, baseMult)
	local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
	local chance = Mod:GetBalanceApprovedChance(baseMult, trinketMult)
	chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

	return BIRTHCAKE_EID:GoldConditional(chance, trinketMult)
end

function BIRTHCAKE_EID:NormalNumberModifier(descObj, baseMult)
	local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
	local chance = baseMult * trinketMult
	chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

	return BIRTHCAKE_EID:GoldConditional(chance, trinketMult)
end

BIRTHCAKE_EID.Descs = {
	[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
		},
		spa = {
			"Genera ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "un {{Card49}}Fragmento de Dado", " {{Card49}}Fragmentos de Dado")
			end,
			" Al recogerlo y en la habitación inicial de cada piso"
		},
		cs_cz = {
			"Vytvoří ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "{{Card49}}Úlomek Kostky", " {{Card49}}Úlomky Kostky")
			end,
			" po zvednutí a ve startovací místnosti každé podlaží",
		},
		pl = {
			"Tworzy ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, " {{Card49}}Odłamek Kości", " {{Card49}}Odłamki Kości")
			end,
			" przy pierwszym podniesieniu i na początku każdego piętra"
		},
	},
	[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Heart}} Heart pickups have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% chance to be upgraded",
			"#Possible upgrades are:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
		ru = {
			"{{Heart}} Подбираемые сердца имеют ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% шанс улучшиться",
			"#Возможные улучшения:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
		spa = {
			"{{Heart}} Los recolectables de corazón tiene una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% de ser mejorados",
			"#Las posibles mejoras son:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
		cs_cz = {
			"{{Heart}} Srdce mají ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% šanci na vylepšení",
			"#Možná vylepšení jsou:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}",
		},
		pl = {
			"{{Heart}} Serduszka mają ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% szansy na ulepszenie",
			"#Możliwe ulepszenia to:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
	},
	[PlayerType.PLAYER_CAIN] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			"{{Slotmachine}} Игровые Автоматы и {{FortuneTeller}} Автоматы для Предсказаний имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)
			end,
			"% шанс возвратить деньги",
			"#{{CraneGame}} Кран-Машины имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% шанс возвратить деньги"
		},
		spa = {
			"{{Slotmachine}} Las Máquinas Tragaperras y las {{FortuneTeller}} Máquinas de Adivinación del Futuro tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance) --used regular slot chance cuz they're the same
			end,
			"% de reembolsar dinero",
			"#{{CraneGame}} Los Juegos de Grúa tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% de reembolsar dinero",
		},
		cs_cz = {
			"{{Slotmachine}} Hrací automaty a {{FortuneTeller}} Věštecké automaty mají ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance) --used regular slot chance cuz they're the same
			end,
			"% šanci na vrácení peněz",
			"#{{CraneGame}} Jeřábová hra má ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% šanci na vrácení peněz",
		},
		pl = {
			"{{Slotmachine}} Automaty do Gier i {{FortuneTeller}} Automaty z Wróżbami mają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance) --used regular slot chance cuz they're the same
			end,
			"% szansy na zwrot pieniędzy",
			"#{{CraneGame}} Chwytaki mają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% szansy na zwrot pieniędzy"
		},
	},
	[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X] | PT_BR [X]
		---@param descObj EID_DescObj
		_modifier = function(descObj)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			local chance = BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.JUDAS.DAMAGE_MULT_UP * mult)

			return BIRTHCAKE_EID:GoldConditional(chance, mult)
		end,
		en_us = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% damage multiplier",
			"#{{DevilRoom}} If taking a Devil Deal item were to kill Judas, this trinket is consumed instead"
		},
		ru = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% множитель урона",
			"#{{DevilRoom}} Если взятие предмета Дьявольской Сделки убьёт Иуду, то вместо этого будет использован брелок"
		},
		spa = {
			"{{ArrowUp}} {{Damage}} Multiplicador de daño del ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"%",
			"#{{DevilRoom}} Si tomar un objeto del Pacto con el Demonio podría matar a Judas, el trinket se consume en su lugar"
		},
		cs_cz = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% Násobitel poškození",
			"#{{DevilRoom}} Jestli by obchod s ďáblem Jidáše zabil, místo toho se zpotřebuje tato cetka",
		},
		pl = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% więcej Obrażeń",
			"#{{DevilRoom}} Gdyby wymiana z Diabłem miała by zabić Judasza, zamiast tego ten trynkiet jest niszczony"
		},
	},
	[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
				"{{Collectible36}} При использовании Какашка создаёт 2 дополнительных какашки по обеим сторонам от оригинальной, ориентация зависит от направления головы"
				.."#{{Collectible}} Имеет другой эффект с остальными активируемыми предметами",
				"#{{Collectible}} Выстреливает %s снаряд(ов)-какашку(ек) в случайных направлениях, которые создают какашку при столкновении",
				"#{{Battery}} X - это половина заряда твоего активного предмета, округлённая в меньшую сторону",
				"{{Collectible}} Нет эффекта для текущего активного предмета"
			) end
		},
		spa = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
				"{{Collectible36}} La Caca genera 2 cacas adicionales en ambos lados de la original al usarse, la orientación basándose en la direccion de la cabeza"
				.."#{{Collectible}} Tiene un efecto distinto con activos diferentes",
				"#{{Collectible}} Suelta %s proyectil(es) de caca en direcciones aleatorias que generan una caca al tocatr el suelo",
				"#{{Battery}} X es la mitad de las cargas máximas de tu acticvo redondeadas hacia abajo",
				"{{Collectible}} Sin efecto para to activo actual"
			) end
		},
		pl = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
				"{{Collectible36}} Kupa tworzy 2 dodatkowe kupy po bokach przy użyciu, pozycja zależy od kierunku głowy"
				.."#{{Collectible}} Ma inny efekt zależnie od użytego przedmiotu",
				"#{{Collectible}} Wystrzeliwywuje %s procisków w losowych kierunkach, które stają się kupami po lądowaniu",
				"#{{Battery}} X jest połową maksymalnych ładunków przedmiotu, zaokroglając w dół",
				"{{Collectible}} Nie robi nic z aktualnym przedmiotem aktywnym"
			) end
		},
	},
	[PlayerType.PLAYER_EVE] = {					-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			"#Урон Кровавой Птицы зависит от урона Евы",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "Урон удвоен")
			end
		},
		spa = {
			"{{Collectible117}} Transforma a la Ave Muerta en la Ave de Sangre",
			"La Ave de Sangre genera periodicamente pequeños charcos de creep roja que hacen daño a enemigos",
			"#El daño de la Ave de Sangre escala con el dañi de Eva",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "Doble daño")
			end
		},
		pl = {
			"{{Collectible117}} Zamienia Zdechłego Ptaka w Krwawego Ptaka",
			"#Krwawy Ptak zostawia za sobą plamy czerwonej mazi",
			"#Obrażenia Krwawego Ptaka skalują się z Obrażeniami Ewy",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "Double damage")
			end
		},
	},
	[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
				"{{Collectible157}} Достижение максимального увеличения урона от Жажды Крови создаёт ",
				"2 {{Heart}} Красных Сердца",
				"2 сердца, зависящих от твоего текущего здоровья"
				.. "#{{Heart}} Двойные Красные Сердца при здоровье меньше половины красного сердца, и Красные Сердца при здоровье больше или равному половине красного сердца"
				.. "#{{SoulHeart}} Иначе создаёт Сердца Души",
				"#{{Collectible619}} Срабатывает и на 6, и на 10 ударе"

			) end
		},
		spa = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
				"{{Collectible157}} Llegar a la máxima mejora de daño con Lujuria de Sangre genera ",
				"2 {{Heart}} Corazones Rojos",
				"2 corazones basados en tu vida actual"
				.. "#{{Heart}} Double Red Hearts below half red health, and Red Hearts above or equal to half red health"
				.. "#{{SoulHeart}} De lo contrario, suelta Corazones de Alma",
				"#{{Collectible619}} Se activa a los 6 y 10 golpes"
			) end
		},
		pl = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
				"{{Collectible157}} Osiągnięcie maksymalnego bonusu z Krwawej Żądzy daje ",
				"2 {{Heart}} czerwone serduszka",
				"2 serduszka zależne od aktualnego zdrowia"
				.. "#{{Heart}} podwójne czerwone serduszka mając mniej niż połowe czerwonego zdrowia, czerwona serduszka mając mając więcej zdrowia"
				.. "#{{SoulHeart}} w innym przypadky daje serduszka dusz",
				"#{{Collectible619}} Aktywuje się po 6 oraz 10 uderzeniach"

			) end
		},
	},
	[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Brimstone blasts last longer while damaging enemies"
		},
		ru = {
			"Луч Серы длится дольше во время нанесения урона врагам"
		},
		spa = {
			"Las ráfagas de Azufre duran más al hacer daño a enemigos"
		},
		pl = {
			"Splunięcie laserem trwa dłużej"
		},
	},
	[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible332}} If Lazarus Risen dies, this trinket is consumed and he is revived again",
			"#The revive grants another damage increase and removes a heart container"
		},
		ru = {
			"{{Collectible332}} Если Воскресший Лазарь умрет, этот брелок будет использован, и он возродится снова",
			"#Возрождение также даёт увеличение урона и забирает контейнер сердца"
		},
		spa = {
			"{{Collectible332}} Si Lázaro Resucitado muere, este trinket se consume y es revivido otra vez",
			"#Revivir otorga otra mejora de daño y quita un contenedor de corazón"
		},
		pl = {
			"{{Collectible332}} Jeżeli Wskrzeszony Łazarz umrze, then trynkiet jest niszczony i jest on znowu wskrzeszony",
			"#Odrodzenie daje kolejny bonus do obrażeń i zabiera kolejne serduszko"
		},
	},
	[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			" случайных брелка(ов) при подборе",
			"#Еффекты брелков пропадают когда Пироженое выбрасывается"
		},
		spa = {
			"{{Trinket}} Traga ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" trinkets aleatorios al tenerlo",
			"#Los efectos de los trinkets se pierden al soltar el Pastel de Cumpleaños"
		},
		pl = {
			"{{Trinket}} Połyka ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" losowe trynkiety po podniesieniu",
			"#Efekty trynkietów są tracone, jeżeli tenk trynkiet zostanie upuszczony"
		},
	},
	[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			"{{Collectible677}} Временно замедляет врагов и даёт убывающее повышение скорострельности при потере Святой Мантии",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
				"Дополнительно замораживает врагов в %s радиусе на 5 секунд",
				"маленьком",
				"среднем",
				"большом"
			) end
		},
		spa = {
			"{{Collectible677}} Ralentiza a los enemigos temporalmente y otorga una mejora de lágrimas al romperse el Manto Sagrado",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
				"Adicionalmente petrifica a los enemigos en un radio %s por 5 segundos",
				"pequeño",
				"mediano",
				"grande"
			) end
		},
		pl = {
			"{{Collectible677}} Tymczasowo spowalnia przeciwników i zwiększa szybkostrzelność po straceniu osłony",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
				"Dodatkowo paraliżuje przeciwników w %s promieniu na 5 sekund",
				"małym",
				"średnim",
				"dużym"
			) end
		},
	},
	[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Familiars have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% chance to mimic Lilith's tear effects"
		},
		ru = {
			"Спутники имеют ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% шанс скопировать эффекты слёз Лилит"
		},
		spa = {
			"Los familiares tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% de copiar los efecos de lágrima de Lilith"
		},
		pl = {
			"Sojusznicy mają ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% szansy na skopiowanie efektów łez Lilit"
		},
	},
	[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
		spa = {
			"{{Shop}} Las tiendas y las {{DevilRoom}} Salas del Demonio contienen ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "cinco centavos", " monedas de cinco centavos")
			end
		},
		pl = {
			"{{Shop}} Sklepy i {{DevilRoom}} pokoje Diabła zawierają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "piątaka", " piątaki")
			end
		},
	},
	[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			"#Поглощённые брелки проглатываются, сохраняя свои еффекты до тех пор, пока Пустота удерживается в руках",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
				"%s шанс дублировать поглощённый брелок"
			) end
		},
		spa = {
			"{{Collectible477}} El Vacío puede absorber trinkets",
			"#Los trinkets absorbidos son tragados, manteniendo sus efectos permanentemente mientras que el jugador tenga el Vacío",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
				"%s de probabilidad de duplicar el trinket absorbido"
			) end
		},
		pl = {
			"{{Collectible477}} Pustka może niszczyć trynkiety",
			"#Zniszczone trynkiety są połykane, zachowując swoje efekty, póki Pustka jest trzymana",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
				"%s szansy na skopiowanie zniszczonych trynkietów"
			) end
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {		-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(player, descObj.ObjSubType)
			local baseNum, maxNum = 1 * trinketMult, 3 * trinketMult

			return BIRTHCAKE_EID:GoldConditional(baseNum .. "-" .. maxNum, trinketMult)
		end,
		en_us = {
			"Firing at {{Player16}}The Forgotten's body as {{Player17}}The Soul will cause ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			" bone fragment tears to fire out of it in random directions and fill it with \"soul charge\"",
			"#Returning to The Forgotten will grant a fading fire rate increase depending on how much soul charge they were filled with"
		},
		ru = {
			"Стреляя в тело {{Player16}}Забытого {{Player17}}Душой приведёт к выстреливании из него ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			" осколков костей в случайных направлениях и заполнении его \"зарядом души\"",
			"#Возращение в Забытого даст убывающее повышение скорострельности в зависимости от того, насколько много заряда души он имеет"
		},
		spa = {
			"Disparar al cuerpo de {{Player16}}El Olvidado como {{Player17}}El Alma causa que ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			" fragmentos de hueso sean disparados en direcciones aleatorias y llena a El Olvidado con \"carga de alma\"",
			"#Volver al cuerpo otorga una mejora desvaneciente de lágrimas dependiendo de cúanta carga de alma tuviera"
		},
		pl = {
			"Strzelanie w {{Player16}}Ciało Zapomnianego jako {{Player17}}Dusza wystrzeliwywuje ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			" odłamków kości w losowych kierunkach i ładuje ciało \"ładunkiem dusz\"",
			"#Powrót to Ciała daje zanikający bonus do szybkostrzelności zależnie od ładunku"
		},
	},
	[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible584}} Using an active item has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% chance to spawn an additional wisp of the same type"
		},
		ru = {
			"{{Collectible584}} Использование активного предмета имеет ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% шанс создания дополнительного огонька того же типа"
		},
		spa = {
			"{{Collectible584}} Usar un activo tiene una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% de generar un fuego adicional del mismo tipo"
		},
		pl = {
			"{{Collectible584}} Użycie aktywnego przedmiotu ma ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% szansy na stworzenie dodatkowego ognika tego samego typu"
		},
	},
	[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"The holder will reflect all damage they take onto the other brother"
		},
		ru = {
			"Держащий брат будет перенаправлять весь получаемый урон на другого брата"
		},
		spa = {
			"El propietrio refleja todo el daño al otro hermano"
		},
		pl = {
			"Właściciel przekierowywuje otrzymane obrażenia do drugiego brata"
		},
	},
	[PlayerType.PLAYER_ISAAC_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Grants an additional inventory slot"
		},
		ru = {
			"Даёт дополнительный слот инвентаря"
		},
		spa = {
			"Otorga un espacio de inventario adicional"
		},
		pl = {
			"Daje dodatkowe miejsce w ekwipunku"
		},
	},
	[PlayerType.PLAYER_MAGDALENE_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Dropped hearts eventually explode into pools of red creep",
			"#Explosion damage depends on the heart type and the current stage"
		},
		ru = {
			"Выпавшие сердца в конце концов взрываются и оставляют лужи крови",
			"#Урон от взрыва зависит от типа сердца и текущего этажа"
		},
		spa = {
			"Los corazones soltados eventualmente explotan en piscinas de creep roja",
			"#El daño de la explosion depende del tipo de corazón y el piso actual"
		},
		pl = {
			"Upuszcone serduszka po pewnym czasie wybuchają w kałuże czerwonej mazi",
			"#Siła eksplozji zależy od typu serduszka i piętra"
		},
	},
	[PlayerType.PLAYER_CAIN_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Double pickups that spawn are split into their halves"
		},
		ru = {
			"Двойные подбираемые предметы распадаются на их половины"
		},
		spa = {
			"Los recolectables dobles que se generan de dividen en sus medias partes"
		},
		pl = {
			"Podwójne pickupy są dzielone na połówki"
		},
	},
	[PlayerType.PLAYER_JUDAS_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			"{{Collectible705}} Прохождение сквозь врагов под Темными Искусствами уменьшает их время зарядки на ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
		spa = {
			"{{Collectible705}} Atravesar enemigos con las Artes Oscuras disminuye su tiempo de carga en ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
		pl = {
			"{{Collectible705}} Trafiane przeciwników Mrocznymi Technikami skraca ich odnowienie o ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
	},
	[PlayerType.PLAYER_BLUEBABY_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Thrown poops have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% chance to not be damaged when hit by projectiles"
		},
		ru = {
			"Бросаемые какашки имеют ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% шанс не повредиться, когда в них попадают снаряды"
		},
		spa = {
			"Las cacas tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% de no ser dañadas al ser golpeadas por proyectiles"
		},
		pl = {
			"Rzucone kupy ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% szansy na nie otrzymanie obrażeń po trafieniu"
		},
	},
	[PlayerType.PLAYER_EVE_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Blood clots leave behind a small pool of damaging creep on death",
			"#The damage and effects of the creep depend on the type of clot killed"
		},
		ru = {
			"Кровяные сгустки оставляют маленькую наносящую урон лужу при смерти",
			"#Урон и эффекты лужи зависят от типа умершего сгустка"
		},
		spa = {
			"Los coágulos de sangre dejan atrás un pequeño charco de creep que hace daño a enemigos al morir",
			"#El daño y los efectos del creep dependen del tipo de coágulo muerto"
		},
		pl = {
			"Zakrzepki zostawiają za sobą mają kałuże mazi po śmierci",
			"#Obrażenia i dodatkowe efekty mazi zależą od typu zabitego Zakrzepka"
		},
	},
	[PlayerType.PLAYER_SAMSON_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible704}} Clearing a room while in Berserk has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% chance to extend its length by 5 seconds and spawn a {{HalfHeart}} half red heart"
		},
		ru = {
			"{{Collectible704}} Зачистка комнаты под действием Берсерка имеет ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% шанс увеличить его длительность на 5 секунд и создать {{HalfHeart}} половину красного сердца"
		},
		spa = {
			"{{Collectible704}} Limpiar una habitación en estado de Berserker tiene una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% de extender su duración en 5 segundos y generar {{HalfHeart}} medio Corazón Rojo"
		},
		pl = {
			"{{Collectible704}} Ukończenie pokoju w stanie Berserka ma ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% szansy na wydłużenie czasu trwania o 5 sekund i stworzenie {{HalfHeart}} połowy czerwonego serduszka"
		},
	},
	[PlayerType.PLAYER_AZAZEL_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Sneezing fires out a cluster of 6 booger tears that deal a portion of Azazel's damage",
			"#{{Collectible459}} Tears have a ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% chance to stick onto enemies to damage them over time"
		},
		ru = {
			"При чихании выстреливает скопление из 6 соплей, наносящих часть урона Азазеля ", --we have word declension in russian, so "козявка" isn't accurate + "сопля" is better
			"#{{Collectible459}} Слёзы имеют ",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% шанс прилипнуть к врагам для нанесения урона со временем"
		},
		spa = {
			"Estornudar dispara 6 lágrimas de moco que hacen una porción del daño de Azazel",
			"#{{Collectible459}} Las lágrimas tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% de pegarse a enemigos y hacerles daño con el tiempo"
		},
		pl = {
			"Kichanie wystrzeliwywuje 6 smarków, które zadają ułamek Obrażeń Azazela",
			"#{{Collectible459}} Smarki mają ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% szansy na przyczepienie się do przeciwników, zadając obrażenia rozłożone w czasie"
		},
	},
	[PlayerType.PLAYER_LAZARUS_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Collectible711}} When using Flip, item pedestals have a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LAZARUS.ITEM_SPLIT_CHANCE)
			end,
			"% chance to split into both collectibles displayed"
		},
		ru = {
			"{{Collectible711}} При использовании Переворота пьедесталы с предметами имеют ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LAZARUS.ITEM_SPLIT_CHANCE)
			end,
			"% шанс разделиться на оба отображаемых предмета"
		},
		spa = {
			"{{Collectible711}} Al usar Flip, los objetos de pedestal tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LAZARUS.ITEM_SPLIT_CHANCE)
			end,
			"% de dividirse en ambos objetos mostrados"
		},
		pl = {
			"{{Collectible711}} Po użyciu Odwrotu, przedmioty mają ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LAZARUS.ITEM_SPLIT_CHANCE)
			end,
			"% szansy na rozdzielenie się na oba pokazane przedmioty"
		},
	},
	[PlayerType.PLAYER_EDEN_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Taking damage has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
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
		spa = {
			"Recibir daño tiene una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% de no rerollear los objetos de Eden",
			"#Este trinket es casi inmune a ser rerolleado, teniendo una probabilidad del "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% de ser rerolleado al recibir daño"
		},
		pl = {
			"Przy otrzymaniu obrażeń ma ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% szansy na nie przelosowanie przedmiotów Edenu",
			"#Ten trynkiet jest częściowo odporny na przelosowanie, mając "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% na przelosowanie przy otrzymaniu obrażeń"
		},
	},
	[PlayerType.PLAYER_THELOST_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"{{Card51}} Spawns a Holy Card when first picked up",
			"#Cards have another ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% chance of becoming a Holy Card"

		},
		ru = {
			"{{Card51}} Создаёт Святую Карту при первом подборе",
			"#Карты имеют ещё ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% шанс стать Святой Картой"
		},
		spa = {
			"{{Card51}} Genera una Carta Sagrada al recoger el trinket por primera vez",
			"#Las cartas tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% de transformarse en una Carta Sagrada"

		},
		pl = {
			"{{Card51}} Daje Świętą Kartę po pierwszym podniesieniu",
			"#Karty mają dodatkowe ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% szansy na stanie się Świętą Kartą"
		},
	},
	[PlayerType.PLAYER_LILITH_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Whipping out Lilith's Gello has a",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% chance to spawn another Gello",
			"#The additional Gello deals 50% damage"
		},
		ru = {
			"Выхлёстывание Гелло Лилит имеет",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% шанс создать ещё одного Гелло",
			"#Дополнительный Гелло наносит 50% урона"
		},
		spa = {
			"Disparar Gello tiene una probabilidad del",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% de generar un Gello adicional",
			"#El Gello adicional hace el 50% de tu daño"
		},
		pl = {
			"Wystrzelenie Gello ma",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% szansy na wystrzelenie drugiego Gello",
			"#Drugi Gello zadaje 50% obrażeń"
		},
	},
	[PlayerType.PLAYER_KEEPER_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Spawns an item and 2 pickups for sale at the start of each floor"
		},
		ru = {
			"Создаёт предмет и 2 подбираемых предмета на продажу в начале каждого этажа"
		},
		spa = {
			"Genera un objeto y 2 recolectables a la venta al principio de cada piso"
		},
		pl = {
			"Tworzy przedmiot i dwa pickupy na sprzedaż na początku każdego piętra"
		},
	},
	[PlayerType.PLAYER_APOLLYON_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
		spa = {
			"{{Collectible706}} Los trinkets se pueden transformar en langostas usando Abismo",
			"#Las langostas generadas de trinkets hacen ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" de daño"
		},
		pl = {
			"{{Collectible706}} Czeluść może zamieniać trynkiety w szarańcze",
			"#Szarańcze stworzone z trynkietów zadają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" obrażeń"
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {		-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Killing enemies will spawn stationary bone fragments that damage enemies on contact",
			"#Holding {{Player35}}The Forgotten will cause all bone fragments to fly towards {{Player40}}The Soul, becoming orbitals",
			"#Can have up to ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" orbitals"
		},
		ru = {
			"Убийство врагов создаст неподвижные осколки костей, наносящие урон врагам при контакте",
			"#Подбирание {{Player35}}Забытого заставит все осколки костей полететь к {{Player40}}Душе, становясь орбитальными",
			"#Может иметь до ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" орбитальных осколков костей"
		},
		spa = {
			"Matar enemigos genera fragmentos de hueso inmóviles que hacen daño a los enemigos al entrar en contacto",
			"#Recoger a {{Player35}}El Olvidado atrae a todos los fragmentos de hueso a {{Player40}}El Alma, convirtiéndose en orbitales",
			"#Puede tener hasta ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" orbitales"
		},
		pl = {
			"Zabici przeciwnicy zostawiają po sobie lewitujące kości, które zadają obrażenie innym przeciwnikom",
			"#Podniesienie {{Player35}}Ciała przyciąga wszystkie kości do {{Player40}}Duszy, po czym zaczynają ją orbitować",
			"#Można mieć maksymalnie ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" kości"
		},
	},
	[PlayerType.PLAYER_BETHANY_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
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
			"{{Collectible712}} Огоньки Лемегетона имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" дополнительного здоровья"
		},
		spa = {
			"{{Collectible712}} Los fuegos de Lemegeton pueden tomar ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" golpes adicionales"
		},
		pl = {
			"{{Collectible712}} Ogniki Lemegetona mogą otrzymać dodatkowe ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" uderzeń"
		},
	},
	[PlayerType.PLAYER_JACOB_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [X] | PT_BR [X]
		en_us = {
			"Dark Esau leaves behind small flames when flying, blocking tears and enemy projectiles",
			"#The flames can damage both Jacob and enemies"
		},
		ru = {
			"Тёмный Исав оставляет за собой огонь при полете, блокирующий слёзы и снаряды врагов",
			"#Огонь может наносить урон и Иакову, и врагам"
		},
		spa = {
			"Esaú Oscuro deja un rastro pequeño de llamas al atacar, bloqueando lágrimas y proyectiles enemigos",
			"#Las llamas pueden dañar a ambos Jacob y los enemigos"
		},
		pl = {
			"Mroczny Ezaw zostawia za sobą płomienie, które blokują łzy i wrogie pociski",
			"#Płomienie są w stanie zranić Jakuba i przeciwników"
		},
	},
}

BIRTHCAKE_EID.ShortDescriptions = {
	DEFAULT_EFFECT = {							-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			local statMult = Mod.Birthcake.DEFAULT_EFFECT:GetStatMult(trinketMult)
			statMult = BIRTHCAKE_EID:AdjustNumberValue(statMult)

			return BIRTHCAKE_EID:GoldConditional(statMult, trinketMult)
		end,
		en_us = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"% to all stats"
		},
		ru = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"% ко всем характеристикам"
		},
		spa = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"% a todas las estadísticas"
		},
	},
	APOLLYON_B_APPEND = {						-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [X] | KO_KR [X] | PT_BR [X]
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
		},
		ru = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
				"Серая саранча, наносящая х0.5 урона",
				"Красная саранча, наносящая полный урон"
				)
			end
		},
		spa = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
				"Langostas grises que hacen la mitad del daño",
				"Langostas rojas que hacen el daño entero"
				)
			end
		},
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
				local _, spritePath = Mod:GetBirthcakeSprite(player)

				sprite:ReplaceSpritesheet(1, spritePath)
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
	"Apollyon B Birthcake",
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
