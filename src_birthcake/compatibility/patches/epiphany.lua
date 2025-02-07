local Mod = BirthcakeRebaked
local loader = Mod.PatchesLoader

local function epiphanyPatch()
	Mod.API:AddBirthcakePickupText(Epiphany.technical_character, "Coming soon?", "Technical's")
	Mod.API:AddBirthcakeSprite(Epiphany.technical_character, {
		SpritePath = "gfx/items/trinkets/technical_character_birthcake.png"
	})
end

loader:RegisterPatch("Epiphany", epiphanyPatch)