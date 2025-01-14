local mod = Birthcake
local game = Game()
local CainBirthcake = {}

-- Functions

function CainBirthcake:CheckCain(player)
    return player:GetPlayerType() == PlayerType.PLAYER_CAIN
end

function CainBirthcake:CheckCainB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_CAIN_B
end

-- Cain Birthcake

function CainBirthcake:CainPickup(player,flag)
    if not CainBirthcake:CheckCain(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if flag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck + 1
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CainBirthcake.CainPickup, CacheFlag.CACHE_LUCK)

function CainBirthcake:MachineInteraction(player,entity,low)
    if not CainBirthcake:CheckCain(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if entity.Type == EntityType.ENTITY_SLOT then
        local sprite = entity:GetSprite()
        Isaac.ConsoleOutput(sprite:GetAnimation().."\n")
        if sprite:GetAnimation() == "Idle" or sprite:GetAnimation() == "Prize" then
            mod:GetData(entity).isIdle = true
        end
        if sprite:GetAnimation() == "Initiate" and mod:GetData(entity).isIdle then
            mod:GetData(entity).isIdle = false
            local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
            local roll = rng:RandomFloat()
            if entity.Variant == 16 then
                local chance = 0.25
                if mod:GetTrinketMul(player,true) > 1  then
                    chance = 0.33
                end
                if roll < chance then
                    player:AddCoins(5)
                    player:AnimateHappy()
                end
            elseif entity.Variant == 1 or entity.Variant == 3 then
                local chance = 0.33
                if mod:GetTrinketMul(player,true) > 1  then
                    chance = 0.5
                end
                if roll < chance then
                    player:AddCoins(1)
                    player:AnimateHappy()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, CainBirthcake.MachineInteraction)

-- Tainted Cain Birthcake

function CainBirthcake:SplitPickup(Entity,Variant,Subtype,position,velocity,spawner,seed)
    local player = game:GetPlayer(0)
    if not CainBirthcake:CheckCainB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if Entity == EntityType.ENTITY_PICKUP then
        if Variant == PickupVariant.PICKUP_BOMB and Subtype == BombSubType.BOMB_DOUBLEPACK then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, Isaac.GetFreeNearPosition(position, 1), Vector(0,0), spawner)
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, seed}
        end

        if Variant == PickupVariant.PICKUP_COIN and Subtype == CoinSubType.COIN_DOUBLEPACK then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, Isaac.GetFreeNearPosition(position, 1), Vector(0,0), spawner)
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, seed}
        end

        if Variant == PickupVariant.PICKUP_KEY and Subtype == KeySubType.KEY_DOUBLEPACK then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, Isaac.GetFreeNearPosition(position, 1), Vector(0,0), spawner)
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, seed}
        end

        if Variant == PickupVariant.PICKUP_HEART and Subtype == HeartSubType.HEART_DOUBLEPACK then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, Isaac.GetFreeNearPosition(position, 1), Vector(0,0), spawner)
            return {EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, seed}
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, CainBirthcake.SplitPickup)

function CainBirthcake:UsingBag(entity)
    local entitySprite = entity:GetSprite()
    local player = game:GetPlayer(0)

    if entitySprite:GetAnimation() == "Swing" then
        mod:GetData(player).isBagOfCraftingActive = true
    elseif entitySprite:GetAnimation() == "Idle" then
        mod:GetData(player).isBagOfCraftingActive = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, CainBirthcake.UsingBag)

