local mod = Birthcake
local game = Game()
local LazarusCake = {}
local LazarusItem = {}
local DeadLazarusItem = {}
local SharedItem = -1
local dead = false
local lazarusRisen = false
local upgraded = false


-- functions

function LazarusCake:CheckLazarus(player)
    return player:GetPlayerType() == PlayerType.PLAYER_LAZARUS or player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2
end

function LazarusCake:CheckLazarusB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B or player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B
end

-- Lazarus Birthcake

function LazarusCake:DeathBringer(player,dmg)
    player = player:ToPlayer()

    if not LazarusCake:CheckLazarus(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local health = player:GetHearts() - dmg
    if health <= 0 and player:WillPlayerRevive() then
        dead = true
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, LazarusCake.DeathBringer, EntityType.ENTITY_PLAYER)

function LazarusCake:AliveMonger()
    local player = game:GetPlayer(0)

    if not LazarusCake:CheckLazarus(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local health = player:GetHearts()

    if health > 0 and dead then
        if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
            lazarusRisen = true
        end
        dead = false
        local entites = Isaac.GetRoomEntities()
        for i = 1, #entites do
            local entity = entites[i]
            if entity.Type ~= EntityType.ENTITY_PLAYER and entity.Type ~= EntityType.ENTITY_PICKUP and entity.Type ~= EntityType.ENTITY_POOP and entity.Type ~= EntityType.ENTITY_BOMBDROP and entity.Type ~= EntityType.ENTITY_EFFECT then
                local damage = 40 * player:GetTrinketMultiplier(TrinketType.TRINKET_BIRTHCAKE)
                entity:TakeDamage(damage,0,EntityRef(player),0)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 2, entity.Position, Vector(0,0), entity):SetColor(Color(1,1,1),5,5,false,false)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector(0,0), entity):SetColor(Color(1,1,1),5,5,false,false)
                SFXManager():Play(SoundEffect.SOUND_DEATH_CARD)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, LazarusCake.AliveMonger)

function LazarusCake:NoPenalty()
    local player = game:GetPlayer(0)

    if not LazarusCake:CheckLazarus(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if lazarusRisen then
        lazarusRisen = false
        player:AddMaxHearts(2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, LazarusCake.NoPenalty)

-- Tainted Lazarus Birthcake

function LazarusCake:NewGame()
    LazarusItem = {}
    DeadLazarusItem = {}
    SharedItem = -1
    dead = false
    lazarusRisen = false
    upgraded = false
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, LazarusCake.NewGame)

function LazarusCake:UpdateItems()
    local player = game:GetPlayer(0)

    if not LazarusCake:CheckLazarusB(player) then
        return
    end

    if not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        if SharedItem ~= -1 then
            player:GetEffects():RemoveCollectibleEffect(SharedItem)
            SharedItem = -1
        end
    end

    if player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then 
        if mod:GetTrinketMul(player,true) > 1 then
            upgraded = true
        else
            upgraded = false
        end
    end

    local ItemCount = Isaac:GetItemConfig():GetCollectibles().Size -1
    for i = 1, ItemCount do
        local itemConfig = Isaac.GetItemConfig():GetCollectible(i)
        if player:HasCollectible(i,true) and (itemConfig.Type == ItemType.ITEM_PASSIVE or itemConfig.Type == ItemType.ITEM_FAMILIAR) and not itemConfig:HasTags(ItemConfig.TAG_LAZ_SHARED) and not itemConfig:HasTags(ItemConfig.TAG_LAZ_SHARED_GLOBAL) then
            if upgraded and itemConfig.Quality == 0 then
                goto continue
            end
            local playerType = player:GetPlayerType()
            if playerType == PlayerType.PLAYER_LAZARUS_B and not mod:IsInList(i,LazarusItem) then
                table.insert(LazarusItem, i)
            elseif playerType == PlayerType.PLAYER_LAZARUS2_B and not mod:IsInList(i,DeadLazarusItem) then
                table.insert(DeadLazarusItem, i)
            end
        end
        ::continue::
    end
    local playerType = player:GetPlayerType()
    for i = 1, #LazarusItem do
        if not player:HasCollectible(LazarusItem[i],true) and playerType == PlayerType.PLAYER_LAZARUS_B then
            table.remove(LazarusItem, i)
        end
        local itemConfig = Isaac.GetItemConfig():GetCollectible(LazarusItem[i])
        if upgraded and itemConfig.Quality == 0 then
            table.remove(LazarusItem, i)
        end
    end
    for i = 1, #DeadLazarusItem do
        if not player:HasCollectible(DeadLazarusItem[i],true) and playerType == PlayerType.PLAYER_LAZARUS2_B  then
            table.remove(DeadLazarusItem, i)
        end
        local itemConfig = Isaac.GetItemConfig():GetCollectible(DeadLazarusItem[i])
        if upgraded and itemConfig.Quality == 0 then
            table.remove(DeadLazarusItem, i)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, LazarusCake.UpdateItems)

function LazarusCake:Gift()
    local player = game:GetPlayer(0)
    if not LazarusCake:CheckLazarusB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    if SharedItem ~= -1 then
        player:GetEffects():RemoveCollectibleEffect(SharedItem)
        SharedItem = -1
    end

    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    local playerType = player:GetPlayerType()
    if playerType == PlayerType.PLAYER_LAZARUS_B then
        if #DeadLazarusItem > 0 then
            SharedItem = DeadLazarusItem[rng:RandomInt(#DeadLazarusItem)+1]
        end
    elseif playerType == PlayerType.PLAYER_LAZARUS2_B then
        if #LazarusItem > 0 then
            SharedItem = LazarusItem[rng:RandomInt(#LazarusItem)+1]
        end
    end

    Isaac.ConsoleOutput("Shared Item: " .. tostring(SharedItem).."\n")
    if SharedItem ~= -1 then
        player:GetEffects():AddCollectibleEffect(SharedItem)
    end

end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, LazarusCake.Gift)
