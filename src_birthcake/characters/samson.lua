local Mod = BirthcakeRebaked
local game = Mod.Game

local SAMSON_CAKE = {}
BirthcakeRebaked.Birthcake.SAMSON = SAMSON_CAKE

-- Samson Birthcake

---@param player EntityPlayer
function SAMSON_CAKE:SpawnReward(player)
	local effects = player:GetEffects()
	local addedHearts = 0
	for _ = 1, 2 do
		local variant = HeartSubType.HEART_FULL
		if Mod:GetTrinketMult(player) > 1 then
			local health = player:GetHearts() + player:GetRottenHearts() + addedHearts
			local maxHealth = player:GetEffectiveMaxHearts()

			if health >= maxHealth then
				variant = HeartSubType.HEART_SOUL
			elseif health <= maxHealth * 0.5 then
				variant = HeartSubType.HEART_DOUBLEPACK
				addedHearts = addedHearts + 4
			else
				addedHearts = addedHearts + 2
			end
		end
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, variant,
			Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
	end
	effects:AddTrinketEffect(Mod.Birthcake.ID)
end

---@param ent Entity
function SAMSON_CAKE:BloodLust(ent, amount, flags, source, dmg)
	local player = ent:ToPlayer() ---@cast player EntityPlayer
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_SAMSON) then
		local effects = player:GetEffects()
		local bloodyLustStack = effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BLOODY_LUST)
		local numTimesTriggered = effects:GetTrinketEffectNum(Mod.Birthcake.ID)

		if bloodyLustStack == 5 and numTimesTriggered < 1
			or (bloodyLustStack == 9 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) and numTimesTriggered < 2
		then
			SAMSON_CAKE:SpawnReward(player)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SAMSON_CAKE.BloodLust, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function SAMSON_CAKE:GrantRewardIfMissing(player)
	if player:HasTrinket(Mod.Birthcake.ID) and not player.QueuedItem.Item then
		local effects = player:GetEffects()
		local bloodyLustStack = effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BLOODY_LUST)
		local numTimesTriggered = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
		if bloodyLustStack >= 6 and numTimesTriggered < 1
			or bloodyLustStack >= 10 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and numTimesTriggered < 2
		then
			SAMSON_CAKE:SpawnReward(player)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, SAMSON_CAKE.GrantRewardIfMissing, PlayerType.PLAYER_SAMSON)

function SAMSON_CAKE:ResetBirthcakeEffects()
	Mod:ForEachPlayer(function (player)
		local effects = player:GetEffects()
		if player:GetPlayerType() == PlayerType.PLAYER_SAMSON and effects:GetTrinketEffectNum(Mod.Birthcake.ID) > 0 then
			player:GetEffects():RemoveTrinketEffect(Mod.Birthcake.ID, -1)
		end
	end)
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SAMSON_CAKE.ResetBirthcakeEffects)

-- Tainted Samson Birthcake

SAMSON_CAKE.BERSERK_INCREASE_CHANCE = 0.25

function SAMSON_CAKE:BerserkRoomClear()
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_SAMSON_B)
			and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		then
			local playerEffects = player:GetEffects()
			local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
			local roll = rng:RandomFloat()
			if roll <= Mod:GetBalanceApprovedChance(SAMSON_CAKE.BERSERK_INCREASE_CHANCE, Mod:GetTrinketMult(player)) then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF,
					Mod.Game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40), Vector(0, 0), player)
				playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK, true, 1)
				Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
			end
		end
	end)
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, SAMSON_CAKE.BerserkRoomClear)
