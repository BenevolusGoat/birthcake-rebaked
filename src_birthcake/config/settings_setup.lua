--luacheck: no max line length
local Mod = BirthcakeRebaked
local SettingsHelper = BirthcakeRebaked.SettingsHelper

SettingsHelper.AddChoiceSetting("Settings", Mod.Setting.TaintedName,
	"The display name of Tainted characters when picking up Birthcake", {
		"Default name",
		"\"Tainted\" prefix",
		"Title",
	}, 1)

SettingsHelper.AddChoiceSetting("Settings", Mod.Setting.BirthcakeLanguage,
	"The language used when picking up Birthcake", {
		"Game-selected language",
		"EID-selected language",
		"English",
		"Russian",
		"Spanish",
		"Czech",
		"Korean",
		"Polish",
		"Brazillian Portugese",
	}, 1)

if not REPENTOGON then return end

local pGameData = Isaac.GetPersistentGameData()
SettingsHelper.AddBooleanSetting("Settings", Mod.Setting.BirthcakeUnlocked,
"(RGON ONLY) Is Birthcake unlocked?",
false,
nil,
function(currentValue)
	if currentValue == true then
		Isaac.ClearChallenge(Mod.Challenges.BIRTHDAY_PARTY.ID)
	else
		Isaac.ExecuteCommand("lockachievement " .. Mod.Achievements.BIRTHCAKE)
		Isaac.MarkChallengeAsNotDone(Mod.Challenges.BIRTHDAY_PARTY.ID)
	end
end)

SettingsHelper.AddBooleanSetting("Settings", Mod.Setting.ChallengeUnlocked,
"(RGON ONLY) Is Isaac's Birthday Party unlocked?",
false,
nil,
function(currentValue)
	if currentValue == true then
		pGameData:TryUnlock(Mod.Achievements.ISAACS_BIRTHDAY_PARTY)
	else
		Isaac.ExecuteCommand("lockachievement " .. Mod.Achievements.ISAACS_BIRTHDAY_PARTY)
	end
end)