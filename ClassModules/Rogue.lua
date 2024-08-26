RogueModule = {}
RogueModule.buttons = {}
RogueModule.menus = {}
RogueModule.actions = {}
RogueModule.menuOrder = {}

NCM_CLASS_DEFAULT_SETTINGS.Rogue = {
    STEALTH = 1,
}

function RogueModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    self.menuOrder = {}
    
    -- Stealth controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 1 then -- Stealth is learned at level 1 for rogues
        local stealthStatus = NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Rogue and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Rogue.STEALTH == 1 and "|cFF00FFFFON|r" or "|cFFFF0000OFF|r"
        self.buttons.BOT_ROGUE_STEALTH = { text = "|cFFFFF569Stealth: " .. stealthStatus, dist = 0 }
        if NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Rogue and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Rogue.STEALTH == 1 then
            self.actions.BOT_ROGUE_STEALTH = "deny add stealth"
        else
            self.actions.BOT_ROGUE_STEALTH = "deny remove stealth"
        end
        table.insert(self.menuOrder, "BOT_ROGUE_STEALTH")
    end
end

function RogueModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        
        -- Update Rogue settings
        if button == "BOT_ROGUE_STEALTH" then
            NCMCompanions[unitName].Rogue.STEALTH = 1 - NCMCompanions[unitName].Rogue.STEALTH
            -- Update the action for the next click
            if NCMCompanions[unitName].Rogue.STEALTH == 1 then
                self.actions.BOT_ROGUE_STEALTH = "deny add stealth"
            else
                self.actions.BOT_ROGUE_STEALTH = "deny remove stealth"
            end
        end
        return true
    end
    return false
end
