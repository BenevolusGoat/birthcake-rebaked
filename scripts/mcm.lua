local mod = Birthcake

local setting = {}
local IsaacSettings = {
    cycleChance = 0.25,
}
local IsaacBSettings = {
    excludeChance = 0.25,
    destroyChance = 0.50,
}

if ModConfigMenu == nil then
    return
end

ModConfigMenu.AddSetting(
    "Birthcake Tweaks",
    "Isaac Birthcake",
    {
        Type = ModConfigMenu.OptionType.SCROLL,
        CurrentSetting = function()
            return IsaacSettings.cycleChance
        end,
        Display = function()
            return "Cycle Chance: $scroll" .. tostring(IsaacSettings.cycleChance)
        end,
        OnChange = function(value)
            IsaacSettings.cycleChance = value
        end,
        Info = { "E" }
    }
)