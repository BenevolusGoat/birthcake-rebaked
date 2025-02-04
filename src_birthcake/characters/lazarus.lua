local Mod = BirthcakeRebaked
local game = Mod.Game

local LAZARUS_CAKE = {}
BirthcakeRebaked.Birthcake.LAZARUS = LAZARUS_CAKE

--"lazarusshared" doesn't work for TRINKETS so this is my only other option non-rgon *fucking sobbing out my ass*
local flippedLazPlayer = {}

---@param player EntityPlayer
function LAZARUS_CAKE:CheckLazarusB(player)
	local playerType = player:GetPlayerType()
	local isLaz = (playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B)
	local twin = player:GetOtherTwin() --Birthright, works on non-rgon and rgon
	local otherLaz
	if not twin then
		if REPENTOGON then
			otherLaz = player:GetFlippedForm()
		else
			otherLaz = flippedLazPlayer[player.Index]
		end
	else
		otherLaz = twin
	end
	return isLaz and (otherLaz and otherLaz:HasTrinket(Mod.Birthcake.ID) or player:HasTrinket(Mod.Birthcake.ID))
end

-- Lazarus Birthcake

LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP = "Laz Birthcake"

---@param player EntityPlayer
function LAZARUS_CAKE:CheckBirthcake(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and Mod.HiddenItemManager:CountStack(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP) == 0
	then
		local effects = player:GetEffects()
		Mod.HiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS, -1, 1,
			LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
		local reviveNum = effects:GetNullEffectNum(NullItemID.ID_LAZARUS_BOOST)
		local reviveTracker = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
		effects:AddTrinketEffect(Mod.Birthcake.ID, false, reviveNum - reviveTracker)
	elseif not player:HasTrinket(Mod.Birthcake.ID)
		and Mod.HiddenItemManager:CountStack(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP) > 0
	then
		Mod.HiddenItemManager:RemoveAll(player, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
	end
end

---@param player EntityPlayer
function LAZARUS_CAKE:CheckRisenDeath(player)
	local data = Mod:GetData(player)
	---If you've already revived as Laz Risen, and you suddenly receive another boost, likely from our wisp
	if player:HasTrinket(Mod.Birthcake.ID) then
		local hasBirthcakeRevive = Mod.HiddenItemManager:CountStack(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
			LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP) > 0
		local effects = player:GetEffects()
		local reviveNum = effects:GetNullEffectNum(NullItemID.ID_LAZARUS_BOOST)
		local reviveTracker = effects:GetTrinketEffectNum(Mod.Birthcake.ID)

		if reviveTracker < reviveNum then
			effects:AddTrinketEffect(Mod.Birthcake.ID, false, reviveNum - reviveTracker)
			if not data.LazCakeHasRags and hasBirthcakeRevive then
				local hadGolden = player:TryRemoveTrinket(Mod.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
				local momsBoxBonus = player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and 1 or 0
				if hadGolden then
					local bonus = 1 + momsBoxBonus
					effects:AddNullEffect(NullItemID.ID_LAZARUS_BOOST, false, bonus)
					effects:AddTrinketEffect(Mod.Birthcake.ID, false, bonus)
				else
					player:TryRemoveTrinket(Mod.Birthcake.ID)
					effects:AddNullEffect(NullItemID.ID_LAZARUS_BOOST, false, momsBoxBonus)
					effects:AddTrinketEffect(Mod.Birthcake.ID, false, momsBoxBonus)
				end
				Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
				if not player:HasTrinket(Mod.Birthcake.ID) then
					Mod.HiddenItemManager:RemoveAll(player, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
				end
			end
		end
	end
	data.LazCakeHasRags = player:HasCollectible(CollectibleType.COLLECTIBLE_LAZARUS_RAGS, true, true)
end

---@param player EntityPlayer
function LAZARUS_CAKE:OnLazRisenPeffectUpdate(player)
	LAZARUS_CAKE:CheckBirthcake(player)
	LAZARUS_CAKE:CheckRisenDeath(player)
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, LAZARUS_CAKE.OnLazRisenPeffectUpdate, PlayerType.PLAYER_LAZARUS2)

---@param player EntityPlayer
function LAZARUS_CAKE:OnPlayerTypeChange(player)
	Mod.HiddenItemManager:RemoveAll(player, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, LAZARUS_CAKE.OnPlayerTypeChange, PlayerType.PLAYER_LAZARUS2)

-- Tainted Lazarus Birthcake

local ALIVE_COLOR = Color(1, 1, 1, 1, 0.7, 0.9, 1)
local DEAD_COLOR = Color(1, 1, 1, 1, 1, 0, 0)

---@param itemID CollectibleType
---@param rng RNG
---@param player EntityPlayer
function LAZARUS_CAKE:PreFlipPedestals(itemID, rng, player)
	for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
		local pickup = ent:ToPickup() ---@cast pickup EntityPickup
		if pickup.SubType ~= CollectibleType.COLLECTIBLE_NULL then
			Mod:GetData(pickup).FlipPedestal = { pickup.SubType, pickup.Price }
		end
	end
end

LAZARUS_CAKE.DevilPriceSplit = {
	[PickupPrice.PRICE_THREE_SOULHEARTS] = PickupPrice.PRICE_ONE_SOUL_HEART,
	[PickupPrice.PRICE_TWO_HEARTS] = PickupPrice.PRICE_ONE_HEART,
	[PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS] = PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART,
	[PickupPrice.PRICE_TWO_SOUL_HEARTS] = PickupPrice.PRICE_ONE_SOUL_HEART,
}

---@param pickup EntityPickup
---@param player EntityPlayer
---@param previousItemID integer
---@param previousPrice integer
function LAZARUS_CAKE:SpawnSplitPedestals(pickup, player, previousItemID, previousPrice)
	local useAlive = player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B
	for i = 1, 2 do
		local subtype = i == 1 and previousItemID or pickup.SubType
		local pos = i == 1 and Vector(40, 0) or Vector(-40, 0)
		useAlive = i == 1 and useAlive or not useAlive
		local splitPedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, subtype,
			Mod.Game:GetRoom():FindFreePickupSpawnPosition(pickup.Position + pos, 0), Vector.Zero, player):ToPickup()
		---@cast splitPedestal EntityPickup
		splitPedestal:SetColor(useAlive and ALIVE_COLOR or DEAD_COLOR, 30, 1, true, false)
		local price = i == 1 and previousPrice or pickup.Price
		if price >= 2 then
			price = (price / 2) // 1
		elseif LAZARUS_CAKE.DevilPriceSplit[price] then
			price = LAZARUS_CAKE.DevilPriceSplit[price]
		end
		splitPedestal.Price = price
		splitPedestal.AutoUpdatePrice = price ~= PickupPrice.PRICE_FREE
		splitPedestal.ShopItemId = -1
	end
end

---@param itemID CollectibleType
---@param rng RNG
---@param player EntityPlayer
function LAZARUS_CAKE:PostFlipPedestals(itemID, rng, player)
	if LAZARUS_CAKE:CheckLazarusB(player) then
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
			local pickup = ent:ToPickup() ---@cast pickup EntityPickup
			local data = Mod:GetData(pickup)
			if not data.FlipPedestal then goto continue end
			local previousItemID = data.FlipPedestal[1]
			local previousPrice = data.FlipPedestal[2]

			if pickup.SubType ~= previousItemID then
				pickup:Remove()
				LAZARUS_CAKE:SpawnSplitPedestals(pickup, player, previousItemID, previousPrice)
			end
			::continue::
		end
	end
	--If RGON or Birthright, don't bother
	if REPENTOGON or player:GetOtherTwin() then return end
	local playerType = player:GetPlayerType()
	if (playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B) then
		flippedLazPlayer[player.Index] = player
	elseif flippedLazPlayer[player.Index] then
		flippedLazPlayer[player.Index] = nil
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, LAZARUS_CAKE.PreFlipPedestals, CollectibleType.COLLECTIBLE_FLIP)
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, LAZARUS_CAKE.PostFlipPedestals, CollectibleType.COLLECTIBLE_FLIP)

---@param player EntityPlayer
function LAZARUS_CAKE:OnPlayerTypeBChange(player)
	local playerType = player:GetPlayerType()
	if playerType ~= PlayerType.PLAYER_LAZARUS_B and playerType ~= PlayerType.PLAYER_LAZARUS2_B then
		flippedLazPlayer[player.Index] = nil
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, LAZARUS_CAKE.OnPlayerTypeBChange, PlayerType.PLAYER_LAZARUS2)
Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, LAZARUS_CAKE.OnPlayerTypeBChange, PlayerType.PLAYER_LAZARUS2_B)
