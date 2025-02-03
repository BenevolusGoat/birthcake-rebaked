local Mod = BirthcakeRebaked
local game = Mod.Game

local BLUEBABY_CAKE = {}
BirthcakeRebaked.Birthcake.BLUEBABY = BLUEBABY_CAKE

-- Blue Baby Birthcake

local ceil = math.ceil

---Credit to Epiphany for this luck chance calculation
---@param player EntityPlayer
function BLUEBABY_CAKE:GetGoldenPoopChance(player)
	local luck = player.Luck
	local GOLDEN_POOP_CHANCE = {
		MinLuck = 0,
		MaxLuck = 7,
		MinChance = 0.01,
		MaxChance = 0.25
	}

	if player:HasCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH) then
		GOLDEN_POOP_CHANCE.MinChance = 0.05
		GOLDEN_POOP_CHANCE.MaxChance = 0.5
	end
	luck = Mod:Clamp(luck, GOLDEN_POOP_CHANCE.MinLuck, GOLDEN_POOP_CHANCE.MaxLuck)

	local deltaX = GOLDEN_POOP_CHANCE.MaxLuck - GOLDEN_POOP_CHANCE.MinLuck
	local rngRequirement = ((GOLDEN_POOP_CHANCE.MaxChance - GOLDEN_POOP_CHANCE.MinChance) / deltaX) * luck +
		(GOLDEN_POOP_CHANCE.MaxLuck * GOLDEN_POOP_CHANCE.MinChance - GOLDEN_POOP_CHANCE.MinLuck * GOLDEN_POOP_CHANCE.MaxChance) /
		deltaX

	return rngRequirement
end

BLUEBABY_CAKE.PoopVariantChance = {
	[Mod.EntityPoopVariant.GOLDEN] = function(player)
		return BLUEBABY_CAKE:GetGoldenPoopChance(player)
	end,
	--[Mod.EntityPoopVariant.CORN] = 0.2,
	[Mod.EntityPoopVariant.HOLY] = function(player) return player:HasCollectible(CollectibleType
		.COLLECTIBLE_HALLOWED_GROUND) and 0.05 or 0 end,
	[Mod.EntityPoopVariant.BLACK] = function(player) return player:HasTrinket(TrinketType.TRINKET_MECONIUM) and 0.33 or 0 end
}

---@param rng any
---@param player EntityPlayer
function BLUEBABY_CAKE:SpawnPoopWall(itemID, rng, player, flags, slot, _)
	if Mod:HasBitFlags(flags, UseFlag.USE_OWNED)
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BLUEBABY)
	then
		local data = Mod:GetData(player)
		if not data.PreventPoopLoop then
			local room = Mod.Game:GetRoom()
			local originPos = room:GetGridPosition(room:GetGridIndex(player.Position))
			local spawnDir = Mod:DirectionToVector(player:GetHeadDirection()):Rotated(90)
			local playerPos = player.Position
			data.PreventPoopLoop = true
			for _ = 1, 2 do -- idk why but with 2 it spawns 4 poops, so I changed it to 1
				local pos = room:FindFreeTilePosition(originPos + spawnDir:Resized(40), 40)
				if BLUEBABY_CAKE:CheckForValidPos(room:GetRoomShape(), pos) then
					player.Position = pos
					player:UseActiveItem(CollectibleType.COLLECTIBLE_POOP, UseFlag.USE_NOANIM, slot)
					spawnDir = spawnDir:Rotated(180)
				end
			end
			player.Position = playerPos
			data.PreventPoopLoop = false
		end
	end
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, BLUEBABY_CAKE.SpawnPoopWall, CollectibleType.COLLECTIBLE_POOP)

---@param roomShape RoomShape
---@param pos Vector
function BLUEBABY_CAKE:CheckForValidPos(roomShape, pos) --func for checking position in those thin and tall rooms cuz they're just bugged
	if (roomShape == RoomShape.ROOMSHAPE_IH or roomShape == RoomShape.ROOMSHAPE_IIH)
		and (pos.Y < 180 or pos.Y > 380)
	then
		return false
	elseif (roomShape == RoomShape.ROOMSHAPE_IV or roomShape == RoomShape.ROOMSHAPE_IIV)
		and (pos.X < 180 or pos.X > 460)
	then
		return false
	end
	return true
end

