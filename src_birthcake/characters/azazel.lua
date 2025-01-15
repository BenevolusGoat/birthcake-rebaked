local Mod = BirthcakeRebaked
local game = Mod.Game

local AZAZEL_CAKE = {}
BirthcakeRebaked.Birthcake.AZAZEL = AZAZEL_CAKE

-- Azazel Birthcake

AZAZEL_CAKE.DEFAULT_MAX_DURATION = 7
AZAZEL_CAKE.DEFAULT_BONUS_DURATION = 14

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
					laser:SetTimeout(AZAZEL_CAKE.DEFAULT_MAX_DURATION)
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

-- Tainted Azazel Birthcake

