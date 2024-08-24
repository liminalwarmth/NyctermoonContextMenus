-- CompanionData.lua: This file is used to capture the info of companions when they are hired and maintain stored info about them.

-- Table to store the list of companions and their classes
companions = {}
--[[------------------------------------
    Add Companion and Get Who Info
--------------------------------------]]
function AddCompanionAndGetInfo(name)
    companions[name] = true
    
    -- Create an invisible frame to capture chat messages
    local captureFrame = CreateFrame("Frame")
    captureFrame:Hide()
    
    local originalAddMessage = DEFAULT_CHAT_FRAME.AddMessage
    local capturedInfo = {}
    local capturingInfo = false
    
    -- Override the AddMessage function to capture companion info
    DEFAULT_CHAT_FRAME.AddMessage = function(self, text, r, g, b, id)
        local cleanText = CleanMessage(text)
        if string.find(cleanText, "^%-%-%-%-%-%-%-%-%-%-$") then
            capturingInfo = not capturingInfo
            if not capturingInfo then
                -- End of companion info, process captured info if needed
                -- For now, we'll just print it to demonstrate
                DEFAULT_CHAT_FRAME:AddMessage("Captured Companion Info for " .. name .. ":", 0, 1, 0)
                for i = 1, table.getn(capturedInfo) do
                    DEFAULT_CHAT_FRAME:AddMessage(capturedInfo[i], 0, 1, 0)
                end
                capturedInfo = {}
            end
        elseif capturingInfo then
            table.insert(capturedInfo, cleanText)
        else
            originalAddMessage(self, text, r, g, b, id)
        end
    end
end

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
                    else
                        -- Display the whisper that didn't match
                        DEFAULT_CHAT_FRAME:AddMessage("Not a match: " .. logEntry.message, 1, 0.5, 0)  -- Orange text for debugging
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
                AddCompanionAndGetInfo(name)
                
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