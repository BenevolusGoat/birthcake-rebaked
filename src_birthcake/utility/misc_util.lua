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

---Checks the pickup and simulates pickup interaction
---@param player EntityPlayer
---@param pickup EntityPickup
---@return boolean @Returns `false` if you can't pick up the pickup, `true` if you consumed it.
---@function
function BirthcakeRebaked:PricedPickup(player, pickup)
	if Mod:CanPlayerBuyShopItem(player, pickup) then
		if pickup.Price > 0 and player:GetNumCoins() < pickup.Price then
			return false
		end -- we return if the price is in money and the player doesn't have enough
		if pickup.Price == 0 then
			Mod:PickupKill(pickup)
			return true
		end

		Mod:PayPickupPrice(player, pickup)
		Mod:PickupShopKill(player, pickup)
		return true
	end
	return false
end

---Kills a shop pickup and plays the correct pickup animation
---@param player EntityPlayer
---@param pickup EntityPickup
---@param sound SoundEffect?
function BirthcakeRebaked:PickupShopKill(player, pickup, sound)
	local sprite = pickup:GetSprite()
	if not sound then
		pickup:PlayPickupSound()
	else
		Mod.SFXManager:Play(sound, 1, 0, false, 1.0)
	end
	player:AnimatePickup(sprite, true, "Pickup")
	pickup.EntityCollisionClass = 0
	local game = Mod.Game
	local room = game:GetRoom()

	if game:IsGreedMode() and room:GetType() == RoomType.ROOM_SHOP then
		local pickupvariant = pickup.Variant
		local pickupsubtype = pickup.SubType
		local pickupposition = pickup.Position
		local pickupprice = pickup.Price
		local shopid = pickup.ShopItemId
		Isaac.CreateTimer(function()
			local NewPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupvariant, pickupsubtype, pickupposition,
					Vector.Zero, nil)
				:ToPickup()
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickupposition, Vector.Zero, NewPickup)
			NewPickup.Price = pickupprice
			NewPickup.ShopItemId = shopid
		end, 10, 1, true)
	elseif player:HasCollectible(CollectibleType.COLLECTIBLE_RESTOCK) and (room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_BLACK_MARKET) then
		local pickupvariant = pickup.Variant
		local pickupposition = pickup.Position
		local room_save = Mod.SaveManager.GetRoomSave()
		local tax = room_save[tostring(pickup.ShopItemId)] or 1
		local pickupprice = (pickup.Price > 0 and pickup.Price < 99) and math.min(99, (5 + ((tax * (tax + 1)) / 2)))
			or pickup.Price
		room_save[tostring(pickup.ShopItemId)] = tax + 1
		local pickupsubtype = pickup.SubType
		local shopid = pickup.ShopItemId
		Isaac.CreateTimer(function()
			local NewPickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupvariant, pickupsubtype, pickupposition,
					Vector.Zero, nil)
				:ToPickup()
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickupposition, Vector.Zero, NewPickup)
			NewPickup.Price = pickupprice
			NewPickup.ShopItemId = shopid
			NewPickup.AutoUpdatePrice = false
			NewPickup.Wait = 60
		end, 10, 1, true)
	end
	pickup:Remove()
end

---Kills a pickup and simulaters vanilla behaviour
---@function
---@param pickup EntityPickup
function BirthcakeRebaked:PickupKill(pickup)
	pickup:PlayPickupSound()
	pickup.Velocity = Vector.Zero
	pickup.EntityCollisionClass = 0
	local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
		:ToEffect() ---@cast effect EntityEffect
	effect.Timeout = pickup.Timeout
	local sprite = effect:GetSprite()
	sprite:Load(pickup:GetSprite():GetFilename(), false)
	if pickup.Variant == PickupVariant.PICKUP_TRINKET then
		local gfx = Mod.ItemConfig:GetTrinket(pickup.SubType).GfxFileName
		sprite:ReplaceSpritesheet(0, gfx)
	end
	sprite:LoadGraphics()
	sprite:Play("Collect", true)
	Mod:KillChoice(pickup)
	pickup:Remove()
