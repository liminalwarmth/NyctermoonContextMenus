HunterModule = {}
HunterModule.buttons = {}
HunterModule.menus = {}
HunterModule.actions = {}
HunterModule.menuOrder = {}

NCM_CLASS_DEFAULT_SETTINGS.Hunter = {
    PET_ENABLED = 1,
    ASPECT = "",
}

function HunterModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    self.menuOrder = {}
    
    -- Pet controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        local petStatus = NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Hunter and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Hunter.PET_ENABLED == 1 and "|cFF00FFFFON|r" or "|cFFFF0000OFF|r"
        self.buttons.BOT_PET_TOGGLE = { text = "|cFFABD473Pet: " .. petStatus, dist = 0 }
        self.actions.BOT_PET_TOGGLE = NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Hunter.PET_ENABLED == 1 and "set pet off" or "set pet on"
        table.insert(self.menuOrder, "BOT_PET_TOGGLE")
    end
    
    -- Pet selection
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        self.buttons.BOT_HUNTER_PET = { text = "|cFFABD473Choose Beast|r", dist = 0, nested = 1 }
        local petTypes = {
            {name = "Bat", color = "|cFFFF7D0A"},
            {name = "Bear", color = "|cFF0070DE"},
            {name = "Boar", color = "|cFF0070DE", extra = "|cFFFFFFFF(Charge)|r"},
            {name = "Bird", color = "|cFFFFF569", displayName = "Carrion Bird"},
            {name = "Cat", color = "|cFFFF7D0A", extra = "|cFFFFFFFF(Prowl)|r"},
            {name = "Crab", color = "|cFF0070DE"},
            {name = "Croc", color = "|cFF0070DE", displayName = "Crocolisk"},
            {name = "Gorilla", color = "|cFF0070DE", extra = "|cFFFFFFFF(Thunderstomp)|r"},
            {name = "Hyena", color = "|cFFFFF569"},
            {name = "Owl", color = "|cFFFF7D0A"},
            {name = "Raptor", color = "|cFFFF7D0A"},
            {name = "Scorpid", color = "|cFF0070DE", extra = "|cFFFFFFFF(Scorpid Poison)|r"},
            {name = "Spider", color = "|cFFFF7D0A"},
            {name = "Strider", color = "|cFF0070DE", displayName = "Tallstrider"},
            {name = "Turtle", color = "|cFF0070DE", extra = "|cFFFFFFFF(Shell Shield)|r"},
            {name = "Serpent", color = "|cFFFF7D0A", displayName = "Wind Serpent", extra = "|cFFFFFFFF(Lightning Breath)|r"},
            {name = "Wolf", color = "|cFFFFF569", extra = "|cFFFFFFFF(Furious Howl)|r"}
        }
        
        self.menus.BOT_HUNTER_PET = {}
        for _, pet in ipairs(petTypes) do
            local buttonName = "BOT_HUNTER_PET_" .. string.upper(pet.name)
            local displayName = pet.displayName or pet.name
            local buttonText = pet.color .. displayName .. "|r"
            if pet.extra then
                buttonText = buttonText .. " " .. pet.extra
            end
            self.buttons[buttonName] = { text = buttonText, dist = 0 }
            self.actions[buttonName] = "set pet " .. string.lower(pet.name)
            table.insert(self.menus.BOT_HUNTER_PET, buttonName)
        end
        table.insert(self.menuOrder, "BOT_HUNTER_PET")
    end
    -- Aspect controls
    local aspects = {
        {level = 1, name = "None"},
        {level = 10, name = "Hawk"},
        {level = 20, name = "Cheetah"},
        {level = 40, name = "Pack"},
        {level = 46, name = "Wild"}
    }
    
    local availableAspects = {}
    for _, aspect in ipairs(aspects) do
        if NYCTER_SELECTED_UNIT_LEVEL >= aspect.level then
            table.insert(availableAspects, aspect)
        end
    end
    
    if table.getn(availableAspects) > 1 then
        self.buttons.BOT_HUNTER_ASPECT = { text = "|cFFABD473Set Aspect|r", dist = 0, nested = 1 }
        self.menus.BOT_HUNTER_ASPECT = {}
        
        for _, aspect in ipairs(availableAspects) do
            local buttonName = "BOT_HUNTER_ASPECT_" .. string.upper(aspect.name)
            local buttonText = aspect.name == "None" and "AI Default (Clear Setting)" or "Aspect of the " .. aspect.name
            if aspect.name ~= "None" and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Hunter.ASPECT == "Aspect of the " .. aspect.name then
                buttonText = buttonText .. " |cFF00FFFF[x]|r"
            end
            self.buttons[buttonName] = { text = buttonText, dist = 0 }
            self.actions[buttonName] = aspect.name == "None" and "set aspect cancel" or "set aspect Aspect of the " .. aspect.name
            table.insert(self.menus.BOT_HUNTER_ASPECT, buttonName)
        end
        table.insert(self.menuOrder, "BOT_HUNTER_ASPECT")
    end
end

function HunterModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        
        -- Update Hunter settings
        if button == "BOT_PET_TOGGLE" then
            NCMCompanions[unitName].Hunter.PET_ENABLED = 1 - NCMCompanions[unitName].Hunter.PET_ENABLED
        elseif string.find(button, "^BOT_HUNTER_ASPECT_") then
            local _, _, aspectName = string.find(command, "set aspect (.+)")
            NCMCompanions[unitName].Hunter.ASPECT = aspectName or ""
        end
        
        -- Update the menu to reflect the new settings
        self:UpdateMenu(UnitLevel(NYCTER_SELECTED_UNIT))
        return true
    end
    return false
end
