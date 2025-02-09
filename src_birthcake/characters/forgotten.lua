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
function THEFORGOTTEN_CAKE:OnForgottenBodyUpdate(familiar)
	local player = familiar.Player

	if player and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THESOUL) then
		local effects = player:GetEffects()
		local pData = Mod:GetData(player)
		if pData.IsForgotten then
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

				local mult = Mod:GetTrinketMult(player)

				if numSoulCharge < THEFORGOTTEN_CAKE.SOUL_CHARGE_EFFECT_CAP then
					effects:AddTrinketEffect(Mod.Birthcake.ID, false)
				end

				for _ = 1 * mult, player:GetTrinketRNG(Mod.Birthcake.ID):RandomInt(3 * mult) do
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

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, THEFORGOTTEN_CAKE.OnForgottenBodyUpdate, FamiliarVariant.FORGOTTEN_BODY)

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
				player:SetColor(SOUL_COLOR, duration, 1, true, false)
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
function THEFORGOTTEN_CAKE:StopBirthcakeEffectReset(player)
	if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
		return true
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, THEFORGOTTEN_CAKE.StopBirthcakeEffectReset, PlayerType.PLAYER_THESOUL)

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

THEFORGOTTEN_CAKE.BONE_ORBITAL_CAP = 6

---@param npc EntityNPC
function THEFORGOTTEN_CAKE:OnNPCDeath(npc)
	if npc:HasEntityFlags(EntityFlag.FLAG_ICE) then return end
	local data = Mod:GetData(npc)
	local player = data.ForgottenBirthcakeCheckDeath

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THEFORGOTTEN_B)
	then
		local theSoul = player:GetOtherTwin()
		local familiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_SPUR, 0, npc.Position, Vector.Zero, theSoul):ToFamiliar()
		---@cast familiar EntityFamiliar
		Mod:GetData(familiar).ForgottenCakeBoneSpur = true
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, THEFORGOTTEN_CAKE.OnNPCDeath)

---@param player EntityPlayer
function THEFORGOTTEN_CAKE:OnForgottenPickup(player)
	local forgor = player:GetOtherTwin()
	if not Mod:PlayerTypeHasBirthcake(forgor, PlayerType.PLAYER_THEFORGOTTEN_B) then return end

	local data = Mod:GetData(player)
	if forgor.Position:DistanceSquared(player.Position) <= 5
		and not player:IsExtraAnimationFinished()
		and string.find(player:GetSprite():GetAnimation(), "PickupWalk")
	then
		if not data.ForgottenCakeHasBody then
			data.ForgottenCakeHasBody = true
			local numOrbitals = 0
			local cap = THEFORGOTTEN_CAKE.BONE_ORBITAL_CAP * Mod:GetTrinketMult(forgor)
			for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL)) do
				local familiar = ent:ToFamiliar() ---@cast familiar EntityFamiliar
				if GetPtrHash(familiar.Player) == GetPtrHash(player) then
					numOrbitals = numOrbitals + 1
					if numOrbitals == cap then
						break
					end
				end
			end

			if numOrbitals == cap then
				return
			end
			local spurs = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_SPUR)
			local validSpur = false
			for i = #spurs, 1, -1 do
				local familiar = spurs[i]:ToFamiliar() ---@cast familiar EntityFamiliar
				if Mod:GetData(familiar).ForgottenCakeBoneSpur then
					validSpur = true
					local sprite = familiar:GetSprite()
					local anim = sprite:GetAnimation()
					local orbital = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BONE_ORBITAL, 0, familiar.Position, Vector.Zero, player):ToFamiliar()
					---@cast orbital EntityFamiliar
					orbital:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					local sprite2 = orbital:GetSprite()
					sprite2:Play(anim)
					sprite2:SetFrame(anim, sprite:GetFrame())
					familiar:Remove()
					Mod:GetData(orbital).ForgottenCakeBoneOrbital = true
					numOrbitals = numOrbitals + 1
					if numOrbitals == cap then break end
				end
			end
			if validSpur then
				Mod.SFXManager:Play(SoundEffect.SOUND_RECALL)
			end
		end
	else
		data.ForgottenCakeHasBody = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, THEFORGOTTEN_CAKE.OnForgottenPickup, PlayerType.PLAYER_THESOUL_B)

---@param familiar EntityFamiliar
function THEFORGOTTEN_CAKE:OrbitalRecallUpdate(familiar)
	local data = Mod:GetData(familiar)
	if data.ForgottenCakeBoneOrbital then
		if familiar.Position:DistanceSquared(familiar.Player.Position) >= 40 ^ 2 then
			if familiar.FrameCount % 3 == 0 then
				local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HAEMO_TRAIL, 0, familiar.Position, Vector.Zero, familiar):ToEffect()
				---@cast effect EntityEffect
				effect.DepthOffset = -5
				effect.Color = Color(0,0,0,0,0.34,0.6,0.85)
				effect:SetColor(Color(0,0,0,1,0.64,0.8, 1), 6, 10, true, true)
				effect.SpriteScale = Vector(0.75, 0.75)
				effect.PositionOffset = Vector(0, -8)
			end
		else
			data.ForgottenCakeBoneOrbital = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, THEFORGOTTEN_CAKE.OrbitalRecallUpdate, FamiliarVariant.BONE_ORBITAL)