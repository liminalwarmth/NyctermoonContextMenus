DruidModule = {}

-- Button definitions
DruidModule.Buttons = {
    ["BOT_DRUID_STEALTH"] = { text = "|cFFFF7D0AStealth Control|r", dist = 0, nested = 1 },
    ["BOT_DRUID_STEALTH_ON"] = { text = "|cff1EFF00Allow Stealth|r", dist = 0 },
    ["BOT_DRUID_STEALTH_OFF"] = { text = "|cffFF0000Prevent Stealth|r", dist = 0 },
    ["BOT_DRUID_REBIRTH"] = { text = "|cFFFF7D0ARebirth|r", dist = 0, nested = 1 },
    ["BOT_DRUID_REBIRTH_ALLOW"] = { text = "|cff1EFF00Allow Combat Resurrect|r", dist = 0 },
    ["BOT_DRUID_REBIRTH_DENY"] = { text = "|cffFF0000Deny Combat Resurrect|r", dist = 0 },
}

-- Menu creation function
function DruidModule:CreateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    local menus = {}
    
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
        DruidModule.Buttons["BOT_DRUID_STEALTH"].nested = 1
        menus["BOT_DRUID_STEALTH"] = { "BOT_DRUID_STEALTH_ON", "BOT_DRUID_STEALTH_OFF" }
    end
    
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
        DruidModule.Buttons["BOT_DRUID_REBIRTH"].nested = 1
        menus["BOT_DRUID_REBIRTH"] = { "BOT_DRUID_REBIRTH_ALLOW", "BOT_DRUID_REBIRTH_DENY" }
    end
    
    return menus
end

-- Button click handlers
function DruidModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT_NAME)
    if button == "BOT_DRUID_STEALTH_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove prowl")
    elseif button == "BOT_DRUID_STEALTH_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add prowl")
    elseif button == "BOT_DRUID_REBIRTH_ALLOW" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny remove rebirth")
    elseif button == "BOT_DRUID_REBIRTH_DENY" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "deny add rebirth")
    end
end