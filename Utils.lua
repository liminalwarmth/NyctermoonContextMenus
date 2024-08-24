--[[------------------------------------
    Clean Message of Color Codes
--------------------------------------]]
local function CleanMessage(message)
    return string.gsub(string.gsub(message, "|c%x%x%x%x%x%x%x%x", ""), "|r", "")
end