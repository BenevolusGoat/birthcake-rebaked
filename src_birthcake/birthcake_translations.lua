--WIP but enough to fill in stuff

--EID.Languages = {"en_us", "fr", "pt", "pt_br", "ru", "spa", "it", "bul", "pl", "de", "tr_tr", "ko_kr", "zh_cn", "ja_jp", "cs_cz", "nl_nl", "uk_ua", "el_gr"}

local NAME_SHARE        = {
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

local DESCRIPTION_SHARE = {
	[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
}

--The
local CAKE              = {
	en_us = "Cake",
	ru = "Пироженое",
	spa = "Pastel",
	cs_cz = "Dort",
	pl = "Babeczka",
	ko_kr = "케이크",
}
--is a LIE
--ТОРТ ЭТО ЛОЖЬ --It's funny that I typed "THE CAKE IS A LIE" but everyone just typed "IS A LIE"
--je LEŽ
--es una MENTIRA

---This can be stolen from stringtable.sta as they define character names
---But I don't know if it'd be any different with the 's and s'
local translations      = {
	BIRTHCAKE_NAME = {
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Isaac's " .. CAKE.en_us,
			ru = CAKE.ru .. " Исаака",
			spa = CAKE.spa .. " de Isaac",
			cs_cz = "Izákův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Izaaka",
			ko_kr = "아이작의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Magdelene's " .. CAKE.en_us,
			ru = CAKE.ru .. " Магдалины",
			spa = CAKE.spa .. " de Magdalena",
			cs_cz = "Magdalénin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Magdaleny",
			ko_kr = "막달레나의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Cain's " .. CAKE.en_us,
			ru = CAKE.ru .. " Каина",
			spa = CAKE.spa .. " de Caín",
			cs_cz = "Kainův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Kaina",
			ko_kr = "카인의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Judas '" .. CAKE.en_us,
			ru = CAKE.ru .. " Иуды",
			spa = CAKE.spa .. " de Judas",
			cs_cz = "Jidášův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Judasza",
			ko_kr = "유다의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "???'s " .. CAKE.en_us,
			ru = CAKE.ru .. " ???",
			spa = CAKE.spa .. " de ???",
			cs_cz = CAKE.cs_cz .. " ???",
			pl = CAKE.pl .. " ???",
			ko_kr = "???의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_EVE] = {
			en_us = "Eve's " .. CAKE.en_us,
			ru = CAKE.ru .. " Евы",
			spa = CAKE.spa .. " de Eva",
			cs_cz = "Evin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Ewy",
			ko_kr = "이브의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Samson's " .. CAKE.en_us,
			ru = CAKE.ru .. " Самсона",
			spa = CAKE.spa .. " de Sansón",
			cs_cz = "Samsonův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Samsona",
			ko_kr = "삼손의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Azazel's " .. CAKE.en_us,
			ru = CAKE.ru .. " Азазеля",
			spa = CAKE.spa .. " de Azazel",
			cs_cz = "Azazelův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Azazela",
			ko_kr = "아자젤의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Lazarus '" .. CAKE.en_us,
			ru = CAKE.ru .. " Лазаря",
			spa = CAKE.spa .. " de Lázaro",
			cs_cz = "Lazarův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Łazarza",
			ko_kr = "나사로의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_EDEN] = {
			en_us = "Eden's " .. CAKE.en_us,
			ru = CAKE.ru .. " Идена",
			spa = CAKE.spa .. " de Edén",
			cs_cz = "Edenův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Edena",
			ko_kr = "에덴의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_THELOST] = {
			en_us = "The Lost's " .. CAKE.en_us,
			ru = CAKE.ru .. " Потерянного",
			spa = CAKE.spa .. " de El Perdido",
			cs_cz = CAKE.cs_cz .. " Ztraceného",
			pl = CAKE.pl .. " Zaginionego",	--kurde niektóre części EID po prostu go zostawiają jako Losta ale jak spolszczamy pełną gębą to idę z tym.
			ko_kr = "더 로스트의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Lilith's " .. CAKE.en_us,
			ru = CAKE.ru .. " Лилит",
			spa = CAKE.spa .. " de Lilith",
			cs_cz = "Lilithin " .. CAKE.cs_cz, -- Couldn't find a better translation, seems to be called like that in czech anyways tho
			pl = CAKE.pl .. " Lilit", --na polskiej wikipedii jest zapisywana jako "Lilith", ale polskie EID zapisuje jako "Lilit"
			ko_kr = "릴리트의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Keeper's " .. CAKE.en_us,
			ru = CAKE.ru .. " Хранителя",
			spa = CAKE.spa .. " de Keeper",
			cs_cz = "Držitelův " .. CAKE.cs_cz, -- In EID he's just called "Keeper", which I just had to czech-ify
			pl = CAKE.pl .. " Dozorcy", --Polskie EID tak to tłumaczy
			ko_kr = "키퍼의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Apollyon's " .. CAKE.en_us,
			ru = CAKE.ru .. " Апполиона",
			spa = CAKE.spa .. " de Apolión",
			cs_cz = "Apollyónův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Apollyona", --EID nie zmienia mu nazwy. Polska wikipedia nazywa go "Abaddon"
			ko_kr = "아폴리온의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "The Forgotten's " .. CAKE.en_us,
			ru = CAKE.ru .. " Забытого",
			spa = CAKE.spa .. " de El Olvidado",
			cs_cz = CAKE.cs_cz .. " Zapomenutého",
			pl = CAKE.pl .. " Zapomnianego",
			ko_kr = "더 포가튼의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Bethany's " .. CAKE.en_us,
			ru = CAKE.ru .. " Вифании", --Бетани
			spa = CAKE.spa .. " de Bethany",
			cs_cz = "Betániin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Betanii",
			ko_kr = "베타니의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Jacob's " .. CAKE.en_us,
			ru = CAKE.ru .. " Якова",
			spa = CAKE.spa .. " de Jacob",
			cs_cz = "Jákobův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Jakuba",
			ko_kr = "야곱의 "..CAKE.ko_kr,
		},
		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_ESAU] = {
			en_us = "Esau's " .. CAKE.en_us,
			ru = CAKE.ru .. " Исава",
			spa = CAKE.spa .. " de Esaú",
			cs_cz = "Ezauův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Ezawa",
			ko_kr = "에사우의 "..CAKE.ko_kr,
		},
	},

	---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
	BIRTHCAKE_DESCRIPTION = {
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Bonus roll",
			ru = "Бонусный переброс",
			cs_cz = "Bonusový hod", -- Or "Bonusová šance", not sure what fits more
			pl = "Bonusowa szansa", --Nie wiem, czy lepiej, ale próbowałem.
			ko_kr = "추가 리롤",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Healing power",
			ru = "Сила исцеления",
			cs_cz = "Síla léčení",
			pl = "Siła leczenia",
			ko_kr = "회복력",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Sleight of hand",
			ru = "Ловкость рук",
			cs_cz = "Fígl", -- The direct translation sounds really weird, I think this one is fitting tho hehe
			pl = "Lepkie ręce", --dosłownie tłumaczenie brzmi badziewnie. "Lepkie ręcę" jest używane w języku
			ko_kr = "손재주",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Sinner's guard",
			ru = "Страж грешника",
			cs_cz = "Hříšníkův strážce",
			pl = "Straż Grzesznika", --ej Monwil, sprawdź wymowę rosyjskiego tłumaczenia lub przeczytaj czeskie :trololed:
			ko_kr = "죄인의 보호막",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "Loose bowels",
			ru = "Дряблый кишечник",
			cs_cz = "Řídká stolice",
			pl = "Erupcja Wezuwiusza", --przepraszam. Nie mogłem się powstrzymać.
			ko_kr = "설사",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_EVE] = {
			en_us = "Safe bleeding",
			ru = "Безопасное кровотечение",
			cs_cz = "Bezpečné krvácení",
			pl = "Bezpieczny ból",	--Niby ból i krwotok to różne słowa, ale to mi się bardziej kojarzyło z samym efektem.
			ko_kr = "안전한 출혈",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Healing rage",
			ru = "Исцеляющая ярость",
			cs_cz = "Léčivý hněv",
			pl = "Leczący gniew",
			ko_kr = "치유의 분노",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Deeper breaths",
			ru = "Дыши глубже...",
			cs_cz = "Hluboké dýchání",
			pl = "Daleki wydech", --szczerze to jest takie pół śmiechem pisane
			ko_kr = "깊어진 숨결",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Come down with me",
			ru = "Снизойди со мной",
			cs_cz = "Sejdi se mnou",
			pl = "Polegnijcie, ze mną", --idk mi się nie podoboa co ty myślisz?
			ko_kr = "동귀어진",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_EDEN] = {
			en_us = "Variety flavor",
			ru = "Вкус разнообразия",
			cs_cz = "Všehochuť",
			pl = "Smak różnorodności",
			ko_kr = "다양한 맛",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_THELOST] = {
			en_us = "Regained power",
			ru = "Возвращенная сила",
			cs_cz = "Obnovená síla",
			pl = "Odnaleziona siła", --chciałem dać "odnaleziona" bo tłumaczą losta jako "zaginionego". Ale nie wiem :/
			ko_kr = "되찾은 동력",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Remember to share!",
			ru = "Не забудь поделиться!",
			cs_cz = "Nezapomeň se podělit!",
			pl = "Pamiętaj, by się dzielić!",
			ko_kr = "좋은 건 나눠야지!",
		},
		-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [!] | PL: [!]
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Spare change", --or Viva la revolution, funni
			ru = "Лишняя мелочь",
			cs_cz = "Drobné",
			pl = "Drobne",
			ko_kr = "잔돈",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Snack time!",
			ru = "Время перекуса!",
			cs_cz = "Sváča!",
			pl = "Smakołyki!",
			ko_kr = "간식 시간이다!",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "Revitalize",
			ru = "Оживление",
			cs_cz = "Oživení",
			pl = "Ożywiony",
			ko_kr = "재활",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Harmony of body and soul",
			ru = "Гармония души и тела",
			cs_cz = "Rovnováha těla a duše",
			pl = "Harmonia ciała i duszy",
			ko_kr = "육신과 영혼의 조화",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Stronger than you",
			ru = "Сильнее, чем ты",
			cs_cz = "Silnější než ty",
			pl = "Silniejszy od ciebie",
			ko_kr = "너보다 강해",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_ISAAC_B] = {
			en_us = "Pocket item",
			ru = "Карманный предмет",
			cs_cz = "Kapesní předmět",
			pl = "Podręczny przedmiot",
			ko_kr = "주머니 아이템",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_MAGDALENE_B] = {
			en_us = "Heart attack",
			ru = "Сердечный приступ",
			cs_cz = "Infarkt",
			pl = "Zawał",
			ko_kr = "심장이 터질 것만 같아!", --진짜 터짐 ㅋㅋ
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_CAIN_B] = {
			en_us = "Repurpose",
			ru = "Переработка",
			cs_cz = "Opětovné použití", -- I struggled with this one a lot, it's kinda weird to translate or my vocabulary is just shit ti-hi
			pl = "Recykling",
			ko_kr = "재활용",
		},
		-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		[PlayerType.PLAYER_JUDAS_B] = {
			en_us = "Shadow charge",
			ru = "Теневой заряд",
			cs_cz = "Stínové nabití",
			pl = "Szarża cieni",
			ko_kr = "그림자 충전",
		},
		-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [!] | PL: [!]
		[PlayerType.PLAYER_BLUEBABY_B] = {
			en_us = "Sturdy turds",
			ru = "Твердый кал",
			cs_cz = "Tvrdé hovno",
			pl = "Zatwardzenie",
			ko_kr = "거 똥 한 번 더럽게 단단하네!",
		},
		-- EN: [X] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		[PlayerType.PLAYER_EVE_B] = {
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
			ko_kr = "",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_SAMSON_B] = {
			en_us = "Unending rampage",
			ru = "Нескончаемая ярость",
			cs_cz = "Nekonečné běsnění",
			pl = "Nieskończony gniew",
			ko_kr = "끝없는 폭주",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_AZAZEL_B] = {
			en_us = "Allergy up",
			ru = "Аллергия ↑",
			cs_cz = "Alergie ↑",
			pl = "Alergie ↑",
			ko_kr = "알레르기 증가",
		},
		-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_LAZARUS_B] = {
			en_us = "Rise again",
			ru = "Дар с небес",
			cs_cz = "Dar z neznáma",
			pl = "Dar z nie tego świata"
		},
		-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		[PlayerType.PLAYER_EDEN_B] = {
			en_us = "Anti-Virus, results may vary",
			ru = "",
			cs_cz = "Věčné cetky",
			pl = "Wieczne trynkiety", --EID tak trinkety tłumaczy
			ko_kr = "영원한 장신구",
		},
		-- EN: [X] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		[PlayerType.PLAYER_THELOST_B] = {
			en_us = "Blessed deck",
			ru = "",
			cs_cz = "",
			pl = "",
			ko_kr = "",
		},
		-- EN: [X] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		[PlayerType.PLAYER_LILITH_B] = {
			en_us = "Missing twin",
			ru = "",
			cs_cz = "",
			pl = "",
			ko_kr = "",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_KEEPER_B] = {
			en_us = "Local business",
			ru = "Местный бизнес",
			cs_cz = "Místní podnik",
			pl = "Lokalny biznes",
			ko_kr = "소상공인",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_APOLLYON_B] = {
			en_us = "Harvest",
			ru = "Сбор урожая",
			cs_cz = "Sklizeň",
			pl = "Żniwa",
			ko_kr = "수확",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {
			en_us = "Fracture",
			ru = "Перелом",
			cs_cz = "Zlomenina",
			pl = "Rozpad",
			ko_kr = "골절",
		},
		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK]
		[PlayerType.PLAYER_BETHANY_B] = {
			en_us = "Stronger summons",
			ru = "Более сильные огоньки", --"Призывы" don't sound very good
			cs_cz = "Silnější vyvolání",
			pl = "Silniejsze ogniki",
			ko_kr = "강해진 소환물",
		},
		-- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		[PlayerType.PLAYER_JACOB_B] = {
			en_us = "Blazing trail",
			ru = "",
			cs_cz = "",
			pl = "",
			ko_kr = "",
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
