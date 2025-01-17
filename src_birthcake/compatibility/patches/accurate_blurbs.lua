local loader = BirthcakeRebaked.PatchesLoader

local function accurateBlurbsPatch()
	local DESCRIPTION_SHARE  = {
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
		},
		[PlayerType.PLAYER_MAGDALENE] = {
			en_us = "Heart pickups may double. Yum Heart gives a half soul heart",
		},
		[PlayerType.PLAYER_CAIN] = {
			en_us = "Slot and Fortune Machines may refund money. Crane Game too, but lower chance",
		},
		[PlayerType.PLAYER_JUDAS] = {
			en_us = "Flat and multiplier damage up. Prevents death but gets consumed",
		},
		[PlayerType.PLAYER_BLUEBABY] = {
			en_us = "Active items create poops based on charge",
		},
		[PlayerType.PLAYER_EVE] = {
			en_us = "Red hearts are hurt before others, no devil deal penalty",
		},
		[PlayerType.PLAYER_SAMSON] = {
			en_us = "Drops red hearts at maximum rage",
		},
		[PlayerType.PLAYER_AZAZEL] = {
			en_us = "Longer brimstone from dealing damage",
		},
		[PlayerType.PLAYER_LAZARUS] = {
			en_us = "Room damage and soul heart on revival",
		},
		[PlayerType.PLAYER_LAZARUS2] = {
			en_us = "Wait till next floor for effect",
		},
		[PlayerType.PLAYER_EDEN] = {
			en_us = "3 random gulped trinkets",
		},
		[PlayerType.PLAYER_THELOST] = {
			en_us = "Two free active uses per floor. Eternal D6 does a D6 + Birthright reroll",
		},
		[PlayerType.PLAYER_LILITH] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_KEEPER] = {
			en_us = "Nickel in Shop and Devil rooms",
		},
		[PlayerType.PLAYER_APOLLYON] = {
			en_us = "Voidable trinkets",
		},
		[PlayerType.PLAYER_THEFORGOTTEN] = {
			en_us = "Shoot Forgotten's Body to charge it, swap back for tears up",
		},
		[PlayerType.PLAYER_BETHANY] = {
			en_us = "Additional Wisp may spawn on active use",
		},
		[PlayerType.PLAYER_JACOB] = {
			en_us = "Gain a small percentage of stats from the other brother",
		},
		[PlayerType.PLAYER_ISAAC_B] = {
			en_us = "Extra inventory slot",
		},
		[PlayerType.PLAYER_MAGDALENE_B] = {
			en_us = "Temporary hearts from enemies explode",
		},
		[PlayerType.PLAYER_CAIN_B] = {
			en_us = "Double pickups are split into their halves",
		},
		[PlayerType.PLAYER_JUDAS_B] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_BLUEBABY_B] = {
			en_us = "Poops block projectiles and slow enemies",
		},
		[PlayerType.PLAYER_EVE_B] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_SAMSON_B] = {
			en_us = "Clearing rooms may extend Berserk and spawn a heart",
		},
		[PlayerType.PLAYER_AZAZEL_B] = {
			en_us = "Sneeze brimstone-marking tears. Small chance to stick",
		},
		[PlayerType.PLAYER_LAZARUS_B] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_EDEN_B] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_THELOST_B] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_LILITH_B] = {
			en_us = "???",
		},
		[PlayerType.PLAYER_KEEPER_B] = {
			en_us = "Spawns a mini shop every floor",
		},
		[PlayerType.PLAYER_APOLLYON_B] = {
			en_us = "Abyssable trinkets for half damage locusts",
		},
		[PlayerType.PLAYER_THEFORGOTTEN_B] = {
			en_us = "Killing enemies spawns orbitals. Throw Forgotten to fire them",
		},
		[PlayerType.PLAYER_BETHANY_B] = {
			en_us = "Double health wisps",
		},
		[PlayerType.PLAYER_JACOB_B] = {
			en_us = "???",
		}
	}
end

loader:RegisterPatch("AccurateBlurbs", accurateBlurbsPatch)