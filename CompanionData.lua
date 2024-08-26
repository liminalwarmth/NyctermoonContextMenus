-- CompanionData.lua: This file is used to capture the info of companions when they are hired and maintain stored info about them.

-- Table to store the list of companions and data about them
NCMCompanions = NCMCompanions or {}

--[[------------------------------------
    Companions Table Data Management
--------------------------------------]]
-- add a companion to the NCMCompanions table
function AddCompanion(name, rank, class, race, spec, role, owner, master)
    NCMCompanions[name] = {
        Rank = rank or "N/A",
        Class = class or "N/A",
        Race = race or "N/A",
        Spec = spec or "N/A",
        Role = role or "N/A",
        Owner = owner or "N/A",
        Master = master or "N/A"
    }

    -- Schedule the initialization of the companion after 0.5 seconds
    AddNCMTimer("InitializeCompanion_" .. name, 0.5, InitializeCompanion, 10, name)
end

-- Remove companions from the NCMCompanions table
function RemoveCompanion(name)
    if NCMCompanions[name] then
        local removedCompanion = NCMCompanions[name]
        local unitID = removedCompanion.UnitID
        NCMCompanions[name] = nil
        local coloredName = "|" .. (removedCompanion.ClassColor or "cFFFFFFFF") .. name .. "|r"
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            local removedInfo = "|cFFFFAA00Companion departed: [|r" .. coloredName .. "|cFFFFAA00]|r "
            removedInfo = removedInfo .. "[|cff1EFF00" .. (removedCompanion.Rank or "N/A") .. "|r] "
            removedInfo = removedInfo .. "(|cFF87CEFA" .. "L." .. (removedCompanion.Level or "??") .. "|r "
            removedInfo = removedInfo .. (removedCompanion.Race or "N/A") .. " "
            removedInfo = removedInfo .. (removedCompanion.Class or "N/A") .. ")"
            DEFAULT_CHAT_FRAME:AddMessage(removedInfo, 1, 1, 1)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFAA00Companion departed: [|r" .. coloredName .. "|cFFFFAA00]|r", 1, 1, 1)
        end
    end
end

-- Function to display current companions
function DisplayCurrentCompanions()
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFAA00Current Companions:|r", 1, 1, 1)
    for companionName, companionData in pairs(NCMCompanions) do
        local coloredName = "|" .. (companionData.ClassColor or "cFFFFFFFF") .. companionName .. "|r"
        local infoString = "|cFFFFFFFF" .. coloredName .. " "
        infoString = infoString .. "[|cff1EFF00" .. (companionData.Rank or "N/A") .. "|r] "
        infoString = infoString .. "(|cFF87CEFA" .. "L." .. (companionData.Level or "??") .. "|r "
        infoString = infoString .. (companionData.Race or "N/A") .. " "
        infoString = infoString .. (companionData.Class or "N/A") .. ")"
        if companionData.Owner then
            infoString = infoString .. " [Owner: " .. companionData.Owner .. "]"
        end
        DEFAULT_CHAT_FRAME:AddMessage(infoString, 1, 1, 1)
    end
end


