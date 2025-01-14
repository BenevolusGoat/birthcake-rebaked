local Mod = BirthcakeRebaked
local game = Mod.Game

local EDEN_CAKE = {}
BirthcakeRebaked.Birthcake.EDEN = EDEN_CAKE
EDEN_CAKE.HiddenItemGroup = "Eden Birthcake"

-- Eden Birthcake

--TODO: Revisit

function EDEN_CAKE:TrySpawnBirthcakeWisp(player)
	if player:HasTrinket(Mod.Birthcake.ID) then
		local hidden_item_manager = Mod.HiddenItemManager
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EDEN_CAKE.TrySpawnBirthcakeWisp, PlayerType.PLAYER_EDEN)

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
