---@class ModReference
_G.BirthcakeRebaked = RegisterMod("Birthcake Rebaked", 1)
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

local trinketPath = "gfx/items/trinkets/"

BirthcakeRebaked.BirthcakeSprite = {
	[PlayerType.PLAYER_ISAAC] = {
		Description = "Better rolls",
		SpritePath = trinketPath .. "0_isaac_birthcake.png",
	},
	[PlayerType.PLAYER_MAGDALENE] = {
		Description = "Healing power",
		SpritePath = trinketPath .. "1_magdalene_birthcake.png",
	},
	[PlayerType.PLAYER_CAIN] = {
		Description = "Sleight of hand",
		SpritePath = trinketPath .. "2_cain_birthcake.png",
	},
	[PlayerType.PLAYER_JUDAS] = {
		Description = "Sinner's guard",
		SpritePath = trinketPath .. "3_judas_birthcake.png",
	},
	[PlayerType.PLAYER_BLUEBABY] = {
		Description = "Loose bowels",
		SpritePath = trinketPath .. "4_bluebaby_birthcake.png",
	},
	[PlayerType.PLAYER_EVE] = {
		Description = "Pain for pleasure",
		SpritePath = trinketPath .. "5_eve_birthcake.png",
	},
	[PlayerType.PLAYER_SAMSON] = {
		Description = "Healing rage",
		SpritePath = trinketPath .. "6_samson_birthcake.png",
	},
	[PlayerType.PLAYER_AZAZEL] = {
		Description = "Alternative attack",
		SpritePath = trinketPath .. "7_azazel_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS] = {
		Description = "Come down with me",
		SpritePath = trinketPath .. "8_lazarus_birthcake.png",
	},
	[PlayerType.PLAYER_EDEN] = {
		Description = "Mystery flavor",
		SpritePath = trinketPath .. "9_eden_birthcake.png",
	},
	[PlayerType.PLAYER_THELOST] = {
		Description = "Regained power",
		SpritePath = trinketPath .. "10_thelost_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS2] = {
		Name = "Lazarus' Cake",
		Description = "Come down with me",
		SpritePath = trinketPath .. "11_lazarus2_birthcake.png",
	},
	[PlayerType.PLAYER_BLACKJUDAS] = {
		Name = "Judas' Cake",
		Description = "Sinner's guard",
		SpritePath = trinketPath .. "12_darkjudas_birthcake.png",
	},
	[PlayerType.PLAYER_LILITH] = {
		Description = "Remember to share",
		SpritePath = trinketPath .. "13_lilith_birthcake.png",
	},
	[PlayerType.PLAYER_KEEPER] = {
		Description = "Spare change",
		SpritePath = trinketPath .. "14_keeper_birthcake.png",
	},
	[PlayerType.PLAYER_APOLLYON] = {
		Description = "Snack time",
		SpritePath = trinketPath .. "15_apollyon_birthcake.png",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {
		Description = "Harmony of body and soul",
		SpritePath = trinketPath .. "16_forgotten_birthcake.png",
	},
	[PlayerType.PLAYER_THESOUL] = {
		Description = "Harmony of body and soul",
		SpritePath = trinketPath .. "17_forgottensoul_birthcake.png",
	},
	[PlayerType.PLAYER_BETHANY] = {
		Description = "Virtuous Guidance",
		SpritePath = trinketPath .. "18_bethany_birthcake.png",
	},
	[PlayerType.PLAYER_JACOB] = {
		Description = "Stronger than you",
		SpritePath = trinketPath .. "19_jacob_birthcake.png",
	},
	[PlayerType.PLAYER_ESAU] = {
		Description = "Stronger than you",
		SpritePath = trinketPath .. "20_esau_birthcake.png",
	},
	[PlayerType.PLAYER_ISAAC_B] = {
		Description = "Danger = Space",
		SpritePath = trinketPath .. "21_isaacb_birthcake.png",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = {
		Description = "Heart attack",
		SpritePath = trinketPath .. "22_magdaleneb_birthcake.png",
	},
	[PlayerType.PLAYER_CAIN_B] = {
		Description = "Repurpose",
		SpritePath = trinketPath .. "23_cainb_birthcake.png",
	},
	[PlayerType.PLAYER_JUDAS_B] = {
		Description = "Sinner's guard",
		SpritePath = trinketPath .. "24_judasb_birthcake.png",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = {
		Description = "Sturdy turds",
		SpritePath = trinketPath .. "25_bluebabyb_birthcake.png",
	},
	[PlayerType.PLAYER_EVE_B] = {
		Description = "Saignant",
		SpritePath = trinketPath .. "26_eveb_birthcake.png",
	},
	[PlayerType.PLAYER_SAMSON_B] = {
		Description = "Unending rampage",
		SpritePath = trinketPath .. "27_samsonb_birthcake.png",
	},
	[PlayerType.PLAYER_AZAZEL_B] = {
		Description = "Allergy up",
		SpritePath = trinketPath .. "28_azazelb_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS_B] = {
		Description = "A gift from the other side",
		SpritePath = trinketPath .. "29_lazarusb_birthcake.png",
	},
	[PlayerType.PLAYER_EDEN_B] = {
		Description = "Undecided",
		SpritePath = trinketPath .. "30_edenb_birthcake.png",
	},
	[PlayerType.PLAYER_THELOST_B] = {
		Description = "Small fortune at cost",
		Anm2 = trinketPath .. "thelostb_birthcake.anm2",
		SpritePath = trinketPath .. "31_thelostb_birthcake.png",
	},
	[PlayerType.PLAYER_LILITH_B] = {
		Description = "I ask for your help",
		SpritePath = trinketPath .. "32_lilithb_birthcake.png",
	},
	[PlayerType.PLAYER_KEEPER_B] = {
		Description = "Local business",
		SpritePath = trinketPath .. "33_keeperb_birthcake.png",
	},
	[PlayerType.PLAYER_APOLLYON_B] = {
		Description = "Harvest",
		SpritePath = trinketPath .. "34_apollyonb_birthcake.png",
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {
		Description = "Spectral protection",
		SpritePath = trinketPath .. "35_forgottenb_birthcake.png",
	},
	[PlayerType.PLAYER_BETHANY_B] = {
		Description = "Desire fullfilled",
		SpritePath = trinketPath .. "36_bethanyb_birthcake.png",
	},
	[PlayerType.PLAYER_JACOB_B] = {
		Description = "Uneasy truce",
		SpritePath = trinketPath .. "37_jacobb_birthcake.png",
	},
	[PlayerType.PLAYER_LAZARUS2_B] = {
		Description = "A gift from the other side",
		SpritePath = trinketPath .. "38_lazarus2b_birthcake.png",
	},
	[PlayerType.PLAYER_JACOB2_B] = {
		Description = "Uneasy truce",
		SpritePath = trinketPath .. "39_jacobghostb_birthcake.png",
	},
	[PlayerType.PLAYER_THESOUL_B] = {
		Description = "Spectral protection",
		SpritePath = trinketPath .. "40_forgottensoulb_birthcake.png",
	},
}
BirthcakeRebaked.ModCallbacks = {
	---(player: EntityPlayer): string, Optional Arg: PlayerType - Called when getting the player-specific name of Birthcake before displayed as item text. Return a string to override it
	PRE_BIRTHCAKE_ITEMTEXT_NAME = "BIRTHCAKE_PRE_BIRTHCAKE_ITEMTEXT_NAME",
	---(player: EntityPlayer): string, Optional Arg: PlayerType - Called when getting the player-specific description of Birthcake before displayed as item text. Return a string to override it
	PRE_BIRTHCAKE_ITEMTEXT_DESCRIPTION = "BIRTHCAKE_PRE_BIRTHCAKE_ITEMTEXT_DESCRIPTION",
	---(player: EntityPlayer, sprite: Sprite), Optional Arg: Player Type - Called when loading the player-specific Birthcake sprite. Return a sprite object to override it
	LOAD_BIRTHCAKE_SPRITE = "BIRTHCAKE_LOAD_BIRTHCAKE_SPRITE",
	PRE_BIRTHCAKE_RENDER = "BIRTHCAKE_PRE_BIRTHCAKE_RENDER",
	POST_BIRTHCAKE_RENDER = "BIRTHCAKE_POST_BIRTHCAKE_RENDER",
	---(player: EntityPlayer, firstTimePickup: boolean, isGolden: boolean), Optional Arg: PlayerType - Called when picking up the Birthcake trinket
	POST_BIRTHCAKE_PICKUP = "BIRTHCAKE_POST_BIRTHCAKE_PICKUP",
	---(player: EntityPlayer, firstTimePickup: boolean, isGolden: boolean), Optional Arg: PlayerType - Called when collecting the Birthcake trinket. REPENTOGON will trigger this any time the item is added to the player's inventory. Otherwise, it triggers only when picked up as a trinket
	POST_BIRTHCAKE_COLLECT = "BIRTHCAKE_POST_BIRTHCAKE_COLLECT"
}

--[[ Mod.TrinketDesc = {
	----- Isaac -----
	[0] =
	{
		["Normal"] = "When rerolling, items have a 25% chance to cycle back and forth between their new and original form";
	};
	[21] =
	{
		["Normal"] = "Getting hit while having no empty item slot has a 25% chance to permanently exclude a random item from occupying an invetory slot #The trinket has a 50% chance to disappear if this occurs";
	};
	----- Magdalene -----
	[1] =
	{
		["Normal"] = "Higher chance for red hearts to be replaced by double red hearts # {{HalfSoulHeart}} Yum heart refills half soul heart upon use";
		["Upgraded"] = "Higher chance for red hearts to be replaced by double red hearts # {{SoulHeart}} Yum heart refills {{ColorGold}}one {{ColorText}}soul heart upon use"
	};
	[22] =
	{
		["Normal"] = "Uncollected red hearts dropped from enemies create small blood explosions when they disappear, damaging nearby enemies";
	};
	----- Cain -----
	[2] =
	{
		["Normal"] = "↑ +1 Luck# Interacting with machines has a 33% chance to not consume coins# The chance is reduced to 25% for the crane game";
		["Upgraded"] = "↑ +1 Luck# Interacting with machines has a {{ColorGold}}50{{ColorText}}% chance to not consume coins# The chance is reduced to {{ColorGold}}33{{ColorText}}% for the crane game";
	};
	[23] =
	{
		["Normal"] = "Double pickups spawn as two individual pickups instead #Putting a pickup in the bag has a 5% chance to add it to your inventory";
	};
	----- Judas -----
	[3] =
	{
		["Normal"] = "↑ +{{DamageUp}} damage #Grants +1 black heart when selling all of your red health to a devil deal";
		["Upgraded"] = "↑ +{{ColorGold}}{{DamageUp}}{{ColorText}} damage #Grants +1 black heart when selling all of your red health to a devil deal"
	};
	[24] =
	{
		["Normal"] = "Enemies marked by dark arts are slowed down after the attack is executed";
	};
	----- Blue Baby -----
	[4] =
	{
		["Normal"] = "Active items spawn number of active item charges - 1 poops upon use # Each poop has a 10% chance to be replaced by tainted ???'s corn poop";
		["Mom's Box"] = "Active items spawn number of active item charges - 1 poops upon use # Each poop has a {{ColorGold}}20{{ColorText}}% chance to be replaced by tainted ???'s corn poop";
		["+Golden"] = "# {{ColorGold}}50% chance for spawned poop to be golden {{ColorText}}";
		["+{{Trinket"..TrinketType.TRINKET_MECONIUM.."}}"] = "# {{Trinket".. TrinketType.TRINKET_MECONIUM .."}} {{ColorGray}}Poops spawned have a chance to be black poop"
	};
	[25] =
	{
		["Normal"] = "Thrown poops are resistant to enemy projectiles #Enemies can go through poops, but are heavily slowed down when doing so";
	};
	----- Eve -----
	[5] =
	{
		["Normal"] = "Prioritizes Eve's red health when taking damage #Losing red health doesn't affect devil/angel deal chances if eve has at least one soul heart";
		["Upgraded"] = "Prioritizes Eve's red health when taking damage #Losing red health doesn't affect devil/angel deal chances if eve has at least one soul heart # {{ColorGold}}Also replace bone hearts behind soul hearts when taking damage";
	};
	[26] =
	{
		["Normal"] = "Spawns 2 clots at a time at the cost of draining twice as much health # Clots leave damaging creep upon death";
	};
	----- Samson -----
	[6] =
	{
		["Normal"] = "Drops 2 red hearts when full rage is reached";
		["Upgraded"] = "Drop {{ColorGold}}2 hearts based on on your current health{{ColorText}} when full rage is reached";
		["+Birthright"] = "# {{Collectible".. CollectibleType.COLLECTIBLE_BIRTHRIGHT .."}} {{ColorGray}}Also drop 2 hearts when 6 rage is reached";
	};
	[27] =
	{
		["Normal"] = "While in berserk mode, has a chance to spawn a random hearts and extends berserk mode for 5 seconds";
	};
	----- Azazel -----
	[7] =
	{
		["Normal"] = "Holding a fire button while brimstone is fully charged allows azazel to shoot regular tears # Azazel's tears only deal 50% damage but have twice the range";
	};
	[28] =
	{
		["Normal"] = "When Azazel sneeze on enemies they get poisoned #Azazel also receives knockback when sneezing";
	};
	---- Lazarus -----
	[8] =
	{
		["Normal"] = "Upon revival, deals 40 damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
		["Upgraded"] = "Upon revival, deals {{ColorGold}}{{Chance40}}{{ColorText}} damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
	};
	[11] =
	{
		["Normal"] = "Upon revival, deals 40 damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
		["Upgraded"] = "Upon revival, deals {{ColorGold}}{{Chance40}}{{ColorText}} damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
	};
	[29] =
	{
		["Normal"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room";
		["Upgraded"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room # {{ColorGold}}Prevents Quality {{Quality0}} items from being shared {{ColorText}}"
	};
	[38] =
	{
		["Normal"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room";
		["Upgraded"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room # {{ColorGold}}Prevents Quality {{Quality0}} items from being shared {{ColorText}}"
	};
	----- Eden -----
	[9] =
	{
		["Normal"] = "";
	};
	[30] =
	{
		["Normal"] = "Pedestal items have a chance to either become glitched or turn into items from different item pools";
	};
	----- The lost -----
	[10] =
	{
		["Normal"] = "While holding the Eternal D6, grants 2 guaranteed rerolls per floor that don't require any charges # If the lost is not holding the Eternal D6, he instead gains one free use of his active item per floor";
	};
	[31] =
	{
		["Normal"] = "Has a 50% chance to spawn an extra item when encountering an item pedestal # If this occurs, the trinket has a 25% chance to self-destrcut, dealing 100 damage to all enemies in the room and removing your mantle in the process";
	};
	---- Lillith ----
	[13] =
	{
		["Normal"] = "Familiars have a 25% chance to copy lillith's tear effects # At the start of each floor has a 10% chance to consume the trinket and spawn a demon familiar # If it happens the cake has 25% chance to replace any future trinket";
	};
	[32] =
	{
		["Normal"] = "Spawn Incubus every other room and Succubus the room between that one # When entering a boss fight, spawn both Incubus and Succubus"; -- KAULIANPOWER
	};
	----- Keeper -----
	[14] =
	{
		["Normal"] = "Grants a nickel when entering a shop, a black market or a devil room";
		["Upgraded"] = "Grants a {{ColorGold}}golden penny{{ColorText}} when entering a shop, a black market or a devil room"
	};
	[33] =
	{
		["Normal"] = "Spawns an item and 2 pickups for sale in the starting room of each floor";
	};
	---- Apollyon -----
	[15] =
	{
		["Normal"] = "Allows void to consume trinkets on the ground # While holding void, you gain the effects of all consumed trinkets";
	};
	[34] =
	{
		["Normal"] = "Allows abyss to consume trinkets on the ground. Turning them into smaller locusts that deal 50% damage # You don't gain the effect of trinkets consumed by abyss";
	};
	---- The Forgotten ----
	[16] =
	{
		["Normal"] = "Upon striking an enemy with the bone club, the forgotten gains an intangible wisp # Switching to the soul turns every wisp into a weak purgatory ghost that grants a temporary dmg boost to the soul";
	};
	[17] =
	{
		["Normal"] = "Upon striking an enemy with the bone club, the forgotten gains an intangible wisp # Switching to the soul turns every wisp into a weak purgatory ghost that grants a temporary dmg boost to the soul";
	};
	[35] =
	{
		["Normal"] = "Spawn 3 fly orbital, 2 on the soul and 1 on the bone pile # Enemies are fixated into attacking the bone pile when not near the soul";
	};
	[40] =
	{
		["Normal"] = "Spawn 3 fly orbital, 2 on the soul and 1 on the bone pile # Enemies are fixated into attacking the bone pile when not near the soul";
	};
	---- Bethany -----
	[18] =
	{
		["Normal"] = "Has 10% chance to spawn a basic wisp upon room clear";
		["Upgraded"] = "Has {{ColorGold}}{{Chance10}}{{ColorText}}% chance to spawn a basic wisp upon room clear"
	};
	[36] =
	{
		["Normal"] = "The next use of lemegeton will consume this trinket and spawn 2 lemegeton wisps that draw from the current room's item pool";
		["Golden"] = "{{ColorGold}}Allow lemegeton to spawn 2 lemegeton wisps that draw from the current room's item pool # {{ColorText}}Chance to turn into a regular {{Trinket"..Mod.Birthcake.ID.."}}Birthcake after this occurs";
	};
	---- Jacob & Esau -----
	[19] =
	{
		["Normal"] = "The holder gains +25% of the stat the other brother has";
	};
	[20] =
	{
		["Normal"] = "The holder gains +25% of the stat the other brother has";
	};
	[37] =
	{
		["Normal"] = "Dark Esau consumes the cake upon damaging Jacob, preventing him from turning into The Lost # After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor";
		["Golden"] = "{{ColorGold}}Allow Jacob to get a free hit from Dark Esau, preventing him from turning into The Lost # {{ColorText}}After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor #Chance to turn into a regular {{Trinket"..Mod.Birthcake.ID.."}}Birthcake after being hit";
	};
	[39] =
	{
		["Normal"] = "Dark Esau consumes the cake upon damaging Jacob, preventing him from turning into The Lost # After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor";
		["Golden"] = "{{ColorGold}}Allow Jacob to get a free hit from Dark Esau, preventing him from turning into The Lost # {{ColorText}}After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor #Chance to turn into a regular {{Trinket"..Mod.Birthcake.ID.."}}Birthcake after being hit";
	};
} ]]

function BirthcakeRebaked:GetBirthcakeSprite(player)
	local playerType = player:GetPlayerType()
	local config = Mod.BirthcakeSprite[playerType]
	local sprite = Sprite()
	sprite:Load("gfx/005.350_trinket.anm2", false)
	sprite:ReplaceSpritesheet(0, config.SpritePath)
	sprite:LoadGraphics()
	local spriteResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.LOAD_BIRTHCAKE_SPRITE, playerType, player, sprite)
	sprite = (spriteResult ~= nil and type(spriteResult) == "userdata" and getmetatable(spriteResult).__type == "Sprite" and spriteResult) or
		sprite
	return sprite
end

include("src_birthcake.utility.hud_helper")
include("src_birthcake.utility.rgon_enums")
include("src_birthcake.utility.misc_util")
include("src_birthcake.utility.birthcake_util")
--include("src_birthcake.mcm")
include("src_birthcake.trinket_birthcake")
include("src_birthcake.challenge_birthday_party")

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
		local config = Mod.BirthcakeSprite[playerType]
		local name = config.Name or player:GetName() .. "'s Cake"
		local description = config.Description or "but its not your birthday..."
		local nameResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.PRE_BIRTHCAKE_ITEMTEXT_NAME, playerType, player)
		local descriptionResult = Isaac.RunCallbackWithParam(Mod.ModCallbacks.PRE_BIRTHCAKE_ITEMTEXT_DESCRIPTION,
			playerType,
			player)
		name = (nameResult ~= nil and tostring(nameResult)) or name
		description = (descriptionResult ~= nil and tostring(descriptionResult)) or description
		Mod.Game:GetHUD():ShowItemText(name, description, false)

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

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BirthcakeRebaked.ItemDesc)

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
	local player = Isaac.GetPlayer()
	local playerType = player:GetPlayerType()

	if Mod:IsBirthcake(pickup.SubType) then
		local sprite = pickup:GetSprite()
		local config = Mod.BirthcakeSprite[playerType]
		local anim = sprite:GetAnimation()
		if config.Anm2 then
			sprite:Load(config.Anm2, true)
			sprite:Play(anim)
		end
		if config.SpritePath then
			sprite:ReplaceSpritesheet(0, config.SpritePath)
		end
		sprite:LoadGraphics()

		Isaac.RunCallbackWithParam(Mod.ModCallbacks.LOAD_BIRTHCAKE_SPRITE, playerType, player, sprite)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BirthcakeRebaked.ChangeSpritePickup, PickupVariant.PICKUP_TRINKET)

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
