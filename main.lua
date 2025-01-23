---@class ModReference
_G.BirthcakeRebaked = RegisterMod("Birthcake: Rebaked", 1)
local Mod = BirthcakeRebaked
BirthcakeRebaked.SaveManager = include("src_birthcake.utility.save_manager")
BirthcakeRebaked.SaveManager.Init(BirthcakeRebaked)
BirthcakeRebaked.Game = Game()
BirthcakeRebaked.SFXManager = SFXManager()
BirthcakeRebaked.ItemConfig = Isaac.GetItemConfig()
BirthcakeRebaked.SFX = {
	PARTY_HORN = Isaac.GetSoundIdByName("Party Horn")
}
BirthcakeRebaked.Challenges = {}
BirthcakeRebaked.GENERIC_RNG = RNG()
BirthcakeRebaked.HiddenItemManager = include("src_birthcake.utility.vendor.hidden_item_manager")
BirthcakeRebaked.HiddenItemManager:Init(BirthcakeRebaked)

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	BirthcakeRebaked.GENERIC_RNG:SetSeed(Mod.Game:GetSeeds():GetStartSeed(), 35)
end)

local trinketPath = "gfx/items/trinkets/"

---@type {[PlayerType]: {SpritePath: string, PickupSpritePath: string | nil, Anm2: string | nil}}
BirthcakeRebaked.BirthcakeSprite = {
	[PlayerType.PLAYER_ISAAC] = {
		SpritePath = trinketPath .. "0_isaac_birthcake.png",
	},
	[PlayerType.PLAYER_MAGDALENE] = {
		SpritePath = trinketPath .. "1_magdalene_birthcake.png",
	},
	[PlayerType.PLAYER_CAIN] = {
		SpritePath = trinketPath .. "2_cain_birthcake.png",
	},
	[PlayerType.PLAYER_JUDAS] = {
		SpritePath = trinketPath .. "3_judas_birthcake.png",
	},
	[PlayerType.PLAYER_BLUEBABY] = {
		SpritePath = trinketPath .. "4_bluebaby_birthcake.png",
	},
	[PlayerType.PLAYER_EVE] = {
		SpritePath = trinketPath .. "5_eve_birthcake.png",
	},
	[PlayerType.PLAYER_SAMSON] = {
		SpritePath = trinketPath .. "6_samson_birthcake.png",
	},
	[PlayerType.PLAYER_AZAZEL] = {
		SpritePath = trinketPath .. "7_azazel_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS] = {
		SpritePath = trinketPath .. "8_lazarus_birthcake.png",
	},
	[PlayerType.PLAYER_EDEN] = {
		SpritePath = trinketPath .. "9_eden_birthcake.png",
	},
	[PlayerType.PLAYER_THELOST] = {
		SpritePath = trinketPath .. "10_thelost_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS2] = {
		SpritePath = trinketPath .. "11_lazarus2_birthcake.png",
	},
	[PlayerType.PLAYER_BLACKJUDAS] = {
		SpritePath = trinketPath .. "12_darkjudas_birthcake.png",
	},
	[PlayerType.PLAYER_LILITH] = {
		SpritePath = trinketPath .. "13_lilith_birthcake.png",
	},
	[PlayerType.PLAYER_KEEPER] = {
		SpritePath = trinketPath .. "14_keeper_birthcake.png",
	},
	[PlayerType.PLAYER_APOLLYON] = {
		SpritePath = trinketPath .. "15_apollyon_birthcake.png",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {
		SpritePath = trinketPath .. "16_forgotten_birthcake.png",
	},
	[PlayerType.PLAYER_THESOUL] = {
		SpritePath = trinketPath .. "17_forgottensoul_birthcake.png",
	},
	[PlayerType.PLAYER_BETHANY] = {
		SpritePath = trinketPath .. "18_bethany_birthcake.png",
	},
	[PlayerType.PLAYER_JACOB] = {
		SpritePath = trinketPath .. "19_jacob_birthcake.png",
		PickupSpritePath = trinketPath .. "19_jacob_esau_birthcake.png"
	},
	[PlayerType.PLAYER_ESAU] = {
		SpritePath = trinketPath .. "20_esau_birthcake.png",
	},
	[PlayerType.PLAYER_ISAAC_B] = {
		SpritePath = trinketPath .. "21_isaacb_birthcake.png",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = {
		SpritePath = trinketPath .. "22_magdaleneb_birthcake.png",
	},
	[PlayerType.PLAYER_CAIN_B] = {
		SpritePath = trinketPath .. "23_cainb_birthcake.png",
	},
	[PlayerType.PLAYER_JUDAS_B] = {
		SpritePath = trinketPath .. "24_judasb_birthcake.png",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = {
		SpritePath = trinketPath .. "25_bluebabyb_birthcake.png",
	},
	[PlayerType.PLAYER_EVE_B] = {
		SpritePath = trinketPath .. "26_eveb_birthcake.png",
	},
	[PlayerType.PLAYER_SAMSON_B] = {
		SpritePath = trinketPath .. "27_samsonb_birthcake.png",
	},
	[PlayerType.PLAYER_AZAZEL_B] = {
		SpritePath = trinketPath .. "28_azazelb_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS_B] = {
		SpritePath = trinketPath .. "29_lazarusb_birthcake.png",
	},
	[PlayerType.PLAYER_EDEN_B] = {
		SpritePath = trinketPath .. "30_edenb_birthcake.png",
	},
	[PlayerType.PLAYER_THELOST_B] = {
		SpritePath = trinketPath .. "31_thelostb_birthcake.png",
	},
	[PlayerType.PLAYER_LILITH_B] = {
		SpritePath = trinketPath .. "32_lilithb_birthcake.png",
	},
	[PlayerType.PLAYER_KEEPER_B] = {
		SpritePath = trinketPath .. "33_keeperb_birthcake.png",
	},
	[PlayerType.PLAYER_APOLLYON_B] = {
		SpritePath = trinketPath .. "34_apollyonb_birthcake.png",
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {
		SpritePath = trinketPath .. "35_forgottenb_birthcake.png",
	},
	[PlayerType.PLAYER_BETHANY_B] = {
		SpritePath = trinketPath .. "36_bethanyb_birthcake.png",
	},
	[PlayerType.PLAYER_JACOB_B] = {
		SpritePath = trinketPath .. "37_jacobb_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS2_B] = {
		SpritePath = trinketPath .. "38_lazarus2b_birthcake.png",
	},
	[PlayerType.PLAYER_JACOB2_B] = {
		SpritePath = trinketPath .. "39_jacobghostb_birthcake.png",
	},
	[PlayerType.PLAYER_THESOUL_B] = {
		SpritePath = trinketPath .. "40_forgottensoulb_birthcake.png",
	},
}
BirthcakeRebaked.ModCallbacks = {
	---(player: EntityPlayer, name: string): string, Optional Arg: PlayerType - Called when getting the player-specific name of Birthcake before displayed as item text. Return a string to override it
	GET_BIRTHCAKE_ITEMTEXT_NAME = "BIRTHCAKE_GET_BIRTHCAKE_ITEMTEXT_NAME",
	---(player: EntityPlayer, description: string): string, Optional Arg: PlayerType - Called when getting the player-specific description of Birthcake before displayed as item text. Return a string to override it
	GET_BIRTHCAKE_ITEMTEXT_DESCRIPTION = "BIRTHCAKE_GET_BIRTHCAKE_ITEMTEXT_DESCRIPTION",
	---(player: EntityPlayer, sprite: Sprite), Optional Arg: PlayerType - Called when loading the player-specific Birthcake sprite. Return a sprite object to override it
	LOAD_BIRTHCAKE_SPRITE = "BIRTHCAKE_LOAD_BIRTHCAKE_SPRITE",
	---(player: EntityPlayer, pickup: EntityPickup), Optional Arg: PlayerType - Called when the Birthcake pickup spawns and after its sprite has been applied. You can give it a new sprite manually
	POST_BIRTHCAKE_PICKUP_INIT = "BIRTHCAKE_POST_BIRTHCAKE_PICKUP_INIT",
	PRE_BIRTHCAKE_RENDER = "BIRTHCAKE_PRE_BIRTHCAKE_RENDER",
	POST_BIRTHCAKE_RENDER = "BIRTHCAKE_POST_BIRTHCAKE_RENDER",
	---(player: EntityPlayer, firstTimePickup: boolean, isGolden: boolean), Optional Arg: PlayerType - Called when picking up the Birthcake trinket
	POST_BIRTHCAKE_PICKUP = "BIRTHCAKE_POST_BIRTHCAKE_PICKUP",
	---(player: EntityPlayer, firstTimePickup: boolean, isGolden: boolean), Optional Arg: PlayerType - Called when collecting the Birthcake trinket. REPENTOGON will trigger this any time the item is added to the player's inventory. Otherwise, it triggers only when picked up as a trinket
	POST_BIRTHCAKE_COLLECT = "BIRTHCAKE_POST_BIRTHCAKE_COLLECT",
	--(player: EntityPlayer, oldPlayerType: PlayerType), Optional Arg: PlayerType - Called when your tracked PlayerType changes. This happens regardless of you having Birthcake or not. `player` is your current player with the new PlayerType. `PlayerType` arg is for the previous PlayerType you were
	POST_PLAYERTYPE_CHANGE = "BIRTHCAKE_POST_PLAYERTYPE_CHANGE",
	BLUEBABY_GET_POOP_TEAR_SPRITE = "BIRTHCAKE_BLUEBABY_GET_POOP_TEAR_SPRITE"
}
local translations = include("src_birthcake.birthcake_translations")
BirthcakeRebaked.BirthcakeNames = translations.BIRTHCAKE_NAME
BirthcakeRebaked.BirthcakeDescriptions = translations.BIRTHCAKE_DESCRIPTION
BirthcakeRebaked.BirthcakeDefaultDescription = translations.DEFAULT_DESCRIPTION
BirthcakeRebaked.EID = translations.EID

local utility = {
	"hud_helper",
	"rgon_enums",
	"misc_util",
	"birthcake_util"
}
for _, path in ipairs(utility) do
	include("src_birthcake.utility." .. path)
end

local miscSrc = {
	"compatibility.birthcake_legacy",
	"trinket_birthcake",
	"challenge_birthday_party",
	"api"
}
for _, path in ipairs(miscSrc) do
	include("src_birthcake." .. path)
end

include("src_birthcake.compatibility.patches.eid")

local languageOptionToEID = {
	["en"] = "en_us",
	["jp"] = "ja_jp",
	["es"] = "spa",
	["de"] = "de",
	["fr"] = "fr",
	["ru"] = "ru",
	["kr"] = "ko_kr",
	["zh"] = "zh_cn"
}

function BirthcakeRebaked:TryGetTranslation(table)
	local desc = table[languageOptionToEID[Options.Language]] or table.en_us

	if desc == "" then
		desc = table.en_us
	end

	return desc
end

---@param player EntityPlayer
function BirthcakeRebaked:GetBirthcakeName(player)
	local playerType = player:GetPlayerType()
	local name = player:GetName() .. "'s Cake"
	if Mod.BirthcakeNames[playerType] and Mod:TryGetTranslation(Mod.BirthcakeNames[playerType]) then
		name = Mod:TryGetTranslation(Mod.BirthcakeNames[playerType])
	end
	local nameResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.GET_BIRTHCAKE_ITEMTEXT_NAME, playerType, player, name)
	name = (nameResult ~= nil and tostring(nameResult)) or name
	return name
end

---@param player EntityPlayer
function BirthcakeRebaked:GetBirthcakeDescription(player)
	local playerType = player:GetPlayerType()
	local description = Mod:TryGetTranslation(Mod.BirthcakeDefaultDescription)
	if Mod.BirthcakeDescriptions[playerType] and Mod:TryGetTranslation(Mod.BirthcakeDescriptions[playerType]) then
		description = Mod:TryGetTranslation(Mod.BirthcakeDescriptions[playerType])
	elseif Birthcake.BirthcakeDescs[playerType] then
		description = Birthcake.BirthcakeDescs[playerType]
	end
	local descriptionResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.GET_BIRTHCAKE_ITEMTEXT_DESCRIPTION, playerType,
		player, description)
	description = (descriptionResult ~= nil and tostring(descriptionResult)) or description
	return description
end

---@param player EntityPlayer
function BirthcakeRebaked:GetBirthcakeSprite(player)
	local playerType = player:GetPlayerType()
	local spriteConfig = Mod.BirthcakeSprite[playerType]
	local sprite = Sprite()
	sprite:Load("gfx/005.350_trinket.anm2", false)
	local spritePath = trinketPath .. "0_isaac_birthcake.png"
	if spriteConfig then
		spritePath = spriteConfig.SpritePath
	elseif not spriteConfig and Birthcake.BirthcakeDescs[playerType] then
		spritePath = trinketPath .. player:GetName():lower() .. "_birthcake.png"
	end
	sprite:ReplaceSpritesheet(0, spritePath)
	sprite:LoadGraphics()
	local spriteResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.LOAD_BIRTHCAKE_SPRITE, playerType, player, sprite)
	sprite = (spriteResult ~= nil and type(spriteResult) == "userdata" and getmetatable(spriteResult).__type == "Sprite" and spriteResult) or
		sprite
	return sprite
end

--Setup like so so that this works with stuff like Forgotten and Tainted Laz

local playerByIndex = {}

---@param player EntityPlayer
function BirthcakeRebaked:ResetEffectsOnTypeChange(player)
	local playerType = player:GetPlayerType()
	local lastPlayerType = playerByIndex[player.Index]
	if not lastPlayerType then
		playerByIndex[player.Index] = playerType
	elseif lastPlayerType ~= playerType then
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, lastPlayerType, player,
			lastPlayerType)
			playerByIndex[player.Index] = playerType
		player:GetEffects():RemoveTrinketEffect(Mod.Birthcake.ID, -1)
	end
