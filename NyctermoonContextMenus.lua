-- NyctermoonContextMenus.lua

-- Define custom popup buttons and menus
UnitPopupButtons["BOT_CONTROL"] = { text = "Bot Settings", dist = 0, nested = 1 }
UnitPopupButtons["BOT_TOGGLE_HELM"] = {text = "Toggle Helm", dist = 0}
UnitPopupButtons["BOT_TOGGLE_CLOAK"] = { text = "Toggle Cloak", dist = 0 }
UnitPopupButtons["BOT_TOGGLE_AOE"] = { text = "Toggle AoE", dist = 0 }
UnitPopupMenus["BOT_CONTROL"] = { "BOT_TOGGLE_HELM", "BOT_TOGGLE_CLOAK", "BOT_TOGGLE_AOE"}

-- Define role settings
UnitPopupButtons["BOT_SET_ROLE"] = { text = "Set Role", dist = 0, nested = 1 }
UnitPopupButtons["BOT_ROLE_TANK"] = { text = "Tank", dist = 0 }
UnitPopupButtons["BOT_ROLE_HEALER"] = { text = "Healer", dist = 0 }
UnitPopupButtons["BOT_ROLE_DPS"] = { text = "DPS", dist = 0 }
UnitPopupButtons["BOT_ROLE_MDPS"] = { text = "Melee DPS", dist = 0 }
UnitPopupButtons["BOT_ROLE_RDPS"] = { text = "Ranged DPS", dist = 0 }
UnitPopupMenus["BOT_SET_ROLE"] = { "BOT_ROLE_TANK", "BOT_ROLE_HEALER", "BOT_ROLE_DPS", "BOT_ROLE_MDPS", "BOT_ROLE_RDPS" }

