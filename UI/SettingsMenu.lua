-- Displays Settings Menu for NCM
local CheckBoxTables = {
    ["Context Menu Settings"] = {
        [0] = "NCMSettingsCheckboxGroup",
        [1] = { "NCMSettingsCheckbox01", "Enable Context Menus" },
        [2] = { "NCMSettingsCheckbox02", "Show Keybinds" },
        [3] = { "NCMSettingsCheckbox03", "Auto-hide Menu" }
    },
    ["Dummy Menu"] = {
        [0] = "DummyMenuCheckboxGroup",
        [1] = { "DummyMenuCheckbox21", "Option 1" },
        [2] = { "DummyMenuCheckbox22", "Option 2" },
        [3] = { "DummyMenuCheckbox23", "Option 3" },
        [4] = { "DummyMenuCheckbox24", "Option 4" },
        [5] = { "DummyMenuCheckbox25", "Option 5" },
        [6] = { "DummyMenuCheckbox26", "Option 6" },
        [7] = { "DummyMenuCheckbox27", "Option 7" },
        [8] = { "DummyMenuCheckbox28", "Option 8" },
        [9] = { "DummyMenuCheckbox29", "Option 9" },
        [10] = { "DummyMenuCheckbox30", "Option 10" }
    },
    ["Menu Customization"] = {
        [0] = "MenuCustomizationCheckboxGroup",
        [1] = { "MenuCustomizationCheckbox41", "Custom Colors" },
        [2] = { "MenuCustomizationCheckbox42", "Transparent Background" },
        [3] = { "MenuCustomizationCheckbox43", "Large Font" }
    }
}

local function CheckBoxGroup(hParent, offsetX, offsetY, sTitle, tCheck)
    local frame = CreateFrame("Frame", tCheck[0], hParent)
    frame:SetPoint("TOPLEFT", hParent, "TOPLEFT", offsetX, offsetY)
    frame:SetWidth(11)
    frame:SetHeight(11)

    local fs_title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    fs_title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    fs_title:SetTextColor(1, 1, 1, 1)
    fs_title:SetText(sTitle)

    frame.fs_title = fs_title
    frame.cb = {}

    for k,v in ipairs(tCheck) do
        local cb = CreateFrame("CheckButton", v[1], frame, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 8, -(4+(k-1)*14))
        cb:SetWidth(16)
        cb:SetHeight(16)
        
        if v[2] then cb.tooltipTitle = v[2] end
        if v[3] then cb.tooltipText = v[3] end

        local num = tonumber(string.sub(v[1], -2))

        cb:SetScript("OnShow", function()
            NCM_GetSetting(num)
        end)
        cb:SetScript("OnClick", function()
            NCM_SetSetting(num)
        end)
        cb:SetScript("OnEnter", function()
            if this.tooltipTitle then
                GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
                GameTooltip:SetBackdropColor(.01, .01, .01, .91)
                GameTooltip:SetText(this.tooltipTitle)
                if this.tooltipText then
                    GameTooltip:AddLine(this.tooltipText, 1, 1, 1)
                end
                GameTooltip:Show()
            end
        end)
        cb:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        frame.cb[k] = cb
    end

    return frame
end

