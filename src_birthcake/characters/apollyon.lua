local Mod = BirthcakeRebaked
local game = Mod.Game

local APOLLYON_CAKE = {}
BirthcakeRebaked.Birthcake.APOLLYON = APOLLYON_CAKE

---@param player EntityPlayer
function APOLLYON_CAKE:OnPlayerInit(player)
	if player:GetPlayerType() == PlayerType.PLAYER_APOLLYON then
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		player_run_save.ApollyonBirthcakeHasVoid = player:HasCollectible(CollectibleType.COLLECTIBLE_VOID)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, APOLLYON_CAKE.OnPlayerInit)

---@param player EntityPlayer
function APOLLYON_CAKE:OnVoidUse(itemID, rng, player, flags, slot, varData)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_APOLLYON) then
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		local trinketList = {}
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)) do
			local pickup = ent:ToPickup()
			---@cast pickup EntityPickup
			table.insert(trinketList, {TrinketType = pickup.SubType, FirstTime = pickup.Touched})
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, Vector.Zero, nil)
			poof.SpriteScale = Vector(0.5, 0.5)
			poof.Color = Color(0.6, 0.35, 0.6)
			pickup.Timeout = 4

			player_run_save.ApollyonBirthcakeTrinkets = player_run_save.ApollyonBirthcakeTrinkets or {}
			table.insert(player_run_save.ApollyonBirthcakeTrinkets, pickup.SubType)
		end
		if #trinketList > 0 then
			Mod:AddSmeltedTrinkets(player, trinketList)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, APOLLYON_CAKE.OnVoidUse, CollectibleType.COLLECTIBLE_VOID)

---Even if you LOSE Birthcake or are no longer Apollyon, the items are tied to Void, so you should keep the voided trinkets, just can't void any further ones
---@param player EntityPlayer
function APOLLYON_CAKE:ManageVoidedTrinkets(player)
	local player_run_save = Mod.SaveManager.GetRunSave(player)
	if player_run_save.ApollyonBirthcakeHasVoid and not player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
		player_run_save.ApollyonBirthcakeHasVoid = false
		local trinketList = player_run_save.ApollyonBirthcakeTrinkets
		if trinketList then
			Mod:RemoveSmeltedTrinkets(player, trinketList)
		end
	--It's nil if you've never been Apollyon with Void
	elseif player_run_save.ApollyonBirthcakeHasVoid == false
		and player:HasCollectible(CollectibleType.COLLECTIBLE_VOID)
		and not player.QueuedItem.Item
	then
		player_run_save.ApollyonBirthcakeHasVoid = true
		local trinketList = player_run_save.ApollyonBirthcakeTrinkets
		if trinketList then
			Mod:AddSmeltedTrinkets(player, trinketList)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, APOLLYON_CAKE.ManageVoidedTrinkets)

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

			local familiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ABYSS_LOCUST, CollectibleType.COLLECTIBLE_HALO_OF_FLIES,
			pickup.Position, Vector.Zero, player)
			familiar:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, APOLLYON_CAKE.TaintedTrinketConsumer, CollectibleType.COLLECTIBLE_ABYSS)
