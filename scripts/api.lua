local mod = Birthcake
local game = Game()
local API = {}

function API:RegisterEffect(charater,callback,func)
end

function API:SetBirthcakeDesc(PlayerType,Description)
    mod.BirthcakeDesc[PlayerType] = Description
end

function API:AddTrinketEID(PlayerType,Type,Description)
    mod.TrinketDesc[PlayerType][Type] = Description
end