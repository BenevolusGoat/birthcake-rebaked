local Mod = BirthcakeRebaked

local BIRTHDAY_PARTY = {}
BirthcakeRebaked.CHALLENGE_BIRTHDAY_PARTY = BIRTHDAY_PARTY

BIRTHDAY_PARTY.ID = Isaac.GetChallengeIdByName("Isaac's Birthday Party")

BIRTHDAY_PARTY.CharacterLineSkip = {
	[PlayerType.PLAYER_THELOST] = PlayerType.PLAYER_LILITH,
	[PlayerType.PLAYER_THEFORGOTTEN] = PlayerType.PLAYER_BETHANY,
	[PlayerType.PLAYER_JACOB] = PlayerType.PLAYER_ISAAC_B,
	[PlayerType.PLAYER_JACOB_B] = PlayerType.PLAYER_ISAAC
}

---@type {[PlayerType]: fun(player: EntityPlayer)}
BIRTHDAY_PARTY.CharacterRewards = {
	[PlayerType.PLAYER_MAGDALENE] = function(player)
		local room = Mod.Game:GetRoom()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
			CollectibleType.COLLECTIBLE_YUM_HEART, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
	end,
	[PlayerType.PLAYER_THELOST] = function(player)
		local room = Mod.Game:GetRoom()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
			CollectibleType.COLLECTIBLE_ETERNAL_D6, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
	end,
	[PlayerType.PLAYER_LILITH] = function(player)
		local room = Mod.Game:GetRoom()
		player:AddBlackHearts(2)
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
			CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
	end,
	[PlayerType.PLAYER_KEEPER] = function(player)
		player:AddHearts(4)
	end,
	[PlayerType.PLAYER_APOLLYON] = function(player)
		local room = Mod.Game:GetRoom()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_VOID,
			room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
	end,
	[PlayerType.PLAYER_BETHANY] = function(player)
		local room = Mod.Game:GetRoom()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
			CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, room:GetCenterPos() + Vector(-0, -80), Vector(0, 0), nil)
	end,
	[PlayerType.PLAYER_LILITH_B] = function(player)
		player:AddBlackHearts(2)
	end,
	[PlayerType.PLAYER_THEFORGOTTEN] = function(player)
		player:AddSoulHearts(2)
	end,
	[PlayerType.PLAYER_KEEPER_B] = function(player)
		player:AddHearts(2)
		Mod.Birthcake.KEEPER:SpawnMiniShop()
	end
}

function BIRTHDAY_PARTY:OnChallengeStart()
	if Isaac.GetChallenge() == BIRTHDAY_PARTY.ID then
		local room = Mod.Game:GetRoom()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, Mod.Birthcake.ID,
			room:GetCenterPos(), Vector.Zero, nil)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BIRTHDAY_PARTY.OnChallengeStart)

function BIRTHDAY_PARTY:SwitchCharacter()
	if Mod.Game.Challenge == BIRTHDAY_PARTY.ID
		and Mod.Game:GetLevel():GetStage() ~= LevelStage.STAGE1_1
	then
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do
			local player = ent:ToPlayer() ---@cast player EntityPlayer
			local playerType = player:GetPlayerType()
			if player:HasTrinket(Mod.Birthcake.ID) then
				player:TryRemoveTrinket(Mod.Birthcake.ID)
			end

			player:ChangePlayerType(BIRTHDAY_PARTY.CharacterLineSkip[playerType] or playerType)
			playerType = player:GetPlayerType()

			if player:GetMaxHearts() == 0 then
				player:AddMaxHearts(4)
				player:AddHearts(4)
			elseif player:CanPickSoulHearts() and player:GetMaxHearts() == 0 and player:GetSoulHearts() <= 5 then
				player:AddSoulHearts(6)
			end

			BIRTHDAY_PARTY.CharacterRewards[playerType](player)
			player:QueueItem(Mod.ItemConfig:GetTrinket(Mod.Birthcake.ID))
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BIRTHDAY_PARTY.SwitchCharacter)
