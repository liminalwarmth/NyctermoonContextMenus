RogueModule = {}
RogueModule.buttons = {}
RogueModule.menus = {}
RogueModule.actions = {}

function RogueModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Stealth controls
    self.buttons.BOT_ROGUE_STEALTH = { text = "|cFFFFF569Stealth Control|r", dist = 0, nested = 1 }
    self.buttons.BOT_ROGUE_STEALTH_ON = { text = "|cff1EFF00Allow Stealth|r", dist = 0 }
    self.buttons.BOT_ROGUE_STEALTH_OFF = { text = "|cffFF0000Prevent Stealth|r", dist = 0 }
    self.actions.BOT_ROGUE_STEALTH_ON = "deny remove stealth"
    self.actions.BOT_ROGUE_STEALTH_OFF = "deny add stealth"
    
    self.menus.BOT_ROGUE_STEALTH = { "BOT_ROGUE_STEALTH_ON", "BOT_ROGUE_STEALTH_OFF" }
end

function RogueModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        return true
    end
    return false
end
