local Mod = BirthcakeRebaked

local FOUND_SOUL_CAKE = {}

BirthcakeRebaked.Birthcake.LOST_SOUL = FOUND_SOUL_CAKE

FOUND_SOUL_CAKE.BIRTHCAKE_COLOR = Color(1, 1, 1, 1, 0.5, 0.2, 0.21)
FOUND_SOUL_CAKE.DAMAGE_MULT_UP = 0.50

local delayHorn = false

---@param player EntityPlayer
function FOUND_SOUL_CAKE:CheckBirthcake(player)
	if Mod.Game:GetRoom():GetFrameCount() > 0 and player.BabySkin == BabySubType.BABY_FOUND_SOUL then
		player:GetData().CheckCoopBabyBirthcake = true
		delayHorn = true
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FOUND_SOUL_CAKE.CheckBirthcake, PlayerVariant.FOUND_SOUL)

function FOUND_SOUL_CAKE:PlayPartyHorn()
	if delayHorn then
		Mod:ForEachPlayer(function (player)
			if player:GetData().CheckCoopBabyBirthcake and player:HasTrinket(Mod.Birthcake.ID) then
				Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
				player:SetColor(FOUND_SOUL_CAKE.BIRTHCAKE_COLOR, 15, 1, true, false)
				player:GetData().CheckCoopBabyBirthcake = nil
			end
		end)
		delayHorn = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, FOUND_SOUL_CAKE.PlayPartyHorn)

---@param player EntityPlayer
---@param flag CacheFlag
function FOUND_SOUL_CAKE:AllStatsUp(player, flag)
	if player:HasTrinket(Mod.Birthcake.ID)
		and player.Variant == PlayerVariant.FOUND_SOUL
		and player.BabySkin == BabySubType.BABY_FOUND_SOUL
	then
		local parent = player.Parent and player.Parent:ToPlayer()
		if not parent then return end
		player.Damage = player.Damage + (parent.Damage * FOUND_SOUL_CAKE.DAMAGE_MULT_UP)
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, FOUND_SOUL_CAKE.AllStatsUp, CacheFlag.CACHE_DAMAGE)