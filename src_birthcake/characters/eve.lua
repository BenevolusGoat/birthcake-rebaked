local Mod = BirthcakeRebaked
local game = Mod.Game

local EVE_CAKE = {}
BirthcakeRebaked.Characters.EVE = EVE_CAKE

-- Eve Birthcake

function EVE_CAKE:RemoveHeart(ent, damage, flag, source, cdframe)
	local player = ent:ToPlayer() ---@cast player EntityPlayer
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE) then
		return flag | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EVE_CAKE.RemoveHeart, EntityType.ENTITY_PLAYER)

-- Tainted Eve Birthcake

---@param ent Entity
function EVE_CAKE:ClotDeath(ent, dmg, flag, source, cdframe)
	local player = ent:ToFamiliar() and ent:ToFamiliar().Player

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EVE_B)
		and ent.Variant == FamiliarVariant.BLOOD_BABY and ent:IsDead()
	then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0,
			Isaac.GetFreeNearPosition(ent.Position, 10), Vector(0, 0), ent)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, EVE_CAKE.ClotDeath, EntityType.ENTITY_FAMILIAR)
