local mod = Birthcake
local game = Game()
local KeeperCake = {}
local gotReward = false
local Variants = {30,40,69,70,90,300}

-- functions

function KeeperCake:CheckKeeper(player)
    return player:GetPlayerType() == PlayerType.PLAYER_KEEPER
end

function KeeperCake:CheckKeeperB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_KEEPER_B
end

-- Keeper Birthcake

function KeeperCake:Nickel()
    local player = game:GetPlayer(0)
    local room = game:GetRoom()

    if room:GetFrameCount() == 0 then
        gotReward = false
    end

    if not KeeperCake:CheckKeeper(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if room:IsFirstVisit() then
        if (room:GetType() == RoomType.ROOM_SHOP or room:GetType() == RoomType.ROOM_DEVIL or room:GetType() == RoomType.ROOM_BLACK_MARKET) and gotReward == false then
            if mod:GetTrinketMul(player,true) > 1  then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player)
            else
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player)
            end
            gotReward = true
        else
            gotReward = false
        end
    else
        gotReward = false
    end


end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, KeeperCake.Nickel)

-- Tainted Keeper Birthcake

local function SpawnFromPool(pool,pos,price,seed)
    local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(pool,false), pos, Vector(0,0),nil):ToPickup()
    local itemConfig = Isaac.GetItemConfig():GetCollectible(item.SubType)
    Isaac.ConsoleOutput(itemConfig.ShopPrice .. "\n")
    if price == -1 then
        price = math.floor(itemConfig.ShopPrice / 2)
    end
    item.Price = price
    item.AutoUpdatePrice = false
    item.ShopItemId = -1
    return item
end

local function SpawnRandomPickup(pos,price,seed)
    local player = game:GetPlayer(0)
    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    local variant = Variants[rng:RandomInt(#Variants)+1]
    local SubType = 0
    if variant == 30 then
        SubType = 1
    elseif variant == 40 then
        SubType = 1
    elseif variant == 69 then
        SubType = rng:RandomInt(2)
    elseif variant == 70 then
        SubType = rng:RandomInt(PillColor.NUM_STANDARD_PILLS)
    elseif variant == 90 then
        SubType = 1
    elseif variant == 300 then
        SubType = rng:RandomInt(Card.NUM_CARDS)
    end
    local Pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, SubType, pos, Vector(0,0),nil):ToPickup()
    if price == -1 then
        price = 3
    end
    Pickup.Price = price
    Pickup.AutoUpdatePrice = false
    Pickup.ShopItemId = -1
    return Pickup
end

function KeeperCake:LocalShop()
    local player = game:GetPlayer(0)

    if not KeeperCake:CheckKeeperB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local room = game:GetRoom()
    local seed = game:GetSeeds():GetStartSeed()
    local centerPos = room:GetCenterPos()

    room:TurnGold()
    local item = SpawnFromPool(ItemPoolType.POOL_SHOP,centerPos+Vector(0,-60),-1,seed)
    local pickup1 = SpawnRandomPickup(centerPos+Vector(80,-40),-1,seed)
    local pickup2 = SpawnRandomPickup(centerPos+Vector(-80,-40),-1,seed)
    mod:GetData(item).IsKeeperShop = true
    mod:GetData(pickup1).IsKeeperShop = true
    mod:GetData(pickup2).IsKeeperShop = true
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, KeeperCake.LocalShop)

function KeeperCake:UpdateShop(entity)
    local IsKeeperShop = mod:GetData(entity).IsKeeperShop
    if not IsKeeperShop then
        return
    end
    entity.ShopItemId = -1
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, KeeperCake.UpdateShop)