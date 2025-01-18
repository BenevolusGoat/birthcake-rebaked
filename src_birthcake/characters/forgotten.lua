local Mod = BirthcakeRebaked
local game = Mod.Game

local THEFORGOTTEN_CAKE = {}
BirthcakeRebaked.Birthcake.THEFORGOTTEN = THEFORGOTTEN_CAKE

THEFORGOTTEN_CAKE.SOUL_CHARGE_EFFECT_CAP = 10
THEFORGOTTEN_CAKE.SOUL_CHARGE_DURATION_MULT = 30
THEFORGOTTEN_CAKE.SOUL_CHARGE_COLLECT_COOLDOWN = 10
THEFORGOTTEN_CAKE.SOUL_CHARGE_DECAY_COOLDOWN = 30
THEFORGOTTEN_CAKE.SOUL_CHARGE_FIREDELAY_MULT = 0.2

local SOUL_COLOR_OFFSET = Color(0.5, 0.7, 1, 1, 0.05, 0.12, 0.2)
local SOUL_COLOR = Color(1.5, 1.7, 2, 1, 0.05, 0.12, 0.2)

-- "The Forgotten's" Birthcake and by that I mean The Soul

---@param familiar EntityFamiliar
function THEFORGOTTEN_CAKE:OnForgottenBodyCollision(familiar)
	local player = familiar.Player

	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THESOUL) then
		local effects = player:GetEffects()
		local pData = Mod:GetData(player)
		if pData.IsForgotten then
			effects:RemoveTrinketEffect(Mod.Birthcake.ID, -1)
			pData.IsForgotten = false
			pData.IsSoul = true
		end
		local numSoulCharge = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
		local fData = Mod:GetData(familiar)
		for _, ent in ipairs(Isaac.FindInRadius(familiar.Position, familiar.Size)) do
			if (ent:ToTear()
					or ent:ToLaser() --Doesn't work (womp)
					or (ent:ToKnife() and ent:ToKnife():IsFlying())
					or ent:ToBomb()
				) and not fData.SoulChargeCooldown
			then
				fData.SoulChargeCooldown = THEFORGOTTEN_CAKE.SOUL_CHARGE_COLLECT_COOLDOWN
				fData.SoulChargeDecay = THEFORGOTTEN_CAKE.SOUL_CHARGE_DECAY_COOLDOWN

				Mod.SFXManager:Play(SoundEffect.SOUND_BONE_BREAK, 0.5, 0, false)

				if numSoulCharge < THEFORGOTTEN_CAKE.SOUL_CHARGE_EFFECT_CAP then
					effects:AddTrinketEffect(Mod.Birthcake.ID, false)
				end

				for _ = 1, player:GetTrinketRNG(Mod.Birthcake.ID):RandomInt(3) + Mod:GetTrinketMult(player) do
					local tear = player:FireTear(familiar.Position, RandomVector():Resized(player.ShotSpeed * 10),
						false, true, false, player, 0.5)
					tear:ChangeVariant(TearVariant.BONE)
					Mod:GetData(tear).ForgottenCakeBodyCollision = true
					local sprite = tear:GetSprite()
					sprite:ReplaceSpritesheet(0, "gfx/tears_brokenbone.png")
					sprite:LoadGraphics()
				end
			end
		end
		if fData.SoulChargeCooldown then
			if fData.SoulChargeCooldown > 0 then
				fData.SoulChargeCooldown = fData.SoulChargeCooldown - 1
			else
				fData.SoulChargeCooldown = nil
			end
		end
		if fData.SoulChargeDecay then
			if fData.SoulChargeDecay > 0 then
				fData.SoulChargeDecay = fData.SoulChargeDecay - 1
			elseif numSoulCharge > 0 then
				effects:RemoveTrinketEffect(Mod.Birthcake.ID)
				fData.SoulChargeDecay = THEFORGOTTEN_CAKE.SOUL_CHARGE_DECAY_COOLDOWN
			else
				fData.SoulChargeDecay = nil
			end
			local s = SOUL_COLOR_OFFSET
			local p = (numSoulCharge / THEFORGOTTEN_CAKE.SOUL_CHARGE_EFFECT_CAP)
			local newColor = Color(1 + (s.R * p), 1 + (s.G * p), 1 + (s.B * p), 1, (s.RO * p), (s.GO * p), (s.BO * p))
			familiar:SetColor(newColor, 2, 5, true, true)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, THEFORGOTTEN_CAKE.OnForgottenBodyCollision, FamiliarVariant.FORGOTTEN_BODY)