---@param rng RNG
---@param player EntityPlayer
function BLUEBABY_CAKE:SpawnPoop(itemID, rng, player, _, _, _)
	if Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BLUEBABY)
		and itemID ~= CollectibleType.COLLECTIBLE_POOP
	then
		local chargeUsed = player:GetActiveCharge()
		if chargeUsed > 12 then
			chargeUsed = 1
		end
		if chargeUsed == 0 then return end
		chargeUsed = ceil(chargeUsed / 2)

		for _ = 1, chargeUsed do
			local variant = Mod.EntityPoopVariant.NORMAL
			local roll = rng:RandomFloat()
			local chanceMult = Mod:GetTrinketMult(player)

			--Loops through all poop variants and selects the rarest
			for poopVariant, chance in pairs(BLUEBABY_CAKE.PoopVariantChance) do
				local poopChance = type(chance) == "function" and chance(player) or chance
				---@cast poopChance number

				if roll <= poopChance * chanceMult then
					variant = poopVariant
				end
			end

			local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.GRIDENT, 0, player.Position,
				RandomVector():Resized(12), player):ToTear()
			---@cast tear EntityTear
			local sprite = tear:GetSprite()
			local result = Isaac.RunCallbackWithParam(Mod.ModCallbacks.BLUEBABY_GET_POOP_TEAR_SPRITE, variant, player)
			sprite.Offset = Vector(0, -5)
			if result ~= nil and type(result) == "userdata" and getmetatable(result).__type == "Sprite" then
				sprite:Load(result:GetFilename(), true)
				sprite:SetFrame(result:GetAnimation(), result:GetFrame())
			else
				sprite:Load("gfx/tear_poops_birthcake.anm2", true)
				sprite:SetFrame("Idle", variant)
			end
			tear.FallingAcceleration = 0.5
			Mod:GetData(tear).BluebabyCakeTear = variant
		end
		local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, player.Position, Vector.Zero, nil)
		fart.Color = Color(1.8, 0.7, 1.5)
		fart.SpriteScale = Vector(0.75, 0.75)
		Mod.SFXManager:Play(SoundEffect.SOUND_FART)
	end
end

Mod:AddPriorityCallback(ModCallbacks.MC_USE_ITEM, CallbackPriority.LATE, BLUEBABY_CAKE.SpawnPoop)

---@param tear EntityTear
function BLUEBABY_CAKE:OnTearUpdate(tear)
	local data = Mod:GetData(tear)
	if data.BluebabyCakeTear then
		tear:SetSize(13, Vector(1, 1), 8)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, BLUEBABY_CAKE.OnTearUpdate, TearVariant.GRIDENT)

---@param tear Entity
function BLUEBABY_CAKE:OnTearDestroy(tear)
	local data = Mod:GetData(tear)
	if data.BluebabyCakeTear then
		Isaac.Spawn(EntityType.ENTITY_POOP, data.BluebabyCakeTear, 0,
			Mod.Game:GetRoom():FindFreeTilePosition(tear.Position, 40), Vector.Zero,
			Mod:FirstPlayerTypeBirthcakeOwner(PlayerType.PLAYER_BLUEBABY))
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, function(_, tear)
	if tear.Variant == TearVariant.GRIDENT then
		BLUEBABY_CAKE:OnTearDestroy(tear)
	end
end, EntityType.ENTITY_TEAR)

-- Blue Baby B Birthcake

BLUEBABY_CAKE.NO_POOP_DAMAGE_CHANCE = 0.33

---@param poop EntityNPC
function BLUEBABY_CAKE:OnPoopDamage(poop, amount, flags, source, countdownFlags)
	local player = poop.SpawnerEntity and poop.SpawnerEntity:ToPlayer()

	if player
		and Mod:PlayerTypeHasBirthcake(player, PlayerType.PLAYER_BLUEBABY_B)
		and poop.Variant ~= Mod.EntityPoopVariant.PETRIFIED
		and player:GetTrinketRNG(Mod.Birthcake.ID):RandomFloat()
		<= Mod:GetBalanceApprovedChance(BLUEBABY_CAKE.NO_POOP_DAMAGE_CHANCE, Mod:GetTrinketMult(player))
	then
		return false
	end
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BLUEBABY_CAKE.OnPoopDamage, EntityType.ENTITY_POOP)
