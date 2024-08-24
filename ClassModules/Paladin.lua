PaladinModule = {}
PaladinModule.buttons = {}
PaladinModule.menus = {}
PaladinModule.actions = {}

function PaladinModule:UpdateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    self.buttons = {}
    self.menus = {}
    self.actions = {}
    
    -- Blessing controls
    self.buttons.BOT_PALADIN_BLESSING = { text = "|cFFF58CBASet Blessing|r", dist = 0, nested = 1 }
    self.buttons.BOT_PALADIN_BLESSING_DEFAULT = { text = "AI Default (Clear Setting)", dist = 0 }
    self.buttons.BOT_PALADIN_BLESSING_MIGHT = { text = "Blessing of Might", dist = 0 }
    self.buttons.BOT_PALADIN_BLESSING_WISDOM = { text = "Blessing of Wisdom", dist = 0 }
    self.buttons.BOT_PALADIN_BLESSING_KINGS = { text = "Blessing of Kings", dist = 0 }
    self.buttons.BOT_PALADIN_BLESSING_LIGHT = { text = "Blessing of Light", dist = 0 }
    self.buttons.BOT_PALADIN_BLESSING_SALVATION = { text = "Blessing of Salvation", dist = 0 }
    
    self.actions.BOT_PALADIN_BLESSING_DEFAULT = "set blessing cancel"
    self.actions.BOT_PALADIN_BLESSING_MIGHT = NYCTER_SELECTED_UNIT_LEVEL >= 52 and "set blessing Greater Blessing of Might" or "set blessing Blessing of Might"
    self.actions.BOT_PALADIN_BLESSING_WISDOM = NYCTER_SELECTED_UNIT_LEVEL >= 54 and "set blessing Greater Blessing of Wisdom" or "set blessing Blessing of Wisdom"
    self.actions.BOT_PALADIN_BLESSING_KINGS = NYCTER_SELECTED_UNIT_LEVEL >= 60 and "set blessing Greater Blessing of Kings" or "set blessing Blessing of Kings"
    self.actions.BOT_PALADIN_BLESSING_LIGHT = NYCTER_SELECTED_UNIT_LEVEL >= 60 and "set blessing Greater Blessing of Light" or "set blessing Blessing of Light"
    self.actions.BOT_PALADIN_BLESSING_SALVATION = NYCTER_SELECTED_UNIT_LEVEL >= 56 and "set blessing Greater Blessing of Salvation" or "set blessing Blessing of Salvation"
    
    local blessings = {
        {level = 4,  id = "BOT_PALADIN_BLESSING_MIGHT"},
        {level = 14, id = "BOT_PALADIN_BLESSING_WISDOM"},
        {level = 26, id = "BOT_PALADIN_BLESSING_SALVATION"},
        {level = 40, id = "BOT_PALADIN_BLESSING_LIGHT"},
        {level = 60, id = "BOT_PALADIN_BLESSING_KINGS"}
    }
    
    self.menus.BOT_PALADIN_BLESSING = { "BOT_PALADIN_BLESSING_DEFAULT" }
    for _, blessing in ipairs(blessings) do
        if NYCTER_SELECTED_UNIT_LEVEL >= blessing.level then
            table.insert(self.menus.BOT_PALADIN_BLESSING, blessing.id)
        end
    end
    
    -- Aura controls
    self.buttons.BOT_PALADIN_AURAS = { text = "|cFFF58CBASet Aura|r", dist = 0, nested = 1 }
    self.buttons.BOT_PALADIN_AURAS_DEFAULT = { text = "AI Default (Clear Setting)", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_DEVOTION = { text = "Devotion Aura", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_RETRIBUTION = { text = "Retribution Aura", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_CONCENTRATION = { text = "Concentration Aura", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_SANCTITY = { text = "Sanctity Aura", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_SHADOW_RESISTANCE = { text = "Shadow Resistance Aura", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_FROST_RESISTANCE = { text = "Frost Resistance Aura", dist = 0 }
    self.buttons.BOT_PALADIN_AURA_FIRE_RESISTANCE = { text = "Fire Resistance Aura", dist = 0 }
    
    self.actions.BOT_PALADIN_AURAS_DEFAULT = "set aura cancel"
    self.actions.BOT_PALADIN_AURA_DEVOTION = "set aura Devotion Aura"
    self.actions.BOT_PALADIN_AURA_RETRIBUTION = "set aura Retribution Aura"
    self.actions.BOT_PALADIN_AURA_CONCENTRATION = "set aura Concentration Aura"
    self.actions.BOT_PALADIN_AURA_SANCTITY = "set aura Sanctity Aura"
    self.actions.BOT_PALADIN_AURA_SHADOW_RESISTANCE = "set aura Shadow Resistance Aura"
    self.actions.BOT_PALADIN_AURA_FROST_RESISTANCE = "set aura Frost Resistance Aura"
    self.actions.BOT_PALADIN_AURA_FIRE_RESISTANCE = "set aura Fire Resistance Aura"
    
    local auras = {
        {level = 1,  id = "BOT_PALADIN_AURA_DEVOTION"},
        {level = 16, id = "BOT_PALADIN_AURA_RETRIBUTION"},
        {level = 22, id = "BOT_PALADIN_AURA_CONCENTRATION"},
        {level = 28, id = "BOT_PALADIN_AURA_SHADOW_RESISTANCE"},
        {level = 30, id = "BOT_PALADIN_AURA_SANCTITY"},
        {level = 32, id = "BOT_PALADIN_AURA_FROST_RESISTANCE"},
        {level = 36, id = "BOT_PALADIN_AURA_FIRE_RESISTANCE"}
    }
    
    self.menus.BOT_PALADIN_AURAS = { "BOT_PALADIN_AURAS_DEFAULT" }
    for _, aura in ipairs(auras) do
        if NYCTER_SELECTED_UNIT_LEVEL >= aura.level then
            table.insert(self.menus.BOT_PALADIN_AURAS, aura.id)
        end
    end
end

function PaladinModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT)
    local command = self.actions[button]
    if command then
        local unitName = UnitName(NYCTER_SELECTED_UNIT)
        SendTargetedBotWhisperCommand(unitName, command)
        return true
    end
    return false
end
