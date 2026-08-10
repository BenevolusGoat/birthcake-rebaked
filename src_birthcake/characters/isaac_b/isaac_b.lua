local Mod = BirthcakeRebaked
local game = Mod.Game

local ISAAC_CAKE = BirthcakeRebaked.Birthcake.ISAAC

---@param player EntityPlayer
function ISAAC_CAKE:HasFullInventory(player)
	local numPassives = 0
	for itemID = 1, #Mod.ItemConfig:GetCollectibles() do
		if player:HasCollectible(itemID) and ISAAC_CAKE:ItemWillFillInventory(itemID) then
			numPassives = numPassives + player:GetCollectibleNum(itemID)
			if numPassives >= ISAAC_CAKE:GetMaxInventorySpace(player) then
				return true
			end
		end
	end
	return false
end

---@param player EntityPlayer
function ISAAC_CAKE:ManageBirthcakeInventoryCap(player)
	local effects = player:GetEffects()
	local currentCap = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
	local expectedCap = Mod:GetTrinketMult(player)

	if expectedCap > 0 or currentCap > 0 then
		if expectedCap < currentCap then
			local diff = currentCap - expectedCap
			effects:RemoveTrinketEffect(Mod.Birthcake.ID, diff)
			ISAAC_CAKE:TryRemoveBirthcakeItems(player)
		elseif expectedCap > currentCap then
			local diff = expectedCap - currentCap
			effects:AddTrinketEffect(Mod.Birthcake.ID, false, diff)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ISAAC_CAKE.ManageBirthcakeInventoryCap, PlayerType.PLAYER_ISAAC_B)
