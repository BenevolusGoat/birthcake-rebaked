_G.Birthcake = {}
local mod = Birthcake
mod.BirthcakeDescs = {}
mod.BirthcakeDesc = mod.BirthcakeDescs
mod.TrinketDesc = {}

function mod:SetBirthcakeDesc(PlayerType,Description)
	mod.BirthcakeDesc[PlayerType] = Description
end

---@param PlayerType PlayerType
---@param Type "Normal" | "Upgraded" | "Golden" | "+Golden" | "+{{Trinket'..TrinketType.TRINKET_MECONIUM..'}}" | "+Birthright"
---@param Description any
function mod:AddTrinketEID(PlayerType,Type,Description)
	mod.TrinketDesc[PlayerType] = {}
	mod.TrinketDesc[PlayerType][Type] = Description
end