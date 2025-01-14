local Mod = BirthcakeRebaked
local game = Mod.Game
local BethanyBirthcake = {}

-- Functions

function BethanyBirthcake:CheckBethany(player)
	return player:GetPlayerType() == PlayerType.PLAYER_BETHANY
end

function BethanyBirthcake:CheckBethanyB(player)
	return player:GetPlayerType() == PlayerType.PLAYER_BETHANY_B
end

-- Bethany Birthcake

function BethanyBirthcake:BethanyNewRoom()
	local player = game:GetPlayer(0)
	if not BethanyBirthcake:CheckBethany(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		return
	end
	local player = game:GetPlayer(0)
	local isFirstVisit = game:GetRoom():IsFirstVisit()
	if isFirstVisit then
		Mod:GetData(player).hasBethanyWispSpawned = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BethanyBirthcake.BethanyNewRoom)

function BethanyBirthcake:BethanyWispSpawns(player)
	if not BethanyBirthcake:CheckBethany(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		return
	end
	local isRoomClear = game:GetRoom():IsClear()
	local isFirstVisit = game:GetRoom():IsFirstVisit()
	if isRoomClear and isFirstVisit and not Mod:GetData(player).hasBethanyWispSpawned then
		Mod:GetData(player).hasBethanyWispSpawned = true
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local roll = rng:RandomFloat()
		Isaac.ConsoleOutput(tostring(roll) .. "\n")
		if roll < 0.1 * player:GetTrinketMultiplier(Mod.Trinkets.BIRTHCAKE.ID) then
			local wisp = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, 0, player.Position, Vector(0, 0),
				player)
			wisp:GetSprite():Play("Appear", true)
			wisp:GetData().isWisp = true
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BethanyBirthcake.BethanyWispSpawns)

-- Tainted Bethany Birthcake

function BethanyBirthcake:LemegtonUse(collectibleID, rngObj, player, useFlags, activeSlot, varData)
	if not BethanyBirthcake:CheckBethanyB(player) or not player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) or collectibleID ~= CollectibleType.COLLECTIBLE_LEMEGETON or activeSlot ~= ActiveSlot.SLOT_POCKET then
		return nil
	end

	-- stop the activation of the item

	local roomType = game:GetRoom():GetType()
	local seed = game:GetSeeds():GetStartSeed()
	local roomItemPool = game:GetItemPool():GetPoolForRoom(roomType, seed)

	for i = 1, 2 do
		if roomItemPool ~= ItemPoolType.POOL_NULL then
			local item = CollectibleType.COLLECTIBLE_NULL
			while true do
				item = game:GetItemPool():GetCollectible(roomItemPool, false, Random())
				local itemConfig = Isaac.GetItemConfig():GetCollectible(1)
				if itemConfig:HasTags(ItemConfig.TAG_SUMMONABLE) and itemConfig.Type == ItemType.ITEM_PASSIVE then
					break
				end
			end

			player:AddItemWisp(item, player.Position, true)
		else
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_LEMEGETON)
			local item = CollectibleType.COLLECTIBLE_NULL
			while true do
				item = rng:RandomInt(CollectibleType.NUM_COLLECTIBLES)
				local itemConfig = Isaac.GetItemConfig():GetCollectible(item)
				if itemConfig and itemConfig:HasTags(ItemConfig.TAG_SUMMONABLE) and itemConfig.Type == ItemType.ITEM_PASSIVE then
					break
				end
			end
			player:AddItemWisp(item, player.Position, true)
		end
	end

	player:AnimateCollectible(CollectibleType.COLLECTIBLE_LEMEGETON, "UseItem", "PlayerPickupSparkle")
	SFXManager():Play(SoundEffect.SOUND_DEVILROOM_DEAL, 1, 0, false, 1)
	player:SetActiveCharge(player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + 6, ActiveSlot.SLOT_POCKET)

	if Mod:GetTrinketMult(player) > 1 then
		Isaac.ConsoleOutput(player:GetTrinket(0))
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		local roll = rng:RandomFloat()
		if roll < 0.5 then
			player:TryRemoveTrinket(Mod.Trinkets.BIRTHCAKE.ID)
			player:AddTrinket(Mod.Trinkets.BIRTHCAKE.ID)
		end
	else
		player:TryRemoveTrinket(Mod.Trinkets.BIRTHCAKE.ID)
	end

	return true
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, BethanyBirthcake.LemegtonUse, CollectibleType.COLLECTIBLE_LEMEGTON)
