-- CompanionData.lua: This file is used to capture the info of companions when they are hired and maintain stored info about them.

-- Table to store the list of companions and data about them
companions = {}

--[[------------------------------------
    Companions Table Data Management
--------------------------------------]]
-- add a companion to the companions table
function AddCompanion(name)
    companions[name] = true
end

-- initialize companions after they are added to the companions table
function InitializeCompanion(name)
    companions[name] = true
end 

-- remove companions from the companions table
function RemoveCompanion(name)
    companions[name] = nil
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
Captured format:

[Cian] Dungeon:None Raid:None
 
1. [Gazryklite]:T0D - Shaman Orc - Default - Melee DPS
O:[Gazryk] M:[Cian] P:[None]
 
2. [Raelynlite]:T0D - Priest Human - Default - Range DPS
O:[Raelyn] M:[Cian] P:[None]
 
3. [Ribble]:T3R - Mage Gnome - Arcane - Range DPS
O:[Raelyn] M:[Cian] P:[None]
]]--

--[[------------------------------------
Detect New Companions and Companion Messages
--------------------------------------]]
-- Create a frame to handle events
eventFrame = CreateFrame("Frame")

-- Register for all relevant chat events
eventFrame:RegisterEvent("CHAT_MSG_MONSTER_WHISPER")
eventFrame:RegisterEvent("CHAT_MSG_SYSTEM")

-- Table to store the last 20 messages and their event types
messageLog = {}

-- Set up the event handler
eventFrame:SetScript("OnEvent", function()
    -- Get the message content and event type
    local message = arg1
    local eventType = event
    
    -- Clean the current message
    local cleanMessage = CleanMessage(message)
    
    -- Add the new message to the log
    if eventType == "CHAT_MSG_MONSTER_WHISPER" then
        local monsterName = arg2 or "Unknown"
        cleanMessage = monsterName .. " whispers: " .. cleanMessage
    end
    table.insert(messageLog, 1, {message = cleanMessage, event = eventType})
    
    -- Keep only the last 20 messages
    if table.getn(messageLog) > 20 then
        table.remove(messageLog)
    end
    
    if eventType == "CHAT_MSG_SYSTEM" then
        -- Check if it's a player leaving the party or raid
        local _, _, leaveName = string.find(cleanMessage, "(%S+) leaves the party%.")
        if not leaveName then
            _, _, leaveName = string.find(cleanMessage, "(%S+) has left the raid group")
        end
        
        if leaveName and companions[leaveName] then
            companions[leaveName] = nil
            DEFAULT_CHAT_FRAME:AddMessage("Removed companion " .. leaveName .. " from the companions table", 1, 0.5, 0)
            -- List the current companions
            DEFAULT_CHAT_FRAME:AddMessage("Current companions:", 0, 1, 0)
            for companionName, _ in pairs(companions) do
                DEFAULT_CHAT_FRAME:AddMessage("- " .. companionName, 0, 1, 0)
            end
        end
        
        -- Check if it's a player joining the party or raid
        local _, _, name = string.find(cleanMessage, "(%S+) joins the party%.")
        if not name then
            _, _, name = string.find(cleanMessage, "(%S+) has joined the raid group")
        end
        
        if name then
            local companionDetected = false
            
            -- Check whispers first
            for i = 2, table.getn(messageLog) do
                local logEntry = messageLog[i]
                if logEntry.event == "CHAT_MSG_MONSTER_WHISPER" then
                    if string.find(logEntry.message, "^" .. name .. ".*has transferred me to you") then
                        companionDetected = true
                        break
                    end
                end
            end
            
            -- If companion not detected in whispers, check system messages
            if not companionDetected then
                for i = 2, table.getn(messageLog) do
                    local logEntry = messageLog[i]
                    if logEntry.event == "CHAT_MSG_SYSTEM" then
                        if string.find(logEntry.message, "New Companion hired") or 
                           string.find(logEntry.message, "New Legacy Companion added") then
                            companionDetected = true
                            break
                        elseif string.find(logEntry.message, "(%S+) joins the party%.") or 
                               string.find(logEntry.message, "(%S+) has joined the raid group") then
                            break  -- Stop checking if we encounter another join message
                        end
                    end
                end
            end
            
            if companionDetected then
                -- Add the companion and get their info
                -- AddCompanionAndGetInfo(name)
                GetWhoInfo()
                
                DEFAULT_CHAT_FRAME:AddMessage("Added companion " .. name .. " to the companions table", 0, 1, 0)
                -- List the current companions
                DEFAULT_CHAT_FRAME:AddMessage("Current companions:", 0, 1, 0)
                for companionName, _ in pairs(companions) do
                    DEFAULT_CHAT_FRAME:AddMessage("- " .. companionName, 0, 1, 0)
                end
            end
        end
    end
end)