local Mod = BirthcakeRebaked
local game = Mod.Game

local LAZARUS_CAKE = {}
BirthcakeRebaked.Birthcake.LAZARUS = LAZARUS_CAKE

---@param player EntityPlayer
function LAZARUS_CAKE:CheckLazarusB(player)
	local playerType = player:GetPlayerType()
	return (playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B) and player:HasTrinket(Mod.Birthcake.ID)
end

-- Lazarus Birthcake

LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP = "Laz Birthcake"

---@param player EntityPlayer
function LAZARUS_CAKE:CheckBirthcake(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and Mod.HiddenItemManager:CountStack(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP) == 0
	then
		local effects = player:GetEffects()
		Mod.HiddenItemManager:Add(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS, -1, 1, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
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
		local hasBirthcakeRevive = Mod.HiddenItemManager:CountStack(player, CollectibleType.COLLECTIBLE_LAZARUS_RAGS, LAZARUS_CAKE.HIDDEN_ITEM_MANAGER_GROUP) > 0
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

function LAZARUS_CAKE:NewGame()
	--[[ LazarusItem = {}
	DeadLazarusItem = {}
	SharedItem = -1
	dead = false
	lazarusRisen = false
	upgraded = false ]]
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, LAZARUS_CAKE.NewGame)

function LAZARUS_CAKE:UpdateItems()
	--[[ local player = game:GetPlayer(0)

	if not LAZARUS_CAKE:CheckLazarusB(player) then
		return
	end

	if not player:HasTrinket(Mod.Birthcake.ID) then
		if SharedItem ~= -1 then
			player:GetEffects():RemoveCollectibleEffect(SharedItem)
			SharedItem = -1
		end
	end

	if player:HasTrinket(Mod.Birthcake.ID) then
		if Mod:GetTrinketMult(player, true) > 1 then
			upgraded = true
		else
			upgraded = false
		end
	end

	local ItemCount = Isaac:GetItemConfig():GetCollectibles().Size - 1
	for i = 1, ItemCount do
		local itemConfig = Mod.ItemConfig:GetCollectible(i)
		if player:HasCollectible(i, true) and (itemConfig.Type == ItemType.ITEM_PASSIVE or itemConfig.Type == ItemType.ITEM_FAMILIAR) and not itemConfig:HasTags(ItemConfig.TAG_LAZ_SHARED) and not itemConfig:HasTags(ItemConfig.TAG_LAZ_SHARED_GLOBAL) then
			if upgraded and itemConfig.Quality == 0 then
				goto continue
			end
			local playerType = player:GetPlayerType()
			if playerType == PlayerType.PLAYER_LAZARUS_B and not Mod:IsInList(i, LazarusItem) then
				table.insert(LazarusItem, i)
			elseif playerType == PlayerType.PLAYER_LAZARUS2_B and not Mod:IsInList(i, DeadLazarusItem) then
				table.insert(DeadLazarusItem, i)
			end
		end
		::continue::
	end
	local playerType = player:GetPlayerType()
	for i = 1, #LazarusItem do
		if not player:HasCollectible(LazarusItem[i], true) and playerType == PlayerType.PLAYER_LAZARUS_B then
			table.remove(LazarusItem, i)
		end
		local itemConfig = Mod.ItemConfig:GetCollectible(LazarusItem[i])
		if upgraded and itemConfig.Quality == 0 then
			table.remove(LazarusItem, i)
		end
	end
	for i = 1, #DeadLazarusItem do
		if not player:HasCollectible(DeadLazarusItem[i], true) and playerType == PlayerType.PLAYER_LAZARUS2_B then
			table.remove(DeadLazarusItem, i)
		end
		local itemConfig = Mod.ItemConfig:GetCollectible(DeadLazarusItem[i])
		if upgraded and itemConfig.Quality == 0 then
			table.remove(DeadLazarusItem, i)
		end
	end ]]
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, LAZARUS_CAKE.UpdateItems)

function LAZARUS_CAKE:Gift()
	--[[ local player = game:GetPlayer(0)
	if not LAZARUS_CAKE:CheckLazarusB(player) or not player:HasTrinket(Mod.Birthcake.ID) then
		return nil
	end

	if SharedItem ~= -1 then
		player:GetEffects():RemoveCollectibleEffect(SharedItem)
		SharedItem = -1
	end

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	local playerType = player:GetPlayerType()
	if playerType == PlayerType.PLAYER_LAZARUS_B then
		if #DeadLazarusItem > 0 then
			SharedItem = DeadLazarusItem[rng:RandomInt(#DeadLazarusItem) + 1]
		end
	elseif playerType == PlayerType.PLAYER_LAZARUS2_B then
		if #LazarusItem > 0 then
			SharedItem = LazarusItem[rng:RandomInt(#LazarusItem) + 1]
		end
	end

	Isaac.ConsoleOutput("Shared Item: " .. tostring(SharedItem) .. "\n")
	if SharedItem ~= -1 then
		player:GetEffects():AddCollectibleEffect(SharedItem)
	end ]]
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, LAZARUS_CAKE.Gift)
