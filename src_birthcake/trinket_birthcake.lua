local Mod = BirthcakeRebaked
local BIRTHCAKE_TRINKET = {}
BirthcakeRebaked.Birthcake = BIRTHCAKE_TRINKET
BIRTHCAKE_TRINKET.ID = Isaac.GetTrinketIdByName("Birthcake")

local characters = {
	"bethany",
	"cain",
	"magdalene",
	"judas",
	"isaac",
	"bluebaby",
	"eve",
	"samson",
	"keeper",
	"lazarus",
	"apollyon",
	"jacob",
	"eden",
	"thelost",
	"azazel",
	"forgotten",
	"lillith",
	"default_effect"
}
local characterScriptPath = "src_birthcake.characters."

for _, name in ipairs(characters) do
	include(characterScriptPath .. name)
end

HudHelper.RegisterHUDElement({
	Name = "Birthcake",
	Priority = HudHelper.Priority.NORMAL,
	Condition = function(player, _, _, slot)
		return player:GetTrinket(slot) == BIRTHCAKE_TRINKET.ID
	end,
	OnRender = function(player, _, _, pos, scale)
		local data = Mod:GetData(player)
		if not data.BirthcakeSprite then
			data.BirthcakeSprite = Mod:GetBirthcakeSprite(player)
			data.BirthcakeSprite:Play("Idle")
		end
		local playerType = player:GetPlayerType()
		data.BirthcakeSprite.Scale = Vector(scale, scale)
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.PRE_BIRTHCAKE_RENDER, playerType, player,
			data.BirthcakeSprite, pos)
		data.BirthcakeSprite:Render(pos)
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_RENDER, playerType, player,
			data.BirthcakeSprite, pos)
	end
}, HudHelper.HUDType.TRINKET)

function BIRTHCAKE_TRINKET:OnPlayerTypeChange(player)
	local data = Mod:GetData(player)
	if data.BirthcakeSprite then
		data.BirthcakeSprite = nil
	end
end

Mod:AddPriorityCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, CallbackPriority.EARLY, BIRTHCAKE_TRINKET.OnPlayerTypeChange)