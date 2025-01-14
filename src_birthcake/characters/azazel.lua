local Mod = BirthcakeRebaked
local game = Mod.Game

local AZAZEL_CAKE = {}
BirthcakeRebaked.Trinkets.BIRTHCAKE.AZAZEL = AZAZEL_CAKE

local charge = 0
local frameCounter = 0

-- Azazel Birthcake

--TODO: This is kinda lame honestly and doesn't fit with Azazel

function AZAZEL_CAKE:ShootTears(player)
	if player:HasTrinket(Mod.Trinkets.BIRTHCAKE.ID) then
		if tostring(player:GetShootingInput()) ~= "0 0" or player:AreOpposingShootDirectionsPressed() then
			charge = charge + 1
			if charge >= player.MaxFireDelay then
				frameCounter = frameCounter + 1
				if frameCounter % math.floor(player.MaxFireDelay / 2) == 0 then
					player:FireTear(player.Position, player:GetAimDirection() * 10, false, false, false, player, 0.5)
				end
			end
		else
			charge = 0
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, AZAZEL_CAKE.ShootTears, PlayerType.PLAYER_AZAZEL)

-- Tainted Azazel Birthcake

---@param effect EntityEffect
function AZAZEL_CAKE:Sneeze(effect)
	local player = effect.SpawnerEntity and effect.SpawnerEntity:ToPlayer()
	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_AZAZEL_B)
	then
		player:AddVelocity(player:GetShootingInput():Rotated(180):Resized(3))
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, AZAZEL_CAKE.Sneeze, EffectVariant.HAEMO_TRAIL)


---@param entity Entity
---@param source EntityRef
function AZAZEL_CAKE:AzazelSickness(entity, _, flags, source, _)
	local player = source and source.Entity and source.Entity:ToPlayer()

	if entity:IsActiveEnemy(false) and player and flags == 0 then
		if player.FireDelay == -1 then
			entity:AddPoison(EntityRef(player), 23 * 10, player.Damage)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, AZAZEL_CAKE.AzazelSickness)
