local Mod = BirthcakeRebaked

function BirthcakeRebaked:IsInList(item, table)
	for _, v in pairs(table) do
		if v == item then
			return true
		end
	end
	return false
end

---@param pool ItemPoolType
---@param pos Vector
function BirthcakeRebaked:SpawnFromPool(pool, pos, price)
	local collectible = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
		Mod.Game:GetItemPool():GetCollectible(pool, false), pos, Vector(0, 0), nil):ToPickup()
	---@cast collectible EntityPickup
	local itemConfig = Mod.ItemConfig:GetCollectible(collectible.SubType)

	if price == -1 then
		price = (itemConfig.ShopPrice / 2) // 1
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

---Returns true if the first agument contains the second argument
---@generic flag : BitSet128 | integer | TearFlags
---@param flags flag
---@param checkFlag flag
function BirthcakeRebaked:HasBitFlags(flags, checkFlag)
	if not checkFlag then
		error("BitMaskHelper: checkFlag is nil", 2)
	end
	return flags & checkFlag > 0
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
		--[[player:QueueItem(configitem, pickup.Charge, pickup.Touched)
		player.QueuedItem.Item = configitem]]
		Mod.SFXManager:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 0.5)
		pickup.Touched = true
		pickup.SubType = 0
		local sprite = pickup:GetSprite()
		sprite:Play("Empty", true)
		sprite:ReplaceSpritesheet(4, "blank")
		sprite:LoadGraphics()
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
		local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)
		for i = #pickups, 1, -1 do
			local ent = pickups[i]
			if pickup.OptionsPickupIndex == ent:ToPickup().OptionsPickupIndex and GetPtrHash(pickup) ~= GetPtrHash(ent) then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, ent.Position, Vector.Zero, nil)
				ent:Remove()
			end
		end
	end
end


---@param baseChance number
---@param mult number
function BirthcakeRebaked:GetBalanceApprovedChance(baseChance, mult)
	if mult == 0 then mult = 1 end
	return (1 - 2 ^ (-mult)) * baseChance * 2
end


---@param pickup EntityPickup
function BirthcakeRebaked:IsDevilDealItem(pickup)
	return pickup.Price < 0 and pickup.Price ~= PickupPrice.PRICE_FREE and pickup.Price ~= PickupPrice.PRICE_SPIKES
end


---Credit to Epiphany
---@generic K, V
---@param tab table<K,V>
---@param func fun(val: V): any
---@function
function BirthcakeRebaked:Map(tab, func)
	local out = {}

	for k, v in pairs(tab) do
		out[k] = func(v)
	end

	return out
end

function BirthcakeRebaked:Clamp(x, min, max)
	if x < min then return min end
	if x > max then return max end
	return x
end

---From decomp
---@param bomb EntityBomb
function BirthcakeRebaked:GetBombRadius(bomb)
	local damage = bomb.ExplosionDamage
	local radius = 90.0
	if 175.0 <= damage then
		radius = 105.0
	elseif damage <= 140.0 then
		radius = 75.0
	end
	return radius * bomb.RadiusMultiplier
end