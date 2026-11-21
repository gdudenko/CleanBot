-- ============================================================
-- Localize.lua  —  Russian (ruRU) pass over CleanBot's own data
-- tables. Loaded last in CleanBot.toc, before PLAYER_LOGIN builds
-- the UI, so every table below is already defined and the values
-- are translated in place.
--
-- Display paths that build a string at runtime (SetText and
-- friends) call NS.CB_L directly; this file only covers plain
-- data tables whose name/desc/header fields are rendered later.
-- Command tokens (cmd/field/group/type/id/frame/icon) are never
-- touched, so the whisper protocol stays in English.
-- ============================================================
local NS = CleanBotNS

if GetLocale() ~= "ruRU" then return end

-- Fields that are safe to translate: everything here is rendered,
-- never compared against a server token or used as a table key.
local DISPLAY_FIELDS = {
    name         = true,
    desc         = true,
    header       = true,
    noneLabel    = true,
    noneDesc     = true,
    title        = true,
    label        = true,
    text         = true,
    tooltipTitle = true,
    tooltipText  = true,
    emptyText    = true,
    emptyLabel   = true,
}

local function walk(t, seen)
    if type(t) ~= "table" or seen[t] then return end
    seen[t] = true
    for k, v in pairs(t) do
        if type(v) == "table" then
            walk(v, seen)
        elseif type(v) == "string" and DISPLAY_FIELDS[k] then
            t[k] = NS.CB_L(v)
        end
    end
end

local seen = {}
local roots = {
    NS.MOVEMENT_STRATEGIES,
    NS.STRATEGIES,
    NS.NC_STRATEGIES,
    NS.CLASS_STRATEGIES,
    NS.CB_actionSlots,
}
for i = 1, #roots do walk(roots[i], seen) end

-- Class names are composed into dropdown labels and flyout titles
-- ("|cff…Warrior|r", "Tank Warrior"), so translate the display map
-- itself. CLASS_STRATEGIES keys remain the English class tokens.
local CLASS_RU = {
    WARRIOR     = "Воин",
    MAGE        = "Маг",
    ROGUE       = "Разбойник",
    DRUID       = "Друид",
    HUNTER      = "Охотник",
    SHAMAN      = "Шаман",
    PRIEST      = "Жрец",
    WARLOCK     = "Чернокнижник",
    PALADIN     = "Паладин",
    DEATHKNIGHT = "Рыцарь смерти",
}
for class, ru in pairs(CLASS_RU) do
    if NS.CLASS_DISPLAY[class] then NS.CLASS_DISPLAY[class] = ru end
end
