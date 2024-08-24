PriestModule = {}
PriestModule.buttons = {}
PriestModule.menus = {}
PriestModule.actions = {}

function PriestModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Fear Ward controls (Dwarf only)
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 and UnitRace(NYCTER_SELECTED_UNIT) == "Dwarf" then
        self.buttons.BOT_PRIEST_FEAR_WARD = { text = "|cFFFFFFA0Set Fear Ward On|r", dist = 0, nested = 1 }
        self.menus.BOT_PRIEST_FEAR_WARD = GetLocalGroupMembers(NYCTER_SELECTED_UNIT, true, true, "BOT_PRIEST_FEAR_WARD")
    end
end
function PriestModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    if string.find(button, "^BOT_PRIEST_FEAR_WARD_") then
        local _, _, playerName = string.find(button, "_([^_]+)$")
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, "set fearward on " .. playerName)
        return true
    end
    return false
end
