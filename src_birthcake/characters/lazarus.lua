local Mod = BirthcakeRebaked
local game = Mod.Game

local LAZARUS_CAKE = {}
BirthcakeRebaked.Birthcake.LAZARUS = LAZARUS_CAKE

---@param player EntityPlayer
function LAZARUS_CAKE:CheckLazarusB(player)
	local playerType = player:GetPlayerType()
	return (playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B)
	and	player:HasTrinket(Mod.Birthcake.ID)
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
		effects:AddTrinketEffect(Mod.Birthcake.ID, false, effects:GetNullEffectNum(NullItemID.ID_LAZARUS_BOOST))
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

LAZARUS_CAKE.ITEM_SPLIT_CHANCE = 0.30
local ALIVE_COLOR = Color(1, 1, 1, 1, 0.7, 0.9, 1)
local DEAD_COLOR = Color(1, 1, 1, 1, 1, 0, 0)

---@param player EntityPlayer
function LAZARUS_CAKE:OnBirthcakeCollect(player)
	local player_run_save = Mod:GetLazBSharedSaveData(player)
	player_run_save.LazBCakeShared = player:GetPlayerType()
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, LAZARUS_CAKE.OnBirthcakeCollect)

---@param itemID CollectibleType
---@param rng RNG
---@param player EntityPlayer
function LAZARUS_CAKE:PreFlipPedestals(itemID, rng, player)
	for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
		local pickup = ent:ToPickup() ---@cast pickup EntityPickup
		Mod:GetData(pickup).FlipPedestal = ent.SubType
	end
end

---@param itemID CollectibleType
---@param rng RNG
---@param player EntityPlayer
function LAZARUS_CAKE:PostFlipPedestals(itemID, rng, player)
	local player_run_save = Mod:GetLazBSharedSaveData(player)
	if LAZARUS_CAKE:CheckLazarusB(player) or player_run_save.LazBCakeShared then
		--If the form expected to have Birthcake doesn't have it
		if player:GetPlayerType() == player_run_save.LazBCakeShared
			and not player:HasTrinket(Mod.Birthcake.ID)
		then
			player_run_save.LazBCakeShared = nil
			return
		--Update who has Birthcake
		elseif LAZARUS_CAKE:CheckLazarusB(player) then
			player_run_save.LazBCakeShared = player:GetPlayerType()
		end
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE)) do
			local pickup = ent:ToPickup() ---@cast pickup EntityPickup
			local previousSubType = Mod:GetData(pickup).FlipPedestal
			local randomFloat = player:GetTrinketRNG(Mod.Birthcake.ID):RandomFloat()
			local randomChance = Mod:GetBalanceApprovedChance(LAZARUS_CAKE.ITEM_SPLIT_CHANCE, Mod:GetTrinketMult(player))
			if previousSubType
				and pickup.SubType ~= previousSubType
				and randomFloat < randomChance
			then
				local useAlive = player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B
				pickup:Remove()
				local splitPedestal1 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, previousSubType,
					Mod.Game:GetRoom():FindFreePickupSpawnPosition(pickup.Position, 40, true), Vector.Zero, player):ToPickup()
				---@cast splitPedestal1 EntityPickup
				local splitPedestal2 = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, pickup
					.SubType,
					pickup.Position, Vector.Zero, player):ToPickup()
				---@cast splitPedestal2 EntityPickup
				splitPedestal1:SetColor(useAlive and ALIVE_COLOR or DEAD_COLOR, 30, 1, true, false)
				splitPedestal2:SetColor(useAlive and DEAD_COLOR or ALIVE_COLOR, 30, 1, true, false)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, LAZARUS_CAKE.PreFlipPedestals, CollectibleType.COLLECTIBLE_FLIP)
Mod:AddCallback(ModCallbacks.MC_USE_ITEM, LAZARUS_CAKE.PostFlipPedestals, CollectibleType.COLLECTIBLE_FLIP)

---@param player EntityPlayer
function LAZARUS_CAKE:OnPlayerTypeBChange(player)
	local playerType = player:GetPlayerType()
	if playerType ~= PlayerType.PLAYER_LAZARUS_B and playerType ~= PlayerType.PLAYER_LAZARUS2_B then
		local player_run_save = Mod:GetLazBSharedSaveData(player)
		player_run_save.LazBCakeShared = nil
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, LAZARUS_CAKE.OnPlayerTypeBChange, PlayerType.PLAYER_LAZARUS2)
Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, LAZARUS_CAKE.OnPlayerTypeBChange, PlayerType.PLAYER_LAZARUS2_B)