function NCM_CreateSettingsFrame()
    local frame = CreateFrame("Frame", "NCMSettingsFrame")
    tinsert(UISpecialFrames,"NCMSettingsFrame")
    frame:SetScale(.81)

    frame:SetWidth(480)
    frame:SetHeight(428)
    
    frame:SetPoint("TOPLEFT", nil, "TOPLEFT", 250, -50)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
        tile = true, 
        tileSize = 32, 
        edgeSize = 32, 
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(.01, .01, .01, .91)

    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(false)
    frame:RegisterForDrag("LeftButton")
    frame:Hide()
    frame:SetScript("OnMouseDown", function()
        if arg1 == "LeftButton" and not this.isMoving then
            this:StartMoving()
            this.isMoving = true
        end
    end)
    frame:SetScript("OnMouseUp", function()
        if arg1 == "LeftButton" and this.isMoving then
            this:StopMovingOrSizing()
            this.isMoving = false
        end
    end)
    frame:SetScript("OnHide", function()
        if this.isMoving then
            this:StopMovingOrSizing()
            this.isMoving = false
        end
    end)

    local texture_title = frame:CreateTexture("NCMSettingsFrameTitle")
    texture_title:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    texture_title:SetWidth(266)
    texture_title:SetHeight(58)
    texture_title:SetPoint("CENTER", frame, "TOP", 0, -20)

    frame.texture_title = texture_title

    local fs_title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    fs_title:SetPoint("CENTER", frame.texture_title, "CENTER", 0, 12)
    fs_title:SetText("NCM Settings")

    frame.fs_title = fs_title

    local btn_close = CreateFrame("Button", "NCMSettingsFrameCloseButton", frame, "UIPanelCloseButton")
    btn_close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -12)
    btn_close:SetWidth(32)
    btn_close:SetHeight(32)
    
    frame.btn_close = btn_close

    frame.btn_close:SetScript("OnClick", function()
        this:GetParent():Hide()
    end)
    
    local yOffset = -45 -- Start below the title
    local groupOrder = {}
    for groupName, _ in pairs(CheckBoxTables) do
        table.insert(groupOrder, groupName)
    end
    table.sort(groupOrder) -- Sort the group names alphabetically
    for i = 1, table.getn(groupOrder) do
        local groupName = groupOrder[i]
        local groupData = CheckBoxTables[groupName]
        local groupKey = "cbgroup_" .. string.lower(string.gsub(groupName, "%s+", ""))
        

        frame[groupKey] = CheckBoxGroup(frame, 20, yOffset, groupName, groupData)
        
        -- Calculate the height of the current group
        local groupHeight = 14 * table.getn(groupData)  -- 14 pixels per option
        
        -- Update yOffset for the next group
        yOffset = yOffset - groupHeight - 20
    end

    return frame
end

-- Define NCMStrings table
NCMStrings = {}
for _, groupData in pairs(CheckBoxTables) do
    for i = 1, table.getn(groupData) do
        local checkboxData = groupData[i]
        if checkboxData and checkboxData[2] then
            local num = tonumber(string.sub(checkboxData[1], -2))
            NCMStrings[num] = checkboxData[2]
        end
    end
end

-- Define NCMObjects table
NCMObjects = {}

-- Define NCMCONFIG table with default values
NCMCONFIG = {
    ENABLED = true,
    SHOWKEYBINDS = true,
    AUTOHIDE = false,
    CUSTOMCOLORS = false,
    TRANSPARENT = false,
    LARGEFONT = false
}

-- Function to save NCMCONFIG
local function SaveNCMConfig()
    if not NCMCONFIG.NOSAVE then
        NCMConfig = NCMCONFIG
    end
end

-- Function to load NCMCONFIG
local function LoadNCMConfig()
    if NCMConfig then
        for k, v in pairs(NCMConfig) do
            NCMCONFIG[k] = v
        end
    end
end

-- Call LoadNCMConfig when the addon loads
LoadNCMConfig()

-- Hook the original NCM_SetSetting function
local original_NCM_SetSetting = NCM_SetSetting
NCM_SetSetting = function(num)
    original_NCM_SetSetting(num)
    SaveNCMConfig()
end

function NCM_GetSetting(num)
    local labelString = getglobal(this:GetName().."Text")
    local label = NCMStrings[num] or ""
    NCMObjects[num] = this

    if num == 01 and NCMCONFIG.ENABLED
    or num == 02 and NCMCONFIG.SHOWKEYBINDS
    or num == 03 and NCMCONFIG.AUTOHIDE
    or num == 11 and NCMCONFIG.CUSTOMCOLORS
    or num == 12 and NCMCONFIG.TRANSPARENT
    or num == 13 and NCMCONFIG.LARGEFONT
    or nil then
        this:SetChecked(true)
    else
        this:SetChecked(nil)
    end
    labelString:SetText(label)
end

function NCM_SetSetting(num)
    local checked = this:GetChecked()
    if num == 01 then
        NCMCONFIG.ENABLED = checked
    elseif num == 02 then
        NCMCONFIG.SHOWKEYBINDS = checked
    elseif num == 03 then
        NCMCONFIG.AUTOHIDE = checked
    elseif num == 11 then
        NCMCONFIG.CUSTOMCOLORS = checked
    elseif num == 12 then
        NCMCONFIG.TRANSPARENT = checked
    elseif num == 13 then
        NCMCONFIG.LARGEFONT = checked
    end
end
