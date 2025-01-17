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
	player:UseActiveItem(CollectibleType.COLLECTIBLE_NECRONOMICON, UseFlag.USE_NOANIM)
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
		JUDAS_CAKE:ExchangeBirthcake(player)
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, JUDAS_CAKE.PreTakeDamage, EntityType.ENTITY_PLAYER)

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

function JUDAS_CAKE:Slow(player)
	if player:HasTrinket(Mod.Birthcake.ID)
		and player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_DARK_ARTS)
	then
		for _, ent in ipairs(Isaac.GetRoomEntities()) do
			if ent:IsActiveEnemy(false) then
				local entityColor = ent:GetColor()
				local slowColor = Color(entityColor.R, entityColor.G, entityColor.B, 0.8, entityColor.RO, entityColor.GO,
					entityColor.BO)
				if ent.Position:DistanceSquared(player.Position) < 30 ^ 2 then
					ent:AddSlowing(EntityRef(player), 100, 0.5, slowColor)
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, JUDAS_CAKE.Slow, PlayerType.PLAYER_JUDAS_B)
