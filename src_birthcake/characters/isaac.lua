local Mod = BirthcakeRebaked
local game = Mod.Game

local ISAAC_CAKE = {}

BirthcakeRebaked.Birthcake.ISAAC = ISAAC_CAKE

local frameCounter = 0
local frequency = 60

-- Isaac Birthcake

--TODO: Either rework or use Final Wishes

function ISAAC_CAKE:Switch(entity, newItemId)
	if entity.SubType == newItemId then
		return
	end

	local level = game:GetLevel()
	entity.SubType = newItemId
	if level:GetCurses() ~= LevelCurse.CURSE_OF_BLIND then
		local newItem = Isaac.GetItemConfig():GetCollectible(newItemId)
		entity:GetSprite():ReplaceSpritesheet(1, newItem.GfxFileName)
		entity:GetSprite():LoadGraphics()
	end
end

function ISAAC_CAKE:SwitchItem(player)
	frameCounter = frameCounter + 1
	if not Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
		return
	end

	local room = game:GetRoom()
	local entities = room:GetEntities()
	local level = game:GetLevel()

	for i = 0, #entities - 1 do
		local entity = entities:Get(i)
		if entity then
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				if room:IsFirstVisit() then
					if Mod:GetData(entity).isCycling == nil then
						Mod:GetData(entity).isCycling = false
					end

					if Mod:GetData(entity).CyclingID == nil then
						Mod:GetData(entity).CyclingID = {
							["original"] = entity.SubType,
							["new"] = 1
						}
					end

					table.insert(Mod:GetData(player).LastSeenItems, {
						["roomID"] = level:GetCurrentRoomIndex(),
						["isCycling"] = Mod:GetData(entity).isCycling,
						["original"] = Mod:GetData(entity).CyclingID.original,
						["new"] = Mod:GetData(entity).CyclingID.new,
					})
				else
					local roomID = level:GetCurrentRoomIndex()
					for i = 1, #Mod:GetData(player).LastSeenItems do
						if Mod:GetData(player).LastSeenItems[i].roomID == roomID then
							Mod:GetData(entity).isCycling = Mod:GetData(player).LastSeenItems[i].isCycling
							Mod:GetData(entity).CyclingID = {
								["original"] = Mod:GetData(player).LastSeenItems[i].original,
								["new"] = Mod:GetData(player).LastSeenItems[i].new
							}
						end
					end
				end

				if frameCounter % frequency == 0 and Mod:GetData(entity).isCycling then
					local ogItem = Mod:GetData(entity).CyclingID.original
					local newItem = Mod:GetData(entity).CyclingID.new
					if entity.SubType == ogItem then
						ISAAC_CAKE:Switch(entity, newItem)
					elseif entity.SubType == newItem then
						ISAAC_CAKE:Switch(entity, ogItem)
					end
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, ISAAC_CAKE.SwitchItem)

function ISAAC_CAKE:IsaacRerollPre(collectible, rng, player, useFlags, activeSlot, vardata)
	if not Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
		return nil
	end

	local room = game:GetRoom()
	local entities = room:GetEntities()
	local level = game:GetLevel()

	for i = 0, #entities - 1 do
		local entity = entities:Get(i)
		if entity then
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				Mod:GetData(entity).CyclingID.original = entity.SubType

				local roomID = level:GetCurrentRoomIndex()
				for i = 1, #Mod:GetData(player).LastSeenItems do
					if Mod:GetData(player).LastSeenItems[i].roomID == roomID then
						Mod:GetData(player).LastSeenItems[i].original = entity.SubType
					end
				end
			end
		end
	end
	return nil
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, ISAAC_CAKE.IsaacRerollPre, CollectibleType.COLLECTIBLE_D6)

function ISAAC_CAKE:IsaacReroll(collectible, rng, player, useFlags, activeSlot, vardata)
	if not Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
		return nil
	end

	local room = game:GetRoom()
	local entities = room:GetEntities()
	local level = game:GetLevel()

	for i = 0, #entities - 1 do
		local entity = entities:Get(i)
		if entity then
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				local roll = rng:RandomFloat()

				if roll < 0.25 then
					Mod:GetData(entity).isCycling = true
				end

				local roomID = level:GetCurrentRoomIndex()
				for i = 1, #Mod:GetData(player).LastSeenItems do
					if Mod:GetData(player).LastSeenItems[i].roomID == roomID then
						Mod:GetData(player).LastSeenItems[i].new = entity.SubType
						Mod:GetData(player).LastSeenItems[i].isCycling = Mod:GetData(entity).isCycling
						Mod:GetData(entity).isCycling = Mod:GetData(player).LastSeenItems[i].isCycling
						Mod:GetData(entity).CyclingID = {
							["original"] = Mod:GetData(player).LastSeenItems[i].original,
							["new"] = Mod:GetData(player).LastSeenItems[i].new
						}
					end
				end
			end
		end
	end
	return nil
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, ISAAC_CAKE.IsaacReroll, CollectibleType.COLLECTIBLE_D6)

-- Isaac B Birthcake

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

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, ISAAC_CAKE.Test, EntityType.ENTITY_PLAYER)
