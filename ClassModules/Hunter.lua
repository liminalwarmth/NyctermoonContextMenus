HunterModule = {}

-- Button definitions
HunterModule.Buttons = {
    -- Pet controls
    ["BOT_PET_TOGGLE"] = { text = "|cFFABD473Pet Control|r", dist = 0, nested = 1 },
    ["BOT_PET_ON"] = { text = "|cff1EFF00Summon Pet|r", dist = 0 },
    ["BOT_PET_OFF"] = { text = "|cffFF0000Dismiss Pet|r", dist = 0 },

    -- Pet selection
    ["BOT_HUNTER_PET"] = { text = "|cFFABD473Choose Beast|r", dist = 0, nested = 1 },
    ["BOT_HUNTER_PET_BAT"] = { text = "|cFFFF7D0ABat|r", dist = 0 },
    ["BOT_HUNTER_PET_BEAR"] = { text = "|cFF0070DEBear|r", dist = 0 },
    ["BOT_HUNTER_PET_BOAR"] = { text = "|cFF0070DEBoar|r |cFFFFFFFF(Charge)|r", dist = 0 },
    ["BOT_HUNTER_PET_BIRD"] = { text = "|cFFFFF569Carrion Bird|r", dist = 0 },
    ["BOT_HUNTER_PET_CAT"] = { text = "|cFFFF7D0ACat|r |cFFFFFFFF(Prowl)|r", dist = 0 },
    ["BOT_HUNTER_PET_CRAB"] = { text = "|cFF0070DECrab|r", dist = 0 },
    ["BOT_HUNTER_PET_CROC"] = { text = "|cFF0070DECrocolisk|r", dist = 0 },
    ["BOT_HUNTER_PET_GORILLA"] = { text = "|cFF0070DEGorilla|r |cFFFFFFFF(Thunderstomp)|r", dist = 0 },
    ["BOT_HUNTER_PET_HYENA"] = { text = "|cFFFFF569Hyena|r", dist = 0 },
    ["BOT_HUNTER_PET_OWL"] = { text = "|cFFFF7D0AOwl|r", dist = 0 },
    ["BOT_HUNTER_PET_RAPTOR"] = { text = "|cFFFF7D0ARaptor|r", dist = 0 },
    ["BOT_HUNTER_PET_SCORPID"] = { text = "|cFF0070DEScorpid|r |cFFFFFFFF(Scorpid Poison)|r", dist = 0 },
    ["BOT_HUNTER_PET_SPIDER"] = { text = "|cFFFF7D0ASpider|r", dist = 0 },
    ["BOT_HUNTER_PET_STRIDER"] = { text = "|cFF0070DETallstrider|r", dist = 0 },
    ["BOT_HUNTER_PET_TURTLE"] = { text = "|cFF0070DETurtle|r |cFFFFFFFF(Shell Shield)|r", dist = 0 },
    ["BOT_HUNTER_PET_SERPENT"] = { text = "|cFFFF7D0AWind Serpent|r |cFFFFFFFF(Lightning Breath)|r", dist = 0 },
    ["BOT_HUNTER_PET_WOLF"] = { text = "|cFFFFF569Wolf|r |cFFFFFFFF(Furious Howl)|r", dist = 0 },

    -- Aspect controls
    ["BOT_HUNTER_ASPECT"] = { text = "|cFFABD473Set Aspect|r", dist = 0, nested = 1 },
    ["BOT_HUNTER_ASPECT_DEFAULT"] = { text = "AI Default (Clear Setting)", dist = 0 },
    ["BOT_HUNTER_ASPECT_HAWK"] = { text = "Aspect of the Hawk", dist = 0 },
    ["BOT_HUNTER_ASPECT_CHEETAH"] = { text = "Aspect of the Cheetah", dist = 0 },
    ["BOT_HUNTER_ASPECT_PACK"] = { text = "Aspect of the Pack", dist = 0 },
    ["BOT_HUNTER_ASPECT_WILD"] = { text = "Aspect of the Wild", dist = 0 },
}

-- Menu creation function
function HunterModule:CreateMenu(NYCTER_SELECTED_UNIT_LEVEL)
    local menus = {}
    
    -- Pet controls
    if NYCTER_SELECTED_UNIT_LEVEL >= 10 then -- Hunters get pets at level 10
        menus["BOT_PET_TOGGLE"] = { "BOT_PET_ON", "BOT_PET_OFF" }
        menus["BOT_HUNTER_PET"] = {
            "BOT_HUNTER_PET_BAT", "BOT_HUNTER_PET_BEAR", "BOT_HUNTER_PET_BOAR", "BOT_HUNTER_PET_BIRD",
            "BOT_HUNTER_PET_CAT", "BOT_HUNTER_PET_CRAB", "BOT_HUNTER_PET_CROC", "BOT_HUNTER_PET_GORILLA",
            "BOT_HUNTER_PET_HYENA", "BOT_HUNTER_PET_OWL", "BOT_HUNTER_PET_RAPTOR", "BOT_HUNTER_PET_SCORPID",
            "BOT_HUNTER_PET_SPIDER", "BOT_HUNTER_PET_STRIDER", "BOT_HUNTER_PET_TURTLE", "BOT_HUNTER_PET_SERPENT",
            "BOT_HUNTER_PET_WOLF"
        }
    end

    -- Aspect controls
    local aspects = {
        {level = 10, id = "BOT_HUNTER_ASPECT_HAWK"},
        {level = 20, id = "BOT_HUNTER_ASPECT_CHEETAH"},
        {level = 40, id = "BOT_HUNTER_ASPECT_PACK"},
        {level = 46, id = "BOT_HUNTER_ASPECT_WILD"}
    }
    local aspectItems = {}
    for i = 1, table.getn(aspects) do
        if NYCTER_SELECTED_UNIT_LEVEL >= aspects[i].level then
            table.insert(aspectItems, aspects[i].id)
        end
    end
    if table.getn(aspectItems) > 0 then
        table.insert(aspectItems, 1, "BOT_HUNTER_ASPECT_DEFAULT")
        menus["BOT_HUNTER_ASPECT"] = aspectItems
    end
    
    return menus
end

-- Button click handlers
function HunterModule:HandleButtonClick(button, NYCTER_SELECTED_UNIT_NAME)
    -- Pet controls
    if button == "BOT_PET_ON" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet on")
    elseif button == "BOT_PET_OFF" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet off")
    
    -- Pet selection
    elseif string.find(button, "^BOT_HUNTER_PET_") then
        local _, _, petType = string.find(button, "^BOT_HUNTER_PET_(.+)$")
        if petType then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set pet " .. string.lower(petType))
        end
    
    -- Aspect controls
    elseif button == "BOT_HUNTER_ASPECT_DEFAULT" then
        SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect cancel")
    elseif string.find(button, "^BOT_HUNTER_ASPECT_") then
        local _, _, aspectType = string.find(button, "^BOT_HUNTER_ASPECT_(.+)$")
        if aspectType then
            SendTargetedBotWhisperCommand(NYCTER_SELECTED_UNIT_NAME, "set aspect Aspect of the " .. aspectType)
        end
    end
end
