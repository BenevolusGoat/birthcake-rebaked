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

---@type {[BloodClotSubtype]: fun(clot: EntityFamiliar, creep: EntityEffect)}
EVE_CAKE.ClotVariantOnDeath = {
	[Mod.BloodClotSubtype.RED] = function(clot, creep)
		creep.CollisionDamage = clot.Player.Damage * 0.35
	end,
	[Mod.BloodClotSubtype.SOUL] = function(clot, creep)
		creep:GetSprite():Load("gfx/1000.025_creep (white).anm2", true)
		creep.Color = Color(1,1,1,1,-0.9, -0.725, -0.5)
		creep.Color = Color(0.2, 0.4, 0.7, 1)
		creep.CollisionDamage = clot.Player.Damage * 0.35
	end,
	[Mod.BloodClotSubtype.BLACK] = function(clot, creep)
		creep:GetSprite():Load("gfx/1000.025_creep (white).anm2", true)
		creep.Color = Color(1,1,1,1,-0.9, -0.9, -0.9)
		creep.CollisionDamage = clot.Player.Damage * 0.43
		local data = Mod:GetData(creep)
		data.IsEveCakeCreep = true
		data.EveCakeBlackCreep = true
		creep.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS
	end,
	[Mod.BloodClotSubtype.ETERNAL] = function(clot, creep)
		creep:GetSprite():Load("gfx/1000.025_creep (white).anm2", true)
		creep.CollisionDamage = clot.Player.Damage * 0.52
		local data = Mod:GetData(creep)
		data.IsEveCakeCreep = true
		data.EveCakeWhiteCreep = true
	end,
	[Mod.BloodClotSubtype.GOLD] = function(clot, creep)
		creep:GetSprite():Load("gfx/1000.025_creep (white).anm2", true)
		creep.Color = Color(1,1,1,1,-0.05, -0.4, -1)
		creep.CollisionDamage = clot.Player.Damage * 0.35
		local data = Mod:GetData(creep)
		data.IsEveCakeCreep = true
		data.EveCakeGoldCreep = true
	end,
	[Mod.BloodClotSubtype.BONE] = function(clot, creep)
		creep:GetSprite():Load("gfx/1000.025_creep (white).anm2", true)
		creep.Color = Color(1,1,1,1,-0.25, -0.27, -0.29)
		creep.CollisionDamage = clot.Player.Damage * 0.35
		for _ = 1, 3 do
			Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0, clot.Position, Vector.Zero, clot.Player)
		end
	end,
	[Mod.BloodClotSubtype.ROTTEN] = function(clot, creep)
		creep:GetSprite():Load("gfx/1000.025_creep (white).anm2", true)
		creep.Color = Color(1,1,1,1,-0.8, -0.78, -0.87)
		creep.CollisionDamage = clot.Player.Damage * 0.35
		clot.Player:AddBlueFlies(3, clot.Position, clot.Player)
	end
}

---@param ent Entity
function EVE_CAKE:ClotDeath(ent, dmg, flag, source, cdframe)
	local player = ent:ToFamiliar() and ent:ToFamiliar().Player

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE_B)
		and ent.Variant == FamiliarVariant.BLOOD_BABY
	then
		local clot = ent:ToFamiliar() ---@cast clot EntityFamiliar
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, clot.Position, Vector.Zero, clot):ToEffect()
		---@cast creep EntityEffect
		creep:SetTimeout(241)
		local deathEffect = EVE_CAKE.ClotVariantOnDeath[ent.SubType]
		if deathEffect then
			deathEffect(clot, creep)
		end
		creep:Update()
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, EVE_CAKE.ClotDeath, EntityType.ENTITY_FAMILIAR)

---@param effect EntityEffect
function EVE_CAKE:OnClotCreepUpdate(effect)
	local data = Mod:GetData(effect)
	if not data.IsEveCakeCreep then return end
	local ref = EntityRef(effect)
	local radius = data.EveCakeWhiteCreep and effect.Size * 5 or effect.Size
	for _, ent in ipairs(Isaac.FindInRadius(effect.Position, radius, EntityPartition.ENEMY)) do
		local npc = ent:ToNPC()
		if npc and ent:IsActiveEnemy(false) and ent:IsVulnerableEnemy() and Mod.Game:GetRoom():IsPositionInRoom(npc.Position, 0) then
			if data.EveCakeGoldCreep then
				npc:AddMidasFreeze(ref, 150)
			elseif data.EveCakeBlackCreep then
				npc:AddFear(ref, 150)
			elseif data.EveCakeWhiteCreep then
				effect:AddVelocity((npc.Position - effect.Position):Normalized())
				if effect.Velocity:Length() > 5 then
					effect.Velocity = effect.Velocity:Resized(5)
				end
			end
		end
	end
	if data.EveCakeWhiteCreep and not Mod.Game:GetRoom():IsPositionInRoom(effect.Position, 0) then
		effect.Velocity = Vector.Zero
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, EVE_CAKE.OnClotCreepUpdate, EffectVariant.PLAYER_CREEP_RED)