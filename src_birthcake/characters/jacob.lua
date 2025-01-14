local Mod = BirthcakeRebaked
local game = Mod.Game

local JACOB_ESAU_CAKE = {}
BirthcakeRebaked.Birthcake.JACOB_AND_ESAU = JACOB_ESAU_CAKE

JACOB_ESAU_CAKE.STAT_SHARE_MULT = 0.1

-- functions

function JACOB_ESAU_CAKE:CheckJacobEsau(player)
	return (player:GetPlayerType() == PlayerType.PLAYER_JACOB or player:GetPlayerType() == PlayerType.PLAYER_ESAU)
	and player:HasTrinket(Mod.Birthcake.ID)
end

function JACOB_ESAU_CAKE:CheckTaintedJacob(player)
	return (player:GetPlayerType() == PlayerType.PLAYER_JACOB_B or player:GetPlayerType() == PlayerType.PLAYER_JACOB2_B)
	and player:HasTrinket(Mod.Birthcake.ID)
end

-- Jacob Birthcake

local function tearsUpAdd(firedelay, val)
	local currentTears = 30 / (firedelay + 1)
	local newTears = currentTears + val
	return math.max((30 / newTears) - 1, -0.99)
end

---@param player EntityPlayer
---@param flag CacheFlag
function JACOB_ESAU_CAKE:ShareTwinStats(player, flag)
	if JACOB_ESAU_CAKE:CheckJacobEsau(player)
		and player:GetOtherTwin()
	then
		local otherTwin = player:GetOtherTwin()
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_DAMAGE) then
			player.Damage = player.Damage + (otherTwin.Damage) * JACOB_ESAU_CAKE.STAT_SHARE_MULT
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_SHOTSPEED) then
			player.ShotSpeed = player.ShotSpeed + (otherTwin.ShotSpeed) * JACOB_ESAU_CAKE.STAT_SHARE_MULT
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_SPEED) then
			player.MoveSpeed = player.MoveSpeed + (otherTwin.MoveSpeed) * JACOB_ESAU_CAKE.STAT_SHARE_MULT
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_RANGE) then
			player.TearRange = player.TearRange + (otherTwin.TearRange) * JACOB_ESAU_CAKE.STAT_SHARE_MULT
		end
		if Mod:HasBitFlags(flag, CacheFlag.CACHE_FIREDELAY) then
			local value = (30 / otherTwin.MaxFireDelay) * JACOB_ESAU_CAKE.STAT_SHARE_MULT
			player.MaxFireDelay = tearsUpAdd(player.MaxFireDelay, value)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JACOB_ESAU_CAKE.ShareTwinStats)

-- Tainted Jacob

---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param countdownFrames integer
function JACOB_ESAU_CAKE:ConsumeJacobCake(ent, amount, flags, source, countdownFrames)
	if ent:ToPlayer()
		and JACOB_ESAU_CAKE:CheckTaintedJacob(ent:ToPlayer())
		and source
		and source.Entity
		and source.Entity.Type == EntityType.ENTITY_DARK_ESAU
		and not Mod:HasBitFlags(flags, DamageFlag.DAMAGE_FAKE)
	then
		local player = ent:ToPlayer()
		---@cast player EntityPlayer
		local npc = source.Entity
		local floor_save = Mod.SaveManager.GetFloorSave()
		if not floor_save.DarkEsauBirthcake or not floor_save.DarkEsauBirthcake[tostring(npc.InitSeed)] then
			floor_save.DarkEsauBirthcake = floor_save.DarkEsauBirthcake or {}
			floor_save.DarkEsauBirthcake[tostring(npc.InitSeed)] = true
		end
		player:TryRemoveTrinket(Mod.Birthcake.ID)
		player:TakeDamage(0, flags | DamageFlag.DAMAGE_FAKE, source, countdownFrames)
		return false
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JACOB_ESAU_CAKE.ConsumeJacobCake, EntityType.ENTITY_PLAYER)