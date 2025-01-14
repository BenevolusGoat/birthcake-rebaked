local Mod = BirthcakeRebaked
local game = Mod.Game

local ISAAC_CAKE = {}

BirthcakeRebaked.Birthcake.ISAAC = ISAAC_CAKE

-- Isaac Birthcake

function ISAAC_CAKE:SpawnTreasureDiceShard()
	local room = Mod.Game:GetRoom()
	if room:GetType() ~= RoomType.ROOM_TREASURE then return end
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
			for _ = 1, Mod:GetTrinketMult(player) do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD,
					room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, player)
			end
		end
	end)
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, ISAAC_CAKE.SpawnTreasureDiceShard)

function ISAAC_CAKE:SpawnBossDiceShard()
	local room = Mod.Game:GetRoom()
	if room:GetType() ~= RoomType.ROOM_BOSS then return end
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
			for _ = 1, Mod:GetTrinketMult(player) do
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD,
					room:FindFreePickupSpawnPosition(room:GetCenterPos() - Vector(0, 40)), Vector.Zero, player)
			end
		end
	end)
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.EARLY, ISAAC_CAKE.SpawnBossDiceShard)

-- Isaac B Birthcake

function ISAAC_CAKE:ItemWillFillInventory(itemID)
	local itemConfig = Mod.ItemConfig:GetCollectible(itemID)
	if (itemConfig.Type == ItemType.ITEM_PASSIVE or itemConfig.Type == ItemType.ITEM_FAMILIAR)
		and not itemConfig:HasTags(ItemConfig.TAG_QUEST)
	then
		return true
	end
end

---@param pickup EntityPickup
---@param collider Entity
function ISAAC_CAKE:PrePickupCollision(pickup, collider)
	local player = collider:ToPlayer()
	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC_B)
		and pickup.SubType ~= CollectibleType.COLLECTIBLE_NULL
		and player:IsExtraAnimationFinished()
		and ISAAC_CAKE:ItemWillFillInventory(pickup.SubType)
		and ISAAC_CAKE:IsFullInventory(player)
	then
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		local inventory = player_run_save.IsaacBBirthcakeInventory
		if not inventory then
			inventory = {}
			player_run_save.IsaacBBirthcakeInventory = inventory
		end
		if #inventory < player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID) then
			inventory[#inventory + 1] = pickup.SubType
			Mod:AwardPedestalItem(pickup, player)
			return false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, ISAAC_CAKE.PrePickupCollision, PickupVariant.PICKUP_COLLECTIBLE)

-- Difference in code is stark enough that I'm separating the files for the convenience of my own eyes
if REPENTOGON then
	include("src_birthcake.characters.isaac_b.isaac_b_rgon")
else
	include("src_birthcake.characters.isaac_b.isaac_b")
end

local inventorySprite = Sprite()
inventorySprite:Load("gfx/ui/ui_inventory.anm2", false)
inventorySprite:Play("Idle")
inventorySprite:ReplaceSpritesheet(0, "gfx/ui/ui_inventory_birthcake.png")
inventorySprite:ReplaceSpritesheet(1, "gfx/ui/ui_inventory_birthcake.png")
inventorySprite:LoadGraphics()

local NUM_COLUMNS = 4

HudHelper.RegisterHUDElement({
	Name = "Isaac B Birthcake Inventory",
	Priority = 0.5, --Between vanilla and highest, lol
	XPadding = -4,
	YPadding = function(player)
		local inventoryCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		local numRows = math.ceil(inventoryCap / NUM_COLUMNS)
		local desiredPadding = 16 + (12 * (numRows - 1))
		return desiredPadding
	end,
	Condition = function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC_B) then
			local inventoryCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
			return inventoryCap > 0
		end
		return false
	end,
	OnRender = function(player, playerHUDIndex, _, position)
		local inventoryCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		local player_run_save = Mod.SaveManager.GetRunSave(player)
		local inventory = player_run_save.IsaacBBirthcakeInventory
		local isAtTop = playerHUDIndex < 2
		local yOffset = isAtTop and 12 or -12
		local data = Mod:GetData(player)
		position = position + Vector(0, 8)

		for i = 0, inventoryCap - 1 do
			local renderPos = position + Vector(12 * (i % NUM_COLUMNS), yOffset * (i // NUM_COLUMNS))
			inventorySprite:RenderLayer(0, renderPos)
			local itemID = inventory and inventory[i + 1]
			if not itemID then goto continue end
			if not data.IsaacBBirthcakeInventorySprites
				or not data.IsaacBBirthcakeInventorySprites[itemID]
			then
				local itemSprite = Sprite()
				itemSprite:Load("gfx/005.100_collectible.anm2", false)
				itemSprite:Play("PlayerPickup")
				itemSprite:ReplaceSpritesheet(1, Mod.ItemConfig:GetCollectible(itemID).GfxFileName)
				itemSprite:LoadGraphics()
				itemSprite.Scale = Vector(0.5, 0.5)
				itemSprite.Offset = Vector(0, 4)
				if not data.IsaacBBirthcakeInventorySprites then
					data.IsaacBBirthcakeInventorySprites = {}
				end
				data.IsaacBBirthcakeInventorySprites[itemID] = itemSprite
			end
			local itemSprite = data.IsaacBBirthcakeInventorySprites[itemID]

			itemSprite.Color = Color(0, 0, 0, 0.5)
			itemSprite:Render(renderPos + Vector(1, 1))
			itemSprite.Color = Color.Default
			itemSprite:Render(renderPos)
			::continue::
		end
	end
}, HudHelper.HUDType.EXTRA)
