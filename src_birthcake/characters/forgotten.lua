local Mod = BirthcakeRebaked
local game = Mod.Game

local THEFORGOTTEN_CAKE = {}
BirthcakeRebaked.Birthcake.THEFORGOTTEN = THEFORGOTTEN_CAKE

-- The Forgotten and Tainted Forgotten's Birthcakes

---@param ent Entity
---@param source EntityRef
function THEFORGOTTEN_CAKE:EntityTakeDamage(ent, _, _, source)
	if source
		and source.Entity
		and source.Entity:ToPlayer()
		and ent:IsActiveEnemy(false)
		and ent:IsVulnerableEnemy()
	then
		--Last hit gets credit for the kill
		local player = source.Entity:ToPlayer()
		Mod:GetData(ent).ForgottenBirthcakeCheckDeath = player
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, THEFORGOTTEN_CAKE.EntityTakeDamage)

---@param npc EntityNPC
function THEFORGOTTEN_CAKE:OnNPCDeath(npc)
	if npc:HasEntityFlags(EntityFlag.FLAG_ICE) then return end
	local data = Mod:GetData(npc)
	if data.ForgottenBirthcakeCheckDeath then
		---@type EntityPlayer
		local player = data.ForgottenBirthcakeCheckDeath
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THEFORGOTTEN) then
			THEFORGOTTEN_CAKE:SpawnPurgatoryWisp(player, npc.Position)
		elseif Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THEFORGOTTEN_B) then
			if REPENTOGON then
				player:AddBoneOrbital(npc.Position)
			else
				local bone = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0,
				npc.Position, Vector.Zero, player):ToFamiliar()
				---@cast bone EntityFamiliar
				bone:AddToOrbit(0)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, THEFORGOTTEN_CAKE.OnNPCDeath)

-- Forgotten's Birthcake

---@param wisp EntityFamiliar
function THEFORGOTTEN_CAKE:IsPurgatoryWisp(wisp)
	local familiar_run_save = Mod.SaveManager.TryGetRunSave(wisp)
	return familiar_run_save
	and familiar_run_save.ForgottenBirthcakePurgatoryWisp
end

---@param player EntityPlayer
---@param pos Vector
function THEFORGOTTEN_CAKE:SpawnPurgatoryWisp(player, pos)
	local wisp = player:AddWisp(CollectibleType.COLLECTIBLE_PURGATORY, pos)
	wisp.FireCooldown = 9999999999
	wisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	Mod.SaveManager.GetRunSave(wisp).ForgottenBirthcakePurgatoryWisp = true
	wisp:AddToOrbit(0)
	return wisp
end

THEFORGOTTEN_CAKE.WISP_DAMAGE_BONUS = 1.5
THEFORGOTTEN_CAKE.WISP_DAMAGE_DIMINISH_RATE = 0.025

---@param player EntityPlayer
function THEFORGOTTEN_CAKE:ConvertPurgatoryWisps(player)
	if player:HasTrinket(Mod.Birthcake.ID) then
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, CollectibleType.COLLECTIBLE_PURGATORY)) do
			local wisp = ent:ToFamiliar() ---@cast wisp EntityFamiliar

			if THEFORGOTTEN_CAKE:IsPurgatoryWisp(wisp) then
				--TODO: Variant?? Collision Damage?? Balls?? Boobs??
				local ghost = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, player.Position, Vector.Zero, player)
				ghost:SetColor(Color(0.7, 1, 1), -1, 1, false, true)
				print(ghost.CollisionDamage)
				player_run_save.SoulCakeDiminishingDamage = (player_run_save.SoulCakeDiminishingDamage or 0) + (THEFORGOTTEN_CAKE.WISP_DAMAGE_BONUS * Mod:GetTrinketMult(player))
				wisp:Remove()
			end
		end
		if (player_run_save.SoulCakeDiminishingDamage or 0) > 0 then
			player_run_save.SoulCakeDiminishingDamage = player_run_save.SoulCakeDiminishingDamage - THEFORGOTTEN_CAKE.WISP_DAMAGE_DIMINISH_RATE
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		elseif player_run_save.SoulCakeDiminishingDamage then
			player_run_save.SoulCakeDiminishingDamage = nil
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	else
		local player_run_save = Mod.SaveManager.TryGetRunSave(player)
		if player_run_save and player_run_save.SoulCakeDiminishingDamage then
			player_run_save.SoulCakeDiminishingDamage = nil
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, THEFORGOTTEN_CAKE.ConvertPurgatoryWisps, PlayerType.PLAYER_THESOUL)

---@param player EntityPlayer
function THEFORGOTTEN_CAKE:WispDamageBonus(player)
	local player_run_save = Mod.SaveManager.TryGetRunSave(player)
	if player_run_save
		and player_run_save.SoulCakeDiminishingDamage
	then
		player.Damage = player.Damage + player_run_save.SoulCakeDiminishingDamage
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, THEFORGOTTEN_CAKE.WispDamageBonus, CacheFlag.CACHE_DAMAGE)