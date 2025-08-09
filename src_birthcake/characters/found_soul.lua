local Mod = BirthcakeRebaked

--Although categorized under Lost Soul, this technically extends to any "co-op baby player"
--And also because its exclusive to co-op babies/Lost Soul theres no need for a name, sprite, etc :P

local FOUND_SOUL_CAKE = {}

BirthcakeRebaked.Birthcake.LOST_SOUL = FOUND_SOUL_CAKE

FOUND_SOUL_CAKE.BIRTHCAKE_COLOR = Color(1, 1, 1, 1, 0.5, 0.2, 0.21)

local delayHorn = false

function FOUND_SOUL_CAKE:CheckBirthcake(player)
	if Mod.Game:GetRoom():GetFrameCount() > 0 then
		player:GetData().CheckCoopBabyBirthcake = true
		delayHorn = true
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FOUND_SOUL_CAKE.CheckBirthcake, PlayerVariant.FOUND_SOUL)

function FOUND_SOUL_CAKE:PlayPartyHorn()
	if delayHorn then
		Mod:ForEachPlayer(function (player)
			if player:GetData().CheckCoopBabyBirthcake and player:HasTrinket(Mod.Birthcake.ID) then
				Mod.SFXManager:Play(Mod.SFX.PARTY_HORN)
				player:SetColor(FOUND_SOUL_CAKE.BIRTHCAKE_COLOR, -1, 1, false, false)
				player:GetData().CheckCoopBabyBirthcake = nil
			end
		end)
		delayHorn = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, FOUND_SOUL_CAKE.PlayPartyHorn)

---@param tear EntityTear
function FOUND_SOUL_CAKE:PostFireTear(tear)
	local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
	if player and player.Variant == PlayerVariant.FOUND_SOUL then
		local bc = FOUND_SOUL_CAKE.BIRTHCAKE_COLOR
		local c = tear:GetColor()
		tear:SetColor(Color(c.R, c.G, c.B, c.A, bc.RO, bc.GO, bc.BO), -1, 1, false, true)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, FOUND_SOUL_CAKE.PostFireTear)