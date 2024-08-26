DruidModule = {}
DruidModule.buttons = {}
DruidModule.menus = {}
DruidModule.actions = {}
DruidModule.menuOrder = {}

NCM_CLASS_DEFAULT_SETTINGS.Druid = {
    PROWL = 1,
    REBIRTH = 1,
}

function DruidModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    self.menuOrder = {}
    
    -- Stealth controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Prowl is learned at level 20
        local stealthStatus = NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid.PROWL == 1 and "|cFF00FFFFON|r" or "|cFFFF0000OFF|r"
        self.buttons.BOT_DRUID_STEALTH = { text = "|cFFFF7D0AStealth: " .. stealthStatus, dist = 0 }
        if NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid.PROWL == 1 then
            self.actions.BOT_DRUID_STEALTH = "deny add prowl"
        else
            self.actions.BOT_DRUID_STEALTH = "deny remove prowl"
        end
        table.insert(self.menuOrder, "BOT_DRUID_STEALTH")
    end
    
    -- Rebirth controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Rebirth is learned at level 20
        local rebirthStatus = NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid.REBIRTH == 1 and "|cFF00FFFFON|r" or "|cFFFF0000OFF|r"
        self.buttons.BOT_DRUID_REBIRTH = { text = "|cFFFF7D0ARebirth: " .. rebirthStatus, dist = 0 }
        if NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Druid.REBIRTH == 1 then
            self.actions.BOT_DRUID_REBIRTH = "deny add rebirth"
        else
            self.actions.BOT_DRUID_REBIRTH = "deny remove rebirth"
        end
        table.insert(self.menuOrder, "BOT_DRUID_REBIRTH")
    end
end

function DruidModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        
        -- Update Druid settings
        if button == "BOT_DRUID_STEALTH" then
            NCMCompanions[unitName].Druid.PROWL = 1 - NCMCompanions[unitName].Druid.PROWL
            -- Update the action for the next click
            if NCMCompanions[unitName].Druid.PROWL == 1 then
                self.actions.BOT_DRUID_STEALTH = "deny add prowl"
            else
                self.actions.BOT_DRUID_STEALTH = "deny remove prowl"
            end
        elseif button == "BOT_DRUID_REBIRTH" then
            NCMCompanions[unitName].Druid.REBIRTH = 1 - NCMCompanions[unitName].Druid.REBIRTH
            -- Update the action for the next click
            if NCMCompanions[unitName].Druid.REBIRTH == 1 then
                self.actions.BOT_DRUID_REBIRTH = "deny add rebirth"
            else
                self.actions.BOT_DRUID_REBIRTH = "deny remove rebirth"
            end
        end
        return true
    end
    return false
end