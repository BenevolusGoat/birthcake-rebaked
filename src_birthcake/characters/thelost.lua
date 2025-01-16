local Mod = BirthcakeRebaked
local game = Mod.Game

local THELOST_CAKE = {}
BirthcakeRebaked.Birthcake.THELOST = THELOST_CAKE

-- The Lost Birthcake

---@param player EntityPlayer
function THELOST_CAKE:FreeEternalD6(itemID, rng, player, flags, slot, varData)
	local effects = player:GetEffects()

	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
		and Mod:HasBitFlags(flags, UseFlag.USE_OWNED)
		and effects:HasTrinketEffect(Mod.Birthcake.ID)
		and slot == ActiveSlot.SLOT_PRIMARY
	then
		player:AddCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT, 0, false)
		player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, UseFlag.USE_NOANIM, slot)
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
		effects:RemoveTrinketEffect(Mod.Birthcake.ID)
		player:AnimateCollectible(CollectibleType.COLLECTIBLE_ETERNAL_D6, "UseItem", "PlayerPickupSparkle")
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		Mod:GetData(player).FullChargeED6 = true
		return true
	end
end

Mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, THELOST_CAKE.FreeEternalD6, CollectibleType.COLLECTIBLE_ETERNAL_D6)

function THELOST_CAKE:RechargeD6(player)
	local data = Mod:GetData(player)
	if data.FullChargeED6 then
		player:FullCharge(ActiveSlot.SLOT_PRIMARY)
		data.FullChargeED6 = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, THELOST_CAKE.RechargeD6, PlayerType.PLAYER_THELOST)

---@param itemID CollectibleType
function THELOST_CAKE:IsValidActiveItem(itemID)
	local itemConfig = Mod.ItemConfig:GetCollectible(itemID)
	return itemConfig.ChargeType == ItemConfig.CHARGE_NORMAL
	and itemConfig.MaxCharges > 0
	and itemConfig.MaxCharges <= 12
end

---@param player EntityPlayer
function THELOST_CAKE:FreeActiveUse(itemID, rng, player, flags, slot, varData)
	if itemID == CollectibleType.COLLECTIBLE_ETERNAL_D6 then return end
	local effects = player:GetEffects()

	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
		and Mod:HasBitFlags(flags, UseFlag.USE_OWNED)
		and effects:HasTrinketEffect(Mod.Birthcake.ID)
		and THELOST_CAKE:IsValidActiveItem(itemID)
	then
		effects:RemoveTrinketEffect(Mod.Birthcake.ID)
		Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
		return {Discharge = false}
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, THELOST_CAKE.FreeActiveUse)

function THELOST_CAKE:OnNewLevel()
	Mod:ForEachPlayer(function(player)
		if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST) then
			local effects = player:GetEffects()
			effects:AddTrinketEffect(Mod.Birthcake.ID, false, 1 + Mod:GetTrinketMult(player))
		end
	end)
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, THELOST_CAKE.OnNewLevel)

---@param player EntityPlayer
---@param firstTime boolean
---@param isGolden boolean
function THELOST_CAKE:OnCollectBirthcake(player, firstTime, isGolden)
	if firstTime then
		local effects = player:GetEffects()
		effects:AddTrinketEffect(Mod.Birthcake.ID, false, 1 + Mod:GetTrinketMult(player))
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, THELOST_CAKE.OnCollectBirthcake, PlayerType.PLAYER_THELOST)

local font = Font()
font:Load("font/pftempestasevencondensed.fnt")

local blueChargebar = Sprite()
blueChargebar:Load("gfx/ui/ui_chargebar.anm2", false)
blueChargebar:ReplaceSpritesheet(0, "gfx/ui/ui_chargebar_birthcake.png")
blueChargebar:LoadGraphics()

local chargeAnimations = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
	[8] = true,
	[12] = true,
}

HudHelper.RegisterHUDElement({
	Name = "Lost Birthcake Chargebar",
	Priority = HudHelper.Priority.HIGH,
	Condition = function(player, playerHUDIndex, hudLayout, slot)
		return Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
			and HudHelper.ShouldActiveBeDisplayed(player, player:GetActiveItem(slot), slot)
			and slot == ActiveSlot.SLOT_PRIMARY
			and player:GetEffects():HasTrinketEffect(Mod.Birthcake.ID)
			and not player:NeedsCharge(slot)
			and THELOST_CAKE:IsValidActiveItem(player:GetActiveItem(slot))
	end,
	OnRender = function(player, playerHUDIndex, hudLayout, position, alpha, scale, slot)
		local maxCharges = Mod.ItemConfig:GetCollectible(player:GetActiveItem(slot)).MaxCharges
		local barAnim = chargeAnimations[maxCharges] and maxCharges or 1
		local chargebarPos = position + Vector(34 * scale, 17 * scale)
		blueChargebar.Color = Color(1,1,1,alpha)
		blueChargebar.Scale = Vector(scale, scale)
		blueChargebar:Play("BarFull")
		blueChargebar:Render(chargebarPos)
		blueChargebar:Play("BarOverlay" .. barAnim)
		blueChargebar:Render(chargebarPos)
	end
}, HudHelper.HUDType.ACTIVE)

HudHelper.RegisterHUDElement({
	Name = "Lost Birthcake Rerolls",
	Priority = HudHelper.Priority.NORMAL,
	XPadding = -18,
	YPadding = 10,
	Condition = function(player, _, _)
		return player:GetEffects():HasTrinketEffect(Mod.Birthcake.ID)
	end,
	OnRender = function(player, _, _, position)
		local data = Mod:GetData(player)
		local textPos = position + Vector(14, 0)
		if not data.LostBirthcakeSprite then
			local sprite = Sprite()
			sprite:Load("gfx/items/trinkets/thelost_birthcake.anm2", true)
			sprite:Play("Idle")
			sprite.Offset = Vector(0, 1)
			data.LostBirthcakeSprite = sprite
		end
		local isValid = THELOST_CAKE:IsValidActiveItem(player:GetActiveItem(ActiveSlot.SLOT_PRIMARY))
		local numUses = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		if isValid then
			data.LostBirthcakeSprite.Color = Color(1, 1, 1, 1)
		else
			data.LostBirthcakeSprite.Color = Color(1, 1, 1, 0.5)
		end
		HudHelper.Utils.RenderFont("x" .. numUses, textPos)
		data.LostBirthcakeSprite:Render(position)
	end
}, HudHelper.HUDType.EXTRA)

-- Tainted Lost Birthcake

--TODO: Revisit
