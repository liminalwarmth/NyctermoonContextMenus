MageModule = {}
MageModule.buttons = {}
MageModule.menus = {}
MageModule.actions = {}

function MageModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Portal controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
        self.buttons.BOT_OPEN_PORTAL = { text = "|cFF69CCF0Open Portal|r", dist = 0, nested = 1 }
        self.menus.BOT_OPEN_PORTAL = {}
        
        local portals = {}
        if NYCTER_SELECTED_UNIT_RACE == "Human" or NYCTER_SELECTED_UNIT_RACE == "Dwarf" or NYCTER_SELECTED_UNIT_RACE == "Gnome" or NYCTER_SELECTED_UNIT_RACE == "NightElf" then
            table.insert(portals, {id = "BOT_PORTAL_STORMWIND", name = "Stormwind"})
            table.insert(portals, {id = "BOT_PORTAL_IRONFORGE", name = "Ironforge"})
            if NYCTER_SELECTED_UNIT_LEVEL >= 50 then
                table.insert(portals, {id = "BOT_PORTAL_DARNASSUS", name = "Darnassus"})
            end
        elseif NYCTER_SELECTED_UNIT_RACE == "Orc" or NYCTER_SELECTED_UNIT_RACE == "Troll" or NYCTER_SELECTED_UNIT_RACE == "Tauren" or NYCTER_SELECTED_UNIT_RACE == "Undead" then
            table.insert(portals, {id = "BOT_PORTAL_ORGRIMMAR", name = "Orgrimmar"})
            table.insert(portals, {id = "BOT_PORTAL_UNDERCITY", name = "Undercity"})
            if NYCTER_SELECTED_UNIT_LEVEL >= 50 then
                table.insert(portals, {id = "BOT_PORTAL_THUNDER_BLUFF", name = "Thunder Bluff"})
            end
        end
        
        for _, portal in ipairs(portals) do
            self.buttons[portal.id] = { text = portal.name, dist = 0 }
            self.actions[portal.id] = "cast Portal: " .. portal.name
            table.insert(self.menus.BOT_OPEN_PORTAL, portal.id)
        end
    end
    
    -- Amplify/Dampen Magic controls
    self.buttons.BOT_MAGE_AMPLIFY_MAGIC = { text = "|cFF69CCF0Set Amplify Magic|r", dist = 0, nested = 1 }
    self.buttons.BOT_MAGE_AMPLIFY_USE = { text = "Use Amplify Magic", dist = 0 }
    self.buttons.BOT_MAGE_DAMPEN_USE = { text = "Use Dampen Magic", dist = 0 }
    self.buttons.BOT_MAGE_AMPLIFY_NEITHER = { text = "None", dist = 0 }
    
    self.actions.BOT_MAGE_AMPLIFY_USE = "set magic amplify"
    self.actions.BOT_MAGE_DAMPEN_USE = "set magic dampen"
    self.actions.BOT_MAGE_AMPLIFY_NEITHER = "set magic none"
    
    if NYCTER_SELECTED_UNIT_LEVEL >= 12 then
        self.menus.BOT_MAGE_AMPLIFY_MAGIC = {"BOT_MAGE_AMPLIFY_NEITHER"}
    end
    if NYCTER_SELECTED_UNIT_LEVEL >= 12 then
        table.insert(self.menus.BOT_MAGE_AMPLIFY_MAGIC, 1, "BOT_MAGE_DAMPEN_USE")
    end
    if NYCTER_SELECTED_UNIT_LEVEL >= 18 then
        table.insert(self.menus.BOT_MAGE_AMPLIFY_MAGIC, 1, "BOT_MAGE_AMPLIFY_USE")
    end
    
end

function MageModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        if string.find(button, "^BOT_PORTAL_") then
            local _, _, city = string.find(button, "^BOT_PORTAL_(.+)$")
            if city then
                local portalCity = string.gsub(city, "_", " ")
                portalCity = string.gsub(portalCity, "(%a)([%w_']*)", function(first, rest)
                    return string.upper(first)..string.lower(rest)
                end)
                StaticPopupDialogs["PORTAL_CONFIRM"] = {
                    text = "Are you sure you want " .. unitName .. " to open a mage portal to " .. portalCity .. "? You have a limited number of portals per hire.",
                    button1 = OKAY,
                    button2 = CANCEL,
                    OnAccept = function()
                        SendTargetedBotWhisperCommand(unitName, command)
                    end,
                    timeout = 0,
                    hideOnEscape = 1,
                }
                StaticPopup_Show("PORTAL_CONFIRM")
                return true
            end
        else
            SendTargetedBotWhisperCommand(unitName, command)
            return true
        end
    end
    return false
end
