-- NyctermoonContextMenus.lua
-- Coded for Vanilla WoW 1.12.1, using LUA version 5.0

--[[ TODO:
- Slash commands and options menu
- Make portal and summoning confirmations optional

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

[RAID MENU?]
    - Set distancing (Rag, some BWL)

--]]

--[[---------------------------------------------------------------------------------
  COMPANION MENU COMMANDS
----------------------------------------------------------------------------------]]
-- Load Class Modules
local ClassModules = {
    Druid = DruidModule,
    -- Add other class modules as they are created
}
-- Hook the UnitPopup_ShowMenu function to establish the variables of which party member is being clicked
local originalUnitPopupShowMenu = UnitPopup_ShowMenu
function UnitPopup_ShowMenu(dropdownMenu, which, unit, name, userData)
    --[[--------------------------
        Initialize Unit Menu
    ----------------------------]]
    -- Check if the unit is valid and in party or raid
    local isValidUnitInPartyOrRaid = false
    isValidUnitInPartyOrRaid = UnitInParty(unit) or UnitInRaid(unit)

    -- If the unit is not in party/raid, fall back to the original menu
    if not isValidUnitInPartyOrRaid then
        return originalUnitPopupShowMenu(dropdownMenu, which, unit, name, userData)
    end

    -- Store the unit, name, class, faction, and level in global variables
    NYCTER_SELECTED_UNIT = unit
    NYCTER_SELECTED_UNIT_NAME = tostring(UnitName(unit))
    NYCTER_SELECTED_UNIT_CLASS = tostring(UnitClass(unit))
    NYCTER_SELECTED_UNIT_FACTION = UnitFactionGroup(unit)
    NYCTER_SELECTED_UNIT_RACE = UnitRace(unit)
    NYCTER_SELECTED_UNIT_LEVEL = UnitLevel(unit)

    -- Check if the selected unit is the player
    if NYCTER_SELECTED_UNIT_NAME == UnitName("player") then
        -- If it is, show the self menu instead
        return originalUnitPopupShowMenu(dropdownMenu, "SELF", unit, name, userData)
    end
    
    -- Target the PARTY dropdown menu
    local menuFrame = "PARTY"

    -- BOT CONTROL MENU: Declare top level defaults
    UnitPopupButtons["BOT_CONTROL"] = { text = "|cFFFFAA00Companion Settings|r", dist = 0, nested = 1 }
    UnitPopupButtons["BOT_TOGGLE_HELM"] = {text = "Toggle Helm", dist = 0}
    UnitPopupButtons["BOT_TOGGLE_CLOAK"] = { text = "Toggle Cloak", dist = 0 }
    UnitPopupButtons["BOT_TOGGLE_AOE"] = { text = "Toggle AoE", dist = 0 }
    UnitPopupMenus["BOT_CONTROL"] = { "BOT_TOGGLE_AOE","BOT_TOGGLE_HELM", "BOT_TOGGLE_CLOAK"}

    -- BOT CONTROL MENU: Clear prior settings
    -- Remove any existing class-specific menus
    local i = table.getn(UnitPopupMenus["PARTY"])
    while i > 0 do
        local menu = UnitPopupMenus["PARTY"][i]
        if string.find(menu, "^BOT_") then
            table.remove(UnitPopupMenus["PARTY"], i)
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

    -- Remove the whisper all command if present
    for i, v in ipairs(UnitPopupMenus["SELF"]) do
        if v == "SELF_SEND_COMMAND_TO_ALL" then
            table.remove(UnitPopupMenus["SELF"], i)
            break
        end
    end

    -- Add the whisper all command after dungeon settings if in party or raid
    if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
        for i, v in ipairs(UnitPopupMenus["SELF"]) do
            if v == "SELF_DUNGEON_SETTINGS" then
                table.insert(UnitPopupMenus["SELF"], i + 1, "SELF_SEND_COMMAND_TO_ALL")
                break
            end
        end
    end

    --[[--------------------------
        Add Companion Settings
    ----------------------------]]
    -- COMPANION ROLES: Define & insert role button settings into bot control menu
    local roleButtons = {
        ["BOT_ROLE_TANK"] = "|cFFC79C6ETank|r",
        ["BOT_ROLE_HEALER"] = "|cFFF58CBAHealer|r",
        ["BOT_ROLE_DPS"] = "|cFF69CCF0DPS|r",
        ["BOT_ROLE_MDPS"] = "|cFFFFF569Melee DPS|r",
        ["BOT_ROLE_RDPS"] = "|cFFABD473Ranged DPS|r"
    }
    for id, text in pairs(roleButtons) do
        UnitPopupButtons[id] = { text = "|cFFFFAA00Set Role:|r " .. text, dist = 0 }
    end

    -- Add role options to BOT_CONTROL menu based on class and set color of companions menu
    local classSettings = {
        ["Warrior"] = {color = "C79C6E", roles = {"TANK", "DPS"}},
        ["Paladin"] = {color = "F58CBA", roles = {"TANK", "HEALER", "DPS"}},
        ["Hunter"] = {color = "ABD473", roles = {}},
        ["Rogue"] = {color = "FFF569", roles = {}},
        ["Priest"] = {color = "FFFFA0", roles = {"HEALER", "DPS"}},
        ["Shaman"] = {color = "0070DE", roles = {"TANK", "HEALER", "MDPS", "RDPS"}},
        ["Mage"] = {color = "69CCF0", roles = {}},
        ["Warlock"] = {color = "9482C9", roles = {}},
        ["Druid"] = {color = "FF7D0A", roles = {"TANK", "HEALER", "MDPS", "RDPS"}}
    }

    local classInfo = classSettings[NYCTER_SELECTED_UNIT_CLASS]
    UnitPopupButtons["BOT_CONTROL"].text = "|cFF" .. classInfo.color .. "Companion Settings|r"
    for _, role in ipairs(classInfo.roles) do
        table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_ROLE_" .. role)
    end

    -- Deny danger spells (added after roles by class for those that have them)
    UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny Danger Spells", dist = 0 }

    -- Insert BOT_CONTROL into the PARTY menu
    table.insert(UnitPopupMenus[menuFrame], 1, "BOT_CONTROL")

    -- Conditionally edit the tables for each class
    local dynamicMenus = {}

    -- Function to update class-specific menus if a module exists
    local function UpdateClassMenu(class, level)
        local classModule = ClassModules[class]
        if classModule then
            classModule:UpdateMenu(level)
            for buttonName, buttonData in pairs(classModule.buttons) do
                UnitPopupButtons[buttonName] = buttonData
            end
            for menuName, menuItems in pairs(classModule.menus) do
                UnitPopupMenus[menuName] = menuItems
                table.insert(dynamicMenus, menuName)
            end
        end
    end

    UpdateClassMenu(NYCTER_SELECTED_UNIT_CLASS, NYCTER_SELECTED_UNIT_LEVEL)

    --[[--------------------------
        Mage
    ----------------------------]]
    if NYCTER_SELECTED_UNIT_CLASS == "Mage" then
        -- MAGE: Group portals
        UnitPopupButtons["BOT_OPEN_PORTAL"] = { text = "|cFF69CCF0Open Portal|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_PORTAL_STORMWIND"] = { text = "Stormwind", dist = 0 }
        UnitPopupButtons["BOT_PORTAL_IRONFORGE"] = { text = "Ironforge", dist = 0 }
        UnitPopupButtons["BOT_PORTAL_DARNASSUS"] = { text = "Darnassus", dist = 0 }
        UnitPopupButtons["BOT_PORTAL_ORGRIMMAR"] = { text = "Orgrimmar", dist = 0 }
        UnitPopupButtons["BOT_PORTAL_UNDERCITY"] = { text = "Undercity", dist = 0 }
        UnitPopupButtons["BOT_PORTAL_THUNDER_BLUFF"] = { text = "Thunder Bluff", dist = 0 }
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

        -- MAGE: Amplify Magic options
        UnitPopupButtons["BOT_MAGE_AMPLIFY_MAGIC"] = { text = "|cFF69CCF0Set Amplify Magic|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_MAGE_AMPLIFY_USE"] = { text = "Use Amplify Magic", dist = 0 }
        UnitPopupButtons["BOT_MAGE_DAMPEN_USE"] = { text = "Use Dampen Magic", dist = 0 }
        UnitPopupButtons["BOT_MAGE_AMPLIFY_NEITHER"] = { text = "None", dist = 0 }
        if NYCTER_SELECTED_UNIT_LEVEL >= 12 then -- Dampen Magic is learned at level 12
            local amplifyMagicOptions = {"BOT_MAGE_DAMPEN_USE","BOT_MAGE_AMPLIFY_NEITHER"}
            if NYCTER_SELECTED_UNIT_LEVEL >= 18 then -- Amplify Magic is learned at level 18
                table.insert(amplifyMagicOptions, 1, "BOT_MAGE_AMPLIFY_USE")
            end
            UnitPopupMenus["BOT_MAGE_AMPLIFY_MAGIC"] = amplifyMagicOptions
            table.insert(dynamicMenus, "BOT_MAGE_AMPLIFY_MAGIC")
        end
        -- Deny Danger Spells
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Blink is learned at level 20
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFF69CCF0Danger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end

    --[[--------------------------
        Hunter
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
        -- Load Hunter module
        local hunterMenus = HunterModule:CreateMenu(NYCTER_SELECTED_UNIT_LEVEL)
        for menuName, menuItems in pairs(hunterMenus) do
            UnitPopupMenus[menuName] = menuItems
            table.insert(dynamicMenus, menuName)
        end
        for buttonName, buttonData in pairs(HunterModule.Buttons) do
            UnitPopupButtons[buttonName] = buttonData
        end
        -- HUNTER: Deny dangerous spells
        if NYCTER_SELECTED_UNIT_LEVEL >= 8 then -- Scare Beast is learned at level 8
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFFABD473Danger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end

    --[[--------------------------
        Warlock
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
        -- WARLOCK: Summon player ritual
        UnitPopupButtons["BOT_WARLOCK_SUMMON_PLAYER_RITUAL"] = { text = "|cFF9482C9Summon Player|r", dist = 0 }
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
            table.insert(dynamicMenus, "BOT_WARLOCK_SUMMON_PLAYER_RITUAL")
        end
        -- WARLOCK: Choose pet type
        UnitPopupButtons["BOT_WARLOCK_PET"] = { text = "|cFF9482C9Choose Demon|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_WARLOCK_PET_IMP"] = { text = "Imp", dist = 0 }
        UnitPopupButtons["BOT_WARLOCK_PET_VOIDWALKER"] = { text = "Voidwalker", dist = 0 }
        UnitPopupButtons["BOT_WARLOCK_PET_SUCCUBUS"] = { text = "Succubus", dist = 0 }
        UnitPopupButtons["BOT_WARLOCK_PET_FELHUNTER"] = { text = "Felhunter", dist = 0 }
        UnitPopupButtons["BOT_PET_TOGGLE"] = { text = "|cFF9482C9Pet Control|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_PET_ON"] = { text = "|cff1EFF00Summon Pet|r", dist = 0 }
        UnitPopupButtons["BOT_PET_OFF"] = { text = "|cffFF0000Dismiss Pet|r", dist = 0 }
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_WARLOCK_PET"] = { "BOT_WARLOCK_PET_IMP" }
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
            table.insert(UnitPopupMenus["BOT_WARLOCK_PET"], "BOT_WARLOCK_PET_VOIDWALKER")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
            table.insert(UnitPopupMenus["BOT_WARLOCK_PET"], "BOT_WARLOCK_PET_SUCCUBUS")
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
        
        -- WARLOCK: Set Soulstone on
        if NYCTER_SELECTED_UNIT_LEVEL >= 18 then -- Soulstone is learned at level 18
            UnitPopupButtons["BOT_WARLOCK_SOULSTONE"] = { text = "|cFF9482C9Set Soulstone On|r", dist = 0, nested = 1 }
            UnitPopupMenus["BOT_WARLOCK_SOULSTONE"] = GetLocalGroupMembers(NYCTER_SELECTED_UNIT, true, true, "BOT_WARLOCK_SOULSTONE")
            table.insert(dynamicMenus, "BOT_WARLOCK_SOULSTONE")
        end

    --[[--------------------------
        Paladin
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Paladin" then
        -- PALADIN: Choose blessing
        UnitPopupButtons["BOT_PALADIN_BLESSING"] = { text = "|cFFF58CBASet Blessing|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_PALADIN_BLESSING_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 }
        UnitPopupButtons["BOT_PALADIN_BLESSING_MIGHT"] = { text = "Blessing of Might", dist = 0 }
        UnitPopupButtons["BOT_PALADIN_BLESSING_WISDOM"] = { text = "Blessing of Wisdom", dist = 0 }
        UnitPopupButtons["BOT_PALADIN_BLESSING_KINGS"] = { text = "Blessing of Kings", dist = 0 }
        UnitPopupButtons["BOT_PALADIN_BLESSING_LIGHT"] = { text = "Blessing of Light", dist = 0 }
        UnitPopupButtons["BOT_PALADIN_BLESSING_SALVATION"] = { text = "Blessing of Salvation", dist = 0 }
        local blessings = {
            {level = 4,  id = "BOT_PALADIN_BLESSING_MIGHT"},
            {level = 14, id = "BOT_PALADIN_BLESSING_WISDOM"},
            {level = 26, id = "BOT_PALADIN_BLESSING_SALVATION"},
            {level = 40, id = "BOT_PALADIN_BLESSING_LIGHT"},
            {level = 60, id = "BOT_PALADIN_BLESSING_KINGS"}
        }
        local blessingItems = {}
        for _, blessing in ipairs(blessings) do
            if NYCTER_SELECTED_UNIT_LEVEL >= blessing.level then
                table.insert(blessingItems, blessing.id)
            end
        end
        if table.getn(blessingItems) > 0 then
            table.insert(blessingItems, 1, "BOT_PALADIN_BLESSING_DEFAULT")
            UnitPopupMenus["BOT_PALADIN_BLESSING"] = blessingItems
            table.insert(dynamicMenus, "BOT_PALADIN_BLESSING")
        end
        
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
        local auras = {
            {level = 1,  id = "BOT_PALADIN_AURA_DEVOTION"},
            {level = 16, id = "BOT_PALADIN_AURA_RETRIBUTION"},
            {level = 22, id = "BOT_PALADIN_AURA_CONCENTRATION"},
            {level = 28, id = "BOT_PALADIN_AURA_SHADOW_RESISTANCE"},
            {level = 30, id = "BOT_PALADIN_AURA_SANCTITY"},
            {level = 32, id = "BOT_PALADIN_AURA_FROST_RESISTANCE"},
            {level = 36, id = "BOT_PALADIN_AURA_FIRE_RESISTANCE"}
        }
        local auraItems = {}
        for _, aura in ipairs(auras) do
            if NYCTER_SELECTED_UNIT_LEVEL >= aura.level then
                table.insert(auraItems, aura.id)
            end
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
        -- SHAMAN: Choose air totem
        UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM"] = { text = "|cFF0070DESet|r |cFFb8bcffAir|r |cFF0070DETotem|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GRACE"] = { text = "Grace of Air", dist = 0 }
        UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_NATURE"] = { text = "Nature Resistance", dist = 0 }
        UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_WINDFURY"] = { text = "Windfury", dist = 0 }
        UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GROUNDING"] = { text = "Grounding", dist = 0 }
        UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_TRANQUIL"] = { text = "Tranquil Air", dist = 0 }

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
         
        -- SHAMAN: Totems
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
                {level = 42, id = "BOT_SHAMAN_AIR_TOTEM_GRACE"},
                {level = 50, id = "BOT_SHAMAN_AIR_TOTEM_TRANQUIL"}
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

        -- SHAMAN: Reincarnation
        UnitPopupButtons["BOT_SHAMAN_REINCARNATION"] = { text = "|cFF0070DEReincarnation|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_SHAMAN_REINCARNATION_ALLOW"] = { text = "|cff1EFF00Allow Self-Resurrection|r", dist = 0 }
        UnitPopupButtons["BOT_SHAMAN_REINCARNATION_DENY"] = { text = "|cffFF0000Deny Self-Resurrection|r", dist = 0 }
        if NYCTER_SELECTED_UNIT_LEVEL >= 30 then -- Reincarnation is learned at level 30
            UnitPopupMenus["BOT_SHAMAN_REINCARNATION"] = { "BOT_SHAMAN_REINCARNATION_ALLOW", "BOT_SHAMAN_REINCARNATION_DENY" }
            table.insert(dynamicMenus, "BOT_SHAMAN_REINCARNATION")
        end
    --[[--------------------------
        Priest
    ----------------------------]]
    elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 14 then
            UnitPopupButtons["BOT_DENY_DANGER_SPELLS"] = { text = "Deny |cFFFFFFA0Danger Spells|r", dist = 0 }
            table.insert(UnitPopupMenus["BOT_CONTROL"], "BOT_DENY_DANGER_SPELLS")
        end
        
        -- PRIEST: Fear Ward (Dwarf only)
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 and UnitRace(NYCTER_SELECTED_UNIT) == "Dwarf" then
            UnitPopupButtons["BOT_PRIEST_FEAR_WARD"] = { text = "|cFFFFFFA0Set Fear Ward On|r", dist = 0, nested = 1 }
            UnitPopupMenus["BOT_PRIEST_FEAR_WARD"] = GetLocalGroupMembers(NYCTER_SELECTED_UNIT, true, true, "BOT_PRIEST_FEAR_WARD")
            table.insert(dynamicMenus, "BOT_PRIEST_FEAR_WARD")
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
        -- ROGUE: Stealth control on or off
        UnitPopupButtons["BOT_ROGUE_STEALTH"] = { text = "|cFFFFF569Stealth Control|r", dist = 0, nested = 1 }
        UnitPopupButtons["BOT_ROGUE_STEALTH_ON"] = { text = "|cff1EFF00Allow Stealth|r", dist = 0 }
        UnitPopupButtons["BOT_ROGUE_STEALTH_OFF"] = { text = "|cffFF0000Prevent Stealth|r", dist = 0 }
        UnitPopupMenus["BOT_ROGUE_STEALTH"] = { "BOT_ROGUE_STEALTH_ON", "BOT_ROGUE_STEALTH_OFF" }
        table.insert(dynamicMenus, "BOT_ROGUE_STEALTH")
    end

    --[[--------------------------
        Add CC and Focus Buttons
    ----------------------------]]
    -- Assign CC mark buttons
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

    -- Assign focus mark buttons
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
    -- Add cc and focus mark assignment to the dynamic menus in the last position
    table.insert(dynamicMenus, "BOT_ASSIGN_CC_MARK")
    table.insert(dynamicMenus, "BOT_ASSIGN_FOCUS_MARK")

    --[[--------------------------
       Add Follow On Buttons
    ----------------------------]]
    UnitPopupButtons["BOT_FOLLOW_ON"] = { text = "Set |cFFFFFFA0Follow|r On", dist = 0, nested = 1 }
    UnitPopupMenus["BOT_FOLLOW_ON"] = GetLocalGroupMembers(NYCTER_SELECTED_UNIT, true, false, "BOT_FOLLOW_ON")
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
    local classModule = ClassModules[NYCTER_SELECTED_UNIT_CLASS]
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
    elseif button == "SELF_SEND_COMMAND_TO_ALL" then
        StaticPopup_Show("SEND_COMMAND_TO_ALL")
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
    Mage Amplify Magic options
    --------------------------------------]]
    elseif button == "BOT_MAGE_AMPLIFY_USE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set magic amplify")
    elseif button == "BOT_MAGE_DAMPEN_USE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set magic dampen")
    elseif button == "BOT_MAGE_AMPLIFY_NEITHER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set magic none")
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
    Warlock soulstone
    --------------------------------------]]
    elseif string.find(button, "^BOT_WARLOCK_SOULSTONE_") then
        local _, _, playerName = string.find(button, "_([^_]+)$")
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set soulstone on " .. playerName)
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
    elseif button == "BOT_HUNTER_ASPECT_HAWK" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Hawk")
    elseif button == "BOT_HUNTER_ASPECT_CHEETAH" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the Cheetah")
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
    elseif button == "BOT_SHAMAN_AIR_TOTEM_TRANQUIL" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Tranquil Air Totem")
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
    Shaman Clear & Toggle totems
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_CLEAR_TOTEMS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem cancel")
    elseif button == "BOT_SHAMAN_TOGGLE_TOTEMS" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle totems")
    --[[------------------------------------
    Shaman Reincarnation
    --------------------------------------]]
    elseif button == "BOT_SHAMAN_REINCARNATION_ALLOW" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove reincarnation")
    elseif button == "BOT_SHAMAN_REINCARNATION_DENY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add reincarnation")
    
    --[[------------------------------------
    Class-specific actions with modules
    --------------------------------------]]
    elseif classModule and classModule.HandleButtonClick then
        if classModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT_NAME) then
            -- If the module handled the click, close menus and return
            CloseDropDownMenus()
            return
        end
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
        elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add scare beast")
        end
    --[[------------------------------------
    Rogue stealth control
    --------------------------------------]]
    elseif button == "BOT_ROGUE_STEALTH_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove stealth")
    elseif button == "BOT_ROGUE_STEALTH_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add stealth")
    --[[------------------------------------
    Priest Fear Ward
    --------------------------------------]]
    elseif string.find(button, "^BOT_PRIEST_FEAR_WARD_") then
        local _, _, playerName = string.find(button, "_([^_]+)$")
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set fearward on " .. playerName)
    --[[------------------------------------
    Default Behavior
    --------------------------------------]]
    else
        originalUnitPopupOnClick()
    end
    -- Close the dropdown menus
    CloseDropDownMenus()
end