local Mod = BirthcakeRebaked

local ISAAC_CAKE = BirthcakeRebaked.Birthcake.ISAAC

---@param player EntityPlayer
function ISAAC_CAKE:IsFullInventory(player)
	local numPassives = 0

	for _, historyItem in ipairs(player:GetHistory():GetCollectiblesHistory()) do
		if ISAAC_CAKE:ItemWillFillInventory(historyItem:GetItemID()) then
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
		local diff = numItems - expectedCap
		for _ = 1, diff do
			local itemID = inventory[numItems]
			numItems = numItems - 1
			player:DropCollectible(itemID, nil, true)
		end
	end
end

---@param player EntityPlayer
function ISAAC_CAKE:OnCollectibleAdd(itemID, charge, firstTime, slot, varData, player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC_B)
		and ISAAC_CAKE:ItemWillFillInventory(itemID)
		and ISAAC_CAKE:IsFullInventory(player)
	then
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		local inventory = player_run_save.IsaacBBirthcakeInventory
		if not inventory then
			inventory = {}
			player_run_save.IsaacBBirthcakeInventory = inventory
		end
		local expectedCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		if #inventory < expectedCap then
			inventory[#inventory + 1] = itemID
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, ISAAC_CAKE.OnCollectibleAdd)

---@param player EntityPlayer
---@param itemID CollectibleType
function ISAAC_CAKE:OnCollectibleRemove(player, itemID)
	if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B
		and ISAAC_CAKE:ItemWillFillInventory(itemID)
		and ISAAC_CAKE:IsFullInventory(player)
	then
		local player_run_save = Mod.SaveManager.TryGetRunSave(player)
		local inventory = player_run_save and player_run_save.IsaacBBirthcakeInventory
		if inventory and #inventory > 0 then
			for index, inventoryItem in ipairs(inventory) do
				if itemID == inventoryItem then
					table.remove(inventory, index)
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, ISAAC_CAKE.OnCollectibleRemove)

---@param player EntityPlayer
function ISAAC_CAKE:OnIsaacBFirstPickup(player, _, _, isGolden)
	if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B then
		local addBy = isGolden and 2 or 1
		local effects = player:GetEffects()
		effects:AddTrinketEffect(Mod.Birthcake.ID, false, addBy)
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, ISAAC_CAKE.OnIsaacBFirstPickup, PlayerType.PLAYER_ISAAC_B)

---@param player EntityPlayer
function ISAAC_CAKE:OnIsaacBPickupRemove(player, trinketID)
	if player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B then
		local removeBy = Mod:IsBirthcake(trinketID, true) and 2 or 1
		local effects = player:GetEffects()
		effects:RemoveTrinketEffect(Mod.Birthcake.ID, removeBy)
		ISAAC_CAKE:TryRemoveBirthcakeItems(player)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, ISAAC_CAKE.OnIsaacBPickupRemove, Mod.Birthcake.ID)
Mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_REMOVED, ISAAC_CAKE.OnIsaacBPickupRemove,
Mod.Birthcake.ID + TrinketType.TRINKET_GOLDEN_FLAG)
