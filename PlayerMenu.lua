--[[---------------------------------------------------------------------------------
  PLAYER (SELF) MENU COMMANDS
----------------------------------------------------------------------------------]]
-- Whisper all in raid (added or removed below)
UnitPopupButtons["SELF_SEND_COMMAND_TO_ALL"] = { text = "|cFFFF80FFWhisper to All|r", dist = 0 }
table.insert(UnitPopupMenus["SELF"], 1, "SELF_SEND_COMMAND_TO_ALL")

-- Dungeon Settings (Difficulty, Reset option)
UnitPopupButtons["SELF_DUNGEON_SETTINGS"] = { text = "|cFFD2B48CDungeon Settings|r", dist = 0, nested = 1 }
UnitPopupButtons["SELF_DUNGEON_NORMAL"] = { text = "Set Difficulty: |cff1EFF00Normal|r", dist = 0 }
UnitPopupButtons["SELF_DUNGEON_HEROIC"] = { text = "Set Difficulty: |cFFFFAA00Heroic|r", dist = 0 }
UnitPopupButtons["SELF_RESET_INSTANCES"] = { text = "Reset all instances", dist = 0 }
StaticPopupDialogs["SELF_RESET_INSTANCES_CONFIRM"] = {
	text = "Do you really want to reset all of your instances?",
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		RunScript("ResetInstances()")
	end,
	timeout = 0,
	hideOnEscape = 1
}
UnitPopupMenus["SELF_DUNGEON_SETTINGS"] = { "SELF_DUNGEON_NORMAL", "SELF_DUNGEON_HEROIC", "SELF_RESET_INSTANCES" }
table.insert(UnitPopupMenus["SELF"],1,"SELF_DUNGEON_SETTINGS")

-- View miscellaneous stats
UnitPopupButtons["SELF_NYCTERMOON_STATS"] = { text = "|cFFFFAA00Nyctermoon Stats|r", dist = 0, nested = 1 }
UnitPopupButtons["SELF_LEGACY_BONUS"] = { text = "|cFFFFAA00Legacy Overview|r", dist = 0 }
UnitPopupButtons["SELF_XP_BONUS"] = { text = "|cFFFFFFA0Current XP Bonus|r", dist = 0 }
UnitPopupButtons["SELF_COMPANION_INFO"] = { text = "Companion Info", dist = 0 }
UnitPopupMenus["SELF_NYCTERMOON_STATS"] = { "SELF_LEGACY_BONUS", "SELF_XP_BONUS", "SELF_COMPANION_INFO" }
table.insert(UnitPopupMenus["SELF"], 1, "SELF_NYCTERMOON_STATS")