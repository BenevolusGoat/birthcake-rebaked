local mod = Birthcake
local json = require("json")

function mod:IsTainted(player)
    local playerType = player:GetPlayerType()
    if playerType >= 21 and playerType <=  40 then
        return true
    end
    return false
end

function mod:GetData(entity)
	if entity then
		local data = entity:GetData()
		if not data.Birthcake then
			data.Birthcake = {}
		end
		return data.Birthcake
	end
	return nil
end

function mod:IsInList(item,table)
    for _,v in pairs(table) do
        if v == item then
            return true
        end
    end
    return false
end

function mod:HasMomBox(player)
    return player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX)
end

function mod:IsBirthcake(SubType)
    if SubType == TrinketType.TRINKET_BIRTHCAKE or SubType == (TrinketType.TRINKET_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG) then
        return true
    end
    return false
end

function mod:IsGolden(SubType)
    if SubType == (TrinketType.TRINKET_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG) then
        return true
    end
    return false
end

function mod:GetTrinketMul(player,mombox)
    mombox = mombox or false
    local trinketMul = player:GetTrinketMultiplier(TrinketType.TRINKET_BIRTHCAKE)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and mombox == false then
        trinketMul = trinketMul - 1
    end
    return trinketMul
end