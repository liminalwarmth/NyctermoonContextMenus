-- CompanionData.lua: This file is used to capture the info of companions when they are hired and maintain stored info about them.

-- Table to store the list of companions and data about them
companions = {}

--[[------------------------------------
    Companions Table Data Management
--------------------------------------]]
-- add a companion to the companions table
function AddCompanion(name, rank, class, race, spec, role, owner, master)
    companions[name] = {
        Rank = rank or "N/A",
        Class = class or "N/A",
        Race = race or "N/A",
        Spec = spec or "N/A",
        Role = role or "N/A",
        Owner = owner or "N/A",
        Master = master or "N/A"
    }
    
    local addedCompanion = companions[name]
    local infoString = "Added companion " .. name .. " ("
    infoString = infoString .. (addedCompanion.Rank or "N/A") .. " "
    infoString = infoString .. (addedCompanion.Race or "N/A") .. " "
    infoString = infoString .. (addedCompanion.Class or "N/A") .. ")"
    DEFAULT_CHAT_FRAME:AddMessage(infoString, 1, 0.5, 0)
    
    DisplayCurrentCompanions()
end

-- initialize companions after they are added to the companions table
function InitializeCompanion(name)
    companions[name] = true
end 

-- Function to display current companions
function DisplayCurrentCompanions()
    DEFAULT_CHAT_FRAME:AddMessage("Current companions:", 0, 1, 0)
    for companionName, companionData in pairs(companions) do
        local infoString = companionName .. " ("
        infoString = infoString .. (companionData.Rank or "N/A") .. " "
        infoString = infoString .. (companionData.Race or "N/A") .. " "
        infoString = infoString .. (companionData.Class or "N/A") .. ")"
        DEFAULT_CHAT_FRAME:AddMessage(infoString, 1, 0.5, 0)
    end
end

-- Remove companions from the companions table
function RemoveCompanion(name)
    if companions[name] then
        local removedCompanion = companions[name]
        companions[name] = nil
        if removedCompanion then
            local removedInfo = "Removed companion " .. name .. " ("
            removedInfo = removedInfo .. (removedCompanion.Rank or "N/A") .. " "
            removedInfo = removedInfo .. (removedCompanion.Race or "N/A") .. " "
            removedInfo = removedInfo .. (removedCompanion.Class or "N/A") .. ")"
            DEFAULT_CHAT_FRAME:AddMessage(removedInfo, 1, 0.5, 0)
        end
        DisplayCurrentCompanions()
    else
        DEFAULT_CHAT_FRAME:AddMessage("ERROR: Companion " .. name .. " not found in the companions table...", 1, 0, 0)
    end
end

-- compare the companions table to the who info and update the companions table
function CompareCompanionsToWhoInfo(whoInfo)
    for _, companion in pairs(whoInfo) do
        if companion.name then
            companions[companion.name] = true
        end
    end
end

-- parse the who info and create companions data
function ParseWhoInfo(whoInfo)
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

    -- Print tempCompanions table to chat for debugging
    DEFAULT_CHAT_FRAME:AddMessage("Parsed Companions Data:", 0, 1, 0)
    for name, _ in pairs(tempCompanions) do
        local infoString = "Name: '" .. name .. "', "
        infoString = infoString .. "Rank: '" .. (tempCompanions[name].Rank or "N/A") .. "', "
        infoString = infoString .. "Class: '" .. (tempCompanions[name].Class or "N/A") .. "', "
        infoString = infoString .. "Race: '" .. (tempCompanions[name].Race or "N/A") .. "', "
        infoString = infoString .. "Spec: '" .. (tempCompanions[name].Spec or "N/A") .. "', "
        infoString = infoString .. "Role: '" .. (tempCompanions[name].Role or "N/A") .. "', "
        infoString = infoString .. "Owner: '" .. (tempCompanions[name].Owner or "N/A") .. "', "
        infoString = infoString .. "Master: '" .. (tempCompanions[name].Master or "N/A") .. "'"
        DEFAULT_CHAT_FRAME:AddMessage(infoString, 0, 1, 0)
    end

    -- Update the global companions table
    for name, data in pairs(tempCompanions) do
        companions[name] = data
    end
