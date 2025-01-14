local Mod = BirthcakeRebaked
local game = Mod.Game

local BLUEBABY_CAKE = {}
BirthcakeRebaked.Birthcake.BLUEBABY = BLUEBABY_CAKE

-- Functions

function BLUEBABY_CAKE:CheckBlueBaby(player)
	return player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY
end

function BLUEBABY_CAKE:CheckBlueBabyB(player)
	return player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY_B
end

-- Blue Baby Birthcake

BLUEBABY_CAKE.PoopVariantChance = {
	[Mod.EntityPoopVariant.GOLDEN] = 0.01,
	[Mod.EntityPoopVariant.CORN] = 0.2,
	[Mod.EntityPoopVariant.BLACK] = 0.33
}

---@param rng RNG
---@param player EntityPlayer
function BLUEBABY_CAKE:SpawnPoop(_, rng, player, _, _, _)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BLUEBABY) then
		local chargeUsed = player:GetActiveCharge()
		if chargeUsed > 12 then
			chargeUsed = 1
		end
		if chargeUsed == 0 then return end
		for _ = 1, chargeUsed - 1 do
			local variant = Mod.EntityPoopVariant.NORMAL
			local roll = rng:RandomFloat()
			local chanceMult = Mod:GetTrinketMult(player)

			--Loops through all poop variants and selects the rarest
			for poopVariant, chance in pairs(BLUEBABY_CAKE.PoopVariantChance) do
				if roll <= chance * chanceMult then
					poopVariant = poopVariant
				end
			end

			Isaac.Spawn(EntityType.ENTITY_POOP, variant, 0, player.Position, RandomVector():Resized(5), player)
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, BLUEBABY_CAKE.SpawnPoop)

-- Blue Baby B Birthcake

function BLUEBABY_CAKE:Poop()
	for _, poop in ipairs(Isaac.FindByType(EntityType.ENTITY_POOP)) do
		local player = poop.SpawnerEntity and poop.SpawnerEntity:ToPlayer()
		if player and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BLUEBABY_B) then
			if poop.EntityCollisionClass == EntityCollisionClass.ENTCOLL_ALL then
				poop.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
			end
			if poop:GetSprite():GetAnimation() ~= "State5" then
				for _, projEnt in ipairs(Isaac.FindInRadius(poop.Position, poop.Size, EntityPartition.BULLET)) do
					projEnt:Remove()
				end
				for _, enemy in ipairs(Isaac.FindInRadius(poop.Position, poop.Size, EntityPartition.ENEMY)) do
					enemy:AddSlowing(EntityRef(player), 1, 0.5, enemy:GetColor())
				end
			end
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BLUEBABY_CAKE.Poop)
