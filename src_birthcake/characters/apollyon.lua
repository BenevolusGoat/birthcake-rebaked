local Mod = BirthcakeRebaked
local game = Mod.Game

local APOLLYON_CAKE = {}
BirthcakeRebaked.Birthcake.APOLLYON = APOLLYON_CAKE

---@param player EntityPlayer
---@param trinketList {TrinketType: TrinketType, FirstTime: boolean}[] | TrinketType[]
function APOLLYON_CAKE:AddVoidedTrinkets(player, trinketList)
	local trinket0 = player:GetTrinket(0)
	local trinket1 = player:GetTrinket(1)
	if not REPENTOGON then
		player:TryRemoveTrinket(trinket0)
		player:TryRemoveTrinket(trinket1)
	end
	for _, trinketData in ipairs(trinketList) do
		local trinketID = type(trinketData) == "table" and trinketData.TrinketType or trinketData
		local firstPickup = type(trinketData) == "table" and trinketData.FirstTime or false
		---@cast trinketID TrinketType
		---@cast firstPickup boolean

		if REPENTOGON then
			player:AddSmeltedTrinket(trinketID)
		else
			player:AddTrinket(trinketID, firstPickup)
			player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)
		end
	end
	if not REPENTOGON then
		player:AddTrinket(trinket0)
		player:AddTrinket(trinket1)
	end
end

---@param player EntityPlayer
function APOLLYON_CAKE:OnPlayerInit(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	player_run_save.ApollyonBirthcakeHasVoid = player:HasCollectible(CollectibleType.COLLECTIBLE_VOID)
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, APOLLYON_CAKE.OnPlayerInit)

---@param player EntityPlayer
function APOLLYON_CAKE:OnVoidUse(itemID, player, rng, flags, slot, varData)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_APOLLYON) then
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		local trinketList = {}
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
			local pickup = ent:ToPickup()
			---@cast pickup EntityPickup
			table.insert(trinketList, {TrinketType = pickup.SubType, FirstTime = pickup.Touched})
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
			poof.SpriteScale = Vector(0.5, 0.5)
			poof.Color = Color(1, 0, 0.65)
			pickup.Timeout = 4

			player_run_save.ApollyonBirthcakeTrinkets = player_run_save.ApollyonBirthcakeTrinkets or {}
			player_run_save.ApollyonBirthcakeTrinkets[tostring(pickup.SubType)] = (player_run_save.ApollyonBirthcakeTrinkets[tostring(pickup.SubType)] or 0) + 1
		end
		if #trinketList > 0 then
			APOLLYON_CAKE:AddVoidedTrinkets(player, trinketList)
		end
	end
end

---@param player EntityPlayer
---@param trinketList {[string]: integer}[]
function APOLLYON_CAKE:RemoveVoidedTrinkets(player, trinketList)
	for trinketIDStr, trinketNum in pairs(trinketList) do
		local trinketID = tonumber(trinketIDStr)
		---@cast trinketID TrinketType

		for _ = 1, trinketNum do
			if REPENTOGON then
				player:TryRemoveSmeltedTrinket(trinketID)
			else
				player:TryRemoveTrinket(trinketID)
			end
		end
	end
end

---@param player EntityPlayer
function APOLLYON_CAKE:ManageVoidedTrinkets(player)
	if not player:HasTrinket(Mod.Birthcake.ID) then return end
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	if player_run_save.ApollyonBirthcakeHasVoid and not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
		player_run_save.ApollyonBirthcakeHasVoid = false
		local trinketList = player_run_save.ApollyonBirthcakeTrinkets
		if trinketList then
			APOLLYON_CAKE:RemoveVoidedTrinkets(player, trinketList)
		end
	elseif not player_run_save.ApollyonBirthcakeHasVoid and player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
		local trinketList = player_run_save.ApollyonBirthcakeTrinkets
		if trinketList then
			APOLLYON_CAKE:AddVoidedTrinkets(player, trinketList)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, APOLLYON_CAKE.ManageVoidedTrinkets, PlayerType.PLAYER_APOLLYON)

-- Apollyon B Birthcake

function APOLLYON_CAKE:TaintedTrinketConsumer(_, _, player, _, _, _)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_APOLLYON_B) then
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
			local pickup = ent:ToPickup()
			---@cast pickup EntityPickup

			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
			poof.SpriteScale = Vector(0.5, 0.5)
			poof.Color = Color(1, 0, 0)
			pickup.Timeout = 4

			if REPENTOGON then
				player:AddLocust(CollectibleType.COLLECTIBLE_HALO_OF_FLIES, pickup.Position)
			else
				Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, CollectibleType.COLLECTIBLE_HALO_OF_FLIES,
				pickup.Position, Vector.Zero, player)
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, APOLLYON_CAKE.TaintedTrinketConsumer, CollectibleType.COLLECTIBLE_ABYSS)
