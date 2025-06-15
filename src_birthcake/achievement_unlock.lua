local Mod = BirthcakeRebaked

local ACHIEVEMENT = {}
BirthcakeRebaked.Achievements = ACHIEVEMENT
if not REPENTOGON then return end
ACHIEVEMENT.BIRTHCAKE = Isaac.GetAchievementIdByName("Birthcake")
ACHIEVEMENT.ISAACS_BIRTHDAY_PARTY = Isaac.GetAchievementIdByName("Isaac's Birthday Party")
local pGameData = Isaac.GetPersistentGameData()

function ACHIEVEMENT:CheckChallengeUnlock()
	if not pGameData:Unlocked(ACHIEVEMENT.ISAACS_BIRTHDAY_PARTY)
		and pGameData:Unlocked(Achievement.MAGDALENE)
		and pGameData:Unlocked(Achievement.CAIN)
		and pGameData:Unlocked(Achievement.JUDAS)
		and pGameData:Unlocked(Achievement.BLUE_BABY)
		and pGameData:Unlocked(Achievement.EVE)
		and pGameData:Unlocked(Achievement.SAMSON)
		and pGameData:Unlocked(Achievement.AZAZEL)
		and pGameData:Unlocked(Achievement.LAZARUS)
		and pGameData:Unlocked(Achievement.EDEN)
		and pGameData:Unlocked(Achievement.LOST)
		and pGameData:Unlocked(Achievement.LILITH)
		and pGameData:Unlocked(Achievement.KEEPER)
		and pGameData:Unlocked(Achievement.APOLLYON)
		and pGameData:Unlocked(Achievement.FORGOTTEN)
		and pGameData:Unlocked(Achievement.BETHANY)
		and pGameData:Unlocked(Achievement.JACOB_AND_ESAU)
	then
		pGameData:TryUnlock(ACHIEVEMENT.ISAACS_BIRTHDAY_PARTY)
	end
end

Mod:AddCallback(ModCallbacks.MC_POST_ACHIEVEMENT_UNLOCK, ACHIEVEMENT.CheckChallengeUnlock)
Mod:AddCallback(Mod.SaveManager.SaveCallbacks.POST_DATA_LOAD, ACHIEVEMENT.CheckChallengeUnlock)