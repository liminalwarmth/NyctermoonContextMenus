-- NyctermoonContextMenus.lua
-- Coded for Vanilla WoW 1.12.1, using LUA version 5.1

--[[ TODO:
- Slash commands and options menu
- Make portal and summoning confirmations optional
- Add whispers to mages for amplify behavior:
    set magic amplify -> all dampen magic will be dispelled from your group and all your mages will buff this
    set magic dampen ->  all amplify magic will be dispelled from your group and all your mages will buff this
    set magic none -> all dampen and amplify magic will be dispelled from your group and neither will be buffed

[MAYBE?]
- Custom stats display frame on your character
- Add tooltips to menu commands
- Add new changes:
    .settings notifications commands [on/off]
    .settings notifications emotes [on/off]
    .settings notifications [on/off] -- for both
- Set resist gear (for 1, for all)
    syntax is whisper "set gear fire" etc
    "set gear all fire" whispered to any comp will set for all comps. Provided they are out of combat and your res >= 255
    [Parts]: Just double-checked: T1R fire, T2R fire/shadow, T3R fire/shadow/nature/viscidus, T4R and T5R fire/shadoow/nature/viscidus/frost
- Toggle shaman ankh use
- Change Follow On for raid targets to be people in THEIR party

[RAID MENU?]
    - Set distancing (Rag, some BWL)

[BUGS]
- Look into Luna frames ResetInstances button infinite loop:
    >> LunaUnitFrames/modules/units.lua
    local function initPlayerDrop()
        UnitPopup_ShowMenu(PlayerFrameDropDown, "SELF", "player")
        if not (UnitInRaid("player") or GetNumPartyMembers() > 0) or UnitIsPartyLeader("player") and PlayerFrameDropDown.init and not CanShowResetInstances() then
            UIDropDownMenu_AddButton({text = RESET_INSTANCES, func = ResetInstances, notCheckable = 1}, 1)
            PlayerFrameDropDown.init = nil
        end
    end

--]]

--[[------------------------------------
    Send Z Commands (Bot Targeted)
--------------------------------------]]
local function SendTargetedBotZCommand(unit, command)
    -- Target the bot whose command we want to send
    TargetUnit(unit)
    -- Use a non-blocking delay mechanism to let the target go through (c_timer does not work, less than a second misses them sometimes)
    local delayTime = 1.0
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function()
        delayTime = delayTime - arg1
        if delayTime <= 0 then
            local chatType = "SAY"
            if UnitInRaid("player") then
                chatType = "RAID"
            elseif GetNumPartyMembers() > 0 then
                chatType = "PARTY"
            end
            SendChatMessage(".z " .. command, chatType)
            frame:SetScript("OnUpdate", nil)
        end
    end)
end

--[[------------------------------------
    Send Whisper Commands to Bot
--------------------------------------]]
local function SendTargetedBotWhisperCommand(name, command)
    SendChatMessage(command, "WHISPER", nil, name)
end

--[[------------------------------------
    Define Class Colors for Addon
--------------------------------------]]
local CLASS_COLORS = {
    ["WARRIOR"] = "cFFC79C6E",
    ["MAGE"]    = "cFF69CCF0",
    ["ROGUE"]   = "cFFFFF569",
    ["DRUID"]   = "cFFFF7D0A",
    ["HUNTER"]  = "cFFABD473",
    ["SHAMAN"]  = "cFF0070DE",
    ["PRIEST"]  = "cFFFFFFA0",  -- Slightly yellow-tinted
    ["WARLOCK"] = "cFF9482C9",
    ["PALADIN"] = "cFFF58CBA"
}

--[[---------------------------------------------------------------------------------
  PLAYER (SELF) MENU COMMANDS
----------------------------------------------------------------------------------]]

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

--[[---------------------------------------------------------------------------------
  COMPANION MENU COMMANDS
----------------------------------------------------------------------------------]]
-- Define custom popup buttons and menus
UnitPopupButtons["BOT_CONTROL"] = { text = "|cFFFFAA00Companion Settings|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_TOGGLE_HELM"] = {text = "Toggle Helm", dist = 0}
UnitPopupButtons["BOT_TOGGLE_CLOAK"] = { text = "Toggle Cloak", dist = 0 }
UnitPopupButtons["BOT_TOGGLE_AOE"] = { text = "Toggle AoE", dist = 0 }
UnitPopupMenus["BOT_CONTROL"] = { "BOT_TOGGLE_AOE","BOT_TOGGLE_HELM", "BOT_TOGGLE_CLOAK"}

-- Define role settings
UnitPopupButtons["BOT_ROLE_TANK"] = { text = "|cFFFFAA00Set Role:|r |cFFC79C6ETank|r", dist = 0 }
UnitPopupButtons["BOT_ROLE_HEALER"] = { text = "|cFFFFAA00Set Role:|r |cFFF58CBAHealer|r", dist = 0 }
UnitPopupButtons["BOT_ROLE_DPS"] = { text = "|cFFFFAA00Set Role:|r |cFF69CCF0DPS|r", dist = 0 }
UnitPopupButtons["BOT_ROLE_MDPS"] = { text = "|cFFFFAA00Set Role:|r |cFFFFF569Melee DPS|r", dist = 0 }
UnitPopupButtons["BOT_ROLE_RDPS"] = { text = "|cFFFFAA00Set Role:|r |cFFABD473Ranged DPS|r", dist = 0 }

-- Deny danger spells (added after roles)
UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny Danger Spells", dist = 0 }

