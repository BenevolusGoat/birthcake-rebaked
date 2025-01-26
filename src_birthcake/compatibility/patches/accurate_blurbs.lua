local Mod = BirthcakeRebaked
local loader = BirthcakeRebaked.PatchesLoader

---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
BirthcakeRebaked.BirthcakeAccurateBlurbs = {
	[PlayerType.PLAYER_ISAAC] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Dice Shard in Starting Rooms",
		ru = "Создает Осколок Кости + Осколки Кости в стартовой комнате",
		pl = "Odłamki Kości w pokojach Skarbów i Bossa",
		pt_br = "Fragmentos de dado nas salas iniciais",
	},
	[PlayerType.PLAYER_MAGDALENE] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Heart pickups may double",
		ru = "Подбираемые сердца могут удвоиться",
		pl = "Serca są czasami podwojone. Serduszko daje pół serca dusz",
		pt_br = "Corações talvez dobrem",
	},
	[PlayerType.PLAYER_CAIN] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Machines may refund",
		ru = "Автоматы могут возвратить деньги",
		pl = "Automaty do Gier i z Wróżbami czasami zwracają pieniądze. Chwytaki również, ale rzadziej",
		pt_br = "Máquinas provavelmente darão reembolsos",
	},
	[PlayerType.PLAYER_JUDAS] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "DMG multiplier + exchange for lethal Deal",
		ru = "Множитель Урона ↑ + обмен на летальную Сделку",
		pl = "Większe obrażenia i mnożnik obrażeń. Zapobiega śmierci, ale zostaje zniszcony",
		pt_br = "Multiplicador de dano + troca por trato letal",
	},
	[PlayerType.PLAYER_BLUEBABY] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Active use drop poops depending on charge",
		ru = "Использование активных предметов бросает какашки в зависимости от заряда",
		pl = "Przedmioty aktywne tworzą kupy zależnie od ładunków",
		pt_br = "Items ativos jogam cocôs dependendo da quantidade de cargas",
	},
	[PlayerType.PLAYER_EVE] = { -- EN: [X] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "(DMG scaling + blood-creep) for Dead Bird",
		ru = "(скейлинг Урона + кровавый след) для Мертвой Птицы", --how the f am i supposed to translate "scaling"?
		pl = "Obrażenia najpierw zabierają czerwone zdrowie, bez zmniejszania szansy na pokój Diabła",
		pt_br = "Mais dano + trilha de sangue para o pássaro morto",
	},
	[PlayerType.PLAYER_SAMSON] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Drop red hearts at maximum rage",
		ru = "Роняет красные сердца при максимальном уровне ярости",
		pl = "Tworzy serduszka po osiągnieciu maksymalnego gniewu",
		pt_br = "Ganhe corações vermelhos quando chegar a raiva máxima",
	},
	[PlayerType.PLAYER_AZAZEL] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "DMG down + extended Brimstone duration",
		ru = "Урон ↓ + увеличенная длительность Серы",
		pl = "Zadawanie obrażeń wydłuża laser",
		pt_br = "Dano ↓ + laser dura mais tempo",
	},
	[PlayerType.PLAYER_LAZARUS] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Extra Lazarus' Rags revive",
		ru = "Дополнительное возрождение от Лохмотьев Лазаря",
		pl = "Obrażenia w pokoju i serce dusz po odrodzeniu",
		pt_br = "Vida extra",
	},
	[PlayerType.PLAYER_EDEN] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "3 unchanging random trinket effects",
		ru = "3 случайных неизменных эффектов брелков",
		pl = "3 losowe połknięte trynkiety",
		pt_br = "efeitos de três berloques",
	},
	[PlayerType.PLAYER_THELOST] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Astral Projection on Holy Mantle breakage",
		ru = "Астральная Проэкция при потери Святой Мантии",
		pl = "2 darmowe użycia przedmiotu na piętro. Wieczne D6 wykonuje efekt D6 + Prawo Urodzenia",
		pt_br = "Projeção Astral quando o Manto Sagrado quebrar",
	},
	[PlayerType.PLAYER_LILITH] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Buddies may copy tear effects",
		ru = "Спутники могут скопировать эффекты слез",
		pl = "Sojusznicy czasami kopiują efekty twoich łez",
		pt_br = "Amigos talvez copiarão efeitos das lágrimas",
	},
	[PlayerType.PLAYER_KEEPER] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Nickel in Shop and Devil Rooms",
		ru = "Пятак в Магазине и комнате Сделки с Дьяволом",
		pl = "Piątak w sklepach i pokojach Diabła",
		pt_br = "Níquel nas lojas e salas do demônio",
	},
	[PlayerType.PLAYER_APOLLYON] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Trinkets can be absorbed with Void",
		ru = "Брелки могут быть поглощены Пустотой",
		pl = "Jadalne trynkiety",
		pt_br = "Berloques podem ser absorvidos com o Vazio",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Shoot bone-body to fill for fading tears up",
		ru = "Стреляй в скелет, чтобы заполнить его для убывающего повышения скорострельности",
		pl = "Strzel w ciało, aby je naładować. Wróc do niego, aby dostać bonus do szybkostrzelności",
		pt_br = "Atire no corpo de esquelto para atirar mais rápido por um tempo",
	},
	[PlayerType.PLAYER_BETHANY] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "May spawn additional wisp on active use",
		ru = "При использовании активируемого предмета может появиться дополнительный огонек",
		pl = "Użyte przedmioty czasami dają dodatkowe ogniki",
		pt_br = "Talvez invoque outra fumaça ao usar o item ativo",
	},
	[PlayerType.PLAYER_JACOB] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "All damage hurts the other brother instead",
		ru = "Весь урон получает другой брат вместо этого",
		pl = "Dostań część statystyk od brata",
		pt_br = "Todo dano tomado é direcionado ao outro irmão",
	},
	[PlayerType.PLAYER_ISAAC_B] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Extra inventory slot",
		ru = "Дополнительный слот инвентаря",
		pl = "Dodatkowe miejsce w ekwipunku",
		pt_br = "Extra espaço no inventário",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Temp. hearts ejected from enemies explode",
		ru = "Временные сердца, падающие с врагов, взрываются",
		pl = "Serduszka z przeciwników wybuchają",
		pt_br = "Corações ejetados dos inimigos explodem",
	},
	[PlayerType.PLAYER_CAIN_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Double pickups are split apart",
		ru = "Двойные подбираемые предметы распадаются на части",
		pl = "Rozdziela podwójne pickupy",
		pt_br = "Captadores duplos são separados",
	},
	[PlayerType.PLAYER_JUDAS_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Pass through with Dark Arts for active charge",
		ru = "Прохождение сквозь врагов под Темными Искусствами заряжает активный предмет",
		pl = "Mroczne Techniki ładują się szybciej, gdy trafiają przeciwników",
		pt_br = "Passe por inimigos com Artes Sombrias para ganhar cargas",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Poops may not be hurt",
		ru = "Какашки могут не повредиться",
		pl = "Kupy blokują pociski i spowalniają przeciwników",
		pt_br = "Cocôs talvez não sofrerão danos",
	},
	[PlayerType.PLAYER_EVE_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Clots drop creep on death",
		ru = "Сгустки оставляют лужу при смерти",
		pt_br = "Coágulos deixam uma trilha de sangue ao morrer",
	},
	[PlayerType.PLAYER_SAMSON_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Room clear may (extend Berserk + drop heart)",
		ru = "Зачистка комнат может (продлить действие Берсерка + создать сердце)",
		pl = "Kończenie pokojów czasami wydłuża stan Berserka i tworzy serduszko",
		pt_br = "Terminar salas talvez extenda Berserk + dar um coração",
	},
	[PlayerType.PLAYER_AZAZEL_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Sneeze brimstone-marking booger tears",
		ru = "Вычихивание прилипающих слез с меткой серы",
		pl = "Kichaj naznaczającymi łzami. Czasami są lepkie",
		pt_br = "Lágrimas de meleca ao espirrar",
	},
	[PlayerType.PLAYER_LAZARUS_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Flipping items may split items into both sides",
		ru = "Переворачивание предметов может разделить их на обе части", --This may not be accurate
		pt_br = "Trocar o item talvez dividira ambos os lados",
	},
	[PlayerType.PLAYER_EDEN_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "May not reroll everything when hurt",
		ru = "Может не поменять все при получении урона",
		pl = "3 losowe połknięte trynkiety, ciągle zmienne",
		pt_br = "Talvez não mudará todos os seus items ao sofrer dano",
	},
	[PlayerType.PLAYER_THELOST_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Holy Card + cards may be Holy Card more",
		ru = "Святая Карта + карты могут стать Святыми Картами больше",
		pt_br = "Carta sagrada + Mais chance de cartas sagradas",
	},
	[PlayerType.PLAYER_LILITH_B] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Chance for additional Gello on birth",
		ru = "Шанс на дополнительного Гелло при рождении", --"on birth"? maybe just "on shoot", but ok
		pt_br = "Chance de invocar outro Gello ao atirar",
	},
	[PlayerType.PLAYER_KEEPER_B] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Spawn a mini shop every floor",
		ru = "Создает мини-магазин каждый этаж",
		pl = "Mini sklep na każdym piętrze",
		pt_br = "Invoca uma pequena loja todo andar",
	},
	[PlayerType.PLAYER_APOLLYON_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Abyss-absorb trinkets for half-DMG locusts",
		ru = "Поглощение Бездной брелков для саранчи с половиной Урона",
		pl = "Pochłaniaj trynkiety, aby dostać szarańcze o połowicznych obrażeniach",
		pt_br = "Abismo consegue absorber trinkets para ganhar gafanhotos de metade de dano",
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Kill for bone-orbitals + hold body to gather",
		ru = "Убивай для орбитальных костей + возьми тело, чтобы собрать",
		pl = "Zabijanie przeciwników tworzy kości. Rzuć ciałem, by je wystrzelić",
		pt_br = "Mate para ganhar orbitais de osso + segure o corpo para reunílos",
	},
	[PlayerType.PLAYER_BETHANY_B] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Wisps have double health",
		ru = "Двойное здоровье у огоньков",
		pl = "Ogniki mają podwojone zdrowie",
		pt_br = "Fumaças tem o dobro de vida",
	},
	[PlayerType.PLAYER_JACOB_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Dark Esau leaves a flame-trail",
		ru = "Темный Исав оставляет огненный след",
		pt_br = "Esaú sombrio deixa uma trilha de chamas",
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
