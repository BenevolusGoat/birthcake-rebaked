--luacheck: no max line length
local Mod = BirthcakeRebaked
local SettingsHelper = BirthcakeRebaked.SettingsHelper

SettingsHelper.AddChoiceSetting("Settings", Mod.Setting.TaintedName,
	"The display name of Tainted characters display when picking up Birthcake", {
		"Default name",
		"\"Tainted\" prefix",
		"Title",
	}, 1)

SettingsHelper.AddChoiceSetting("Settings", Mod.Setting.BirthcakeLanguage,
	"The language used when picking up Birthcake", {
		"Game-selected language",
		"Polish",
		"Czech",
		"Brazillian Portugese",
		"EID-selected language",
	}, 1)
