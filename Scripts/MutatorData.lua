MutatorData =
{
	-- Remove enemy entirely
	NoHeavyMelee =
	{
		RemoveEnemies = { "HeavyMelee", "HeavyMeleeElite", },
	},
	NoSwarmer =
	{
		RemoveEnemies = { "Swarmer", "SwarmerElite", "LightSpawner", "LightSpawnerElite", },
	},
	NoCaster =
	{
		RemoveEnemies = { "LightRanged", "LightRangedElite", "SpreadShotUnit", "SpreadShotUnitElite", },
	},
	NoHeavyRanged =
	{
		RemoveEnemies = { "HeavyRanged", "HeavyRangedElite", },
	},
	NoShieldRanged =
	{
		RemoveEnemies = { "ShieldRanged", "ShieldRangedElite", },
	},
	NoThief =
	{
		RemoveEnemies = { "ThiefMineLayer", "ThiefMineLayerElite", },
	},
	NoBloodlessNaked =
	{
		RemoveEnemies = { "BloodlessNaked", "BloodlessNakedElite", },
	},
	NoBloodlessGrenadier =
	{
		RemoveEnemies = { "BloodlessGrenadier", "BloodlessGrenadierElite", },
		RemoveRooms = { "A_MiniBoss01", },
	},
	NoBloodlessSelfDestruct =
	{
		RemoveEnemies = { "BloodlessSelfDestruct", "BloodlessSelfDestructElite", },
		RemoveRooms = { "A_MiniBoss01", },
	},
	NoCrusherUnit =
	{
		RemoveEnemies = { "CrusherUnit", },
	},

	-- Remove normal versions
	NoHeavyMeleeNormal =
	{
		RemoveEnemies = { "HeavyMelee", },
	},
	NoSwarmerNormal =
	{
		RemoveEnemies = { "Swarmer", "LightSpawner", },
	},
	NoCasterNormal =
	{
		RemoveEnemies = { "LightRanged", "SpreadShotUnit", },
	},
	NoHeavyRangedNormal =
	{
		RemoveEnemies = { "HeavyRanged", },
	},
	NoShieldRangedNormal =
	{
		RemoveEnemies = { "ShieldRanged", },
	},
	NoThiefNormal =
	{
		RemoveEnemies = { "ThiefMineLayer", },
	},
	NoBloodlessNakedNormal =
	{
		RemoveEnemies = { "BloodlessNaked", },
	},
	NoBloodlessGrenadierNormal =
	{
		RemoveEnemies = { "BloodlessGrenadier", },
	},
	NoBloodlessSelfDestruct =
	{
		RemoveEnemies = { "BloodlessSelfDestruct", },
	},

	-- Remove elite versions
	NoHeavyMeleeElite =
	{
		RemoveEnemies = { "HeavyMeleeElite", },
	},
	NoSwarmerElite =
	{
		RemoveEnemies = { "SwarmerElite", "LightSpawnerElite", },
	},
	NoCasterElite =
	{
		RemoveEnemies = { "LightRangedElite", "SpreadShotUnitElite", },
	},
	NoHeavyRangedElite =
	{
		RemoveEnemies = { "HeavyRangedElite", },
	},
	NoShieldRangedElite =
	{
		RemoveEnemies = { "ShieldRangedElite", },
	},
	NoThiefElite =
	{
		RemoveEnemies = { "ThiefMineLayerElite", },
	},
	NoBloodlessNakedElite =
	{
		RemoveEnemies = { "BloodlessNakedElite", },
	},
	NoBloodlessGrenadierElite =
	{
		RemoveEnemies = { "BloodlessGrenadierElite", },
		RemoveRooms = { "A_MiniBoss01", },
	},
	NoBloodlessSelfDestructElite =
	{
		RemoveEnemies = { "BloodlessSelfDestructElite", },
		RemoveRooms = { "A_MiniBoss01", },
	},

	-- No room reward
	NoBoon =
	{
		RemoveRoomRewards = { "Boon", "Devotion", },
	},
	NoRoomRewardMaxHealthDrop =
	{
		RemoveRoomRewards = { "RoomRewardMaxHealthDrop", },
	},
	NoStackUpgrade =
	{
		RemoveRoomRewards = { "StackUpgrade", }
	},
	NoWeaponUpgrade =
	{
		RemoveRoomRewards = { "WeaponUpgrade", },
	},

	-- No room
	NoSingleExitCombatRooms =
	{
		RemoveRooms = { "A_Combat01", "A_Combat02", "A_Combat04", "A_Combat07", "A_Combat08A", "A_Combat08B", "A_Combat09", "A_Combat11", "A_Combat13", "A_Combat14", "A_Combat15", "A_Combat18", "A_Combat19", "A_Combat21", "A_Combat24", "A_MiniBoss01", },
		GameStateRequirements =
		{
			MutatorInactive = "NoMultiExitRoom",
		}
	},
	NoMultiExitCombatRooms =
	{
		RemoveRooms = { "A_Combat05", "A_Combat06", "A_Combat10", "A_Combat12", "A_Combat16", "A_Combat17", "A_Combat20", },
		GameStateRequirements =
		{
			MutatorInactive = "NoSingleExitRoom",
		}
	},
	NoNonCombatRooms =
	{
		RemoveRooms = { "A_Reprieve01", "A_Story01", "A_Shop01", "B_Shop01", },
		MutatorInactive = "NoSingleExitRoom",
	},
	--[[
	NoSpikeTrapTooms =
	{
		RemoveRooms = { },
	},
	NoDartTrapTooms =
	{
		RemoveRooms = { },
	},
	--]]

	-- No encounter
	NoSurvival =
	{
		RemoveEncounters = { "SurvivalTartarus", "SurvivalAsphodel", },
	},

	-- Chance modifiers

	IncreasedHighValueBreakables =
	{
		BreakableChanceMultiplier = 10.0,
		GameStateRequirements =
		{
			MutatorInactive = "NoHighValueBreakables",
		}
	},
	NoHighValueBreakables =
	{
		BreakableChanceMultiplier = 0.0,
		GameStateRequirements =
		{
			MutatorInactive = "IncreasedHighValueBreakables",
		}
	},

	IncreasedSecretSpawnChance =
	{
		SecretSpawnChanceMultiplier = 10.0,
		GameStateRequirements =
		{
			MutatorInactive = "NoSecretSpawnChance",
		}
	},
	NoSecretSpawnChance =
	{
		SecretSpawnChanceMultiplier = 0.0,
		GameStateRequirements =
		{
			MutatorInactive = "IncreasedSecretSpawnChance",
		}
	},

	IncreasedChallengeSpawnChance =
	{
		ChallengeSpawnChanceMultiplier = 10.0,
		GameStateRequirements =
		{
			MutatorInactive = "NoChallengeSpawnChance",
		}
	},
	NoChallengeSpawnChance =
	{
		ChallengeSpawnChanceMultiplier = 0.0,
		GameStateRequirements =
		{
			MutatorInactive = "IncreasedChallengeSpawnChance",
		}
	},

	IncreasedWellShopSpawnChance =
	{
		WellShopSpawnChanceMultiplier = 10.0,
		GameStateRequirements =
		{
			MutatorInactive = "NoWellShopSpawnChance",
		}
	},
	NoWellShopSpawnChance =
	{
		WellShopSpawnChanceMultiplier = 0.0,
		GameStateRequirements =
		{
			MutatorInactive = "IncreasedWellShopSpawnChance",
		}
	},

}