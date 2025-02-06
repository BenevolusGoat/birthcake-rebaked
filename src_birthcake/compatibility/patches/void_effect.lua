local Mod = BirthcakeRebaked
local loader = Mod.PatchesLoader

if REPENTOGON then
	local function voidEffectPatch()
		Mod:AddCallback(Mod.ModCallbacks.APOLLYON_VOID_TRINKET, function(_, pickup)
			DIVIDED_VOID_VOIDED_EFFECT.ListVoidedPickups[GetPtrHash(pickup)] = 0
			DIVIDED_VOID_VOIDED_EFFECT.RemovePuffs(pickup.Position)
		end)
		Mod:AddCallback(Mod.ModCallbacks.APOLLYON_B_ABYSS_TRINKET, function(_, pickup)
			DIVIDED_VOID_VOIDED_EFFECT.ListVoidedPickups[GetPtrHash(pickup)] = 2
			DIVIDED_VOID_VOIDED_EFFECT.RemovePuffs(pickup.Position)
		end)
	end

	loader:RegisterPatch("DIVIDED_VOID_VOIDED_EFFECT", voidEffectPatch)
end