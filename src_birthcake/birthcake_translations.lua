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
	[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN_B,
}

local DESCRIPTION_SHARE = {
	[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
	[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
	[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
	[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
	[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
	[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN_B,
}

-- [OK]: good
-- [!]: needs to be updated with the english translation
-- [X]: hasn't been done yet
local translations = {
	BIRTHCAKE_NAME = {
		[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Isaac's",
			ru = "Исаака",
			spa = "de Isaac",
			cs_cz = "Izákův",
			pl = "Izaaka",
			ko_kr = "아이작의",
			pt_br = "do Isaque",
		},
		[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Magdelene's",
			ru = "Магдалины",
			spa = "de Magdalena",
			cs_cz = "Magdalénin",
			pl = "Magdaleny",
			ko_kr = "막달레나의",
			pt_br = "da Madalena",
		},
		[PlayerType.PLAYER_CAIN] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Cain's",
			ru = "Каина",
			spa = "de Caín",
			cs_cz = "Kainův",
			pl = "Kaina",
			ko_kr = "카인의",
			pt_br = "do Caim",
		},
		[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Judas'",
			ru = "Иуды",
			spa = "de Judas",
			cs_cz = "Jidášův",
			pl = "Judasza",
			ko_kr = "유다의",
			pt_br = "do Judas",
		},
		[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "???'s",
			ru = "???",
			spa = "de ???",
			cs_cz = "???",
			pl = "???",
			ko_kr = "???의",
			pt_br = "do ???",
		},
		[PlayerType.PLAYER_EVE] = {					-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Eve's",
			ru = "Евы",
			spa = "de Eva",
			cs_cz = "Evin",
			pl = "Ewy",
			ko_kr = "이브의",
			pt_br = "da Eva",
		},
		[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Samson's",
			ru = "Самсона",
			spa = "de Sansón",
			cs_cz = "Samsonův",
			pl = "Samsona",
			ko_kr = "삼손의",
			pt_br = "do Sansão",
		},
		[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Azazel's",
			ru = "Азазеля",
			spa = "de Azazel",
			cs_cz = "Azazelův",
			pl = "Azazela",
			ko_kr = "아자젤의",
			pt_br = "do Azazel",
		},
		[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Lazarus'",
			ru = "Лазаря",
			spa = "de Lázaro",
			cs_cz = "Lazarův",
			pl = "Łazarza",
			ko_kr = "나사로의",
			pt_br = "do Lázaro",
		},
		[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Eden's",
			ru = "Эдема", --official name, but I'd use 2'nd variant "Идена"
			spa = "de Edén",
			cs_cz = "Edenův",
			pl = "Edena",
			ko_kr = "에덴의",
			pt_br = "do Éden",
		},
		[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "The Lost's",
			ru = "Потерянного",
			spa = "de El Perdido",
			cs_cz = "Ztraceného",
			pl = "Zaginionego",	--kurde niektóre części EID po prostu go zostawiają jako Losta ale jak spolszczamy pełną gębą to idę z tym.
			ko_kr = "더 로스트의",
			pt_br = "do O Perdido",
		},
		[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Lilith's",
			ru = "Лилит",
			spa = "de Lilith",
			cs_cz = "Lilithin", -- Couldn't find a better translation, seems to be called like that in czech anyways tho
			pl = "Lilit", --na polskiej wikipedii jest zapisywana jako "Lilith", ale polskie EID zapisuje jako "Lilit"
			ko_kr = "릴리트의",
			pt_br = "da Lilith",
		},
		[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Keeper's",
			ru = "Хранителя",
			spa = "de Keeper",
			cs_cz = "Držitelův", -- In EID he's just called "Keeper", which I just had to czech-ify
			pl = "Dozorcy", --Polskie EID tak to tłumaczy
			ko_kr = "키퍼의",
			pt_br = "do Keeper",
		},
		[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Apollyon's",
			ru = "Апполиона",
			spa = "de Apolión",
			cs_cz = "Apollyónův",
			pl = "Apollyona", --EID nie zmienia mu nazwy. Polska wikipedia nazywa go "Abaddon"
			ko_kr = "아폴리온의",
			pt_br = "do Apolion",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {		-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "The Forgotten's",
			ru = "Забытого",
			spa = "de El Olvidado",
			cs_cz = "Zapomenutého",
			pl = "Zapomnianego",
			ko_kr = "더 포가튼의",
			pt_br = "do O Esquecido",
		},
		[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Bethany's",
			ru = "Вифании", --Бетани
			spa = "de Bethany",
			cs_cz = "Betániin",
			pl = "Betanii",
			ko_kr = "베타니의",
			pt_br = "da Betânia",
		},
		[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [ОК] | SPA: [!] | CS_CZ: [OK] | PL: [!] | KO_KR [!]
			en_us = "Jacob & Esau's",
			ru = "Иакова и Исава",
			spa = "de Jacob",
			cs_cz = "Jákobův a Ezauův",
			pl = "Jakuba",
			ko_kr = "야곱의",
			pt_br = "do Jacó e Esaú",
		},
--[[
		[PlayerType.PLAYER_ESAU] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Esau's",
			ru = "Исава",
			spa = "de Esaú",
			cs_cz = "Ezauův",
			pl = "Ezawa",
			ko_kr = "에사우의",
			pt_br = "Esaú",
		},
 ]]
	},

	---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
	BIRTHCAKE_DESCRIPTION = {
		[PlayerType.PLAYER_ISAAC] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Bonus roll",
			ru = "Бонусный переброс",
			spa = "Intento extra", --kinda had to change it to "Extra attempt"
			cs_cz = "Bonusový hod", -- Or "Bonusová šance", not sure what fits more
			pl = "Bonusowa szansa", --Nie wiem, czy lepiej, ale próbowałem.
			ko_kr = "추가 새로고침",
			pt_br = "Chance bônus",
		},
		[PlayerType.PLAYER_MAGDALENE] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Healing power",
			ru = "Сила исцеления",
			spa = "Poder sanador",
			cs_cz = "Síla léčení",
			pl = "Siła leczenia",
			ko_kr = "회복력",
			pt_br = "Poder de cura",
		},
		[PlayerType.PLAYER_CAIN] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Sleight of hand",
			ru = "Ловкость рук",
			spa = "Prestidigitación",
			cs_cz = "Fígl", -- The direct translation sounds really weird, I think this one is fitting tho hehe
			pl = "Lepkie ręce", --dosłownie tłumaczenie brzmi badziewnie. "Lepkie ręcę" jest używane w języku
			ko_kr = "손재주",
			pt_br = "Predigistação",
		},
		[PlayerType.PLAYER_JUDAS] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Sinner's guard",
			ru = "Страж грешника",
			spa = "Guardia del pecador",
			cs_cz = "Hříšníkův strážce",
			pl = "Straż Grzesznika", --ej Monwil, sprawdź wymowę rosyjskiego tłumaczenia lub przeczytaj czeskie :trololed:
			ko_kr = "죄인의 보호막",
			pt_br = "Guarda do pecador",
		},
		[PlayerType.PLAYER_BLUEBABY] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Loose bowels",
			ru = "Дряблый кишечник",
			spa = "Caca estreñida",
			cs_cz = "Řídká stolice",
			pl = "Erupcja Wezuwiusza", --przepraszam. Nie mogłem się powstrzymać.
			ko_kr = "민감한 장",
			pt_br = "Intestino solto",
		},
		[PlayerType.PLAYER_EVE] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Bloody murder!",
			ru = "Кровавое убийство!",
			spa = "Asesinato sangriento!",
			cs_cz = "Krvavá vražda",
			pl = "Krwawy Morderca",
			ko_kr = "피투성이 까마귀", --씨발 언어유희 한 번 살리기 힘드네
			pt_br = "Assasinato sangrento!",
		},
		[PlayerType.PLAYER_SAMSON] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Healing rage",
			ru = "Исцеляющая ярость",
			spa = "Furia curativa",
			cs_cz = "Léčivý hněv",
			pl = "Leczący gniew",
			ko_kr = "치유의 분노",
			pt_br = "Fúria curativa",
		},
		[PlayerType.PLAYER_AZAZEL] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Deeper breaths",
			ru = "Дыши глубже...",
			spa = "Respiración profunda",
			cs_cz = "Hluboké dýchání",
			pl = "Daleki wydech", --szczerze to jest takie pół śmiechem pisane
			ko_kr = "깊어진 숨결",
			pt_br = "Respirações profundas",
		},
		[PlayerType.PLAYER_LAZARUS] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Rise again",
			ru = "Восстань снова",
			cs_cz = "Povstaň znovu",
			pl = "Powstań z grobu",
			ko_kr = "다시 한 번 소생하라",
			pt_br = "Levante novamente",
		},
		[PlayerType.PLAYER_EDEN] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Variety flavor",
			ru = "Вкус разнообразия",
			spa = "Multisabor",
			cs_cz = "Všehochuť",
			pl = "Smak różnorodności",
			ko_kr = "다양한 맛",
			pt_br = "Sabor com variedade",
		},
		[PlayerType.PLAYER_THELOST] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Regained power",
			ru = "Возвращенная сила",
			spa = "Poder recuperado",
			cs_cz = "Obnovená síla",
			pl = "Odnaleziona siła", --chciałem dać "odnaleziona" bo tłumaczą losta jako "zaginionego". Ale nie wiem :/
			ko_kr = "되찾은 동력",
			pt_br = "Poder readquirido",
		},
		[PlayerType.PLAYER_LILITH] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Remember to share!",
			ru = "Не забудь поделиться!",
			spa = "Acuérdate de compartir!",
			cs_cz = "Nezapomeň se podělit!",
			pl = "Pamiętaj, by się dzielić!",
			ko_kr = "좋은 건 나눠야지!",
			pt_br = "Lembre-se de compartilhar!",
		},
		[PlayerType.PLAYER_KEEPER] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Spare change",
			ru = "Лишняя мелочь",
			spa = "Monedas sueltas",
			cs_cz = "Drobné",
			pl = "Drobne",
			ko_kr = "잔돈",
			pt_br = "Trocado",
		},
		[PlayerType.PLAYER_APOLLYON] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Snack time!",
			ru = "Время перекуса!",
			spa = "Hora de merendar!",
			cs_cz = "Sváča!",
			pl = "Smakołyki!",
			ko_kr = "간식 시간이다!",
			pt_br = "Hora do lanchinho!",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Revitalize",
			ru = "Оживление",
			spa = "Revitalizar",
			cs_cz = "Oživení",
			pl = "Ożywiony",
			ko_kr = "재활",
			pt_br = "Revitalizar",
		},
		[PlayerType.PLAYER_BETHANY] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Harmony of body and soul",
			ru = "Гармония души и тела",
			spa = "Armonía del cuerpo y el alma",
			cs_cz = "Rovnováha těla a duše",
			pl = "Harmonia ciała i duszy",
			ko_kr = "육신과 영혼의 조화",
			pt_br = "Harmonia de corpo e alma",
		},
		[PlayerType.PLAYER_JACOB] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "What's mine is yours",
			ru = "Что мое, то и твое",
			spa = "Lo que es mío es tuyo",
			cs_cz = "Co je mé je tvé",
			pl = "Moje, twoje, nasze, wspólne", --Makłowicz
			ko_kr = "너보다 강해",
			pt_br = "O que é seu é meu",
		},
		[PlayerType.PLAYER_ISAAC_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Pocket item",
			ru = "Карманный предмет",
			spa = "Objeto de bolsillo",
			cs_cz = "Kapesní předmět",
			pl = "Podręczny przedmiot",
			ko_kr = "주머니 아이템",
			pt_br = "Item de bolso",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Heart attack",
			ru = "Сердечный приступ",
			spa = "Infarto",
			cs_cz = "Infarkt",
			pl = "Zawał",
			ko_kr = "심장이 터질 것만 같아!", --진짜 터짐 ㅋㅋ
			pt_br = "Poder de cura",
		},
		[PlayerType.PLAYER_CAIN_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Repurpose",
			ru = "Переработка",
			spa = "Reutilizar",
			cs_cz = "Opětovné použití", -- I struggled with this one a lot, it's kinda weird to translate or my vocabulary is just shit ti-hi
			pl = "Recykling",
			ko_kr = "재활용",
			pt_br = "Reutilizar",
		},
		[PlayerType.PLAYER_JUDAS_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Shadow charge",
			ru = "Теневой заряд",
			spa = "Carga sombría",
			cs_cz = "Stínové nabití",
			pl = "Szarża cieni",
			ko_kr = "그림자 충전",
			pt_br = "Carga sombria",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Sturdy turds",
			ru = "Твердые какашки",
			spa = "Cacas robustas",
			cs_cz = "Tvrdá hovna",
			pl = "Kał ze skał",
			ko_kr = "거 똥 한 번 더럽게 단단하네!",
			pt_br = "Cocô duro",
		},
		[PlayerType.PLAYER_EVE_B] = {				-- EN: [X] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X] | KO_KR [X]
			en_us = "",
			ru = "",
			cs_cz = "",
			pl = "",
			ko_kr = "",
			pt_br = "",
		},
		[PlayerType.PLAYER_SAMSON_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Unending rampage",
			ru = "Нескончаемая ярость",
			spa = "Alboroto interminable", --Probably works??? couldn't find anything better for it
			cs_cz = "Nekonečné běsnění",
			pl = "Nieskończony gniew",
			ko_kr = "끝없는 폭주",
			pt_br = "Raiva sem fim",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Allergy up",
			ru = "Аллергия ↑",
			spa = "Alergia ↑",
			cs_cz = "Alergie ↑",
			pl = "Alergie ↑",
			ko_kr = "알레르기 증가",
			pt_br = "Alergia ↑",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [!] | KO_KR [X]
			en_us = "Untwined destiny",
			ru = "Неразрывная судьба",
			spa = "Destino desatado",
			cs_cz = "Rozpletený osud",
			pl = "Powstań z grobu",
			pt_br = "Destino desentrelaçado",
			ko_kr = "풀려버린 운명",
		},
		[PlayerType.PLAYER_EDEN_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [!]
			en_us = "Anti-Virus, results may vary",
			ru = "Антивирус, результаты могут различаться",
			spa = "Antivirus, los efectos pueden variar",
			cs_cz = "Antivirus, výsledky se mohou lišit",
			pl = "Antivirus, wyniki mogą byż różne",
			ko_kr = "영원한 장신구",
			pt_br = "Antivírus, resultados talvez variem",
		},
		[PlayerType.PLAYER_THELOST_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X]
			en_us = "Blessed deck",
			ru = "Благословенная колода",
			spa = "Baraja bendecida",
			cs_cz = "Požehnaný balíček",
			pl = "Święta Talia",
			ko_kr = "축복받은 덱",
			pt_br = "Baralho abençoado",
		},
		[PlayerType.PLAYER_LILITH_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X]
			en_us = "Missing twin",
			ru = "Пропавший близнец",
			spa = "Gemelo perdido",
			cs_cz = "Pohřešované dvojče",
			pl = "Zaginiony Bliźniak",
			ko_kr = "잃어버린 쌍둥이",
			pt_br = "Gêmeo desaparecido",
		},
		[PlayerType.PLAYER_KEEPER_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Local business",
			ru = "Местный бизнес",
			spa = "Negocio local",
			cs_cz = "Místní podnik",
			pl = "Lokalny biznes",
			ko_kr = "소상공인",
			pt_br = "Negócios locais",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Harvest",
			ru = "Сбор урожая",
			spa = "Cosecha",
			cs_cz = "Sklizeň",
			pl = "Żniwa",
			ko_kr = "수확",
			pt_br = "Colheita",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Fracture",
			ru = "Перелом",
			spa = "Fractura",
			cs_cz = "Zlomenina",
			pl = "Rozpad",
			ko_kr = "골절",
			pt_br = "Fratura",
		},
		[PlayerType.PLAYER_BETHANY_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
			en_us = "Stronger summons",
			ru = "Более сильные огоньки", --"Призывы" don't sound very good
			spa = "Invocaciones más fuertes",
			cs_cz = "Silnější vyvolání",
			pl = "Silniejsze ogniki",
			ko_kr = "강화된 소환물",
			pt_br = "Invocações mais fortes",
		},
		[PlayerType.PLAYER_JACOB_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [OK] | KO_KR [X]
			en_us = "Blazing trail",
			ru = "Пылающий след",
			spa = "Rastro en llamas",
			cs_cz = "Žhnoucí stopa",
			pl = "Płonący ślad",
			ko_kr = "타오르는 흔적",
			pt_br = "Trilha flamejante",
		},
	},

	TAINTED_TITLES = {
		[PlayerType.PLAYER_ISAAC_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Broken's",
			spa = "Del Roto",
			cs_cz = "Zlomeného",
			ru = "Сломанного",
			pt_br = "Do Quebrado",
			ko_kr = "망가진 자의",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Dauntless's",
			spa = "de La Intrépida", --Idk if it's like this AT ALL
			cs_cz = "Nesmělé",
			ru = "Бесстрашшной",
			pt_br = "Da Destemida",
			ko_kr = "겁없는 자의",
		},
		[PlayerType.PLAYER_CAIN_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Hoarder's",
			spa = "Dell Acumulador",
			cs_cz = "Hromadiče",
			ru = "Хранителя (порченного)",
			pt_br = "Do Acumulador",
			ko_kr = "수집가의",
		},
		[PlayerType.PLAYER_JUDAS_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Deceiver's",
			spa = "Del Traidor", --More like "The Traitor" but eh
			cs_cz = "Šejdíře",
			ru = "Обманщика",
			pt_br = "Do Enganador",
			ko_kr = "기만자의",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Soiled's",
			spa = "Del Sucio",
			cs_cz = "Zašpiněného",
			ru = "Грязного",
			pt_br = "Do Sujo",
			ko_kr = "역겨운 자의",
		},
		[PlayerType.PLAYER_EVE_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Curdled's",
			spa = "de La Cuajada", --How the hell do I translate this
			cs_cz = "Zkažené", -- I don't know man
			ru = "Свернувшейся",
			pt_br = "Da Coagulada", -- Dunno if it's like this
			ko_kr = "응집된 자의",
		},
		[PlayerType.PLAYER_SAMSON_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Savage's",
			spa = "Del Salvaje",
			cs_cz = "Divocha",
			ru = "Дикаря",
			pt_br = "O Selvagem",
			ko_kr = "야만적인 자의",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Benighted's",
			spa = "Del Ignorante",
			cs_cz = "Zaostalého", -- I don't feel like this is the right translation...
			ru = "Мрачного",
			pt_br = "Do Ignorante",
			ko_kr = "우매한 자의",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Enigma's",
			spa = "Del Enigma",
			cs_cz = "Záhadného",
			ru = "Загадки",
			pt_br = "Do Enigma",
			ko_kr = "수수께끼의",
		},
		[PlayerType.PLAYER_EDEN_B] = {				-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Capricious'",
			spa = "Del Caprichoso",
			cs_cz = "Rozmarného",
			ru = "Непостоянного",
			pt_br = "Do Caprichoso",
			ko_kr = "변덕스러운 자의",
		},
		[PlayerType.PLAYER_THELOST_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Baleful's",
			spa = "Del Tétrico", --Is it like this? idk
			cs_cz = "Zlověstného",
			ru = "Гибельного",
			pt_br = "Do Maléfico",
			ko_kr = "불길한 자의",
		},
		[PlayerType.PLAYER_LILITH_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Harlot's",
			spa = "da La Prostituta",
			cs_cz = "Coury",
			ru = "Блудницы",
			pt_br = "Da Prostituta",
			ko_kr = "대탕녀의",
		},
		[PlayerType.PLAYER_KEEPER_B] = {			-- EN: [OK] | RU: [OK] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Miser's",
			spa = "Del Avariento",
			cs_cz = "Skrblíka",
			ru = "Скупого",
			pt_br = "Do Avarento",
			ko_kr = "구두쇠의",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Empty's",
			spa = "de El Vacío",
			cs_cz = "Prázdného",
			ru = "Пустого",
			pt_br = "Do O Vazio",
			ko_kr = "공허한 자의",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Fettered's",
			spa = "Del Encadenado",
			cs_cz = "Spoutaného",
			ru = "Скованных", --the fact that it's in the plural makes sense actually
			pt_br = "Do Acorrentado",
			ko_kr = "속박된 자의",
		},
		[PlayerType.PLAYER_BETHANY_B] = {			-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Zealot's",
			spa = "da La Fanática",
			cs_cz = "Zfanatizované",
			ru = "Фанатички",
			pt_br = "Da Fanática",
			ko_kr = "광신도의",
		},
		[PlayerType.PLAYER_JACOB_B] = {				-- EN: [OK] | RU: [ОК] | SPA: [OK] | CS_CZ: [OK] | PL: [X] | KO_KR [X]
			en_us = "The Deserter's",
			spa = "Del Desertor",
			cs_cz = "Zrádce",
			ru = "Дезертира",
			pt_br = "Do Desertor",
			ko_kr = "도망자의",
		},
	},

	ONE_LINERS = {
		DEFAULT_DESCRIPTION = {
			en_us = "All stats up",
			ja_jp = "全てのステータスがアップ",
			ko_kr = "모든 능력치 증가",
			--"所有属性上升", (Simplified Chinese)
			ru = "Все характеристики ↑",
			--"Alle Werte hoch", (German)
			spa = "Mejora todas las estadísticas",
			fr = "Toutes les stats augmentées",
			cs_cz = "Všechny statistiky ↑",
			pt_br = "Melhoria de todas as estatísticas",
		},
		--The
		CAKE = {
			en_us = "Cake",
			ru = "Пироженое",
			spa = "Pastel",
			cs_cz = "Dort",
			pl = "Babeczka",
			ko_kr = "케이크",
			pt_br = "Bolo",
			--is a LIE
			--ЭТО ЛОЖЬ
			--es una MENTIRA
			--je LEŽ
		},
		TAINTED = {
			en_us = "Tainted",
			spa = "Tainted",
			cs_cz = "Poskvrněný",
			ru = "Порченый",
			pt_br = "Contaminado",
			ko_kr = "더럽혀진",
		},
		BIRTHCAKE = {
			en_us = "Birthcake",
			ru = "Деньрожденное пироженое", --This translation really sucks, "Праздничное" is better, but not related to birthday that much
			spa = "Pastel de cumple",
			cs_cz = "Narozeninový dort",
			pt_br = "Bolo de nascimento",
			ko_kr = "생일 케이크",
		}
	}
}

function BirthcakeRebaked:AppendCake(str, lang)
	local reverse = {
		ru = true,
		spa = true,
		pl = true,
	}
	if reverse[lang] then
		return translations.ONE_LINERS.CAKE[lang] .. " " .. str
	else
		return str .. " " .. translations.ONE_LINERS.CAKE[lang]
	end
end

function BirthcakeRebaked:PrefixTainted(str, lang)
	local reverse = {
		ru = true,
		spa = true,
		pl = true,
		cs_cz = true,
		ko_kr = true,
	}
	if reverse[lang] then
		return str .. " " .. translations.ONE_LINERS.TAINTED[lang]
	else
		return translations.ONE_LINERS.TAINTED[lang] .. " " .. str
	end
end

for playerType, sharedType in pairs(NAME_SHARE) do
	translations.BIRTHCAKE_NAME[playerType] = translations.BIRTHCAKE_NAME[sharedType]
end

for playerType, sharedType in pairs(DESCRIPTION_SHARE) do
	translations.BIRTHCAKE_DESCRIPTION[playerType] = translations.BIRTHCAKE_DESCRIPTION[sharedType]
end

return translations
