--#region Variables

local Mod = BirthcakeRebaked

local BIRTHDAY_PARTY = {}
BirthcakeRebaked.Challenges.BIRTHDAY_PARTY = BIRTHDAY_PARTY

BIRTHDAY_PARTY.ID = Isaac.GetChallengeIdByName("Isaac's Birthday Party")

include("src_birthcake.utility.challenge_util")

local CHARACTER_LIST = {
	PlayerType.PLAYER_ISAAC,
	PlayerType.PLAYER_MAGDALENE,
	PlayerType.PLAYER_CAIN,
	PlayerType.PLAYER_JUDAS,
	PlayerType.PLAYER_BLUEBABY,
	PlayerType.PLAYER_EVE,
	PlayerType.PLAYER_SAMSON,
	PlayerType.PLAYER_AZAZEL,
	PlayerType.PLAYER_LAZARUS,
	PlayerType.PLAYER_EDEN,
	PlayerType.PLAYER_THELOST,
	PlayerType.PLAYER_LILITH,
	PlayerType.PLAYER_KEEPER,
	PlayerType.PLAYER_APOLLYON,
	PlayerType.PLAYER_THEFORGOTTEN,
	PlayerType.PLAYER_BETHANY,
	PlayerType.PLAYER_JACOB,
}


---@type {[PlayerType]: fun(player: EntityPlayer)}
BIRTHDAY_PARTY.CharacterRewards = {
	[PlayerType.PLAYER_BLUEBABY] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_POOP) then
			local player_run_save = Mod:RunSave(player)
			player_run_save.BirthdayPartyGrantedPoop = true
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				CollectibleType.COLLECTIBLE_POOP, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_EVE] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_DEAD_BIRD) then
			local player_run_save = Mod:RunSave(player)
			player_run_save.BirthdayPartyGrantedDeadBird = true
			player:AddCollectible(CollectibleType.COLLECTIBLE_DEAD_BIRD)
		end
	end,
	[PlayerType.PLAYER_SAMSON] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST) then
			local player_run_save = Mod:RunSave(player)
			player_run_save.BirthdayPartyGrantedBloodyLust = true
			player:AddCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST)
		end
	end,
	[PlayerType.PLAYER_LILITH] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) then
			local player_run_save = Mod:RunSave(player)
			player_run_save.BirthdayPartyGrantedBoxOfFriends = true
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_APOLLYON] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
			local player_run_save = Mod:RunSave(player)
			player_run_save.BirthdayPartyGrantedVoid = true
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_VOID,
				room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_BETHANY] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
			local player_run_save = Mod:RunSave(player)
			player_run_save.BirthdayPartyGrantedBookofVirtues = true
			player:AddCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
		end
	end,
	[PlayerType.PLAYER_KEEPER] = function(player)
		local maxHearts = player:GetMaxHearts()
		if maxHearts < 6 then
			player:AddMaxHearts(6 - maxHearts)
			player:AddHearts(6)
		end
	end,
	[PlayerType.PLAYER_THEFORGOTTEN] = function(player)
		if player:GetSoulHearts() == 0 then
			player:AddSoulHearts(2)
		end
	end
}


---@type {[PlayerType]: fun(player: EntityPlayer)}
BIRTHDAY_PARTY.CharacterResets = {
	[PlayerType.PLAYER_BLUEBABY] = function(player)
		local player_run_save = Mod:RunSave(player)
		if player_run_save.BirthdayPartyGrantedPoop then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_POOP)
			player_run_save.BirthdayPartyGrantedPoop = nil
		end
	end,
	[PlayerType.PLAYER_EVE] = function(player)
		local player_run_save = Mod:RunSave(player)
		if player_run_save.BirthdayPartyGrantedDeadBird then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_DEAD_BIRD)
			player_run_save.BirthdayPartyGrantedDeadBird = nil
		end
	end,
	[PlayerType.PLAYER_SAMSON] = function(player)
		local player_run_save = Mod:RunSave(player)
		if player_run_save.BirthdayPartyGrantedBloodyLust then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST)
			player_run_save.BirthdayPartyGrantedBloodyLust = nil
		end
	end,
	[PlayerType.PLAYER_LILITH] = function(player)
		local player_run_save = Mod:RunSave(player)
		if player_run_save.BirthdayPartyGrantedBoxOfFriends then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
			player_run_save.BirthdayPartyGrantedBoxOfFriends = nil
		end
	end,
	[PlayerType.PLAYER_APOLLYON] = function(player)
		local player_run_save = Mod:RunSave(player)
		if player_run_save.BirthdayPartyGrantedVoid then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_VOID)
			player_run_save.BirthdayPartyGrantedVoid = nil
		end
	end,
	[PlayerType.PLAYER_BETHANY] = function(player)
		local player_run_save = Mod:RunSave(player)
		if player_run_save.BirthdayPartyGrantedBookofVirtues then
			player:RemoveCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)
			player_run_save.BirthdayPartyGrantedBookofVirtues = nil
		end
	end,
	[PlayerType.PLAYER_LAZARUS2] = function(player)
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_ANEMIC)
	end
}

