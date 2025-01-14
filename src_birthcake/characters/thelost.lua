local Mod = BirthcakeRebaked
local game = Mod.Game

local THELOST_CAKE = {}
BirthcakeRebaked.Birthcake.THELOST = THELOST_CAKE

-- The Lost Birthcake

---@param player EntityPlayer
function THELOST_CAKE:FreeEternalD6(itemID, rng, player, flags, slot, varData)
	local player_floor_save = Mod.SaveManager.GetFloorSave(player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
		and Mod:HasBitFlags(flags, UseFlag.USE_OWNED)
		and (player_floor_save.LostBirthcakeFreeEternalD6Use or 0) < 2
	then
		player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM, slot)
		player:FullCharge(slot)
		player_floor_save.LostBirthcakeFreeEternalD6Use = (player_floor_save.LostBirthcakeFreeEternalD6Use or 0) + 1
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_ETERNAL_D6, "UseItem", "PlayerPickupSparkle")
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		return true
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, THELOST_CAKE.FreeEternalD6, CollectibleType.COLLECTIBLE_ETERNAL_D6)

---@param player EntityPlayer
function THELOST_CAKE:FreeActiveUse(itemID, rng, player, flags, slot, varData)
	if itemID == CollectibleType.COLLECTIBLE_ETERNAL_D6 then return end
	local player_floor_save = Mod.SaveManager.GetFloorSave(player)

	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
		and Mod:HasBitFlags(flags, UseFlag.USE_OWNED)
		and not player_floor_save.LostBirthcakeFreeActiveUse
	then
		player_floor_save.LostBirthcakeFreeActiveUse = true
		player:FullCharge()
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, THELOST_CAKE.FreeActiveUse)

local font = Font()
font:Load("font/pftempestasevencondensed.fnt")

HudHelper.RegisterHUDElement({
	Name = "Lost Birthcake Rerolls",
	Priority = HudHelper.Priority.HIGH,
	Condition = function(player, playerHUDIndex, hudLayout, slot)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
			and HudHelper.ShouldActiveBeDisplayed(player, player:GetActiveItem(slot), slot)
		then
			local itemID = player:GetActiveItem(slot)
			local player_floor_save = Mod.SaveManager.GetFloorSave(player)

			if itemID == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
				return player_floor_save.LostBirthcakeFreeEternalD6Use < 2
			else
				return player_floor_save.LostBirthcakeFreeActiveUse
			end
		end
		return false
	end,
	OnRender = function(player, playerHUDIndex, hudLayout, position, alpha, scale, slot)
		local itemID = player:GetActiveItem(slot)
		local player_floor_save = Mod.SaveManager.GetFloorSave(player)
		position = position + Vector(28 * scale, 28 * scale)

		if itemID == CollectibleType.COLLECTIBLE_ETERNAL_D6 then
			local numUses = 2 - (player_floor_save.LostBirthcakeFreeEternalD6Use or 0)
			font:DrawStringScaled("x" .. numUses, position.X, position.Y, scale, scale, KColor(1, 1, 1, alpha))
		else
			local numUses = player_floor_save.LostBirthcakeFreeActiveUse and 1 or 0
			font:DrawStringScaled("x" .. numUses, position.X, position.Y, scale, scale, KColor(1, 1, 1, alpha))
		end
	end
})

-- Tainted Lost Birthcake

--TODO: Revisit
