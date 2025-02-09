local Mod = BirthcakeRebaked

---@param player EntityPlayer
function BirthcakeRebaked:IsTainted(player)
	if REPENTOGON then
		return player:GetEntityConfigPlayer():IsTainted()
	else
		local playerType = player:GetPlayerType()
		local name = player:GetName()
		if playerType >= PlayerType.PLAYER_ISAAC_B and playerType < PlayerType.NUM_PLAYER_TYPES then
			return true
		else
			return playerType == Isaac.GetPlayerTypeByName(name, true)
		end
	end
end

---Executes given function for every player
---Return anything to end the loop early
---@param func fun(player: EntityPlayer, playerNum?: integer): any?
function BirthcakeRebaked:ForEachPlayer(func)
	if REPENTOGON then
		for i, player in ipairs(PlayerManager.GetPlayers()) do
			if func(player, i) then
				return true
			end
		end
	else
		for i = 0, Mod.Game:GetNumPlayers() - 1 do
			if Isaac.GetPlayer(i) and func(Isaac.GetPlayer(i), i) then
				return true
			end
		end
	end
end

---@function
function BirthcakeRebaked:GetAllHearts(player)
	return (player:GetHearts() - player:GetRottenHearts() * 2) + player:GetSoulHearts() + player:GetRottenHearts() +
		player:GetEternalHearts() + player:GetBoneHearts()
end

---Credit to Epiphany and me sorta because I did the bone heart and soul heart fix heheheheheheheheehe
---@param player EntityPlayer
---@param amount integer
function BirthcakeRebaked:IsPlayerTakingMortalDamage(player, amount)
	return BirthcakeRebaked:GetAllHearts(player) - amount <= 0
		and not ((player:GetSoulHearts() > 0 or player:GetBoneHearts() > 0)
			and player:GetHearts() > 0) --Soul/Bone Hearts will protect your red health, no matter how much damage you take
end

---@param player EntityPlayer
---@param trinketList {TrinketType: TrinketType, FirstTime: boolean}[] | TrinketType[]
function BirthcakeRebaked:AddSmeltedTrinkets(player, trinketList)
	local trinket0 = player:GetTrinket(0)
	local trinket1 = player:GetTrinket(1)
	if not REPENTOGON then
		player:TryRemoveTrinket(trinket0)
		player:TryRemoveTrinket(trinket1)
	end
	for _, trinketData in ipairs(trinketList) do
		local trinketID = type(trinketData) == "table" and trinketData.TrinketType or trinketData
		local firstPickup = type(trinketData) == "table" and trinketData.FirstTime or false
		---@cast trinketID TrinketType
		---@cast firstPickup boolean

		if REPENTOGON then
			player:AddSmeltedTrinket(trinketID)
		else
			player:AddTrinket(trinketID, firstPickup)
			player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)
		end
	end
	if not REPENTOGON then
		player:AddTrinket(trinket0)
		player:AddTrinket(trinket1)
	end
end

---@param player EntityPlayer
---@param trinketList TrinketType[]
function BirthcakeRebaked:RemoveSmeltedTrinkets(player, trinketList)
	for _, trinketID in pairs(trinketList) do
		if REPENTOGON then
			player:TryRemoveSmeltedTrinket(trinketID)
		else
			player:TryRemoveTrinket(trinketID)
		end
	end
end

---@param dir integer
function BirthcakeRebaked:DirectionToVector(dir)
	return Vector(-1, 0):Rotated(90 * dir)
end

function BirthcakeRebaked:Delay2Tears(delay)
	return 30 / (delay + 1)
end

function BirthcakeRebaked:Tears2Delay(tears)
	return (30 / tears) - 1
end

---Credit to Epiphany
---@param player EntityPlayer
---@param pickup EntityPickup
function BirthcakeRebaked:CanPickupDeal(player, pickup)
	return player:CanPickupItem()
		and player:IsExtraAnimationFinished()
		and pickup.Wait == 0
		and Mod:IsDevilDealItem(pickup)
		and pickup.Price ~= PickupPrice.PRICE_SOUL
end

function BirthcakeRebaked:IsCoopPlay()
	if REPENTOGON then
		return PlayerManager.IsCoopPlay()
	end
	local isCoopPlay = false
	local controllerIdx
	for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
		local player = ent:ToPlayer() ---@cast player EntityPlayer
		if not controllerIdx then
			controllerIdx = player.ControllerIndex
		elseif controllerIdx ~= player.ControllerIndex then
			isCoopPlay = true
			break
		end
	end
	return isCoopPlay
end

---Credit to Epiphany
---Returns the actual amount of soul hearts the player has, subtracting black hearts.
---@param player EntityPlayer
---@function
function BirthcakeRebaked:GetPlayerRealSoulHeartsCount(player)
	local blackCount = 0
	local soulHearts = player:GetSoulHearts()
	local blackMask = player:GetBlackHearts()

	for i = 1, soulHearts do
		local bit = 2 ^ math.floor((i - 1) / 2)
		if blackMask | bit == blackMask then
			blackCount = blackCount + 1
		end
	end

	return soulHearts - blackCount
end

---Credit to Epiphany
---Returns the actual amount of black hearts the player has.
---@param player EntityPlayer
---@function
function BirthcakeRebaked:GetPlayerRealBlackHeartsCount(player)
	local blackCount = 0
	local soulHearts = player:GetSoulHearts()
	local blackMask = player:GetBlackHearts()

	for i = 1, soulHearts do
		local bit = 2 ^ math.floor((i - 1) / 2)
		if blackMask | bit == blackMask then
			blackCount = blackCount + 1
		end
	end

	return blackCount
end