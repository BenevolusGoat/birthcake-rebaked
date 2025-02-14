local Mod = BirthcakeRebaked
local game = Mod.Game

local JACOB_ESAU_CAKE = {}
BirthcakeRebaked.Birthcake.JACOB_AND_ESAU = JACOB_ESAU_CAKE

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
		and not data.PreventDamageLoop
	then
		local otherData = Mod:GetData(player:GetOtherTwin())
		otherData.PreventDamageLoop = true
		player:GetOtherTwin():TakeDamage(amount, flags, source, countdown)
		otherData.PreventDamageLoop = false
		return false
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JACOB_ESAU_CAKE.RedirectDamage, EntityType.ENTITY_PLAYER)

-- Tainted Jacob

JACOB_ESAU_CAKE.DARK_ESAU_FLAME = Isaac.GetEntityTypeByName("Dark Esau Birthcake Flame")
JACOB_ESAU_CAKE.DARK_ESAU_FLAME_VARIANT = Isaac.GetEntityVariantByName("Dark Esau Birthcake Flame")
JACOB_ESAU_CAKE.DARK_ESAU_FLAME_DURATION = 90

---@param npc EntityNPC
function JACOB_ESAU_CAKE:OnDarkEsauUpdate(npc)
	if not (npc.SpawnerEntity
		and npc.SpawnerEntity:ToPlayer()
		and JACOB_ESAU_CAKE:CheckTaintedJacob(npc.SpawnerEntity:ToPlayer()))
	then
		return
	end
	local sprite = npc:GetSprite()
	if sprite:IsPlaying("Charge") then
		if sprite:GetFrame() == 0 then
			npc:SetColor(Color(1, 1, 1, 1, 0.5, 0, 0), -1, 1, false, true)
			npc:SetColor(Color.Default, 24, 1, true, true)
		end
	elseif string.find(sprite:GetAnimation(), "Dash") and npc.Velocity:LengthSquared() >= 8 ^ 2 then
		if sprite:GetFrame() == 0 then
			npc:SetColor(Color.Default, -1, 5, false, true)
			npc:SetColor(Color(1, 1, 1, 1, 0.5, 0, 0), 20, 5, true, true)
		end
		if npc.FrameCount % 3 == 0 and Mod.Game:GetRoom():IsPositionInRoom(npc.Position, 0) then
			local flame = Isaac.Spawn(JACOB_ESAU_CAKE.DARK_ESAU_FLAME, JACOB_ESAU_CAKE.DARK_ESAU_FLAME_VARIANT, 0, npc.Position, Vector.Zero, npc):ToNPC()
			---@cast flame EntityNPC
			Mod:GetData(flame).Duration = JACOB_ESAU_CAKE.DARK_ESAU_FLAME_DURATION
		end
	elseif sprite:IsPlaying("Idle") and npc.Color.RO > 0 then
		npc:SetColor(Color.Default, -1, 1, true, true)
	end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, JACOB_ESAU_CAKE.OnDarkEsauUpdate, EntityType.ENTITY_DARK_ESAU)

---@param flame EntityNPC
function JACOB_ESAU_CAKE:OnFlameInit(flame)
	if flame.Variant ~= JACOB_ESAU_CAKE.DARK_ESAU_FLAME_VARIANT then return end
	flame:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	flame:GetSprite():Play("Appear")
	if flame.SpawnerType == EntityType.ENTITY_DARK_ESAU and flame.SpawnerEntity.SubType == 1 then
		flame:GetSprite():ReplaceSpritesheet(0, "gfx/effects/effect_005_fire_red.png")
		flame:GetSprite():LoadGraphics()
	end
	flame:AddEntityFlags(
	EntityFlag.FLAG_NO_TARGET
	| EntityFlag.FLAG_NO_KNOCKBACK
	| EntityFlag.FLAG_NO_FLASH_ON_DAMAGE
	| EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK
	| EntityFlag.FLAG_NO_REWARD)
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, JACOB_ESAU_CAKE.OnFlameInit, JACOB_ESAU_CAKE.DARK_ESAU_FLAME)

local max = math.max

