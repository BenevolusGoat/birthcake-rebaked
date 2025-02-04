local Mod = BirthcakeRebaked
local loader = BirthcakeRebaked.PatchesLoader

---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
BirthcakeRebaked.BirthcakeAccurateBlurbs = {
	[PlayerType.PLAYER_ISAAC] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Dice Shard in Starting Rooms",
		ru = "Создаёт Осколок Кости + Осколки Кости в стартовой комнате",
		pl = "Odłamki Kości na początku piętra",
		pt_br = "Fragmentos de dado nas salas iniciais",
		ko_kr = "시작 방에 주사위 조각 생성",
	},
	[PlayerType.PLAYER_MAGDALENE] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Heart pickups may double",
		ru = "Подбираемые сердца могут удвоиться",
		pl = "Serca są czasami podwojone",
		pt_br = "Corações talvez dobrem",
		ko_kr = "하트 픽업이 더블 픽업으로 가끔 대체됨",
	},
	[PlayerType.PLAYER_CAIN] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Machines may refund",
		ru = "Автоматы могут возвратить деньги",
		pl = "Automaty do Gier czasami zwracają pieniądze",
		pt_br = "Máquinas provavelmente darão reembolsos",
		ko_kr = "슬롯 머신이 가끔씩 돈을 돌려줌",
	},
	[PlayerType.PLAYER_JUDAS] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OD] | KO_KR [OK] | PT_BR [OK]
		en_us = "DMG multiplier + exchange for lethal Deal",
		ru = "Множитель Урона ↑ + обмен на летальную Сделку",
		pl = "Mnożnik obrażeń + chroni przed zabójczą wymianą z Diabłem",
		pt_br = "Multiplicador de dano + troca por trato letal",
		ko_kr = "공격력 배수 적용, 악마 거래 시 체력이 부족하면 이 장신구를 대신 소모",
	},
	[PlayerType.PLAYER_BLUEBABY] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Active use drop poops depending on charge",
		ru = "Использование активных предметов бросает какашки в зависимости от заряда",
		pl = "Przedmioty aktywne tworzą kupy zależnie od ładunków",
		pt_br = "Items ativos jogam cocôs dependendo da quantidade de cargas",
		ko_kr = "액티브 사용 시 충전량에 비례해 똥 생성",
	},
	[PlayerType.PLAYER_EVE] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "(DMG scaling + blood-creep) for Dead Bird",
		ru = "(скейлинг Урона + кровавый след) для Мертвой Птицы", --how the f am i supposed to translate "scaling"?
		pl = "Zdechły Ptak dostaje skalowanie Obrażeń i smugę krwi",
		pt_br = "Mais dano + trilha de sangue para o pássaro morto",
		ko_kr = "죽은 새가 피 장판 생성, 공격력 능력치 비례 피해량 증가",
	},
	[PlayerType.PLAYER_SAMSON] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Drop red hearts at maximum rage",
		ru = "Создаёт красные сердца при максимальном уровне ярости",
		pl = "Tworzy serduszka po osiągnieciu maksymalnego gniewu",
		pt_br = "Ganhe corações vermelhos quando chegar a raiva máxima",
		ko_kr = "피의 욕망 누적량 최대치 달성 시 빨간 하트 생성",
	},
	[PlayerType.PLAYER_AZAZEL] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "DMG down + extended Brimstone duration",
		ru = "Урон ↓ + увеличенная длительность Серы",
		pl = "OBR ↓ + laser trwa dłużej",
		pt_br = "Dano ↓ + laser dura mais tempo",
		ko_kr = "공격력 하락 + 혈사포 지속 시간 증가",
	},
	[PlayerType.PLAYER_LAZARUS] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Extra Lazarus' Rags revive",
		ru = "Дополнительное возрождение от Лохмотьев Лазаря",
		pl = "Dodatkowe życie",
		pt_br = "Vida extra",
		ko_kr = "나사로의 누더기 부활 횟수 1회 추가",
	},
	[PlayerType.PLAYER_EDEN] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "3 unchanging random trinket effects",
		ru = "3 случайных неизменных эффектов брелков",
		pl = "Efekty 3 losowych trynkietów",
		pt_br = "efeitos de três berloques",
		ko_kr = "무작위 장신구 효과 3개 부여",
	},
	[PlayerType.PLAYER_THELOST] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!] | KO_KR [OK] | PT_BR [OK]
		en_us = "Astral Projection on Holy Mantle breakage",
		ru = "Астральная Проэкция при потери Святой Мантии",
		pl = "Astralna Projekcja przy utracie tarczy",
		pt_br = "Projeção Astral quando o Manto Sagrado quebrar",
		ko_kr = "성스러운 망토 보호막 파괴 시 시간이 느려짐",
	},
	[PlayerType.PLAYER_LILITH] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Buddies may copy tear effects",
		ru = "Спутники могут скопировать эффекты слёз",
		pl = "Sojusznicy czasami kopiują efekty twoich łez",
		pt_br = "Amigos talvez copiarão efeitos das lágrimas",
		ko_kr = "패밀리어들이 가끔 눈물 효과를 복사함",
	},
	[PlayerType.PLAYER_KEEPER] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Nickel in Shop and Devil Rooms",
		ru = "Пятак в Магазине и комнате Сделки с Дьяволом",
		pl = "Piątak w sklepach i pokojach Diabła",
		pt_br = "Níquel nas lojas e salas do demônio",
		ko_kr = "상점, 악마 방에 5센트 주화 생성",
	},
	[PlayerType.PLAYER_APOLLYON] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Trinkets can be absorbed with Void",
		ru = "Брелки могут быть поглощены Пустотой",
		pl = "Pustka może pochłaniać trynkiety",
		pt_br = "Berloques podem ser absorvidos com o Vazio",
		ko_kr = "공허 아이템으로 장신구도 흡수 가능",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = { 			-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Shoot bone-body to fill for fading tears up",
		ru = "Стреляй в скелет, чтобы заполнить его для убывающего повышения скорострельности",
		pl = "Strzel w ciało, aby je naładować bonusem do szybkostrzelności",
		pt_br = "Atire no corpo de esquelto para atirar mais rápido por um tempo",
		ko_kr = "해골에 눈물을 쏘면 일시적으로 연사력 증가",
	},
	[PlayerType.PLAYER_BETHANY] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "May spawn additional wisp on active use",
		ru = "При использовании активируемого предмета может появиться дополнительный огонек",
		pl = "Użyte przedmioty czasami dają dodatkowe ogniki",
		pt_br = "Talvez invoque outra fumaça ao usar o item ativo",
		ko_kr = "액티브 사용 시 가끔씩 추가 위습 생성",
	},
	[PlayerType.PLAYER_JACOB] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "All damage hurts the other brother instead",
		ru = "Весь урон получает другой брат вместо этого",
		pl = "Przenosi krzywdę do brata",
		pt_br = "Todo dano tomado é direcionado ao outro irmão",
		ko_kr = "소지 시 피해를 무시하지만 그 때마다 나머지 형제가 대신 피격됨",
	},
	[PlayerType.PLAYER_ISAAC_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Extra inventory slot",
		ru = "Дополнительный слот инвентаря",
		pl = "Dodatkowe miejsce w ekwipunku",
		pt_br = "Extra espaço no inventário",
		ko_kr = "인벤토리 슬롯 +1",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = { 			-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Temp. hearts ejected from enemies explode",
		ru = "Временные сердца, падающие с врагов, взрываются",
		pl = "Serduszka z przeciwników wybuchają",
		pt_br = "Corações ejetados dos inimigos explodem",
		ko_kr = "적이 드랍하는 하트가 폭발을 일으킴",
	},
	[PlayerType.PLAYER_CAIN_B] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Double pickups are split apart",
		ru = "Двойные подбираемые предметы распадаются на части",
		pl = "Rozdziela podwójne pickupy",
		pt_br = "Captadores duplos são separados",
		ko_kr = "2중 픽업이 두 개의 단일 픽업으로 분해됨",
	},
	[PlayerType.PLAYER_JUDAS_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Pass through with Dark Arts for active charge",
		ru = "Прохождение сквозь врагов под Темными Искусствами заряжает активный предмет",
		pl = "Mroczne Techniki ładują się szybciej, gdy trafiają przeciwników",
		pt_br = "Passe por inimigos com Artes Sombrias para ganhar cargas",
		ko_kr = "흑마술로 적 관통 시 액티브 충전",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Poops may not be hurt",
		ru = "Какашки могут не повредиться",
		pl = "Kupy są niezniszczalne",
		pt_br = "Cocôs talvez não sofrerão danos",
		ko_kr = "똥이 적으로부터의 피해를 무시함",
	},
	[PlayerType.PLAYER_EVE_B] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Clots drop creep on death",
		ru = "Сгустки оставляют лужу при смерти",
		pl = "Zakrzepki zostawiają maź po śmierci",
		pt_br = "Coágulos deixam uma trilha de sangue ao morrer",
		ko_kr = "핏덩이 사망 시 피 장판 생성",
	},
	[PlayerType.PLAYER_SAMSON_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Room clear may (extend Berserk + drop heart)",
		ru = "Зачистка комнат может (продлить действие Берсерка + создать сердце)",
		pl = "Kończenie pokojów czasami wydłuża stan Berserka i tworzy serduszko",
		pt_br = "Terminar salas talvez extenda Berserk + dar um coração",
		ko_kr = "방 클리어 시 폭주 지속 시간이 증가하고 빨간 하트를 생성할 수도 있음",
	},
	[PlayerType.PLAYER_AZAZEL_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Sneeze brimstone-marking booger tears",
		ru = "Вычихивание соплей с меткой серы",
		pl = "Kichaj naznaczającymi smarkami",
		pt_br = "Lágrimas de meleca ao espirrar",
		ko_kr = "재채기를 하면 혈사포 표식 효과를 부여하는 코딱지도 같이 발사됨",
	},
	[PlayerType.PLAYER_LAZARUS_B] = { 				-- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!] | KO_KR [!] | PT_BR [!]
		en_us = "Flipping items splits items into both sides",
		ru = "Переворачивание предметов может разделить их на обе части",
		pl = "Odwrót czasami rozdziela przedmioty na obie strony",
		pt_br = "Trocar o item talvez dividira ambos os lados",
		ko_kr = "아이템에 뒤집기 사용 시 이따금씩 아이템 2개로 분리됨",
	},
	[PlayerType.PLAYER_EDEN_B] = { 					-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "May not reroll everything when hurt",
		ru = "Может не поменять всё при получении урона",
		pl = "Blokuje losowanie przy trafieniu",
		pt_br = "Talvez não mudará todos os seus items ao sofrer dano",
		ko_kr = "피격 시 가끔씩 리롤 효과 무시",
	},
	[PlayerType.PLAYER_THELOST_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Holy Card + cards may be Holy Card more",
		ru = "Святая Карта + карты могут стать Святыми Картами чаще",
		pl = "Święta Karta + więcej Świętych Kart",
		pt_br = "Carta sagrada + Mais chance de cartas sagradas",
		ko_kr = "성스러운 카드 효과 + 성스러운 카드 변환 확률 증가",
	},
	[PlayerType.PLAYER_LILITH_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Chance for additional Gello on birth",
		ru = "Шанс на дополнительного Гелло при рождении", --"on birth"? maybe just "on shoot", but ok
		pl = "Czasami rodzisz dwa bachory",
		pt_br = "Chance de invocar outro Gello ao atirar",
		ko_kr = "젤로 투척 시 일정 확률로 젤로 1명이 추가로 튀어나옴",
	},
	[PlayerType.PLAYER_KEEPER_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Spawn a mini shop every floor",
		ru = "Создает мини-магазин каждый этаж",
		pl = "Mini sklep na każdym piętrze",
		pt_br = "Invoca uma pequena loja todo andar",
		ko_kr = "매 층마다 소형 상점 생성",
	},
	[PlayerType.PLAYER_APOLLYON_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Abyss-absorb trinkets for half-DMG locusts",
		ru = "Поглощение Бездной брелков для саранчи с Уроном x0.5",
		pl = "Pochłaniaj trynkiety, aby dostać szarańcze o połowicznych obrażeniach",
		pt_br = "Abismo consegue absorber trinkets para ganhar gafanhotos de metade de dano",
		ko_kr = "무저갱으로 장신구 흡수 가능, 흡수 시 데미지 절반짜리 메뚜기 생성",
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = { 			-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Kill for bone-orbitals + hold body to gather",
		ru = "Убивай для орбитальных костей + возьми тело, чтобы собрать",
		pl = "Zabijanie przeciwników tworzy kości + zbieraj podnosząć ciało",
		pt_br = "Mate para ganhar orbitais de osso + segure o corpo para reunílos",
		ko_kr = "적 처치 시 뼛조각생성; 해골을 들면 뼛조각이 오비탈이 됨",
	},
	[PlayerType.PLAYER_BETHANY_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Wisps have double health",
		ru = "Двойное здоровье у огоньков",
		pl = "Ogniki mają podwojone zdrowie",
		pt_br = "Fumaças tem o dobro de vida",
		ko_kr = "위습 체력 2배",
	},
	[PlayerType.PLAYER_JACOB_B] = { 				-- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK] | KO_KR [OK] | PT_BR [OK]
		en_us = "Dark Esau leaves a flame-trail",
		ru = "Тёмный Исав оставляет огненный след",
		pl = "Mroczny Ezaw zostawia ognisty ślad",
		pt_br = "Esaú sombrio deixa uma trilha de chamas",
		ko_kr = "검은 에사우가 돌진하면 그 자리에 불꽃을 남김",
	}
}

local function accurateBlurbsPatch()
	local DESCRIPTION_SHARE = {
		[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
		[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
		[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS_B,
		[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
		[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
	}

	for sharedDescription, copyDescription in pairs(DESCRIPTION_SHARE) do
		Mod.BirthcakeAccurateBlurbs[sharedDescription] = Mod.BirthcakeAccurateBlurbs[copyDescription]
	end

	Mod:AddCallback(Mod.ModCallbacks.GET_BIRTHCAKE_ITEMTEXT_DESCRIPTION, function(_, player)
		local playerType = player:GetPlayerType()
		if Mod.BirthcakeAccurateBlurbs[playerType] and Mod:GetTranslatedString(Mod.BirthcakeAccurateBlurbs[playerType]) then
			return Mod:GetTranslatedString(Mod.BirthcakeAccurateBlurbs[playerType])
		end
	end)
end

loader:RegisterPatch("AccurateBlurbs", accurateBlurbsPatch)
