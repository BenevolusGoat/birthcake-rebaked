local Mod = BirthcakeRebaked
local game = Mod.Game

local ISAAC_CAKE = {}

BirthcakeRebaked.Birthcake.ISAAC = ISAAC_CAKE

-- Isaac Birthcake

function ISAAC_CAKE:OnBirthcakeCollect(player, firstTime)
	if firstTime then
		local room = Mod.Game:GetRoom()
		for _ = 1, Mod:GetTrinketMult(player) do
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD,
				room:FindFreePickupSpawnPosition(player.Position, 40), Vector.Zero, player)
		end
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, ISAAC_CAKE.OnBirthcakeCollect, PlayerType.PLAYER_ISAAC)

local delayHorn = false

function ISAAC_CAKE:SpawnStartingRoomDiceShard()
	local room = Mod.Game:GetRoom()

	if room:IsFirstVisit() and Mod.Game:GetLevel():GetStage() ~= LevelStage.STAGE1_1 then
		Mod:ForEachPlayer(function(player)
			if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC) then
				for _ = 1, Mod:GetTrinketMult(player) do
					Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD,
						room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, true), Vector.Zero, player)
				end
				delayHorn = true
			end
		end)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ISAAC_CAKE.SpawnStartingRoomDiceShard)

function ISAAC_CAKE:PlayPartyHorn()
	if delayHorn then
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		delayHorn = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, ISAAC_CAKE.PlayPartyHorn)

-- Isaac B Birthcake

ISAAC_CAKE.HIDDEN_ITEM_MANAGER_GROUP = "Isaac B Birthcake"

---@param player EntityPlayer
function ISAAC_CAKE:GetMaxInventorySpace(player)
	return player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 12 or 8
end

function ISAAC_CAKE:ItemWillFillInventory(itemID)
	local itemConfig = Mod.ItemConfig:GetCollectible(itemID)
	if itemConfig
		and (itemConfig.Type == ItemType.ITEM_PASSIVE or itemConfig.Type == ItemType.ITEM_FAMILIAR)
		and not itemConfig:HasTags(ItemConfig.TAG_QUEST)
		and itemID ~= CollectibleType.COLLECTIBLE_BIRTHRIGHT
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
		and pickup.Wait == 0
		and player.ItemHoldCooldown == 0
		and Mod:CanPlayerBuyShopItem(player, pickup)
		and ISAAC_CAKE:ItemWillFillInventory(pickup.SubType)
		and ISAAC_CAKE:HasFullInventory(player)
	then
		local player_run_save = Mod:RunSave(player)
		local inventory = player_run_save.IsaacBBirthcakeInventory
		if not inventory then
			inventory = {}
			player_run_save.IsaacBBirthcakeInventory = inventory
		end
		if #inventory < player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID) then
			inventory[#inventory + 1] = pickup.SubType
			Mod.HiddenItemManager:Add(player, pickup.SubType, -1, 1, ISAAC_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
			Mod:PricedPickup(player, pickup)
			local itemConfig = Mod.ItemConfig:GetCollectible(pickup.SubType)
			Mod.Game:GetHUD():ShowItemText(player, itemConfig)
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

---@param player EntityPlayer
function ISAAC_CAKE:ManageBirthrightInventoryCap(player)
	local effects = player:GetEffects()
	local cakeEffects = effects:GetTrinketEffectNum(Mod.Birthcake.ID)
	if cakeEffects > 0 then
		local player_run_save = Mod:RunSave(player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			and not player_run_save.IsaacCakeHasBirthright
		then
			player_run_save.IsaacCakeHasBirthright = true
			local inventory = player_run_save.IsaacBBirthcakeInventory or {}
			while not ISAAC_CAKE:HasFullInventory(player) and #inventory > 0 do
				table.remove(inventory, #inventory)
			end
		elseif not player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
			and player_run_save.IsaacCakeHasBirthright
		then
			player_run_save.IsaacCakeHasBirthright = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, ISAAC_CAKE.ManageBirthrightInventoryCap, PlayerType.PLAYER_ISAAC_B)

---@param player EntityPlayer
function ISAAC_CAKE:OnPlayerTypeChange(player)
	local player_run_save = Mod:RunSave(player)
	if player_run_save.IsaacBBirthcakeInventory then
		for _, itemID in ipairs(player_run_save.IsaacBBirthcakeInventory) do
			player:AddCollectible(itemID, 0, false)
			Mod.HiddenItemManager:Remove(player, itemID, ISAAC_CAKE.HIDDEN_ITEM_MANAGER_GROUP)
		end
		player_run_save.IsaacBBirthcakeInventory = nil
		player_run_save.IsaacBBirthcakeSprites = nil
		player_run_save.IsaacCakeHasBirthright = nil
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_PLAYERTYPE_CHANGE, ISAAC_CAKE.OnPlayerTypeChange, PlayerType.PLAYER_ISAAC_B)

local inventorySprite = Sprite()
inventorySprite:Load("gfx/ui/ui_inventory.anm2", false)
inventorySprite:Play("Idle")
inventorySprite:ReplaceSpritesheet(0, "gfx/ui/ui_inventory_birthcake.png")
inventorySprite:ReplaceSpritesheet(1, "gfx/ui/ui_inventory_birthcake.png")
inventorySprite:LoadGraphics()

local NUM_COLUMNS = 4

local ceil = math.ceil

HudHelper.RegisterHUDElement({
	Name = "Isaac B Birthcake Inventory",
	Priority = HudHelper.Priority.HIGHEST - 0.5, --Between vanilla and highest, lol
	XPadding = -4,
	YPadding = function(player)
		local inventoryCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		local numRows = ceil(inventoryCap / NUM_COLUMNS)
		local desiredPadding = 16 + (12 * (numRows - 1))
		return desiredPadding
	end,
	Condition = function(player)
		return Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_ISAAC_B)
			and player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID) > 0
	end,
	OnRender = function(player, playerHUDIndex, _, position)
		local inventoryCap = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		local player_run_save = Mod:RunSave(player)
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
