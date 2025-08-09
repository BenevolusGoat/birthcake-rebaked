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
	"lilith",
	"found_soul",
	"default_effect"
}
local characterScriptPath = "src_birthcake.characters."

for _, name in ipairs(characters) do
	include(characterScriptPath .. name)
end

local spritePath
local lastPlayerTypeRendered

HudHelper.RegisterHUDElement({
	ItemID = Mod.Birthcake.ID,
	OnRender = function(player, _, _, pos, alpha, scale, trinketID)
		local isGolden = Mod:IsBirthcake(trinketID, true)
		local playerType = player:GetPlayerType()
		local useDefaultSprite = Mod.GetSetting(Mod.Setting.UniqueSprite) == false
		if lastPlayerTypeRendered ~= playerType
			or useDefaultSprite and lastPlayerTypeRendered ~= PlayerType.PLAYER_ISAAC
		then
			lastPlayerTypeRendered = useDefaultSprite and PlayerType.PLAYER_ISAAC or playerType
			local _, newSpritePath = Mod:GetBirthcakeSprite(player)
			spritePath = newSpritePath
		end
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.PRE_BIRTHCAKE_RENDER, playerType, player, pos)
		HudHelper.RenderHUDItem(spritePath, pos, scale, alpha, isGolden, true)
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_RENDER, playerType, player, pos)
	end
}, HudHelper.HUDType.TRINKET_ID)

function BIRTHCAKE_TRINKET:OnPlayerTypeChange(player)
	local data = Mod:GetData(player)
	if data.BirthcakeSprite then
		data.BirthcakeSprite = nil
	end
end

Mod:AddPriorityCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, CallbackPriority.EARLY,
	BIRTHCAKE_TRINKET.OnPlayerTypeChange)
