local Mod = BirthcakeRebaked
local game = Mod.Game

local JUDAS_CAKE = {}

BirthcakeRebaked.Birthcake.JUDAS = JUDAS_CAKE

function JUDAS_CAKE:JudasHasBirthcake(player)
	return (player:GetPlayerType() == PlayerType.PLAYER_JUDAS or player:GetPlayerType() == PlayerType.PLAYER_BLACKJUDAS)
		and player:HasTrinket(Mod.Birthcake.ID)
end

-- Judas Birthcake

function JUDAS_CAKE:JudasPickup(player)
	if JUDAS_CAKE:JudasHasBirthcake(player) then
		player.Damage = player.Damage + 2 + (player.Damage * 0.1) * Mod:GetTrinketMult(player)
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, JUDAS_CAKE.JudasPickup, CacheFlag.CACHE_DAMAGE)

---@param player EntityPlayer
function JUDAS_CAKE:ExchangeBirthcake(player)
	player:AddBlackHearts(2)
	local trinketMult = Mod:GetTrinketMult(player)
	if trinketMult > 1 then
		player:AddBlackHearts(2)
	end
	player:TryRemoveTrinket(Mod.Birthcake.ID)
	local cooldown = player:HasTrinket(TrinketType.TRINKET_BLIND_RAGE) and 60 or 20
	player:SetMinDamageCooldown(cooldown * (2 * trinketMult))
	Mod.SFXManager:Play(SoundEffect.SOUND_SATAN_GROW)
end

---@param ent Entity
---@param amount integer
---@param flags DamageFlag
---@param source EntityRef
---@param frames integer
function JUDAS_CAKE:PreTakeDamage(ent, amount, flags, source, frames)
	local player = ent:ToPlayer() ---@cast player EntityPlayer
	if JUDAS_CAKE:JudasHasBirthcake(player)
		and BirthcakeRebaked:IsPlayerTakingMortalDamage(player, amount)
	then
		--Adding health to block damage instead of preventing it
		player:AddBlackHearts(amount)
		JUDAS_CAKE:ExchangeBirthcake(player)
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JUDAS_CAKE.PreTakeDamage, EntityType.ENTITY_PLAYER)

---@param player EntityPlayer
function JUDAS_CAKE:CheckHealthOnUpdate(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and BirthcakeRebaked:GetAllHearts(player) == 0
	then
		JUDAS_CAKE:ExchangeBirthcake(player)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, JUDAS_CAKE.CheckHealthOnUpdate, PlayerType.PLAYER_JUDAS)
Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, JUDAS_CAKE.CheckHealthOnUpdate, PlayerType.PLAYER_BLACKJUDAS)

-- Tainted Judas Birthcake

JUDAS_CAKE.DARK_ARTS_CHARGE_BONUS = 20

---@param player EntityPlayer
function JUDAS_CAKE:ShadowCharge(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and player:GetActiveItem(ActiveSlot.SLOT_POCKET) == CollectibleType.COLLECTIBLE_DARK_ARTS
	then
		local data = Mod:GetData(player)
		local playerRadius = player.Size
		local maxCharge = Mod.ItemConfig:GetCollectible(CollectibleType.COLLECTIBLE_DARK_ARTS).MaxCharges
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BATTERY) then
			maxCharge = maxCharge * 2
		end
		playerRadius = playerRadius + (player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and 40 or 10)
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS) then
			for _, ent in ipairs(Isaac.GetRoomEntities()) do
				if ent:IsActiveEnemy(false)
					and ent.Position:DistanceSquared(player.Position) <= (playerRadius + ent.Size) ^ 2
					and (not data.JudasCakeEnemyTouch
					or not data.JudasCakeEnemyTouch[GetPtrHash(ent)])
				then
					player:SetActiveCharge(math.min(maxCharge, player:GetActiveCharge(ActiveSlot.SLOT_POCKET) + JUDAS_CAKE.DARK_ARTS_CHARGE_BONUS), ActiveSlot.SLOT_POCKET)
					data.JudasCakeEnemyTouch = data.JudasCakeEnemyTouch or {}
					data.JudasCakeEnemyTouch[GetPtrHash(ent)] = true
				end
			end
		elseif data.JudasCakeEnemyTouch then
			data.JudasCakeEnemyTouch = nil
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, JUDAS_CAKE.ShadowCharge, PlayerType.PLAYER_JUDAS_B)
