-- NyctermoonContextMenus.lua
-- Coded for Vanilla WoW 1.12.1, using LUA version 5.0

--[[ TODO:
- Slash commands and options menu
- Make portal and summoning confirmations optional

[MAYBE?]
- Custom stats display frame on your character
- Add tooltips to menu commands
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
    Hunter = HunterModule,
    Priest = PriestModule,
    Warrior = WarriorModule,
    Rogue = RogueModule,
    Paladin = PaladinModule,
    Shaman = ShamanModule,
    Mage = MageModule,
    Warlock = WarlockModule
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
            end
            -- If there's a menuOrder, it will be used (primarily for Shaman)
            if classModule.menuOrder then
                for _, menuItem in ipairs(classModule.menuOrder) do
                    table.insert(dynamicMenus, menuItem)
                end
            -- Otherwise, add the menus in reverse order, which is the order they're defined in
            else
                local menuNames = {}
                for menuName, _ in pairs(classModule.menus) do
                    table.insert(menuNames, menuName)
                end
                for i = table.getn(menuNames), 1, -1 do
                    table.insert(dynamicMenus, menuNames[i])
                end
            end
        end
    end
    UpdateClassMenu(NYCTER_SELECTED_UNIT_CLASS, NYCTER_SELECTED_UNIT_LEVEL)
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
    --[[------------------------------------
    Class-specific actions with modules
    --------------------------------------]]
    local classModule = ClassModules[NYCTER_SELECTED_UNIT_CLASS]
    -- Check if the button is handled by the class module
    if classModule and classModule.HandleButtonClick then
        if classModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT) then
            CloseDropDownMenus()
            return
        end
    end
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
    Deny danger spells
    --------------------------------------]]
    elseif button == "BOT_DENY_DANGER_SPELLS" then
        if NYCTER_SELECTED_UNIT_CLASS == "Mage" then
            -- Blink: Level 20
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add blink")
        elseif NYCTER_SELECTED_UNIT_CLASS == "Priest" then
            -- Psychic Scream: Level 8
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add psychic scream")
            if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
                -- Holy Nova: Level 20
                SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add holy nova")
            end
        elseif NYCTER_SELECTED_UNIT_CLASS == "Warlock" then
            -- Fear: Level 8
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add fear")
            if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
                -- Howl of Terror: Level 40
                SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add howl of terror")
            end
        elseif NYCTER_SELECTED_UNIT_CLASS == "Warrior" then
            -- Intimidating Shout: Level 22
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add intimidating shout")
        elseif NYCTER_SELECTED_UNIT_CLASS == "Hunter" then
            -- Scare Beast: Level 8
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add scare beast")
        end
    --[[------------------------------------
    Default Behavior
    --------------------------------------]]
    else
        originalUnitPopupOnClick()
    end
    -- Close the dropdown menus
    CloseDropDownMenus()
end