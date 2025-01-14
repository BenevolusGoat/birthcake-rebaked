local mod = Birthcake
local game = Game()
local LillithCake = {}
local isIncubus = true
local replaceChance = 0
local familiarId = {278,113,360,270,275,417,679,698}

-- Functions

function LillithCake:CheckLillith(player)
    return player:GetPlayerType() == PlayerType.PLAYER_LILITH
end

function LillithCake:CheckLillithB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_LILITH_B
end

-- Lillith Birthcake

function LillithCake:EffectShare(Tear)
    local player = game:GetPlayer(0)

    if not LillithCake:CheckLillith(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if Tear.FrameCount ~= 1 then
        return
    end

    if Tear.SpawnerType and Tear.SpawnerType == EntityType.ENTITY_FAMILIAR then
        local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
        local roll = rng:RandomFloat()

        if roll < 0.25 then
            Tear:AddTearFlags(player.TearFlags)
            Tear:SetColor(player.TearColor, -1, 1, false, false)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, LillithCake.EffectShare)
mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, LillithCake.EffectShare)

function LillithCake:Give()
    local player = game:GetPlayer(0)

    if not LillithCake:CheckLillith(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    local roll = rng:RandomFloat()

    if roll < 0.1 then
        player:AddCollectible(familiarId[rng:RandomInt(#familiarId)+1], 0, false)
        player:AnimateHappy()
        player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
        replaceChance = 0.25
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, LillithCake.Give)

function LillithCake:Take(trinket,rng)
    local roll = rng:RandomFloat()
    if roll < replaceChance then
        replaceChance = 0
        return TrinketType.TRINKET_BIRTHCAKE
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_GET_TRINKET, LillithCake.Take)

-- Tainted Lillith Birthcake

function LillithCake:NewGame()
    isIncubus = true
    replaceChance = 0
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, LillithCake.NewGame)

function LillithCake:SpawnCubus()
    local player = game:GetPlayer(0)

    if not LillithCake:CheckLillithB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end
    
    local effects = player:GetEffects()

    local roomType = game:GetRoom():GetType()

    if roomType == RoomType.ROOM_BOSS then
        effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SUCCUBUS, false)
        effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_INCUBUS, false)
    else
        if isIncubus then
            effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_INCUBUS, false)
            isIncubus = false
        else
            effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SUCCUBUS, false)
            isIncubus = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, LillithCake.SpawnCubus)

