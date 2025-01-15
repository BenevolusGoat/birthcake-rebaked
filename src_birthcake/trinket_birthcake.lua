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
	"lillith"
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
	OnRender = function(player, _, _, pos)
		local data = Mod:GetData(player)
		if not data.BirthcakeSprite then
			data.BirthcakeSprite = Mod:GetBirthcakeSprite(player)
			data.BirthcakeSprite:Play("Idle")
		end
		Isaac.RunCallbackWithParam(Mod.Callbacks.PRE_BIRTHCAKE_RENDER, player:GetPlayerType(), player, data.BirthcakeSprite, pos)
		data.BirthcakeSprite:Render(pos)
		Isaac.RunCallbackWithParam(Mod.Callbacks.POST_BIRTHCAKE_RENDER, player:GetPlayerType(), player, data.BirthcakeSprite, pos)
	end
}, HudHelper.HUDType.TRINKET)