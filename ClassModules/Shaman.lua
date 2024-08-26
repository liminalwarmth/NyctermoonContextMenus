ShamanModule = {}
ShamanModule.buttons = {}
ShamanModule.menus = {}
ShamanModule.actions = {}
ShamanModule.menuOrder = {}

NCM_CLASS_DEFAULT_SETTINGS.Shaman = {
    TOTEMS_ENABLED = 1,
    EARTH_TOTEM = "",
    FIRE_TOTEM = "",
    WATER_TOTEM = "",
    AIR_TOTEM = "",
    REINCARNATION = 1,
}

function ShamanModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    self.menuOrder = {}
    
    -- Toggle totem control
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        local totemStatus = NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Shaman and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Shaman.TOTEMS_ENABLED == 1 and "|cFF00FFFFON|r" or "|cFFFF0000OFF|r"
        self.buttons.BOT_SHAMAN_TOGGLE_TOTEMS = { text = "|cFF0070DEToggle Totems: " .. totemStatus, dist = 0 }
        self.actions.BOT_SHAMAN_TOGGLE_TOTEMS = "toggle totems"
        table.insert(self.menuOrder, "BOT_SHAMAN_TOGGLE_TOTEMS")
    end

    -- Totem controls
    self.buttons.BOT_SHAMAN_AIR_TOTEM = { text = "|cFF0070DESet|r |cFFb8bcffAir|r |cFF0070DETotem|r", dist = 0, nested = 1 }
    self.buttons.BOT_SHAMAN_EARTH_TOTEM = { text = "|cFF0070DESet|r |cFF4dd943Earth|r |cFF0070DETotem|r", dist = 0, nested = 1 }
    self.buttons.BOT_SHAMAN_FIRE_TOTEM = { text = "|cFF0070DESet|r |cFFFF4500Fire|r |cFF0070DETotem|r", dist = 0, nested = 1 }
    self.buttons.BOT_SHAMAN_WATER_TOTEM = { text = "|cFF0070DESet|r |cFF34EBD2Water|r |cFF0070DETotem|r", dist = 0, nested = 1 }

    local totems = {
        earth = {
            {level = 4,  id = "BOT_SHAMAN_EARTH_TOTEM_STONESKIN", name = "Stoneskin"},
            {level = 6,  id = "BOT_SHAMAN_EARTH_TOTEM_EARTHBIND", name = "Earthbind"},
            {level = 10, id = "BOT_SHAMAN_EARTH_TOTEM_STRENGTH", name = "Strength of Earth"},
            {level = 18, id = "BOT_SHAMAN_EARTH_TOTEM_TREMOR", name = "Tremor"}
        },
        fire = {
            {level = 10, id = "BOT_SHAMAN_FIRE_TOTEM_SEARING", name = "Searing"},
            {level = 12, id = "BOT_SHAMAN_FIRE_TOTEM_FIRE_NOVA", name = "Fire Nova"},
            {level = 24, id = "BOT_SHAMAN_FIRE_TOTEM_FROST_RESISTANCE", name = "Frost Resistance"},
            {level = 26, id = "BOT_SHAMAN_FIRE_TOTEM_MAGMA", name = "Magma"},
            {level = 28, id = "BOT_SHAMAN_FIRE_TOTEM_FLAMETONGUE", name = "Flametongue"}
        },
        water = {
            {level = 20, id = "BOT_SHAMAN_WATER_TOTEM_HEALING", name = "Healing Stream"},
            {level = 22, id = "BOT_SHAMAN_WATER_TOTEM_POISON_CLEANSING", name = "Poison Cleansing"},
            {level = 26, id = "BOT_SHAMAN_WATER_TOTEM_MANA_SPRING", name = "Mana Spring"},
            {level = 28, id = "BOT_SHAMAN_WATER_TOTEM_FIRE_RESISTANCE", name = "Fire Resistance"},
            {level = 38, id = "BOT_SHAMAN_WATER_TOTEM_DISEASE_CLEANSING", name = "Disease Cleansing"}
        },
        air = {
            {level = 30, id = "BOT_SHAMAN_AIR_TOTEM_NATURE", name = "Nature Resistance"},
            {level = 30, id = "BOT_SHAMAN_AIR_TOTEM_GROUNDING", name = "Grounding"},
            {level = 32, id = "BOT_SHAMAN_AIR_TOTEM_WINDFURY", name = "Windfury"},
            {level = 42, id = "BOT_SHAMAN_AIR_TOTEM_GRACE", name = "Grace of Air"},
            {level = 50, id = "BOT_SHAMAN_AIR_TOTEM_TRANQUIL", name = "Tranquil Air"}
        }
    }

    local elementOrder = {"earth", "fire", "water", "air"}
    for _, element in ipairs(elementOrder) do
        self.menus["BOT_SHAMAN_" .. string.upper(element) .. "_TOTEM"] = {}
        for _, totem in ipairs(totems[element]) do
            if NYCTER_SELECTED_UNIT_LEVEL >= totem.level then
                local buttonText = totem.name
                if NCMCompanions[NYCTER_SELECTED_UNIT_NAME] and NCMCompanions[NYCTER_SELECTED_UNIT_NAME].Shaman[string.upper(element) .. "_TOTEM"] == totem.name then
                    buttonText = buttonText .. " |cFF00FFFF[x]|r"
                end
                self.buttons[totem.id] = { text = buttonText, dist = 0 }
                self.actions[totem.id] = "set totem " .. totem.name .. " Totem"
                table.insert(self.menus["BOT_SHAMAN_" .. string.upper(element) .. "_TOTEM"], totem.id)
            end
        end
        if table.getn(self.menus["BOT_SHAMAN_" .. string.upper(element) .. "_TOTEM"]) > 0 then
            table.insert(self.menuOrder, "BOT_SHAMAN_" .. string.upper(element) .. "_TOTEM")
        end
    end

    -- Clear totem control
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        self.buttons.BOT_SHAMAN_CLEAR_TOTEMS = { text = "|cFF0070DEClear Totem Settings|r", dist = 0 }
        self.actions.BOT_SHAMAN_CLEAR_TOTEMS = "set totem cancel"
        table.insert(self.menuOrder, "BOT_SHAMAN_CLEAR_TOTEMS")
    end

    -- Reincarnation controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 30 then
        self.buttons.BOT_SHAMAN_REINCARNATION = { text = "|cFF0070DEReincarnation|r", dist = 0, nested = 1 }
        self.buttons.BOT_SHAMAN_REINCARNATION_ALLOW = { text = "|cff1EFF00Allow Self-Resurrection|r", dist = 0 }
        self.buttons.BOT_SHAMAN_REINCARNATION_DENY = { text = "|cffFF0000Deny Self-Resurrection|r", dist = 0 }
        self.actions.BOT_SHAMAN_REINCARNATION_ALLOW = "deny remove reincarnation"
        self.actions.BOT_SHAMAN_REINCARNATION_DENY = "deny add reincarnation"
        self.menus.BOT_SHAMAN_REINCARNATION = { "BOT_SHAMAN_REINCARNATION_ALLOW", "BOT_SHAMAN_REINCARNATION_DENY" }
        table.insert(self.menuOrder, "BOT_SHAMAN_REINCARNATION")
    end
end

function ShamanModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        
        if button == "BOT_SHAMAN_TOGGLE_TOTEMS" then
            SendTargetedBotZCommand(NYCTER_SELECTED_UNIT, command)
        else
            SendTargetedBotWhisperCommand(unitName, command)
            
            -- Update totem settings
            if string.find(button, "^BOT_SHAMAN_%w+_TOTEM_") then
                local _, _, totemName = string.find(command, "set totem (.+)")
                if totemName then
                    -- Remove " Totem" from the end of totemName
                    totemName = string.gsub(totemName, " Totem$", "")
                    local _, _, element = string.find(button, "BOT_SHAMAN_(%w+)_TOTEM_")
                    element = string.upper(element)
                    NCMCompanions[unitName].Shaman[element .. "_TOTEM"] = totemName
                end
            elseif button == "BOT_SHAMAN_CLEAR_TOTEMS" then
                NCMCompanions[unitName].Shaman.EARTH_TOTEM = ""
                NCMCompanions[unitName].Shaman.FIRE_TOTEM = ""
                NCMCompanions[unitName].Shaman.WATER_TOTEM = ""
                NCMCompanions[unitName].Shaman.AIR_TOTEM = ""
            end
        end
        return true
    end
    return false
end
