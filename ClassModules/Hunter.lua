HunterModule = {}
HunterModule.buttons = {}
HunterModule.menus = {}
HunterModule.actions = {}

function HunterModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Pet controls
    self.buttons.BOT_PET_TOGGLE = { text = "|cFFABD473Pet Control|r", dist = 0, nested = 1 }
    self.buttons.BOT_PET_ON = { text = "|cff1EFF00Summon Pet|r", dist = 0 }
    self.buttons.BOT_PET_OFF = { text = "|cffFF0000Dismiss Pet|r", dist = 0 }
    self.actions.BOT_PET_ON = "set pet on"
    self.actions.BOT_PET_OFF = "set pet off"
    
    -- Pet selection
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
    
    for _, pet in ipairs(petTypes) do
        local buttonName = "BOT_HUNTER_PET_" .. string.upper(pet.name)
        local displayName = pet.displayName or pet.name
        local buttonText = pet.color .. displayName .. "|r"
        if pet.extra then
            buttonText = buttonText .. " " .. pet.extra
        end
        self.buttons[buttonName] = { text = buttonText, dist = 0 }
        self.actions[buttonName] = "set pet " .. string.lower(pet.name)
    end
    
    -- Aspect controls
    self.buttons.BOT_HUNTER_ASPECT = { text = "|cFFABD473Set Aspect|r", dist = 0, nested = 1 }
    self.buttons.BOT_HUNTER_ASPECT_DEFAULT = { text = "AI Default (Clear Setting)", dist = 0 }
    self.actions.BOT_HUNTER_ASPECT_DEFAULT = "set aspect cancel"
    
    local aspects = {
        {level = 10, name = "Hawk"},
        {level = 20, name = "Cheetah"},
        {level = 40, name = "Pack"},
        {level = 46, name = "Wild"}
    }
    
    for _, aspect in ipairs(aspects) do
        local buttonName = "BOT_HUNTER_ASPECT_" .. string.upper(aspect.name)
        self.buttons[buttonName] = { text = "Aspect of the " .. aspect.name, dist = 0 }
        self.actions[buttonName] = "set aspect Aspect of the " .. aspect.name
    end
    
    -- Create menus based on level
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        self.menus.BOT_PET_TOGGLE = { "BOT_PET_ON", "BOT_PET_OFF" }
        self.menus.BOT_HUNTER_PET = {}
        for _, pet in ipairs(petTypes) do
            table.insert(self.menus.BOT_HUNTER_PET, "BOT_HUNTER_PET_" .. string.upper(pet.name))
        end
        
        self.menus.BOT_HUNTER_ASPECT = { "BOT_HUNTER_ASPECT_DEFAULT" }
        for _, aspect in ipairs(aspects) do
            if NYCTER_SELECTED_UNIT_LEVEL >= aspect.level then
                table.insert(self.menus.BOT_HUNTER_ASPECT, "BOT_HUNTER_ASPECT_" .. string.upper(aspect.name))
            end
        end
    end
end

function HunterModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        return true
    end
    return false
end
