local Mod = BirthcakeRebaked
local game = Mod.Game

local EVE_CAKE = {}
BirthcakeRebaked.Birthcake.EVE = EVE_CAKE

EVE_CAKE.DAMAGE_FLAGS = DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES

-- Eve Birthcake

---@param familiar EntityFamiliar
function EVE_CAKE:BloodBirdInit(familiar)
	local player = familiar.Player or familiar.SpawnerEntity and familiar.SpawnerEntity:ToPlayer()
	if player and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE) then
		local color = familiar.Color
		color:SetColorize(1.5, 0.2, 0.2, 1)
		familiar:SetColor(color, -1, 1, false, true)
		local familiar_run_save = Mod.SaveManager.GetRunSave(familiar)
		familiar_run_save.EveCakeBloodBird = true
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, EVE_CAKE.BloodBirdInit, FamiliarVariant.DEAD_BIRD)

---@param familiar EntityFamiliar
function EVE_CAKE:BloodBirdUpdate(familiar)
	local player = familiar.Player or familiar.SpawnerEntity and familiar.SpawnerEntity:ToPlayer()
	if player then
		local familiar_run_save = Mod.SaveManager.GetRunSave(familiar)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE) then
			if not familiar_run_save.EveCakeBloodBird then
				EVE_CAKE:BloodBirdInit(familiar)
			end
			if familiar.FrameCount % 15 == 0 then
				local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, familiar.Position, Vector.Zero, player)
				creep:Update()
				if not player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then
					creep.SpriteScale = Vector(0.5, 0.5)
				end
			end
		elseif familiar_run_save.EveCakeBloodBird then
			local color = familiar.Color
			color:SetColorize(1, 1, 1, 0)
			familiar:SetColor(color, -1, 10, false, true)
			familiar_run_save.EveCakeBloodBird = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, EVE_CAKE.BloodBirdUpdate, FamiliarVariant.DEAD_BIRD)

---@param player EntityPlayer
function EVE_CAKE:GetBloodBirdDamageFormula(player)
	return math.max(2, 1 + (player.Damage / (2 + (player.Damage * 0.05))))
end

---@param ent Entity
---@param amount number
---@param flags DamageFlag
---@param source EntityRef
---@param countdown integer
function EVE_CAKE:BuffBloodBirdDamage(ent, amount, flags, source, countdown)
	if source.Entity
		and source.Entity:ToFamiliar()
		and source.Entity.Variant == FamiliarVariant.DEAD_BIRD
	then
		local data = Mod:GetData(ent)
		local familiar = source.Entity:ToFamiliar()
		---@cast familiar EntityFamiliar
		local player = familiar.Player or familiar.SpawnerEntity and familiar.SpawnerEntity:ToPlayer()
		if player
			and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE)
			and not data.PreventDamageLoop
		then
			data.PreventDamageLoop = true
			ent:TakeDamage(EVE_CAKE:GetBloodBirdDamageFormula(player), flags, source, countdown)
			data.PreventDamageLoop = false
			return false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EVE_CAKE.BuffBloodBirdDamage)

-- Tainted Eve Birthcake

--TODO: maybe chance to spawn extra red clot

---@param ent Entity
function EVE_CAKE:ClotDeath(ent, dmg, flag, source, cdframe)
	local player = ent:ToFamiliar() and ent:ToFamiliar().Player

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE_B)
		and ent.Variant == FamiliarVariant.BLOOD_BABY and ent:IsDead()
	then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, ent.Position, Vector.Zero, ent)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, EVE_CAKE.ClotDeath, EntityType.ENTITY_FAMILIAR)

