local Mod = BirthcakeRebaked
local game = Mod.Game

local APOLLYON_CAKE = {}
BirthcakeRebaked.Birthcake.APOLLYON = APOLLYON_CAKE

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
			Mod:AddSmeltedTrinkets(player, trinketList)
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
			Mod:RemoveSmeltedTrinkets(player, trinketList)
		end
	elseif not player_run_save.ApollyonBirthcakeHasVoid and player:HasCollectible(CollectibleType.COLLECTIBLE_VOID) then
		local trinketList = player_run_save.ApollyonBirthcakeTrinkets
		if trinketList then
			Mod:AddSmeltedTrinkets(player, trinketList)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, APOLLYON_CAKE.ManageVoidedTrinkets, PlayerType.PLAYER_APOLLYON)

-- Apollyon B Birthcake

--TODO: Add trinket mult interaction

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
