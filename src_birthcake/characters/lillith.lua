local Mod = BirthcakeRebaked

local LILITH_CAKE = {}
BirthcakeRebaked.Birthcake.LILITH = LILITH_CAKE

-- Functions

function LILITH_CAKE:CheckLillith(player)
	return player:GetPlayerType() == PlayerType.PLAYER_LILITH
end

function LILITH_CAKE:CheckLillithB(player)
	return player:GetPlayerType() == PlayerType.PLAYER_LILITH_B
end

-- Lillith Birthcake

---@param tearOrLaser EntityTear | EntityLaser
function LILITH_CAKE:EffectShare(tearOrLaser)
	if tearOrLaser.FrameCount == 1
		and tearOrLaser.SpawnerEntity
		and tearOrLaser.SpawnerEntity:ToFamiliar()
		and tearOrLaser.SpawnerEntity:ToFamiliar().Player
		and Mod:PlayerTypeHasBirthcake(tearOrLaser.SpawnerEntity:ToFamiliar().Player, PlayerType.PLAYER_LILITH)
	then
		local player = tearOrLaser.SpawnerEntity:ToFamiliar().Player
		local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
		local trinketMult = Mod:GetTrinketMult(player)

		if rng:RandomFloat() < 0.25 * trinketMult then
			tearOrLaser:AddTearFlags(player.TearFlags)
			tearOrLaser:SetColor(player.TearColor, -1, 1, false, false)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, LILITH_CAKE.EffectShare)
Mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, LILITH_CAKE.EffectShare)

-- Tainted Lillith Birthcake

--TODO: Consider a second Gello that has a chance to spawn
