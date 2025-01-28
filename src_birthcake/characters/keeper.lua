local Mod = BirthcakeRebaked
local game = Mod.Game

local KEEPER_CAKE = {}
BirthcakeRebaked.Birthcake.KEEPER = KEEPER_CAKE

local delayHorn

-- Keeper Birthcake

function KEEPER_CAKE:Nickel()
	local room = game:GetRoom()
	local roomType = room:GetType()
	local player = Mod:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_KEEPER)

	if player
		and room:IsFirstVisit()
		and (roomType == RoomType.ROOM_SHOP or roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_BLACK_MARKET)
	then
		for _ = 1, Mod:GetCombinedTrinketMult(PlayerType.PLAYER_KEEPER) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL,
				room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0), Vector.Zero, player)
		end
		delayHorn = true
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, KEEPER_CAKE.Nickel)

function KEEPER_CAKE:PlayPartyHorn()
	if delayHorn then
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		delayHorn = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, KEEPER_CAKE.PlayPartyHorn)

-- Tainted Keeper Birthcake

--TODO: Idea for mults. More shop items/pickups?

function KEEPER_CAKE:SpawnMiniShop()
	local room = game:GetRoom()
	local centerPos = room:GetCenterPos()
	local item = BirthcakeRebaked:SpawnFromPool(ItemPoolType.POOL_SHOP, centerPos + Vector(0, -60), -1)
	local pickup1 = BirthcakeRebaked:SpawnRandomPickup(centerPos + Vector(80, -40), -1)
	local pickup2 = BirthcakeRebaked:SpawnRandomPickup(centerPos + Vector(-80, -40), -1)
	Mod.SaveManager.GetRoomFloorSave(item).RerollSave.IsKeeperShop = true
	Mod.SaveManager.GetRoomFloorSave(pickup1).RerollSave.IsKeeperShop = true
	Mod.SaveManager.GetRoomFloorSave(pickup2).RerollSave.IsKeeperShop = true
end

function KEEPER_CAKE:FindKeeperB()
	if BirthcakeRebaked:AnyPlayerTypeHasBirthcake(PlayerType.PLAYER_KEEPER_B) then
		KEEPER_CAKE:SpawnMiniShop()
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, KEEPER_CAKE.FindKeeperB)

---@param pickup EntityPickup
function KEEPER_CAKE:UpdateShop(pickup)
	local room_save = Mod.SaveManager.TryGetRoomFloorSave(pickup)
	if not room_save
		or not room_save.RerollSave.IsKeeperShop
	then
		return
	end
	pickup.ShopItemId = -1
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, KEEPER_CAKE.UpdateShop)