-- Assign CC mark
UnitPopupButtons["BOT_ASSIGN_CC_MARK"] = { text = "Set |cff00ffffCC|r Mark", dist = 0, nested = 1 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_STAR"] = { text = "|cffFFD100Star|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_CIRCLE"] = { text = "|cffFF7F00Circle|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_DIAMOND"] = { text = "|cffFF00FFDiamond|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_TRIANGLE"] = { text = "|cff1EFF00Triangle|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_MOON"] = { text = "|cff6699CCMoon|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_SQUARE"] = { text = "|cff00ffffSquare|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_CROSS"] = { text = "|cffFF0000Cross|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_SKULL"] = { text = "|cFFFFFFA0Skull|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_CC_MARK_CLEAR"] = { text = "Clear CC (Defaults to |cff6699CCMoon|r)", dist = 0 }

UnitPopupMenus["BOT_ASSIGN_CC_MARK"] = {
    "BOT_ASSIGN_CC_MARK_CLEAR",
    "BOT_ASSIGN_CC_MARK_STAR",
    "BOT_ASSIGN_CC_MARK_CIRCLE",
    "BOT_ASSIGN_CC_MARK_DIAMOND",
    "BOT_ASSIGN_CC_MARK_TRIANGLE",
    "BOT_ASSIGN_CC_MARK_MOON",
    "BOT_ASSIGN_CC_MARK_SQUARE",
    "BOT_ASSIGN_CC_MARK_CROSS",
    "BOT_ASSIGN_CC_MARK_SKULL"
}

-- Assign focus mark
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK"] = { text = "Set |cffFF0000Focus|r Mark", dist = 0, nested = 1 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_STAR"] = { text = "|cffFFD100Star|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_CIRCLE"] = { text = "|cffFF7F00Circle|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_DIAMOND"] = { text = "|cffFF00FFDiamond|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_TRIANGLE"] = { text = "|cff1EFF00Triangle|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_MOON"] = { text = "|cff6699CCMoon|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_SQUARE"] = { text = "|cff00ffffSquare|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_CROSS"] = { text = "|cffFF0000Cross|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_SKULL"] = { text = "|cFFFFFFA0Skull|r", dist = 0 }
UnitPopupButtons["BOT_ASSIGN_FOCUS_MARK_CLEAR"] = { text = "Clear Focus (Defaults to |cFFFFFFA0Skull|r)", dist = 0 }

UnitPopupMenus["BOT_ASSIGN_FOCUS_MARK"] = {
    "BOT_ASSIGN_FOCUS_MARK_CLEAR",
    "BOT_ASSIGN_FOCUS_MARK_STAR",
    "BOT_ASSIGN_FOCUS_MARK_CIRCLE",
    "BOT_ASSIGN_FOCUS_MARK_DIAMOND",
    "BOT_ASSIGN_FOCUS_MARK_TRIANGLE",
    "BOT_ASSIGN_FOCUS_MARK_MOON",
    "BOT_ASSIGN_FOCUS_MARK_SQUARE",
    "BOT_ASSIGN_FOCUS_MARK_CROSS",
    "BOT_ASSIGN_FOCUS_MARK_SKULL"
}

-- Set Follow On
UnitPopupButtons["BOT_FOLLOW_ON"] = { text = "Set |cFFFFFFA0Follow|r On", dist = 0, nested = 1 }

-- ROGUE: Stealth control on or off
UnitPopupButtons["BOT_ROGUE_STEALTH"] = { text = "|cFFFFF569Stealth Control|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_ROGUE_STEALTH_ON"] = { text = "|cff1EFF00Allow Stealth|r", dist = 0 }
UnitPopupButtons["BOT_ROGUE_STEALTH_OFF"] = { text = "|cffFF0000Prevent Stealth|r", dist = 0 }

-- DRUID: Stealth control on or off
UnitPopupButtons["BOT_DRUID_STEALTH"] = { text = "|cFFFF7D0AStealth Control|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_DRUID_STEALTH_ON"] = { text = "|cff1EFF00Allow Stealth|r", dist = 0 }
UnitPopupButtons["BOT_DRUID_STEALTH_OFF"] = { text = "|cffFF0000Prevent Stealth|r", dist = 0 }

-- MAGE: Specific portal commands for both Alliance and Horde portals
UnitPopupButtons["BOT_OPEN_PORTAL"] = { text = "|cFF69CCF0Open Portal|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PORTAL_STORMWIND"] = { text = "Stormwind", dist = 0 }
UnitPopupButtons["BOT_PORTAL_IRONFORGE"] = { text = "Ironforge", dist = 0 }
UnitPopupButtons["BOT_PORTAL_DARNASSUS"] = { text = "Darnassus", dist = 0 }
UnitPopupButtons["BOT_PORTAL_ORGRIMMAR"] = { text = "Orgrimmar", dist = 0 }
UnitPopupButtons["BOT_PORTAL_UNDERCITY"] = { text = "Undercity", dist = 0 }
UnitPopupButtons["BOT_PORTAL_THUNDER_BLUFF"] = { text = "Thunder Bluff", dist = 0 }

