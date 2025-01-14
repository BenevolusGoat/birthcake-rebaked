local mod = Birthcake
local game = Game()
local MagdaleneCake = {}
local ReplaceChance = 0.50

-- functions

function MagdaleneCake:CheckMagdalene(player)
    return player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE
end

function MagdaleneCake:CheckMagdaleneB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE_B
end

-- Magdalene Birthcake

function MagdaleneCake:SoulRefill(collectibleType,rng,player,useFlags, activeSlot, varData)
    if not MagdaleneCake:CheckMagdalene(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local soul = 1
    if mod:HasMomBox(player) then
        soul = 2
    end
    player:AddSoulHearts(soul)
    return nil
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, MagdaleneCake.SoulRefill, CollectibleType.COLLECTIBLE_YUM_HEART)


function MagdaleneCake:HeartReplace(Entity,Variant,Subtype,position,velocity,spawner,seed)
    local player = game:GetPlayer(0)
    if not MagdaleneCake:CheckMagdalene(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if Entity == EntityType.ENTITY_PICKUP then
        if Variant == PickupVariant.PICKUP_HEART then
            if Subtype == HeartSubType.HEART_FULL then
                local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                local roll = rng:RandomFloat()
                if roll < ReplaceChance then
                    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, seed}
                end
            end

            if Subtype == HeartSubType.HEART_HALF then
                local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
                local roll = rng:RandomFloat()
                if roll < ReplaceChance then
                    return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, seed}
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, MagdaleneCake.HeartReplace)

-- Tainted Magdalene Birthcake

function MagdaleneCake:HeartInit(entity)
    if mod:GetData(entity).isTemporary == nil then
        mod:GetData(entity).isTemporary = false
    end

    if mod:GetData(entity).defuse == nil then
        mod:GetData(entity).defuse = false
    end


    if entity.Timeout ~= -1 then
        mod:GetData(entity).isTemporary = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, MagdaleneCake.HeartInit,PickupVariant.PICKUP_HEART)

function MagdaleneCake:HeartExplode(entity)
    local player = game:GetPlayer(0)
    if not MagdaleneCake:CheckMagdaleneB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if entity.Type == EntityType.ENTITY_PICKUP then
        if entity.Variant == PickupVariant.PICKUP_HEART and mod:GetData(entity).isTemporary == true and mod:GetData(entity).defuse ~= true then
            entity:BloodExplode()
            game:BombExplosionEffects(entity.Position, player.Damage * 0.5,TearFlags.TEAR_BLOOD_BOMB,Color.Default,nil,0.5,true,false,DamageFlag.DAMAGE_EXPLOSION)
            for i = 1,10 do
                local position = Vector(math.random(-25,25),math.random(-25,25))
                position = position + entity.Position
                local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, position , Vector(0,0), entity)
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, position, Vector(0,0), entity)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, MagdaleneCake.HeartExplode)

function MagdaleneCake:test(pickup,collider,low)
    if pickup.Variant == PickupVariant.PICKUP_HEART and collider.Type == EntityType.ENTITY_PLAYER then
        if mod:GetData(pickup).isTemporary == true then
            mod:GetData(pickup).defuse = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, MagdaleneCake.test, PickupVariant.PICKUP_HEART)