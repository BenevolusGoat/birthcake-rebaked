local Mod = BirthcakeRebaked
local game = Mod.Game

local ISAAC_CAKE = BirthcakeRebaked.Birthcake.ISAAC

---@param player EntityPlayer
function ISAAC_CAKE:IsFullInventory(player)
	local numPassives = 0
	for itemID = 1, #Mod.ItemConfig:GetCollectibles() do
		if ISAAC_CAKE:ItemWillFillInventory(itemID) then
			numPassives = numPassives + 1
		end
	end
	return numPassives >= (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 12 or 8)
end

---@param player EntityPlayer
function ISAAC_CAKE:TryRemoveBirthcakeItems(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	local inventory = player_run_save.IsaacBBirthcakeInventory
	local expectedCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
	local numItems = #inventory

	if expectedCap < numItems then
		local room = game:GetRoom()
		local diff = numItems - expectedCap
		for _ = 1, diff do
			local itemID = inventory[numItems]
			numItems = numItems - 1
			player:RemoveCollectible(itemID, true)
			local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemID,
			room:FindFreePickupSpawnPosition(player.Position, 40, true, false), Vector.Zero, player):ToPickup()
			---@cast collectible EntityPickup
			collectible:Morph(collectible.Type, collectible.Variant, collectible.SubType, true, true, true)
			collectible.Touched = true
		end
	end
end

---@param player EntityPlayer
function ISAAC_CAKE:ManageBirthcakeInventoryCap(player)
	local effects = player:GetEffects()
	local cakeEffects = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
	if cakeEffects > 0 then
		local expectedCap = Mod:GetTrinketMult(player)
		local currentCap = cakeEffects
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

---@param player EntityPlayer
function ISAAC_CAKE:OnPeffectUpdate(player)
	ISAAC_CAKE:OnIsaacBFirstPickup(player)
	ISAAC_CAKE:ManageBirthcakeInventoryCap(player)
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ISAAC_CAKE.OnIsaacBFirstPickup, PlayerType.PLAYER_ISAAC_B)