-- Insert custom buttons into the PARTY pc menu
table.insert(UnitPopupMenus["PARTY"], 1, "BOT_CONTROL")
table.insert(UnitPopupMenus["PARTY"], 2, "BOT_SET_ROLE")

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
UnitPopupButtons["BOT_PALADIN_BLESSING_DEFAULT"] = { text = "Default (Cancel)", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_MIGHT"] = { text = "Blessing of Might", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_WISDOM"] = { text = "Blessing of Wisdom", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_KINGS"] = { text = "Blessing of Kings", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_LIGHT"] = { text = "Blessing of Light", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_SALVATION"] = { text = "Blessing of Salvation", dist = 0 }
UnitPopupButtons["BOT_PALADIN_BLESSING_SANCTUARY"] = { text = "Blessing of Sanctuary", dist = 0 }

-- PALADIN: Choose auras
UnitPopupButtons["BOT_PALADIN_AURAS"] = { text = "Set Aura", dist = 0, nested = 1 }
UnitPopupButtons["BOT_PALADIN_AURA_DEVOTION"] = { text = "Devotion Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_RETRIBUTION"] = { text = "Retribution Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_CONCENTRATION"] = { text = "Concentration Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_SHADOW_RESISTANCE"] = { text = "Shadow Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_FROST_RESISTANCE"] = { text = "Frost Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_FIRE_RESISTANCE"] = { text = "Fire Resistance Aura", dist = 0 }
UnitPopupButtons["BOT_PALADIN_AURA_SANCTITY"] = { text = "Sanctity Aura", dist = 0 }

-- SHAMAN: Choose air totem
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM"] = { text = "Set Air Totem", dist = 0, nested = 1 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_GRACE"] = { text = "Grace of Air", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_NATURE"] = { text = "Nature Resistance", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_WINDWALL"] = { text = "Windwall", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_WINDFURY"] = { text = "Windfury", dist = 0 }
UnitPopupButtons["BOT_SHAMAN_AIR_TOTEM_TRANQUIL"] = { text = "Tranquil Air", dist = 0 }

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
        if string.find(menu, "^BOT_") and menu ~= "BOT_CONTROL" and menu ~= "BOT_SET_ROLE" then
            table.remove(UnitPopupMenus["PARTY"], i)
        end
        i = i - 1
    end

    -- Conditionally edit the tables for each class
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
                table.insert(UnitPopupMenus["PARTY"], 3, "BOT_OPEN_PORTAL")
            end
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then -- Blink is learned at level 22
            table.insert(UnitPopupMenus["PARTY"], 4, "BOT_DENY_DANGER_SPELLS")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_HUNTER_PET"] = { "BOT_HUNTER_PET_BAT", "BOT_HUNTER_PET_BEAR", "BOT_HUNTER_PET_BIRD", "BOT_HUNTER_PET_BOAR", "BOT_HUNTER_PET_CAT", "BOT_HUNTER_PET_CRAB", "BOT_HUNTER_PET_CROC", "BOT_HUNTER_PET_GORILLA", "BOT_HUNTER_PET_HYENA", "BOT_HUNTER_PET_OWL", "BOT_HUNTER_PET_RAPTOR", "BOT_HUNTER_PET_SCORPID", "BOT_HUNTER_PET_SERPENT", "BOT_HUNTER_PET_SPIDER", "BOT_HUNTER_PET_STRIDER", "BOT_HUNTER_PET_TURTLE", "BOT_HUNTER_PET_WOLF" }
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- Hunters get pets at level 10
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_PET_TOGGLE")
            table.insert(UnitPopupMenus["PARTY"], 4, "BOT_HUNTER_PET")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
        UnitPopupMenus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        UnitPopupMenus["BOT_WARLOCK_PET"] = { "BOT_WARLOCK_PET_IMP", "BOT_WARLOCK_PET_VOIDWALKER", "BOT_WARLOCK_PET_SUCCUBUS", "BOT_WARLOCK_PET_FELHUNTER" }
        table.insert(UnitPopupMenus["PARTY"], 3, "BOT_PET_TOGGLE")
        table.insert(UnitPopupMenus["PARTY"], 4, "BOT_WARLOCK_PET")
        if NYCTER_SELECTED_UNIT_LEVEL >= 50 then -- Ritual of Summoning is learned at level 50 in vanilla WoW 1.12.1
            table.insert(UnitPopupMenus["PARTY"], 5, "BOT_WARLOCK_SUMMON_PLAYER_RITUAL")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 8 then -- Fear is learned at level 8
            table.insert(UnitPopupMenus["PARTY"], 6, "BOT_DENY_DANGER_SPELLS")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Paladin" then
        -- TODO: swap for greater blessings at right levels
        local blessings = {}
        local auras = {}
        if NYCTER_SELECTED_UNIT_LEVEL >= 4 then
            table.insert(blessings, "BOT_PALADIN_BLESSING_MIGHT")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 14 then
            table.insert(blessings, "BOT_PALADIN_BLESSING_WISDOM")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 26 then
            table.insert(blessings, "BOT_PALADIN_BLESSING_SALVATION")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
            table.insert(blessings, "BOT_PALADIN_BLESSING_LIGHT")
        end
        -- TODO: Double check sanctuary, might be a greater blessing
        if NYCTER_SELECTED_UNIT_LEVEL >= 60 then
            table.insert(blessings, "BOT_PALADIN_BLESSING_SANCTUARY")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 60 then
            table.insert(blessings, "BOT_PALADIN_BLESSING_KINGS")
        end
        if table.getn(blessings) > 0 then
            table.insert(blessings, 1, "BOT_PALADIN_BLESSING_DEFAULT")
            UnitPopupMenus["BOT_PALADIN_BLESSING"] = blessings
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_PALADIN_BLESSING")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 1 then
            table.insert(auras, "BOT_PALADIN_AURA_DEVOTION")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 16 then
            table.insert(auras, "BOT_PALADIN_AURA_RETRIBUTION")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then
            table.insert(auras, "BOT_PALADIN_AURA_CONCENTRATION")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 28 then
            table.insert(auras, "BOT_PALADIN_AURA_SHADOW_RESISTANCE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 32 then
            table.insert(auras, "BOT_PALADIN_AURA_FROST_RESISTANCE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 36 then
            table.insert(auras, "BOT_PALADIN_AURA_FIRE_RESISTANCE")
        end
        if table.getn(auras) > 0 then
            UnitPopupMenus["BOT_PALADIN_AURAS"] = auras
            table.insert(UnitPopupMenus["PARTY"], 4, "BOT_PALADIN_AURAS")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Shaman" then
        local air_totems = {}
        local earth_totems = {}
        local fire_totems = {}
        local water_totems = {}
        if NYCTER_SELECTED_UNIT_LEVEL >= 30 then
            table.insert(air_totems, "BOT_SHAMAN_AIR_TOTEM_GRACE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 28 then
            table.insert(air_totems, "BOT_SHAMAN_AIR_TOTEM_NATURE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 36 then
            table.insert(air_totems, "BOT_SHAMAN_AIR_TOTEM_WINDWALL")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 32 then
            table.insert(air_totems, "BOT_SHAMAN_AIR_TOTEM_WINDFURY")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 50 then
            table.insert(air_totems, "BOT_SHAMAN_AIR_TOTEM_TRANQUIL")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 4 then
            table.insert(earth_totems, "BOT_SHAMAN_EARTH_TOTEM_STONESKIN")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
            table.insert(earth_totems, "BOT_SHAMAN_EARTH_TOTEM_EARTHBIND")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 28 then
            table.insert(earth_totems, "BOT_SHAMAN_EARTH_TOTEM_STRENGTH")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 18 then
            table.insert(earth_totems, "BOT_SHAMAN_EARTH_TOTEM_TREMOR")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
            table.insert(fire_totems, "BOT_SHAMAN_FIRE_TOTEM_SEARING")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 12 then
            table.insert(fire_totems, "BOT_SHAMAN_FIRE_TOTEM_FIRE_NOVA")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 28 then
            table.insert(fire_totems, "BOT_SHAMAN_FIRE_TOTEM_FROST_RESISTANCE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 26 then
            table.insert(fire_totems, "BOT_SHAMAN_FIRE_TOTEM_MAGMA")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
            table.insert(fire_totems, "BOT_SHAMAN_FIRE_TOTEM_FLAMETONGUE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
            table.insert(water_totems, "BOT_SHAMAN_WATER_TOTEM_HEALING")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 26 then
            table.insert(water_totems, "BOT_SHAMAN_WATER_TOTEM_MANA_SPRING")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 28 then
            table.insert(water_totems, "BOT_SHAMAN_WATER_TOTEM_FIRE_RESISTANCE")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then
            table.insert(water_totems, "BOT_SHAMAN_WATER_TOTEM_DISEASE_CLEANSING")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then
            table.insert(water_totems, "BOT_SHAMAN_WATER_TOTEM_POISON_CLEANSING")
        end
        if table.getn(air_totems) > 0 then
            UnitPopupMenus["BOT_SHAMAN_AIR_TOTEM"] = air_totems
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_SHAMAN_AIR_TOTEM")
        end
        if table.getn(earth_totems) > 0 then
            UnitPopupMenus["BOT_SHAMAN_EARTH_TOTEM"] = earth_totems
            table.insert(UnitPopupMenus["PARTY"], 4, "BOT_SHAMAN_EARTH_TOTEM")
        end
        if table.getn(fire_totems) > 0 then
            UnitPopupMenus["BOT_SHAMAN_FIRE_TOTEM"] = fire_totems
            table.insert(UnitPopupMenus["PARTY"], 5, "BOT_SHAMAN_FIRE_TOTEM")
        end
        if table.getn(water_totems) > 0 then
            UnitPopupMenus["BOT_SHAMAN_WATER_TOTEM"] = water_totems
            table.insert(UnitPopupMenus["PARTY"], 6, "BOT_SHAMAN_WATER_TOTEM")
        end
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- First totem is available at level 10
            table.insert(UnitPopupMenus["PARTY"], 7, "BOT_SHAMAN_CLEAR_TOTEMS")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 14 then -- Psychic Scream is learned at level 14
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_DENY_DANGER_SPELLS")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 22 then -- Intimidating Shout is learned at level 22
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_DENY_DANGER_SPELLS")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Rogue" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- Stealth is learned at level 10
            UnitPopupMenus["BOT_ROGUE_STEALTH"] = { "BOT_ROGUE_STEALTH_ON", "BOT_ROGUE_STEALTH_OFF" }
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_ROGUE_STEALTH")
        end
    elseif NYCTER_SELECTED_UNIT_CLASS == "Druid" then
        if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Stealth is learned at level 20 (cat form)
            UnitPopupMenus["BOT_DRUID_STEALTH"] = { "BOT_DRUID_STEALTH_ON", "BOT_DRUID_STEALTH_OFF" }
            table.insert(UnitPopupMenus["PARTY"], 3, "BOT_DRUID_STEALTH")
        end
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
    
    -- Bot control toggles
    if button == "BOT_TOGGLE_HELM" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle helm")
    elseif button == "BOT_TOGGLE_CLOAK" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle cloak")
    elseif button == "BOT_TOGGLE_AOE" then
        SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, "toggle aoe")
    -- Bot set roles
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
    -- Mage portals
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
    -- Warlock summon player ritual
    elseif button == "BOT_WARLOCK_SUMMON_PLAYER_RITUAL" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Ritual of Summoning")
    -- Pet toggle
    elseif button == "BOT_PET_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet on")
    elseif button == "BOT_PET_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet off")
    -- Hunter pets
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
    -- Warlock pets
    elseif button == "BOT_WARLOCK_PET_IMP" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet imp")
    elseif button == "BOT_WARLOCK_PET_VOIDWALKER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet voidwalker")
    elseif button == "BOT_WARLOCK_PET_SUCCUBUS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet succubus")
    elseif button == "BOT_WARLOCK_PET_FELHUNTER" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet felhunter")
    -- Paladin blessings
    elseif button == "BOT_PALADIN_BLESSING_DEFAULT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing cancel")
    elseif button == "BOT_PALADIN_BLESSING_MIGHT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Might")
    elseif button == "BOT_PALADIN_BLESSING_WISDOM" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Wisdom")
    elseif button == "BOT_PALADIN_BLESSING_KINGS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Kings")
    elseif button == "BOT_PALADIN_BLESSING_LIGHT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Light")
    elseif button == "BOT_PALADIN_BLESSING_SALVATION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Salvation")
    elseif button == "BOT_PALADIN_BLESSING_SANCTUARY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set blessing Blessing of Sanctuary")
    -- Paladin auras
    elseif button == "BOT_PALADIN_AURA_DEVOTION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Devotion Aura")
    elseif button == "BOT_PALADIN_AURA_RETRIBUTION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Retribution Aura")
    elseif button == "BOT_PALADIN_AURA_CONCENTRATION" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Concentration Aura")
    elseif button == "BOT_PALADIN_AURA_SHADOW_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Shadow Resistance Aura")
    elseif button == "BOT_PALADIN_AURA_FROST_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Frost Resistance Aura")
    elseif button == "BOT_PALADIN_AURA_FIRE_RESISTANCE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Fire Resistance Aura")
    elseif button == "BOT_PALADIN_AURA_SANCTITY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "cast Sanctity Aura")
    -- Shaman air totems
    elseif button == "BOT_SHAMAN_AIR_TOTEM_GRACE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Grace of Air Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_NATURE" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Nature Resistance Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_WINDWALL" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Windwall Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_WINDFURY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Windfury Totem")
    elseif button == "BOT_SHAMAN_AIR_TOTEM_TRANQUIL" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Tranquil Air Totem")
    -- Shaman earth totems
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_STONESKIN" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Stoneskin Totem")
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_EARTHBIND" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Earthbind Totem")
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_STRENGTH" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Strength of Earth Totem")
    elseif button == "BOT_SHAMAN_EARTH_TOTEM_TREMOR" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem Tremor Totem")
    -- Shaman fire totems
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
    -- Shaman water totems
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
    -- Clear all totems
    elseif button == "BOT_SHAMAN_CLEAR_TOTEMS" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set totem cancel")
    -- Deny danger spells
    elseif button == "BOT_DENY_DANGER_SPELLS" then
        if NYCTER_SELECTED_UNIT_CLASS == "Mage" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add blink")
        elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add psychic scream")
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add holy nova")
        elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add fear")
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add howl of terror")
        elseif NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add intimidating shout")
        end
    -- Rogue stealth control
    elseif button == "BOT_ROGUE_STEALTH_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove stealth")
    elseif button == "BOT_ROGUE_STEALTH_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add stealth")
    -- Druid stealth control
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