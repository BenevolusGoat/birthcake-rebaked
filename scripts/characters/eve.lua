local mod = Birthcake
local game = Game()
local EveCake = {}

-- Functions

function EveCake:CheckEve(player)
    return player:GetPlayerType() == PlayerType.PLAYER_EVE
end

function EveCake:CheckEveB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_EVE_B
end

-- Eve Birthcake

function EveCake:RemoveHeart(player,damage,flag,source,cdframe)
    player = player:ToPlayer()
    if not EveCake:CheckEve(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local hearts = player:GetHearts()
    local soulhearts = player:GetSoulHearts()
    local hearts = hearts - player:GetRottenHearts() * 2
    local bonehearts = player:GetBoneHearts()

    if soulhearts > 0 and bonehearts > 0 and mod:HasMomBox(player) then
        player:AddSoulHearts(-soulhearts)
        player:AddBoneHearts(-bonehearts)
        player:AddBoneHearts(bonehearts)
        player:AddSoulHearts(soulhearts)
    end

    if soulhearts > 0 and hearts > 0 then
        player:AddHearts(-damage)
        local remaining = damage - hearts
        if remaining < 0 then
            remaining = 0
        end
        Isaac.ConsoleOutput("Remaining: " .. remaining .. "\n")
        player:AddSoulHearts(damage - remaining)
        return nil
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EveCake.RemoveHeart, EntityType.ENTITY_PLAYER)

-- Tainted Eve Birthcake

function EveCake:Twice(Type,Variant,Subtype,position,velocity,spawner,seed)
    local player = game:GetPlayer(0)

    if not EveCake:CheckEveB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if Variant == FamiliarVariant.BLOOD_BABY and spawner ~= nil then
        local hearts = player:GetHearts()
        local soulhearts = player:GetSoulHearts()
        local blackhearts = player:GetBlackHearts()
        local goldhearts = player:GetGoldenHearts()
        local bonehearts = player:GetBoneHearts()
        local eternalhearts = player:GetEternalHearts()
        local rottenhearts = player:GetRottenHearts()
        if goldhearts > 0 then
            player:AddGoldenHearts(-1)
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 4, position, velocity, nil)
        elseif eternalhearts > 0 then
            player:AddEternalHearts(-1)
            Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 3, position, velocity, player)
        elseif rottenhearts >= 4 or soulhearts >= 2 or blackhearts >= 2 or hearts >= 2 or bonehearts >= 2 then
            if rottenhearts > 2 then
                player:AddRottenHearts(-2)
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 6, position, velocity, nil)
            elseif hearts > 0 then
                player:AddHearts(-1)
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 0, position, velocity, nil)
            elseif soulhearts > 0 then
                player:AddSoulHearts(-1)
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 1, position, velocity, nil)
            elseif blackhearts > 0 then
                player:AddBlackHearts(-1)
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 2, position, velocity, nil)
            elseif bonehearts > 0 then
                player:AddBoneHearts(-1)
                Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.BLOOD_BABY, 5, position, velocity, nil)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, EveCake.Twice)

function EveCake:ClotDeath(entity, dmg,flag,source,cdframe)
    local player = game:GetPlayer(0)

    if not EveCake:CheckEveB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if entity.Variant == FamiliarVariant.BLOOD_BABY and entity:IsDead() then 
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, Isaac.GetFreeNearPosition(entity.Position, 10), Vector(0,0), entity)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, EveCake.ClotDeath, EntityType.ENTITY_FAMILIAR)
