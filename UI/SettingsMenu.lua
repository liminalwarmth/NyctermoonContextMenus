--[[------------------------------------
    Settings Menu

    TODO:
    - Save and load from file on login/logout
    - Save settings by character AND account (especially important for comp list)
--------------------------------------]]
-- Define the settings structure
local NCMSettings = {
    ["Confirmation Dialogs"] = {
        { id = "CONFIRM_MAGE_PORTALS", label = "|cFF69CCF0[Mage]|r City Portals", type = "bool", value = true, tooltip = "Show a confirmation dialog before casting city portals" },
        { id = "CONFIRM_WARLOCK_SUMMONING", label = "|cFF9482C9[Warlock]|r Ritual of Summoning", type = "bool", value = true, tooltip = "Show a confirmation dialog before performing Ritual of Summoning" },
    },
    ["Auto-Disable on Hire"] = {
        { id = "DISABLE_DANGEROUS_SPELLS", label = "|cFFFFFFFF[All]|r Dangerous Spells", type = "bool", value = true, tooltip = "Automatically attempt to deny spells known to be dangerous in dungeons when a companion joins." },
        { id = "DISABLE_DRUID_REBIRTH", label = "|cFFFF7D0A[Druid]|r Rebirth", type = "bool", value = true, tooltip = "Automatically deny Rebirth (combat resurrection) when hiring a Druid companion" },
        { id = "DISABLE_SHAMAN_REINCARNATE", label = "|cFF0070DE[Shaman]|r Reincarnate", type = "bool", value = true, tooltip = "Automatically deny Reincarnation (self-resurrection) when hiring a Shaman companion" },
        { id = "DISABLE_MAGE_AMPLIFY_MAGIC", label = "|cFF69CCF0[Mage]|r Amplify Magic", type = "bool", value = true, tooltip = "Automatically set Amplify Magic behavior to 'None' when hiring a Mage companion" },
        { id = "DISABLE_STEALTH_PROWL", label = "|cFFFFF569[Rogue]|r or |cFFFF7D0A[Druid]|r Stealth/Prowl", type = "bool", value = true, tooltip = "Automatically deny Stealth/Prowl when hiring a Rogue or Druid companion" },
    },
    ["Addon Information"] = {
        { id = "COMPANION_MESSAGES_VERBOSE", label = "Verbose Companion Messages", type = "bool", value = true, tooltip = "Enable detailed chat window messages about companions joining, leaving, and skill usage." },
    },
}

-- Initialize NCMCONFIG with initial values
NCMCONFIG = {}
for _, group in pairs(NCMSettings) do
    for _, setting in ipairs(group) do
        NCMCONFIG[setting.id] = setting.value
    end
end

-- Function to save NCMCONFIG
local function SaveNCMConfig()
    if not NCMCONFIG.NOSAVE then
        -- Save account-wide settings
        NCMConfig = NCMCONFIG
        
        -- Save window position
        if NCMSettingsFrame then
            NCMConfig.WindowPosition = {
                point = NCMSettingsFrame:GetPoint()
            }
        end
        
        -- Save character-specific companions data
        NCMCompanions = companions
    end
end

-- Function to load NCMCONFIG
local function LoadNCMConfig()
    -- Load account-wide settings
    if NCMConfig then
        for k, v in pairs(NCMConfig) do
            NCMCONFIG[k] = v
        end
        
        -- Restore window position
        if NCMConfig.WindowPosition and NCMSettingsFrame then
            NCMSettingsFrame:ClearAllPoints()
            NCMSettingsFrame:SetPoint(unpack(NCMConfig.WindowPosition))
        end
    end
    
    -- Load character-specific companions data
    if NCMCompanions then
        companions = NCMCompanions
    else
        companions = {}
    end
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
        cb.tooltipText = setting.tooltip
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
            GameTooltip:AddLine(this.tooltipText, 1, 1, 1, true)
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