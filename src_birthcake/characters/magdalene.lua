local Mod = BirthcakeRebaked
local game = Mod.Game

local MAGDALENE_CAKE = {}
BirthcakeRebaked.Birthcake.MAGDALENE = MAGDALENE_CAKE

MAGDALENE_CAKE.HEART_REPLACE_CHANCE = 0.25
MAGDALENE_CAKE.MAX_SOUL_HEART_BONUS = 3

-- Magdalene Birthcake

MAGDALENE_CAKE.HeartSubTypeConversion = {
	[HeartSubType.HEART_HALF] = HeartSubType.HEART_FULL,
	[HeartSubType.HEART_FULL] = HeartSubType.HEART_DOUBLEPACK,
	[HeartSubType.HEART_SCARED] = HeartSubType.HEART_DOUBLEPACK,
	[HeartSubType.HEART_HALF_SOUL] = HeartSubType.HEART_SOUL
}

function MAGDALENE_CAKE:HeartReplace(entType, variant, subType, position, velocity, spawner, seed)
	if entType == EntityType.ENTITY_PICKUP
		and variant == PickupVariant.PICKUP_HEART
	then
		local player = BirthcakeRebaked:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_MAGDALENE)
		if not player then return end
		local newVariant = MAGDALENE_CAKE.HeartSubTypeConversion

		if player and newVariant then
			local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
			local roll = rng:RandomFloat()
			if roll < Mod:GetBalanceApprovedLuckChance(MAGDALENE_CAKE.HEART_REPLACE_CHANCE, Mod:GetTrinketMult(player)) then
				return { EntityType.ENTITY_PICKUP, newVariant, HeartSubType.HEART_DOUBLEPACK, seed }
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, MAGDALENE_CAKE.HeartReplace)

-- Tainted Magdalene Birthcake

MAGDALENE_CAKE.HeartSubtypeDamage = {
	[HeartSubType.HEART_HALF] = 3.5,
	[HeartSubType.HEART_FULL] = 5.25,
	[HeartSubType.HEART_DOUBLEPACK] = 10.5,
	[HeartSubType.HEART_SCARED] = 5.25,
}

---@param pickup EntityPickup
function MAGDALENE_CAKE:HeartExplode(pickup)
	local damageMult = Mod:GetCombinedTrinketMult(PlayerType.PLAYER_MAGDALENE_B)

	if MAGDALENE_CAKE.HeartSubtypeDamage[pickup.SubType]
		and pickup.Timeout == 0
		and pickup:GetSprite():GetAnimation() ~= "Collect"
		and damageMult > 0
	then
		pickup:BloodExplode()
		local baseDamage = MAGDALENE_CAKE.HeartSubtypeDamage[pickup.SubType] + (0.5 * Mod.Game:GetLevel():GetStage())
		game:BombExplosionEffects(pickup.Position, baseDamage * damageMult, TearFlags.TEAR_BLOOD_BOMB, nil, Mod:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_MAGDALENE_B), 0.5, true,
			false, DamageFlag.DAMAGE_EXPLOSION)
		for _ = 1, 10 do
			local position = Vector(math.random(-25, 25), math.random(-25, 25))
			position = position + pickup.Position
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, position,
				Vector.Zero, pickup)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, position,
				Vector.Zero, pickup)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, MAGDALENE_CAKE.HeartExplode, PickupVariant.PICKUP_HEART)