---@param player EntityPlayer
function THEFORGOTTEN_CAKE:CashInSoulCharge(player)
	local data = Mod:GetData(player)
	local effects = player:GetEffects()

	data.IsForgotten = true

	if player:HasTrinket(Mod.Birthcake.ID) then
		if data.IsSoul then
			data.IsSoul = false
			if effects:GetTrinketEffectNum(Mod.Birthcake.ID) > 0 then
				local numSoulCharge = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
				effects:RemoveTrinketEffect(Mod.Birthcake.ID, -1)
				local duration = numSoulCharge * THEFORGOTTEN_CAKE.SOUL_CHARGE_DURATION_MULT
				effects:AddTrinketEffect(Mod.Birthcake.ID, false, duration)
				player:SetColor(SOUL_COLOR, duration, 5, true, false)
			end
		end
	end
	if effects:GetTrinketEffectNum(Mod.Birthcake.ID) > 0 then
		effects:RemoveTrinketEffect(Mod.Birthcake.ID)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, THEFORGOTTEN_CAKE.CashInSoulCharge, PlayerType.PLAYER_THEFORGOTTEN)

---@param player EntityPlayer
function THEFORGOTTEN_CAKE:SoulChargeFireDelayCache(player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THEFORGOTTEN) then
		local tears = Mod:Delay2Tears(player.MaxFireDelay)
		local effectCountdown = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		local fireDelayMult = THEFORGOTTEN_CAKE.SOUL_CHARGE_FIREDELAY_MULT * (effectCountdown / THEFORGOTTEN_CAKE.SOUL_CHARGE_DURATION_MULT)
		tears = tears + fireDelayMult
		player.MaxFireDelay = Mod:Tears2Delay(tears)
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, THEFORGOTTEN_CAKE.SoulChargeFireDelayCache, CacheFlag.CACHE_FIREDELAY)

-- Tainted Forgotten's Birthcake

--TODO: Bone Orbitals float in place. Picking up forgotten will make them come to you. Max of 6

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
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THEFORGOTTEN_B) then
			local theSoul = player:GetOtherTwin()
			if REPENTOGON then
				theSoul:AddBoneOrbital(npc.Position)
			else
				local bone = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0,
					npc.Position, Vector.Zero, theSoul):ToFamiliar()
				---@cast bone EntityFamiliar
				bone:AddToOrbit(0)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, THEFORGOTTEN_CAKE.OnNPCDeath)

---@param player EntityPlayer
---@param vel Vector
function THEFORGOTTEN_CAKE:OnThrow(player, vel)
	local familiars = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL)
	for i = #familiars, 1, -1 do
		local familiar = familiars[i]:ToFamiliar() ---@cast familiar EntityFamiliar
		if GetPtrHash(familiar.Player) == GetPtrHash(player) then
			local anim = familiar:GetSprite():GetAnimation()
			local filePath = familiar:GetSprite():GetFilename()
			local tear = player:FireTear(familiar.Position, vel, false, true, false, player)
			tear:ChangeVariant(TearVariant.BONE)
			tear:GetSprite():Load(filePath, true)
			tear:GetSprite():Play(anim, true)
			tear:AddTearFlags(TearFlags.TEAR_BONE)
			familiar:Remove()
		end
	end
end

if REPENTOGON then
	---@param player EntityPlayer
	---@param entity Entity
	---@param vel Vector
	function THEFORGOTTEN_CAKE:DetectThrow(player, entity, vel)
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B
			and player:GetOtherTwin()
			and Mod:PlayerTypeHasBirthcake(player:GetOtherTwin(), PlayerType.PLAYER_THEFORGOTTEN_B)
			and entity:ToPlayer()
			and GetPtrHash(entity:ToPlayer()) == GetPtrHash(player:GetOtherTwin())
		then
			THEFORGOTTEN_CAKE:OnThrow(player, vel)
		end
	end

	Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_THROW, THEFORGOTTEN_CAKE.DetectThrow)
else
	---@param player EntityPlayer
	function THEFORGOTTEN_CAKE:DetectThrow(player)
		local data = Mod:GetData(player)
		if Mod:PlayerTypeHasBirthcake(player:GetOtherTwin(), PlayerType.PLAYER_THEFORGOTTEN_B)
			and player:GetOtherTwin().Position:DistanceSquared(player.Position) <= 5
			and not player:IsExtraAnimationFinished()
			and string.find(player:GetSprite():GetAnimation(), "PickupWalk")
		then
			data.SoulBirthcakeHoldingForgottenB = true
		end

		if data.SoulBirthcakeHoldingForgottenB
			and player:GetFireDirection() ~= Direction.NO_DIRECTION
		then
			THEFORGOTTEN_CAKE:OnThrow(player, player:GetTearMovementInheritance(player:GetShootingInput()) * 12)
			data.SoulBirthcakeHoldingForgottenB = nil
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, THEFORGOTTEN_CAKE.DetectThrow, PlayerType.PLAYER_THESOUL_B)
end


--Me when I upgraded the code of the original idea and realized its way too much *sobs*
--[[
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

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, THEFORGOTTEN_CAKE.WispDamageBonus, CacheFlag.CACHE_DAMAGE) ]]