---@param flame EntityNPC
function JACOB_ESAU_CAKE:OnFlameUpdate(flame)
	if flame.Variant ~= JACOB_ESAU_CAKE.DARK_ESAU_FLAME_VARIANT then return end
	local data = Mod:GetData(flame)
	if data.Duration then
		if data.Duration > 0 then
			data.Duration = data.Duration - 1
		end
	end

	local sprite = flame:GetSprite()
	if sprite:IsFinished("Appear") then
		sprite:Play("Idle")
	elseif sprite:IsFinished("Disappear") then
		flame:Remove()
		return
	end

	if sprite:IsPlaying("Idle") then
		for _, proj in ipairs(Isaac.FindInRadius(flame.Position, flame.Size, EntityPartition.BULLET)) do
			if not proj:IsDead() then
				proj:Die()
				flame.HitPoints = max(2, flame.HitPoints - 2)
			end
		end
	end

	if sprite:IsPlaying("Idle") then
		if data.HitList then
			for ptrHash, count in pairs(data.HitList) do
				data.HitList[ptrHash] = count - 1
				if count - 1 <= 0 then
					data.HitList[ptrHash] = nil
				end
			end
		end
		local scale = flame.HitPoints / flame.MaxHitPoints
		if REPENTOGON then
			flame:GetSprite():GetLayer(0):SetSize(Vector(scale, scale))
		else
			flame.SpriteScale = Vector(scale, scale)
		end
		if flame.HitPoints <= 2 or data.Duration == 0 then
			flame:GetSprite():Play("Disappear")
			flame.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			if flame.HitPoints <= 2 then
				Mod.SFXManager:Play(SoundEffect.SOUND_STEAM_HALFSEC)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, JACOB_ESAU_CAKE.OnFlameUpdate, JACOB_ESAU_CAKE.DARK_ESAU_FLAME)

---@param flame EntityNPC
---@param collider Entity
function JACOB_ESAU_CAKE:OnPreCollision(flame, collider)
	if flame.Variant ~= JACOB_ESAU_CAKE.DARK_ESAU_FLAME_VARIANT then return end
	local data = Mod:GetData(flame)
	local ref = EntityRef(flame)

	if flame:GetSprite():IsPlaying("Idle") and (collider:ToPlayer() or (collider:IsActiveEnemy(false) and collider:IsVulnerableEnemy())) then
		if not data.HitList or not data.HitList[GetPtrHash(collider)] then
			data.HitList = data.HitList or {}
			data.HitList[GetPtrHash(collider)] = 5
			if collider:ToPlayer() and not collider:ToPlayer():HasCollectible(CollectibleType.COLLECTIBLE_EVIL_CHARM) then
				collider:TakeDamage(flame.CollisionDamage, DamageFlag.DAMAGE_FIRE, ref, 0)
			else
				collider:TakeDamage(5, DamageFlag.DAMAGE_FIRE, ref, 0)
				collider:AddBurn(ref, 30, 3.5 + (0.5 * Mod.Game:GetLevel():GetStage()))
			end
		end
	end
	return true
end

Mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, JACOB_ESAU_CAKE.OnPreCollision, JACOB_ESAU_CAKE.DARK_ESAU_FLAME)

---@param flame Entity
---@param flags DamageFlag
---@param source EntityRef
function JACOB_ESAU_CAKE:OnTakeDamage(flame, _, flags, source)
	if flame.Variant ~= JACOB_ESAU_CAKE.DARK_ESAU_FLAME_VARIANT then return end
	if Mod:HasBitFlags(flags, DamageFlag.DAMAGE_EXPLOSION) then
		flame.HitPoints = 2
	elseif not Mod:HasBitFlags(flags, DamageFlag.DAMAGE_FIRE | DamageFlag.DAMAGE_POISON_BURN)
		and (not source.Entity or source.Entity.Type ~= EntityType.ENTITY_DARK_ESAU)
	then
		flame.HitPoints = max(2, flame.HitPoints - 2)
	end

	return false
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JACOB_ESAU_CAKE.OnTakeDamage, JACOB_ESAU_CAKE.DARK_ESAU_FLAME)