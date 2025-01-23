local Mod = BirthcakeRebaked
local loader = BirthcakeRebaked.PatchesLoader

---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
BirthcakeRebaked.BirthcakeAccurateBlurbs = {
	[PlayerType.PLAYER_ISAAC] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Dice Shard in Starting Rooms",
		ru = "Создает Осколок Кости + Осколки Кости в стартовой комнате",
		pl = "Odłamki Kości w pokojach Skarbów i Bossa",
	},
	[PlayerType.PLAYER_MAGDALENE] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Heart pickups may double",
		ru = "Подбираемые сердца могут удвоиться",
		pl = "Serca są czasami podwojone. Serduszko daje pół serca dusz",
	},
	[PlayerType.PLAYER_CAIN] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Machines may refund",
		ru = "(Игральные автоматы + Автоматы предсказаний + Кран-машины) могут возвратить деньги", --Looks too long, I'll mb change that later
		pl = "Automaty do Gier i z Wróżbami czasami zwracają pieniądze. Chwytaki również, ale rzadziej",
	},
	[PlayerType.PLAYER_JUDAS] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "DMG multiplier + exchange for lethal Deal",
		ru = "Множитель урона ↑ + летальная Сделка с Дьяволом совершается по цене Пироженного",
		pl = "Większe obrażenia i mnożnik obrażeń. Zapobiega śmierci, ale zostaje zniszcony",
	},
	[PlayerType.PLAYER_BLUEBABY] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Active use drop poops depending on charge",
		ru = "Активные предметы создают какашки в зависимости от их заряда",
		pl = "Przedmioty aktywne tworzą kupy zależnie od ładunków",
	},
	[PlayerType.PLAYER_EVE] = { -- EN: [X] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "(DMG scaling + blood-creep) for Dead Bird",
		ru = "Изменение урона Мертвой Птицы от урона персонажа + она оставляет кровавый след", --how the f am i supposed to translate "scaling"?
		pl = "Obrażenia najpierw zabierają czerwone zdrowie, bez zmniejszania szansy na pokój Diabła",
	},
	[PlayerType.PLAYER_SAMSON] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Drop red hearts at maximum rage",
		ru = "Роняет красные сердца при максимальном уровне ярости",
		pl = "Tworzy serduszka po osiągnieciu maksymalnego gniewu",
	},
	[PlayerType.PLAYER_AZAZEL] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "DMG down + extended Brimstone duration",
		ru = "Урон ↓ + длительность луча серы увеличивается по мере нанесения урона",
		pl = "Zadawanie obrażeń wydłuża laser",
	},
	[PlayerType.PLAYER_LAZARUS] = { -- EN: [OK] | RU: [Х] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Extra Lazarus' Rags revive",
		ru = "???",
		pl = "Obrażenia w pokoju i serce dusz po odrodzeniu",
	},
	[PlayerType.PLAYER_EDEN] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "3 unchanging random trinket effects",
		ru = "Проглатывает 3 случайных брелока + можно выбросить",
		pl = "3 losowe połknięte trynkiety",
	},
	[PlayerType.PLAYER_THELOST] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Astral Projection on Holy Mantle breakage",
		ru = "Эффект Астральной Проэкции при потери Мантии",
		pl = "2 darmowe użycia przedmiotu na piętro. Wieczne D6 wykonuje efekt D6 + Prawo Urodzenia",
	},
	[PlayerType.PLAYER_LILITH] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Buddies may copy tear effects",
		ru = "Спутники имеют шанс скопировать эффекты слез",
		pl = "Sojusznicy czasami kopiują efekty twoich łez",
	},
	[PlayerType.PLAYER_KEEPER] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Nickel in Shop and Devil Rooms",
		ru = "Пятак в Магазине и комнате Сделки с Дьяволом",
		pl = "Piątak w sklepach i pokojach Diabła",
	},
	[PlayerType.PLAYER_APOLLYON] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Trinkets can be absorbed with Void",
		ru = "Брелки могут быть поглощены",
		pl = "Jadalne trynkiety",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Shoot bone-body to fill for fading tears up",
		ru = "Стреляй по скелету для зарядки + вселись для убывающего повышения скорострельности",
		pl = "Strzel w ciało, aby je naładować. Wróc do niego, aby dostać bonus do szybkostrzelności"
	},
	[PlayerType.PLAYER_BETHANY] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "May spawn additional wisp on active use",
		ru = "При использовании активируемого предмета может появиться дополнительный огонек",
		pl = "Użyte przedmioty czasami dają dodatkowe ogniki",
	},
	[PlayerType.PLAYER_JACOB] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "All damage hurts the other brother instead",
		ru = "Получаемый урон перенаправляется на другого брата",
		pl = "Dostań część statystyk od brata",
	},
	[PlayerType.PLAYER_ISAAC_B] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Extra inventory slot",
		ru = "Дополнительный слот инвентаря",
		pl = "Dodatkowe miejsce w ekwipunku",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Temp. hearts ejected from enemies explode",
		ru = "Временные сердца, падающие с врагов, взрываются",
		pl = "Serduszka z przeciwników wybuchają",
	},
	[PlayerType.PLAYER_CAIN_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Double pickups are split apart",
		ru = "Двойные подбираемые предметы распадаются",
		pl = "Rozdziela podwójne pickupy",
	},
	[PlayerType.PLAYER_JUDAS_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Pass through with Dark Arts for active charge",
		ru = "Прохождение сквозь врагов под действием Темных Искусств заряжает активный предмет",
		pl = "Mroczne Techniki ładują się szybciej, gdy trafiają przeciwników",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Poops may not be hurt",
		ru = "Твои какашки могут не получить урон",
		pl = "Kupy blokują pociski i spowalniają przeciwników",
	},
	[PlayerType.PLAYER_EVE_B] = { -- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Clots drop creep on death",
		ru = "???",
	},
	[PlayerType.PLAYER_SAMSON_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Room clear may (extend Berserk + drop heart)",
		ru = "Зачистка комнат может продлить действие Берсерка и создать сердце",
		pl = "Kończenie pokojów czasami wydłuża stan Berserka i tworzy serduszko",
	},
	[PlayerType.PLAYER_AZAZEL_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Sneeze brimstone-marking booger tears",
		ru = "Вычихивание слез с меткой серы, имеющих маленький шанс прилипнуть",
		pl = "Kichaj naznaczającymi łzami. Czasami są lepkie",
	},
	[PlayerType.PLAYER_LAZARUS_B] = { -- EN: [OK] | RU: [X] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Flipping items may split items into both sides",
		ru = "???",
	},
	[PlayerType.PLAYER_EDEN_B] = { -- EN: [OK] | RU: [ОК] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "May not reroll everything when hurt",
		ru = "Может не поменять все при получении урона",
		pl = "3 losowe połknięte trynkiety, ciągle zmienne",
	},
	[PlayerType.PLAYER_THELOST_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Holy Card + cards may be Holy Card more",
		ru = "Больше Святых Карт",
	},
	[PlayerType.PLAYER_LILITH_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Chance for additional Gello on birth",
		ru = "Шанс на дополнительного зародыша",
	},
	[PlayerType.PLAYER_KEEPER_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Spawn a mini shop every floor",
		ru = "Создает мини-магазин каждый этаж",
		pl = "Mini sklep na każdym piętrze",
	},
	[PlayerType.PLAYER_APOLLYON_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Abyss-absorb trinkets for half-DMG locusts",
		ru = "Поглощение брелоков создает саранчу с половиной урона персонажа",
		pl = "Pochłaniaj trynkiety, aby dostać szarańcze o połowicznych obrażeniach",
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [!]
		en_us = "Kill for bone-orbitals + hold body to gather",
		ru = "Создает орбитальные кости при убийстве врагов. Бросок Забытого стреляет ими",
		pl = "Zabijanie przeciwników tworzy kości. Rzuć ciałem, by je wystrzelić",
	},
	[PlayerType.PLAYER_BETHANY_B] = { -- EN: [OK] | RU: [OK] | SPA: [X] | CS_CZ: [X] | PL: [OK]
		en_us = "Wisps have double health",
		ru = "Двойное здоровье у огоньков",
		pl = "Ogniki mają podwojone zdrowie",
	},
	[PlayerType.PLAYER_JACOB_B] = { -- EN: [OK] | RU: [!] | SPA: [X] | CS_CZ: [X] | PL: [X]
		en_us = "Dark Esau leaves a flame-trail",
		ru = "Темный Исав оставляет огненный след",
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
