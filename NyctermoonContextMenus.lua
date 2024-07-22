-- NyctermoonContextMenus.lua
-- Coded for Vanilla WoW 1.12.1, using LUA version 5.1

-- TODO: --
-- Add focus and cc marks settings for party

--[[---------------------------------------------------------------------------------
  PLAYER (SELF) MENU COMMANDS
----------------------------------------------------------------------------------]]

-- Dungeon Settings (Difficulty, Reset option)
UnitPopupButtons["SELF_DUNGEON_SETTINGS"] = { text = "Dungeon Settings", dist = 0, nested = 1 }
UnitPopupButtons["SELF_DUNGEON_NORMAL"] = { text = "Set Difficulty: Normal", dist = 0 }
UnitPopupButtons["SELF_DUNGEON_HEROIC"] = { text = "Set Difficulty: Heroic", dist = 0 }
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
UnitPopupButtons["SELF_NYCTERMOON_STATS"] = { text = "Nyctermoon Stats", dist = 0, nested = 1 }
UnitPopupButtons["SELF_LEGACY_BONUS"] = { text = "Legacy Overview", dist = 0 }
UnitPopupButtons["SELF_XP_BONUS"] = { text = "Current XP Bonus", dist = 0 }
UnitPopupButtons["SELF_COMPANION_INFO"] = { text = "Companion Info", dist = 0 }
UnitPopupMenus["SELF_NYCTERMOON_STATS"] = { "SELF_LEGACY_BONUS", "SELF_XP_BONUS", "SELF_COMPANION_INFO" }
table.insert(UnitPopupMenus["SELF"], 1, "SELF_NYCTERMOON_STATS")


--[[---------------------------------------------------------------------------------
  COMPANION MENU COMMANDS
----------------------------------------------------------------------------------]]
-- Define custom popup buttons and menus
UnitPopupButtons["BOT_CONTROL"] = { text = "Companion Settings", dist = 0, nested = 1 }
UnitPopupButtons["BOT_TOGGLE_HELM"] = {text = "Toggle Helm", dist = 0}
UnitPopupButtons["BOT_TOGGLE_CLOAK"] = { text = "Toggle Cloak", dist = 0 }
UnitPopupButtons["BOT_TOGGLE_AOE"] = { text = "Toggle AoE", dist = 0 }
UnitPopupMenus["BOT_CONTROL"] = { "BOT_TOGGLE_AOE","BOT_TOGGLE_HELM", "BOT_TOGGLE_CLOAK"}

-- Define role settings
UnitPopupButtons["BOT_ROLE_TANK"] = { text = "Set Role: Tank", dist = 0 }
UnitPopupButtons["BOT_ROLE_HEALER"] = { text = "Set Role: Healer", dist = 0 }
UnitPopupButtons["BOT_ROLE_DPS"] = { text = "Set Role: DPS", dist = 0 }
UnitPopupButtons["BOT_ROLE_MDPS"] = { text = "Set Role: Melee DPS", dist = 0 }
UnitPopupButtons["BOT_ROLE_RDPS"] = { text = "Set Role: Ranged DPS", dist = 0 }

-- Insert custom buttons into the PARTY pc menu
table.insert(UnitPopupMenus["PARTY"], 1, "BOT_CONTROL")

-- Deny dangerous spells
UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny Danger Spells", dist = 0 }

-- ROGUE: Stealth control on or off
UnitPopupButtons["BOT_ROGUE_STEALTH"] = { text = "Stealth Control", dist = 0, nested = 1 }
UnitPopupButtons["BOT_ROGUE_STEALTH_ON"] = { text = "Allow Stealth", dist = 0 }
UnitPopupButtons["BOT_ROGUE_STEALTH_OFF"] = { text = "Prevent Stealth", dist = 0 }

-- DRUID: Stealth control on or off
UnitPopupButtons["BOT_DRUID_STEALTH"] = { text = "Stealth Control", dist = 0, nested = 1 }
UnitPopupButtons["BOT_DRUID_STEALTH_ON"] = { text = "Allow Stealth", dist = 0 }
UnitPopupButtons["BOT_DRUID_STEALTH_OFF"] = { text = "Prevent Stealth", dist = 0 }

