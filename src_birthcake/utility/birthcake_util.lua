local Mod = BirthcakeRebaked

--This method is faster than :GetData()
local birthcakeData = {}

---@param entity Entity
function BirthcakeRebaked:GetData(entity)
	local ptrHash = GetPtrHash(entity)
	local data = birthcakeData[ptrHash]
	if not data then
		local newData = {}
		birthcakeData[ptrHash] = newData
		data = newData
	end
	return data
end

Mod:AddPriorityCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CallbackPriority.LATE, function(_, ent)
	birthcakeData[GetPtrHash(ent)] = nil
end)

---@param trinketID TrinketType
---@param isGolden boolean?
function BirthcakeRebaked:IsBirthcake(trinketID, isGolden)
	local normalID = trinketID & ~TrinketType.TRINKET_GOLDEN_FLAG
	local goldenID = trinketID | TrinketType.TRINKET_GOLDEN_FLAG
	if normalID == Mod.Birthcake.ID then
		local golden = trinketID == goldenID
		if isGolden ~= nil then
			return (not isGolden and not golden) or (isGolden and golden)
		else
			return true
		end
	end
	return false
end

---@param player EntityPlayer
---@param ignoreBox? boolean
function BirthcakeRebaked:GetTrinketMult(player, ignoreBox)
	local mult = player:GetTrinketMultiplier(Mod.Birthcake.ID)
	if ignoreBox and player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
		mult = mult - 1
	end
	return mult
end

---@param playerType PlayerType
function BirthcakeRebaked:GetCombinedTrinketMult(playerType)
	local trinketMult = 0
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, playerType) then
			trinketMult = trinketMult + (Mod:GetTrinketMult(player))
		end
	end)
	return trinketMult
end

---@param player EntityPlayer
---@param playerType PlayerType
function BirthcakeRebaked:PlayerTypeHasBirthcake(player, playerType)
	return player and player:ToPlayer() and playerType and player:ToPlayer():GetPlayerType() == playerType and player:ToPlayer():HasTrinket(Mod.Birthcake.ID)
end

--- Returns true if any players have given trinket
---@param playerType PlayerType
---@function
function BirthcakeRebaked:AnyPlayerTypeHasBirthcake(playerType)
	local hasTrinket = false
	Mod:ForEachPlayer(function(player)
		if player:GetPlayerType() == playerType and player:HasTrinket(Mod.Birthcake.ID) then
			hasTrinket = true
			return true
		end
	end)

	return hasTrinket
end

--- Returns true if any players have given trinket
---@param playerType PlayerType
---@return EntityPlayer?
---@function
function BirthcakeRebaked:FirstPlayerTypeBirthcakeOwner(playerType)
	local birthcakePlayer
	Mod:ForEachPlayer(function(player)
		if player:GetPlayerType() == playerType and player:HasTrinket(Mod.Birthcake.ID) then
			birthcakePlayer = player
			return true
		end
	end)

	return birthcakePlayer
end