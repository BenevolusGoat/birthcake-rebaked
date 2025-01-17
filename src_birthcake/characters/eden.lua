local Mod = BirthcakeRebaked
local game = Mod.Game

local EDEN_CAKE = {}
BirthcakeRebaked.Birthcake.EDEN = EDEN_CAKE
EDEN_CAKE.HiddenItemGroup = "Eden Birthcake"

-- Eden Birthcake

---@param player EntityPlayer
---@param num integer
function EDEN_CAKE:AddBirthcakeTrinkets(player, num)
	local itemPool = Mod.Game:GetItemPool()
	local trinketList = {}
	for _ = 1, num do
		local trinketID = itemPool:GetTrinket()
		table.insert(trinketList, { TrinketType = trinketID, FirstTime = true })
	end
	Mod:AddSmeltedTrinkets(player, trinketList)
	Mod.SFXManager:Play(SoundEffect.SOUND_VAMP_GULP)
end

---@param player EntityPlayer
---@param trinketID TrinketType
---@param firstTime boolean
function EDEN_CAKE:OnAddBirthcake(player, firstTime)
	if firstTime then
		local count = 3
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
			count = count + 1
		end
		EDEN_CAKE:AddBirthcakeTrinkets(player, count)
		player:TryRemoveTrinket(Mod.Birthcake.ID)
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, EDEN_CAKE.OnAddBirthcake, PlayerType.PLAYER_EDEN)

-- Tainted Eden birthcake

---@param pickup EntityPickup
function EDEN_CAKE:Undecided(pickup)
	local player = Mod:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_EDEN_B)
	if player then
		local room_save = Mod.SaveManager:GetRoomFloorSave().RerollSave
		if not room_save.TryEdenBirthcakeReroll then
			room_save.TryEdenBirthcakeReroll = true
			local rng = player:GetTrinketRNG(Mod.Birthcake.ID)
			if rng:RandomFloat() < 0.5 then
				if rng:RandomFloat() < 0.5 then
					pickup:AddEntityFlags(EntityFlag.FLAG_GLITCH)
				else
					local itemID = Mod.Game:GetItemPool():GetCollectible(
						rng:RandomInt(ItemPoolType.NUM_ITEMPOOLS - 1) + 1, false, pickup.InitSeed,
						CollectibleType.COLLECTIBLE_GB_BUG)
					pickup:Morph(pickup.Type, pickup.Variant, itemID, true, true)
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, EDEN_CAKE.Undecided, PickupVariant.PICKUP_COLLECTIBLE)
