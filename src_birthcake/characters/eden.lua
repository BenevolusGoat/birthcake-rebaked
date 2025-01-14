local Mod = BirthcakeRebaked
local game = Mod.Game
local EdenCake = {}
ImitedItem = 0
local firstTime = true
local hasTrinket = false

-- functions

function EdenCake:CheckEden(player)
	return player:GetPlayerType() == PlayerType.PLAYER_EDEN
end

function EdenCake:CheckEdenB(player)
	return player:GetPlayerType() == PlayerType.PLAYER_EDEN_B
end

function EdenCake:GameExit(_, bool)
	SaveData.Eden.ImitedItem = ImitedItem
	SaveData.Eden.FirstTime = firstTime
	SaveData.Eden.HasTrinket = hasTrinket
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_GAME_EXIT, CallbackPriority.EARLY, EdenCake.GameExit)
Mod:AddPriorityCallback(ModCallbacks.MC_POST_GAME_END, CallbackPriority.EARLY, EdenCake.GameExit)

-- Eden Birthcake

function EdenCake:ResetItem(IsContinued)
	if IsContinued then
		ImitedItem = SaveData.Eden.ImitedItem
		firstTime = SaveData.Eden.FirstTime
		hasTrinket = SaveData.Eden.HasTrinket
		return
	else
		ImitedItem = 0
		firstTime = true
		hasTrinket = false
	end

	local player = Isaac.GetPlayer(0)
	local ItemConfig = Isaac.GetItemConfig()
	local ItemCount = #ItemConfig:GetCollectibles() - 1
	local ItemQuality = 0
	for i = 1, ItemCount do
		if player:HasCollectible(i) and ItemConfig:GetCollectible(i).Type == ItemType.ITEM_PASSIVE then
			local Quality = ItemConfig:GetCollectible(i).Quality
			if Quality > ItemQuality then
				ItemQuality = Quality
			end
		end
	end
	local ItemID = 0
	while true do
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		ItemID = rng:RandomInt(ItemCount) + 1
		local itemConfig = ItemConfig:GetCollectible(ItemID)
		if itemConfig and ItemQuality >= 2 and itemConfig.Type == ItemType.ITEM_PASSIVE and itemConfig:IsAvailable() then
			break
		else
			if itemConfig and itemConfig.Quality == 4 and itemConfig.Type == ItemType.ITEM_PASSIVE and itemConfig:IsAvailable() then
				break
			end
		end
	end
	ImitedItem = ItemID
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, EdenCake.ResetItem)

function EdenCake:GetItem()
	local player = Isaac.GetPlayer(0)
	if not EdenCake:CheckEden(player) then
		return
	end

	if ImitedItem == 0 then
		return
	end

	if not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		if player:HasCollectible(ImitedItem) and hasTrinket then
			player:RemoveCollectible(ImitedItem)
			hasTrinket = false
		end
		return
	end

	if player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) and not hasTrinket then
		hasTrinket = true
		player:AddCollectible(ImitedItem, 0, firstTime)
		if firstTime then
			firstTime = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, EdenCake.GetItem)

-- Tainted Eden birthcake

function EdenCake:Undecided()
	local player = Isaac.GetPlayer(0)

	if not EdenCake:CheckEdenB(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		return
	end

	local entites = Isaac.GetRoomEntities()

	for i = 1, #entites do
		local entity = entites[i]
		if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SpawnerType ~= EntityType.ENTITY_PLAYER then
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			local roll = rng:RandomFloat()
			Isaac.ConsoleOutput(tostring(roll))
			if roll < 0.5 then
				roll = rng:RandomFloat()
				if roll < 0.5 then
					player:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, 0, false)
					entity:Remove()
					local newEntity = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1,
						entity.Position, Vector(0, 0), player):ToPickup()
					newEntity.Price = entity:ToPickup().Price
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
				else
					player:AddCollectible(CollectibleType.COLLECTIBLE_CHAOS, 0, false)
					entity:Remove()
					local newEntity = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1,
						entity.Position, Vector(0, 0), player):ToPickup()
					newEntity.Price = entity:ToPickup().Price
					player:RemoveCollectible(CollectibleType.COLLECTIBLE_CHAOS)
				end
			else
				entity.SpawnerType = EntityType.ENTITY_PLAYER
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, EdenCake.Undecided)
