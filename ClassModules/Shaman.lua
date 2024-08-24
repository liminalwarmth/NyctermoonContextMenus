ShamanModule = {}
ShamanModule.buttons = {}
ShamanModule.menus = {}
ShamanModule.actions = {}

function ShamanModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Toggle totem control
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        self.buttons.BOT_SHAMAN_TOGGLE_TOTEMS = { text = "|cFF0070DEToggle Totems|r", dist = 0 }
        self.actions.BOT_SHAMAN_TOGGLE_TOTEMS = "toggle totems"
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

    for totemType, totemList in pairs(totems) do
        self.menus["BOT_SHAMAN_" .. string.upper(totemType) .. "_TOTEM"] = {}
        for _, totem in ipairs(totemList) do
            if NYCTER_SELECTED_UNIT_LEVEL >= totem.level then
                self.buttons[totem.id] = { text = totem.name, dist = 0 }
                self.actions[totem.id] = "set totem " .. totem.name .. " Totem"
                table.insert(self.menus["BOT_SHAMAN_" .. string.upper(totemType) .. "_TOTEM"], totem.id)
            end
        end
    end

    -- Clear totem control
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then
        self.buttons.BOT_SHAMAN_CLEAR_TOTEMS = { text = "|cFF0070DEClear Totem Settings|r", dist = 0 }
        self.actions.BOT_SHAMAN_CLEAR_TOTEMS = "set totem cancel"
    end

    -- Reincarnation controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 30 then
        self.buttons.BOT_SHAMAN_REINCARNATION = { text = "|cFF0070DEReincarnation|r", dist = 0, nested = 1 }
        self.buttons.BOT_SHAMAN_REINCARNATION_ALLOW = { text = "|cff1EFF00Allow Self-Resurrection|r", dist = 0 }
        self.buttons.BOT_SHAMAN_REINCARNATION_DENY = { text = "|cffFF0000Deny Self-Resurrection|r", dist = 0 }
        self.actions.BOT_SHAMAN_REINCARNATION_ALLOW = "deny remove reincarnation"
        self.actions.BOT_SHAMAN_REINCARNATION_DENY = "deny add reincarnation"
        self.menus.BOT_SHAMAN_REINCARNATION = { "BOT_SHAMAN_REINCARNATION_ALLOW", "BOT_SHAMAN_REINCARNATION_DENY" }
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
        end
        return true
    end
    return false
end
