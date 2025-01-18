local Mod = BirthcakeRebaked
local game = Mod.Game

local SAMSON_CAKE = {}
BirthcakeRebaked.Birthcake.SAMSON = SAMSON_CAKE

-- Samson Birthcake

function SAMSON_CAKE:BloodLust(ent, amount, flags, source, dmg)
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

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SAMSON_CAKE.BloodLust, EntityType.ENTITY_PLAYER)

-- Tainted Samson Birthcake

SAMSON_CAKE.BASE_BERSERK_HELP_CHANCE = 0.2

function SAMSON_CAKE:BerserkRoomClear()
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_SAMSON_B)
			and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK)
		then
			local playerEffects = player:GetEffects()
			local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
			local roll = rng:RandomFloat()
			if roll < Mod:GetBalanceApprovedLuckChance(SAMSON_CAKE.BASE_BERSERK_HELP_CHANCE, Mod:GetTrinketMult(player)) then
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF,
					Mod.Game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40), Vector(0, 0), player)
				playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK, true, 1)
			end
		end
	end)
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, SAMSON_CAKE.BerserkRoomClear)
