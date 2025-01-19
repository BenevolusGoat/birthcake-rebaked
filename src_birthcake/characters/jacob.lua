local Mod = BirthcakeRebaked
local game = Mod.Game

local JACOB_ESAU_CAKE = {}
BirthcakeRebaked.Birthcake.JACOB_AND_ESAU = JACOB_ESAU_CAKE

JACOB_ESAU_CAKE.STAT_SHARE_MULT = 0.1

-- functions

function JACOB_ESAU_CAKE:CheckJacobEsau(player)
	return (player:GetPlayerType() == PlayerType.PLAYER_JACOB or player:GetPlayerType() == PlayerType.PLAYER_ESAU)
		and player:HasTrinket(Mod.Birthcake.ID)
end

function JACOB_ESAU_CAKE:CheckTaintedJacob(player)
	return (player:GetPlayerType() == PlayerType.PLAYER_JACOB_B or player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B)
		and player:HasTrinket(Mod.Birthcake.ID)
end

-- Jacob Birthcake

---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param countdown integer
function JACOB_ESAU_CAKE:RedirectDamage(ent, amount, flags, source, countdown)
	local player = ent:ToPlayer() ---@cast player EntityPlayer
	local data = Mod:GetData(player)

	if JACOB_ESAU_CAKE:CheckJacobEsau(player)
		and player:GetOtherTwin()
		and not data.JacobEsauCakePreventLoop
	then
		local otherData = Mod:GetData(player:GetOtherTwin())
		otherData.JacobEsauCakePreventLoop = true
		player:GetOtherTwin():TakeDamage(amount, flags, source, countdown)
		otherData.JacobEsauCakePreventLoop = false
		return false
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JACOB_ESAU_CAKE.RedirectDamage, EntityType.ENTITY_PLAYER)

-- Tainted Jacob

JACOB_ESAU_CAKE.DARK_ESAU_FLAME = Isaac.GetEntityVariantByName("Dark Esau Flame")
JACOB_ESAU_CAKE.DARK_ESAU_FLAME_DURATION = 100

---@param npc EntityNPC
function JACOB_ESAU_CAKE:OnDarkEsauUpdate(npc)
	if (not Mod:AnyPlayerTypeHasBirthcake(PlayerType.PLAYER_JACOB_B)
			and not Mod:AnyPlayerTypeHasBirthcake(PlayerType.PLAYER_JACOB2_B))
	then
		return
	end
	local sprite = npc:GetSprite()
	if sprite:IsPlaying("Charge") then
		if sprite:GetFrame() == 0 then
			npc:SetColor(Color(1, 1, 1, 1, 0.5, 0, 0), -1, 5, false, true)
			npc:SetColor(Color.Default, 24, 5, true, true)
		end
	elseif string.find(sprite:GetAnimation(), "Dash") and npc.Velocity:LengthSquared() >= 8 ^ 2 then
		if sprite:GetFrame() == 0 then
			npc:SetColor(Color.Default, -1, 5, false, true)
			npc:SetColor(Color(1, 1, 1, 1, 0.5, 0, 0), 20, 5, true, true)
		end
		if npc.FrameCount % 2 == 0 and Mod.Game:GetRoom():IsPositionInRoom(npc.Position, 0) then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, JACOB_ESAU_CAKE.DARK_ESAU_FLAME, 0, npc.Position, Vector.Zero, npc)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, JACOB_ESAU_CAKE.OnDarkEsauUpdate)

---@param effect EntityEffect
function JACOB_ESAU_CAKE:OnFireInit(effect)
	effect.Timeout = JACOB_ESAU_CAKE.DARK_ESAU_FLAME_DURATION

	if effect.SpawnerType == EntityType.ENTITY_DARK_ESAU and effect.SpawnerEntity.SubType == 1 then
		effect:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_red.png")
		effect:GetSprite():LoadGraphics()
	end
	effect.MaxHitPoints = 5
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, JACOB_ESAU_CAKE.OnFireInit, JACOB_ESAU_CAKE.DARK_ESAU_FLAME)

---@param effect EntityEffect
function JACOB_ESAU_CAKE:OnFireUpdate(effect)
	local sprite = effect:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	elseif sprite:IsFinished("Disappear") then
		effect:Remove()
		return
	end

	if sprite:IsPlaying("Idle") then
		local data = Mod:GetData(effect)
		for _, ent in ipairs(Isaac.FindInRadius(effect.Position, effect.Size)) do
			if (ent:ToProjectile() or ent:ToTear()) and not ent:IsDead() then
				ent:Die()
				effect.HitPoints = math.max(2, effect.HitPoints - 2)
			elseif ent:ToPlayer() or (ent:IsActiveEnemy(false) and ent:IsVulnerableEnemy()) then
				if not data.HitList or not data.HitList[GetPtrHash(ent)] then
					data.HitList = data.HitList or {}
					data.HitList[GetPtrHash(ent)] = 5
					local ref = EntityRef(effect)
					if ent:ToPlayer() and not ent:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
						ent:TakeDamage(1, DamageFlag.DAMAGE_FIRE, EntityRef(effect), 0)
					else
						ent:TakeDamage(5, DamageFlag.DAMAGE_FIRE, EntityRef(effect), 0)
						ent:AddBurn(ref, 30, 3.5 * Mod.Game:GetLevel():GetStage())
					end
				end
			end
		end

		if data.HitList then
			for ptrHash, count in pairs(data.HitList) do
				data.HitList[ptrHash] = count - 1
				if count - 1 <= 0 then
					data.HitList[ptrHash] = nil
				end
			end
		end
		local scale = effect.HitPoints / effect.MaxHitPoints
		effect:GetSprite():GetLayer(0):SetSize(Vector(scale, scale))
		if effect.HitPoints <= 2 or effect.Timeout == 0 then
			effect:GetSprite():Play("Disappear")
			if effect.HitPoints <= 2 then
				Mod.SFXManager:Play(SoundEffect.SOUND_STEAM_HALFSEC)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, JACOB_ESAU_CAKE.OnFireUpdate, JACOB_ESAU_CAKE.DARK_ESAU_FLAME)