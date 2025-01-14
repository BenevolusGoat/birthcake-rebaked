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

function BirthcakeRebaked:IsInList(item, table)
	for _, v in pairs(table) do
		if v == item then
			return true
		end
	end
	return false
end

---@param trinketID TrinketType
---@param isGolden boolean?
function BirthcakeRebaked:IsBirthcake(trinketID, isGolden)
	if trinketID == Mod.Trinkets.BIRTHCAKE.ID then
		local golden = Mod.Trinkets.BIRTHCAKE.ID + TrinketType.TRINKET_GOLDEN_FLAG
		if isGolden ~= nil then
			return (not isGolden and not golden) or (isGolden and golden)
		else
			return true
		end
	end
	return false
end

---@param player EntityPlayer
function BirthcakeRebaked:GetTrinketMult(player)
	return player:GetTrinketMultiplier(Mod.Trinkets.BIRTHCAKE.ID)
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
			if func(Isaac.GetPlayer(i), i) then
				return true
			end
		end
	end
end

---@param player EntityPlayer
---@param playerType PlayerType
function BirthcakeRebaked:PlayerTypeHasBirthcake(player, playerType)
	return player:GetPlayerType() == playerType and player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID)
end

--- Returns true if any players have given trinket
---@param playerType PlayerType
---@function
function BirthcakeRebaked:AnyPlayerTypeHasBirthcake(playerType)
	local hasTrinket = false
	Mod:ForEachPlayer(function(player)
		if player:GetPlayerType() == playerType and player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
			hasTrinket = true
			return true
		end
	end)

	return hasTrinket
end

--- Returns true if any players have given trinket
---@param playerType PlayerType
---@function
function BirthcakeRebaked:FirstPlayerTypeBirthcakeOwner(playerType)
	local birthcakePlayer
	Mod:ForEachPlayer(function(player)
		if player:GetPlayerType() == playerType and player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
			birthcakePlayer = player
			return true
		end
	end)

	return birthcakePlayer
end

---@param pool ItemPoolType
---@param pos Vector
function BirthcakeRebaked:SpawnFromPool(pool, pos, price)
	local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
		Mod.Game:GetItemPool():GetCollectible(pool, false), pos, Vector(0, 0), nil):ToPickup()
	---@cast collectible EntityPickup
	local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible.SubType)

	if price == -1 then
		price = math.floor(itemConfig.ShopPrice / 2)
	end
	collectible.Price = price
	collectible.AutoUpdatePrice = false
	collectible.ShopItemId = -1
	return collectible
end

---@type {Variant: PickupVariant, SubType: integer | fun(rng: RNG): integer}[]
BirthcakeRebaked.PickupPool = {
	{ Variant = PickupVariant.PICKUP_KEY,      SubType = KeySubType.KEY_NORMAL },
	{ Variant = PickupVariant.PICKUP_BOMB,     SubType = KeySubType.KEY_NORMAL },
	{ Variant = PickupVariant.PICKUP_GRAB_BAG, SubType = function(rng) return rng:RandomInt(2) end },
	{
		Variant = PickupVariant.PICKUP_PILL,
		SubType = function(rng)
			return Mod.Game:GetItemPool():GetPill(rng
				:GetSeed())
		end
	},
	{ Variant = PickupVariant.PICKUP_LIL_BATTERY, SubType = BatterySubType.BATTERY_NORMAL },
	{
		Variant = PickupVariant.PICKUP_TAROTCARD,
		SubType = function(rng)
			return Mod.Game:GetItemPool():GetCard(
				rng:GetSeed(), true, true, false)
		end
	},
}

---@param pos Vector
function BirthcakeRebaked:SpawnRandomPickup(pos, price)
	local player = Mod.Game:GetPlayer(0)
	local rng = player:GetTrinketRNG(Mod.Trinkets.BIRTHCAKE.ID)
	local pickupVarSub = BirthcakeRebaked.PickupPool[rng:RandomInt(#BirthcakeRebaked.PickupPool) + 1]
	local variant = pickupVarSub.Variant
	local subType = type(pickupVarSub.SubType) == "function" and pickupVarSub.SubType(rng) or pickupVarSub.SubType
	---@cast subType integer
	local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, subType, pos, Vector.Zero, nil):ToPickup()
	---@cast pickup EntityPickup

	if price == -1 then
		price = 3
	end
	pickup.Price = price
	pickup.AutoUpdatePrice = false
	pickup.ShopItemId = -1
	return pickup
end

---@function
function BirthcakeRebaked:GetAllHearts(player)
	return (player:GetHearts() - player:GetRottenHearts() * 2) + player:GetSoulHearts() + player:GetRottenHearts() +
		player:GetEternalHearts() + player:GetBoneHearts()
end

function BirthcakeRebaked:IsPlayerTakingMortalDamage(player, amount)
	return BirthcakeRebaked:GetAllHearts(player) - amount <= 0
	and not ((player:GetSoulHearts() > 0 or player:GetBoneHearts() > 0)
		and player:GetHearts() > 0) --Soul/Bone Hearts will protect your red health, no matter how much damage you take
end