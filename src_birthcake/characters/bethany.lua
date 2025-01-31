local Mod = BirthcakeRebaked
local game = Mod.Game

local BETHANY_CAKE = {}
BirthcakeRebaked.Birthcake.BETHANY = BETHANY_CAKE

BETHANY_CAKE.WISP_DUPE_CHANCE = 0.25

-- Bethany Birthcake

---@param itemID CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param flags UseFlag
function BETHANY_CAKE:OnActiveUse(itemID, rng, player, flags)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BETHANY)
		and (Mod:HasBitFlags(flags, UseFlag.USE_ALLOWWISPSPAWN)
			or player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES))
	then
		local chanceMult = Mod:GetTrinketMult(player)
		if rng:RandomFloat() <= Mod:GetBalanceApprovedChance(BETHANY_CAKE.WISP_DUPE_CHANCE, chanceMult) then
			player:AddWisp(itemID, player.Position)
			Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, BETHANY_CAKE.OnActiveUse)

-- Tainted Bethany Birthcake

BETHANY_CAKE.WISP_HEALTH_UP = 4
BETHANY_CAKE.WISP_HEALTH_MULT_ADD = 2

---@param familiar EntityFamiliar
function BETHANY_CAKE:OnWispInit(familiar)
	if familiar.FrameCount >= 5 and Mod:PlayerTypeHasBirthcake(familiar.Player, PlayerType.PLAYER_BETHANY_B) then
		local familiar_run_save = Mod:RunSave(familiar)
		if familiar.MaxHitPoints == 4 and not familiar_run_save.BethanyBirthcakeUpgrade then
			local maxHp = familiar.MaxHitPoints + BETHANY_CAKE.WISP_HEALTH_UP +
			(BETHANY_CAKE.WISP_HEALTH_MULT_ADD * (Mod:GetTrinketMult(familiar.Player) - 1))                                                            --8 base, 2 for each multiplier
			familiar.MaxHitPoints = maxHp
			familiar.HitPoints = maxHp
			familiar_run_save.BethanyBirthcakeUpgrade = true
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, BETHANY_CAKE.OnWispInit, FamiliarVariant.ITEM_WISP)
