local BIRTHCAKE_TRINKET = {}
BirthcakeRebaked.Trinkets.BIRTHCAKE = BIRTHCAKE_TRINKET
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
local characterScriptPath = "scripts.Trinkets.BIRTHCAKE."

BirthcakeRebaked.Characters = {}

for _, name in ipairs(characters) do
	include(characterScriptPath .. name)
end