end

---@param player EntityPlayer
function BirthcakeRebaked:ItemDesc(player)
	local playerType = player:GetPlayerType()
	local data = Mod:GetData(player)
	local queuedItem = player.QueuedItem.Item

	if not data.HoldingBirthcake
		and queuedItem
		and queuedItem.Type == ItemType.ITEM_TRINKET
		and Mod:IsBirthcake(queuedItem.ID)
	then
		data.HoldingBirthcake = queuedItem.ID
		data.BirthcakeFirstPickup = player.QueuedItem.Touched
		local name = Mod:GetBirthcakeName(player)
		local description = Mod:GetBirthcakeDescription(player)

		Mod.Game:GetHUD():ShowItemText(name, description, false, true)

		local sprite = BirthcakeRebaked:GetBirthcakeSprite(player)
		sprite:Play("PlayerPickupSparkle")
		player:AnimatePickup(sprite, false, "Pickup")
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_PICKUP, playerType, player, data.BirthcakeFirstPickup,
			Mod:IsBirthcake(queuedItem.ID, true))
	elseif not queuedItem and data.HoldingBirthcake then
		if not REPENTOGON then
			Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, playerType, player,
				data.BirthcakeFirstPickup, Mod:IsBirthcake(data.HoldingBirthcake, true))
		end
		data.HoldingBirthcake = nil
	end
