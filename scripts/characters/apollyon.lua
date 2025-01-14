local mod = Birthcake
local game = Game()
local ApollyonCake = {}
local VoidConsumedTrinkets = {}
local hasVoid = true

-- functions

function ApollyonCake:CheckApollyon(player)
    return player:GetPlayerType() == PlayerType.PLAYER_APOLLYON
end

function ApollyonCake:CheckApollyonB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_APOLLYON_B
end

-- Apollyon Birthcake

function ApollyonCake:NewGame()
    VoidConsumedTrinkets = {}
    hasVoid = true
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, ApollyonCake.NewGame)

function ApollyonCake:TrinketConsumer(collectible,rng,player,useFlags,activeSlot,vardata)
    if not ApollyonCake:CheckApollyon(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local room = game:GetRoom()
    local entities = room:GetEntities()
    player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
    for i = 0, #entities-1 do
        local entity = entities:Get(i)
        if entity then
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TRINKET then
                local trinket = entity.SubType
                table.insert(VoidConsumedTrinkets,trinket)
                entity:Remove()
                player:AddTrinket(trinket)
                player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, false)
                if player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
                    player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
                end
            end
        end
    end
    player:AddTrinket(TrinketType.TRINKET_BIRTHCAKE)
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ApollyonCake.TrinketConsumer, CollectibleType.COLLECTIBLE_VOID)

function ApollyonCake:TrinketUpdate()
    local player = game:GetPlayer(0)
    if not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
        for i = 1, #VoidConsumedTrinkets do
            player:TryRemoveTrinket(VoidConsumedTrinkets[i])
        end
        hasVoid = false
    end
    if not ApollyonCake:CheckApollyon(player) then
        return
    end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) and not hasVoid then
        hasVoid = true
        local hadCake = player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
        for i = 1, #VoidConsumedTrinkets do
            player:AddTrinket(VoidConsumedTrinkets[i])
            player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, false, false, false, false)
            if player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
                hadCake = player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
            end
        end
        if hadCake then
            player:AddTrinket(TrinketType.TRINKET_BIRTHCAKE)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, ApollyonCake.TrinketUpdate)

-- Apollyon B Birthcake

function ApollyonCake:TaintedTrinketConsumer(collectible,rng,player,useFlags,activeSlot,vardata)
    if not ApollyonCake:CheckApollyonB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local room = game:GetRoom()
    local entities = room:GetEntities()
    for i = 0, #entities-1 do
        local entity = entities:Get(i)
        if entity then
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TRINKET then
                local trinket = entity.SubType
                entity:Remove()
                local locust = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, 10, entity.Position, Vector(0,0), player)
                Isaac.ConsoleOutput(tostring(locust.CollisionDamage))
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, ApollyonCake.TaintedTrinketConsumer, CollectibleType.COLLECTIBLE_ABYSS)

function ApollyonCake:Test()
    local room = game:GetRoom()
    local entities = room:GetEntities()
    for i = 0, #entities-1 do
        if entities:Get(i).Type == EntityType.ENTITY_FAMILIAR and entities:Get(i).Variant == FamiliarVariant.ABYSS_LOCUST then
            Isaac.ConsoleOutput("Familiar: " .. tostring(entities:Get(i).CollisionDamage) .. "\n")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, ApollyonCake.Test)
