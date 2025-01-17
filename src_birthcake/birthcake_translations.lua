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
	en_us = "Cake",
	ru = "Пироженое",
	spa = "Pastel",
	cs_cz = "Dort",
	pl = "Babeczka",
}
--is a LIE
--ТОРТ ЭТО ЛОЖЬ
--je LEŽ
--es una MENTIRA

---This can be stolen from stringtable.sta as they define character names
---But I don't know if it'd be any different with the 's and s'
local translations = {
	BIRTHCAKE_NAME = {
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Isaac's " .. CAKE.en_us,
			ru = CAKE.ru .. " Исаака",
			spa = CAKE.spa .. " de Isaac",
			cs_cz = "Izákův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Izaaka",
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Magdelene's " .. CAKE.en_us,
			ru = CAKE.ru .. " Магдалины",
			spa = CAKE.spa .. " de Magdalena",
			cs_cz = "Magdalénin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Magdaleny",
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Cain's " .. CAKE.en_us,
			ru = CAKE.ru .. " Каина",
			spa = CAKE.spa .. " de Caín",
			cs_cz = "Kainův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Kaina",
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Judas '" .. CAKE.en_us,
			ru = CAKE.ru .. " Иуды",
			spa = CAKE.spa .. " de Judas",
			cs_cz = "Jidášův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Judasza",
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "???'s " .. CAKE.en_us,
			ru = CAKE.ru .. " ???",
			spa = CAKE.spa .. " de ???",
			cs_cz = CAKE.cs_cz .. " ???",
			pl = CAKE.pl .. " ???",
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = "Eve's " .. CAKE.en_us,
			ru = CAKE.ru .. " Евы",
			spa = CAKE.spa .. " de Eva",
			cs_cz = "Evin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Ewy",
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Samson's " .. CAKE.en_us,
			ru = CAKE.ru .. " Самсона",
			spa = CAKE.spa .. " de Sansón",
			cs_cz = "Samsonův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Samsona",
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Azazel's " .. CAKE.en_us,
			ru = CAKE.ru .. " Азазеля",
			spa = CAKE.spa .. " de Azazel",
			cs_cz = "Azazelův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Azazela",
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Lazarus '" .. CAKE.en_us,
			ru = CAKE.ru .. " Лазаря",
			spa = CAKE.spa .. " de Lázaro",
			cs_cz = "Lazarův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Łazarza",
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "Eden's " .. CAKE.en_us,
			ru = CAKE.ru .. " Идена",
			spa = CAKE.spa .. " de Edén",
			cs_cz = "Edenův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Edena",
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "The Lost's " .. CAKE.en_us,
			ru = CAKE.ru .. " Потерянного",
			spa = CAKE.spa .. " de El Perdido",
			cs_cz = CAKE.cs_cz .. " Ztraceného",
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Lilith's " .. CAKE.en_us,
			ru = CAKE.ru .. " Лилит",
			spa = CAKE.spa .. " de Lilith",
			cs_cz = "Lilithin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Lilit", --na polskiej wikipedii jest zapisywana jako "Lilith", ale polskie EID zapisuje jako "Lilit"
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Keeper's " .. CAKE.en_us,
			ru = CAKE.ru .. " Хранителя",
			spa = CAKE.spa .. " de Keeper",
			cs_cz = "Držitelův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Dozorcy", --Polskie EID tak to tłumaczy
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Apollyon's " .. CAKE.en_us,
			ru = CAKE.ru .. " Апполиона",
			spa = CAKE.spa .. " de Apolión",
			cs_cz = "Apollyónův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Apollyona", --EID nie zmienia mu nazwy. Polska wikipedia nazywa go "Abaddon"
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "The Forgotten's " .. CAKE.en_us,
			ru = CAKE.ru .. " Забытого",
			spa = CAKE.spa .. " de El Olvidado",
			cs_cz = CAKE.cs_cz .. " Zapomenutého",
			pl = CAKE.pl .. " Zapomnianego",
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Bethany's " .. CAKE.en_us,
			ru = CAKE.ru .. " Вифании", --Бетани
			spa = CAKE.spa .. " de Bethany",
			cs_cz = "Betániin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Betanii",
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Jacob's " .. CAKE.en_us,
			ru = CAKE.ru .. " Якова",
			spa = CAKE.spa .. " de Jacob",
			cs_cz = "Jákobův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Jakuba",
		},
		[PlayerType.PLAYER_ESAU] = {
			en_us = "Esau's " .. CAKE.en_us,
			ru = CAKE.ru .. " Исава",
			spa = CAKE.spa .. " de Esaú",
			cs_cz = "Ezauův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Ezawa",
		},
	},

	---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
	BIRTHCAKE_DESCRIPTION = {
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Bonus roll",
			ru = "Бонусный переброс",
			cs_cz = "Bonusový hod",
			pl = "Bonusowe przelosowanie", --szczerze, to brzmi badziewnie, chciałem dać "dodatkowy los" ale za bardzo kojarzy mi się z hazardem a za mało "rerollowaniem"
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Healing power",
			ru = "Сила исцеления",
			cs_cz = "Síla léčení",
			pl = "Siła leczenia",
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Sleight of hand",
			ru = "Ловкость рук",
			cs_cz = "Fígl",
			pl = "Lepkie ręce", --dosłownie tłumaczenie brzmi badziewnie. "Lepkie ręcę" jest używane w języku
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Sinner's guard",
			ru = "Страж грешника",
			cs_cz = "Hříšníkův strážce",
			pl = "Straż Grzesznika", --ej Monwil, sprawdź wymowę rosyjskiego tłumaczenia lub przeczytaj czeskie :trololed:
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "Loose bowels",
			ru = "Дряблый кишечник",
			cs_cz = "Řídká stolice",
			pl = "Erupcja Wezuwiusza", --przepraszam. Nie mogłem się powstrzymać.
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Deeper breaths",
			ru = "Дыши глубже...",
			cs_cz = "Hluboké dýchání",
			pl = "Daleki wydech", --szczerze to jest takie pół śmiechem pisane
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Come down with me",
			ru = "Снизойди со мной",
			cs_cz = "Sejdi se mnou",
			pl = "Polegnijcie, ze mną", --idk mi się nie podoboa co ty myślisz?
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "Variety flavor",
			ru = "Вкус разнообразия",
			cs_cz = "Všehochuť",
			pl = "Smak różnorodności",
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "Regained power",
			ru = "Возвращенная сила",
			cs_cz = "Obnovená moc",
			pl = "Odnaleziona siła", --chciałem dać "odnaleziona" bo tłumaczą losta jako "zaginionego". Ale nie wiem :/
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Remember to share!",
			ru = "Не забудь поделиться!",
			cs_cz = "Nezapomeň se podělit!",
			pl = "Pamiętaj, s się dzielić!",
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Spare change",
			ru = "Лишняя мелочь",
			cs_cz = "Drobné",
			pl = "Drobne",
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Snack time!",
			ru = "Время перекуса!",
			cs_cz = "Sváča!",
			pl = "Smakołyki!",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "Revitalize",
			ru = "Оживление",
			cs_cz = "Oživení",
			pl = "Ożywiony",
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Harmony of body and soul",
			ru = "Гармония души и тела",
			cs_cz = "Rovnováha těla a duše",
			pl = "Harmonia ciała i duszy",
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Stronger than you",
			ru = "Сильнее, чем ты",
			cs_cz = "Silnější než ty",
			pl = "Silniejszy od ciebie",
		},
		[PlayerType.PLAYER_ISAAC_B] = {
			en_us = "Pocket item",
			ru = "Карманный предмет",
			cs_cz = "Kapesní předmět",
			pl = "Podręczny przedmiot",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {
			en_us = "Heart attack",
			ru = "Сердечный приступ",
			cs_cz = "Infarkt",
			pl = "Zawał",
		},
		[PlayerType.PLAYER_CAIN_B] = {
			en_us = "Repurpose",
			ru = "Перераспределение",
			cs_cz = "Opětovné použití",
			pl = "Recykling",
		},
		[PlayerType.PLAYER_JUDAS_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {
			en_us = "Sturdy turdy",
			ru = "Твердый кал",
			cs_cz = "Tvrdé hovno",
			pl = "Chlupie w dupie", --wymyśl coś lepszego, teraz mnie to bawi ale za 5 miesięcy będę z tego cringe'ował.
		},
		[PlayerType.PLAYER_EVE_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_SAMSON_B] = {
			en_us = "Unending rampage",
			ru = "Нескончаемая ярость",
			cs_cz = "Nekonečné běsnění",
			pl = "Nieskończony gniew",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {
			en_us = "Allergy up",
			ru = "Аллергия ↑",
			cs_cz = "Alergie ↑",
			pl = "Alergie ↑",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {
			en_us = "A gift from beyond",
			ru = "Дар с небес",
			cs_cz = "Dar z neznáma",
			pl = "Dar z nie tego świata"
		},
		[PlayerType.PLAYER_EDEN_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_THELOST_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_LILITH_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
		[PlayerType.PLAYER_KEEPER_B] = {
			en_us = "Local business",
			ru = "Местный бизнес",
			cs_cz = "Místní podnik",
			pl = "Lokalny biznes",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {
			en_us = "Harvest",
			ru = "Сбор урожая",
			cs_cz = "Sklizeň",
			pl = "Żniwa",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {
			en_us = "Fracture",
			ru = "Перелом",
			cs_cz = "Zlomenina",
			pl = "Rozpad",
		},
		[PlayerType.PLAYER_BETHANY_B] = {
			en_us = "Stronger summons",
			ru = "Более сильные огоньки", --"Призывы" don't sound very good
			cs_cz = "Silnější vyvolání",
			pl = "Silniejsze ogniki",
		},
		[PlayerType.PLAYER_JACOB_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
		},
	},

	EID = {}
}

for sharedName, copyName in pairs(NAME_SHARE) do
	translations.BIRTHCAKE_NAME[sharedName] = translations.BIRTHCAKE_NAME[copyName]
end

for sharedDescription, copyDescription in pairs(DESCRIPTION_SHARE) do
	translations.BIRTHCAKE_DESCRIPTION[sharedDescription] = translations.BIRTHCAKE_DESCRIPTION[copyDescription]
end

return translations