end

function BirthcakeRebaked:OnPeffectUpdate(player)
	BirthcakeRebaked:ItemDesc(player)
	BirthcakeRebaked:ResetEffectsOnTypeChange(player)
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BirthcakeRebaked.OnPeffectUpdate)

if REPENTOGON then
	function BirthcakeRebaked:OnTrinketAdd(player, trinketID, firstTime)
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, player:GetPlayerType(), player, firstTime,
			Mod:IsBirthcake(trinketID, true))
	end

	Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, BirthcakeRebaked.OnTrinketAdd, Mod.Birthcake.ID)
	Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, BirthcakeRebaked.OnTrinketAdd,
		Mod.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
end

---@param pickup EntityPickup
function BirthcakeRebaked:ChangeSpritePickup(pickup)
	if Mod:IsBirthcake(pickup.SubType) then
		local isCoopPlay = false
		local controllerIdx
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			local player = ent:ToPlayer() ---@cast player EntityPlayer
			if not controllerIdx then
				controllerIdx = player.ControllerIndex
			elseif controllerIdx ~= player.ControllerIndex then
				isCoopPlay = true
				break
			end
		end

		local player = Isaac.GetPlayer()
		local playerType = player:GetPlayerType()
		local sprite = pickup:GetSprite()
		local spriteConfig = Mod.BirthcakeSprite[playerType]
		local anim = sprite:GetAnimation()
		local spritePath = trinketPath .. "0_isaac_birthcake.png"

		if not isCoopPlay then
			if spriteConfig and spriteConfig.Anm2 then
				sprite:Load(spriteConfig.Anm2, true)
				sprite:Play(anim)
			end
			if spriteConfig then
				if spriteConfig.PickupSpritePath then
					spritePath = spriteConfig.PickupSpritePath
				elseif spriteConfig.SpritePath then
					spritePath = spriteConfig.SpritePath
				end
			end
			if not spriteConfig and Birthcake.BirthcakeDescs[playerType] then
				spritePath = trinketPath .. player:GetName():lower() .. "_birthcake.png"
			end
		end

		---@cast spritePath string
		sprite:ReplaceSpritesheet(0, spritePath)
		sprite:LoadGraphics()

		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_PICKUP_INIT, playerType, player, sprite)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BirthcakeRebaked.ChangeSpritePickup, PickupVariant.PICKUP_TRINKET)

