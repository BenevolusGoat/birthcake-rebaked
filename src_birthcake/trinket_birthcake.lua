local BIRTHCAKE_TRINKET = {}
BirthcakeRebaked.Birthcake = BIRTHCAKE_TRINKET
BIRTHCAKE_TRINKET.ID = Isaac.GetTrinketIdByName("Birthcake")

local characters = {
	"bethany",
	"cain",
	"magdalene",
	"judas",
	"isaac",
	"bluebaby",
	"eve",
	"samson",
	"keeper",
	"lazarus",
	"apollyon",
	"jacob",
	"eden",
	"thelost",
	"azazel",
	"forgotten",
	"lillith"
}
local characterScriptPath = "scripts.trinkets.birthcake."

for _, name in ipairs(characters) do
	include(characterScriptPath .. name)
end
