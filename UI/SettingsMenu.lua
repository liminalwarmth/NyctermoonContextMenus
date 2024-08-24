-- Define the settings structure
local NCMSettings = {
    ["Confirmation Dialogs"] = {
        { id = "CONFIRM_MAGE_PORTALS", label = "Mage Portals", type = "bool", default = true },
        { id = "CONFIRM_WARLOCK_SUMMONING", label = "Warlock Summoning", type = "bool", default = true },
    },
    ["Auto-Disable on Hire"] = {
        { id = "DISABLE_DANGEROUS_SPELLS", label = "Dangerous Spells", type = "bool", default = true },
        { id = "DISABLE_DRUID_REBIRTH", label = "Druid Rebirth", type = "bool", default = true },
        { id = "DISABLE_SHAMAN_REINCARNATE", label = "Shaman Reincarnate", type = "bool", default = true },
        { id = "DISABLE_MAGE_AMPLIFY_MAGIC", label = "Mage Amplify Magic", type = "bool", default = false },
        { id = "DISABLE_STEALTH_PROWL", label = "Stealth/Prowl", type = "bool", default = false },
    },
    -- Add more groups and settings as needed
}

-- Initialize NCMCONFIG with default values
NCMCONFIG = {}
for _, group in pairs(NCMSettings) do
    for _, setting in ipairs(group) do
        NCMCONFIG[setting.id] = setting.default
    end
end

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

-- Global function to get a setting value by ID
function NCMConfig_GetSetting(settingId)
    if NCMCONFIG and NCMCONFIG[settingId] ~= nil then
        return NCMCONFIG[settingId]
    else
        -- Return the default value if the setting is not found
        for _, group in pairs(NCMSettings) do
            for _, setting in ipairs(group) do
                if setting.id == settingId then
                    return setting.default
                end
            end
        end
    end
    return nil -- Return nil if the setting is not found at all
end

-- Call LoadNCMConfig when the addon loads
LoadNCMConfig()

-- Function to create checkbox groups
local function CreateCheckBoxGroup(parent, offsetX, offsetY, groupName, settings)
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", offsetX, offsetY)
    frame:SetWidth(11)
    frame:SetHeight(11)

    local fs_title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    fs_title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    fs_title:SetTextColor(1, 1, 1, 1)
    fs_title:SetText(groupName)

    frame.fs_title = fs_title
    frame.cb = {}

    for i, setting in ipairs(settings) do
        local cb = CreateFrame("CheckButton", "NCMSettingsCheckbox"..setting.id, frame, "UICheckButtonTemplate")
        cb:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 8, -(4+(i-1)*14))
        cb:SetWidth(16)
        cb:SetHeight(16)
        
        cb.tooltipTitle = setting.label
        cb.settingId = setting.id

        cb:SetScript("OnShow", function()
            local checked = NCMCONFIG[this.settingId]
            this:SetChecked(checked)
            getglobal(this:GetName().."Text"):SetText(this.tooltipTitle)
        end)
        cb:SetScript("OnClick", function()
            NCMCONFIG[this.settingId] = this:GetChecked()
            SaveNCMConfig()
        end)
        cb:SetScript("OnEnter", function()
            GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT")
            GameTooltip:SetBackdropColor(.01, .01, .01, .91)
            GameTooltip:SetText(this.tooltipTitle)
            GameTooltip:Show()
        end)
        cb:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        frame.cb[i] = cb
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
    
    -- Create a temporary table to store the groups
    local tempGroups = {}
    for groupName, groupSettings in pairs(NCMSettings) do
        table.insert(tempGroups, {name = groupName, settings = groupSettings})
    end
    
    -- Reverse the order of the groups
    for i = table.getn(tempGroups), 1, -1 do
        local group = tempGroups[i]
        local groupName = group.name
        local groupSettings = group.settings
        
        local groupKey = "cbgroup_" .. string.lower(string.gsub(groupName, "%s+", ""))
        
        frame[groupKey] = CreateCheckBoxGroup(frame, 20, yOffset, groupName, groupSettings)
        
        -- Calculate the height of the current group
        local groupHeight = 14 * table.getn(groupSettings)  -- 14 pixels per option
        
        -- Update yOffset for the next group
        yOffset = yOffset - groupHeight - 20
    end

    return frame
end