--[[------------------------------------
    Companion Initialization
--------------------------------------]]
-- Runs on companions after they are added to the NCMCompanions table to handle initial settings
function InitializeCompanion(name)
    -- Get and update the companion's level and unit reference
    local companionUnit = nil
    local companionLevel = nil
    
    -- Get the unit ID for the companion
    local unitID = GetUnitID(name)
    
    if unitID then
        companionUnit = unitID
        companionLevel = UnitLevel(unitID)
    end
    -- Create new entries for UnitID, Level, and ClassColor in the companion's data
    if companionUnit and companionLevel then
        NCMCompanions[name].UnitID = companionUnit
        NCMCompanions[name].Level = companionLevel
        NCMCompanions[name].ClassColor = getUnitClassColor(companionUnit)
        -- Initialize universal companion settings
        NCMCompanions[name].HelmVisible = 1
        NCMCompanions[name].CloakVisible = 1
        NCMCompanions[name].AoeEnabled = 1
        -- Initialize class-specific settings
        NCMCompanions[name].ClassSettings = {}
        
        -- Display the companion's info in chat
        local addedCompanion = NCMCompanions[name]
        local coloredName = "|" .. (addedCompanion.ClassColor or "cFFFFFFFF") .. name .. "|r"
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            local infoString = "|cFFFFAA00Companion arrived: [|r" .. coloredName .. "|cFFFFAA00]|r "
            infoString = infoString .. "[|cff1EFF00" .. (addedCompanion.Rank or "N/A") .. "|r] "
            infoString = infoString .. "(|cFF87CEFA" .. "L." .. (addedCompanion.Level or "??") .. "|r "
            infoString = infoString .. (addedCompanion.Race or "N/A") .. " "
            infoString = infoString .. (addedCompanion.Class or "N/A") .. ")"
            DEFAULT_CHAT_FRAME:AddMessage(infoString, 1, 1, 1)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFAA00Companion arrived: [|r" .. coloredName .. "|cFFFFAA00]|r", 1, 1, 1)
        end

        -- Initialize class settings for the companion
        InitializeClassSettings(name)
        
        return true
    else
        -- If unit and level are not present, return false to retry
        return false
    end
end

--  1,2,3,4,5,10 for T0D,T1R,T2R,T3R,T4R,T5R
-- Initialize class settings for companions
function InitializeClassSettings(name)
    local companion = NCMCompanions[name]
    if not companion then return end
    local coloredName = "|" .. companion.ClassColor .. name .. "|r"

    -- Initialize the values for the class settings based on template defaults for their class
    companion[companion.Class] = {}
    for key, value in pairs(NCM_CLASS_DEFAULT_SETTINGS[companion.Class]) do
        companion[companion.Class][key] = value
    end
    
    -- Set max and current portals/summons based on rank
    local portalCounts = {
        T0D = 1, T0R = 1,
        T1D = 2, T1R = 2,
        T2D = 3, T2R = 3,
        T3D = 4, T3R = 4,
        T4D = 5, T4R = 5,
        T5D = 10, T5R = 10
    }

    -- Special handling for Mage portals
    if companion.Class == "Mage" and companion.Level >= 40 then     
        companion.Mage.PORTALS_MAX = portalCounts[companion.Rank] or 0
        companion.Mage.PORTALS_CURRENT = companion.Mage.PORTALS_MAX
        -- Report the number of portals available
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            local currentPortals = companion.Mage.PORTALS_CURRENT == 0 and "|cFFFF0000" .. companion.Mage.PORTALS_CURRENT .. "|r" or "|cff1EFF00" .. companion.Mage.PORTALS_CURRENT .. "|r"
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Portals available: " .. currentPortals .. "/" .. companion.Mage.PORTALS_MAX, 1, 0.67, 0)
        end
    end
    

    -- Special handling for Warlock summoning
    if companion.Class == "Warlock" and companion.Level >= 20 then     
        companion.Warlock.SUMMONS_MAX = portalCounts[companion.Rank] or 0
        companion.Warlock.SUMMONS_CURRENT = companion.Warlock.SUMMONS_MAX
        -- Report the number of summons available
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            local currentSummons = companion.Warlock.SUMMONS_CURRENT == 0 and "|cFFFF0000" .. companion.Warlock.SUMMONS_CURRENT .. "|r" or "|cff1EFF00" .. companion.Warlock.SUMMONS_CURRENT .. "|r"
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Summons available: " .. currentSummons .. "/" .. companion.Warlock.SUMMONS_MAX, 1, 0.67, 0)
        end
    end

    -- Check for auto-disable settings and take action
    if companion.Class == "Druid" and NCMCONFIG.DISABLE_DRUID_REBIRTH == 1 then
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Auto-disabling combat resurrection...", 1, 0.67, 0)
        end
        SendTargetedBotWhisperCommand(name, "deny add rebirth")
        companion.Druid.REBIRTH = 0
    end

    if companion.Class == "Shaman" and NCMCONFIG.DISABLE_SHAMAN_REINCARNATE == 1 then
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Auto-disabling self resurrection...", 1, 0.67, 0)
        end
        SendTargetedBotWhisperCommand(name, "deny add reincarnation")
        companion.Shaman.REINCARNATION = 0
    end

    if companion.Class == "Mage" and NCMCONFIG.DISABLE_MAGE_AMPLIFY_MAGIC == 1 then
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Auto-disabling amplify magic...", 1, 0.67, 0)
        end
        SendTargetedBotWhisperCommand(name, "set magic none")
        companion.Mage.AMPLIFY_MAGIC = 0
    end

    if companion.Class == "Rogue" and NCMCONFIG.DISABLE_STEALTH_PROWL == 1 then
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Auto-disabling stealth...", 1, 0.67, 0)
        end
        SendTargetedBotWhisperCommand(name, "deny add stealth")
        companion.Rogue.STEALTH = 0
    elseif companion.Class == "Druid" and NCMCONFIG.DISABLE_STEALTH_PROWL == 1 then
        if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
            DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Auto-disabling stealth...", 1, 0.67, 0)
        end
        SendTargetedBotWhisperCommand(name, "deny add prowl")
        companion.Druid.PROWL = 0
    end

    if NCMCONFIG.DISABLE_DANGEROUS_SPELLS == 1 then
        if NCMCONFIG.DANGEROUS_SPELLS[companion.Class] and table.getn(NCMCONFIG.DANGEROUS_SPELLS[companion.Class]) > 0 then
            if NCMCONFIG.COMPANION_MESSAGES_VERBOSE == 1 then
                DEFAULT_CHAT_FRAME:AddMessage("[" .. coloredName .. "] Auto-disabling dangerous spells...", 1, 0.67, 0)
            end
            for _, spell in ipairs(NCMCONFIG.DANGEROUS_SPELLS[companion.Class]) do
                SendTargetedBotWhisperCommand(name, "deny add " .. spell.name)
            end
        end
    end
