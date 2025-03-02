local Mod = BirthcakeRebaked

local LILITH_CAKE = {}
BirthcakeRebaked.Birthcake.LILITH = LILITH_CAKE

-- Lillith Birthcake

LILITH_CAKE.SHARE_TEAR_EFFECTS_CHANCE = 0.25

local weaponFamiliars = {
	[FamiliarVariant.BLOOD_BABY] = true,
	[FamiliarVariant.INCUBUS] = true,
	[FamiliarVariant.TWISTED_BABY] = true,
	[FamiliarVariant.CAINS_OTHER_EYE] = true,
	[FamiliarVariant.SPRINKLER] = true,
	[FamiliarVariant.UMBILICAL_BABY] = true
}

---@param tearOrLaser EntityTear | EntityLaser
function LILITH_CAKE:EffectShare(tearOrLaser)
	if tearOrLaser.FrameCount == 1
		and tearOrLaser.SpawnerEntity
	then
		local familiar = tearOrLaser.SpawnerEntity:ToFamiliar()
		if familiar
			and (REPENTOGON and not familiar:GetWeapon() or not weaponFamiliars[familiar.Variant])
			and familiar.Player
			and Mod:PlayerTypeHasBirthcake(familiar.Player, PlayerType.PLAYER_LILITH)
		then
			local player = tearOrLaser.SpawnerEntity:ToFamiliar().Player
			local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
			local trinketMult = Mod:GetTrinketMult(player)

			if rng:RandomFloat() <= Mod:GetBalanceApprovedChance(LILITH_CAKE.SHARE_TEAR_EFFECTS_CHANCE, trinketMult) then
				local tearParams = player:GetTearHitParams(tearOrLaser:ToTear() and WeaponType.WEAPON_TEARS or WeaponType.WEAPON_LASER, tearOrLaser.CollisionDamage / 3.5, 1, familiar)
				tearOrLaser:AddTearFlags(tearParams.TearFlags)
				tearOrLaser:SetColor(tearParams.TearColor, -1, 1, false, true)
				if tearOrLaser:ToTear() and tearOrLaser.Variant ~= tearParams.TearVariant then
					tearOrLaser:ChangeVariant(tearParams.TearVariant)
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, LILITH_CAKE.EffectShare)
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, LILITH_CAKE.EffectShare)

-- Tainted Lillith Birthcake

LILITH_CAKE.SPAWN_RUNT_CHANCE = 0.25

---@param ent Entity
function LILITH_CAKE:SetRuntColor(ent)
	local color = ent.Color
	color:SetColorize(2, 0, 0, 0.7)
	ent:SetColor(color, -1, 10, false, true)
end

---@param player EntityPlayer
function LILITH_CAKE:FireRunt(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and player:GetFireDirection() ~= Direction.NO_DIRECTION
		and player.FireDelay == player.MaxFireDelay * 2
		and player:GetTrinketRNG(Mod.Birthcake.ID):RandomFloat()
		<= Mod:GetBalanceApprovedChance(LILITH_CAKE.SPAWN_RUNT_CHANCE, Mod:GetTrinketMult(player))
	then
		local data = Mod:GetData(player)
		if not data.ExtraGello then
			local familiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.UMBILICAL_BABY, 0, player.Position, Vector.Zero, player):ToFamiliar()
			---@cast familiar EntityFamiliar
			familiar:SetSize(10, Vector(1, 1), 12)
			LILITH_CAKE:SetRuntColor(familiar)
			data.ExtraGello = familiar
			Mod:GetData(familiar).LilithBirthcakeGello = true
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, LILITH_CAKE.FireRunt, PlayerType.PLAYER_LILITH_B)

---@param familiar EntityFamiliar
function LILITH_CAKE:OnFamiliarUpdate(familiar)
	local data = Mod:GetData(familiar)
	if data.LilithBirthcakeGello and familiar.Player then
		familiar.SpriteScale = Vector(0.75, 0.75)
		if REPENTOGON then
			for _, gello in ipairs(Isaac.FindInCapsule(familiar:GetCollisionCapsule(), EntityPartition.FAMILIAR)) do
				gello:AddVelocity((gello.Position - familiar.Position):Normalized())
			end
		else
			for _, gello in ipairs(Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.UMBILICAL_BABY)) do
				if GetPtrHash(gello) ~= GetPtrHash(familiar)
					and gello.Position:DistanceSquared(familiar.Position) <= (familiar.Size + gello.Size) ^ 2
				then
					gello:AddVelocity((gello.Position - familiar.Position):Normalized())
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, LILITH_CAKE.OnFamiliarUpdate, FamiliarVariant.UMBILICAL_BABY)

LILITH_CAKE.RUNT_BASE_DMG_MULT = 0.5

---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param countdownFrames integer
function LILITH_CAKE:NerfGelloRuntDamage(ent, amount, flags, source, countdownFrames)
	if source.Entity
		and source.Entity.SpawnerEntity
		and source.Entity.SpawnerEntity:ToFamiliar()
		and source.Entity.SpawnerEntity.Variant == FamiliarVariant.UMBILICAL_BABY
	then
		local familiar = source.Entity.SpawnerEntity:ToFamiliar() ---@cast familiar EntityFamiliar
		local data = Mod:GetData(familiar)
		if data.LilithBirthcakeGello and not data.PreventDamageLoop then
			data.PreventDamageLoop = true
			ent:TakeDamage(amount * LILITH_CAKE.RUNT_BASE_DMG_MULT, flags, source, countdownFrames)
			data.PreventDamageLoop = false
			return false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, LILITH_CAKE.NerfGelloRuntDamage)

function LILITH_CAKE:OnEntityRemove(ent)
	if ent.Variant == FamiliarVariant.UMBILICAL_BABY
		and ent.SpawnerEntity
		and ent.SpawnerEntity:ToPlayer()
	then
		local data = Mod:GetData(ent.SpawnerEntity)
		if data.ExtraGello
			and GetPtrHash(Mod:GetData(ent.SpawnerEntity).ExtraGello) == GetPtrHash(ent)
		then
			data.ExtraGello = nil
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, LILITH_CAKE.OnEntityRemove, EntityType.ENTITY_FAMILIAR)
