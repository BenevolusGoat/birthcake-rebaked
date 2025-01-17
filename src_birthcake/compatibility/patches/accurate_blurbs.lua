local loader = BirthcakeRebaked.PatchesLoader

local function accurateBlurbsPatch()
	local DESCRIPTION_SHARE     = {
		[PlayerType.PLAYER_BLACKJUDAS] = PlayerType.PLAYER_JUDAS,
		[PlayerType.PLAYER_ESAU] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_LAZARUS2_B] = PlayerType.PLAYER_LAZARUS2,
		[PlayerType.PLAYER_JACOB2_B] = PlayerType.PLAYER_JACOB,
		[PlayerType.PLAYER_THESOUL] = PlayerType.PLAYER_THEFORGOTTEN,
		[PlayerType.PLAYER_THESOUL_B] = PlayerType.PLAYER_THEFORGOTTEN,
	}

	---Any empty descriptions are for characters that I may change the effect of, or ones I do want but haven't thought of an idea yet
	local BIRTHCAKE_DESCRIPTION = {
		[PlayerType.PLAYER_ISAAC] = {
			en_us = "Dice Shards in Treasure and Boss room",
			ru = "Осколки кости в Сокровищнице и комнате Босса",
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Heart pickups may double. Yum Heart gives a half soul heart",
			ru = "Подбираемые сердца могут удвоиться. Ням Сердце! дает половину сердца души",
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Slot and Fortune Machines may refund money. Crane Game too, but lower chance",
			ru = "Игральные автоматы могут возвратить деньги. Меньший шанс для Кран-машины",
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Flat and multiplier damage up. Prevents death but gets consumed",
			ru = "Плоский урон ↑, Множитель урона ↑. Спасает от смерти, после чего исчезает",
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "Active items create poops based on charge",
			ru = "Активные предметы создают какашки в зависимости от их заряда",
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = "Red hearts are hurt before others, no devil deal penalty",
			ru = "Красные сердца в приоритете при получении урона, при этом шанс сделок не снижается",
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Drops red hearts at maximum rage",
			ru = "Роняет красные сердца при максимальном уровне ярости",
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Longer brimstone from dealing damage",
			ru = "Длительность луча серы увеличивается по мере нанесения урона",
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Room damage and soul heart on revival",
			ru = "Урон по комнате и сердце души при возрождении",
		},
		[PlayerType.PLAYER_LAZARUS2] = {
			en_us = "Wait till next floor for effect",
			ru = "Подожди следующего этажа для эффекта",
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "3 random gulped trinkets",
			ru = "Приваривает 3 случайных брелока",
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "Two free active uses per floor. Eternal D6 does a D6 + Birthright reroll",
			ru = "2 бесплатных использования Вечного Д6 каждый этаж. Вечный Д6 делает реролл Д6 и Права первородства",
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "Familiars have a chance to copy your tear effects",
			ru = "Спутники имеют шанс скопировать эффекты слез",
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Nickel in Shop and Devil rooms",
			ru = "Пятак в Магазине и комнате Сделки с Дьяволом",
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Voidable trinkets",
			ru = "Поглощаемые брелки",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "Shoot Forgotten's Body to charge it, swap back for tears up",
			ru = 'Стрельба по телу Забытого "заряжает" его. При изменении режима повышение скорострельности',
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Additional Wisp may spawn on active use",
			ru = "При использовании активируемого предмета может появиться дополнительный огонек",
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Gain a small percentage of stats from the other brother",
			ru = "Получение небольшого процента характеристик другого брата",
		},
		[PlayerType.PLAYER_ISAAC_B] = {
			en_us = "Extra inventory slot",
			ru = "Дополнительный слот инвентаря",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {
			en_us = "Temporary hearts from enemies explode",
			ru = "Временные сердца, падающие с врагов, взрываются",
		},
		[PlayerType.PLAYER_CAIN_B] = {
			en_us = "Double pickups are split into their halves",
			ru = "Двойные подбираемые предметы распадаются на два обычных",
		},
		[PlayerType.PLAYER_JUDAS_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {
			en_us = "Poops block projectiles and slow enemies",
			ru = "Какашки блокируют снаряды и замедляют врагов",
		},
		[PlayerType.PLAYER_EVE_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_SAMSON_B] = {
			en_us = "Clearing rooms may extend Berserk and spawn a heart",
			ru = "Зачистка комнат может продлить действие Берсерка и создать сердце",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {
			en_us = "Sneeze brimstone-marking tears. Small chance to stick",
			ru = "Вычихивание слез с меткой серы, имеющих маленький шанс прилипнуть",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_EDEN_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_THELOST_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_LILITH_B] = {
			en_us = "???",
			ru = "???",
		},
		[PlayerType.PLAYER_KEEPER_B] = {
			en_us = "Spawns a mini shop every floor",
			ru = "Создает мини-магазин каждый этаж",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {
			en_us = "Abyssable trinkets for half damage locusts",
			ru = "Поглощение брелоков создает саранчу с половиной урона персонажа",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {
			en_us = "Killing enemies spawns orbitals. Throw Forgotten to fire them",
			ru = "Создает орбитальные кости при убийстве врагов. Бросок Забытого стреляет ими",
		},
		[PlayerType.PLAYER_BETHANY_B] = {
			en_us = "Double health wisps",
			ru = "Двойное здоровье у огоньков",
		},
		[PlayerType.PLAYER_JACOB_B] = {
			en_us = "???",
			ru = "???",
		}
	}
end

loader:RegisterPatch("AccurateBlurbs", accurateBlurbsPatch)
