local Mod = BirthcakeRebaked
local DEFAULT_EFFECT = {}

BirthcakeRebaked.Birthcake.DEFAULT_EFFECT = DEFAULT_EFFECT

DEFAULT_EFFECT.STAT_MULT = 0.15

function DEFAULT_EFFECT:GetStatMult(mult)
	return DEFAULT_EFFECT.STAT_MULT + ((DEFAULT_EFFECT.STAT_MULT / 2) * (mult - 1))
end

---@param player EntityPlayer
---@param flag CacheFlag
function DEFAULT_EFFECT:AllStatsUp(player, flag)
	local playerType = player:GetPlayerType()
	if player:HasTrinket(Mod.Birthcake.ID)
		and not Mod.BirthcakeDescriptions[playerType]
		and not Birthcake.BirthcakeDescs[playerType]
	then
		--Trinket mults add half of the base mult. 2 would mean +100%
		local mult = DEFAULT_EFFECT:GetStatMult(Mod:GetTrinketMult(player))
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + (player.Damage * mult)
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_SHOTSPEED) then
			player.ShotSpeed = player.ShotSpeed + (player.ShotSpeed * mult)
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = player.MoveSpeed + (player.MoveSpeed * mult)
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_RANGE) then
			player.TearRange = player.TearRange + (player.TearRange * mult)
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_FIREDELAY) then
			player.MaxFireDelay = Mod:Tears2Delay(Mod:Delay2Tears(player.MaxFireDelay) * (1 + mult))
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DEFAULT_EFFECT.AllStatsUp)