--#endregion

--#region Health tracking

---@param player EntityPlayer
function BIRTHDAY_PARTY:GrantSavedHealth(player)
	local player_run_save = Mod:RunSave(player)
	if player_run_save.BirthdayPartySavedHealth then
		local twin = player:GetOtherTwin()
		local isMainTwin = GetPtrHash(player:GetMainTwin()) == GetPtrHash(player)
		if twin and isMainTwin then
			local splitAmountMainTwin = {}
			local splitAmountOtherTwin = {}
			for heartType, amount in pairs(player_run_save.BirthdayPartySavedHealth) do
				if amount >= 2 then
					local dividedAmount = amount * 0.5
					--Allow uneven amounts
					if heartType == "Red"
						or heartType == "Soul"
						or heartType == "Black"
					then
						splitAmountMainTwin[heartType] = dividedAmount
					else
						splitAmountMainTwin[heartType] = (dividedAmount % 2 ~= 0) and dividedAmount + 1 or dividedAmount
					end
					splitAmountOtherTwin[heartType] = amount - splitAmountMainTwin[heartType]
				else
					splitAmountMainTwin[heartType] = amount
				end
			end
			player_run_save.BirthdayPartySavedHealth = splitAmountMainTwin
			Mod:RunSave(twin).BirthdayPartySavedHealth = splitAmountOtherTwin
			BIRTHDAY_PARTY:GrantSavedHealth(twin)
		end
		player:AddMaxHearts(-24)
		player:AddSoulHearts(-24)
		local health = player_run_save.BirthdayPartySavedHealth
		player:AddMaxHearts(health.HeartContainers or 0)
		player:AddBoneHearts(health.Bone or 0)
		player:AddHearts(health.Red or 0)
		player:AddEternalHearts(health.Eternal or 0)
		player:AddSoulHearts(health.Soul or 0)
		player:AddBlackHearts(health.Black or 0)
		if isMainTwin then
			player_run_save.BirthdayPartySavedHealth = nil
		end
		if Mod:GetAllHearts(player) == 0 then
			player:AddMaxHearts(2)
		end
	end
end

---@param player EntityPlayer
function BIRTHDAY_PARTY:SaveCurrentHealth(player)
	local player_run_save = Mod:RunSave(player)
	if not player_run_save.BirthdayPartySavedHealth then
		local HeartContainers = player:GetMaxHearts()
		local Red = player:GetHearts()
		local Bone = player:GetBoneHearts()
		local Soul = Mod:GetPlayerRealSoulHeartsCount(player) + player:GetSoulCharge()
		local Black = Mod:GetPlayerRealBlackHeartsCount(player)
		local Rotten = player:GetRottenHearts()
		local Eternal = player:GetEternalHearts()
		local twin = player:GetOtherTwin()
		local otherForgor = player:GetSubPlayer()
		if twin then
			HeartContainers = HeartContainers + twin:GetMaxHearts()
			Red = Red + twin:GetHearts()
			Bone = Bone + twin:GetBoneHearts()
			Soul = Soul + Mod:GetPlayerRealSoulHeartsCount(twin)
			Black = Black + Mod:GetPlayerRealBlackHeartsCount(twin)
			Rotten = Rotten + twin:GetRottenHearts()
			Eternal = Eternal + twin:GetEternalHearts()
		elseif otherForgor then
			HeartContainers = HeartContainers + otherForgor:GetMaxHearts()
			Red = Red + otherForgor:GetHearts()
			Bone = Bone + otherForgor:GetBoneHearts()
			Soul = Soul + Mod:GetPlayerRealSoulHeartsCount(otherForgor)
			Black = Black + Mod:GetPlayerRealBlackHeartsCount(otherForgor)
			Rotten = Rotten + otherForgor:GetRottenHearts()
			Eternal = Eternal + otherForgor:GetEternalHearts()
		end

		player_run_save.BirthdayPartySavedHealth = {
			HeartContainers = HeartContainers,
			Red = Red,
			Bone = Bone,
			Soul = Soul,
			Black = Black,
			Rotten = Rotten,
			Eternal = Eternal,
		}
	end
end

--#endregion

--#region Change PlayerTypes

function BIRTHDAY_PARTY:RefreshCharacterList()
	local run_save = Mod:RunSave()
	run_save.BirthdayPartyCharacterList = run_save.BirthdayPartyCharacterList or {}
	for _, playerType in ipairs(CHARACTER_LIST) do
		run_save.BirthdayPartyCharacterList[#run_save.BirthdayPartyCharacterList + 1] = playerType
	end
end

---@param player EntityPlayer
function BIRTHDAY_PARTY:OnChallengeStart(player)
	if Isaac.GetChallenge() == BIRTHDAY_PARTY.ID then
		local level = Mod.Game:GetLevel()
		if Mod.Game:GetFrameCount() == 0
			or (level:GetCurrentRoomIndex() == level:GetStartingRoomIndex()
				and level:GetStage() == LevelStage.STAGE1_1
				and Mod.Game:GetRoom():IsFirstVisit()
				and not player:HasTrinket(Mod.Birthcake.ID))
		then
			player:AddTrinket(Mod.Birthcake.ID, false)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BIRTHDAY_PARTY.OnChallengeStart)

