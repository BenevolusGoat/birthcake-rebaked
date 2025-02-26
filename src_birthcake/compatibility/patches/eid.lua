--Huge credit to Epiphany for this fluid EID support
local Mod = BirthcakeRebaked
local game = Mod.Game

local BIRTHCAKE_EID = {}
BirthcakeRebaked.EID = BIRTHCAKE_EID

if not EID then return end

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

BIRTHCAKE_EID.SHARED_DESCRIPTIONS = {
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

local max = math.max
local min = math.min
local ceil = math.ceil

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

-- !TRANSLATION PROGRESS
-- EN: 36/36 | RU: 36/36 | SPA: 36/36 | CS_CZ: 36/36 | PL: 34/36 | KO_KR 36/36 | PT_BR 36/36 | ZH_CN 36/36

BIRTHCAKE_EID.Descs = {
	[PlayerType.PLAYER_ISAAC] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		---@param descObj EID_DescObj
		---@param str string
		_modifier = function(descObj, str, strMult)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity),
				descObj.ObjSubType)

			if trinketMult > 1 then
				return "{{ColorGold}}" .. trinketMult .. "{{CR}}" .. strMult
			end

			return str
		end,
		en_us = {
			"Spawns ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "a {{Card49}}Dice Shard",
					" {{Card49}}Dice Shards")
			end,
			" on pickup and in the starting room of every floor"
		},
		ru = {
			"Создаёт ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "{{Card49}}Осколок Кости",
					" {{Card49}}Осколка Кости")
			end,
			" при подьёме и в стартовой комнате каждого этажа"
		},
		spa = {
			"Genera ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "un {{Card49}} Fragmento de Dado",
					" {{Card49}} Fragmentos de Dado")
			end,
			" Al recogerlo y en la habitación inicial de cada piso"
		},
		cs_cz = {
			"Vytvoří ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "{{Card49}} Úlomek Kostky",
					" {{Card49}} Úlomky Kostky")
			end,
			" po zvednutí a ve startovací místnosti každé podlaží",
		},
		pl = {
			"Tworzy ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, " {{Card49}} Odłamek Kości",
					" {{Card49}} Odłamki Kości")
			end,
			" przy pierwszym podniesieniu i na początku każdego piętra"
		},
		pt_br = {
			"Ganhe ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "um {{Card49}} Dice Shard", " {{Card49}} Dice Shards")
			end,
			" ao pegar e na sala inicial de todos os andares"
			},
		ko_kr = {
			"습득 시, 그리고 새로운 층에 진입 시 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "um {{Card49}} 주사위 조각", " {{Card49}} 주사위 조각 여러 개")
			end,
			" 를 생성합니다."
			},
		zh_cn = {
			"拾取后+进入新楼层时，生成",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_ISAAC]._modifier(descObj, "一个{{Card49}} 骰子碎片",
					" {{Card49}} 骰子碎片")
			end,
			""
			},
	},
	[PlayerType.PLAYER_MAGDALENE] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"{{Heart}} Corações tem uma ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% chance de serem melhorados",
			"#Possiveís melhorias são:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
		ko_kr = {
			"{{Heart}} 하트 픽업이 ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"% 의 확률로 다음과 같이 업그레이드됩니다:",
			"#가능한 업그레이드 종류류:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
		zh_cn = {
			"{{Heart}} 心掉落物有",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.MAGDALENE.HEART_REPLACE_CHANCE)
			end,
			"%的概率被升级",
			"#示例:",
			"#{{HalfHeart}} -> {{Heart}} -> {{Heart}}{{Heart}}",
			"#{{HalfSoulHeart}} -> {{SoulHeart}}"
		},
	},
	[PlayerType.PLAYER_CAIN] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		---@param descObj EID_DescObj
		---@param baseChance number | fun(player: EntityPlayer): number
		_modifier = function(descObj, baseChance)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType)
			baseChance = type(baseChance) == "function" and baseChance(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)) or
			baseChance
			---@cast baseChance number
			local chance = Mod:GetBalanceApprovedChance(baseChance, mult)
			chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

			return BIRTHCAKE_EID:GoldConditional(chance, mult)
		end,
		en_us = {
			"{{Slotmachine}} Slot Machines and {{FortuneTeller}} Fortune Telling Machines have a ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)                                                       --used regular slot chance cuz they're the same
			end,
			"% chance to refund money",
			"#{{CraneGame}} Crane Games have a ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% chance to refund money"
		},
		ru = {
			"{{Slotmachine}} Игровые Автоматы и {{FortuneTeller}} Автоматы для Предсказаний имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)
			end,
			"% шанс возвратить деньги",
			"#{{CraneGame}} Кран-Машины имеют ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% шанс возвратить деньги"
		},
		spa = {
			"{{Slotmachine}} Las Máquinas Tragaperras y las {{FortuneTeller}} Máquinas de Adivinación del Futuro tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)                                                       --used regular slot chance cuz they're the same
			end,
			"% de reembolsar dinero",
			"#{{CraneGame}} Los Juegos de Grúa tienen una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% de reembolsar dinero",
		},
		cs_cz = {
			"{{Slotmachine}} Hrací automaty a {{FortuneTeller}} Věštecké automaty mají ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)                                                       --used regular slot chance cuz they're the same
			end,
			"% šanci na vrácení peněz",
			"#{{CraneGame}} Jeřábová hra má ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% šanci na vrácení peněz",
		},
		pl = {
			"{{Slotmachine}} Automaty do Gier i {{FortuneTeller}} Automaty z Wróżbami mają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)                                                       --used regular slot chance cuz they're the same
			end,
			"% szansy na zwrot pieniędzy",
			"#{{CraneGame}} Chwytaki mają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% szansy na zwrot pieniędzy"
		},
		pt_br = {
			"{{Slotmachine}} Caça-Níqueis e {{FortuneTeller}} máquinas cartomante tem uma ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)
			end,
			"% chance de te dar um reembolso",
			"#{{CraneGame}} máquinas de ursinho tem ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj, Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"% chance de dar reembolso"
},
		ko_kr = {
			"{{Slotmachine}} {{FortuneTeller}} 슬롯 머신과 점술 기계가 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)                                                       --used regular slot chance cuz they're the same
			end,
			"%의 확률로 돈을 반환합니다.",
			"#{{CraneGame}} 뽑기 기계가 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"%의 확률로 돈을 반환합니다."
		},
		zh_cn = {
			"{{Slotmachine}}抽奖机和{{FortuneTeller}}占卜机有",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.SLOT_MACHINE].RefundChance)
			end,
			"%的概率返还钱币",
			"#{{CraneGame}}抓娃娃机有",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_CAIN]._modifier(descObj,
					Mod.Birthcake.CAIN.SlotsData[Mod.SlotVariant.CRANE_GAME].RefundChance)
			end,
			"%的概率返还钱币"
		},
	},
	[PlayerType.PLAYER_JUDAS] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
			"#{{DevilRoom}} Если взятие предмета Дьявольской Сделки убьёт Иуду, то будет использован брелок вместо этого"
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
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
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
		pt_br = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% multiplicador de dano",
			"#{{DevilRoom}} Se pegar um trato com o demônio fosse fatal, esse berloque será consumido no lugar"
		},
		ko_kr = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"% 공격력 배수 적용 ",
			"#{{DevilRoom}} 악마 거래용으로 하트가 충분치 않을 경우, 유다가 사망하는 대신 이 장신구가 소모됩니다."
		},
		zh_cn = {
			"{{ArrowUp}} {{Damage}} +",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.JUDAS.DAMAGE_MULT_UP)
			end,
			"%伤害倍率",
			"#{{DevilRoom}} 进行可能致死的恶魔交易时，改为消耗这个饰品换取道具"
		},
	},
	[PlayerType.PLAYER_BLUEBABY] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
					local poopSpawns = max(1, ceil(maxCharge / 2))
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
					.. "#{{Collectible}} Has a different effect with other actives",
					"#{{Collectible}} Fires out %s poop projectile(s) in random directions that spawn a poop when landing",
					"#{{Battery}} X is half your max active charge rounded down",
					"{{Collectible}} No effect for current active"
				)
			end
		},
		ru = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
					"{{Collectible36}} При использовании Какашка создаёт 2 дополнительных какашки по обеим сторонам от оригинальной, ориентация зависит от направления головы"
					.. "#{{Collectible}} Имеет другой эффект с остальными активируемыми предметами",
					"#{{Collectible}} Выстреливает %s снаряд(ов)-какашку(ек) в случайных направлениях, которые создают какашку при столкновении",
					"#{{Battery}} X - это половина заряда твоего активного предмета, округлённая в меньшую сторону",
					"{{Collectible}} Нет эффекта для текущего активного предмета"
				)
			end
		},
		spa = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
					"{{Collectible36}} La Caca genera 2 cacas adicionales en ambos lados de la original al usarse, la orientación basándose en la direccion de la cabeza"
					.. "#{{Collectible}} Tiene un efecto distinto con activos diferentes",
					"#{{Collectible}} Suelta %s proyectil(es) de caca en direcciones aleatorias que generan una caca al tocatr el suelo",
					"#{{Battery}} X es la mitad de las cargas máximas de tu acticvo redondeadas hacia abajo",
					"{{Collectible}} Sin efecto para to activo actual"
				)
			end
		},
		pl = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
					"{{Collectible36}} Kupa tworzy 2 dodatkowe kupy po bokach przy użyciu, pozycja zależy od kierunku głowy"
					.. "#{{Collectible}} Ma inny efekt zależnie od użytego przedmiotu",
					"#{{Collectible}} Wystrzeliwywuje %s procisków w losowych kierunkach, które stają się kupami po lądowaniu",
					"#{{Battery}} X jest połową maksymalnych ładunków przedmiotu, zaokroglając w dół",
					"{{Collectible}} Nie robi nic z aktualnym przedmiotem aktywnym"
				)
			end
		},
		pt_br = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
				"{{Collectible36}} O Cocô invoca 2 cocôs extras nos lados do original ao ser usado, orientação sendo baseada na direção da cabeça"
				.."#{{Collectible}} Tem um efeito differente com outros ativos",
				"#{{Collectible}} Atira %s projetéis de cocô em direções aleatórias que viram cocos ao cair no chão",
				"#{{Battery}} X é metade da carga do seu item ativo, arrendondado para baixo",
				"{{Collectible}} Nenhum efeito para o ativo atual"
			) end
		},
		ko_kr = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
					"{{Collectible36}} 똥을 싸면 ???가 바라보는 방향 기준 똥 2덩이를 추가로 쌉니다."
					.. "#{{Collectible}} 다른 액티브 아이템 사용 시 효과가 달라집니다. ",
					"#{{Collectible}} 착탄 지점에 똥을 생성하는 발사체를 %s발 무작위 방향으로 발사합니다.",
					"#{{Battery}} X는 액티브 아이템의 최대 충전 요구량의 절반을 내림한 값입니다. ",
					"{{Collectible}} 현재 소유 중인 액티브를 대상으로는 효과 없음"
				)
			end
		},
		zh_cn = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
					"{{Collectible36}} 大便会额外生成2个大便以组成屎墙"
					.. "#{{Collectible}} 与其他主动道具具有不同兼容",
					"#{{Collectible}} 朝随机方向发射 %s 个大便泪弹，落地生成大便",
					"#{{Battery}} X =主动充能数的一半向下取整",
					"{{Collectible}} 与当前主动无效果"
				)
			end
		},
		cs_cz = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BLUEBABY]._modifier(descObj,
					"{{Collectible36}} Hovno vytvoří 2 hovna na bocích hráče, orientace záleží na směru hlavy"
					.. "#{{Collectible}} Má jiný efekt s ostatními použitelnými předměty",
					"#{{Collectible}} Vystřelí %s hovnové projektily v náhodněm směru které vytvoří hovno když dopadnou",
					"#{{Battery}} X je polovina maximálního nabití tvého použitelného předmětu zaokrouhleno dolů",
					"{{Collectible}} Žádný efekt pro aktuální použitelný předmět"
				)
			end
		},
	},
	[PlayerType.PLAYER_EVE] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"{{Collectible117}} Transforma o Pássaro Morto em o Pássaro de Sangue",
			"#O Pássaro de Sangue deixa uma pequena trilha de sangue que danifica os inimigos",
			"#O dano do Pássaro de Sangue escala com o dano de Eva",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "Double damage")
			end
		},
		ko_kr = {
			"{{Collectible117}} 죽은 새가 피투성이 새로 변합니다.",
			"#피투성이 새는 주기적으로 피해를 주는 피 장판을 생성합니다. ",
			"#피투성이 새의 피해량은 이브의 공격력에 비례합니다.",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "피해량 2배")
			end
		},
		zh_cn = {
			"{{Collectible117}} 将死鸟变成血鸟",
			"#血鸟会持续留下小片伤害血迹",
			"#血鸟的伤害受面板攻击力影响",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "伤害翻倍")
			end
		},
		cs_cz = {
			"{{Collectible117}} Změní Mrtvého Ptáka na Krvavého Ptáka", -- lol
			"#Krvavý Pták za sebou pravidelně zanechává krvavé kaluže",
			"#Poškození Krvavého Ptáka je rovné poškození Evy",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EVE]._modifier(descObj, "Dvojité poškození")
			end
		},
	},
	[PlayerType.PLAYER_SAMSON] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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

				)
			end
		},
		ru = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
					"{{Collectible157}} Достижение максимального увеличения урона от Жажды Крови создаёт ",
					"2 {{Heart}} Красных Сердца",
					"2 сердца, зависящих от твоего текущего здоровья"
					..
					"#{{Heart}} Двойные Красные Сердца при здоровье меньше половины красного сердца, и Красные Сердца при здоровье больше или равному половине красного сердца"
					.. "#{{SoulHeart}} Иначе создаёт Сердца Души",
					"#{{Collectible619}} Срабатывает и на 6, и на 10 ударе"

				)
			end
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
				)
			end
		},
		pl = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
					"{{Collectible157}} Osiągnięcie maksymalnego bonusu z Krwawej Żądzy daje ",
					"2 {{Heart}} czerwone serduszka",
					"2 serduszka zależne od aktualnego zdrowia"
					..
					"#{{Heart}} podwójne czerwone serduszka mając mniej niż połowe czerwonego zdrowia, czerwona serduszka mając mając więcej zdrowia"
					.. "#{{SoulHeart}} w innym przypadky daje serduszka dusz",
					"#{{Collectible619}} Aktywuje się po 6 oraz 10 uderzeniach"

				)
			end
		},
		pt_br = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
				"{{Collectible157}} Ao alcançar o máximo de aumento de dano com sede de sangue, você ganha ",
				"2 {{Heart}} corações vermelhos",
				"2 corações baseado na sua vida atual"
				.. "#{{Heart}} Corações Duplos se estiver com menos de meio coração, e Corações Vermelhos se sua vida estiver acima ou igual a meio coração"
				.. "#{{SoulHeart}} Ganhe corações de alma caso contrário",
				"#{{Collectible619}} Ativa no 6 e 10 dano"

			) end
		},
		ko_kr = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
					"{{Collectible157}} 피의 욕망 분노 게이지 최대치 달성 시 ",
					"2 {{Heart}} 빨간 하트 2개를 생설합니다.",
					"현재 체력에 따라 다음과 같이 하트 2개를 생성합니다:"
					.. "#{{Heart}} 체력이 빨간 하트 반 개 미만인 경우, 더블 하트 생성, 반 개 이상인 경우 일반 빨간 하트 생성"
					.. "#{{SoulHeart}} 이외의 경우 소울 하트 생성",
					"#{{Collectible619}} 6회 피격 시, 그리고 10회 피격 시에, 총 두 번 발동 "

				)
			end
		},
		zh_cn = {
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_SAMSON]._modifier(descObj,
					"{{Collectible157}} 嗜血提供的伤害达到最大值时",
					"掉落2 {{Heart}} 红心",
					"根据角色当前的血量掉落2个心"
					.. "#{{Heart}} 少于半血生成双红心, 大于半血生成整红心"
					.. "#{{SoulHeart}} 满血则生成魂心",
					"#{{Collectible619}} 可以在第6和第10次触发嗜血时生效"

				)
			end
		},
	},
	[PlayerType.PLAYER_AZAZEL] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = {
			"{{ArrowDown}} {{Damage}} -",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"% damage multiplier",
			"#Brimstone blasts last longer while damaging enemies"
		},
		ru = {
			"{{ArrowDown}} {{Damage}} -",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"% множитель урона",
			"#Луч Серы длится дольше во время нанесения урона врагам"
		},
		spa = {
			"{{ArrowDown}} {{Damage}} Multiplicador de daño de -",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"#Las ráfagas de Azufre duran más al hacer daño a enemigos"
		},
		pl = {
			"{{ArrowDown}} {{Damage}} -",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"% Násobitel poškození",
			"#Splunięcie laserem trwa dłużej"
		},
		ko_kr = {
			"{{ArrowDown}} {{Damage}} 공격력 배수",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"%",
			"#아자젤이 발사하는 혈사포의 지속 시간이 증가합니다"
		},
		pt_br = {
			"{{ArrowDown}} {{Damage}} -",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"% multiplicador de dano",
			"#Enxofre dura mais tempo se danificando inimigos"
		},
		zh_cn = {
			"{{ArrowDown}} {{Damage}} -",
			function()
				return tostring(BIRTHCAKE_EID:AdjustNumberValue(Mod.Birthcake.AZAZEL.DAMAGE_MULT_DOWN))
			end,
			"% 伤害倍率",
			"#血激光柱在造成伤害后会持续更长时间"
		},
	},
	[PlayerType.PLAYER_LAZARUS] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"{{Collectible332}} Se Lazáro Ressucitado morre, esse berloque é consumido e ele é reanimado novamente",
			"#Essa ressucitação dá um aumento no dano e remove um coração"
		},
		ko_kr = {
			"{{Collectible332}} 부활한 나사로가 죽으면 이 장신구를 소모하고 나사로의 부활 후 효과를 1번 더 발동합니다.", --참 쉽죠?
		},
		zh_cn = {
			"{{Collectible332}} 复活的拉撒路死亡后, 消耗这个饰品再复活一次",
			"#同样提供攻击力加成并失去1心之容器"
		},
		cs_cz = {
			"{{Collectible332}} Když Povstalý Lazar zemře, tato cetka je zničena a znovu povstane",
			"#Toto povstání přidá bonusové poškození a odebere jedno zdraví"
		},
	},
	[PlayerType.PLAYER_EDEN] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		---@param descObj EID_DescObj
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity),
				descObj.ObjSubType)
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
		pt_br = {
			"{{Trinket}} Consome ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" Berloques aleatórios em quanto segurado",
			"#Os efeitos dos berloques são perdidos se o bolo de nascimento for removido"
		},
		ko_kr = {
			"{{Trinket}} 소지 시 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			"개의 무작위 장신구가 흡수됩니다.",
			"#{{Warning}} 케이크를 내려놓으면 흡수된 장신구의 효과도 없어집니다."
		},
		zh_cn = {
			"{{Trinket}} 持有时, 吞下",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" 个随机饰品",
			"#丢弃蛋糕会失去这些饰品的效果"
		},
		cs_cz = {
			"{{Trinket}} Spolkne ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_EDEN]._modifier(descObj)
			end,
			" náhodných cetek při držení",
			"#Efekty cetek jsou ztraceny pokud je Narozeninový Dort zahozen"
		},
	},
	[PlayerType.PLAYER_THELOST] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		_modifier = function(descObj, str, ...)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity),
				descObj.ObjSubType)
			if trinketMult > 1 then
				local multWord = { ... }
				return "#{{ColorGold}}" .. str:format(multWord[min(3, trinketMult - 1)]) .. "{{CR}}"
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
				)
			end
		},
		ru = {
			"{{Collectible677}} Временно замедляет врагов и даёт убывающее повышение скорострельности при потере Святой Мантии",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
					"Дополнительно замораживает врагов в %s радиусе на 5 секунд",
					"маленьком",
					"среднем",
					"большом"
				)
			end
		},
		spa = {
			"{{Collectible677}} Ralentiza a los enemigos temporalmente y otorga una mejora de lágrimas al romperse el Manto Sagrado",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
					"Adicionalmente petrifica a los enemigos en un radio %s por 5 segundos",
					"pequeño",
					"mediano",
					"grande"
				)
			end
		},
		pl = {
			"{{Collectible677}} Tymczasowo spowalnia przeciwników i zwiększa szybkostrzelność po straceniu osłony",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
					"Dodatkowo paraliżuje przeciwników w %s promieniu na 5 sekund",
					"małym",
					"średnim",
					"dużym"
				)
			end
		},
		pt_br = {
			"{{Collectible677}} Temporariamente faz os inimigos ficarem mais lentos e ganhe um aumento na taxa de disparo que lentamente se perde quando o Manto Sagrado se quebra",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
				"Também petrifica inimigos %s raio por 5 segundos",
				"pequeno",
				"médio",
				"largo"
			) end
		},
		ko_kr = {
			"{{Collectible677}} 성스러운 망토 보호막이 깨지면 시간을 잠시 느려지게 하며 일시적으로 연사력이 대폭 상승합니다.",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
					"5초 간 %s 범위 내에 있는 적들이 추가로 석화됩니다.",
					"좁은",
					"중간",
					"넓은은"
				)
			end
		},
		zh_cn = {
			"{{Collectible677}} 护盾破碎后, 暂时停止时间, 并获得临时的射速提升",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
					"额外石化 %s 内的敌人5s",
					"小范围",
					"中等范围",
					"大范围"
				)
			end
		},
		cs_cz = {
			"{{Collectible677}} Dočasně zpomalý nepřátele a přidá chátrající rychlost střelby když je Svatý Plášť rozbitý",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THELOST]._modifier(descObj,
					"Také zkamení nepřátele v %s dosahu na 5 vteřin",
					"malý",
					"střední",
					"velký"
				)
			end
		},
	},
	[PlayerType.PLAYER_LILITH] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Familiares tem uma ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% chance de copiar os efeitos de lágrima de Lilith"
		},
		ko_kr = {
			"패밀리어가 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% 확률로 릴리트의 눈물 효과를 따라합니다."
		},
		zh_cn = {
			"跟班有",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% 的概率模仿角色的泪弹特效"
		},
		cs_cz = {
			"Společníci mají ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SHARE_TEAR_EFFECTS_CHANCE)
			end,
			"% šanci na mimikování Lilithiných efektů slz"
		},
	},
	[PlayerType.PLAYER_KEEPER] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "cinco centavos",
					" monedas de cinco centavos")
			end
		},
		pl = {
			"{{Shop}} Sklepy i {{DevilRoom}} pokoje Diabła zawierają ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "piątaka", " piątaki")
			end
		},
		pt_br = {
			"{{Shop}} Lojas e {{DevilRoom}} Salas do demônio contêm ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "uma níquel", " níqueis")
			end
		},
		ko_kr = {
			"{{Shop}} 상점과 {{DevilRoom}} 악마방에 입장하면 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "니켈 하나가 생성됩니다.", "개의의 니켈이 생성됩니다.")
			end
		},
		zh_cn = {
			"{{Shop}} 商店和 {{DevilRoom}} 恶魔房会有",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "一镍币", " 镍币")
			end
		},
		cs_cz = {
			"{{Shop}} Krámy a {{DevilRoom}} Dábelské místností obsahují ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_KEEPER]._modifier(descObj, "niklák", " nikláky")
			end
		},
	},
	[PlayerType.PLAYER_APOLLYON] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		_modifier = function(descObj, str)
			local mult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity), descObj.ObjSubType,
				true)
			local chance = Mod:GetBalanceApprovedChance(Mod.Birthcake.APOLLYON.DOUBLE_VOID_CHANCE, mult - 1)
			chance = BIRTHCAKE_EID:AdjustNumberValue(chance)

			if mult > 1 then
				return "#" .. BIRTHCAKE_EID:GoldConditional(str:format(chance .. "%"), mult)
			end
		end,
		en_us = {
			"{{Collectible477}} Void can absorb trinkets",
			"#Voided trinkets are gulped, retaining their effects permanently as long as Void is held",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s chance to duplicate the voided trinket"
				)
			end
		},
		ru = {
			"{{Collectible477}} Пустота может поглощать брелки",
			"#Поглощённые брелки проглатываются, сохраняя свои эффекты до тех пор, пока Пустота удерживается в руках",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s шанс дублировать поглощённый брелок"
				)
			end
		},
		spa = {
			"{{Collectible477}} El Vacío puede absorber trinkets",
			"#Los trinkets absorbidos son tragados, manteniendo sus efectos permanentemente mientras que el jugador tenga el Vacío",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s de probabilidad de duplicar el trinket absorbido"
				)
			end
		},
		pl = {
			"{{Collectible477}} Pustka może niszczyć trynkiety",
			"#Zniszczone trynkiety są połykane, zachowując swoje efekty, póki Pustka jest trzymana",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s szansy na skopiowanie zniszczonych trynkietów"
				)
			end
		},
		pt_br = {
			"{{Collectible477}} Vazio consegue absorver berloques",
			"#Berloques consumidos com o Vazio são engolidos, mantendo seu efeitos permanentemente se o Vazio estiver sendo segurado",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
				"%s chance de duplicar o berloque absorvido"
			) end
		},
		ko_kr = {
			"{{Collectible477}} 공허로 장신구도 흡수됩니다.",
			"#이렇게 흡수된 장신구는 삼킨 장신구로 취급되어, 공허를 내려놓기 전까지 그 효과가 유지됩니다.",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s 확률로 흡수된 장신구 복제"
				)
			end
		},
		zh_cn = {
			"{{Collectible477}} 虚空可以吞噬饰品",
			"#持有虚空时, 被吞噬的饰品也会生效",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s 的概率复制被吞噬的饰品"
				)
			end
		},
		cs_cz = {
			"{{Collectible477}} Prázdnota může absorbovat cetky",
			"#Absorbované cetky jsou spolknuty, jejich efekty jsou trvalé po dobu držení Prázdnoty",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON]._modifier(descObj,
					"%s šance pro zduplikování absorbované cetky"
				)
			end
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = { 		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Atirar no {{Player16}}corpo do O Esquecido com a {{Player17}}A Alma causará ",
				function(descObj)
					return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
				end,
			" lágrimas de fragmento de ossos sair do corpo em direções aleatórias e vai enchê-lo com \"carga de alma\"",
			"#Retornar ao O Esquecido dará um aumento na taixa de disparo que lentamente some dependendo na quantidade de carga de alma que ele foi enchido com"
		},
		ko_kr = {
			"{{Player16}}더 포가튼의 해골에 {{Player17}}더 소울의 눈물을 쏘면 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			"개의 뼛조각 눈물이 해골에서 발사되며 \"영혼 충전량\"이 시체에 충전됩니다.",
			"#충전량에 비례해 포가튼의 연사력이 일시적으로 증가합니다"
		},
		zh_cn = {
			"{{Player17}}遗骸之魂的泪弹命中 {{Player16}}遗骸的身体会朝随机方向发射",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			" 个骨头泪弹, 并提供 \"灵能充能\"",
			"#切换会遗骸会根据灵能充能获得临时的射速提升"
		},
		cs_cz = {
			"Střílení na tělo {{Player16}}Zapomenutého za {{Player17}}Duši způsobí vystřelení ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_THEFORGOTTEN]._modifier(descObj)
			end,
			" úlomků kostí v náhodných smerěch naplněnými \"duševním nábojem\"",
			"#Vrácení k Zapomenutému udělí slábnoucí zrychlení střelby záležící na počtu duševních nábojů"
		},
	},
	[PlayerType.PLAYER_BETHANY] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Usar um item ativo tem ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% chance de invocar uma fumaça do mesmo tipo"
		},
		ko_kr = {
			"{{Collectible584}} 액티브 아이템 사용 시  ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% 확률로 같은 종류의 위습 1개가 추가로 생성됩니다."
		},
		zh_cn = {
			"{{Collectible584}} 使用主动技能有 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% 的概率额外生成一个相同的魂火"
		},
		cs_cz = {
			"{{Collectible584}} Při použití použitelného předmětu má ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BETHANY.WISP_DUPE_CHANCE)
			end,
			"% šanci pro vytvoření dodatečné bludičky stejného typu"
		},
	},
	[PlayerType.PLAYER_JACOB] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Todo dano que o irmão segurando o bolo de nascimento tomar será direcionado ao outro irmão"
		},
		ko_kr = {
			"이 장신구를 지닌 쪽이 데미지를 입는 대신 다른 쪽이 그 피해를 대신 입습니다." --병신이네 이거
		},
		zh_cn = {
			"持有者会将受到的伤害反馈到兄弟身上"
		},
		cs_cz = {
			"Držitel odrazí veškeré obdržené poškození na svého bratra"
		},
	},
	[PlayerType.PLAYER_ISAAC_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Dá um espaço extra no inventário"
		},
		ko_kr = {
			"인벤토리 슬롯 +1개" --와! 발라트로! 와! 반물질 바우처!
		},
		zh_cn = {
			"一个额外的物品栏"
		},
		cs_cz = {
			"Udělí další slot v inventáři"
		},
	},
	[PlayerType.PLAYER_MAGDALENE_B] = { 		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Corações temporários explodem em poças de sangue ao desaparecer",
			"#Dano da explosão depende no tipo de coração e no andar atual"
		},
		ko_kr = {
			"떨어진 빨간 하트가 피 장판을 생성하며 터져버립니다.",
			"#터질 때의 피해량은 하트 종류와 현재 스테이지에 따라 달라집니다."
		},
		zh_cn = {
			"心掉落物若未能拾取会炸成一滩伤害血迹",
			"#爆炸伤害取决于心的种类和当前楼层"
		},
		cs_cz = {
			"Upuštěná srdce nakonec vybouchnou do krvavých kaluží",
			"#Poškození exploze záleží na zdravý a aktuální fázi"
		},
	},
	[PlayerType.PLAYER_CAIN_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Captadores duplos são partidos pela metade"
		},
		ko_kr = {
			"이중중 픽업이 단일 픽업 2개로 분해됩니다."
		},
		zh_cn = {
			"将双掉落物一分为二"
		},
		cs_cz = {
			"Dvojité sběrné předměty jsou rozděleny na jejich půlky"
		},
	},
	[PlayerType.PLAYER_JUDAS_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		_modifier = function(descObj)
			local player = BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(player, descObj.ObjSubType)
			local amount = (Mod.Birthcake.JUDAS.DARK_ARTS_CHARGE_BONUS * trinketMult) / 180
			amount = BIRTHCAKE_EID:AdjustNumberValue(amount)

			return BIRTHCAKE_EID:GoldConditional(amount, trinketMult) .. "%"
		end,
		en_us = {
			"{{Collectible705}} Passing through enemies with Dark Arts decreases its recharge time by ",
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
		pt_br = {
			"{{Collectible705}} Passar por inimigos com Artes Sombrias diminui seu tempo de carga por ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
		ko_kr = {
			"{{Collectible705}} 적 관통 시마다 흑마술의 충전 시간이 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end,
			" 감소합니다."
		},
		zh_cn = {
			"{{Collectible705}} 暗仪刺刀标记敌人可以令其冷却减少",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
		cs_cz = {
			"{{Collectible705}} Procházení nepřáteli s Temným Uměním snižuje jeho dobu nabíjení o ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_JUDAS_B]._modifier(descObj)
			end
		},
	},
	[PlayerType.PLAYER_BLUEBABY_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Cocôs lançados tem uma chance de ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% não sofrerem danos ao serem acertados por projetéis"
		},
		ko_kr = {
			"던진 똥이 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% 확률로 발사체 피해를 무시합니다. "
		},
		zh_cn = {
			"丢出的大便有",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% 的概率不会受到子弹的伤害"
		},
		cs_cz = {
			"Hozená hovna mají ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.BLUEBABY.NO_POOP_DAMAGE_CHANCE)
			end,
			"% šanci při zásahu neutrpět poškození"
		},
	},
	[PlayerType.PLAYER_EVE_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Trombos deixam uma pequena poça de sangue ao morrer",
			"#O dano e efeito das poças dependem do tipo de trombo"
		},
		ko_kr = {
			"핏덩이 패밀리어가 죽으면 피해를 주는 장판을 남깁니다.",
			"#핏덩이 종류에 따라 장판의 피해와 효과가 달라집니다."
		},
		zh_cn = {
			"血团死亡后会留下一小摊伤害血迹",
			"#不同的血团留下的血迹有不同的伤害和效果"
		},
		cs_cz = {
			"Krvavé sraženiny zanechávají malou kaluž po smrti",
			"#Poškození a efekty kaluže závisí na typu zničené sraženiny"
		},
	},
	[PlayerType.PLAYER_SAMSON_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"{{Collectible704}} Terminar uma sala com o efeito do Berserk ativo tem uma chance de ",
			function(descObj)
				return BIRTHCAKE_EID:BalanceChanceModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% extender sua duração e ganhar um {{HalfHeart}} meio coração vermelho"
			},
		ko_kr = {
			"{{Collectible704}} 폭주 상태에서 방 클리어 시 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% 확률로 폭주시간을 5초 연장하고  {{HalfHeart}} 빨간 하트 반 개를 생성합니다."
		},
		zh_cn = {
			"{{Collectible704}} 在狂战状态下清理房间有",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% 的概率获得5s持续时间并生成1 {{HalfHeart}} 半红心"
		},
		cs_cz = {
			"{{Collectible704}} Vyčištění místnosti během běsnení má ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.SAMSON.BERSERK_INCREASE_CHANCE)
			end,
			"% šanci prodloužit jeho trvání o 5 sekund a vytvoří {{HalfHeart}} polovinu červeného srdce"
		},
	},
	[PlayerType.PLAYER_AZAZEL_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = {
			"Sneezing fires out a cluster of 6 booger tears that deal a portion of Azazel's damage",
			"#{{Collectible459}} Tears have a ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% chance to stick onto enemies to damage them over time"
		},
		ru = {
			"При чихании выстреливает скопление из 6 соплей, наносящих часть урона Азазеля ",
			"#{{Collectible459}} Слёзы имеют ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
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
		pt_br = {
			"Espirrar atira 6 lágrimas que dão uma porção de dano de Azazel",
			"#{{Collectible459}} Lágrimas tem uma chance de ",
			function(descObj)
				return BIRTHCAKE_EID:NormalChanceModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% para grudar nos inimigos e danificá-los com o tempo"
		},
		ko_kr = {
			"재채기를 하면 아자젤의 공격력에 비례하는 코딱지가 6덩이 발사됩니다.",
			"#{{Collectible459}} 코딱지는 ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% 확률로 적에게 붙어 지속적으로 피해를 줍니다."
		},
		zh_cn = {
			"咳血会额外发射6个鼻涕泪弹, 造成角色的部分伤害",
			"#{{Collectible459}} 泪弹有",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% 的概率粘在敌人身上"
		},
		cs_cz = {
			"Kýchání vystřelí 6 soplových slz, které udělují část Azazelova poškození",
			"#{{Collectible459}} Slzy mají ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.AZAZEL.BOOGER_STICK_CHANCE)
			end,
			"% šanci přilepit se na nepřátele a způsobovat jim postupné poškození"
		},
	},
	[PlayerType.PLAYER_LAZARUS_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = {
			"{{Collectible711}} When using Flip, item pedestals will split into both collectibles displayed"
		},
		ru = {
			"{{Collectible711}} При использовании Переворота пьедесталы с предметами разделяются на оба отображаемых предмета"
		},
		spa = {
			"{{Collectible711}} Al usar Flip, los objetos de pedestal se dividen en ambos objetos mostrados"
		},
		pl = {
			"{{Collectible711}} Po użyciu Odwrotu, przedmioty rozdzielają się na oba pokazane przedmioty"
		},
		pt_br = {
			"{{Collectible711}} Quando usar o trocar, items no pedestal irão se dividir em ambos colecionáveis exibidos "
			},
		ko_kr = {
			"{{Collectible711}} 뒤집기 사용 시 뚜렷한 아이템과 흐릿한 아이템이 뚜렷한 아이템 2개로 분해됩니다."
		},
		zh_cn = {
			"{{Collectible711}} 生死逆转的效果改为将道具和虚影一分为二"
		},
		cs_cz = {
			"{{Collectible711}} Při použití Překlopení se podstavce s předměty rozdělí na oba zobrazené předměty"
		},
	},
	[PlayerType.PLAYER_EDEN_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
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
		pt_br = {
			"Tomar dano tem uma chance de ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% de não mudar os items de Éden",
			"#Bolo de nascimento é quase imune a ser mudado, tendo uma chande de "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% mudar ao sofrer dano"
	},
		ko_kr = {
			"피격 시 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% 확률로 리롤 효과가 면제됩니다.",
			"#생일 케이크는 대부분의 경우 리롤에 면역이며 "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% 의 확률로 피격 시 리롤됩니다."
		},
		zh_cn = {
			"受到伤害有",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% 的概率不会重随角色",
			"#蛋糕本身基本不会被重随, 受到伤害时只有"
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% 的概率被重随"
		},
		cs_cz = {
			"Obdržení poškození má ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.EDEN.PREVENT_REROLL_CHANCE)
			end,
			"% šanci nezměnit Edenovy předměty",
			"#Narozeninový Dort je většinou imunní vůči změně, s "
			.. Mod.Birthcake.EDEN.BIRTHCAKE_REROLL_CHANCE .. "% šancí na změnu při zásahu"
		},

	},
	[PlayerType.PLAYER_THELOST_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"{{Card51}} Ganhe uma Carta Sagrada primeira vez que pegar",
			"#Cartas tem uma chance de ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% de virar uma Carta Sagrada"

		},
		ko_kr = {
			"{{Card51}} 최초 습득 시 홀리 카드가 1장 생성됩니다.",
			"#모든 카드가 추가 ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% 확률로 홀리 카드가 됩니다."

		},
		zh_cn = {
			"{{Card51}} 首次拾取时生成一张神圣卡",
			"#卡牌被重随为神圣卡的概率增加 ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"%"
		},
		cs_cz = {
			"{{Card51}} Při prvním sebrání vytvoří Svatou Kartu",
			"#Karty mají ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THELOST.HOLY_CARD_REPLACE_CHANCE)
			end,
			"% šanci stát se Svatými Kartami"
		},
	},
	[PlayerType.PLAYER_LILITH_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = {
			"Whipping out Lilith's Gello has a ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% chance to spawn another Gello",
			"#The additional Gello deals 50% damage"
		},
		ru = {
			"Выхлёстывание Гелло Лилит имеет ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% шанс создать ещё одного Гелло",
			"#Дополнительный Гелло наносит 50% урона"
		},
		spa = {
			"Disparar Gello tiene una probabilidad del ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% de generar un Gello adicional",
			"#El Gello adicional hace el 50% de tu daño"
		},
		pl = {
			"Wystrzelenie Gello ma ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% szansy na wystrzelenie drugiego Gello",
			"#Drugi Gello zadaje 50% obrażeń"
		},
		pt_br = {
			"Atirar o Gello tem uma chance de ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% de invocar outro Gello",
			"#O segundo Gello dá 50% do seu dano"
	},
		ko_kr = {
			"릴리트의 젤로가 튀어나갈 때 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% 확률로 젤로가 1명 더 튀어나옵니다.",
			"#추가 생성된 젤로의 피해량은 기존 젤로의 절반입니다."
		},
		zh_cn = {
			"打出格罗时有 ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% 的概率再生成一个小格罗",
			"#小格罗造成50%的伤害"
		},
		cs_cz = {
			"Vystřelení Lilithina Gella má ",
			function(descObj)
				return BIRTHCAKE_EID:BalancedNumberModifier(descObj, Mod.Birthcake.LILITH.SPAWN_RUNT_CHANCE)
			end,
			"% šanci vyvolat dalšího Gella",
			"#Dodatečný Gello způsobuje 50% poškození"
		},

	},
	[PlayerType.PLAYER_KEEPER_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Invoca um item e 2 captadores a venda no início de todo andar "
		},
		ko_kr = {
			"매 층 시작 지점에 아이템 1개와 픽업 2개를 판매하는 소형 상점이 생성됩니다. "
		},
		zh_cn = {
			"进入下一层时生成打折出售的一个道具和2个掉落物"
		},
		cs_cz = {
			"Na začátku každého patra vytvoří 2 sběrné předměty k prodeji"
		},

	},
	[PlayerType.PLAYER_APOLLYON_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity),
				descObj.ObjSubType)
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
		pt_br = {
			"{{Collectible706}} Berloques podem ser convertidos em gafanhotos com o Abismo",
			"#Gafanhotos feitos com o Abismo dão ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" de dano"
	},
		ko_kr = {
			"{{Collectible706}} 무저갱으로 장신구를 흡수해 메뚜기로 전환할 수 있습니다.",
			"#이렇게 생성된 메뚜기는 ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			"의 피해를 줍니다."
		},
		zh_cn = {
			"{{Collectible706}} 无底洞可以吞噬饰品",
			"#饰品生成的蝗虫造成",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" 伤害"
		},
		cs_cz = {
			"{{Collectible706}} Cetky mohou být přeměněny na kobylky pomocí Propasti",
			"#Kobylky vytvořené z cetek udělují ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_APOLLYON_B]._modifier(descObj)
			end,
			" poškození"
		},
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = { 		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
	    pt_br = {
			"Matar inimigos invocará fragmentos de ossos que dão dano de contato",
			"#Segurar {{Player35}}O esquecido causará todos os fragmentos voarem em direção a {{Player40}}A Alma, virando orbitais",
			"#Pode ter até ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" orbitais"
		},
		ko_kr = {
			"적 처치 시 골극의 뼛조각 패밀리어가 생성됩니다.",
			"{{Player35}}포가튼을 들어올리면 뼛조각들이 오비탈이 되어 {{Player40}}더 소울의 주위를 돌게 됩니다.",
			"#뼛조각 오비탈은 최대 ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			"개까지 가질 수 있습니다."
		},
		zh_cn = {
			"杀死敌人会生成造成碰撞伤害的骨片",
			"#举起 {{Player35}}堕化遗骸会让所有骨片飞向{{Player40}}遗骸之魂并变成环绕物",
			"#至多能拥有 ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" 个环绕物"
		},
		cs_cz = {
			"Zabití nepřátel vytvoří nehybné kostěné úlomky které způsobují poškození při kontaktu",
			"#Držení {{Player35}}Zapomenutého způsobí že všechny kostěné úlomky poletí k {{Player40}}Duši a stanou se orbitálními",
			"#Lze mít až ",
			function(descObj)
				return BIRTHCAKE_EID:NormalNumberModifier(descObj, Mod.Birthcake.THEFORGOTTEN.BONE_ORBITAL_CAP)
			end,
			" orbitálů"
		},
	},
	[PlayerType.PLAYER_BETHANY_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
			"{{Collectible712}} Огоньки Лемегетона могут получить ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" дополнительных удара(ов)"
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
		pt_br = {
			"{{Collectible712}} Fumaças do Lemegeton podem tomar mais ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" golpes adicionais"
	},
		ko_kr = {
			"{{Collectible712}} 레메게톤 위습 체력 + ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			"증가"
		},
		zh_cn = {
			"{{Collectible712}} 所罗门魔典的魂火可以额外承受",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" 次攻击"
		},
		cs_cz = {
			"{{Collectible712}} Bludičky Lemegetonu vydrží o ",
			function(descObj)
				return BIRTHCAKE_EID.Descs[PlayerType.PLAYER_BETHANY_B]._modifier(descObj)
			end,
			" zásahů více"
		},
	},
	[PlayerType.PLAYER_JACOB_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			"Esaú escuro deixa uma pequena trilha de chamas em quanto estiver atacando, bloqueando lágrimas e projetéis inimigos",
			"#As chamas podem danificar o Jacó e os inimigos"
		},
		ko_kr = {
			"검은 에사우가 돌진하면 그 자리에 야곱과 적의 발사체를 막는 불꽃이 생깁니다.",
			"#불꽃은 야곱과 적들 모두에게 피해를 줍니다."
		},
		zh_cn = {
			"堕化以扫冲刺时会留下火墙, 阻挡泪弹和敌弹",
			"#火焰可以伤害以扫和怪物"
		},
		cs_cz = {
			"Temný Ezau za sebou při letu zanechává malé plameny které blokují slzy a nepřátelské střely",
			"#Plameny mohou zraňovat jak Jákoba tak nepřátele"
		},
	},
}

