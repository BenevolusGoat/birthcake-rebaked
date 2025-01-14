local mod = Birthcake
local game = Game()
local IsaacCake = {}
local frameCounter = 0
local frequency = 60

-- Functions

function IsaacCake:CheckIsaac(player)
    return player:GetPlayerType() == PlayerType.PLAYER_ISAAC
end

function IsaacCake:CheckIsaacB(player)
    return player:GetPlayerType() == PlayerType.PLAYER_ISAAC_B
end

-- Isaac Birthcake

function IsaacCake:Switch(entity,newItemId)
    if entity.SubType == newItemId then
        return
    end

    local level = game:GetLevel()
    entity.SubType = newItemId
    if level:GetCurses() ~= LevelCurse.CURSE_OF_BLIND then
        local newItem = Isaac.GetItemConfig():GetCollectible(newItemId)
        entity:GetSprite():ReplaceSpritesheet(1,newItem.GfxFileName)
        entity:GetSprite():LoadGraphics()
    end
end 

function IsaacCake:SwitchItem(player)
    frameCounter = frameCounter + 1
    if not IsaacCake:CheckIsaac(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    local room = game:GetRoom()
    local entities = room:GetEntities()
    local level = game:GetLevel()

    for i = 0, #entities-1 do
        local entity = entities:Get(i)
        if entity then
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                if room:IsFirstVisit() then
                    if mod:GetData(entity).isCycling == nil then
                        mod:GetData(entity).isCycling = false
                    end
                    
                    if mod:GetData(entity).CyclingID == nil then
                        mod:GetData(entity).CyclingID = {
                            ["original"] = entity.SubType,
                            ["new"] = 1
                        }
                    end

                    table.insert(mod:GetData(player).LastSeenItems,{
                        ["roomID"] = level:GetCurrentRoomIndex(),
                        ["isCycling"] = mod:GetData(entity).isCycling,
                        ["original"] = mod:GetData(entity).CyclingID.original,
                        ["new"] = mod:GetData(entity).CyclingID.new,
                    })
                else
                    local roomID = level:GetCurrentRoomIndex()
                    for i = 1, #mod:GetData(player).LastSeenItems do
                        if mod:GetData(player).LastSeenItems[i].roomID == roomID then
                            mod:GetData(entity).isCycling = mod:GetData(player).LastSeenItems[i].isCycling
                            mod:GetData(entity).CyclingID = {
                                ["original"] = mod:GetData(player).LastSeenItems[i].original,
                                ["new"] = mod:GetData(player).LastSeenItems[i].new
                            }
                        end
                    end
                end

                if frameCounter % frequency == 0 and mod:GetData(entity).isCycling then
                    local ogItem = mod:GetData(entity).CyclingID.original
                    local newItem = mod:GetData(entity).CyclingID.new
                    if entity.SubType == ogItem then
                        IsaacCake:Switch(entity,newItem)
                    elseif entity.SubType == newItem then
                        IsaacCake:Switch(entity,ogItem)
                    end
                end
            end
        end
    end

end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, IsaacCake.SwitchItem)

function IsaacCake:IsaacRerollPre(collectible,rng,player,useFlags,activeSlot,vardata)
    if not IsaacCake:CheckIsaac(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local room = game:GetRoom()
    local entities = room:GetEntities()
    local level = game:GetLevel()
    
    for i = 0, #entities-1 do
        local entity = entities:Get(i)
        if entity then
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                mod:GetData(entity).CyclingID.original = entity.SubType

                local roomID = level:GetCurrentRoomIndex()
                for i = 1, #mod:GetData(player).LastSeenItems do
                    if mod:GetData(player).LastSeenItems[i].roomID == roomID then
                        mod:GetData(player).LastSeenItems[i].original = entity.SubType
                    end
                end
            end
        end
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, IsaacCake.IsaacRerollPre, CollectibleType.COLLECTIBLE_D6)

function IsaacCake:IsaacReroll(collectible,rng,player,useFlags,activeSlot,vardata)
    if not IsaacCake:CheckIsaac(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return nil
    end

    local room = game:GetRoom()
    local entities = room:GetEntities()
    local level = game:GetLevel()
    
    for i = 0, #entities-1 do
        local entity = entities:Get(i)
        if entity then
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local roll = rng:RandomFloat()

                if roll < 0.25 then
                    mod:GetData(entity).isCycling = true
                end

                local roomID = level:GetCurrentRoomIndex()
                for i = 1, #mod:GetData(player).LastSeenItems do
                    if mod:GetData(player).LastSeenItems[i].roomID == roomID then
                        mod:GetData(player).LastSeenItems[i].new = entity.SubType
                        mod:GetData(player).LastSeenItems[i].isCycling = mod:GetData(entity).isCycling
                        mod:GetData(entity).isCycling = mod:GetData(player).LastSeenItems[i].isCycling
                        mod:GetData(entity).CyclingID = {
                            ["original"] = mod:GetData(player).LastSeenItems[i].original,
                            ["new"] = mod:GetData(player).LastSeenItems[i].new
                        }
                    end
                end
            end
        end
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, IsaacCake.IsaacReroll, CollectibleType.COLLECTIBLE_D6)

-- Isaac B Birthcake

function IsaacCake:Test(player,damage,flags,source,cdframes)
    if player.Type ~= EntityType.ENTITY_PLAYER then
        return
    end

    player = player:ToPlayer()

    if not IsaacCake:CheckIsaacB(player) or not player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        return
    end

    if player:GetCollectibleCount() < 8 then
        return
    end

    local items = {}
    
    for i = 1, #Isaac.GetItemConfig():GetCollectibles() - 1 do
        if player:HasCollectible(i) and not mod:IsInList(i,items) and Isaac:GetItemConfig():GetCollectible(i).Type == ItemType.ITEM_PASSIVE then
            table.insert(items,i)
        end
    end

    if #items == 0 then
        return
    end

    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    local randint = rng:RandomInt(#items)   
    local itemID = items[randint+1]
    local roll = rng:RandomFloat()

    if roll < 0.25 then
        player:AddCollectible(itemID,0,true)
        roll = rng:RandomFloat()
        if roll < 0.50 then
            player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, IsaacCake.Test, EntityType.ENTITY_PLAYER)