function BIRTHDAY_PARTY:SwitchCharacter()
	local level = Mod.Game:GetLevel()
	if Isaac.GetChallenge() == BIRTHDAY_PARTY.ID
		and (level:GetStage() ~= LevelStage.STAGE1_1 or level:IsAscent())
	then
		local run_save = Mod:RunSave()
		if not run_save.BirthdayPartyCharacterList or #run_save.BirthdayPartyCharacterList == 0 then
			BIRTHDAY_PARTY:RefreshCharacterList()
			for i, availablePlayerType in ipairs(run_save.BirthdayPartyCharacterList) do
				if Isaac.GetPlayer():GetPlayerType() == availablePlayerType then
					table.remove(run_save.BirthdayPartyCharacterList, i)
					break
				end
			end
		end
		local randomIndex = Mod.GENERIC_RNG:RandomInt(#run_save.BirthdayPartyCharacterList) + 1
		local selectedPlayerType = run_save.BirthdayPartyCharacterList[randomIndex]
		table.remove(run_save.BirthdayPartyCharacterList, randomIndex)

		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			local player = ent:ToPlayer() ---@cast player EntityPlayer
			if player.Parent or GetPtrHash(player:GetMainTwin()) ~= GetPtrHash(player) then goto skipPlayer end
			local playerType = player:GetPlayerType()
			if player:HasTrinket(Mod.Birthcake.ID) then
				player:TryRemoveTrinket(Mod.Birthcake.ID)
			end

			if selectedPlayerType == PlayerType.PLAYER_BLUEBABY then
				local maxHearts = player:GetMaxHearts()
				if maxHearts > 0 then
					player:AddMaxHearts(-maxHearts)
					player:AddSoulHearts(maxHearts)
				end
			elseif selectedPlayerType == PlayerType.PLAYER_KEEPER or selectedPlayerType == PlayerType.PLAYER_THELOST then
				BIRTHDAY_PARTY:SaveCurrentHealth(player)
			end

			if BIRTHDAY_PARTY.CharacterResets[playerType] then
				BIRTHDAY_PARTY.CharacterResets[playerType](player)
			end

			player:ChangePlayerType(selectedPlayerType)
			playerType = player:GetPlayerType()

			if BIRTHDAY_PARTY.CharacterRewards[playerType] then
				BIRTHDAY_PARTY.CharacterRewards[playerType](player)
			end
			if selectedPlayerType ~= PlayerType.PLAYER_KEEPER and selectedPlayerType ~= PlayerType.PLAYER_THELOST then
				BIRTHDAY_PARTY:GrantSavedHealth(player)
			end
			Mod:GetData(player).BirthdayPartyQueueBirthcake = true
			::skipPlayer::
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BIRTHDAY_PARTY.SwitchCharacter)

---@param player EntityPlayer
function BIRTHDAY_PARTY:OnPeffectUpdate(player)
	if Isaac.GetChallenge() == BIRTHDAY_PARTY.ID then
		local data = Mod:GetData(player)
		if data.BirthdayPartyQueueBirthcake then
			player:QueueItem(Mod.ItemConfig:GetTrinket(Mod.Birthcake.ID))
			Mod.SFXManager:Play(SoundEffect.SOUND_SHELLGAME)
			data.BirthdayPartyQueueBirthcake = nil
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, BIRTHDAY_PARTY.OnPeffectUpdate)

--#endregion

--#region No more trinekts

---@param pickup EntityPickup
function BIRTHDAY_PARTY:NoTrinkets(pickup)
	if Isaac.GetChallenge() == BIRTHDAY_PARTY.ID
		and pickup.SubType ~= Mod.Birthcake.ID
		and pickup.SubType ~= TrinketType.TRINKET_NULL
		and Isaac.GetPlayer():GetPlayerType() ~= PlayerType.PLAYER_APOLLYON
	then
		local rng = Mod.GENERIC_RNG
		pickup:Morph(pickup.Type, (rng:RandomInt(4) + 1) * 10, 0)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BIRTHDAY_PARTY.NoTrinkets, PickupVariant.PICKUP_TRINKET)

--#endregion

--#region Complete challenge

if REPENTOGON then
	function BIRTHDAY_PARTY:CheckBeastDeath(npc)
		if npc.Variant == 0
			and Isaac.GetChallenge() == Mod.Challenges.BIRTHDAY_PARTY.ID
		then
			Isaac.ClearChallenge(Mod.Challenges.BIRTHDAY_PARTY.ID)
		end
	end

	Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, BIRTHDAY_PARTY.CheckBeastDeath, EntityType.ENTITY_BEAST)
end

--#endregion