BIRTHCAKE_EID.ShortDescriptions = {
	DEFAULT_EFFECT = { -- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		_modifier = function(descObj)
			local trinketMult = BIRTHCAKE_EID:TrinketMulti(BIRTHCAKE_EID:ClosestPlayerTo(descObj.Entity),
				descObj.ObjSubType)
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
		pt_br = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"% para todas as estatísticas"
		},
		ko_kr = {
			"↑ 모든 능력치 +",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"%"
		},
		zh_cn = {
			"↑ 所有属性+",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"% "
		},
		cs_cz = {
			"↑ +",
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT._modifier(descObj)
			end,
			"% všem atributům"
		},
	},
	APOLLYON_B_APPEND = { -- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
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
		pt_br = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
					"Gafanhotos cinzas que dão metade de dano",
					"Gafanhotos vermelhos que podam dar seu dano inteiro"
				)
			end
		},
		ko_kr = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
					"절반의 피해를 주는 회색 메뚜기",
					"온전한 피해를 입히는 빨간 메뚜기"
				)
			end
		},
		zh_cn = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
					"造成50%伤害的灰色蝗虫",
					"造成100%伤害的红色蝗虫"
				)
			end
		},
		cs_cz = {
			function(descObj)
				return BIRTHCAKE_EID.ShortDescriptions.APOLLYON_B_APPEND._modifier(descObj,
					"Šedá kobylka která způsobuje poloviční poškození",
					"Červená kobylka která způsobuje celé poškození"
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
		local renderedPlayerType = {}
		for _, player in ipairs(players) do
			local playerType = player:GetPlayerType()
			local descTable = BIRTHCAKE_EID.Descs[playerType]
			local detectedPlayerType = playerType
			if BIRTHCAKE_EID.SHARED_DESCRIPTIONS[playerType] then
				descTable = BIRTHCAKE_EID.Descs[BIRTHCAKE_EID.SHARED_DESCRIPTIONS[playerType]]
				detectedPlayerType = playerType
			end
			if renderedPlayerType[detectedPlayerType] then
				goto skipPlayer
			end
			renderedPlayerType[detectedPlayerType] = true
			local desc = BIRTHCAKE_EID:GetTranslatedString(BIRTHCAKE_EID.ShortDescriptions.DEFAULT_EFFECT)
			if descTable and BIRTHCAKE_EID:GetTranslatedString(descTable) then
				desc = BIRTHCAKE_EID:GetTranslatedString(descTable)
			elseif Birthcake.TrinketDesc[playerType] and Birthcake.TrinketDesc[playerType].Normal then
				local legacyDesc = BIRTHCAKE_EID.LegacyDescriptions[playerType]
				if not legacyDesc then
					BIRTHCAKE_EID.LegacyDescriptions[playerType] = DD:MakeMinimizedDescription({ Birthcake.TrinketDesc
						[playerType].Normal })
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

			if Mod.GetSetting(Mod.Setting.UniqueSprite) == false or #players > 1 or (not Mod.BirthcakeSprite[playerType] and not Birthcake.BirthcakeDescs[playerType]) then
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
			::skipPlayer::
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
