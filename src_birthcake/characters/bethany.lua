local Mod = BirthcakeRebaked
local game = Mod.Game

local BETHANY_CAKE = {}
BirthcakeRebaked.Birthcake.BETHANY = BETHANY_CAKE

BETHANY_CAKE.WISP_DUPE_CHANCE = 0.25

-- Bethany Birthcake

---@param familiar EntityFamiliar
function BETHANY_CAKE:OnWispSpawn(familiar)
	local player = familiar.Player

	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BETHANY) and familiar.FrameCount == 5 then
		local run_save = Mod:RunSave(familiar)
		if not run_save.BethanyCakeWispSpawned then
			local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
			local chanceMult = Mod:GetTrinketMult(player)
			if rng:RandomFloat() <= Mod:GetBalanceApprovedChance(BETHANY_CAKE.WISP_DUPE_CHANCE, chanceMult) then
				local newWisp = player:AddWisp(familiar.SubType, player.Position)
				Mod:RunSave(newWisp).BethanyCakeWispSpawned = true
				Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
			end
			run_save.BethanyCakeWispSpawned = true
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BETHANY_CAKE.OnWispSpawn, FamiliarVariant.WISP)

-- Tainted Bethany Birthcake

BETHANY_CAKE.WISP_HEALTH_UP = 4
BETHANY_CAKE.WISP_HEALTH_MULT_ADD = 2

---@param familiar EntityFamiliar
function BETHANY_CAKE:OnWispInit(familiar)
	if familiar.FrameCount == 5 and Mod:PlayerTypeHasBirthcake(familiar.Player, PlayerType.PLAYER_BETHANY_B) then
		local familiar_run_save = Mod:RunSave(familiar)
		if familiar.MaxHitPoints == 4 and not familiar_run_save.BethanyCakeUpgrade then
			local maxHp = familiar.MaxHitPoints + BETHANY_CAKE.WISP_HEALTH_UP +
			(BETHANY_CAKE.WISP_HEALTH_MULT_ADD * (Mod:GetTrinketMult(familiar.Player) - 1)) --8 base, 2 for each multiplier
			familiar.MaxHitPoints = maxHp
			familiar.HitPoints = maxHp
			familiar_run_save.BethanyCakeUpgrade = true
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BETHANY_CAKE.OnWispInit, FamiliarVariant.ITEM_WISP)
