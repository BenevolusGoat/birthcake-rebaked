local mod = Birthcake
local game = Game()
local BlueBabyCake = {}
local count = 0

-- Functions

function BlueBabyCake:CheckBlueBaby(player)
    return player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY
end

function BlueBabyCake:CheckBlueBabyB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B
end

-- Blue Baby Birthcake

function BlueBabyCake:SpawnPoop(collectible,rng,player,useFlags,activeSlot,vardata)
    if not BlueBabyCake:CheckBlueBaby(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local chargeUsed = player:GetActiveCharge()
    if collectible == CollectibleType.COLLECTIBLE_NOTCHED_AXE then
        chargeUsed = 1
    end
    for i = 1, chargeUsed - 1 do
        local position = Vector(math.random(-25,25),math.random(-25,25))
        position = position + player.Position
        local variant = 10
        if player:HasTrinket(TrinketType.TRINKET_MECONIUM) then
            local roll = rng:RandomFloat()
            if roll < 0.33 then
                variant = 15
            end
        end
        if mod:GetTrinketMul(player) > 1 then
            local roll = rng:RandomFloat()
            if roll < 0.5 then
                variant = 1
            end
        end
        local roll = rng:RandomFloat()
        local chance = 0.1
        if mod:HasMomBox(player) then
            chance = 0.2
        end
        if roll < chance then
            variant = 12
        end
        Isaac.Spawn(EntityType.ENTITY_POOP, variant, 0, position, Vector(10, 10), player)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, BlueBabyCake.SpawnPoop)

-- Blue Baby B Birthcake

function BlueBabyCake:Poop()
    local player = game:GetPlayer(0)

    if not BlueBabyCake:CheckBlueBabyB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        local entity = entities[i]
        if entity.Type == EntityType.ENTITY_POOP and entity.SpawnerType == EntityType.ENTITY_PLAYER then
            if entity.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
            end
        elseif entity.Type == EntityType.ENTITY_PROJECTILE then
            for i = 1, #entities do
                local entity2 = entities[i]
                if entity == entity2 then
                    goto continue
                end
                if entity2.Type == EntityType.ENTITY_POOP and entity2.SpawnerType == EntityType.ENTITY_PLAYER then
                    if entity.Position:Distance(entity2.Position) < 30 and entity2:GetSprite():GetAnimation() ~= "State5" then
                        entity:Remove()
                    end
                end
                ::continue::
            end
        elseif entity:IsEnemy() then
            for i = 1, #entities do
                local entity2 = entities[i]
                if entity == entity2 then
                    goto continue
                end
                if entity2.Type == EntityType.ENTITY_POOP and entity2.SpawnerType == EntityType.ENTITY_PLAYER then
                    if entity.Position:Distance(entity2.Position) <= 30 and entity2:GetSprite():GetAnimation() ~= "State5" then
                        entity:AddSlowing(EntityRef(player), 1, 0.5, entity:GetColor())
                    end
                end
                ::continue::
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BlueBabyCake.Poop)
