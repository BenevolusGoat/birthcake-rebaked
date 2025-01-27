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
	ItemID = Mod.Birthcake.ID,
	OnRender = function(player, _, _, pos, scale, alpha, trinketID)
		local data = Mod:GetData(player)
		local isGolden = Mod:IsBirthcake(trinketID, true)
		if isGolden and not data.GoldenBirthcakeSprite then
			local sprite, spritePath = Mod:GetBirthcakeSprite(player)
			sprite:Play("Idle")
			if REPENTOGON then
				sprite:SetRenderFlags(AnimRenderFlags.GOLDEN)
			else
				--Credit to Epiphany for this anm2
				sprite = Sprite()
				sprite:Load("gfx/ui/golden_item_hud.anm2")
				for i = 0, 31 do
					sprite:ReplaceSpritesheet(i, spritePath)
				end
				sprite:LoadGraphics()
				sprite:Play("GoldenItemHUD")
				sprite.Offset = Vector(-16, -25)
			end
			data.GoldenBirthcakeSprite = sprite
		end
		if not isGolden and not data.BirthcakeSprite then
			local sprite = Mod:GetBirthcakeSprite(player)
			sprite:Play("Idle")
			data.BirthcakeSprite = sprite
		end
		local sprite = isGolden and data.GoldenBirthcakeSprite or data.BirthcakeSprite
		local playerType = player:GetPlayerType()
		sprite.Scale = Vector(scale, scale)
		sprite.Color = Color(1,1,1,alpha)
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.PRE_BIRTHCAKE_RENDER, playerType, player, sprite, pos)
		sprite:Render(pos)
		if Isaac.GetFrameCount() % 2 == 0 and not Mod.Game:IsPaused() then
			sprite:Update()
		end
		Isaac.RunCallbackWithParam(Mod.ModCallbacks.POST_BIRTHCAKE_RENDER, playerType, player, sprite, pos)
	end
}, HudHelper.HUDType.TRINKET_ITEM)

function BIRTHCAKE_TRINKET:OnPlayerTypeChange(player)
	local data = Mod:GetData(player)
	if data.BirthcakeSprite then
		data.BirthcakeSprite = nil
	end
end

Mod:AddPriorityCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, CallbackPriority.EARLY, BIRTHCAKE_TRINKET.OnPlayerTypeChange)