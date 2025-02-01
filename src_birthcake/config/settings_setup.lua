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