end

--[[------------------------------------
    .z Who Companions Scan and Build
--------------------------------------]]
--[[
    Data structure visualization:
    NCMCompanions = {
        [CompanionName1] = {
            Rank = string,
            Class = string,
            Race = string,
            Spec = string,
            Role = string,
            Owner = string,
            Master = string
        },
        [CompanionName2] = {
            -- Same structure as CompanionName1
        },
        -- More companions...
    }
]]
-- Takes raw text of scanned .z who info and creates current companions temporary data table, compares to existing table and updates it
function UpdateWithZWhoInfo(whoInfo)
    local tempCompanions = {}
    local currentCompanion = nil

    for _, line in ipairs(whoInfo) do
        local _, _, number, name = string.find(line, "^(%d+)%. %[([^%]]+)%]")
        if number and name then
            currentCompanion = name
            tempCompanions[currentCompanion] = {}

            local _, _, rank, class, race, spec, role = string.find(line, ":(%w+) %- (%w+) (%w+) %- ([^-]+) %- (.+)$")
            if rank and class and race and spec and role then
                tempCompanions[currentCompanion].Rank = rank
                tempCompanions[currentCompanion].Class = class
                tempCompanions[currentCompanion].Race = race
                tempCompanions[currentCompanion].Spec = string.gsub(spec, "^%s*(.-)%s*$", "%1")
                tempCompanions[currentCompanion].Role = string.gsub(role, "^%s*(.-)%s*$", "%1")
            end
        elseif currentCompanion then
            local _, _, owner, master = string.find(line, "O:%[([^%]]+)%] M:%[([^%]]+)%]")
            if owner and master then
                tempCompanions[currentCompanion].Owner = owner
                tempCompanions[currentCompanion].Master = master
            end
        end
    end

    -- Update the global NCMCompanions table
    for name, data in pairs(tempCompanions) do
        if not NCMCompanions[name] then
            AddCompanion(name, data.Rank, data.Class, data.Race, data.Spec, data.Role, data.Owner, data.Master)
        else
            -- Update specific fields for existing companions
            NCMCompanions[name].Rank = data.Rank
            NCMCompanions[name].Class = data.Class
            NCMCompanions[name].Race = data.Race
            NCMCompanions[name].Spec = data.Spec
            NCMCompanions[name].Role = data.Role
            NCMCompanions[name].Owner = data.Owner
        end
    end

    -- Remove companions that are not in the tempCompanions table (needed to fix any out of state data)
    local companionsToRemove = {}
    for name, _ in pairs(NCMCompanions) do
        if not tempCompanions[name] then
            table.insert(companionsToRemove, name)
        end
    end

    for _, name in ipairs(companionsToRemove) do
        RemoveCompanion(name)
    end