end

--[[
    Data structure visualization:
    companions = {
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

--[[------------------------------------
    Get Who Info
--------------------------------------]]
function GetWhoInfo()
    -- Create an invisible frame to capture chat messages
    local captureFrame = CreateFrame("Frame")
    captureFrame:Hide()
    
    local originalAddMessage = DEFAULT_CHAT_FRAME.AddMessage
    local capturedInfo = {}
    local capturingInfo = false
    local captureComplete = false
    
    -- Override the AddMessage function to capture who info
    DEFAULT_CHAT_FRAME.AddMessage = function(self, text, r, g, b, id)
        local cleanText = CleanMessage(text)
        if string.find(cleanText, "^%-%-%-%-%-%-%-%-%-%-$") then
            capturingInfo = not capturingInfo
            if not capturingInfo then
                -- Parse the captured info
                ParseWhoInfo(capturedInfo)
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

    -- Check if player is in a raid or party
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

--[[
Structure:
- Invisible frame to capture whispers and system messages
- Listener monitors the frame for events and updates the companions table
- Some actions or commands will trigger a listener queue state so we validate responses
]]--

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
        cleanMessage = source .. " whispers: " .. cleanMessage
    end
    
    local entry = {message = cleanMessage, event = eventType, source = source}
    table.insert(CompanionEventFrame.messageQueue, 1, entry)
    
    if table.getn(CompanionEventFrame.messageQueue) > CompanionEventFrame.maxQueueSize then
        table.remove(CompanionEventFrame.messageQueue)
    end
    -- Debug whisper
    if eventType == "CHAT_MSG_MONSTER_WHISPER" then
        DEFAULT_CHAT_FRAME:AddMessage("Debug: Whisper received from " .. source .. ": " .. cleanMessage, 1, 1, 0)
    end

    -- Every time a message is added to the queue, run our listener to determine actions
    CompanionMessageListener(entry)
end)

--[[------------------------------------
Companion Message Listener
--------------------------------------]]

local function CompanionMessageListener(logEntry)
    local cleanMessage = logEntry.message
    local eventType = logEntry.event
    -- Source only works to identify speaker of whispers (System is other source)
    local source = logEntry.source 
    
    -- Check for companion leaving and remove them from the companions table
    local _, _, leaveName = string.find(cleanMessage, "(%S+) leaves the party%.")
    if not leaveName then
        _, _, leaveName = string.find(cleanMessage, "(%S+) has left the raid group")
    end
    if leaveName and companions[leaveName] then
        RemoveCompanion(leaveName)
        return
    end
    
    -- Check for player joining party or raid
    local _, _, joinName = string.find(cleanMessage, "(%S+) joins the party%.")
    if not joinName then
        _, _, joinName = string.find(cleanMessage, "(%S+) has joined the raid group")
    end
    if joinName then
        -- Check if the player is a companion
        local companionDetected = false
        
        -- Check recent messages for companion detection
        for i = 1, table.getn(CompanionEventFrame.messageQueue) do
            local queueEntry = CompanionEventFrame.messageQueue[i]
            if queueEntry.event == "CHAT_MSG_MONSTER_WHISPER" then
                if string.find(queueEntry.message, "^" .. joinName .. ".*has transferred me to you") then
                    companionDetected = true
                    break
                end
            elseif queueEntry.event == "CHAT_MSG_SYSTEM" then
                if string.find(queueEntry.message, "New Companion hired") or 
                   string.find(queueEntry.message, "New Legacy Companion added") then
                    companionDetected = true
                    break
                elseif string.find(queueEntry.message, "(%S+) joins the party%.") or 
                       string.find(queueEntry.message, "(%S+) has joined the raid group") then
                    break
                end
            end
        end
        
        if companionDetected then
            AddCompanion(joinName)
        end
    end
end