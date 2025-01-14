local mod = Birthcake
local game = Game()
local SamsonCake = {}
local bloodyLustStack = 0
local gotReward = false

-- functions

function SamsonCake:CheckSamson(player)
    return player:GetPlayerType() == PlayerType.PLAYER_SAMSON
end

function SamsonCake:CheckSamsonB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_SAMSON_B
end

-- Samson Birthcake

function SamsonCake:ResetLust()
    bloodyLustStack = 0
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SamsonCake.ResetLust)

function SamsonCake:BloodLust()
    bloodyLustStack = bloodyLustStack + 1
    local player = game:GetPlayer(0)

    if not SamsonCake:CheckSamson(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if bloodyLustStack == 6 then
        for i = 1, 2 do
            local variant = HeartSubType.HEART_FULL
            if mod:GetTrinketMul(player,true) > 1  then
                local health = player:GetHearts() + (i - 1) * 2
                local maxHealth = player:GetEffectiveMaxHearts()
                if health >= maxHealth then
                    variant = HeartSubType.HEART_SOUL
                elseif health <= maxHealth / 2 + 1 then
                    variant = HeartSubType.HEART_DOUBLEPACK
                end
            end
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, variant, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player)
        end
    elseif bloodyLustStack == 10 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        for i = 1, 2 do
            local variant = HeartSubType.HEART_FULL
            if mod:GetTrinketMul(player,true) > 1  then
                local health = player:GetHearts() + (i - 1) * 2
                local maxHealth = player:GetEffectiveMaxHearts()
                if health >= maxHealth then
                    variant = HeartSubType.HEART_SOUL
                elseif health <= maxHealth / 2 + 1 then
                    variant = HeartSubType.HEART_DOUBLEPACK
                end
            end
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, variant, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, SamsonCake.BloodLust, EntityType.ENTITY_PLAYER)

-- Tainted Samson Birthcake

function SamsonCake:NewRoom()
    local room = game:GetRoom()
    if room:IsFirstVisit() then
        gotReward = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SamsonCake.NewRoom)

function SamsonCake:Drop()
    local player = game:GetPlayer(0)

    if not SamsonCake:CheckSamsonB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local playerEffects = player:GetEffects()

    if not playerEffects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK) then
        return
    end

    local room = game:GetRoom()

    if room:IsClear() and room:IsFirstVisit() and not gotReward then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        local roll = rng:RandomFloat()
        if roll < 0.25 then
            SFXManager():Play(SoundEffect.SOUND_PARTY_HORN, 1, 0, false, 1)
            local variant = rng:RandomInt(12)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, variant, Isaac.GetFreeNearPosition(player.Position, 10), Vector(0,0), player)
            playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_BERSERK,true,1)
        end
        gotReward = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, SamsonCake.Drop)