-- MAGE: Specific portal commands for both Alliance and Horde portals
UnitPopupButtons["BOT_OPEN_PORTAL"] = { text = "Open Portal", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PORTAL_STORMWIND"] = { text = "Stormwind", dist = 0 }
UnitPopupButtons["BOT_PORTAL_IRONFORGE"] = { text = "Ironforge", dist = 0 }
UnitPopupButtons["BOT_PORTAL_DARNASSUS"] = { text = "Darnassus", dist = 0 }
UnitPopupButtons["BOT_PORTAL_ORGRIMMAR"] = { text = "Orgrimmar", dist = 0 }
UnitPopupButtons["BOT_PORTAL_UNDERCITY"] = { text = "Undercity", dist = 0 }
UnitPopupButtons["BOT_PORTAL_THUNDER_BLUFF"] = { text = "Thunder Bluff", dist = 0 }

-- HUNTER & WARLOCK: Pet toggle
UnitPopupButtons["BOT_PET_TOGGLE"] = { text = "Pet Control", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PET_ON"] = { text = "Summon Pet", dist = 0 }
UnitPopupButtons["BOT_PET_OFF"] = { text = "Dismiss Pet", dist = 0 }

-- HUNTER: Choose pet type
UnitPopupButtons["BOT_HUNTER_PET"] = { text = "Choose Pet", dist = 0, nested = 1 }
UnitPopupButtons["BOT_HUNTER_PET_BAT"] = { text = "Bat", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_BEAR"] = { text = "Bear", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_BIRD"] = { text = "Bird", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_BOAR"] = { text = "Boar", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_CAT"] = { text = "Cat", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_CRAB"] = { text = "Crab", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_CROC"] = { text = "Crocolisk", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_GORILLA"] = { text = "Gorilla", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_HYENA"] = { text = "Hyena", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_OWL"] = { text = "Owl", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_RAPTOR"] = { text = "Raptor", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_SCORPID"] = { text = "Scorpid", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_SERPENT"] = { text = "Wind Serpent", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_SPIDER"] = { text = "Spider", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_STRIDER"] = { text = "Strider", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_TURTLE"] = { text = "Turtle", dist = 0 }
UnitPopupButtons["BOT_HUNTER_PET_WOLF"] = { text = "Wolf", dist = 0 }

-- WARLOCK: Choose pet type
UnitPopupButtons["BOT_WARLOCK_PET"] = { text = "Choose Demon", dist = 0, nested = 1 }
UnitPopupButtons["BOT_WARLOCK_PET_IMP"] = { text = "Imp", dist = 0 }
UnitPopupButtons["BOT_WARLOCK_PET_VOIDWALKER"] = { text = "Voidwalker", dist = 0 }
UnitPopupButtons["BOT_WARLOCK_PET_SUCCUBUS"] = { text = "Succubus", dist = 0 }
UnitPopupButtons["BOT_WARLOCK_PET_FELHUNTER"] = { text = "Felhunter", dist = 0 }

-- WARLOCK: Summon player ritual
UnitPopupButtons["BOT_WARLOCK_SUMMON_PLAYER_RITUAL"] = { text = "Summon Player", dist = 0 }

-- PALADIN: Choose blessing
UnitPopupButtons["BOT_PALADIN_BLESSING"] = { text = "Set Blessing", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PALADIN_BLESSING_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_MIGHT"] = { text = "Blessing of Might", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_WISDOM"] = { text = "Blessing of Wisdom", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_KINGS"] = { text = "Blessing of Kings", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_LIGHT"] = { text = "Blessing of Light", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_SALVATION"] = { text = "Blessing of Salvation", dist = 0 }

-- PALADIN: Choose auras
UnitPopupButtons["BOT_PALADIN_AURAS"] = { text = "Set Aura", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PALADIN_AURAS_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_DEVOTION"] = { text = "Devotion Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_RETRIBUTION"] = { text = "Retribution Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_CONCENTRATION"] = { text = "Concentration Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_SHADOW_RESISTANCE"] = { text = "Shadow Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_FROST_RESISTANCE"] = { text = "Frost Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_FIRE_RESISTANCE"] = { text = "Fire Resistance Aura", dist = 0 }

-- SHAMAN: Choose air totem
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM"] = { text = "Set Air Totem", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GRACE"] = { text = "Grace of Air", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_NATURE"] = { text = "Nature Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_WINDFURY"] = { text = "Windfury", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GROUNDING"] = { text = "Grounding", dist = 0 }

-- SHAMAN: Choose earth totem
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM"] = { text = "Set Earth Totem", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_STONESKIN"] = { text = "Stoneskin", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_EARTHBIND"] = { text = "Earthbind", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_STRENGTH"] = { text = "Strength of Earth", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_EARTH_TOTEM_TREMOR"] = { text = "Tremor", dist = 0 }

-- SHAMAN: Choose fire totem
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM"] = { text = "Set Fire Totem", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_SEARING"] = { text = "Searing", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_FIRE_NOVA"] = { text = "Fire Nova", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_FROST_RESISTANCE"] = { text = "Frost Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_MAGMA"] = { text = "Magma", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_FIRE_TOTEM_FLAMETONGUE"] = { text = "Flametongue", dist = 0 }

-- SHAMAN: Choose water totem
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM"] = { text = "Set Water Totem", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_HEALING"] = { text = "Healing Stream", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_MANA_SPRING"] = { text = "Mana Spring", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_FIRE_RESISTANCE"] = { text = "Fire Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_DISEASE_CLEANSING"] = { text = "Disease Cleansing", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_WATER_TOTEM_POISON_CLEANSING"] = { text = "Poison Cleansing", dist = 0 }

-- SHAMAN: Clear set totems
UnitPopupButtons["BOT_SHAMAN_CLEAR_TOTEMS"] = { text = "Clear Set Totems", dist = 0 }

-- Hook the UnitPopup_ShowMenu function to establish the variables of which party member is being clicked
local originalUnitPopupShowMenu = UnitPopup_ShowMenu
function UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
    -- Store the unit, name, class, faction, and level in global variables
    NYCTER_SELECTED_UNIT = unit
    NYCTER_SELECTED_UNIT_NAME = tostring(UnitName(unit))
    NYCTER_SELECTED_UNIT_CLASS = tostring(UnitClass(unit))
    NYCTER_SELECTED_UNIT_FACTION = UnitFactionGroup(unit)
    NYCTER_SELECTED_UNIT_LEVEL = UnitLevel(unit)

    -- Remove any existing class-specific menus
    local i = table.getn(UnitPopupMenus["PARTY"])
    while i > 0 do
        local menu = UnitPopupMenus["PARTY"][i]
        if string.find(menu, "^BOT_") and menu ~= "BOT_CONTROL" then
            table.remove(UnitPopupMenus["PARTY"], i)
        end
        i = i - 1
    end

    -- Remove any existing role options from BOT_CONTROL menu
    i = table.getn(UnitPopupMenus["BOT_CONTROL"])
    while i > 0 do
        local option = UnitPopupMenus["BOT_CONTROL"][i]
        if string.find(option, "^BOT_ROLE_") then
            table.remove(UnitPopupMenus["BOT_CONTROL"], i)
        end
        i = i - 1
    end

    -- Add role options to BOT_CONTROL menu based on class
    if NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_DPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Paladin" then
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_DPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Shaman" then
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_MDPS")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_RDPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Druid" then
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_TANK")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_MDPS")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_RDPS")
    elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_HEALER")
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_DPS")
    end

    -- Conditionally edit the tables for each class
    local dynamicMenus = {}

    --[[--------------------------
        Mage
    ----------------------------]]
    if NYCTER_SELECTED_UNIT_CLASS == "Mage" then
        local portals = {}
        if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
            if NYCTER_SELECTED_UNIT_FACTION == "Alliance" then
                table.insert(portals, "BOT_PORTAL_STORMWIND")
                table.insert(portals, "BOT_PORTAL_IRONFORGE")
                if NYCTER_SELECTED_UNIT_LEVEL >= 50 then
                    table.insert(portals, "BOT_PORTAL_DARNASSUS")
                end
            elseif NYCTER_SELECTED_UNIT_FACTION == "Horde" then
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
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then -- Blink is learned at level 22
            table.insert(dynamicMenus, "BOT_DENY_DANGER_SPELLS")
        end
    --[[--------------------------
        Hunter
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_HUNTER_PET"] = { "BOT_HUNTER_PET_BAT", "BOT_HUNTER_PET_BEAR", "BOT_HUNTER_PET_BIRD", "BOT_HUNTER_PET_BOAR", "BOT_HUNTER_PET_CAT", "BOT_HUNTER_PET_CRAB", "BOT_HUNTER_PET_CROC", "BOT_HUNTER_PET_GORILLA", "BOT_HUNTER_PET_HYENA", "BOT_HUNTER_PET_OWL", "BOT_HUNTER_PET_RAPTOR", "BOT_HUNTER_PET_SCORPID", "BOT_HUNTER_PET_SERPENT", "BOT_HUNTER_PET_SPIDER", "BOT_HUNTER_PET_STRIDER", "BOT_HUNTER_PET_TURTLE", "BOT_HUNTER_PET_WOLF" }
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- Hunters get pets at level 10
            table.insert(dynamicMenus, "BOT_PET_TOGGLE")
            table.insert(dynamicMenus, "BOT_HUNTER_PET")
        end
    --[[--------------------------
        Warlock
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_WARLOCK_PET"] = { "BOT_WARLOCK_PET_IMP", "BOT_WARLOCK_PET_VOIDWALKER", "BOT_WARLOCK_PET_SUCCUBUS", "BOT_WARLOCK_PET_FELHUNTER" }
        table.insert(dynamicMenus, "BOT_PET_TOGGLE")
        table.insert(dynamicMenus, "BOT_WARLOCK_PET")
        if NYCTER_SELECTED_UNIT_LEVEL >= 50 then -- Ritual of Summoning is learned at level 50 in vanilla WoW 1.12.1
            table.insert(dynamicMenus, "BOT_WARLOCK_SUMMON_PLAYER_RITUAL")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 8 then -- Fear is learned at level 8
            table.insert(dynamicMenus, "BOT_DENY_DANGER_SPELLS")
        end
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
            table.insert(dynamicMenus, "BOT_DENY_DANGER_SPELLS")
        end
    --[[--------------------------
        Warrior
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then -- Intimidating Shout is learned at level 22
            table.insert(dynamicMenus, "BOT_DENY_DANGER_SPELLS")
        end
    --[[--------------------------
        Rogue
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Rogue" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- Stealth is learned at level 10
            UnitPopupMenus["BOT_ROGUE_STEALTH"] = { "BOT_ROGUE_STEALTH_ON", "BOT_ROGUE_STEALTH_OFF" }
            table.insert(dynamicMenus, "BOT_ROGUE_STEALTH")
        end
    --[[--------------------------
        Druid
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Druid" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Stealth is learned at level 20 (cat form)
            UnitPopupMenus["BOT_DRUID_STEALTH"] = { "BOT_DRUID_STEALTH_ON", "BOT_DRUID_STEALTH_OFF" }
            table.insert(dynamicMenus, "BOT_DRUID_STEALTH")
        end
    end

    -- Insert dynamic menus at the top of the party menu, under BOT_CONTROL
    for i = table.getn(dynamicMenus), 1, -1 do
        table.insert(UnitPopupMenus["PARTY"], 2, dynamicMenus[i])
    end

    -- Call the original function
    originalUnitPopupShowMenu(dropdownMenu, which, unit, name, userData)
end

-- Send a Z command to the bot requires targeting it
local function SendTargetedBotZCommand(unit, command)
    local previousTarget = UnitName("target")
    -- Target the bot whose command we want to send
    TargetUnit(unit)
    -- Use a non-blocking delay mechanism to let the target go through (c_timer does not work, less than half a second misses them sometimes)
    local delayTime = 0.5
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function()
        delayTime = delayTime - arg1
        if delayTime <= 0 then
            SendChatMessage(".z " .. command, "PARTY")
            -- Target the previous target after sending the message
            if previousTarget then
                TargetByName(previousTarget)
            else
                ClearTarget()
            end
            frame:SetScript("OnUpdate", nil)
        end
    end)
end

-- Send a whisper control to the bot that you are targeting
local function SendTargetedBotWhisperCommand(name, command)
    SendChatMessage(command, "WHISPER", nil, name)
end

-- Modify the UnitPopup_OnClick hook to control the clicks on custom menu options
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
    --[[------------------------------------
    Mage portals
    --------------------------------------]]
    elseif button == "BOT_PORTAL_STORMWIND" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: Stormwind")
    elseif button == "BOT_PORTAL_IRONFORGE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: Ironforge")
    elseif button == "BOT_PORTAL_DARNASSUS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: Darnassus")
    elseif button == "BOT_PORTAL_UNDERCITY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: Undercity")
    elseif button == "BOT_PORTAL_ORGRIMMAR" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: Orgrimmar")
    elseif button == "BOT_PORTAL_THUNDER_BLUFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Portal: Thunder Bluff")
    --[[------------------------------------
    Warlock summon player ritual
    --------------------------------------]]
    elseif button == "BOT_WARLOCK_SUMMON_PLAYER_RITUAL" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Ritual of Summoning")
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
    Clear all totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_CLEAR_TOTEMS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem cancel")
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