---For testing help
function BirthcakeRebaked:SpawnGoldenBirthcake()
	local room = Mod.Game:GetRoom()
	Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET,
		Mod.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG, room:FindFreePickupSpawnPosition(room:GetCenterPos()),
		Vector.Zero, nil)
end

--[[
local function round(number, precision)
	local fmtStr = string.format('%%0.%sf', precision)
	number = string.format(fmtStr, number)
	return number
end
 function BirthcakeLocals:ChangeDesc()
	local player = Isaac.GetPlayer(0)
	if EID and player:HasTrinket(Mod.Birthcake.ID) then
		local name = ""
		local ptype = player:GetPlayerType()
		local entity = player:GetTrinket(0)
		if ptype == PlayerType.PLAYER_JUDAS or ptype == PlayerType.PLAYER_JUDAS_B or ptype == PlayerType.PLAYER_BLACKJUDAS then
			name = "Judas' cake"
		elseif ptype == PlayerType.PLAYER_LAZARUS or ptype == PlayerType.PLAYER_LAZARUS2 or ptype == PlayerType.PLAYER_LAZARUS_B or ptype == PlayerType.PLAYER_LAZARUS2_B then
			name = "Lazarus' cake"
		else
			name = player:GetName() .. "'s cake"
		end
		local isTainted = Mod:IsTainted(player)
		if isTainted then
			name = "Tainted " .. name
		end

		if ptype == PlayerType.PLAYER_JUDAS or ptype == PlayerType.PLAYER_BLACKJUDAS then
			local dmg = round(player.Damage * 0.2, 2)
			local desc = "↑ +" ..
				tostring(dmg) .. " damage #Grants +1 black heart when selling all of your red health to a devil deal"
			EID:addTrinket(Mod.Birthcake.ID, desc, name)
		elseif ptype == PlayerType.PLAYER_EDEN then
			if ImitedItem ~= 0 then
				local desc =
					"Imitates a random passive item # Is guaranteed to imitate a Q4 item if eden started with a Q0 or Q1 item # Imited item: {{Collectible" ..
					tostring(ImitedItem) .. "}}"
				EID:addTrinket(Mod.Birthcake.ID, desc, name)
			end
		else
			local desc = ""
			if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and Mod.TrinketDesc[ptype]["Birthright"] ~= nil then
				desc = Mod.TrinketDesc[ptype]["Birthright"]
			elseif (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) or Mod:IsGolden(entity)) and Mod.TrinketDesc[ptype]["Upgraded"] then
				desc = Mod.TrinketDesc[ptype]["Upgraded"]
			elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and Mod.TrinketDesc[ptype]["Mom's Box"] ~= nil then
				desc = Mod.TrinketDesc[ptype]["Mom's Box"]
			elseif player:HasTrinket(Mod.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG) and Mod.TrinketDesc[ptype]["Golden"] then
				desc = Mod.TrinketDesc[ptype]["Golden"]
			else
				desc = Mod.TrinketDesc[ptype]["Normal"]
			end

			if player:HasTrinket(Mod.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG) and Mod.TrinketDesc[ptype]["+Golden"] then
				desc = desc .. Mod.TrinketDesc[ptype]["+Golden"]
			end

			for index, value in pairs(Mod.TrinketDesc[ptype]) do
				if index:find("+{{Trinket") then
					local trinket = index:match("+{{Trinket(%d+)}}")
					trinket = tonumber(trinket)
					if trinket and player:HasTrinket(trinket) then
						desc = desc .. value
					end
				end
			end

			if desc:find("{{Chance") then
				local chance = desc:match("{{Chance(%d+)}}")
				chance = tonumber(chance)
				if chance then
					local newChance = chance * player:GetTrinketMultiplier(entity)
					desc = desc:gsub("{{Chance" .. tostring(chance) .. "}}", tostring(newChance))
				end
			end

			EID:addTrinket(Mod.Birthcake.ID, desc, name)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BirthcakeLocals.ChangeDesc)
]]

include("src_birthcake.compatibility.patches_loader")
