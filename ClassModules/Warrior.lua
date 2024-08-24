WarriorModule = {}
WarriorModule.buttons = {}
WarriorModule.menus = {}
WarriorModule.actions = {}

function WarriorModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}

end

function WarriorModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        return true
    end
    return false
end
