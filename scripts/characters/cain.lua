local Mod = BirthcakeRebaked
local game = Mod.Game

local CAIN_BIRTHCAKE = {}
BirthcakeRebaked.Characters.CAIN = CAIN_BIRTHCAKE

-- Cain Birthcake

---@param player EntityPlayer
function CAIN_BIRTHCAKE:CainPickup(player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_CAIN) then
		player.Luck = player.Luck + 1
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CAIN_BIRTHCAKE.CainPickup, CacheFlag.CACHE_LUCK)

local SLOT_MACHINE = SlotVariant and SlotVariant.SLOT_MACHINE or 1
local FORTUNE_TELLER = SlotVariant and SlotVariant.FORTUNE_TELLING_MACHINE or 3
local CRANE_GAME = SlotVariant and SlotVariant.CRANE_GAME or 16

CAIN_BIRTHCAKE.RefundChance = {
	[SLOT_MACHINE] = 0.33,
	[FORTUNE_TELLER] = 0.33,
	[CRANE_GAME] = 0.25,
}

CAIN_BIRTHCAKE.RefundReward = {
	[SLOT_MACHINE] = 1,
	[FORTUNE_TELLER] = 1,
	[CRANE_GAME] = 5
}

function CAIN_BIRTHCAKE:MachineInteraction(player, ent, low)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_CAIN)
		and ent.Type == EntityType.ENTITY_SLOT
	then
		local data = Mod:GetData(ent)
		data.TouchedPlayer = player
	end
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CallbackPriority.EARLY, CAIN_BIRTHCAKE.MachineInteraction, 0)

function CAIN_BIRTHCAKE:OnSlotInitiate(slot)
	local data = Mod:GetData(slot)
	local sprite = slot:GetSprite()

	if data.TouchedPlayer and not data.WaitAfterInitiate then
		if slot:IsPlaying("Initiate") then
			local player = data.TouchedPlayer
			local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			local roll = rng:RandomFloat()
			local baseChance = CAIN_BIRTHCAKE.RefundChance[slot.Variant]
			local trinketMult = 0.3 * (Mod:GetTrinketMult(player) - 1)
			local chance = baseChance * (1.3 + trinketMult)

			if roll < chance then
				player:AddCoins(CAIN_BIRTHCAKE.RefundReward[slot.Variant])
				player:AnimateHappy()
			end
			data.WaitAfterInitiate = true
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

---@param entType EntityType
---@param variant integer
---@param subType integer
---@param position Vector
---@param velocity Vector
---@param spawner Entity?
---@param seed integer
function CAIN_BIRTHCAKE:SplitPickup(entType, variant, subType, position, velocity, spawner, seed)
	if Mod:AnyPlayerTypeHasBirthcake(PlayerType.PLAYER_CAIN_B)
		and entType == EntityType.ENTITY_PICKUP
	then
		local splitSubType = CAIN_BIRTHCAKE.DoublePickupToSingle[variant] and CAIN_BIRTHCAKE.DoublePickupToSingle[variant][subType]
		if splitSubType then
			Isaac.Spawn(entType, variant, splitSubType, Isaac.GetFreeNearPosition(position + Vector(15, 0), 0), velocity, spawner )
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CLEAVER_SLASH, 0, position, Vector.Zero, nil)
			Mod.SFXManager:Play(SoundEffect.SOUND_KNIFE_PULL)
			return { entType, variant, splitSubType, Isaac.GetFreeNearPosition(position - Vector(15, 0), 0), seed}
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, CAIN_BIRTHCAKE.SplitPickup)

local BAG_OF_CRAFTING = KnifeVariant and KnifeVariant.BAG_OF_CRAFTING or 4
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
			local dupePickup = Isaac.Spawn(pickup.Type, pickup.Variant, pickup.SubType, player.Position, Vector.Zero, pickup.SpawnerEntity):ToPickup()
			---@cast dupePickup EntityPickup
			dupePickup:GetSprite():Play("Idle", true)
			dupePickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
			dupePickup.Timeout = 1
			dupePickup.Visible = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_KNIFE_COLLISION, CAIN_BIRTHCAKE.AddPickup)
