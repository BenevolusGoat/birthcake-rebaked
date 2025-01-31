--#region Variables

local Mod = BirthcakeRebaked

local BIRTHDAY_PARTY = {}
BirthcakeRebaked.CHALLENGE_BIRTHDAY_PARTY = BIRTHDAY_PARTY

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
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				CollectibleType.COLLECTIBLE_POOP, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_EVE] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_DEAD_BIRD) then
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
			CollectibleType.COLLECTIBLE_DEAD_BIRD, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_SAMSON] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BLOODY_LUST) then
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				CollectibleType.COLLECTIBLE_BLOODY_LUST, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_LILITH] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS) then
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_APOLLYON] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_VOID,
				room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_BETHANY] = function(player)
		if not player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
			local room = Mod.Game:GetRoom()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
				CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
		end
	end,
	[PlayerType.PLAYER_KEEPER] = function(player)
		local maxHearts = player:GetMaxHearts()
		if maxHearts < 6 then
			player:AddMaxHearts(6 - maxHearts)
		end
	end,
	[PlayerType.PLAYER_THEFORGOTTEN] = function(player)
		if player:GetSoulHearts() == 0 then
			player:AddSoulHearts(2)
		end
	end
}

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
	if Isaac.GetChallenge() == BIRTHDAY_PARTY.ID
		and Mod.Game:GetLevel():GetStage() ~= LevelStage.STAGE1_1
	then
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			local player = ent:ToPlayer() ---@cast player EntityPlayer
			local playerType = player:GetPlayerType()
			if player:HasTrinket(Mod.Birthcake.ID) then
				player:TryRemoveTrinket(Mod.Birthcake.ID)
			end
			local run_save = Mod:RunSave()
			if not run_save.BirthdayPartyCharacterList or #run_save.BirthdayPartyCharacterList == 0 then
				local removeIsaac = run_save.BirthdayPartyCharacterList == nil
				BIRTHDAY_PARTY:RefreshCharacterList()
				if removeIsaac then
					table.remove(run_save.BirthdayPartyCharacterList, 1)
				end
			end

			local randomPlayerType = Mod.GENERIC_RNG:RandomInt(#run_save.BirthdayPartyCharacterList) + 1
			if run_save.BirthdayPartyCharacterList[randomPlayerType] == PlayerType.PLAYER_BLUEBABY then
				local maxHearts = player:GetMaxHearts()
				if maxHearts > 0 then
					player:AddMaxHearts(-maxHearts)
					player:AddSoulHearts(maxHearts)
				end
			end

			player:ChangePlayerType(run_save.BirthdayPartyCharacterList[randomPlayerType])
			table.remove(run_save.BirthdayPartyCharacterList, randomPlayerType)
			playerType = player:GetPlayerType()

			if BIRTHDAY_PARTY.CharacterRewards[playerType] then
				BIRTHDAY_PARTY.CharacterRewards[playerType](player)
			end
			Mod:GetData(player).BirthdayPartyQueueBirthcake = true
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BIRTHDAY_PARTY.SwitchCharacter)

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
	if pickup.SubType ~= Mod.Birthcake.ID then
		local rng = Mod.GENERIC_RNG
		pickup:Morph(pickup.Type, (rng:RandomInt(4) + 1) * 10, 0)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, BIRTHDAY_PARTY.NoTrinkets, PickupVariant.PICKUP_TRINKET)

--#endregion
