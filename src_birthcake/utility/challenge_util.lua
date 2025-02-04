--Technically taken from Epiphany but I (Benny) made this code specifically
local Mod = BirthcakeRebaked
local BIRTHDAY_PARTY = Mod.CHALLENGE_BIRTHDAY_PARTY

--#region Beast DefeatGoal icon

local icon = Sprite()
icon:Load("gfx/ui/defeatgoal_beast_birthdayparty.anm2")
icon:SetFrame("Destination", 0)

HudHelper.RegisterHUDElement({
	Name = "Isaac's Birthday Party Defeat Goal icon",
	Priority = HudHelper.Priority.NORMAL,
	Condition = function()
		return Isaac.GetChallenge() == BIRTHDAY_PARTY.ID
	end,
	OnRender = function()
		HudHelper.RenderHUDIcon(icon, HudHelper.IconType.DESTINATION_ICON)
	end,
	BypassGhostBaby = true
})

--#endregion

--#region Home re-direct

function BIRTHDAY_PARTY:ShouldActivateForcedHomePath(beforeDefeat)
	local level = Mod.Game:GetLevel()
	return Isaac.GetChallenge() == BIRTHDAY_PARTY.ID
		and BIRTHDAY_PARTY:IsDepthsII()
		and level:GetStageType() < StageType.STAGETYPE_REPENTANCE
		and not level:IsAscent()
		and (beforeDefeat or Mod:RunSave().BirthdayPartyMomDefeated)
end

function BIRTHDAY_PARTY:IsDepthsII()
	local level = Mod.Game:GetLevel()
	return (Mod:HasBitFlags(level:GetCurses(), LevelCurse.CURSE_OF_LABYRINTH) or Mod.Game:IsGreedMode()) and level:GetAbsoluteStage() == LevelStage.STAGE3_1
			or level:GetAbsoluteStage() == LevelStage.STAGE3_2
			or level:GetStage() == LevelStage.STAGE3_2

end

function BIRTHDAY_PARTY:OnMomDefeat()
	if BIRTHDAY_PARTY:IsDepthsII()
		and Mod.Game:GetRoom():IsCurrentRoomLastBoss()
	then
		Mod:RunSave().BirthdayPartyMomDefeated = true
	end
end

Mod:AddPriorityCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, CallbackPriority.IMPORTANT, BIRTHDAY_PARTY.OnMomDefeat)

---@param gridEnt GridEntity
function BIRTHDAY_PARTY:RemoveTrapdoors(gridEnt)
	if BIRTHDAY_PARTY:ShouldActivateForcedHomePath(true)
		and Mod.Game:GetLevel():GetCurrentRoomIndex() ~= GridRooms.ROOM_SECRET_EXIT_IDX
	then
		Mod.Game:GetRoom():RemoveGridEntity(gridEnt:GetGridIndex(), 0, false)
	end
end

if not REPENTOGON then
	local function runGridUpdate()
		local room = Mod.Game:GetRoom()
		for i = 0, room:GetGridSize() do
			local gridEnt = room:GetGridEntity(i)
			if gridEnt then
				BIRTHDAY_PARTY:RemoveTrapdoors(gridEnt)
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, runGridUpdate)
else
	Mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_TRAPDOOR_UPDATE, BIRTHDAY_PARTY.RemoveTrapdoors)
end

--- Close all other doors and lock the player into the mausoleum door
function BIRTHDAY_PARTY:SpawnAscentDoor()
	local run_save = Mod:RunSave()

	if BIRTHDAY_PARTY:ShouldActivateForcedHomePath(true)
		and not run_save.BirthdayPartyReseeded
	then
		local oldChallenge = Mod.Game.Challenge
		Mod.Game.Challenge = Challenge.CHALLENGE_NULL
		Mod.Game:Update()
		run_save.BirthdayPartyReseeded = true
		Isaac.ExecuteCommand("reseed")
		Mod.Game.Challenge = oldChallenge
	elseif not BIRTHDAY_PARTY:IsDepthsII()
		and run_save.BirthdayPartyReseeded
	then
		run_save.BirthdayPartyReseeded = false
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, BIRTHDAY_PARTY.SpawnAscentDoor)

--- Trap them in the mausoleum entrance for eternity
--- ...or, at least until they leave the floor.
function BIRTHDAY_PARTY:TrapInMausoleumDoor()
	if BIRTHDAY_PARTY:ShouldActivateForcedHomePath() then
		local room = Mod.Game:GetRoom()
		for doorSlot = DoorSlot.LEFT0, DoorSlot.NUM_DOOR_SLOTS - 1 do
			local door = room:GetDoor(doorSlot)

			if door
				and door:IsOpen()
				and door:GetSprite():GetAnimation() ~= door.CloseAnimation
				and door.TargetRoomIndex ~= GridRooms.ROOM_SECRET_EXIT_IDX
			then
				door:Close(true)
				door:GetSprite():Play(door.CloseAnimation, true)
				door:SetVariant(DoorVariant.DOOR_HIDDEN)
				local grid_save = Mod.SaveManager.GetRoomFloorSave(room:GetGridPosition(door:GetGridIndex()))
				if not grid_save.HasForcedShut then
					grid_save.HasForcedShut = true
				else
					door:GetSprite():SetLastFrame()
				end
			end
		end
	end
end

-- have to do this on update bc boss transitions override all other ones
Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BIRTHDAY_PARTY.TrapInMausoleumDoor)

function BIRTHDAY_PARTY:WaitToTeleport()
	local level = Mod.Game:GetLevel()
	local curIndex = level:GetCurrentRoomIndex()

	if BIRTHDAY_PARTY:ShouldActivateForcedHomePath()
		and curIndex ~= level:GetStartingRoomIndex()
		and curIndex ~= GridRooms.ROOM_SECRET_EXIT_IDX
		and Mod.Game:GetRoom():GetFrameCount() >= 1
	then
		Mod.Game:StartRoomTransition(GridRooms.ROOM_SECRET_EXIT_IDX, Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BIRTHDAY_PARTY.WaitToTeleport)

--#endregion