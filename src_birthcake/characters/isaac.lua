local Mod = BirthcakeRebaked
local game = Mod.Game

local ISAAC_CAKE = {}

BirthcakeRebaked.Birthcake.ISAAC = ISAAC_CAKE

-- Isaac Birthcake

function ISAAC_CAKE:SpawnTreasureDiceShard()
	local room = Mod.Game:GetRoom()
	if room:GetType() ~= RoomType.ROOM_TREASURE then return end
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
			for _ = 1, Mod:GetTrinketMult(player) do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD,
				room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, player)
			end
		end
	end)
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ISAAC_CAKE.SpawnTreasureDiceShard)

function ISAAC_CAKE:SpawnBossDiceShard()
	local room = Mod.Game:GetRoom()
	if room:GetType() ~= RoomType.ROOM_BOSS then return end
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
			for _ = 1, Mod:GetTrinketMult(player) do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD,
				room:FindFreePickupSpawnPosition(room:GetCenterPos() - Vector(0, 40)), Vector.Zero, player)
			end
		end
	end)
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, ISAAC_CAKE.SpawnBossDiceShard)

-- Isaac B Birthcake
--[[
---@param player EntityPlayer
function ISAAC_CAKE:Test(player, damage, flags, source, cdframes)
	if player.Type ~= EntityType.ENTITY_PLAYER then
		return
	end

	player = player:ToPlayer()

	if not Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC_B) then
		return
	end

	if player:GetCollectibleCount() < 8 then
		return
	end

	local items = {}

	for i = 1, #Isaac.GetItemConfig():GetCollectibles() - 1 do
		if player:HasCollectible(i) and not Mod:IsInList(i, items) and Isaac:GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_PASSIVE then
			table.insert(items, i)
		end
	end

	if #items == 0 then
		return
	end

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	local randint = rng:RandomInt(#items)
	local itemID = items[randint + 1]
	local roll = rng:RandomFloat()

	if roll < 0.25 then
		player:AddCollectible(itemID, 0, true)
		roll = rng:RandomFloat()
		if roll < 0.50 then
			player:TryRemoveTrinket(Mod.Birthcake.ID)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ISAAC_CAKE.Test, EntityType.ENTITY_PLAYER) ]]