end

-- Does an invisible .z who scan and returns a current companions data structure
function ZWhoCompanionsScan()
    -- Create an invisible frame to capture chat messages
    local captureFrame = CreateFrame("Frame")
    captureFrame:Hide()
    
    local originalAddMessage = DEFAULT_CHAT_FRAME.AddMessage
    local capturedInfo = {}
    local capturingInfo = false
    local captureComplete = false
    
    --[[
    This has bugs. Data can look like this:
    ----------
    [Tim] Dungeon:None Raid:T4R
    
    1. [Bob]:T0D - Mage Human - Frost - Range DPS
    O:[Raelyn] M:[Tim] P:[None]
    ----------
    [Redbank] Dungeon:None Raid:None
    ----------
    [Raelyn] Dungeon:None Raid:T4R
    
    1. [Farrell]:T0D - Mage Human - Frost - Range DPS
    O:[Raelyn] M:[Raelyn] P:[None]
    ----------
    [Cody] Dungeon:None Raid:None
    ----------

    --]]
    -- Override the AddMessage function to capture who info
    DEFAULT_CHAT_FRAME.AddMessage = function(self, text, r, g, b, id)
        local cleanText = CleanMessage(text)
        if string.find(cleanText, "^%-%-%-%-%-%-%-%-%-%-$") then
            capturingInfo = not capturingInfo
            if not capturingInfo then
                -- Parse and update companions table with the captured info
                UpdateWithZWhoInfo(capturedInfo)
                -- Clear the captured info
                capturedInfo = {}
                -- Restore original AddMessage function
                DEFAULT_CHAT_FRAME.AddMessage = originalAddMessage
                captureComplete = true
            end
        elseif capturingInfo then
            table.insert(capturedInfo, cleanText)
        else
            originalAddMessage(self, text, r, g, b, id)
        end
    end

    -- Check if player is in a raid or party and send the .z who message
    if UnitInRaid("player") then
        SendChatMessage(".z who", "RAID")
    elseif UnitInParty("player") then
        SendChatMessage(".z who", "PARTY")
    else
        -- Print an error message if not in raid or party
        DEFAULT_CHAT_FRAME:AddMessage("Error getting who info! You are not in a raid or party.", 1, 0, 0)
    end

    -- If we haven't restored the original AddMessage function after 5 seconds, restore it and display an error message only if capture is not complete
    local timer = CreateFrame("Frame")
    timer:SetScript("OnUpdate", function()
        this.elapsed = (this.elapsed or 0) + arg1
        if this.elapsed >= 5 then
            timer:SetScript("OnUpdate", nil)
            if not captureComplete then
                DEFAULT_CHAT_FRAME.AddMessage = originalAddMessage
                DEFAULT_CHAT_FRAME:AddMessage("Error: Failed to properly log who info. Captured data:", 1, 0, 0)
                for i = 1, table.getn(capturedInfo) do
                    DEFAULT_CHAT_FRAME:AddMessage(capturedInfo[i], 0, 1, 0)
                end
            end
        end
    end)
end

--[[------------------------------------
Companion Message Listener
--------------------------------------]]