function CainBirthcake:AddPickup(entity)
    local player = game:GetPlayer(0)
    if not CainBirthcake:CheckCainB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local entitySprite = entity:GetSprite()

    if entitySprite:GetAnimation() ~= "Collect" then
        return
    end

    if entity.Type == EntityType.ENTITY_PICKUP and mod:GetData(player).isBagOfCraftingActive then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING)
        local roll = rng:RandomFloat()

        if roll >= 0.05 then
            return
        end

        if entity.Variant == PickupVariant.PICKUP_BOMB then
            local count = 0
            if entity.SubType == BombSubType.BOMB_NORMAL then
                count = 1
            elseif entity.SubType == BombSubType.BOMB_DOUBLEPACK then
                count = 2
            elseif entity.SubType == BombSubType.BOMB_GOLDEN then
                player:AddGoldenBomb()
                count = -1
            elseif entity.SubType == BombSubType.BOMB_GIGA then
                player:AddGigaBombs(1)
                count = -1
            end
            
            if count > 0 then
                player:AddBombs(count)
            end
        end

        if entity.Variant == PickupVariant.PICKUP_COIN then
            local count = 0
            if entity.SubType == CoinSubType.COIN_PENNY then
                count = 1
            elseif entity.SubType == CoinSubType.COIN_LUCKYPENNY then
                count = 1
                player.Luck = player.Luck + 1
            elseif entity.SubType == CoinSubType.COIN_DOUBLEPACK then
                count = 2
            elseif entity.SubType == CoinSubType.COIN_NICKEL then
                count = 5
            elseif entity.SubType == CoinSubType.COIN_STICKYNICKEL then
                count = 5
            elseif entity.SubType == CoinSubType.COIN_DIME then
                count = 10
            elseif entity.SubType == CoinSubType.COIN_GOLDEN then
                count = 1
                local room = game:GetRoom()
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_GOLDEN, room:GetRandomPosition(0), Vector(0,0), entity)
            end

            if count > 0 then
                player:AddCoins(count)
            end
        end

        if entity.Variant == PickupVariant.PICKUP_KEY then
            local count = 0
            if entity.SubType == KeySubType.KEY_NORMAL then
                count = 1
            elseif entity.SubType == KeySubType.KEY_DOUBLEPACK then
                count = 2
            elseif entity.SubType == KeySubType.KEY_GOLDEN then
                count = -1
                player:AddGoldenKey()
            elseif entity.SubType == KeySubType.KEY_CHARGED then
                count = 1
                player:FullCharge()
            end

            if count > 0 then
                player:AddKeys(count)
            end
        end

        if entity.Variant == PickupVariant.PICKUP_HEART then
            local count = 0
            if entity.SubType == HeartSubType.HEART_FULL then
                count = 2
            elseif entity.SubType == HeartSubType.HEART_DOUBLEPACK then
                count = 4
            elseif entity.SubType == HeartSubType.HEART_HALF then
                count = 1
            elseif entity.SubType == HeartSubType.HEART_SOUL then
                count = -1
                player:AddSoulHearts(2)
            elseif entity.SubType == HeartSubType.HEART_HALF_SOUL then
                count = -1
                player:AddSoulHearts(1)
            elseif entity.SubType == HeartSubType.HEART_BLACK then
                count = -1
                player:AddBlackHearts(2)
            elseif entity.SubType == HeartSubType.HEART_SCARED then
                count = 2
            elseif entity.SubType == HeartSubType.HEART_BLENDED then
                if player:GetHearts() == player:GetEffectiveMaxHearts() - 1 then
                    count = 1
                    player:AddSoulHearts(1)
                elseif player:GetHearts() < player:GetEffectiveMaxHearts() then
                    count = 2
                else
                    count = -1
                    player:AddSoulHearts(2)
                end
            elseif entity.SubType == HeartSubType.HEART_ETERNAL then
                count = -1
                player:AddEternalHearts(1)
            elseif entity.SubType == HeartSubType.HEART_ROTTEN then
                count = -1
                player:AddRottenHearts(2)
            elseif entity.SubType == HeartSubType.HEART_BONE then
                count = -1
                player:AddBoneHearts(1)
            elseif entity.SubType == HeartSubType.HEART_GOLDEN then
                count = -1
                player:AddGoldenHearts(1)
            end

            if count > 0 then
                player:AddHearts(count)
            end
        end

        if entity.Variant == PickupVariant.PICKUP_LIL_BATTERY then
            local count = 0
            if entity.SubType == BatterySubType.BATTERY_NORMAL then
                count = 6
            elseif entity.SubType == BatterySubType.BATTERY_MICRO then
                count = 2
            elseif entity.SubType == BatterySubType.BATTERY_MEGA then
                count = -1
                player:FullCharge()
                player:FullCharge()
            elseif entity.SubType == BatterySubType.BATTERY_GOLDEN then
                player:TakeDamage(2, DamageFlag.DAMAGE_CURSED_DOOR, EntityRef(player), 0)
                player:FullCharge()
            end

            if count > 0 then
                player:SetActiveCharge(player:GetActiveCharge() + count)
            end
        end

        if entity.Variant == PickupVariant.PICKUP_PILL then
            player:AddPill(entity.SubType)
        end

        if entity.Variant == PickupVariant.PICKUP_TAROTCARD then
            player:AddCard(entity.SubType)
        end

        mod:GetData(player).isBagOfCraftingActive = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, CainBirthcake.AddPickup)