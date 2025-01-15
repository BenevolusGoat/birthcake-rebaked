local Mod = BirthcakeRebaked
local game = Mod.Game

local LAZARUS_CAKE = {}
BirthcakeRebaked.Birthcake.LAZARUS = LAZARUS_CAKE

-- Lazarus Birthcake

---@param ent Entity
---@param amount integer
function LAZARUS_CAKE:DeathBringer(ent, amount)
	local player = ent:ToPlayer()
	---@cast player EntityPlayer

	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_LAZARUS)
		and Mod:IsPlayerTakingMortalDamage(player, amount)
		and player:WillPlayerRevive()
	then
		Mod:GetData(player).CheckLazarusRisen = true
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, LAZARUS_CAKE.DeathBringer, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function LAZARUS_CAKE:AliveMonger(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and Mod:GetAllHearts(player) > 0
		and Mod:GetData(player).CheckLazarusRisen
		and player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2
	then
		for _ = 1, player:GetTrinketMultiplier(Mod.Birthcake.ID) do
			player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM)
		end
		player:AddSoulHearts(1)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, LAZARUS_CAKE.AliveMonger, PlayerType.PLAYER_LAZARUS2)

-- Tainted Lazarus Birthcake

function LAZARUS_CAKE:NewGame()
	--[[ LazarusItem = {}
	DeadLazarusItem = {}
	SharedItem = -1
	dead = false
	lazarusRisen = false
	upgraded = false ]]
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, LAZARUS_CAKE.NewGame)

function LAZARUS_CAKE:UpdateItems()
	--[[ local player = game:GetPlayer(0)

	if not LAZARUS_CAKE:CheckLazarusB(player) then
		return
	end

	if not player:HasTrinket(Mod.Birthcake.ID) then
		if SharedItem ~= -1 then
			player:GetEffects():RemoveCollectibleEffect(SharedItem)
			SharedItem = -1
		end
	end

	if player:HasTrinket(Mod.Birthcake.ID) then
		if Mod:GetTrinketMult(player, true) > 1 then
			upgraded = true
		else
			upgraded = false
		end
	end

	local ItemCount = Isaac:GetItemConfig():GetCollectibles().Size - 1
	for i = 1, ItemCount do
		local itemConfig = Mod.ItemConfig:GetCollectible(i)
		if player:HasCollectible(i, true) and (itemConfig.Type == ItemType.ITEM_PASSIVE or itemConfig.Type == ItemType.ITEM_FAMILIAR) and not itemConfig:HasTags(ItemConfig.TAG_LAZ_SHARED) and not itemConfig:HasTags(ItemConfig.TAG_LAZ_SHARED_GLOBAL) then
			if upgraded and itemConfig.Quality == 0 then
				goto continue
			end
			local playerType = player:GetPlayerType()
			if playerType == PlayerType.PLAYER_LAZARUS_B and not Mod:IsInList(i, LazarusItem) then
				table.insert(LazarusItem, i)
			elseif playerType == PlayerType.PLAYER_LAZARUS2_B and not Mod:IsInList(i, DeadLazarusItem) then
				table.insert(DeadLazarusItem, i)
			end
		end
		::continue::
	end
	local playerType = player:GetPlayerType()
	for i = 1, #LazarusItem do
		if not player:HasCollectible(LazarusItem[i], true) and playerType == PlayerType.PLAYER_LAZARUS_B then
			table.remove(LazarusItem, i)
		end
		local itemConfig = Mod.ItemConfig:GetCollectible(LazarusItem[i])
		if upgraded and itemConfig.Quality == 0 then
			table.remove(LazarusItem, i)
		end
	end
	for i = 1, #DeadLazarusItem do
		if not player:HasCollectible(DeadLazarusItem[i], true) and playerType == PlayerType.PLAYER_LAZARUS2_B then
			table.remove(DeadLazarusItem, i)
		end
		local itemConfig = Mod.ItemConfig:GetCollectible(DeadLazarusItem[i])
		if upgraded and itemConfig.Quality == 0 then
			table.remove(DeadLazarusItem, i)
		end
	end ]]
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, LAZARUS_CAKE.UpdateItems)

function LAZARUS_CAKE:Gift()
	--[[ local player = game:GetPlayer(0)
	if not LAZARUS_CAKE:CheckLazarusB(player) or not player:HasTrinket(Mod.Birthcake.ID) then
		return nil
	end

	if SharedItem ~= -1 then
		player:GetEffects():RemoveCollectibleEffect(SharedItem)
		SharedItem = -1
	end

	local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
	local playerType = player:GetPlayerType()
	if playerType == PlayerType.PLAYER_LAZARUS_B then
		if #DeadLazarusItem > 0 then
			SharedItem = DeadLazarusItem[rng:RandomInt(#DeadLazarusItem) + 1]
		end
	elseif playerType == PlayerType.PLAYER_LAZARUS2_B then
		if #LazarusItem > 0 then
			SharedItem = LazarusItem[rng:RandomInt(#LazarusItem) + 1]
		end
	end

	Isaac.ConsoleOutput("Shared Item: " .. tostring(SharedItem) .. "\n")
	if SharedItem ~= -1 then
		player:GetEffects():AddCollectibleEffect(SharedItem)
	end ]]
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, LAZARUS_CAKE.Gift)
