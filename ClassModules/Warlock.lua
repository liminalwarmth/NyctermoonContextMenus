WarlockModule = {}
WarlockModule.buttons = {}
WarlockModule.menus = {}
WarlockModule.actions = {}
WarlockModule.menuOrder = {}

function WarlockModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    self.menuOrder = {}
    
    -- Summon player ritual
    if NYCTER_SELECTED_UNIT_LEVEL >= 20 then
        self.buttons.BOT_WARLOCK_SUMMON_PLAYER_RITUAL = { text = "|cFF9482C9Summon Player|r", dist = 0 }
        self.actions.BOT_WARLOCK_SUMMON_PLAYER_RITUAL = "cast Ritual of Summoning"
        table.insert(self.menuOrder, "BOT_WARLOCK_SUMMON_PLAYER_RITUAL")
    end
    
    -- Pet controls
    self.buttons.BOT_PET_TOGGLE = { text = "|cFF9482C9Pet Control|r", dist = 0, nested = 1 }
    self.buttons.BOT_PET_ON = { text = "|cff1EFF00Summon Pet|r", dist = 0 }
    self.buttons.BOT_PET_OFF = { text = "|cffFF0000Dismiss Pet|r", dist = 0 }
    self.actions.BOT_PET_ON = "set pet on"
    self.actions.BOT_PET_OFF = "set pet off"
    
    -- Pet selection
    self.buttons.BOT_WARLOCK_PET = { text = "|cFF9482C9Choose Demon|r", dist = 0, nested = 1 }
    local petTypes = {
        {name = "Imp", level = 1},
        {name = "Voidwalker", level = 10},
        {name = "Felhunter", level = 20},
        {name = "Succubus", level = 30}
    }
    
    for _, pet in ipairs(petTypes) do
        local buttonName = "BOT_WARLOCK_PET_" .. string.upper(pet.name)
        self.buttons[buttonName] = { text = pet.name, dist = 0 }
        self.actions[buttonName] = "set pet " .. string.lower(pet.name)
    end
    
    -- Create menus based on level
    if NYCTER_SELECTED_UNIT_LEVEL >= 1 then
        self.menus.BOT_PET_TOGGLE = { "BOT_PET_ON", "BOT_PET_OFF" }
        table.insert(self.menuOrder, "BOT_PET_TOGGLE")
        if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
            self.menus.BOT_WARLOCK_PET = {}
            for _, pet in ipairs(petTypes) do
                if NYCTER_SELECTED_UNIT_LEVEL >= pet.level then
                    table.insert(self.menus.BOT_WARLOCK_PET, "BOT_WARLOCK_PET_" .. string.upper(pet.name))
                end
            end
            table.insert(self.menuOrder, "BOT_WARLOCK_PET")
        end
    end
    
    -- Soulstone
    if NYCTER_SELECTED_UNIT_LEVEL >= 18 then
        self.buttons.BOT_WARLOCK_SOULSTONE = { text = "|cFF9482C9Set Soulstone On|r", dist = 0, nested = 1 }
        self.menus.BOT_WARLOCK_SOULSTONE = GetLocalGroupMembers(NYCTER_SELECTED_UNIT, true, true, "BOT_WARLOCK_SOULSTONE")
        table.insert(self.menuOrder, "BOT_WARLOCK_SOULSTONE")
    end
end

function WarlockModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local unitName = UnitName(NYCTER_SELECTED_UNIT)
    if button == "BOT_WARLOCK_SUMMON_PLAYER_RITUAL" then
        local targetName = UnitName("target")
        if not UnitInParty("target") and not UnitInRaid("target") then
            StaticPopupDialogs["SUMMON_INVALID_TARGET"] = {
                text = "You don't have a valid player targeted for Ritual of Summoning. Please target a player in your party or raid group.",
                button1 = OKAY,
                timeout = 0,
                hideOnEscape = 1,
            }
            StaticPopup_Show("SUMMON_INVALID_TARGET")
        else
            local function castSummon()
                SendTargetedBotWhisperCommand(unitName, self.actions[button])
            end
            -- Check config for confirmation dialog setting
            if NCMCONFIG["CONFIRM_WARLOCK_SUMMONING"] then
                StaticPopupDialogs["SUMMON_CONFIRM"] = {
                    text = "Are you sure you want " .. unitName .. " to cast Ritual of Summoning on " .. targetName .. "? You have a limited number of uses.",
                    button1 = OKAY,
                    button2 = CANCEL,
                    OnAccept = castSummon,
                    timeout = 0,
                    hideOnEscape = 1,
                }
                StaticPopup_Show("SUMMON_CONFIRM")
            else
                castSummon()
            end
        end
        return true
    elseif string.find(button, "^BOT_WARLOCK_SOULSTONE_") then
        local _, _, playerName = string.find(button, "_([^_]+)$")
        DEFAULT_CHAT_FRAME:AddMessage("Debug: Soulstone command triggered for " .. playerName)
        SendTargetedBotWhisperCommand(unitName, "set soulstone on " .. playerName)
        DEFAULT_CHAT_FRAME:AddMessage("Debug: Soulstone command sent to " .. unitName .. " for " .. playerName)
        return true
    elseif self.actions[button] then
        SendTargetedBotWhisperCommand(unitName, self.actions[button])
        return true
    end  
    return false
end
