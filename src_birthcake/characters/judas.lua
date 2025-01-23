local Mod = BirthcakeRebaked
local game = Mod.Game

local JUDAS_CAKE = {}

BirthcakeRebaked.Birthcake.JUDAS = JUDAS_CAKE

---@param player EntityPlayer
function JUDAS_CAKE:JudasHasBirthcake(player)
	return (player:GetPlayerType() == PlayerType.PLAYER_JUDAS or player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS)
	and player:HasTrinket(Mod.Birthcake.ID)
end

-- Judas Birthcake

JUDAS_CAKE.DAMAGE_MULT_UP = 0.1
JUDAS_CAKE.PickupPriceCost = {
	[PickupPrice.PRICE_ONE_HEART] = {
		Red = 1,
	},
	[PickupPrice.PRICE_TWO_HEARTS] = {
		Red = 2,
	},
	[PickupPrice.PRICE_THREE_SOULHEARTS] = {
		Soul = 3
	},
	[PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS] = {
		Red = 1,
		Soul = 2
	},
	[PickupPrice.PRICE_SPIKES] = {},
	[PickupPrice.PRICE_SOUL] = {},
	[PickupPrice.PRICE_ONE_SOUL_HEART] = {
		Soul = 1
	},
	[PickupPrice.PRICE_TWO_SOUL_HEARTS] = {
		Soul = 2
	},
	[PickupPrice.PRICE_ONE_HEART_AND_ONE_SOUL_HEART] = {
		Red = 1,
		Soul = 1
	},
}

---@param player EntityPlayer
---@param pickup EntityPickup
function JUDAS_CAKE:IsFatalDeal(player, pickup)
	local hearts = player:GetEffectiveMaxHearts()
	local soulHearts = player:GetSoulHearts()
	if not Mod:CanPickupDeal(player, pickup) then return false end
	local cost = JUDAS_CAKE.PickupPriceCost[pickup.Price]
	if not cost then return false end
	local heartCost = cost.Red or 0
	local soulCost = cost.Soul or 0
	hearts = math.max(0, hearts - (heartCost * 2))
	soulHearts = math.max(0, soulHearts - (soulCost * 2))
	return hearts + soulHearts <= 0
end

---@param player EntityPlayer
function JUDAS_CAKE:JudasPickup(player)
	if JUDAS_CAKE:JudasHasBirthcake(player) then
		player.Damage = player.Damage * (1 + (JUDAS_CAKE.DAMAGE_MULT_UP * Mod:GetTrinketMult(player)))
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JUDAS_CAKE.JudasPickup, CacheFlag.CACHE_DAMAGE)

---@param collider Entity
---@param pickup EntityPickup
function JUDAS_CAKE:OnDevilDealCollision(pickup, collider)
	local player = collider:ToPlayer()

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_JUDAS)
		and JUDAS_CAKE:IsFatalDeal(player, pickup)
	then
		pickup.Price = PickupPrice.PRICE_SOUL
		pickup.AutoUpdatePrice = false
		player:TryRemoveTrinket(Mod.Birthcake.ID)
	end
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, JUDAS_CAKE.OnDevilDealCollision, PickupVariant.PICKUP_COLLECTIBLE)

-- Tainted Judas Birthcake

JUDAS_CAKE.DARK_ARTS_CHARGE_BONUS = 20

---@param player EntityPlayer
function JUDAS_CAKE:ShadowCharge(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and player:GetActiveItem(ActiveSlot.SLOT_POCKET) == CollectibleType.COLLECTIBLE_DARK_ARTS
	then
		local data = Mod:GetData(player)
		local playerRadius = player.Size
		local maxCharge = Mod.ItemConfig:GetCollectible(CollectibleType.COLLECTIBLE_DARK_ARTS).MaxCharges
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
			maxCharge = maxCharge * 2
		end
		playerRadius = playerRadius + (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 40 or 10)
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS) then
			for _, ent in ipairs(Isaac.GetRoomEntities()) do
				if ent:IsActiveEnemy(false)
					and ent.Position:DistanceSquared(player.Position) <= (playerRadius + ent.Size) ^ 2
					and (not data.JudasCakeEnemyTouch
					or not data.JudasCakeEnemyTouch[GetPtrHash(ent)])
				then
					player:SetActiveCharge(math.min(maxCharge, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + JUDAS_CAKE.DARK_ARTS_CHARGE_BONUS), ActiveSlot.SLOT_POCKET)
					data.JudasCakeEnemyTouch = data.JudasCakeEnemyTouch or {}
					data.JudasCakeEnemyTouch[GetPtrHash(ent)] = true
				end
			end
		elseif data.JudasCakeEnemyTouch then
			data.JudasCakeEnemyTouch = nil
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, JUDAS_CAKE.ShadowCharge, PlayerType.PLAYER_JUDAS_B)