end

---Makes a custom coin play the pickup animation
---@function
function BirthcakeRebaked:CollectCustomCoin(pickup, SoundID)
	pickup = pickup:ToPickup()
	pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
	pickup.Touched = true
	Mod:KillChoice(pickup)

	local sprite = pickup:GetSprite()
	sprite:RemoveOverlay()
	sprite:Play("Collect", true)
	pickup:Die()

	if SoundID then
		Mod.SFXManager:Play(SoundID, 1, 0, false, 1.0)
	end
end

function BirthcakeRebaked:IsAnyLost(player)
	if REPENTOGON then
		return player:GetHealthType() == HealthType.LOST
	else
		local playerType = player:GetPlayerType()
		return playerType == PlayerType.PLAYER_THELOST or playerType == PlayerType.PLAYER_THELOST_B
	end
end

---Removes coins or health according to given pickup's price
---@param player EntityPlayer
---@param pickup EntityPickup
---@function
function BirthcakeRebaked:PayPickupPrice(player, pickup)
	local price = pickup.Price
	if price > 0 then
		player:AddCoins(-price)
	elseif price == PickupPrice.PRICE_SOUL then
		player:TryRemoveTrinket(TrinketType.TRINKET_YOUR_SOUL)
	elseif price == PickupPrice.PRICE_SPIKES then
		if not Mod:IsAnyLost(player) then
			local ref = EntityRef(pickup)
			-- following vanilla entity refs for price spikes
			ref.Type = 0
			ref.Variant = 0
			ref.Entity = nil
			player:TakeDamage(2, DamageFlag.DAMAGE_SPIKES | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag
				.DAMAGE_NO_PENALTIES, ref, 30)
		end
	elseif Mod:IsDevilDealItem(pickup) then
		if Mod:IsAnyLost(player) then
			Mod:KillDevilPedestals(pickup)
		else
			if price == PickupPrice.PRICE_ONE_HEART then
				player:AddMaxHearts(-2)
			elseif price == PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS then
				player:AddMaxHearts(-2)
				player:AddSoulHearts(-4)
			elseif price == PickupPrice.PRICE_THREE_SOULHEARTS then
				player:AddSoulHearts(-6)
			elseif price == PickupPrice.PRICE_TWO_HEARTS then
				player:AddMaxHearts(-4)
			end
		end
	elseif price == PickupPrice.PRICE_FREE then
		if not player:TryRemoveTrinket(TrinketType.TRINKET_STORE_CREDIT) then
			for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
				local _player = ent:ToPlayer()
				if _player and _player:TryRemoveTrinket(TrinketType.TRINKET_STORE_CREDIT) then
					return
				end
			end
		end
	end
end

--- Kills all pedestals that cost hearts. For use when Lost buys a devil item
---@param ignoredPickup? EntityPickup A pointer hash to a pedestal that will be ignored. In most cases, this should be a pedestal that the player just picked up.
---@param filter? fun(Pedestal: EntityPickup): boolean
function BirthcakeRebaked:KillDevilPedestals(ignoredPickup, filter)
	local ignoredHash = GetPtrHash(ignoredPickup) or -1
	local level = Mod.Game:GetLevel()
	local isDarkRoom = level:GetStage() == LevelStage.STAGE6 and level:GetStageType() == StageType.STAGETYPE_ORIGINAL
	local pickups = Isaac.FindByType(EntityType.ENTITY_PICKUP)

	for i = #pickups, 1, -1 do
		local ent = pickups[i]
		local pickup = ent:ToPickup() ---@cast pickup EntityPickup
		if GetPtrHash(pickup) ~= ignoredHash
			and (Mod:IsDevilDealItem(pickup)
				or level:GetStartingRoomIndex() == level:GetCurrentRoomIndex()
				and pickup.Variant == PickupVariant.PICKUP_REDCHEST
				and isDarkRoom)
			and (not filter or filter(pickup))
		then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
			pickup:Remove()
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
