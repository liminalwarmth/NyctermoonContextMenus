-- Default table of dangerous spells by class
NCMCONFIG.DANGEROUS_SPELLS = {
    ["Druid"] = {},
    ["Hunter"] = {
        {name = "Scare Beast"},
    },
    ["Mage"] = {
        {name = "Blink"},
    },
    ["Paladin"] = {},
    ["Priest"] = {
        {name = "Psychic Scream"},
        {name = "Holy Nova"},
    },
    ["Rogue"] = {},
    ["Shaman"] = {
        {name = "Searing Totem"},
    },
    ["Warlock"] = {
        {name = "Fear"},
        {name = "Howl of Terror"},
    },
    ["Warrior"] = {
        {name = "Intimidating Shout"},
    },
}

-- Function to add a dangerous spell to the table
function AddDangerousSpell(class, spellName)
    if not NCMCONFIG.DANGEROUS_SPELLS[class] then
        NCMCONFIG.DANGEROUS_SPELLS[class] = {}
    end
    
    -- Check if the spell already exists
    for i, spell in ipairs(NCMCONFIG.DANGEROUS_SPELLS[class]) do
        if spell.name == spellName then
            return
        end
    end
    
    -- Add the new spell if it doesn't exist
    table.insert(NCMCONFIG.DANGEROUS_SPELLS[class], {name = spellName})
end

-- Function to remove a dangerous spell from the table
function RemoveDangerousSpell(class, spellName)
    if NCMCONFIG.DANGEROUS_SPELLS[class] then
        for i = 1, table.getn(NCMCONFIG.DANGEROUS_SPELLS[class]) do
            if NCMCONFIG.DANGEROUS_SPELLS[class][i].name == spellName then
                table.remove(NCMCONFIG.DANGEROUS_SPELLS[class], i)
                return true
            end
        end
    end
    return false
end
