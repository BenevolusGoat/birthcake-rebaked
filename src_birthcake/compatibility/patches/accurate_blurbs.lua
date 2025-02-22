local Mod = BirthcakeRebaked
local loader = BirthcakeRebaked.PatchesLoader

-- !TRANSLATION PROGRESS
-- EN: 34/34 | RU: 34/34 | SPA: 0/34 | CS_CZ: 0/34 | PL: 34/34 | KO_KR 34/34 | PT_BR 34/34 | UK_UA 34/34

---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
BirthcakeRebaked.BirthcakeAccurateBlurbs = {
	[PlayerType.PLAYER_ISAAC] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Dice Shard in Starting Rooms",
		ru = "Осколки Кости в стартовой комнате",
		pl = "Odłamki Kości na początku piętra",
		pt_br = "Fragmentos de dado nas salas iniciais",
		ko_kr = "시작 방에 주사위 조각 생성",
		zh_cn = "在初始房间生成骰子碎片",
		cs_cz = "Úlomek Kostky ve startovací místnosti",
		uk_ua = "Уламок кубика в стартовій кімнаті" --в EID використовується "стартова кімната" єдиний раз (або я неуважний), інші описи просто пишуть "на початку кожного поверху"
	},
	[PlayerType.PLAYER_MAGDALENE] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Heart pickups may double",
		ru = "Подбираемые сердца могут удвоиться",
		pl = "Serca są czasami podwojone",
		pt_br = "Corações talvez dobrem",
		ko_kr = "하트 픽업이 더블 픽업으로 가끔 대체됨",
		zh_cn = "强化的心掉落物",
		cs_cz = "Srdce mohou být dvojitá",
		uk_ua = "Серця можуть подвоюватись",
	},
	[PlayerType.PLAYER_CAIN] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Machines may refund",
		ru = "Автоматы могут возвратить деньги",
		pl = "Automaty do Gier czasami zwracają pieniądze",
		pt_br = "Máquinas provavelmente darão reembolsos",
		ko_kr = "슬롯 머신이 가끔씩 돈을 돌려줌",
		zh_cn = "抽奖机概率回本",
		cs_cz = "Automaty mohou vrátit peníze",
		uk_ua = "Автомати можуть відшкодувати",
	},
	[PlayerType.PLAYER_JUDAS] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "DMG multiplier + exchange for lethal Deal",
		ru = "Множитель Урона ↑ + обмен на летальную Сделку",
		pl = "Mnożnik obrażeń + chroni przed zabójczą wymianą z Diabłem",
		pt_br = "Multiplicador de dano + troca por trato letal",
		ko_kr = "공격력 배수 적용, 악마 거래 시 체력이 부족하면 이 장신구를 대신 소모",
		zh_cn = "伤害上升 + 抵消致命交易",
		cs_cz = "Násobitel poškození + výměna za smrtelný obchod",
		uk_ua = "Множник Шкоди ↑ + обмін на смертельну угоду",
	},
	[PlayerType.PLAYER_BLUEBABY] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Active use drops poops depending on charge",
		ru = "Использование активных предметов бросает какашки в зависимости от заряда",
		pl = "Przedmioty aktywne tworzą kupy zależnie od ładunków",
		pt_br = "Items ativos jogam cocôs dependendo da quantidade de cargas",
		ko_kr = "액티브 사용 시 충전량에 비례해 똥 생성",
		zh_cn = "根据主动充能生成额外大便",
		cs_cz = "Použití aktivního předmětu vytvoří hovna podle nabití",
		uk_ua = "Викакування при використанні активних предметів залежно від заряду", --довгеньке, не знаю, чи можна скоротити
	},
	[PlayerType.PLAYER_EVE] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "(DMG scaling + blood-creep) for Dead Bird",
		ru = "(скейлинг Урона + кровавый след) для Мертвой Птицы", --how the f am i supposed to translate "scaling"?
		pl = "Zdechły Ptak dostaje skalowanie Obrażeń i smugę krwi",
		pt_br = "Mais dano + trilha de sangue para o pássaro morto",
		ko_kr = "죽은 새가 피 장판 생성, 공격력 능력치 비례 피해량 증가",
		zh_cn = "(死鸟的) 伤害上升 + 血迹蔓延",
		cs_cz = "(Škálování poškození + krvavé kaluže) pro Mrtvého Ptáka",
		uk_ua = "(Зростання Шкоди + кривавий слід) для Мертвого птаха",
	},
	[PlayerType.PLAYER_SAMSON] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Drop red hearts at maximum rage",
		ru = "Создаёт красные сердца при максимальном уровне ярости",
		pl = "Tworzy serduszka po osiągnieciu maksymalnego gniewu",
		pt_br = "Ganhe corações vermelhos quando chegar a raiva máxima",
		ko_kr = "피의 욕망 누적량 최대치 달성 시 빨간 하트 생성",
		zh_cn = "嗜血最大时生成心掉落物",
		cs_cz = "Vytvoří červená srdce při maximálním vzteku",
		uk_ua = "Створює червоні серця при досягненні максимальної злості",
	},
	[PlayerType.PLAYER_AZAZEL] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "DMG down + extended Brimstone duration",
		ru = "Урон ↓ + увеличенная длительность Серы",
		pl = "OBR ↓ + laser trwa dłużej",
		pt_br = "Dano ↓ + laser dura mais tempo",
		ko_kr = "공격력 하락 + 혈사포 지속 시간 증가",
		zh_cn = "伤害下降 + 可拓张的硫磺火",
		cs_cz = "Poškození ↓ + Brimstone vydrží déle",
		uk_ua = "Шкода ↓ + подовжена тривалість Сірки",
	},
	[PlayerType.PLAYER_LAZARUS] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Extra Lazarus' Rags revive",
		ru = "Дополнительное возрождение от Лохмотьев Лазаря",
		pl = "Dodatkowe życie",
		pt_br = "Vida extra",
		ko_kr = "나사로의 누더기 부활 횟수 1회 추가",
		zh_cn = "额外的复活次数",
		cs_cz = "Bonusové povstání",
		uk_ua = "Додаткове воскресіння від Ганчір'я Лазаря",
	},
	[PlayerType.PLAYER_EDEN] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "3 unchanging random trinket effects",
		ru = "3 случайных неизменных эффектов брелков",
		pl = "Efekty 3 losowych trynkietów",
		pt_br = "efeitos de três berloques",
		ko_kr = "무작위 장신구 효과 3개 부여",
		zh_cn = "+3 随机饰品",
		cs_cz = "3 náhodné neměnící efekty cetek",
		uk_ua = "3 незмінні випадкові ефекти брелоків",
	},
	[PlayerType.PLAYER_THELOST] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Astral Projection on Holy Mantle breakage",
		ru = "Астральная Проэкция при потери Святой Мантии",
		pl = "Astralna Projekcja przy utracie tarczy",
		pt_br = "Projeção Astral quando o Manto Sagrado quebrar",
		ko_kr = "성스러운 망토 보호막 파괴 시 시간이 느려짐",
		zh_cn = "护盾破碎, 时间骤停",
		cs_cz = "Astrální Projekce při rozbití Svatého Pláště",
		uk_ua = "Астральна проекція при поломці Святої Мантії",
	},
	[PlayerType.PLAYER_LILITH] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Buddies may copy tear effects",
		ru = "Спутники могут скопировать эффекты слёз",
		pl = "Sojusznicy czasami kopiują efekty twoich łez",
		pt_br = "Amigos talvez copiarão efeitos das lágrimas",
		ko_kr = "패밀리어들이 가끔 눈물 효과를 복사함",
		zh_cn = "跟班概率复制泪弹特效",
		cs_cz = "Kamarádi mohou kopírovat efekty slz",
		uk_ua = "Друзяки можуть копіювати ефекти сліз",
	},
	[PlayerType.PLAYER_KEEPER] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Nickel in Shop and Devil Rooms",
		ru = "Пятак в Магазине и комнате Сделки с Дьяволом",
		pl = "Piątak w sklepach i pokojach Diabła",
		pt_br = "Níquel nas lojas e salas do demônio",
		ko_kr = "상점, 악마 방에 5센트 주화 생성",
		zh_cn = "在商店和恶魔房嫖点镍币",
		cs_cz = "Niklák v obchodě a v ďábelské místnosti",
		uk_ua = "П'ятак в магазинах та кімнатах Диявола",
	},
	[PlayerType.PLAYER_APOLLYON] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Trinkets can be absorbed with Void",
		ru = "Брелки могут быть поглощены Пустотой",
		pl = "Pustka może pochłaniać trynkiety",
		pt_br = "Berloques podem ser absorvidos com o Vazio",
		ko_kr = "공허 아이템으로 장신구도 흡수 가능",
		zh_cn = "虚空可以吞噬饰品",
		cs_cz = "Cetky mohou být absorbovány Prázdnotou",
		uk_ua = "Порожнеча може поглинати брелоки",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = { 			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Shoot bone-body to fill for fading tears up",
		ru = "Стреляй в тело-скелет, чтобы заполнить его для убывающего повышения скорострельности",
		pl = "Strzel w ciało, aby je naładować bonusem do szybkostrzelności",
		pt_br = "Atire no corpo de esquelto para atirar mais rápido por um tempo",
		ko_kr = "해골에 눈물을 쏘면 일시적으로 연사력 증가",
		zh_cn = "攻击遗骸填充射速增益",
		cs_cz = "Střílej do těla pro dočasné rychlé střílení",
			uk_ua = "Стріляй в тіло-скелет щоб наповнювати спадаючий темп стрільби",
	},
	[PlayerType.PLAYER_BETHANY] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "May spawn additional wisp on active use",
		ru = "При использовании активируемого предмета может появиться дополнительный огонек",
		pl = "Użyte przedmioty czasami dają dodatkowe ogniki",
		pt_br = "Talvez invoque outra fumaça ao usar o item ativo",
		ko_kr = "액티브 사용 시 가끔씩 추가 위습 생성",
		zh_cn = "主动概率生成额外魂火",
		cs_cz = "Může vytvořit dodatečné bludičky při použití aktivního předmětu",
		uk_ua = "Можливі додаткові вогники при використанні активних предметів",
	},
	[PlayerType.PLAYER_JACOB] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "All damage hurts the other brother instead",
		ru = "Весь урон получает другой брат вместо этого",
		pl = "Przenosi krzywdę do brata",
		pt_br = "Todo dano tomado é direcionado ao outro irmão",
		ko_kr = "소지 시 피해를 무시하지만 그 때마다 나머지 형제가 대신 피격됨",
		zh_cn = "受到的伤害转移到兄弟身上",
		cs_cz = "Veškeré poškození zraňuje tvého bratra",
		uk_ua = "Вся шкода завдається іншому братові",
	},
	[PlayerType.PLAYER_ISAAC_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Extra inventory slot",
		ru = "Дополнительный слот инвентаря",
		pl = "Dodatkowe miejsce w ekwipunku",
		pt_br = "Extra espaço no inventário",
		ko_kr = "인벤토리 슬롯 +1",
		zh_cn = "额外的物品栏",
		cs_cz = "Další slot v inventáři",
		uk_ua = "Додатковий слот для інвентарю",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Temp. hearts ejected from enemies explode",
		ru = "Временные сердца, падающие с врагов, взрываются",
		pl = "Serduszka z przeciwników wybuchają",
		pt_br = "Corações ejetados dos inimigos explodem",
		ko_kr = "적이 드랍하는 하트가 폭발을 일으킴",
		zh_cn = "怪物产生的临时心会爆炸",
		cs_cz = "Dočasná srdce vybuchují",
		uk_ua = "Тимчасові серця із ворогів вибухають"
	},
	[PlayerType.PLAYER_CAIN_B] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Double pickups are split apart",
		ru = "Двойные подбираемые предметы распадаются на части",
		pl = "Rozdziela podwójne pickupy",
		pt_br = "Captadores duplos são separados",
		ko_kr = "2중 픽업이 두 개의 단일 픽업으로 분해됨",
		zh_cn = "双掉落物分解",
		cs_cz = "Dvojité sběrné předměty jsou rozděleny",
		uk_ua = "Подвійні витратники роздвоєні", --EID використовує "розхідники", але то, здається, є русизмом
	},
	[PlayerType.PLAYER_JUDAS_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Pass through with Dark Arts for active charge",
		ru = "Прохождение сквозь врагов под Темными Искусствами заряжает активный предмет",
		pl = "Mroczne Techniki ładują się szybciej, gdy trafiają przeciwników",
		pt_br = "Passe por inimigos com Artes Sombrias para ganhar cargas",
		ko_kr = "흑마술로 적 관통 시 액티브 충전",
		zh_cn = "暗仪刺刀标记敌人获得冷却缩减",
		cs_cz = "Procházej nepřáteli s Temným Uměním pro rychlejší nabíjení",
		uk_ua = "Проходь крізь ворогів за допомогою Темним мистецтвом для заряду",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Poops may not be hurt",
		ru = "Какашки могут не повредиться",
		pl = "Kupy są niezniszczalne",
		pt_br = "Cocôs talvez não sofrerão danos",
		ko_kr = "똥이 적으로부터의 피해를 무시함",
		zh_cn = "大便概率不受到伤害",
		cs_cz = "Hovna nemusí být zraněna",
		uk_ua = "Какашки можуть не пошкодитись",
	},
	[PlayerType.PLAYER_EVE_B] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Clots drop creep on death",
		ru = "Сгустки оставляют лужу при смерти",
		pl = "Zakrzepki zostawiają maź po śmierci",
		pt_br = "Coágulos deixam uma trilha de sangue ao morrer",
		ko_kr = "핏덩이 사망 시 피 장판 생성",
		zh_cn = "血团死亡后留下血迹",
		cs_cz = "Sraženiny vytvoří kaluže po smrti",
		uk_ua = "Згустки залишають калюжу при вмиранні",
	},
	[PlayerType.PLAYER_SAMSON_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Room clear may (extend Berserk + drop heart)",
		ru = "Зачистка комнат может (продлить действие Берсерка + создать сердце)",
		pl = "Kończenie pokojów czasami wydłuża stan Berserka i tworzy serduszko",
		pt_br = "Terminar salas talvez extenda Berserk + dar um coração",
		ko_kr = "방 클리어 시 폭주 지속 시간이 증가하고 빨간 하트를 생성할 수도 있음",
		zh_cn = "清理房间有概率掉落红心 + 延长狂战",
		cs_cz = "Dokončení místnosti může (prodloužit Běsnění + vytvořit srdce)",
		uk_ua = "При зачистки кімнати можливе (продовження Берсерк! + випадання серця)",
	},
	[PlayerType.PLAYER_AZAZEL_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Sneeze brimstone-marking booger tears",
		ru = "Вычихивание соплей с меткой серы",
		pl = "Kichaj naznaczającymi smarkami",
		pt_br = "Lágrimas de meleca ao espirrar",
		ko_kr = "재채기를 하면 혈사포 표식 효과를 부여하는 코딱지도 같이 발사됨",
		zh_cn = "咳血发射鼻涕泪弹",
		cs_cz = "Kýchej Brimstone-označující soplové slzy",
		uk_ua = "Чхай соплі з міткою сірки",
	},
	[PlayerType.PLAYER_LAZARUS_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Flipping items splits items into both sides",
		ru = "Переворачивание предметов разделяет их на обе части",
		pl = "Odwrót czasami rozdziela przedmioty na obie strony",
		pt_br = "Trocar o item dividirá ambos os lados",
		ko_kr = "아이템에 뒤집기 사용 시 아이템 2개로 분리됨",
		zh_cn = "将可逆转的道具一分为二",
		cs_cz = "Překlopení předmětů je rozdělí na obě verze",
		uk_ua = "Перевернення предметів роздвоює їх на обидві сторони",
	},
	[PlayerType.PLAYER_EDEN_B] = { 					-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "May not reroll everything when hurt",
		ru = "Может не изменить всё при получении урона",
		pl = "Blokuje losowanie przy trafieniu",
		pt_br = "Talvez não mudará todos os seus items ao sofrer dano",
		ko_kr = "피격 시 가끔씩 리롤 효과 무시",
		zh_cn = "受伤也不一定等于重随一切",
		cs_cz = "Nemusí vše změnit při poškození",
		uk_ua = "Шанс не реролити все при шкоді",
	},
	[PlayerType.PLAYER_THELOST_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Holy Card + cards may be Holy Card more",
		ru = "Святая Карта + карты могут стать Святыми Картами чаще",
		pl = "Święta Karta + więcej Świętych Kart",
		pt_br = "Carta sagrada + Mais chance de cartas sagradas",
		ko_kr = "성스러운 카드 효과 + 성스러운 카드 변환 확률 증가",
		zh_cn = "神圣卡 + 更多神圣卡",
		cs_cz = "Svatá Karta + více Svatých Karet",
		uk_ua = "Свята картка + більший шанс, що карти будуть Святими Картками",
	},
	[PlayerType.PLAYER_LILITH_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Chance for additional Gello on birth",
		ru = "Шанс на дополнительного Гелло при рождении", --"on birth"? maybe just "on shoot", but ok
		pl = "Czasami rodzisz dwa bachory",
		pt_br = "Chance de invocar outro Gello ao atirar",
		ko_kr = "젤로 투척 시 일정 확률로 젤로 1명이 추가로 튀어나옴",
		zh_cn = "有概率额外生出一个格罗",
		cs_cz = "Šance při porodu pro dalšího Gella",
		uk_ua = "Шанс на додатковий Гелло при народженні",
	},
	[PlayerType.PLAYER_KEEPER_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Spawn a mini-shop every floor",
		ru = "Создает мини-магазин каждый этаж",
		pl = "Mini sklep na każdym piętrze",
		pt_br = "Invoca uma pequena loja todo andar",
		ko_kr = "매 층마다 소형 상점 생성",
		zh_cn = "每层生成一个打折地摊",
		cs_cz = "Vytvoří mini-obchod každé patro",
		uk_ua = "Створює міні-магазин в кожному поверсі",
	},
	[PlayerType.PLAYER_APOLLYON_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Abyss-absorb trinkets for half-DMG locusts",
		ru = "Поглощение Бездной брелков для саранчи с Уроном x0.5",
		pl = "Pochłaniaj trynkiety, aby dostać szarańcze o połowicznych obrażeniach",
		pt_br = "Abismo consegue absorber trinkets para ganhar gafanhotos de metade de dano",
		ko_kr = "무저갱으로 장신구 흡수 가능, 흡수 시 데미지 절반짜리 메뚜기 생성",
		zh_cn = "无底洞可以吞噬饰品换取一半伤害的蝗虫",
		cs_cz = "Absorbuj cetky Propastí pro slabší kobylky",
		uk_ua = "Поглинай брелоки Безоднею для сарани із пів-Шкодою", --EID для Безодні називає їх мухами чогось???
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = { 			-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Kill for bone-orbitals + hold body to gather",
		ru = "Убивай для орбитальных костей + возьми тело, чтобы собрать их",
		pl = "Zabijanie przeciwników tworzy kości + zbieraj podnosząć ciało",
		pt_br = "Mate para ganhar orbitais de osso + segure o corpo para reunílos",
		ko_kr = "적 처치 시 뼛조각생성; 해골을 들면 뼛조각이 오비탈이 됨",
		zh_cn = "杀死敌人获取骨片 + 举起遗骸聚集骨片",
		cs_cz = "Zabíjej pro úlomky kostí + drž tělo pro sbírání",
		uk_ua = "Вбивай для уламок кісток + тримай тіло, щоб збирати",
	},
	[PlayerType.PLAYER_BETHANY_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Wisps have double health",
		ru = "Двойное здоровье у огоньков",
		pl = "Ogniki mają podwojone zdrowie",
		pt_br = "Fumaças tem o dobro de vida",
		ko_kr = "위습 체력 2배",
		zh_cn = "魂火获得双倍生命",
		cs_cz = "Bludičky mají vyšší zdravý",
		uk_ua = "Вогники мають подвійне здоров'я",
	},
	[PlayerType.PLAYER_JACOB_B] = { 				-- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [OK] | PL: [OK] | KO_KR [OK] | PT_BR [OK] | ZH_CN [OK]
		en_us = "Dark Esau leaves a flame-trail",
		ru = "Тёмный Исав оставляет огненный след",
		pl = "Mroczny Ezaw zostawia ognisty ślad",
		pt_br = "Esaú sombrio deixa uma trilha de chamas",
		ko_kr = "검은 에사우가 돌진하면 그 자리에 불꽃을 남김",
		zh_cn = "堕化以扫会留下火墙",
		cs_cz = "Temný Ezau zanechává plamenitou cestu",
		uk_ua = "Темний Ісав залишає вогняний слід",
	}
}

local function accurateBlurbsPatch()
	local DESCRIPTION_SHARE = {
		[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
		[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_LAZARUS2] = PlayerType.PLAYER_LAZARUS,
		[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS_B,
		[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB_B,
		[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
		[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN_B,
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
