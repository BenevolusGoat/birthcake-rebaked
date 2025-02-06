--Technically taken from Epiphany but I (Benny) made this code specifically
local Mod = BirthcakeRebaked
local BIRTHDAY_PARTY = Mod.Challenges.BIRTHDAY_PARTY

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
		or level:GetStage() == LevelStage.STAGE3_2
end

function BIRTHDAY_PARTY:OnMomDefeat()
	if BIRTHDAY_PARTY:ShouldActivateForcedHomePath(true)
		and Mod.Game:GetRoom():IsCurrentRoomLastBoss()
	then
		Mod.Game:SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, true)
		Mod.Game:SetStateFlag(GameStateFlag.STATE_SECRET_PATH, true)
		Mod.Game:StartStageTransition(false, 1, Isaac.GetPlayer())
		return true
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
			if gridEnt and gridEnt:GetType() == GridEntityType.GRID_TRAPDOOR then
				BIRTHDAY_PARTY:RemoveTrapdoors(gridEnt)
			end
		end
	end
	Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, runGridUpdate)
else
	Mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_TRAPDOOR_UPDATE, BIRTHDAY_PARTY.RemoveTrapdoors)
end

--#endregion
