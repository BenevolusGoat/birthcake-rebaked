local mod = Birthcake
local game = Game()
local TheForgottenCake = {}
local tempDmg = 0
local frameCounter = 0
local frequency = 20
local fly = nil

-- functions

function TheForgottenCake:CheckForgotten(player)
    return player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or player:GetPlayerType() == PlayerType.PLAYER_THESOUL
end

function TheForgottenCake:CheckForgottenB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B or player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B
end

-- The Forgotten Birthcake

function TheForgottenCake:Attack(entity, dmg, dmgFlag, dmgSource, dmgCountdownFrames)
    local player = Isaac.GetPlayer(0)

    if not TheForgottenCake:CheckForgotten(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN then
        return
    end

    if entity:IsEnemy() and dmgSource.Type == EntityType.ENTITY_PLAYER then
        local wisp = player:AddWisp(609,entity.Position)
        wisp = wisp:ToFamiliar()
        wisp.FireCooldown = 9999999999
        wisp.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        wisp.Target = player
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, TheForgottenCake.Attack)

function TheForgottenCake:Harmony()
    local player = Isaac.GetPlayer(0)

    if not TheForgottenCake:CheckForgotten(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if player:GetPlayerType() ~= PlayerType.PLAYER_THESOUL then
        tempDmg = 0
        return
    end

    local entities = Isaac.GetRoomEntities()

    local count = 0

    for i = 1, #entities do
        local entity = entities[i]
        if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.WISP and entity.SubType == 609 and entity.Target.Type == EntityType.ENTITY_PLAYER then
            entity:Remove()
            count = count + 1
        end
    end

    for i = 1, count do
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, player.Position, Vector(0,0), player)
        tempDmg = tempDmg + 1.5
        player.Damage = player.Damage + 1.5
    end

    if tempDmg > 0 then
        frameCounter = frameCounter + 1
        if frameCounter % frequency == 0 then
            tempDmg = tempDmg - .5
            player.Damage = player.Damage - .5
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, TheForgottenCake.Harmony)

-- Tainted Forgotten Birthcake

function TheForgottenCake:TheSoul()
    local player = Isaac.GetPlayer(0)
    local soul = player:GetOtherTwin()
    local entities = Isaac.GetRoomEntities()

    if not TheForgottenCake:CheckForgottenB(player) then
        return
    end

    local count = 0

    if not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) and not soul:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        for i = 1, #entities do
            local entity = entities[i]
            if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.FLY_ORBITAL then
                entity:Remove()
            end
        end
        fly = nil
        return
    else
        for i = 1, #entities do
            local entity = entities[i]
            if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.FLY_ORBITAL then
                count = count + 1
            end
        end
        if count < 3 then
            fly = nil
        end
    end

    if fly == nil then
        if count == 2 then
            fly = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.FLY_ORBITAL , 0, player.Position, Vector(0,0), player)
            fly.Target = player
        end
        if count == 0 then
            for i = 1, 2 do
                local ent = Isaac.Spawn(EntityType.ENTITY_FAMILIAR,FamiliarVariant.FLY_ORBITAL , 0, soul.Position, Vector(0,0), soul)
                ent.Target = soul
            end
        end
    end

    for i = 1, #entities do
        local entity = entities[i]
        if entity.Type ~= EntityType.ENTITY_PLAYER and entity:IsEnemy() then
            if entity.Target then
                local distance = entity.Position:Distance(soul.Position)
                if distance <= 150 and entity.Target.Type == fly.Type and entity.Target.Variant == fly.Variant then
                    Isaac.ConsoleOutput(tostring(distance).." ")
                    entity.Target = soul
                elseif entity.Target.Type == soul.Type and distance > 150 then
                    entity.Target = fly
                end
            else
                entity.Target = fly
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, TheForgottenCake.TheSoul)

-- Cannot be implemtend