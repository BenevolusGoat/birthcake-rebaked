local Mod = BirthcakeRebaked
local game = Mod.Game

local AZAZEL_CAKE = {}
BirthcakeRebaked.Birthcake.AZAZEL = AZAZEL_CAKE

-- Azazel Birthcake

--API SSUUCCKKSS and I can't change the damage of the laser directly, trust me I tried for non-gon

AZAZEL_CAKE.DEFAULT_BONUS_DURATION = 14
AZAZEL_CAKE.DAMAGE_MULT = 0.9

---@param ent Entity
---@param amount number
---@param flags DamageFlag
---@param source EntityRef
---@param countdown integer
function AZAZEL_CAKE:OnEntityTakeDamage(ent, amount, flags, source, countdown)
	local player = source and source.Entity and source.Entity:ToPlayer()

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_AZAZEL)
		and ent:ToNPC()
		and ent:IsActiveEnemy(false)
		and amount > 0
	then
		for _, laserEnt in ipairs(Isaac.FindByType(EntityType.ENTITY_LASER)) do
			local laser = laserEnt:ToLaser()
			---@cast laser EntityLaser
			if laser.Timeout >= 1
				and GetPtrHash(laser.Parent) == GetPtrHash(player)
				and GetPtrHash(laser.SpawnerEntity) == GetPtrHash(player)
			then
				local trinketMult = (Mod:GetTrinketMult(player) - 1) * 0.5 --trinket mult has half effect
				local bonusDuration = AZAZEL_CAKE.DEFAULT_BONUS_DURATION * trinketMult
				local data = Mod:GetData(laser)
				if (data.AzazelBirthcakeExtension or 0) < AZAZEL_CAKE.DEFAULT_BONUS_DURATION + bonusDuration then
					laser:SetTimeout(laser.Timeout)
					data.AzazelBirthcakeExtension = (data.AzazelBirthcakeExtension or 0) + 1
				end
			end
		end
	end
end

if REPENTOGON then
	Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_TAKE_DMG, AZAZEL_CAKE.OnEntityTakeDamage)
else
	Mod:AddPriorityCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, CallbackPriority.LATE, AZAZEL_CAKE.OnEntityTakeDamage)
end

---@param player EntityPlayer
function AZAZEL_CAKE:DamageDown(player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_AZAZEL) then
		player.Damage = player.Damage * AZAZEL_CAKE.DAMAGE_MULT
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AZAZEL_CAKE.DamageDown, CacheFlag.CACHE_DAMAGE)

-- Tainted Azazel Birthcake

AZAZEL_CAKE.BOOGER_RANGE = 0.25
AZAZEL_CAKE.BOOGER_STICK_CHANCE = 0.11

local function randomInt(lower, upper)
	return Mod.GENERIC_RNG:RandomInt((upper - lower) + 1) + lower
end

---@param effect EntityEffect
function AZAZEL_CAKE:OnSneeze(effect)
	local player = effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()
	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_AZAZEL_B)
		and player:GetFireDirection() ~= Direction.NO_DIRECTION
		and player.FireDelay == -1
	then
		local fireDir = BirthcakeRebaked:DirectionToVector(player:GetFireDirection())
		local randomVel = randomInt(-2, 2)
		local randomAngle = randomInt(-20, 20)
		local vel = (fireDir:Resized(10 + randomVel):Rotated(randomAngle) * player.ShotSpeed * 1.2) + player:GetTearMovementInheritance(fireDir)
		local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BOOGER, 0, player.Position, vel, player):ToTear()
		---@cast tear EntityTear
		tear.CollisionDamage = tear.CollisionDamage * 0.5
		tear.FallingAcceleration = AZAZEL_CAKE.BOOGER_RANGE

		if Mod.GENERIC_RNG:RandomFloat() <= AZAZEL_CAKE.BOOGER_STICK_CHANCE * Mod:GetTrinketMult(player) then
			tear:AddTearFlags(TearFlags.TEAR_BOOGER)
		end
		tear:SetColor(Color(1, 0, 0, 1, 0.5, 0, 0), -1, 10, false, true)
		Mod:GetData(tear).AzazelCakeBoogerTear = true
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, AZAZEL_CAKE.OnSneeze, EffectVariant.HAEMO_TRAIL)

---@param tear EntityTear
---@param collider Entity
function AZAZEL_CAKE:OnBoogerCollision(tear, collider)
	if tear.SpawnerEntity
		and tear.SpawnerEntity:ToPlayer()
		and collider:IsActiveEnemy(false)
		and Mod:GetData(tear).AzazelCakeBoogerTear
	then
		collider:AddEntityFlags(EntityFlag.FLAG_BRIMSTONE_MARKED)
	end
end

if REPENTOGON then
	Mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, AZAZEL_CAKE.OnBoogerCollision)
else
	Mod:AddPriorityCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, CallbackPriority.LATE, AZAZEL_CAKE.OnBoogerCollision)
end
