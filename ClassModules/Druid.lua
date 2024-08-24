DruidModule = {}
DruidModule.buttons = {}
DruidModule.menus = {}
DruidModule.actions = {}

function DruidModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Stealth controls
    self.buttons.BOT_DRUID_STEALTH = { text = "|cFFFF7D0AStealth Control|r", dist = 0, nested = 0 }
    self.buttons.BOT_DRUID_STEALTH_ON = { text = "|cff1EFF00Allow Stealth|r", dist = 0 }
    self.buttons.BOT_DRUID_STEALTH_OFF = { text = "|cffFF0000Prevent Stealth|r", dist = 0 }
    self.actions.BOT_DRUID_STEALTH_ON = "deny remove prowl"
    self.actions.BOT_DRUID_STEALTH_OFF = "deny add prowl"
    
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Prowl is learned at level 20
        self.buttons.BOT_DRUID_STEALTH.nested = 1
        self.menus.BOT_DRUID_STEALTH = { "BOT_DRUID_STEALTH_ON", "BOT_DRUID_STEALTH_OFF" }
    end
    
    -- Rebirth controls
    self.buttons.BOT_DRUID_REBIRTH = { text = "|cFFFF7D0ARebirth|r", dist = 0, nested = 0 }
    self.buttons.BOT_DRUID_REBIRTH_ALLOW = { text = "|cff1EFF00Allow Combat Resurrect|r", dist = 0 }
    self.buttons.BOT_DRUID_REBIRTH_DENY = { text = "|cffFF0000Deny Combat Resurrect|r", dist = 0 }
    self.actions.BOT_DRUID_REBIRTH_ALLOW = "deny remove rebirth"
    self.actions.BOT_DRUID_REBIRTH_DENY = "deny add rebirth"
    
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then -- Rebirth is learned at level 20
        self.buttons.BOT_DRUID_REBIRTH.nested = 1
        self.menus.BOT_DRUID_REBIRTH = { "BOT_DRUID_REBIRTH_ALLOW", "BOT_DRUID_REBIRTH_DENY" }
    end
end

function DruidModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT_NAME)
    local command = self.actions[button]
    if command then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, command)
    end
end