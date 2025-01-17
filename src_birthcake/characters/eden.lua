local Mod = BirthcakeRebaked
local game = Mod.Game

local EDEN_CAKE = {}
BirthcakeRebaked.Birthcake.EDEN = EDEN_CAKE
EDEN_CAKE.HiddenItemGroup = "Eden Birthcake"

-- Eden Birthcake

---@param player EntityPlayer
---@param num integer
function EDEN_CAKE:AddBirthcakeTrinkets(player, num)
	local itemPool = Mod.Game:GetItemPool()
	local trinketList = {}
	for _ = 1, num do
		local trinketID = itemPool:GetTrinket()
		table.insert(trinketList, { TrinketType = trinketID, FirstTime = true })
	end
	Mod:AddSmeltedTrinkets(player, trinketList)
	Mod.SFXManager:Play(SoundEffect.SOUND_VAMP_GULP)
end

---@param player EntityPlayer
---@param firstTime boolean
function EDEN_CAKE:OnAddBirthcake(player, firstTime, isGolden)
	if firstTime then
		local count = 3
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
			count = count + 1
		end
		if isGolden then
			count = count + 1
		end
		EDEN_CAKE:AddBirthcakeTrinkets(player, count)
		player:TryRemoveTrinket(Mod.Birthcake.ID)
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, EDEN_CAKE.OnAddBirthcake, PlayerType.PLAYER_EDEN)

-- Tainted Eden birthcake

---@param player EntityPlayer
function EDEN_CAKE:RerollBirthcakeTrinkets(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	player_run_save.EdenCakeRerollingTrinkets = player_run_save.EdenCakeRerollingTrinkets or {}
	local trinketList = player_run_save.EdenCakeRerollingTrinkets
	for i = #trinketList, 1, -1 do
		local trinketID = trinketList[i]
		player:TryRemoveTrinket(trinketID)
		table.remove(trinketList, i)
	end
	local itemPool = Mod.Game:GetItemPool()
	for _ = 1, 3 + (player:GetTrinketMultiplier(Mod.Birthcake.ID) - 1) do
		local trinketID = itemPool:GetTrinket()
		table.insert(trinketList, trinketID)
	end
	Mod:AddSmeltedTrinkets(player, trinketList)
	player_run_save.EdenCakeHasRerollingTrinkets = true
end

---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param countdownFrames integer
function EDEN_CAKE:PreventReroll(ent, amount, flags, source, countdownFrames)
	local player = ent:ToPlayer() ---@cast player EntityPlayer
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_EDEN_B)
		and not Mod:HasBitFlags(flags, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_PENALTIES)
	then
		EDEN_CAKE:RerollBirthcakeTrinkets(player)
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
	EDEN_CAKE:ManageRerollingTrinkets(player)
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, EDEN_CAKE.ReturnBirthcake, PlayerType.PLAYER_EDEN_B)

---@param player EntityPlayer
function EDEN_CAKE:ManageRerollingTrinkets(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	if player_run_save.EdenCakeHasRerollingTrinkets and not player:HasTrinket(Mod.Birthcake.ID) then
		local trinketList = player_run_save.EdenCakeRerollingTrinkets
		if trinketList then
			Mod:RemoveSmeltedTrinkets(player, trinketList, false)
		end
		player_run_save.EdenCakeHasRerollingTrinkets = false
	elseif not player_run_save.EdenCakeHasRerollingTrinkets and player:HasTrinket(Mod.Birthcake.ID) then
		local trinketList = player_run_save.EdenCakeRerollingTrinkets
		if trinketList then
			Mod:AddSmeltedTrinkets(player, trinketList)
		else
			EDEN_CAKE:RerollBirthcakeTrinkets(player)
		end
		player_run_save.EdenCakeHasRerollingTrinkets = true
	end
end