--WIP but enough to fill in stuff

--EID.Languages = {"en_us", "fr", "pt", "pt_br", "ru", "spa", "it", "bul", "pl", "de", "tr_tr", "ko_kr", "zh_cn", "ja_jp", "cs_cz", "nl_nl", "uk_ua", "el_gr"}

local NAME_SHARE = {
	[PlayerType.PLAYER_ISAAC_B] = PlayerType.PLAYER_ISAAC,
	[PlayerType.PLAYER_MAGDALENE_B] = PlayerType.PLAYER_MAGDALENE,
	[PlayerType.PLAYER_CAIN_B] = PlayerType.PLAYER_CAIN,
	[PlayerType.PLAYER_JUDAS_B] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_BLUEBABY_B] = PlayerType.PLAYER_BLUEBABY,
	[PlayerType.PLAYER_EVE_B] = PlayerType.PLAYER_EVE,
	[PlayerType.PLAYER_SAMSON_B] = PlayerType.PLAYER_SAMSON,
	[PlayerType.PLAYER_AZAZEL_B] = PlayerType.PLAYER_AZAZEL,
	[PlayerType.PLAYER_LAZARUS_B] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_EDEN_B] = PlayerType.PLAYER_EDEN,
	[PlayerType.PLAYER_THELOST_B] = PlayerType.PLAYER_THELOST,
	[PlayerType.PLAYER_LILITH_B] = PlayerType.PLAYER_LILITH,
	[PlayerType.PLAYER_KEEPER_B] = PlayerType.PLAYER_KEEPER,
	[PlayerType.PLAYER_APOLLYON_B] = PlayerType.PLAYER_APOLLYON,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_BETHANY_B] = PlayerType.PLAYER_BETHANY,
	[PlayerType.PLAYER_JACOB_B] = PlayerType.PLAYER_JACOB,

	[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
}

local DESCRIPTION_SHARE  = {
	[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
}

--The
local CAKE ={
	en_us = "Cake"
}
--is a lie

---This can be stolen from stringtable.sta as they define character names
---But I don't know if it'd be any different with the 's and s'
local translations = {
	BIRTHCAKE_NAME = {
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Isaac's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Magdelene's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Cain's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Judas '" .. CAKE.en_us
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "???'s " .. CAKE.en_us
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = "Eve's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Samson's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Azazel's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Lazarus '" .. CAKE.en_us
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "Eden's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "The Lost's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Lilith's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Keeper's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Apollyon's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "The Forgotten's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Bethany's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Jacob's " .. CAKE.en_us
		},
		[PlayerType.PLAYER_ESAU] = {
			en_us = "Esau's " .. CAKE.en_us
		},
	},

	---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
	BIRTHCAKE_DESCRIPTION = {
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Bonus roll"
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Healing power"
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Sleight of hand"
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Sinner's guard"
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "Loose bowels"
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = ""
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = ""
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Deeper breaths"
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Come down with me"
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "Variety flavor"
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "Regained power"
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Remember to share!"
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Spare change"
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Snake time!"
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "Revitalize"
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Harmony of body and soul"
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Stronger than you"
		},
		[PlayerType.PLAYER_ISAAC_B] = {
			en_us = "Pocket item"
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {
			en_us = "Heart attack"
		},
		[PlayerType.PLAYER_CAIN_B] = {
			en_us = "Repurpose"
		},
		[PlayerType.PLAYER_JUDAS_B] = {
			en_us = ""
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {
			en_us = "Sturdy turdy"
		},
		[PlayerType.PLAYER_EVE_B] = {
			en_us = ""
		},
		[PlayerType.PLAYER_SAMSON_B] = {
			en_us = "Unending rampage"
		},
		[PlayerType.PLAYER_AZAZEL_B] = {
			en_us = ""
		},
		[PlayerType.PLAYER_LAZARUS_B] = {
			en_us = "A gift from beyond"
		},
		[PlayerType.PLAYER_EDEN_B] = {
			en_us = ""
		},
		[PlayerType.PLAYER_THELOST_B] = {
			en_us = ""
		},
		[PlayerType.PLAYER_LILITH_B] = {
			en_us = ""
		},
		[PlayerType.PLAYER_KEEPER_B] = {
			en_us = "Local business"
		},
		[PlayerType.PLAYER_APOLLYON_B] = {
			en_us = "Harvest"
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {
			en_us = "Fracture"
		},
		[PlayerType.PLAYER_BETHANY_B] = {
			en_us = "Stronger summons"
		},
		[PlayerType.PLAYER_JACOB_B] = {
			en_us = ""
		}
	},

	EID = {}
}

for sharedName, copyName in pairs(NAME_SHARE) do
	translations.BIRTHCAKE_NAME[sharedName] = translations.BIRTHCAKE_NAME[copyName]
end

for sharedDescription, copyDescription in pairs(NAME_SHARE) do
	translations.BIRTHCAKE_DESCRIPTION[sharedDescription] = translations.BIRTHCAKE_DESCRIPTION[copyDescription]
end

return translations