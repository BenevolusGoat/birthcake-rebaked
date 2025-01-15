local Mod = BirthcakeRebaked

function BirthcakeRebaked:IsInList(item, table)
	for _, v in pairs(table) do
		if v == item then
			return true
		end
	end
	return false
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

---@param pool ItemPoolType
---@param pos Vector
function BirthcakeRebaked:SpawnFromPool(pool, pos, price)
	local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
		Mod.Game:GetItemPool():GetCollectible(pool, false), pos, Vector(0, 0), nil):ToPickup()
	---@cast collectible EntityPickup
	local itemConfig = Mod.ItemConfig:GetCollectible(collectible.SubType)

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
	local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
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

---Returns true if the first agument contains the second argument
---@generic flag : BitSet128 | integer | TearFlags
---@param flags flag
---@param checkFlag flag
function BirthcakeRebaked:HasBitFlags(flags, checkFlag)
	if not checkFlag then
		error("BitMaskHelper: checkFlag is nil", 2)
	end
	return flags & checkFlag == checkFlag
end

---Credit to Epiphany
---Grants the player an item from a pedestal
---@param pickup EntityPickup
---@param player EntityPlayer
---@function
function BirthcakeRebaked:AwardPedestalItem(pickup, player)
	local itemId = pickup.SubType
	if itemId ~= CollectibleType.COLLECTIBLE_NULL then
		local configitem = Mod.ItemConfig:GetCollectible(itemId)
		player:AnimateCollectible(itemId)
		player:QueueItem(configitem, pickup.Charge, pickup.Touched)
		player.QueuedItem.Item = configitem
		Mod.SFXManager:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 0.5)
		pickup.Touched = true
		pickup.SubType = 0
		pickup:GetSprite():Play("Empty", true)
		pickup:GetSprite():ReplaceSpritesheet(4, "blank", true)
		Mod.Game:GetHUD():ShowItemText(player, Isaac:GetItemConfig():GetCollectible(itemId))
		Mod:KillChoice(pickup)
	end
end

---Credit to Epiphany
---@param pickup EntityPickup
---Options? compatibility and Choice pedestals in general.
---Kills choices connected to the pickup passed.
---@function
function BirthcakeRebaked:KillChoice(pickup)
	if pickup.OptionsPickupIndex ~= 0 then
		local pickups =Isaac.FindByType(EntityType.ENTITY_PICKUP)
		for i = #pickups, 1, -1 do
			local ent = pickups[i]
			if pickup.OptionsPickupIndex == ent:ToPickup().OptionsPickupIndex and GetPtrHash(pickup) ~= GetPtrHash(ent) then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, ent.Position, Vector.Zero, nil)
				ent:Remove()
			end
		end
	end
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
---@param trinketList {[string]: integer}[]
function BirthcakeRebaked:RemoveSmeltedTrinkets(player, trinketList)
	for trinketIDStr, trinketNum in pairs(trinketList) do
		local trinketID = tonumber(trinketIDStr)
		---@cast trinketID TrinketType

		for _ = 1, trinketNum do
			if REPENTOGON then
				player:TryRemoveSmeltedTrinket(trinketID)
			else
				player:TryRemoveTrinket(trinketID)
			end
		end
	end
end