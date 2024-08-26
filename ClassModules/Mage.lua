MageModule = {}
MageModule.buttons = {}
MageModule.menus = {}
MageModule.actions = {}

NCM_CLASS_DEFAULT_SETTINGS.Mage = {
    PORTALS_MAX = 0,
    PORTALS_CURRENT = 0,
    AMPLIFY_MAGIC = 2,
}

function MageModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Portal controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 40 then
        local unitName = NYCTER_SELECTED_UNIT_NAME
        local portalsCurrent = NCMCompanions[unitName] and NCMCompanions[unitName].Mage and NCMCompanions[unitName].Mage.PORTALS_CURRENT or 0
        local portalsMax = NCMCompanions[unitName] and NCMCompanions[unitName].Mage and NCMCompanions[unitName].Mage.PORTALS_MAX or 0
        local portalColor = portalsCurrent > 0 and "|cFF00FF00" or "|cFFFF0000"
        self.buttons.BOT_OPEN_PORTAL = { text = "|cFF69CCF0Open Portal|r " .. portalColor .. "(" .. portalsCurrent .. "/" .. portalsMax .. ")|r", dist = 0, nested = 1 }
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
    self.buttons.BOT_MAGE_AMPLIFY = { text = "|cFF69CCF0Set Amplify Magic|r", dist = 0, nested = 1 }
    self.menus.BOT_MAGE_AMPLIFY = {}

    local amplifyMagicStatus = NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Mage and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Mage.AMPLIFY_MAGIC or 0

    local function addAmplifyButton(id, text, value, minLevel)
        if NYCTER_SELECTED_UNIT_LEVEL >= minLevel then
            local buttonText = text
            if amplifyMagicStatus == value then
                buttonText = buttonText .. " |cFF00FFFF[x]|r"
            end
            self.buttons[id] = { text = buttonText, dist = 0 }
            self.actions[id] = "set magic " .. string.lower(text)
            table.insert(self.menus.BOT_MAGE_AMPLIFY, id)
        end
    end

    addAmplifyButton("BOT_MAGE_AMPLIFY_USE", "Amplify", 2, 18)
    addAmplifyButton("BOT_MAGE_AMPLIFY_DAMPEN", "Dampen", 1, 12)
    addAmplifyButton("BOT_MAGE_AMPLIFY_NONE", "None", 0, 12)
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
                
                local portalsCurrent = NCMCompanions[unitName] and NCMCompanions[unitName].Mage and NCMCompanions[unitName].Mage.PORTALS_CURRENT or 0
                
                if portalsCurrent <= 0 then
                    StaticPopupDialogs["PORTAL_NO_CHARGES"] = {
                        text = unitName .. " has used all of their available portals. Hire a new mage companion if you want more portals!",
                        button1 = OKAY,
                        timeout = 0,
                        hideOnEscape = 1,
                    }
                    StaticPopup_Show("PORTAL_NO_CHARGES")
                    return true
                end
                
                local function castPortal()
                    SendTargetedBotWhisperCommand(unitName, command)
                    -- Decrement the current portal count
                    if NCMCompanions[unitName] and NCMCompanions[unitName].Mage then
                        NCMCompanions[unitName].Mage.PORTALS_CURRENT = math.max(0, (NCMCompanions[unitName].Mage.PORTALS_CURRENT or 0) - 1)
                    end
                    -- Update the menu to reflect the new portal count
                    self:UpdateMenu(UnitLevel(NYCTER_SELECTED_UNIT))
                end
                -- Check config for confirmation dialog setting
                if NCMCONFIG.CONFIRM_MAGE_PORTALS then
                    StaticPopupDialogs["PORTAL_CONFIRM"] = {
                        text = "Are you sure you want " .. unitName .. " to open a mage portal to " .. portalCity .. "? You have " .. portalsCurrent .. " portal(s) remaining for this hire.",
                        button1 = OKAY,
                        button2 = CANCEL,
                        OnAccept = castPortal,
                        timeout = 0,
                        hideOnEscape = 1,
                    }
                    StaticPopup_Show("PORTAL_CONFIRM")
                else
                    castPortal()
                end
                return true
            end
        elseif string.find(button, "^BOT_MAGE_AMPLIFY_") then
            SendTargetedBotWhisperCommand(unitName, command)
            -- Update AMPLIFY_MAGIC setting
            if NCMCompanions[unitName] and NCMCompanions[unitName].Mage then
                if button == "BOT_MAGE_AMPLIFY_USE" then
                    NCMCompanions[unitName].Mage.AMPLIFY_MAGIC = 2
                elseif button == "BOT_MAGE_AMPLIFY_DAMPEN" then
                    NCMCompanions[unitName].Mage.AMPLIFY_MAGIC = 1
                elseif button == "BOT_MAGE_AMPLIFY_NONE" then
                    NCMCompanions[unitName].Mage.AMPLIFY_MAGIC = 0
                end
            end
            -- Update the menu to reflect the new setting
            self:UpdateMenu(UnitLevel(NYCTER_SELECTED_UNIT))
            return true
        else
            SendTargetedBotWhisperCommand(unitName, command)
            return true
        end
    end
    return false
end
