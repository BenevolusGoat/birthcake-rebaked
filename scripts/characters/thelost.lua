local Mod = BirthcakeRebaked
local game = Mod.Game
local TheLostCake = {}
local FreeRoll = 2

-- functions

function TheLostCake:CheckLost(player)
	return player:GetPlayerType() == PlayerType.PLAYER_THELOST
end

function TheLostCake:CheckLostB(player)
	return player:GetPlayerType() == PlayerType.PLAYER_THELOST_B
end

-- The Lost Birthcake

function TheLostCake:NewFloor()
	FreeRoll = 2
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, TheLostCake.NewFloor)

function TheLostCake:FreeUse(collectibleID, rngObj, player, useFlags, activeSlot, varData)
	if not TheLostCake:CheckLost(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		return nil
	end

	if collectibleID == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
		if FreeRoll > 0 then
			FreeRoll = FreeRoll - 1
			local entites = Isaac.GetRoomEntities()
			for i = 1, #entites do
				local entity = entites[i]
				if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
					local collectible = entity:ToPickup()
					collectible:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, true)
				end
			end
			player:AnimateCollectible(CollectibleType.COLLECTIBLE_ETERNAL_D6, "Pickup", "PlayerPickupSparkle")
			player:SetActiveCharge(player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) + 2)
			return true
		else
			return nil
		end
	else
		if FreeRoll > 0 then
			FreeRoll = 0
			local itemConfig = Isaac.GetItemConfig():GetCollectible(collectibleID)
			player:SetActiveCharge(player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY) + itemConfig.MaxCharges)
			return nil
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, TheLostCake.FreeUse)

function TheLostCake:DrawText()
	local player = Isaac.GetPlayer(0)
	if not TheLostCake:CheckLost(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		Isaac.RenderText("", 45, 40, 255, 255, 255, 255)
		return
	end
	if FreeRoll > 0 then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ETERNAL_D6) then
			Isaac.RenderText("x" .. FreeRoll, 42, 35, 255, 255, 255, 255)
		else
			Isaac.RenderScaledText("x1", 44, 38, 0.75, 0.75, 255, 255, 255, 255)
		end
	else
		Isaac.RenderText("", 45, 30, 255, 255, 255, 255)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_RENDER, TheLostCake.DrawText)

-- Tainted Lost Birthcake

function TheLostCake:Fortune()
	local player = Isaac.GetPlayer(0)

	if not TheLostCake:CheckLostB(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		return
	end

	local entites = Isaac.GetRoomEntities()
	for i = 1, #entites do
		local entity = entites[i]
		if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SpawnerType ~= EntityType.ENTITY_PLAYER then
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			local float = rng:RandomFloat()
			if float < 0.5 then
				SFXManager():Play(SoundEffect.SOUND_PARTY_HORN, 1, 0, false, 1)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1,
					Isaac.GetFreeNearPosition(entity.Position, 10), Vector(0, 0), player)
				local float = rng:RandomFloat()
				if float < 0.25 then
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0,
						Isaac.GetFreeNearPosition(player.Position, 10), Vector(0, 0), player)
					for j = 1, #entites do
						local entity2 = entites[j]
						if entity2:IsEnemy() then
							entity2:TakeDamage(100, 0, EntityRef(player), 0)
						end
					end
					local playerEffects = player:GetEffects()
					if playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE) then
						player:TakeDamage(1, 0, EntityRef(player), 0)
					end
					player:TryRemoveTrinket(Mod.Trinkets.BIRTHCAKE.ID)
				end
			end
			entity.SpawnerType = EntityType.ENTITY_PLAYER
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, TheLostCake.Fortune)
