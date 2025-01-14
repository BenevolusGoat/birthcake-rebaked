local Mod = BirthcakeRebaked
local game = Mod.Game
local SamsonCake = {}

-- functions

function SamsonCake:CheckSamson(player)
	return player:GetPlayerType() == PlayerType.PLAYER_SAMSON
end

function SamsonCake:CheckSamsonB(player)
	return player:GetPlayerType() == PlayerType.PLAYER_SAMSON_B
end

-- Samson Birthcake

function SamsonCake:BloodLust(ent, amount, flags, source, dmg)
	local player = ent:ToPlayer() ---@cast player EntityPlayer
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_SAMSON) then
		local bloodyLustStack = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BLOODY_LUST)
		if bloodyLustStack == 6 or (bloodyLustStack == 10 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)) then
			for i = 1, 2 do
				local variant = HeartSubType.HEART_FULL
				if Mod:GetTrinketMult(player) > 1 then
					local health = player:GetHearts() + (i - 1) * 2
					local maxHealth = player:GetEffectiveMaxHearts()
					if health >= maxHealth then
						variant = HeartSubType.HEART_SOUL
					elseif health <= maxHealth / 2 + 1 then
						variant = HeartSubType.HEART_DOUBLEPACK
					end
				end
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, variant,
					Isaac.GetFreeNearPosition(player.Position, 10), Vector.Zero, player)
			end
		end
	end

end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SamsonCake.BloodLust, EntityType.ENTITY_PLAYER)

-- Tainted Samson Birthcake

function SamsonCake:NewRoom()
	local room = game:GetRoom()
	if room:IsFirstVisit() then
		gotReward = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SamsonCake.NewRoom)

function SamsonCake:BerserkRoomClear()
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_SAMSON_B)
			and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		then
			local playerEffects = player:GetEffects()
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			local roll = rng:RandomFloat()
			if roll < 0.25 then
				--TODO: WEIGTHED chances to spawning hearts
				--SFXManager():Play(SoundEffect.SOUND_PARTY_HORN, 1, 0, false, 1)
				local variant = rng:RandomInt(12)
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, variant,
					Isaac.GetFreeNearPosition(player.Position, 10), Vector(0, 0), player)
				playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK, true, 1)
			end
		end
	end)

end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, SamsonCake.BerserkRoomClear)
