local Mod = BirthcakeRebaked
local game = Mod.Game

local BETHANY_CAKE = {}
BirthcakeRebaked.Birthcake.BETHANY = BETHANY_CAKE

BETHANY_CAKE.WISP_CHANCE = 0.25

-- Bethany Birthcake

---@param itemID CollectibleType
---@param rng RNG
---@param player EntityPlayer
---@param flags UseFlag
function BETHANY_CAKE:OnActiveUse(itemID, rng, player, flags)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BETHANY)
		and Mod:HasBitFlags(flags, UseFlag.USE_ALLOWWISPSPAWN)
		and player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
	then
		local chanceMult = Mod:GetTrinketMult(player)
		if rng:RandomFloat() < BETHANY_CAKE.WISP_CHANCE * chanceMult then
			player:AddWisp(itemID, player.Position)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, BETHANY_CAKE.OnActiveUse)

-- Tainted Bethany Birthcake

--TODO: Rework
