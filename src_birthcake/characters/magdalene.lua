local Mod = BirthcakeRebaked
local game = Mod.Game

local MAGDALENE_CAKE = {}
BirthcakeRebaked.Birthcake.MAGDALENE = MAGDALENE_CAKE

MAGDALENE_CAKE.HEART_REPLACE_CHANCE = 0.33

-- Magdalene Birthcake

MAGDALENE_CAKE.HeartSubTypeConversion = {
	[HeartSubType.HEART_HALF] = HeartSubType.HEART_FULL,
	[HeartSubType.HEART_FULL] = HeartSubType.HEART_DOUBLEPACK,
	[HeartSubType.HEART_SCARED] = HeartSubType.HEART_DOUBLEPACK,
	[HeartSubType.HEART_HALF_SOUL] = HeartSubType.HEART_SOUL
}

---@param pickup EntityPickup
function MAGDALENE_CAKE:HeartReplace(pickup)
	local pickup_save = Mod:TryGetNoRerollSave(pickup)
	local player = BirthcakeRebaked:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_MAGDALENE)
	if not player then return end
	local newSubType = MAGDALENE_CAKE.HeartSubTypeConversion[pickup.SubType]

	if player
		and newSubType
		and (not pickup_save
			or not pickup_save.NoRerollSave.MagdaleneCakeUpgradedPickup)
	then
		pickup_save = Mod:GetNoRerollSave(pickup)
		local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
		if rng:RandomFloat()
			<= Mod:GetBalanceApprovedChance(MAGDALENE_CAKE.HEART_REPLACE_CHANCE, Mod:GetTrinketMult(player))
		then
			pickup_save.MagdaleneCakeUpgradedPickup = true
			pickup:Morph(pickup.Type, pickup.Variant, newSubType, true, true)
			Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, MAGDALENE_CAKE.HeartReplace, PickupVariant.PICKUP_HEART)

-- Tainted Magdalene Birthcake

MAGDALENE_CAKE.HeartSubtypeDamage = {
	[HeartSubType.HEART_HALF] = 3.5,
	[HeartSubType.HEART_FULL] = 5.25,
	[HeartSubType.HEART_DOUBLEPACK] = 10.5,
	[HeartSubType.HEART_SCARED] = 5.25,
}

local random = math.random

---@param pickup EntityPickup
function MAGDALENE_CAKE:HeartExplode(pickup)
	local trinketMult = Mod:GetCombinedTrinketMult(PlayerType.PLAYER_MAGDALENE_B)

	if MAGDALENE_CAKE.HeartSubtypeDamage[pickup.SubType]
		and pickup.Timeout == 0
		and pickup:GetSprite():GetAnimation() ~= "Collect"
		and trinketMult > 0
	then
		pickup:BloodExplode()
		local damage = (MAGDALENE_CAKE.HeartSubtypeDamage[pickup.SubType] + (0.5 * Mod.Game:GetLevel():GetStage())) *
		trinketMult
		for _, ent in ipairs(Isaac.FindInRadius(pickup.Position, pickup.Size * 3, EntityPartition.ENEMY)) do
			if ent:IsActiveEnemy(false) and ent:IsVulnerableEnemy() then
				ent:TakeDamage(damage, DamageFlag.DAMAGE_EXPLOSION | DamageFlag.DAMAGE_IGNORE_ARMOR, EntityRef(pickup), 0)
			end
		end
		Mod.SFXManager:Play(SoundEffect.SOUND_EXPLOSION_WEAK)
		for _ = 1, 10 do
			local position = Vector(random(-25, 25), random(-25, 25))
			position = position + pickup.Position
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, position,
				Vector.Zero, pickup)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, position,
				Vector.Zero, pickup)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, MAGDALENE_CAKE.HeartExplode, PickupVariant.PICKUP_HEART)
