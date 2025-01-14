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
local characterScriptPath = "scripts.characters."

BirthcakeRebaked.Characters = {}

for _, name in ipairs(characters) do
	include(characterScriptPath .. name)
end
