local Mod = BirthcakeRebaked
local loader = Mod.PatchesLoader

local function epiphanyPatch()
	local playerType = Epiphany.technical_character
	Mod.API:AddBirthcakePickupText(playerType, "It's all a mystery!", "Technical's")
	Mod.API:AddBirthcakeSprite(playerType, {
		SpritePath = "gfx/items/trinkets/technical_character_birthcake.png"
	})
	Mod.API:AddAccurateBlurbcake(playerType, "Does, in fact, still do nothing")
	Mod.API:AddEIDDescription(playerType, "No effect")
end

loader:RegisterPatch("Epiphany", epiphanyPatch)