local Mod = BirthcakeRebaked
local game = Mod.Game

local THELOST_CAKE = {}
BirthcakeRebaked.Birthcake.THELOST = THELOST_CAKE

-- The Lost Birthcake

THELOST_CAKE.AP_FIREDELAY_MULT = 2
THELOST_CAKE.AP_DURATION = 150

local MANTLE_BREAK_SUBTYPE = 11

---@param effect EntityEffect
function THELOST_CAKE:OnLastMantleHit(effect)
	local player = effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()

	if effect.FrameCount == 1
		and effect.SubType == MANTLE_BREAK_SUBTYPE
		and not Mod.Game:GetRoom():IsClear()
		and player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST)
		and effect.Parent
		and GetPtrHash(effect.Parent) == GetPtrHash(player)
		and player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_HOLY_MANTLE) == 0
	then
		player:AddCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)
		player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, EntityRef(player), 0)
		player:RemoveCollectible(CollectibleType.COLLECTIBLE_ASTRAL_PROJECTION)
		player:GetEffects():AddTrinketEffect(Mod.Birthcake.ID, false, THELOST_CAKE.AP_DURATION)
		for _, ent in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.DEVIL)) do
			if ent.Position:DistanceSquared(player.Position) <= 5
				and ent:GetSprite():IsPlaying("Death")
			then
				ent:Remove()
				break
			end
		end
		Mod.SFXManager:Stop(SoundEffect.SOUND_ISAAC_HURT_GRUNT)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, THELOST_CAKE.OnLastMantleHit, EffectVariant.POOF02)

---@param player EntityPlayer
function THELOST_CAKE:TearsCountdown(player)
	local effects = player:GetEffects()
	if effects:HasTrinketEffect(Mod.Birthcake.ID) then
		effects:RemoveTrinketEffect(Mod.Birthcake.ID, 1)
		player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		player:EvaluateItems()
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, THELOST_CAKE.TearsCountdown, PlayerType.PLAYER_THELOST)

---@param player EntityPlayer
function THELOST_CAKE:FadingTearsUp(player)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST) then
		local tears = Mod:Delay2Tears(player.MaxFireDelay)
		local effectCountdown = player:GetEffects():GetTrinketEffectNum(Mod.Birthcake.ID)
		local fireDelayMult = THELOST_CAKE.AP_FIREDELAY_MULT * (effectCountdown / THELOST_CAKE.AP_DURATION)
		tears = tears + fireDelayMult
		player.MaxFireDelay = Mod:Tears2Delay(tears)
	end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, THELOST_CAKE.FadingTearsUp, CacheFlag.CACHE_FIREDELAY)

-- Tainted Lost Birthcake


THELOST_CAKE.HOLY_CARD_REPLACE_BASE_CHANCE = 0.1 --wtf Benny, 10 is too much

function THELOST_CAKE:OnBirthcakeCollect(player, firstTime)
	if firstTime then
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_HOLY,
		Mod.Game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40), Vector.Zero, player)
	end
end

Mod:AddCallback(Mod.ModCallbacks.POST_BIRTHCAKE_COLLECT, THELOST_CAKE.OnBirthcakeCollect, PlayerType.PLAYER_THELOST_B)

---@param rng RNG
---@param onlyPlayingCards boolean
function THELOST_CAKE:ReplaceWithHolyCard(rng, _, onlyPlayingCards)
	if onlyPlayingCards then
		local totalMult = 0
		Mod:ForEachPlayer(function(player)
			if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_THELOST_B) then
				totalMult = totalMult + Mod:GetTrinketMult(player)
			end
		end)
		if totalMult > 0 and rng:RandomFloat() < Mod:GetBalanceApprovedLuckChance(THELOST_CAKE.HOLY_CARD_REPLACE_BASE_CHANCE, totalMult) then
			return Card.CARD_HOLY
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_GET_CARD, THELOST_CAKE.ReplaceWithHolyCard)