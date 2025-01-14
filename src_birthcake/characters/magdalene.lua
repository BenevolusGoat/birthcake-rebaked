local Mod = BirthcakeRebaked
local game = Mod.Game

local MAGDALENE_CAKE = {}
BirthcakeRebaked.Characters.MAGDALENE = MAGDALENE_CAKE

MAGDALENE_CAKE.HEART_REPLACE_CHANCE = 0.50
MAGDALENE_CAKE.MAX_SOUL_HEART_BONUS = 3

-- Magdalene Birthcake

function MAGDALENE_CAKE:SoulRefill(_, _, player, _, _, _)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_MAGDALENE) then
		player:AddSoulHearts(math.min(MAGDALENE_CAKE.MAX_SOUL_HEART_BONUS, 1 * Mod:GetTrinketMult(player)))
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, MAGDALENE_CAKE.SoulRefill, CollectibleType.COLLECTIBLE_YUM_HEART)

function MAGDALENE_CAKE:HeartReplace(entType, variant, subType, position, velocity, spawner, seed)
	if entType == EntityType.ENTITY_PICKUP
		and variant == PickupVariant.PICKUP_HEART
	then
		local player = BirthcakeRebaked:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_MAGDALENE)
		if not player then return end

		if player and (subType == HeartSubType.HEART_HALF or subType == HeartSubType.HEART_FULL) then
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			local roll = rng:RandomFloat()
			if roll < MAGDALENE_CAKE.HEART_REPLACE_CHANCE then
				return { EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, seed }
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, MAGDALENE_CAKE.HeartReplace)

-- Tainted Magdalene Birthcake

---@param pickup EntityPickup
function MAGDALENE_CAKE:HeartExplode(pickup)
	local data = Mod:GetData(pickup)
	if pickup.Timeout ~= -1 then
		data.OhMyGodJCABomb = true
	end

	local damageMult = 0

	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_MAGDALENE_B) then
			damageMult = damageMult + (Mod:GetTrinketMult(player))
		end
	end)

	if pickup.Variant == PickupVariant.PICKUP_HEART and pickup.Timeout ~= -1 and not pickup.Touched and damageMult > 0 then
		pickup:BloodExplode()
		game:BombExplosionEffects(pickup.Position, 5.25 * damageMult, TearFlags.TEAR_BLOOD_BOMB, nil, nil, 0.5, true, false, DamageFlag.DAMAGE_EXPLOSION)
		for _ = 1, 10 do
			local position = Vector(math.random(-25, 25), math.random(-25, 25))
			position = position + pickup.Position
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, position,
				Vector(0, 0), pickup)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, position,
				Vector(0, 0), pickup)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, MAGDALENE_CAKE.HeartExplode, EntityType.ENTITY_PICKUP)
