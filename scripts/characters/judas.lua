local mod = Birthcake
local game = Game()
local JudasCake = {}

-- functions

function JudasCake:CheckJudas(player)
    return player:GetPlayerType() == PlayerType.PLAYER_JUDAS or player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS
end

function JudasCake:CheckJudasB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_JUDAS_B
end

-- Judas Birthcake

function JudasCake:JudasPickup(player,flag)
    if not JudasCake:CheckJudas(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + (player.Damage * 0.2) * player:GetTrinketMultiplier(TrinketType.TRINKET_BIRTHCAKE)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JudasCake.JudasPickup, CacheFlag.CACHE_DAMAGE)

function JudasCake:Exchange(player,flag)
    if not JudasCake:CheckJudas(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_DEVIL then
        mod:GetData(player).items = {}
        mod:GetData(player).health = player:GetEffectiveMaxHearts()
        return
    end

    local item = player.QueuedItem.Item
    if not mod:GetData(player).isItemOverHead and item then
        if item:IsCollectible() and not mod:IsInList(item.ID,mod:GetData(player).items) then
            mod:GetData(player).isItemOverHead = true
            local devilPrice = item.DevilPrice
            local health = mod:GetData(player).health
            if devilPrice * 2 >= health and health > 0 then
                player:AddBlackHearts(2)
            end
            table.insert(mod:GetData(player).items,item.ID)
            mod:GetData(player).health = health - devilPrice * 2
        end
    end
    if mod:GetData(player).isItemOverHead and not item then
        mod:GetData(player).isItemOverHead = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JudasCake.Exchange)

-- Tainted Judas Birthcake

function JudasCake:Slow(player)
    if not JudasCake:CheckJudasB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local playerEffets = player:GetEffects()

    if playerEffets:HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS) then
        local playerPos = player.Position
        local entities = Isaac.GetRoomEntities()
        for i = 1, #entities do
            local entity = entities[i]
            if entity:IsVulnerableEnemy() then
                local entityPos = entity.Position
                local distance = (playerPos - entityPos):Length()
                local entityColor = entity:GetColor()
                local slowColor = Color(entityColor.R,entityColor.G,entityColor.B,0.8,entityColor.RO,entityColor.GO,entityColor.BO)
                if distance < 30 then
                    entity:AddSlowing(EntityRef(player), 100, 0.5, slowColor)
                end
            end
        end
    end


end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, JudasCake.Slow)