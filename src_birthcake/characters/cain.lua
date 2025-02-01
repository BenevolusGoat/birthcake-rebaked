local Mod = BirthcakeRebaked
local game = Mod.Game

local CAIN_BIRTHCAKE = {}
BirthcakeRebaked.Birthcake.CAIN = CAIN_BIRTHCAKE

-- Cain Birthcake

---@param player EntityPlayer
function CAIN_BIRTHCAKE:CainPickup(player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_CAIN) then
		player.Luck = player.Luck + 1
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CAIN_BIRTHCAKE.CainPickup, CacheFlag.CACHE_LUCK)

---@type {[SlotVariant]: {RefundReward: fun(player: EntityPlayer), RefundChance: number | fun(player: EntityPlayer): number}}
CAIN_BIRTHCAKE.SlotsData = {
	[Mod.SlotVariant.SLOT_MACHINE] = {
		RefundChance = 0.33,
		RefundReward = function(player)
			player:AddCoins(1)
		end,
	},
	[Mod.SlotVariant.FORTUNE_TELLING_MACHINE] = {
		RefundChance = 0.33,
		RefundReward = function(player)
			player:AddCoins(1)
		end,
	},
	[Mod.SlotVariant.CRANE_GAME] = {
		RefundChance = 0.25,
		RefundReward = function(player)
			player:AddCoins(5)
		end,
	},
}

function CAIN_BIRTHCAKE:MachineInteraction(player, ent, low)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_CAIN)
		and ent.Type == EntityType.ENTITY_SLOT
	then
		local data = Mod:GetData(ent)
		data.TouchedPlayer = player
	end
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CallbackPriority.EARLY, CAIN_BIRTHCAKE.MachineInteraction,
	0)

function CAIN_BIRTHCAKE:OnSlotInitiate(slot)
	local data = Mod:GetData(slot)
	local sprite = slot:GetSprite()

	if data.TouchedPlayer and not data.WaitAfterInitiate then
		if sprite:IsPlaying("Initiate") then
			local slotData = CAIN_BIRTHCAKE.SlotsData[slot.Variant]

			if slotData then
				local player = data.TouchedPlayer
				local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
				local roll = rng:RandomFloat()
				local baseChance = type(slotData.RefundChance) == "function" and slotData.RefundChance(player) or
				slotData.RefundChance
				---@cast baseChance number
				local chance = Mod:GetBalanceApprovedChance(baseChance, Mod:GetTrinketMult(player))

				if roll <= chance then
					slotData.RefundReward(player)
					player:AnimateHappy()
				end
				data.WaitAfterInitiate = true
			end
		end
		data.TouchedPlayer = nil
	end
	if data.WaitAfterInitiate and not sprite:IsPlaying("Initiate") then
		data.WaitAfterInitiate = nil
	end
end

if REPENTOGON then
	Mod:AddCallback(ModCallbacks.MC_POST_SLOT_UPDATE, CAIN_BIRTHCAKE.OnSlotInitiate)
else
	Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_SLOT)) do
			CAIN_BIRTHCAKE:OnSlotInitiate(ent)
		end
	end)
end


-- Tainted Cain Birthcake

CAIN_BIRTHCAKE.DoublePickupToSingle = {
	[PickupVariant.PICKUP_BOMB] = {
		[BombSubType.BOMB_DOUBLEPACK] = BombSubType.BOMB_NORMAL
	},
	[PickupVariant.PICKUP_KEY] = {
		[KeySubType.KEY_DOUBLEPACK] = KeySubType.KEY_NORMAL
	},
	[PickupVariant.PICKUP_COIN] = {
		[CoinSubType.COIN_DOUBLEPACK] = CoinSubType.COIN_PENNY
	},
	[PickupVariant.PICKUP_HEART] = {
		[HeartSubType.HEART_DOUBLEPACK] = HeartSubType.HEART_FULL
	},
}

---@param pickup EntityPickup
function CAIN_BIRTHCAKE:SplitPickup(pickup)
	local pickup_save = Mod:TryGetNoRerollSave(pickup)
	if Mod:AnyPlayerTypeHasBirthcake(PlayerType.PLAYER_CAIN_B)
		and not pickup:IsShopItem()
		and (not pickup_save
			or not pickup_save.NoRerollSave 
			or not pickup_save.NoRerollSave.CainCakeSplitPickup)
		and pickup.FrameCount == 1
	then
		local variant = pickup.Variant
		local subType = pickup.SubType
		local splitSubType = CAIN_BIRTHCAKE.DoublePickupToSingle[variant] and
			CAIN_BIRTHCAKE.DoublePickupToSingle[variant][subType]
		if splitSubType then
			pickup_save = Mod:GetNoRerollSave(pickup)
			local pickup2 = Isaac.Spawn(pickup.Type, variant, splitSubType,
			Isaac.GetFreeNearPosition(pickup.Position + Vector(15, 0), 0), Vector.Zero, pickup.SpawnerEntity)
			:ToPickup()
			---@cast pickup2 EntityPickup
			Mod:GetNoRerollSave(pickup2).CainCakeSplitPickup = true
			pickup:Morph(pickup.Type, pickup.Variant, splitSubType, true, true, true)
			pickup2:Morph(pickup.Type, pickup.Variant, splitSubType, true, true, true)
			pickup_save.CainCakeSplitPickup = true
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CLEAVER_SLASH, 0, pickup.Position, Vector.Zero, nil)
			Mod.SFXManager:Play(SoundEffect.SOUND_KNIFE_PULL)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CAIN_BIRTHCAKE.SplitPickup, PickupVariant.PICKUP_BOMB)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CAIN_BIRTHCAKE.SplitPickup, PickupVariant.PICKUP_KEY)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CAIN_BIRTHCAKE.SplitPickup, PickupVariant.PICKUP_HEART)
Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CAIN_BIRTHCAKE.SplitPickup, PickupVariant.PICKUP_COIN)

--[[ local BAG_OF_CRAFTING = KnifeVariant and KnifeVariant.BAG_OF_CRAFTING or 4
local CLUB_HITBOX = KnifeSubType and KnifeSubType.CLUB_HITBOX or 4

---@param knife EntityKnife
---@param collider Entity
function CAIN_BIRTHCAKE:AddPickup(knife, collider)
	local player = knife.SpawnerEntity and knife.SpawnerEntity:ToPlayer()
	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_CAIN_B)
		and knife.Variant == BAG_OF_CRAFTING
		and knife.SubType == CLUB_HITBOX
		and collider:ToPickup()
	then
		local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)
		local roll = rng:RandomFloat()
		local pickup = collider:ToPickup()
		---@cast pickup EntityPickup

		if roll <= 0.05 then
			local dupePickup = Isaac.Spawn(pickup.Type, pickup.Variant, pickup.SubType, player.Position, Vector.Zero,
				pickup.SpawnerEntity):ToPickup()
			---@cast dupePickup EntityPickup
			dupePickup:GetSprite():Play("Idle", true)
			dupePickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			dupePickup.Timeout = 1
			dupePickup.Visible = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, CAIN_BIRTHCAKE.AddPickup) ]]