-- HUNTER & WARLOCK: Pet toggle
UnitPopupButtons["BOT_PET_TOGGLE"] = { text = "Pet Control", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PET_ON"] = { text = "|cff1EFF00Summon Pet|r", dist = 0 }
UnitPopupButtons["BOT_PET_OFF"] = { text = "|cffFF0000Dismiss Pet|r", dist = 0 }

-- HUNTER: Choose pet type
UnitPopupButtons["BOT_HUNTER_PET"] = { text = "|cFFABD473Choose Beast|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_HUNTER_PET_BAT"] = { text = "|cFFFF7D0ABat|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_BEAR"] = { text = "|cFF0070DEBear|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_BOAR"] = { text = "|cFF0070DEBoar|r |cFFFFFFFF(Charge)|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_BIRD"] = { text = "|cFFFFF569Carrion Bird|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_CAT"] = { text = "|cFFFF7D0ACat|r |cFFFFFFFF(Prowl)|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_CRAB"] = { text = "|cFF0070DECrab|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_CROC"] = { text = "|cFF0070DECrocolisk|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_GORILLA"] = { text = "|cFF0070DEGorilla|r |cFFFFFFFF(Thunderstomp)|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_HYENA"] = { text = "|cFFFFF569Hyena|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_OWL"] = { text = "|cFFFF7D0AOwl|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_RAPTOR"] = { text = "|cFFFF7D0ARaptor|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_SCORPID"] = { text = "|cFF0070DEScorpid|r |cFFFFFFFF(Scorpid Poison)|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_SPIDER"] = { text = "|cFFFF7D0ASpider|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_STRIDER"] = { text = "|cFF0070DETallstrider|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_TURTLE"] = { text = "|cFF0070DETurtle|r |cFFFFFFFF(Shell Shield)|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_SERPENT"] = { text = "|cFFFF7D0AWind Serpent|r |cFFFFFFFF(Lightning Breath)|r", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_WOLF"] = { text = "|cFFFFF569Wolf|r |cFFFFFFFF(Furious Howl)|r", dist = 0 }

-- HUNTER: Choose aspect
UnitPopupButtons["BOT_HUNTER_ASPECT_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 }
-- UnitPopupButtons["BOT_HUNTER_ASPECT_MONKEY"] = { text = "Aspect of the Monkey", dist = 0 }
UnitPopupButtons["BOT_HUNTER_ASPECT_HAWK"] = { text = "Aspect of the Hawk", dist = 0 }
UnitPopupButtons["BOT_HUNTER_ASPECT_CHEETAH"] = { text = "Aspect of the Cheetah", dist = 0 }
-- UnitPopupButtons["BOT_HUNTER_ASPECT_BEAST"] = { text = "Aspect of the Beast", dist = 0 }
UnitPopupButtons["BOT_HUNTER_ASPECT_PACK"] = { text = "Aspect of the Pack", dist = 0 }
UnitPopupButtons["BOT_HUNTER_ASPECT_WILD"] = { text = "Aspect of the Wild", dist = 0 }

-- WARLOCK: Choose pet type
UnitPopupButtons["BOT_WARLOCK_PET"] = { text = "|cFF9482C9Choose Demon|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_WARLOCK_PET_IMP"] = { text = "Imp", dist = 0 }
UnitPopupButtons["BOT_WARLOCK_PET_VOIDWALKER"] = { text = "Voidwalker", dist = 0 }
UnitPopupButtons["BOT_WARLOCK_PET_SUCCUBUS"] = { text = "Succubus", dist = 0 }
UnitPopupButtons["BOT_WARLOCK_PET_FELHUNTER"] = { text = "Felhunter", dist = 0 }

-- WARLOCK: Summon player ritual
UnitPopupButtons["BOT_WARLOCK_SUMMON_PLAYER_RITUAL"] = { text = "|cFF9482C9Summon Player|r", dist = 0 }

-- PALADIN: Choose blessing
UnitPopupButtons["BOT_PALADIN_BLESSING"] = { text = "|cFFF58CBASet Blessing|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PALADIN_BLESSING_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_MIGHT"] = { text = "Blessing of Might", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_WISDOM"] = { text = "Blessing of Wisdom", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_KINGS"] = { text = "Blessing of Kings", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_LIGHT"] = { text = "Blessing of Light", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_SALVATION"] = { text = "Blessing of Salvation", dist = 0 }

-- PALADIN: Choose auras
UnitPopupButtons["BOT_PALADIN_AURAS"] = { text = "|cFFF58CBASet Aura|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PALADIN_AURAS_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_DEVOTION"] = { text = "Devotion Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_RETRIBUTION"] = { text = "Retribution Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_CONCENTRATION"] = { text = "Concentration Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_SANCTITY"] = { text = "Sanctity Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_SHADOW_RESISTANCE"] = { text = "Shadow Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_FROST_RESISTANCE"] = { text = "Frost Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_FIRE_RESISTANCE"] = { text = "Fire Resistance Aura", dist = 0 }

-- SHAMAN: Choose air totem
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM"] = { text = "|cFF0070DESet|r |cFFb8bcffAir|r |cFF0070DETotem|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GRACE"] = { text = "Grace of Air", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_NATURE"] = { text = "Nature Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_WINDFURY"] = { text = "Windfury", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GROUNDING"] = { text = "Grounding", dist = 0 }

-- SHAMAN: Choose earth totem
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM"] = { text = "|cFF0070DESet|r |cFF4dd943Earth|r |cFF0070DETotem|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_STONESKIN"] = { text = "Stoneskin", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_EARTHBIND"] = { text = "Earthbind", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_STRENGTH"] = { text = "Strength of Earth", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_TREMOR"] = { text = "Tremor", dist = 0 }

-- SHAMAN: Choose fire totem
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM"] = { text = "|cFF0070DESet|r |cFFFF4500Fire|r |cFF0070DETotem|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_SEARING"] = { text = "Searing", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_FIRE_NOVA"] = { text = "Fire Nova", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_FROST_RESISTANCE"] = { text = "Frost Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_MAGMA"] = { text = "Magma", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_FLAMETONGUE"] = { text = "Flametongue", dist = 0 }

-- SHAMAN: Choose water totem
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM"] = { text = "|cFF0070DESet|r |cFF34EBD2Water|r |cFF0070DETotem|r", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_HEALING"] = { text = "Healing Stream", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_MANA_SPRING"] = { text = "Mana Spring", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_FIRE_RESISTANCE"] = { text = "Fire Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_DISEASE_CLEANSING"] = { text = "Disease Cleansing", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_POISON_CLEANSING"] = { text = "Poison Cleansing", dist = 0 }

-- SHAMAN: Clear set totems or toggle off
UnitPopupButtons["BOT_SHAMAN_CLEAR_TOTEMS"] = { text = "|cFF0070DEClear Totem Settings|r", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_TOGGLE_TOTEMS"] = { text = "|cFF0070DEToggle Totems|r", dist = 0 }

-- Hook the UnitPopup_ShowMenu function to establish the variables of which party member is being clicked
local originalUnitPopupShowMenu = UnitPopup_ShowMenu
function UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
    --[[--------------------------
        Initialize Unit Menu
    ----------------------------]]
    -- Check if the unit is valid and in party or raid
    local isValidUnitInPartyOrRaid = false
    if unit and UnitExists(unit) then
        isValidUnitInPartyOrRaid = UnitInParty(unit) or UnitInRaid(unit)
    end

    -- If the unit is nil, invalid, or not in party/raid, fall back to the original menu
    if not unit or not UnitExists(unit) or not isValidUnitInPartyOrRaid then
        return originalUnitPopupShowMenu(dropdownMenu, which, unit, name, userData)
    end

    -- Store the unit, name, class, faction, and level in global variables
    NYCTER_SELECTED_UNIT = unit
    NYCTER_SELECTED_UNIT_NAME = tostring(UnitName(unit))
    NYCTER_SELECTED_UNIT_CLASS = tostring(UnitClass(unit))
    NYCTER_SELECTED_UNIT_FACTION = UnitFactionGroup(unit)
    NYCTER_SELECTED_UNIT_RACE = UnitRace(unit)
    NYCTER_SELECTED_UNIT_LEVEL = UnitLevel(unit)

    -- -- Either the PARTY or RAIDPLAYER frame should be used and either way both should have custom items cleared from prior
    local menuFrame = "PARTY"
    if UnitInRaid(unit) and not UnitInParty(unit) then
        menuFrame = "PLAYER"
    end

    -- Remove any existing class-specific menus (PARTY)
    local i = table.getn(UnitPopupMenus["PARTY"])
    while i > 0 do
        local menu = UnitPopupMenus["PARTY"][i]
        if string.find(menu, "^BOT_") then
            table.remove(UnitPopupMenus["PARTY"], i)
        end
        i = i - 1
    end

    -- Remove any existing class-specific menus (RAID)
    local i = table.getn(UnitPopupMenus["PLAYER"])
    while i > 0 do
        local menu = UnitPopupMenus["PLAYER"][i]
        if string.find(menu, "^BOT_") then
            table.remove(UnitPopupMenus["PLAYER"], i)
        end
        i = i - 1
    end

    -- Remove any existing custom options from BOT_CONTROL menu
    i = table.getn(UnitPopupMenus["BOT_CONTROL"])
    while i > 0 do
        local option = UnitPopupMenus["BOT_CONTROL"][i]
        if string.find(option, "^BOT_ROLE_") or string.find(option, "^BOT_DENY") then
            table.remove(UnitPopupMenus["BOT_CONTROL"], i)
        end
        i = i - 1
    end

    --[[--------------------------
        Add Companion Settings
    ----------------------------]]
    -- Add role options to BOT_CONTROL menu based on class and set color of companions menu
    if NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFFC79C6ECompanion Settings|r"
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_DPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Paladin" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFFF58CBACompanion Settings|r"
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_DPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFFABD473Companion Settings|r"
    elseif NYCTER_SELECTED_UNIT_CLASS == "Rogue" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFFFFF569Companion Settings|r"
    elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFFFFFFA0Companion Settings|r"
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_DPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Shaman" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFF0070DECompanion Settings|r"
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_MDPS")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_RDPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Mage" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFF69CCF0Companion Settings|r"
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFF9482C9Companion Settings|r"
    elseif NYCTER_SELECTED_UNIT_CLASS == "Druid" then
        UnitPopupButtons["BOT_CONTROL"].text = "|cFFFF7D0ACompanion Settings|r"
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_MDPS")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_RDPS")
    end

    -- Insert custom buttons into the PARTY pc menu
    table.insert(UnitPopupMenus[menuFrame], 1, "BOT_CONTROL")

    -- Conditionally edit the tables for each class
    local dynamicMenus = {}

    --[[--------------------------
        Mage
    ----------------------------]]
    if NYCTER_SELECTED_UNIT_CLASS == "Mage" then
        local portals = {}
        if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
            if NYCTER_SELECTED_UNIT_RACE == "Human" or NYCTER_SELECTED_UNIT_RACE == "Dwarf" or NYCTER_SELECTED_UNIT_RACE == "Gnome" or NYCTER_SELECTED_UNIT_RACE == "NightElf" then
                table.insert(portals, "BOT_PORTAL_STORMWIND")
                table.insert(portals, "BOT_PORTAL_IRONFORGE")
                if NYCTER_SELECTED_UNIT_LEVEL >= 50 then
                    table.insert(portals, "BOT_PORTAL_DARNASSUS")
                end
            elseif NYCTER_SELECTED_UNIT_RACE == "Orc" or NYCTER_SELECTED_UNIT_RACE == "Troll" or NYCTER_SELECTED_UNIT_RACE == "Tauren" or NYCTER_SELECTED_UNIT_RACE == "Undead" then
                table.insert(portals, "BOT_PORTAL_ORGRIMMAR")
                table.insert(portals, "BOT_PORTAL_UNDERCITY")
                if NYCTER_SELECTED_UNIT_LEVEL >= 50 then
                    table.insert(portals, "BOT_PORTAL_THUNDER_BLUFF")
                end
            end
            if table.getn(portals) > 0 then
                UnitPopupMenus["BOT_OPEN_PORTAL"] = portals
                table.insert(dynamicMenus, "BOT_OPEN_PORTAL")
            end
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Blink is learned at level 20
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFF69CCF0Danger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end
    --[[--------------------------
        Hunter
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_HUNTER_PET"] = {
            "BOT_HUNTER_PET_BAT",
            "BOT_HUNTER_PET_BEAR",
            "BOT_HUNTER_PET_BOAR",
            "BOT_HUNTER_PET_BIRD",
            "BOT_HUNTER_PET_CAT",
            "BOT_HUNTER_PET_CRAB",
            "BOT_HUNTER_PET_CROC",
            "BOT_HUNTER_PET_GORILLA",
            "BOT_HUNTER_PET_HYENA",
            "BOT_HUNTER_PET_OWL",
            "BOT_HUNTER_PET_RAPTOR",
            "BOT_HUNTER_PET_SCORPID", 
            "BOT_HUNTER_PET_SPIDER",
            "BOT_HUNTER_PET_STRIDER",
            "BOT_HUNTER_PET_TURTLE",
            "BOT_HUNTER_PET_SERPENT",
            "BOT_HUNTER_PET_WOLF"
        }
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- Hunters get pets at level 10
            UnitPopupButtons["BOT_PET_TOGGLE"] = { text = "|cFFABD473Pet Control|r", dist = 0, nested = 1 }
            table.insert(dynamicMenus, "BOT_PET_TOGGLE")
            table.insert(dynamicMenus, "BOT_HUNTER_PET")
        end
        -- Hunter Aspects
        local aspects = {
            -- Monkey omitted intentionally (cannot be set)
            {level = 10,  id = "BOT_HUNTER_ASPECT_HAWK"},
            {level = 20, id = "BOT_HUNTER_ASPECT_CHEETAH"},
            -- Beast omitted intentionally (cannot be set)
            {level = 40, id = "BOT_HUNTER_ASPECT_PACK"},
            {level = 46, id = "BOT_HUNTER_ASPECT_WILD"}
        }

        local aspectItems = {}

        for i = 1, table.getn(aspects) do
            if NYCTER_SELECTED_UNIT_LEVEL >= aspects[i].level then
                table.insert(aspectItems, aspects[i].id)
            end
        end

        if table.getn(aspectItems) > 0 then
            table.insert(aspectItems, 1, "BOT_HUNTER_ASPECT_DEFAULT")
            UnitPopupMenus["BOT_HUNTER_ASPECT"] = aspectItems
            UnitPopupButtons["BOT_HUNTER_ASPECT"] = { text = "|cFFABD473Set Aspect|r", dist = 0, nested = 1 }
            table.insert(dynamicMenus, "BOT_HUNTER_ASPECT")
        end

    --[[--------------------------
        Warlock
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_WARLOCK_PET"] = { "BOT_WARLOCK_PET_IMP" }
        UnitPopupButtons["BOT_PET_TOGGLE"] = { text = "|cFF9482C9Pet Control|r", dist = 0, nested = 1 }
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
            table.insert(UnitPopupMenus["BOT_WARLOCK_PET"], "BOT_WARLOCK_PET_VOIDWALKER")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
            table.insert(UnitPopupMenus["BOT_WARLOCK_PET"], "BOT_WARLOCK_PET_SUCCUBUS")
            table.insert(dynamicMenus, "BOT_WARLOCK_SUMMON_PLAYER_RITUAL")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 30 then
            table.insert(UnitPopupMenus["BOT_WARLOCK_PET"], "BOT_WARLOCK_PET_FELHUNTER")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 8 then -- Fear is learned at level 8
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFF9482C9Danger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end
        table.insert(dynamicMenus, "BOT_PET_TOGGLE")
        table.insert(dynamicMenus, "BOT_WARLOCK_PET")
    --[[--------------------------
        Paladin
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Paladin" then
        local blessings = {
            {level = 4,  id = "BOT_PALADIN_BLESSING_MIGHT"},
            {level = 14, id = "BOT_PALADIN_BLESSING_WISDOM"},
            {level = 26, id = "BOT_PALADIN_BLESSING_SALVATION"},
            {level = 40, id = "BOT_PALADIN_BLESSING_LIGHT"},
            {level = 60, id = "BOT_PALADIN_BLESSING_KINGS"}
        }
        local auras = {
            {level = 1,  id = "BOT_PALADIN_AURA_DEVOTION"},
            {level = 16, id = "BOT_PALADIN_AURA_RETRIBUTION"},
            {level = 22, id = "BOT_PALADIN_AURA_CONCENTRATION"},
            {level = 28, id = "BOT_PALADIN_AURA_SHADOW_RESISTANCE"},
            {level = 30, id = "BOT_PALADIN_AURA_SANCTITY"},
            {level = 32, id = "BOT_PALADIN_AURA_FROST_RESISTANCE"},
            {level = 36, id = "BOT_PALADIN_AURA_FIRE_RESISTANCE"}
        }

        local blessingItems = {}
        local auraItems = {}

        for _, blessing in ipairs(blessings) do
            if NYCTER_SELECTED_UNIT_LEVEL >= blessing.level then
                table.insert(blessingItems, blessing.id)
            end
        end

        for _, aura in ipairs(auras) do
            if NYCTER_SELECTED_UNIT_LEVEL >= aura.level then
                table.insert(auraItems, aura.id)
            end
        end

        if table.getn(blessingItems) > 0 then
            table.insert(blessingItems, 1, "BOT_PALADIN_BLESSING_DEFAULT")
            UnitPopupMenus["BOT_PALADIN_BLESSING"] = blessingItems
            table.insert(dynamicMenus, "BOT_PALADIN_BLESSING")
        end

        if table.getn(auraItems) > 0 then
            table.insert(auraItems, 1, "BOT_PALADIN_AURAS_DEFAULT")
            UnitPopupMenus["BOT_PALADIN_AURAS"] = auraItems
            table.insert(dynamicMenus, "BOT_PALADIN_AURAS")
        end
    --[[--------------------------
        Shaman
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Shaman" then
        local totems = {
            earth = {
                {level = 4,  id = "BOT_SHAMAN_EARTH_TOTEM_STONESKIN"},
                {level = 6,  id = "BOT_SHAMAN_EARTH_TOTEM_EARTHBIND"},
                {level = 10, id = "BOT_SHAMAN_EARTH_TOTEM_STRENGTH"},
                {level = 18, id = "BOT_SHAMAN_EARTH_TOTEM_TREMOR"}
            },
            fire = {
                {level = 10, id = "BOT_SHAMAN_FIRE_TOTEM_SEARING"},
                {level = 12, id = "BOT_SHAMAN_FIRE_TOTEM_FIRE_NOVA"},
                {level = 24, id = "BOT_SHAMAN_FIRE_TOTEM_FROST_RESISTANCE"},
                {level = 26, id = "BOT_SHAMAN_FIRE_TOTEM_MAGMA"},
                {level = 28, id = "BOT_SHAMAN_FIRE_TOTEM_FLAMETONGUE"}
            },
            water = {
                {level = 20, id = "BOT_SHAMAN_WATER_TOTEM_HEALING"},
                {level = 22, id = "BOT_SHAMAN_WATER_TOTEM_POISON_CLEANSING"},
                {level = 26, id = "BOT_SHAMAN_WATER_TOTEM_MANA_SPRING"},
                {level = 28, id = "BOT_SHAMAN_WATER_TOTEM_FIRE_RESISTANCE"},
                {level = 38, id = "BOT_SHAMAN_WATER_TOTEM_DISEASE_CLEANSING"}
            },
            air = {
                {level = 30, id = "BOT_SHAMAN_AIR_TOTEM_NATURE"},
                {level = 30, id = "BOT_SHAMAN_AIR_TOTEM_GROUNDING"},
                {level = 32, id = "BOT_SHAMAN_AIR_TOTEM_WINDFURY"},
                {level = 42, id = "BOT_SHAMAN_AIR_TOTEM_GRACE"}
            }
        }

        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- First totem is available at level 10
            table.insert(dynamicMenus, "BOT_SHAMAN_TOGGLE_TOTEMS")
        end
        local elementOrder = {"earth", "fire", "water", "air"}
        for _, element in ipairs(elementOrder) do
            local menuItems = {}
            for _, totem in ipairs(totems[element]) do
                if NYCTER_SELECTED_UNIT_LEVEL >= totem.level then
                    table.insert(menuItems, totem.id)
                end
            end
            if table.getn(menuItems) > 0 then
                UnitPopupMenus["BOT_SHAMAN_"..string.upper(element).."_TOTEM"] = menuItems
                table.insert(dynamicMenus, "BOT_SHAMAN_"..string.upper(element).."_TOTEM")
            end
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- First totem is available at level 10
            table.insert(dynamicMenus, "BOT_SHAMAN_CLEAR_TOTEMS")
        end
    --[[--------------------------
        Priest
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 14 then -- Psychic Scream is learned at level 14
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFFFFFFA0Danger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end
    --[[--------------------------
        Warrior
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then -- Intimidating Shout is learned at level 22
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFFC79C6EDanger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end
    --[[--------------------------
        Rogue
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Rogue" then -- Stealth at level 1
        UnitPopupMenus["BOT_ROGUE_STEALTH"] = { "BOT_ROGUE_STEALTH_ON", "BOT_ROGUE_STEALTH_OFF" }
        table.insert(dynamicMenus, "BOT_ROGUE_STEALTH")
    --[[--------------------------
        Druid
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Druid" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Stealth is learned at level 20 (cat form)
            UnitPopupMenus["BOT_DRUID_STEALTH"] = { "BOT_DRUID_STEALTH_ON", "BOT_DRUID_STEALTH_OFF" }
            table.insert(dynamicMenus, "BOT_DRUID_STEALTH")
        end
    end

    --[[--------------------------
        Add CC and Focus Buttons
    ----------------------------]]
    -- Add cc and focus mark assignment to the dynamic menus in the last position
    table.insert(dynamicMenus, "BOT_ASSIGN_CC_MARK")
    table.insert(dynamicMenus, "BOT_ASSIGN_FOCUS_MARK")

    --[[--------------------------
       Add Follow On Buttons
    ----------------------------]]
    -- Set a function to get the unit class and return the color code string for that class
    local function getUnitClassColor(unit)
        local _, class = UnitClass(unit)
        return CLASS_COLORS[string.upper(class)] or "cFFFFFFFF"  -- Default to white if class not found
    end
    -- Build the follow on table from the group party members and add it to the menu
    local followOnTable = {}
    -- Add the player as the first follow option
    local playerName = UnitName("player")
    local playerColorCode = getUnitClassColor("player")
    UnitPopupButtons["BOT_FOLLOW_ON_"..playerName] = { text = "|"..playerColorCode..playerName.."|r (Me)", dist = 0 }
    -- Then the party members who are not the currently selected unit
    table.insert(followOnTable, "BOT_FOLLOW_ON_"..playerName)
    for i = 1, GetNumPartyMembers() do
        local unit = "party"..i
        local name = GetUnitName(unit)
        -- Make a new button for each party member, excluding the clicked unit
        if name ~= NYCTER_SELECTED_UNIT_NAME then
            local colorCode = getUnitClassColor(unit)
            UnitPopupButtons["BOT_FOLLOW_ON_"..name] = { text = "|"..colorCode..name.."|r", dist = 0 }
            table.insert(followOnTable, "BOT_FOLLOW_ON_"..name)
        end
    end
    UnitPopupMenus["BOT_FOLLOW_ON"] = followOnTable
    table.insert(dynamicMenus, "BOT_FOLLOW_ON")

    --[[--------------------------
        Finish and Clean Up
    ----------------------------]]
    -- Insert dynamic menus at the top of the party menu, under BOT_CONTROL
    for i = table.getn(dynamicMenus), 1, -1 do
        table.insert(UnitPopupMenus[menuFrame], 2, dynamicMenus[i])
    end

    -- Call the original function
    originalUnitPopupShowMenu(dropdownMenu, which, unit, name, userData)
end

--[[------------------------------------
    Handle Custom Menu Clicks
--------------------------------------]]
local originalUnitPopupOnClick = UnitPopup_OnClick
function UnitPopup_OnClick()
	local button = this.value;
    
    --[[------------------------------------
    Player (self commands)
    --------------------------------------]]
    if button == "SELF_RESET_INSTANCES" then
        StaticPopup_Show("SELF_RESET_INSTANCES_CONFIRM")
    elseif button == "SELF_DUNGEON_NORMAL" then
        SendChatMessage(".settings difficulty normal", "SAY")
    elseif button == "SELF_DUNGEON_HEROIC" then
        SendChatMessage(".settings difficulty heroic", "SAY")
    elseif button == "SELF_LEGACY_BONUS" then
        SendChatMessage(".legacy", "SAY")
    elseif button == "SELF_XP_BONUS" then
        ClearTarget()
        SendChatMessage(".stats misc", "SAY")
    elseif button == "SELF_COMPANION_INFO" then
        ClearTarget()
        SendChatMessage(".z who", "SAY")
    --[[------------------------------------
    Companion Control
    --------------------------------------]]
    elseif button == "BOT_TOGGLE_HELM" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle helm")
    elseif button == "BOT_TOGGLE_CLOAK" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle cloak")
    elseif button == "BOT_TOGGLE_AOE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle aoe")
    elseif button == "BOT_ROLE_TANK" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "set tank")
    elseif button == "BOT_ROLE_HEALER" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "set healer")
    elseif button == "BOT_ROLE_DPS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "set dps")
    elseif button == "BOT_ROLE_MDPS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "set mdps")
    elseif button == "BOT_ROLE_RDPS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "set rdps")
    elseif string.find(button, "^BOT_FOLLOW_ON_") then
        local _, _, playerName = string.find(button, "_([^_]+)$")
        if playerName == UnitName("player") then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set follow off")
        else
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set follow on " .. playerName)
        end
    --[[------------------------------------
    CC and Focus Mark Controls
    --------------------------------------]]
    elseif button == "BOT_ASSIGN_CC_MARK_STAR" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark star")
    elseif button == "BOT_ASSIGN_CC_MARK_CIRCLE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark circle")
    elseif button == "BOT_ASSIGN_CC_MARK_DIAMOND" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark diamond")
    elseif button == "BOT_ASSIGN_CC_MARK_TRIANGLE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark triangle")
    elseif button == "BOT_ASSIGN_CC_MARK_SQUARE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark square")
    elseif button == "BOT_ASSIGN_CC_MARK_CROSS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark cross")
    elseif button == "BOT_ASSIGN_CC_MARK_CLEAR" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "clear ccmark")
    elseif button == "BOT_ASSIGN_CC_MARK_MOON" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark moon")
    elseif button == "BOT_ASSIGN_CC_MARK_SKULL" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "ccmark skull")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_STAR" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark star")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_CIRCLE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark circle")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_DIAMOND" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark diamond")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_TRIANGLE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark triangle")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_SQUARE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark square")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_CROSS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark cross")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_CLEAR" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "clear focusmark")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_MOON" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark moon")
    elseif button == "BOT_ASSIGN_FOCUS_MARK_SKULL" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "focusmark skull")
    --[[------------------------------------
    Mage portals
    --------------------------------------]]
    elseif string.find(button, "^BOT_PORTAL_") then
        local _, _, city = string.find(button, "^BOT_PORTAL_(.+)$")
        if city then
            local portalCity = string.gsub(city, "_", " ")
            portalCity = string.gsub(portalCity, "(%a)([%w_']*)", function(first, rest)
                return string.upper(first)..string.lower(rest)
            end)
            StaticPopupDialogs["PORTAL_CONFIRM"] = {
                text = "Are you sure you want " .. NYCTER_SELECTED_UNIT_NAME .. " to open a mage portal to " .. portalCity .. "? You have a limited number of portals per hire.",
                button1 = OKAY,
                button2 = CANCEL,
                OnAccept = function()
                    SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: " .. portalCity)
                end,
                timeout = 0,
                hideOnEscape = 1,
            }
            StaticPopup_Show("PORTAL_CONFIRM")
        end
    --[[------------------------------------
    Warlock summon player ritual
    --------------------------------------]]
    elseif button == "BOT_WARLOCK_SUMMON_PLAYER_RITUAL" then
        local targetName = UnitName("target")
        local warlockName = NYCTER_SELECTED_UNIT_NAME
        if not UnitInParty("target") and not UnitInRaid("target") then
            StaticPopupDialogs["SUMMON_INVALID_TARGET"] = {
                text = "You don't have a valid player targeted for Ritual of Summoning. Please target a player in your party or raid group.",
                button1 = OKAY,
                timeout = 0,
                hideOnEscape = 1,
            }
            StaticPopup_Show("SUMMON_INVALID_TARGET")
        else
            StaticPopupDialogs["SUMMON_CONFIRM"] = {
                text = "Are you sure you want " .. warlockName .. " to cast Ritual of Summoning on " .. targetName .. "? You have a limited number of uses.",
                button1 = OKAY,
                button2 = CANCEL,
                OnAccept = function()
                    SendTargetedBotWhisperCommand(warlockName, "cast Ritual of Summoning")
                end,
                timeout = 0,
                hideOnEscape = 1,
            }
            StaticPopup_Show("SUMMON_CONFIRM")
        end
    --[[------------------------------------
    Pet toggle
    --------------------------------------]]
    elseif button == "BOT_PET_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet on")
    elseif button == "BOT_PET_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet off")
    --[[------------------------------------
    Hunter pets
    --------------------------------------]]
    elseif button == "BOT_HUNTER_PET_BAT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet bat")
    elseif button == "BOT_HUNTER_PET_BEAR" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet bear")
    elseif button == "BOT_HUNTER_PET_BIRD" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet bird")
    elseif button == "BOT_HUNTER_PET_BOAR" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet boar")
    elseif button == "BOT_HUNTER_PET_CAT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet cat")
    elseif button == "BOT_HUNTER_PET_CRAB" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet crab")
    elseif button == "BOT_HUNTER_PET_CROC" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet croc")
    elseif button == "BOT_HUNTER_PET_GORILLA" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet gorilla")
    elseif button == "BOT_HUNTER_PET_HYENA" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet hyena")
    elseif button == "BOT_HUNTER_PET_OWL" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet owl")
    elseif button == "BOT_HUNTER_PET_RAPTOR" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet raptor")
    elseif button == "BOT_HUNTER_PET_SCORPID" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet scorpid")
    elseif button == "BOT_HUNTER_PET_SERPENT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet serpent")
    elseif button == "BOT_HUNTER_PET_SPIDER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet spider")
    elseif button == "BOT_HUNTER_PET_STRIDER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet strider")
    elseif button == "BOT_HUNTER_PET_TURTLE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet turtle")
    elseif button == "BOT_HUNTER_PET_WOLF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet wolf")
    --[[------------------------------------
    Hunter aspects
    --------------------------------------]]
    elseif button == "BOT_HUNTER_ASPECT_DEFAULT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect cancel")
    -- elseif button == "BOT_HUNTER_ASPECT_MONKEY" then
    --     SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Monkey")
    elseif button == "BOT_HUNTER_ASPECT_HAWK" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Hawk")
    elseif button == "BOT_HUNTER_ASPECT_CHEETAH" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Cheetah")
    -- elseif button == "BOT_HUNTER_ASPECT_BEAST" then
    --     SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Beast")
    elseif button == "BOT_HUNTER_ASPECT_PACK" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Pack")
    elseif button == "BOT_HUNTER_ASPECT_WILD" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Wild")
    --[[------------------------------------
    Warlock pets
    --------------------------------------]]
    elseif button == "BOT_WARLOCK_PET_IMP" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet imp")
    elseif button == "BOT_WARLOCK_PET_VOIDWALKER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet voidwalker")
    elseif button == "BOT_WARLOCK_PET_SUCCUBUS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet succubus")
    elseif button == "BOT_WARLOCK_PET_FELHUNTER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet felhunter")
    --[[------------------------------------
    Paladin blessings
    --------------------------------------]]
    elseif button == "BOT_PALADIN_BLESSING_DEFAULT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing cancel")
    elseif button == "BOT_PALADIN_BLESSING_MIGHT" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 52 then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Greater Blessing of Might")
        else
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Might")
        end
    elseif button == "BOT_PALADIN_BLESSING_WISDOM" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 54 then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Greater Blessing of Wisdom")
        else
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Wisdom")
        end
    elseif button == "BOT_PALADIN_BLESSING_KINGS" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 60 then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Greater Blessing of Kings")
        else
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Kings")
        end
    elseif button == "BOT_PALADIN_BLESSING_LIGHT" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 60 then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Greater Blessing of Light")
        else
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Light")
        end
    elseif button == "BOT_PALADIN_BLESSING_SALVATION" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 56 then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Greater Blessing of Salvation")
        else
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Salvation")
        end
    --[[------------------------------------
    Paladin auras
    --------------------------------------]]
    elseif button == "BOT_PALADIN_AURAS_DEFAULT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura cancel")
    elseif button == "BOT_PALADIN_AURA_DEVOTION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Devotion Aura")
    elseif button == "BOT_PALADIN_AURA_RETRIBUTION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Retribution Aura")
    elseif button == "BOT_PALADIN_AURA_SANCTITY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Sanctity Aura")
    elseif button == "BOT_PALADIN_AURA_CONCENTRATION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Concentration Aura")
    elseif button == "BOT_PALADIN_AURA_SHADOW_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Shadow Resistance Aura")
    elseif button == "BOT_PALADIN_AURA_FROST_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Frost Resistance Aura")
    elseif button == "BOT_PALADIN_AURA_FIRE_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aura Fire Resistance Aura")
    --[[------------------------------------
    Shaman air totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_AIR_TOTEM_GRACE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Grace of Air Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_NATURE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Nature Resistance Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_WINDFURY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Windfury Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_GROUNDING" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Grounding Totem")
    --[[------------------------------------
    Shaman earth totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_STONESKIN" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Stoneskin Totem")
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_EARTHBIND" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Earthbind Totem")
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_STRENGTH" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Strength of Earth Totem")
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_TREMOR" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Tremor Totem")
    --[[------------------------------------
    Shaman fire totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_FIRE_TOTEM_SEARING" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Searing Totem")
    elseif button == "BOT_SHAMAN_FIRE_TOTEM_FIRE_NOVA" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Fire Nova Totem")
    elseif button == "BOT_SHAMAN_FIRE_TOTEM_FROST_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Frost Resistance Totem")
    elseif button == "BOT_SHAMAN_FIRE_TOTEM_MAGMA" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Magma Totem")
    elseif button == "BOT_SHAMAN_FIRE_TOTEM_FLAMETONGUE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Flametongue Totem")
    --[[------------------------------------
    Shaman water totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_WATER_TOTEM_HEALING" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Healing Stream Totem")
    elseif button == "BOT_SHAMAN_WATER_TOTEM_MANA_SPRING" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Mana Spring Totem")
    elseif button == "BOT_SHAMAN_WATER_TOTEM_FIRE_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Fire Resistance Totem")
    elseif button == "BOT_SHAMAN_WATER_TOTEM_DISEASE_CLEANSING" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Disease Cleansing Totem")
    elseif button == "BOT_SHAMAN_WATER_TOTEM_POISON_CLEANSING" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Poison Cleansing Totem")
    --[[------------------------------------
    Clear & Toggle totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_CLEAR_TOTEMS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem cancel")
    elseif button == "BOT_SHAMAN_TOGGLE_TOTEMS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle totems")
    --[[------------------------------------
    Deny danger spells
    --------------------------------------]]
    elseif button == "BOT_DENY_DANGER_SPELLS" then
        if NYCTER_SELECTED_UNIT_CLASS == "Mage" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add blink")
        elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add psychic scream")
            if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
                SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add holy nova")
            end
        elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add fear")
            if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
                SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add howl of terror")
            end
        elseif NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add intimidating shout")
        end
    --[[------------------------------------
    Rogue stealth control
    --------------------------------------]]
    elseif button == "BOT_ROGUE_STEALTH_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove stealth")
    elseif button == "BOT_ROGUE_STEALTH_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add stealth")
    --[[------------------------------------
    Druid stealth control
    --------------------------------------]]
    elseif button == "BOT_DRUID_STEALTH_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove prowl")
    elseif button == "BOT_DRUID_STEALTH_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add prowl")
    else
        originalUnitPopupOnClick()
    end
    -- Close the dropdown menus
    CloseDropDownMenus()
end