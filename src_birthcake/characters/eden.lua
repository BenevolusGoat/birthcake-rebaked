local Mod = BirthcakeRebaked
local game = Mod.Game

local EDEN_CAKE = {}
BirthcakeRebaked.Birthcake.EDEN = EDEN_CAKE
EDEN_CAKE.HiddenItemGroup = "Eden Birthcake"

-- Eden Birthcake

---@param player EntityPlayer
function EDEN_CAKE:RefreshBirthcakeTrinkets(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	local itemPool = Mod.Game:GetItemPool()
	local trinketList = {}
	player_run_save.EdenCakeTrinkets = player_run_save.EdenCakeTrinkets or trinketList
	Mod:RemoveSmeltedTrinkets(player, trinketList)
	for _ = 1, 2 + Mod:GetTrinketMult(player) - #player_run_save.EdenCakeTrinkets do
		local trinketID = itemPool:GetTrinket()
		table.insert(trinketList, trinketID)
	end
	Mod:AddSmeltedTrinkets(player, trinketList)
	Mod.SFXManager:Play(SoundEffect.SOUND_VAMP_GULP)
	player_run_save.EdenCakeHasTrinkets = true
end

---@param player EntityPlayer
---@param firstTime boolean
function EDEN_CAKE:OnAddBirthcake(player, firstTime)
	if firstTime then
		EDEN_CAKE:RefreshBirthcakeTrinkets(player)
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, EDEN_CAKE.OnAddBirthcake, PlayerType.PLAYER_EDEN)

---@param player EntityPlayer
function EDEN_CAKE:ManageTrinkets(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	if player_run_save.EdenCakeHasTrinkets and not player:HasTrinket(Mod.Birthcake.ID) then
		local trinketList = player_run_save.EdenCakeTrinkets
		if trinketList then
			Mod:RemoveSmeltedTrinkets(player, trinketList)
		end
		player_run_save.EdenCakeHasTrinkets = false
	elseif not player_run_save.EdenCakeHasTrinkets and player:HasTrinket(Mod.Birthcake.ID) and not player.QueuedItem.Item then
		local trinketList = player_run_save.EdenCakeTrinkets
		if trinketList then
			Mod:AddSmeltedTrinkets(player, trinketList)
		end
		player_run_save.EdenCakeHasTrinkets = true
	elseif player_run_save.EdenCakeHasTrinkets and player:HasTrinket(Mod.Birthcake.ID) then
		if #player_run_save.EdenCakeTrinkets ~= 2 + Mod:GetTrinketMult(player) then
			EDEN_CAKE:RefreshBirthcakeTrinkets(player)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EDEN_CAKE.ManageTrinkets, PlayerType.PLAYER_EDEN)

function EDEN_CAKE:OnPlayerTypeChange(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	if player_run_save.EdenCakeHasTrinkets then
		local trinketList = player_run_save.EdenCakeTrinkets
		if trinketList then
			Mod:RemoveSmeltedTrinkets(player, trinketList)
		end
		player_run_save.EdenCakeHasTrinkets = nil
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, EDEN_CAKE.OnPlayerTypeChange, PlayerType.PLAYER_EDEN)

-- Tainted Eden birthcake

EDEN_CAKE.PREVENT_REROLL_CHANCE = 0.33

---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param countdownFrames integer
function EDEN_CAKE:PreventReroll(ent, amount, flags, source, countdownFrames)
	local player = ent:ToPlayer()
	if not Mod:HasBitFlags(flags, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES)
		and player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EDEN_B)
		and not Mod:GetData(player).EdenCakePreventLoop
	then
		--We only care about held Birthcakes, not smelted
		local trinket0 = player:GetTrinket(0)
		local trinket1 = player:GetTrinket(1)
		local data = Mod:GetData(player)
		if Mod:IsBirthcake(trinket0) then
			data.EdenCakeRegrantBirthcake0 = trinket0
			player:TryRemoveTrinket(trinket0)
		elseif Mod:IsBirthcake(trinket1) then
			data.EdenCakeRegrantBirthcake1 = trinket1
			player:TryRemoveTrinket(trinket1)
		end

		if player:GetTrinketRNG(Mod.Birthcake.ID):RandomFloat() <= Mod:GetBalanceApprovedChance(EDEN_CAKE.PREVENT_REROLL_CHANCE, Mod:GetTrinketMult(player)) then
			data.EdenCakePreventLoop = true
			player:TakeDamage(amount, flags | DamageFlag.DAMAGE_NO_PENALTIES, source, countdownFrames)
			data.EdenCakePreventLoop = false
			return false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, EDEN_CAKE.PreventReroll, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function EDEN_CAKE:ReturnBirthcake(player)
	local data = Mod:GetData(player)

	if data.EdenCakeRegrantBirthcake1 then
		player:AddTrinket(data.EdenCakeRegrantBirthcake1, false)
		data.EdenCakeRegrantBirthcake1 = nil
	end
	if data.EdenCakeRegrantBirthcake0 then
		player:AddTrinket(data.EdenCakeRegrantBirthcake0, false)
		data.EdenCakeRegrantBirthcake0 = nil
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EDEN_CAKE.ReturnBirthcake, PlayerType.PLAYER_EDEN_B)
