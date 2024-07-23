# Nyctermoon Context Menus - WoW Vanilla (1.12.1) AddOn

This addon adds right-click context menu items to control the utility behaviors and settings for your Companion Bot party members on the Nyctermoon private server. It is not intended to be a replacement for the Companion Control Panel that is distributed with the server files, but rather a complement to it. Common companion toggle commands, role assignment, and spell cast requests can be accessed from these context menus for quick and easy use.

It also adds some Nyctermoon-specific informational commands and settings that can be accessed by right-clicking the player frame. All features enabled by this addon can also be performed manually with the .z, .legacy, .settings, and companion whisper commands described on the [Nyctermoon Wiki](http://nyctermoon.wikidot.com/).

### Features

- View Nyctermoon-specific XP bonus and Legacy info
- Swap between Normal and Heroic dungeon difficulty settings and reset instances
- Change Companion role and toggle helm/cloak display
- Cast useful companion class spells from a right-click context menu:
  - Open Mage Portals to major cities (faction-specific)
  - Ask Warlocks to Summon party members
  - Easily set and change Shaman Totems and Paladin Buffs/Auras
  - Choose Hunter and Warlock pets, and summon or dismiss them as needed
  - Toggle stealth on and off for Rogues and Druids
- Dynamic menu options: class skills and role toggles will only appear on the menus when you can actually use them
- Native pfUI support.

### Usage

Right click on your player frame to see the Player Menu commands, and right click on a party or raid member to see the Companion Menu commands.

### Known Issues

- Custom bot commands will appear on players AND bots because I'm not aware of a way to tell them apart programmatically. The commands won't have any effect on real players (other than maybe annoying them).
- Using some of the commands sometimes will change or remove your current target, so don't use them in combat. (This is necessary to ensure that the proper companion gets the command and not your whole group if there's some server lag).

## Player Menu Commands

Right click on your player frame to see the Player Menu commands.

### Nyctermoon Stats

Shortcuts for common commands to see character, group, or account-wide Legacy information.

- **Legacy Overview**: Shows your account Legacy info (equivalent to the ".legacy" command).
- **Current XP Bonus**: Shows your current character's XP bonus (equivalent to the ".stats misc" command).
- **Companion Info**: Shows info about your current group companions (equivalent to ".z who" command).

### Dungeon Settings

- **Set Difficulty: Normal**: Sets your dungeon difficulty to Normal. (Standard Loot and Enemy settings in instances)
- **Set Difficulty: Heroic**: Sets your dungeon difficulty to Heroic. (+100% XP and Loot, 1.5X Enemy damage and health in instances)
- **Reset all instances**: Resets all of your active instances. (Max 5 resets per hour, same as using "/script ResetInstances()")

## Companion Menu Commands

Right click on a party or raid member (in either the group/raid or your target frame) to see the Companion Menu commands available for that character.

### Companion Settings

General settings that apply to all companions.

- **Toggle AoE/Helm/Cloak**: Toggles companion AoE, helm, or cloak setting (all classes).
- **Set Role**: Sets the companion's role. Will dynamically display the roles available based on the companion's class. Will not display for classes that only have one role available.

### Mage

- **Open Portal**: Will ask your mage to open a portal to any of the major cities of their character faction, provided they are high enough level to do so.
- **Deny Danger Spells**

### Shaman

- **Set Earth Totem**: Ask your shaman to use only this Earth Totem.
- **Set Fire Totem**: Ask your shaman to use only this Fire Totem.
- **Set Water Totem**: Ask your shaman to use only this Water Totem.
- **Set Air Totem**: Ask your shaman to use only this Air Totem.
- **Clear Totems**: Reset all of your custom totem settings.

### Paladin

- **Set Blessing**: Ask your paladin to use only this Blessing. Dynamically upgrades to the Greater version when available.
- **Set Aura**: Ask your paladin to use this Aura.

### Warlock

- **Choose Demon**: Select the demon you want your warlock to use (Imp, Felhunter, Voidwalker, or Succubus).
- **Pet Control**: Ask your Warlock to summon or dismiss their pet.
- **Summon Player**: Ask your Warlock to summon your current targeted player to your location. There is a confirmation window prior to summoning, and the player must be in your group or raid. After using this command, you must ask your companions to help finish the summoning ritual with the ".z use" command unless you have other players who will click the portal.
- **Deny Danger Spells**

### Hunter

- **Choose Beast**: Select the beast type you want your hunter to use (all Beast families are available from the dropdown).
- **Pet Control**: Ask your Hunter to summon or dismiss their pet.

### Rogue and Druid

- **Toggle Stealth**: Ask your Rogue or Druid to turn their Stealth (or Prowl) ability on or off. Turning it off will prevent them from stealthing until your turn it back on.

### Priest and Warrior

- **Deny Danger Spells**

### Deny Danger Spells

You can click this command to automatically deny dangerous spells that people often don't want their companions to use. It will only appear if your companion has the spells.

- **Priest**: Psychic Scream and Holy Nova
- **Mage**: Blink
- **Warlock**: Fear and Howl of Terror
- **Warrior**: Intimidating Shout

### Set CC and Focus Marks

These menus allow you to set a companion's crowd control and focus targets by assigning them a specific raid icon as described on the [Nyctermoon Wiki page for Behavior .z commands](http://nyctermoon.wikidot.com/zcommands#toc19).

- **Set CC Mark**: Sets the companion's CC mark. This companion will attempt to keep all enemies with this raid icon crowd controlled.
- **Set Focus Mark**: Sets the companion's focus mark. This companion will focus their damage and attacks exclusively on living enemies with this raid icon and ignore other targets.
