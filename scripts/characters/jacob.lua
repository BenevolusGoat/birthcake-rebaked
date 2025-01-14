local mod = Birthcake
local game = Game()
local JacobCake = {}
local BirthcakeUsed = false

-- functions

function JacobCake:CheckJacob(player)
    return player:GetPlayerType() == PlayerType.PLAYER_JACOB or player:GetPlayerType() == PlayerType.PLAYER_ESAU
end

function JacobCake:CheckJacobB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_JACOB_B
end

-- Jacob Birthcake

local function tearsUpAdd(firedelay, val)
    local currentTears = 30 / (firedelay + 1)
    local newTears = currentTears + val
    return math.max((30 / newTears) - 1, -0.99)
end


function JacobCake:Share(player,flag)
    if not JacobCake:CheckJacob(player) then
        return
    end

    local otherTwin = player:GetOtherTwin()
    local playerType = player:GetPlayerType()

    if player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + (otherTwin.Damage) * 0.25
        end
        if flag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed + (otherTwin.ShotSpeed) * 0.25
        end
        if flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (otherTwin.MoveSpeed) * 0.25
        end
        if flag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange + (otherTwin.TearRange) * 0.25
        end
        if flag == CacheFlag.CACHE_FIREDELAY then
            local value = (30 / otherTwin.MaxFireDelay ) * 0.25
            player.MaxFireDelay = tearsUpAdd(player.MaxFireDelay, value)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JacobCake.Share)

-- Tainted Jacob 

function JacobCake:NewFloor()
    BirthcakeUsed = false
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, JacobCake.NewFloor)

function JacobCake:Live(player,dmg,flag,source,cdframes)
    player = player:ToPlayer()
    if not JacobCake:CheckJacobB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if source.Type == EntityType.ENTITY_DARK_ESAU then
        if mod:GetTrinketMul(player) > 1 then
            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            local roll = rng:RandomFloat()
            if roll < 0.5 then
                player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
                player:AddTrinket(TrinketType.TRINKET_BIRTHCAKE)
            end
        else
            player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
        end
        BirthcakeUsed = true
        player:SetMinDamageCooldown(cdframes)
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JacobCake.Live, EntityType.ENTITY_PLAYER)

function JacobCake:EsauTarget()
    local entities = Isaac.GetRoomEntities()

    if not BirthcakeUsed then
        return
    end

    for i = 1, #entities do
        local entity = entities[i]
        if entity.Type == EntityType.ENTITY_DARK_ESAU and entity.Target and entity.Target.Type == EntityType.ENTITY_PLAYER then
            for j = 1, #entities do
                local entity2 = entities[j]
                if entity2.Type ~= EntityType.ENTITY_PLAYER and entity2:IsEnemy() and entity2.Type ~= EntityType.ENTITY_DARK_ESAU then
                    entity.Target = entity2
                end
            end
        elseif entity.Type == EntityType.ENTITY_DARK_ESAU and not entity.Target then
            for j = 1, #entities do
                local entity2 = entities[j]
                if entity2.Type ~= EntityType.ENTITY_PLAYER and entity2:IsEnemy() and entity2.Type ~= EntityType.ENTITY_DARK_ESAU then
                    entity.Target = entity2
                end
            end
        end
    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, JacobCake.EsauTarget)

function JacobCake:AnimaSolaTarget(collectibleID, rngObj, player, useFlags, activeSlot, varData)
    local entities = Isaac.GetRoomEntities()
    local nearest = nil

    if not BirthcakeUsed then
        return nil
    end

    for i = 1, #entities do
        local entity = entities[i]
        if entity.Type ~= EntityType.ENTITY_DARK_ESAU and entity.Type ~= EntityType.ENTITY_PLAYER and entity:IsEnemy() then
            if nearest == nil then
                nearest = entity
            else
                if entity.Position:DistanceSquared(player.Position) < nearest.Position:DistanceSquared(player.Position) then
                    nearest = entity
                end
            end
        end
    end
    player:AnimateCollectible(CollectibleType.COLLECTIBLE_ANIMA_SOLA, "UseItem", "PlayerPickupSparkle")
    local chain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ANIMA_CHAIN, 0,nearest.Position , Vector(0,0), player)
    chain.Target = nearest
    chain = chain:ToEffect()
    chain.Timeout = 146
    return true
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, JacobCake.AnimaSolaTarget, CollectibleType.COLLECTIBLE_ANIMA_SOLA)

-- function JacobCake:Test()
--     local player = Isaac.GetPlayer(0)
--     local roomCenter = game:GetRoom():GetCenterPos()

--     local entities = Isaac.GetRoomEntities()
--     for i = 1, #entities do
--         local entity = entities[i]
--         if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.ANIMA_CHAIN then
--             entity = entity:ToEffect()
--             Isaac.ConsoleOutput(entity.Timeout .. "\n")
--         end
--     end

--     if BirthcakeUsed then
--         return
--     end

--     BirthcakeUsed = true

--     local chain = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ANIMA_CHAIN, 0,player.Position , Vector(0,0), player)
--     chain.Target = player
--     chain = chain:ToEffect()
--     chain.Timeout = 146
-- end

-- mod:AddCallback(ModCallbacks.MC_POST_RENDER, JacobCake.Test)

