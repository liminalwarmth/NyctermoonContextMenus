--[[------------------------------------
    Send Z Commands (Bot Targeted)
--------------------------------------]]
function SendTargetedBotZCommand(unit, command)
    -- Target the bot whose command we want to send
    TargetUnit(unit)
    -- Use a non-blocking delay mechanism to let the target go through (c_timer does not work, less than a second misses them sometimes)
    local delayTime = 1.0
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function()
        delayTime = delayTime - arg1
        if delayTime <= 0 then
            local chatType = "SAY"
            if UnitInRaid("player") then
                chatType = "RAID"
            elseif GetNumPartyMembers() > 0 then
                chatType = "PARTY"
            end
            SendChatMessage(".z " .. command, chatType)
            frame:SetScript("OnUpdate", nil)
        end
    end)
end

--[[------------------------------------
    Send Whisper Commands to Bot
--------------------------------------]]
function SendTargetedBotWhisperCommand(name, command)
    SendChatMessage(command, "WHISPER", nil, name)
end

--[[------------------------------------
    Send Whisper Commands to Entire Party/Raid
--------------------------------------]]

function SendCommandToAll(message)
    local numMembers = 0
    local getNameFunc
    local playerName = UnitName("player")
    
    if UnitInRaid("player") then
        numMembers = GetNumRaidMembers()
        getNameFunc = function(i) 
            local name = GetRaidRosterInfo(i)
            return name
        end
    elseif GetNumPartyMembers() > 0 then
        numMembers = GetNumPartyMembers()
        getNameFunc = function(i) return UnitName("party"..i) end
    else
        DEFAULT_CHAT_FRAME:AddMessage("You are not in a party or raid.")
        return
    end

    for i = 1, numMembers do
        local name = getNameFunc(i)
        if name and name ~= playerName then
            SendChatMessage(message, "WHISPER", GetDefaultLanguage("player"), name)
        end
    end
end

-- Create a StaticPopupDialog for the text input
StaticPopupDialogs["SEND_COMMAND_TO_ALL"] = {
    text = "Enter a command to whisper to all raid/party members:",
    button1 = "Send",
    button2 = "Cancel",
    OnAccept = function()
        local editBox = getglobal(this:GetParent():GetName().."EditBox")
        local message = editBox:GetText()
        SendCommandToAll(message)
        editBox:SetText("")
    end,
    OnShow = function()
        local editBox = getglobal(this:GetName().."EditBox")
        editBox:SetText("")
        editBox:SetScript("OnEnterPressed", function()
            local message = this:GetText()
            SendCommandToAll(message)
            this:SetText("")
            StaticPopup_Hide("SEND_COMMAND_TO_ALL")
        end)
    end,
    OnHide = function()
        local editBox = getglobal(this:GetName().."EditBox")
        editBox:SetScript("OnEnterPressed", nil)
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    hasEditBox = true,
    editBoxWidth = 400,
}

--[[------------------------------------
    Define Class Colors for Addon
--------------------------------------]]
CLASS_COLORS = {
    ["WARRIOR"] = "cFFC79C6E",
    ["MAGE"]    = "cFF69CCF0",
    ["ROGUE"]   = "cFFFFF569",
    ["DRUID"]   = "cFFFF7D0A",
    ["HUNTER"]  = "cFFABD473",
    ["SHAMAN"]  = "cFF0070DE",
    ["PRIEST"]  = "cFFFFFFA0",  -- Slightly yellow-tinted
    ["WARLOCK"] = "cFF9482C9",
    ["PALADIN"] = "cFFF58CBA"
}
function getUnitClassColor(unit)
    local _, class = UnitClass(unit)
    return CLASS_COLORS[string.upper(class)] or "cFFFFFFFF"  -- Default to white if class not found
end

--[[------------------------------------
    Define Raid Group for Unit
--------------------------------------]]
function GetUnitRaidGroup(unit)
    if UnitInRaid(unit) then
        for i = 1, 40 do
            local name, _, subgroup = GetRaidRosterInfo(i)
            if name == UnitName(unit) then
                return subgroup
            end
        end
    end
    return nil
end

--[[------------------------------------
    Clean Message of Color Codes
--------------------------------------]]
function CleanMessage(message)
    return string.gsub(string.gsub(message, "|c%x%x%x%x%x%x%x%x", ""), "|r", "")
end

--[[------------------------------------
    Get Local Group Members and Build Menu Buttons
--------------------------------------]]
function GetLocalGroupMembers(unit, includePlayer, includeTarget, buttonPrefix)
    local members = {}
    local menuItems = {}
    local playerName = UnitName("player")
    local targetName = UnitName(unit)
    local isInRaid = UnitInRaid("player")
    local unitGroup = GetUnitRaidGroup(unit)

    if includePlayer then
        local playerColorCode = getUnitClassColor("player")
        table.insert(members, {name = playerName, colorCode = playerColorCode, isPlayer = true})
    end

    if isInRaid then
        -- In a raid, add members of the unit's group
        for i = 1, 40 do
            local name, _, subgroup = GetRaidRosterInfo(i)
            if name and subgroup == unitGroup and (includeTarget or name ~= targetName) and name ~= playerName then
                local colorCode = getUnitClassColor("raid"..i)
                table.insert(members, {name = name, colorCode = colorCode, isPlayer = false})
            end
        end
    else
        -- In a party, add all party members
        for i = 1, GetNumPartyMembers() do
            local partyUnit = "party"..i
            local name = GetUnitName(partyUnit)
            if name and (includeTarget or name ~= targetName) and name ~= playerName then
                local colorCode = getUnitClassColor(partyUnit)
                table.insert(members, {name = name, colorCode = colorCode, isPlayer = false})
            end
        end
    end

    -- Build menu items for each member
    for _, member in ipairs(members) do
        local buttonName = buttonPrefix .. "_" .. member.name
        local displayText = "|" .. member.colorCode .. member.name .. "|r"
        if member.isPlayer then
            displayText = displayText .. " (Me)"
        end
        UnitPopupButtons[buttonName] = { text = displayText, dist = 0 }
        table.insert(menuItems, buttonName)
    end

    return menuItems
end