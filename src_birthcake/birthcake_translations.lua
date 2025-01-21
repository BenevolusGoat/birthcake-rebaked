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
--ЭТО ЛОЖЬ
--je LEŽ
--es una MENTIRA

---This can be stolen from stringtable.sta as they define character names
---But I don't know if it'd be any different with the 's and s'

-- [OK]: good
-- [!]: needs to be updated with the english translation
-- [X]: hasn't been done yet
local translations = {
	BIRTHCAKE_NAME = {
		[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Isaac's " .. CAKE.en_us,
			ru = CAKE.ru .. " Исаака",
			spa = CAKE.spa .. " de Isaac",
			cs_cz = "Izákův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Izaaka",
			ko_kr = "아이작의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Magdelene's " .. CAKE.en_us,
			ru = CAKE.ru .. " Магдалины",
			spa = CAKE.spa .. " de Magdalena",
			cs_cz = "Magdalénin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Magdaleny",
			ko_kr = "막달레나의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_CAIN] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Cain's " .. CAKE.en_us,
			ru = CAKE.ru .. " Каина",
			spa = CAKE.spa .. " de Caín",
			cs_cz = "Kainův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Kaina",
			ko_kr = "카인의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Judas '" .. CAKE.en_us,
			ru = CAKE.ru .. " Иуды",
			spa = CAKE.spa .. " de Judas",
			cs_cz = "Jidášův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Judasza",
			ko_kr = "유다의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "???'s " .. CAKE.en_us,
			ru = CAKE.ru .. " ???",
			spa = CAKE.spa .. " de ???",
			cs_cz = CAKE.cs_cz .. " ???",
			pl = CAKE.pl .. " ???",
			ko_kr = "???의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_EVE] = {					-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Eve's " .. CAKE.en_us,
			ru = CAKE.ru .. " Евы",
			spa = CAKE.spa .. " de Eva",
			cs_cz = "Evin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Ewy",
			ko_kr = "이브의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Samson's " .. CAKE.en_us,
			ru = CAKE.ru .. " Самсона",
			spa = CAKE.spa .. " de Sansón",
			cs_cz = "Samsonův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Samsona",
			ko_kr = "삼손의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Azazel's " .. CAKE.en_us,
			ru = CAKE.ru .. " Азазеля",
			spa = CAKE.spa .. " de Azazel",
			cs_cz = "Azazelův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Azazela",
			ko_kr = "아자젤의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Lazarus '" .. CAKE.en_us,
			ru = CAKE.ru .. " Лазаря",
			spa = CAKE.spa .. " de Lázaro",
			cs_cz = "Lazarův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Łazarza",
			ko_kr = "나사로의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Eden's " .. CAKE.en_us,
			ru = CAKE.ru .. " Идена",
			spa = CAKE.spa .. " de Edén",
			cs_cz = "Edenův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Edena",
			ko_kr = "에덴의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "The Lost's " .. CAKE.en_us,
			ru = CAKE.ru .. " Потерянного",
			spa = CAKE.spa .. " de El Perdido",
			cs_cz = CAKE.cs_cz .. " Ztraceného",
			pl = CAKE.pl .. " Zaginionego",	--kurde niektóre części EID po prostu go zostawiają jako Losta ale jak spolszczamy pełną gębą to idę z tym.
			ko_kr = "더 로스트의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Lilith's " .. CAKE.en_us,
			ru = CAKE.ru .. " Лилит",
			spa = CAKE.spa .. " de Lilith",
			cs_cz = "Lilithin " .. CAKE.cs_cz, -- Couldn't find a better translation, seems to be called like that in czech anyways tho
			pl = CAKE.pl .. " Lilit", --na polskiej wikipedii jest zapisywana jako "Lilith", ale polskie EID zapisuje jako "Lilit"
			ko_kr = "릴리트의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Keeper's " .. CAKE.en_us,
			ru = CAKE.ru .. " Хранителя",
			spa = CAKE.spa .. " de Keeper",
			cs_cz = "Držitelův " .. CAKE.cs_cz, -- In EID he's just called "Keeper", which I just had to czech-ify
			pl = CAKE.pl .. " Dozorcy", --Polskie EID tak to tłumaczy
			ko_kr = "키퍼의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Apollyon's " .. CAKE.en_us,
			ru = CAKE.ru .. " Апполиона",
			spa = CAKE.spa .. " de Apolión",
			cs_cz = "Apollyónův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Apollyona", --EID nie zmienia mu nazwy. Polska wikipedia nazywa go "Abaddon"
			ko_kr = "아폴리온의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "The Forgotten's " .. CAKE.en_us,
			ru = CAKE.ru .. " Забытого",
			spa = CAKE.spa .. " de El Olvidado",
			cs_cz = CAKE.cs_cz .. " Zapomenutého",
			pl = CAKE.pl .. " Zapomnianego",
			ko_kr = "더 포가튼의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Bethany's " .. CAKE.en_us,
			ru = CAKE.ru .. " Вифании", --Бетани
			spa = CAKE.spa .. " de Bethany",
			cs_cz = "Betániin " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Betanii",
			ko_kr = "베타니의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Jacob's " .. CAKE.en_us,
			ru = CAKE.ru .. " Якова",
			spa = CAKE.spa .. " de Jacob",
			cs_cz = "Jákobův " .. CAKE.cs_cz,
			pl = CAKE.pl .. " Jakuba",
			ko_kr = "야곱의 "..CAKE.ko_kr,
		},
		[PlayerType.PLAYER_ESAU] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
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
		[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Bonus roll",
			ru = "Бонусный переброс",
			cs_cz = "Bonusový hod", -- Or "Bonusová šance", not sure what fits more
			pl = "Bonusowa szansa", --Nie wiem, czy lepiej, ale próbowałem.
			ko_kr = "추가 리롤",
		},
		[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Healing power",
			ru = "Сила исцеления",
			cs_cz = "Síla léčení",
			pl = "Siła leczenia",
			ko_kr = "회복력",
		},
		[PlayerType.PLAYER_CAIN] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Sleight of hand",
			ru = "Ловкость рук",
			cs_cz = "Fígl", -- The direct translation sounds really weird, I think this one is fitting tho hehe
			pl = "Lepkie ręce", --dosłownie tłumaczenie brzmi badziewnie. "Lepkie ręcę" jest używane w języku
			ko_kr = "손재주",
		},
		[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Sinner's guard",
			ru = "Страж грешника",
			cs_cz = "Hříšníkův strážce",
			pl = "Straż Grzesznika", --ej Monwil, sprawdź wymowę rosyjskiego tłumaczenia lub przeczytaj czeskie :trololed:
			ko_kr = "죄인의 보호막",
		},
		[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Loose bowels",
			ru = "Дряблый кишечник",
			cs_cz = "Řídká stolice",
			pl = "Erupcja Wezuwiusza", --przepraszam. Nie mogłem się powstrzymać.
			ko_kr = "설사",
		},
		[PlayerType.PLAYER_EVE] = {					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Bloody murder!",
			ru = "Кровавое убийство!",
			cs_cz = "Krvavá vražda",
			pl = "Krwawy Morderca",
			ko_kr = "안전한 출혈",
		},
		[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Healing rage",
			ru = "Исцеляющая ярость",
			cs_cz = "Léčivý hněv",
			pl = "Leczący gniew",
			ko_kr = "치유의 분노",
		},
		[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Deeper breaths",
			ru = "Дыши глубже...",
			cs_cz = "Hluboké dýchání",
			pl = "Daleki wydech", --szczerze to jest takie pół śmiechem pisane
			ko_kr = "깊어진 숨결",
		},
		[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Come down with me",
			ru = "Снизойди со мной",
			cs_cz = "Sejdi se mnou",
			pl = "Polegnijcie, ze mną", --idk mi się nie podoboa co ty myślisz?
			ko_kr = "동귀어진",
		},
		[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Variety flavor",
			ru = "Вкус разнообразия",
			cs_cz = "Všehochuť",
			pl = "Smak różnorodności",
			ko_kr = "다양한 맛",
		},
		[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Regained power",
			ru = "Возвращенная сила",
			cs_cz = "Obnovená síla",
			pl = "Odnaleziona siła", --chciałem dać "odnaleziona" bo tłumaczą losta jako "zaginionego". Ale nie wiem :/
			ko_kr = "되찾은 동력",
		},
		[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Remember to share!",
			ru = "Не забудь поделиться!",
			cs_cz = "Nezapomeň se podělit!",
			pl = "Pamiętaj, by się dzielić!",
			ko_kr = "좋은 건 나눠야지!",
		},
		[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Spare change",
			ru = "Лишняя мелочь",
			cs_cz = "Drobné",
			pl = "Drobne",
			ko_kr = "잔돈",
		},
		[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Snack time!",
			ru = "Время перекуса!",
			cs_cz = "Sváča!",
			pl = "Smakołyki!",
			ko_kr = "간식 시간이다!",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Revitalize",
			ru = "Оживление",
			cs_cz = "Oživení",
			pl = "Ożywiony",
			ko_kr = "재활",
		},
		[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Harmony of body and soul",
			ru = "Гармония души и тела",
			cs_cz = "Rovnováha těla a duše",
			pl = "Harmonia ciała i duszy",
			ko_kr = "육신과 영혼의 조화",
		},
		[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "What's mine is yours",
			ru = "Что мое, то и твое",
			cs_cz = "Co je mé je tvé",
			pl = "Moje, twoje, nasze, wspólne", --Makłowicz
			ko_kr = "너보다 강해",
		},
		[PlayerType.PLAYER_ISAAC_B] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Pocket item",
			ru = "Карманный предмет",
			cs_cz = "Kapesní předmět",
			pl = "Podręczny przedmiot",
			ko_kr = "주머니 아이템",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Heart attack",
			ru = "Сердечный приступ",
			cs_cz = "Infarkt",
			pl = "Zawał",
			ko_kr = "심장이 터질 것만 같아!", --진짜 터짐 ㅋㅋ
		},
		[PlayerType.PLAYER_CAIN_B] = {				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Repurpose",
			ru = "Переработка",
			cs_cz = "Opětovné použití", -- I struggled with this one a lot, it's kinda weird to translate or my vocabulary is just shit ti-hi
			pl = "Recykling",
			ko_kr = "재활용",
		},
		[PlayerType.PLAYER_JUDAS_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Shadow charge",
			ru = "Теневой заряд",
			cs_cz = "Stínové nabití",
			pl = "Szarża cieni",
			ko_kr = "그림자 충전",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Sturdy turds",
			ru = "Твердые какашки",
			cs_cz = "Tvrdá hovna",
			pl = "Kał ze skał",
			ko_kr = "거 똥 한 번 더럽게 단단하네!",
		},
		[PlayerType.PLAYER_EVE_B] = {				-- EN: [X] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X]
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
			ko_kr = "",
		},
		[PlayerType.PLAYER_SAMSON_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Unending rampage",
			ru = "Нескончаемая ярость",
			cs_cz = "Nekonečné běsnění",
			pl = "Nieskończony gniew",
			ko_kr = "끝없는 폭주",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Allergy up",
			ru = "Аллергия ↑",
			cs_cz = "Alergie ↑",
			pl = "Alergie ↑",
			ko_kr = "알레르기 증가",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [!] | KO_KR [X]
			en_us = "Rise again",
			ru = "Восстань снова",
			cs_cz = "Povstaň znovu",
			pl = "Powstań z grobu",
		},
		[PlayerType.PLAYER_EDEN_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Anti-Virus, results may vary",
			ru = "Антивирус, результаты могут различаться",
			cs_cz = "Antivirus, výsledky se mohou lišit",
			pl = "Antivirus, wyniki mogą byż różne",
			ko_kr = "영원한 장신구",
		},
		[PlayerType.PLAYER_THELOST_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [X]
			en_us = "Blessed deck",
			ru = "Благословенная колода",
			cs_cz = "Požehnaný balíček",
			pl = "Święta Talia",
			ko_kr = "",
		},
		[PlayerType.PLAYER_LILITH_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [X]
			en_us = "Missing twin",
			ru = "Пропавший близнец",
			cs_cz = "Pohřešované dvojče",
			pl = "Zaginiony Bliźniak",
			ko_kr = "",
		},
		[PlayerType.PLAYER_KEEPER_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Local business",
			ru = "Местный бизнес",
			cs_cz = "Místní podnik",
			pl = "Lokalny biznes",
			ko_kr = "소상공인",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Harvest",
			ru = "Сбор урожая",
			cs_cz = "Sklizeň",
			pl = "Żniwa",
			ko_kr = "수확",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {		-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Fracture",
			ru = "Перелом",
			cs_cz = "Zlomenina",
			pl = "Rozpad",
			ko_kr = "골절",
		},
		[PlayerType.PLAYER_BETHANY_B] = {			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK]
			en_us = "Stronger summons",
			ru = "Более сильные огоньки", --"Призывы" don't sound very good
			cs_cz = "Silnější vyvolání",
			pl = "Silniejsze ogniki",
			ko_kr = "강해진 소환물",
		},
		[PlayerType.PLAYER_JACOB_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [X]
			en_us = "Blazing trail",
			ru = "Пылающий след",
			cs_cz = "Žhnoucí stopa",
			pl = "Płonący ślad",
			ko_kr = "",
		},
	},

	DEFAULT_DESCRIPTION = {
		en_us = "All stats up",
		ja_jp = "全てのステータスがアップ",
		ko_kr = "모든 능력치 증가",
		--"所有属性上升", (Simplified Chinese)
		ru = "Все характеристики ↑",
		--"Alle Werte hoch", (German)
		spa = "Mejora todas las estadísticas",
		fr = "Toutes les stats augmentées",
	}
}

for sharedName, copyName in pairs(NAME_SHARE) do
	translations.BIRTHCAKE_NAME[sharedName] = translations.BIRTHCAKE_NAME[copyName]
end

for sharedDescription, copyDescription in pairs(DESCRIPTION_SHARE) do
	translations.BIRTHCAKE_DESCRIPTION[sharedDescription] = translations.BIRTHCAKE_DESCRIPTION[copyDescription]
end

return translations