function CompanionMessageListener(logEntry)
    local cleanMessage = logEntry.message
    local eventType = logEntry.event
    -- Source only works to identify speaker of whispers (System is other source)
    local source = logEntry.source 
    
    -- Check for companion leaving and schedule their removal from the companions table
    local _, _, leaveName = string.find(cleanMessage, "(%S+) leaves the party%.")
    if not leaveName then
        _, _, leaveName = string.find(cleanMessage, "(%S+) has left the raid group")
    end
    if leaveName and NCMCompanions[leaveName] then
        -- Schedule the removal of the companion after .5 second
        AddNCMTimer("RemoveCompanion_" .. leaveName, .5, RemoveCompanion, 3, leaveName)
        return
    end
    
    -- Check for player joining party or raid
    local joinParty = string.find(cleanMessage, "(%S+) joins the party%.")
    local joinRaid = string.find(cleanMessage, "(%S+) has joined the raid group")
    
    if joinParty or joinRaid then
        -- Perform a ZWho scan when any player joins to update the companions table with all current companions
        ZWhoCompanionsScan()
    end

    -- Check for helm, cloak, and AoE toggle messages
    local _, _, companionName, toggleItem = string.find(cleanMessage, "%[(%S+)%] has toggled their (%S+)%.")
    if companionName and toggleItem and NCMCompanions[companionName] then
        if toggleItem == "Helm" then
            NCMCompanions[companionName].HelmVisible = 1 - NCMCompanions[companionName].HelmVisible
        elseif toggleItem == "Cloak" then
            NCMCompanions[companionName].CloakVisible = 1 - NCMCompanions[companionName].CloakVisible
        end
    end

    local _, _, companionName = string.find(cleanMessage, "%[(%S+)%] will only use Single%-Target spells%.")
    if companionName and NCMCompanions[companionName] then
        NCMCompanions[companionName].AoeEnabled = 0
    end

    local _, _, companionName = string.find(cleanMessage, "%[(%S+)%] is allowed to use Area%-of%-Effect spells%.")
    if companionName and NCMCompanions[companionName] then
        NCMCompanions[companionName].AoeEnabled = 1
    end

    -- Check for role change messages
    local _, _, companionName, newRole = string.find(cleanMessage, "%[(%S+)%] is set to (%S+%s?%S*)%.")
    if companionName and newRole and NCMCompanions[companionName] then
        -- Map the role string to a standardized format
        local roleMap = {
            ["Healer"] = "Healer",
            ["Tank"] = "Tank",
            ["Melee DPS"] = "Melee DPS",
            ["Ranged DPS"] = "Range DPS"
        }
        local standardizedRole = roleMap[newRole]
        if standardizedRole then
            NCMCompanions[companionName].Role = standardizedRole
        end
    end

    -- Check for shaman totem toggle messages
    local _, _, companionName, totemState = string.find(cleanMessage, "%[(%S+)%] has toggled Totems %[(%w+)%]")
    if companionName and totemState and NCMCompanions[companionName] and NCMCompanions[companionName].Class == "Shaman" then
        if totemState == "ON" then
            NCMCompanions[companionName].Shaman.TOTEMS_ENABLED = 1
        elseif totemState == "OFF" then
            NCMCompanions[companionName].Shaman.TOTEMS_ENABLED = 0
        end
    end
end

--[[------------------------------------
Companion Event Frame for Message Captures
--------------------------------------]]
CompanionEventFrame = CreateFrame("Frame")
CompanionEventFrame.messageQueue = {}
CompanionEventFrame.maxQueueSize = 30

CompanionEventFrame:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
CompanionEventFrame:RegisterEvent("CHAT_MSG_SYSTEM")

CompanionEventFrame:SetScript("OnEvent", function()
    local message = arg1
    local eventType = event
    local source = "System"
    
    local cleanMessage = CleanMessage(message)
    
    if eventType == "CHAT_MSG_MONSTER_WHISPER" then
        source = arg2 or "Unknown"
    end
    
    local entry = {message = cleanMessage, event = eventType, source = source}
    table.insert(CompanionEventFrame.messageQueue, 1, entry)
    
    if table.getn(CompanionEventFrame.messageQueue) > CompanionEventFrame.maxQueueSize then
        table.remove(CompanionEventFrame.messageQueue)
    end

    -- Every time a message is added to the queue, run our listener to determine actions
    CompanionMessageListener(entry)
end)