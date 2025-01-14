local json = require("json")
Birthcake = RegisterMod("birthcake",1)
local mod = Birthcake
local BirthcakeLocals = {}
local game = Game()

TrinketType.TRINKET_BIRTHCAKE = Isaac.GetTrinketIdByName("Birthcake")
Challenge.CHALLENGE_BIRTHDAY_PARTY = Isaac.GetChallengeIdByName("Isaac's birthday party")
SoundEffect.SOUND_PARTY_HORN = Isaac.GetSoundIdByName("Party Horn")

mod.BirthcakeDescs = {
    [0] = "Better rolls"; -- Isaac
    [21] = "Danger = Space";

    [1] = "Healing power"; -- Magdalene
    [22] = "Heart attack";

    [2] = "Sleight of hand"; -- Cain
    [23] = "Repurpose";

    [3] = "Sinner's guard"; -- Judas
    [12] = "Sinner's guard"; -- Black Judas
    [24] = "Aftermath";

    [4] = "Loose Bowels"; -- ???
    [25] = "Sturdy turds";

    [5] = "Pain for pleasure"; -- Eve
    [26] = "Saignant";

    [6] = "Healing rage"; -- Samson
    [27] = "Unending rampage";

    [7] = "Alternative attack"; -- Azazel
    [28] = "Allergy up";

    [8] = "Come down with me"; -- Lazarus
    [11] = "Come down with me"; -- Lazarus 2
    [29] = "A gift from the other side";
    [38] = "A gift from the other side";

    [9] = "Mystery flavor"; -- Eden
    [30] = "Undecided";

    [10] = "Regained power"; -- The Lost
    [31] = "Small fortune at cost";

    [13] = "Remember to share"; -- Lillith
    [32] = "I ask for your help";

    [14] = "Spare change"; -- Keeper
    [33] = "Local business";

    [15] = "Snack time"; -- Apollyon
    [34] = "Harvest";

    [16] = "Harmony of body and soul"; -- The Forgotten
    [17] = "Harmony of body and soul"; -- The Soul
    [35] = "Spectral protection";
    [40] = "Spectral protection";

    [18] = "Virtuous Guidance"; -- Bethany
    [36] = "Desire fullfilled";

    [19] = "Stronger than you"; -- Jacob
    [20] = "Stronger than you"; -- Esau
    [37] = "Uneasy truce";
    [39] = "Uneasy truce";
}

mod.TrinketDesc = {
    ----- Isaac -----
    [0] = 
    {
        ["Normal"] = "When rerolling, items have a 25% chance to cycle back and forth between their new and original form";
    };
    [21] = 
    {
        ["Normal"] = "Getting hit while having no empty item slot has a 25% chance to permanently exclude a random item from occupying an invetory slot #The trinket has a 50% chance to disappear if this occurs";
    };
    ----- Magdalene -----
    [1] = 
    {
        ["Normal"] = "Higher chance for red hearts to be replaced by double red hearts # {{HalfSoulHeart}} Yum heart refills half soul heart upon use";
        ["Upgraded"] = "Higher chance for red hearts to be replaced by double red hearts # {{SoulHeart}} Yum heart refills {{ColorGold}}one {{ColorText}}soul heart upon use"
    };
    [22] = 
    {
        ["Normal"] = "Uncollected red hearts dropped from enemies create small blood explosions when they disappear, damaging nearby enemies";
    };
    ----- Cain -----
    [2] =
    {
        ["Normal"] = "↑ +1 Luck# Interacting with machines has a 33% chance to not consume coins# The chance is reduced to 25% for the crane game"; 
        ["Upgraded"] = "↑ +1 Luck# Interacting with machines has a {{ColorGold}}50{{ColorText}}% chance to not consume coins# The chance is reduced to {{ColorGold}}33{{ColorText}}% for the crane game";
    };
    [23] = 
    {
        ["Normal"] = "Double pickups spawn as two individual pickups instead #Putting a pickup in the bag has a 5% chance to add it to your inventory";
    };
    ----- Judas -----
    [3] = 
    {
        ["Normal"] = "↑ +{{DamageUp}} damage #Grants +1 black heart when selling all of your red health to a devil deal";
        ["Upgraded"] = "↑ +{{ColorGold}}{{DamageUp}}{{ColorText}} damage #Grants +1 black heart when selling all of your red health to a devil deal"
    };
    [24] =
    {
        ["Normal"] = "Enemies marked by dark arts are slowed down after the attack is executed";
    };
    ----- Blue Baby -----
    [4] = 
    {
        ["Normal"] = "Active items spawn number of active item charges - 1 poops upon use # Each poop has a 10% chance to be replaced by tainted ???'s corn poop";
        ["Mom's Box"] = "Active items spawn number of active item charges - 1 poops upon use # Each poop has a {{ColorGold}}20{{ColorText}}% chance to be replaced by tainted ???'s corn poop";
        ["+Golden"] = "# {{ColorGold}}50% chance for spawned poop to be golden {{ColorText}}";
        ["+{{Trinket"..TrinketType.TRINKET_MECONIUM.."}}"] = "# {{Trinket".. TrinketType.TRINKET_MECONIUM .."}} {{ColorGray}}Poops spawned have a chance to be black poop"
    };
    [25] = 
    {
        ["Normal"] = "Thrown poops are resistant to enemy projectiles #Enemies can go through poops, but are heavily slowed down when doing so";
    };
    ----- Eve -----
    [5] = 
    {
        ["Normal"] = "Prioritizes Eve's red health when taking damage #Losing red health doesn't affect devil/angel deal chances if eve has at least one soul heart";
        ["Upgraded"] = "Prioritizes Eve's red health when taking damage #Losing red health doesn't affect devil/angel deal chances if eve has at least one soul heart # {{ColorGold}}Also replace bone hearts behind soul hearts when taking damage";
    };
    [26] = 
    {
        ["Normal"] = "Spawns 2 clots at a time at the cost of draining twice as much health # Clots leave damaging creep upon death";
    };
    ----- Samson -----
    [6] = 
    {
        ["Normal"] = "Drops 2 red hearts when full rage is reached";
        ["Upgraded"] = "Drop {{ColorGold}}2 hearts based on on your current health{{ColorText}} when full rage is reached";
        ["+Birthright"] = "# {{Collectible".. CollectibleType.COLLECTIBLE_BIRTHRIGHT .."}} {{ColorGray}}Also drop 2 hearts when 6 rage is reached";
    };
    [27] =
    {
        ["Normal"] = "While in berserk mode, has a chance to spawn a random hearts and extends berserk mode for 5 seconds";
    };
    ----- Azazel -----
    [7] = 
    {
        ["Normal"] = "Holding a fire button while brimstone is fully charged allows azazel to shoot regular tears # Azazel's tears only deal 50% damage but have twice the range";
    };
    [28] = 
    {
        ["Normal"] = "When Azazel sneeze on enemies they get poisoned #Azazel also receives knockback when sneezing";
    };
    ---- Lazarus -----
    [8] = 
    {
        ["Normal"] = "Upon revival, deals 40 damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
        ["Upgraded"] = "Upon revival, deals {{ColorGold}}{{Chance40}}{{ColorText}} damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
    };
    [11] = 
    {
        ["Normal"] = "Upon revival, deals 40 damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
        ["Upgraded"] = "Upon revival, deals {{ColorGold}}{{Chance40}}{{ColorText}} damage to all enemies in the room # When Lazarus Risen revert back to Lazarus, he also get back his lost heart container";
    };
    [29] = 
    {
        ["Normal"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room";
        ["Upgraded"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room # {{ColorGold}}Prevents Quality {{Quality0}} items from being shared {{ColorText}}"
    };
    [38] = 
    {
        ["Normal"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room";
        ["Upgraded"] = "Upon entering a new room, the form holding the trinket gains a random item from the other form for the duration of the room # {{ColorGold}}Prevents Quality {{Quality0}} items from being shared {{ColorText}}"
    };
    ----- Eden -----
    [9] = 
    {
        ["Normal"] = "";
    };
    [30] = 
    {
        ["Normal"] = "Pedestal items have a chance to either become glitched or turn into items from different item pools";
    };
    ----- The lost -----
    [10] = 
    {
        ["Normal"] = "While holding the Eternal D6, grants 2 guaranteed rerolls per floor that don't require any charges # If the lost is not holding the Eternal D6, he instead gains one free use of his active item per floor";
    };
    [31] = 
    {
        ["Normal"] = "Has a 50% chance to spawn an extra item when encountering an item pedestal # If this occurs, the trinket has a 25% chance to self-destrcut, dealing 100 damage to all enemies in the room and removing your mantle in the process";
    };
    ---- Lillith ----
    [13] = 
    {
        ["Normal"] = "Familiars have a 25% chance to copy lillith's tear effects # At the start of each floor has a 10% chance to consume the trinket and spawn a demon familiar # If it happens the cake has 25% chance to replace any future trinket";
    };
    [32] = 
    {
        ["Normal"] = "Spawn Incubus every other room and Succubus the room between that one # When entering a boss fight, spawn both Incubus and Succubus"; -- KAULIANPOWER
    };
    ----- Keeper -----
    [14] = 
    {
        ["Normal"] = "Grants a nickel when entering a shop, a black market or a devil room";
        ["Upgraded"] = "Grants a {{ColorGold}}golden penny{{ColorText}} when entering a shop, a black market or a devil room"
    };
    [33] = 
    {
        ["Normal"] = "Spawns an item and 2 pickups for sale in the starting room of each floor";
    };
    ---- Apollyon -----
    [15] = 
    {
        ["Normal"] = "Allows void to consume trinkets on the ground # While holding void, you gain the effects of all consumed trinkets";
    };
    [34] = 
    {
        ["Normal"] = "Allows abyss to consume trinkets on the ground. Turning them into smaller locusts that deal 50% damage # You don't gain the effect of trinkets consumed by abyss";
    };
    ---- The Forgotten ----
    [16] = 
    {
        ["Normal"] = "Upon striking an enemy with the bone club, the forgotten gains an intangible wisp # Switching to the soul turns every wisp into a weak purgatory ghost that grants a temporary dmg boost to the soul";
    };
    [17] = 
    {
        ["Normal"] = "Upon striking an enemy with the bone club, the forgotten gains an intangible wisp # Switching to the soul turns every wisp into a weak purgatory ghost that grants a temporary dmg boost to the soul";
    };
    [35] = 
    {
        ["Normal"] = "Spawn 3 fly orbital, 2 on the soul and 1 on the bone pile # Enemies are fixated into attacking the bone pile when not near the soul";
    };
    [40] = 
    {
        ["Normal"] = "Spawn 3 fly orbital, 2 on the soul and 1 on the bone pile # Enemies are fixated into attacking the bone pile when not near the soul";
    };
    ---- Bethany -----
    [18] = 
    {
        ["Normal"] = "Has 10% chance to spawn a basic wisp upon room clear";
        ["Upgraded"] = "Has {{ColorGold}}{{Chance10}}{{ColorText}}% chance to spawn a basic wisp upon room clear"
    };
    [36] = 
    {
        ["Normal"] = "The next use of lemegeton will consume this trinket and spawn 2 lemegeton wisps that draw from the current room's item pool";
        ["Golden"] = "{{ColorGold}}Allow lemegeton to spawn 2 lemegeton wisps that draw from the current room's item pool # {{ColorText}}Chance to turn into a regular {{Trinket"..TrinketType.TRINKET_BIRTHCAKE.."}}Birthcake after this occurs";
    };
    ---- Jacob & Esau -----
    [19] = 
    {
        ["Normal"] = "The holder gains +25% of the stat the other brother has";
    };
    [20] = 
    {
        ["Normal"] = "The holder gains +25% of the stat the other brother has";
    };
    [37] = 
    {
        ["Normal"] = "Dark Esau consumes the cake upon damaging Jacob, preventing him from turning into The Lost # After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor";
        ["Golden"] = "{{ColorGold}}Allow Jacob to get a free hit from Dark Esau, preventing him from turning into The Lost # {{ColorText}}After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor #Chance to turn into a regular {{Trinket"..TrinketType.TRINKET_BIRTHCAKE.."}}Birthcake after being hit";
    };
    [39] = 
    {
        ["Normal"] = "Dark Esau consumes the cake upon damaging Jacob, preventing him from turning into The Lost # After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor";
        ["Golden"] = "{{ColorGold}}Allow Jacob to get a free hit from Dark Esau, preventing him from turning into The Lost # {{ColorText}}After this occurs, Dark Esau and Anima Sola will target enemies for the rest of the floor #Chance to turn into a regular {{Trinket"..TrinketType.TRINKET_BIRTHCAKE.."}}Birthcake after being hit";
    };
}

local PlayerList = {
	"_isaac", 
	"_magdalene",
	"_cain",
	"_judas",
	"_bluebaby",
	"_eve",
	"_samson",
	"_azazel",
	"_lazarus",
	"_eden",
	"_thelost",
	"_lazarus2",
	"_darkjudas",
	"_lilith",
	"_keeper",
	"_apollyon",
	"_forgotten",
	"_forgottensoul",
	"_bethany",
	"_jacob",
	"_esau",
	"_isaacb",
	"_magdaleneb",
	"_cainb",
	"_judasb",
	"_bluebabyb",
	"_eveb",
	"_samsonb",
	"_azazelb",
	"_lazarusb",
	"_edenb",
	"_thelostb",
	"_lilithb",
	"_keeperb",
	"_apollyonb",
	"_forgottenb",
	"_bethanyb",
	"_jacobb",
	"_lazarus2b",
	"_jacobghostb",
	"_forgottensoulb"
}

SaveData = {
    Eden = {
        ImitedItem = 0,
        FirstTime = false,
        HasTrinket = false
    }
}

local iconsPath = "gfx/items/trinkets/"
local characterScriptPath = "scripts/characters/"

include("scripts/helpFuncs.lua")
include("scripts/mcm.lua")
include(characterScriptPath.."bethany.lua")
include(characterScriptPath.."cain.lua")
include(characterScriptPath.."magdalene.lua")
include(characterScriptPath.."judas.lua")
include(characterScriptPath.."isaac.lua")
include(characterScriptPath.."bluebaby.lua")
include(characterScriptPath.."eve.lua")
include(characterScriptPath.."samson.lua")
include(characterScriptPath.."keeper.lua")
include(characterScriptPath.."lazarus.lua")
include(characterScriptPath.."apollyon.lua")
include(characterScriptPath.."jacob.lua")
include(characterScriptPath.."eden.lua")
include(characterScriptPath.."thelost.lua")
include(characterScriptPath.."azazel.lua")
include(characterScriptPath.."forgotten.lua")
include(characterScriptPath.."lillith.lua")

function BirthcakeLocals:InitData(player)
    if mod:GetData(player).isBirthcakeOverHead == nil then
        mod:GetData(player).isBirthcakeOverHead = false
    end
    if mod:GetData(player).isItemOverHead == nil then
        mod:GetData(player).isItemOverHead = false
    end
    if mod:GetData(player).items == nil then
        mod:GetData(player).items = {}
    end
    if mod:GetData(player).health == nil then
        mod:GetData(player).health = 0
    end
    if mod:GetData(player).hasBethanyWispSpawned == nil then
        mod:GetData(player).hasBethanyWispSpawned = false
    end
    if mod:GetData(player).isBagOfCraftingActive == nil then
        mod:GetData(player).isBagOfCraftingActive = false
    end
    if mod:GetData(player).LastSeenItems == nil then
        mod:GetData(player).LastSeenItems = {}
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BirthcakeLocals.InitData)

function BirthcakeLocals:GameStart()
    if mod:HasData() then
        local data = json.decode(mod:LoadData())
        if data then
            SaveData = data
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BirthcakeLocals.GameStart)

function BirthcakeLocals:GameExit()
    mod:SaveData(json.encode(SaveData))
end
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, BirthcakeLocals.GameExit)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, BirthcakeLocals.GameExit)

function BirthcakeLocals:ItemDesc(player)
    local ptype = player:GetPlayerType()
    if not mod:GetData(player).isBirthcakeOverHead and player.QueuedItem.Item then
        if mod:IsBirthcake(player.QueuedItem.Item.ID)then
            mod:GetData(player).isBirthcakeOverHead = true
            local desc = mod.BirthcakeDescs[ptype]
            local name = ""
            if ptype == PlayerType.PLAYER_JUDAS or ptype == PlayerType.PLAYER_JUDAS_B or ptype == PlayerType.PLAYER_BLACKJUDAS then
                name = "Judas' cake"
            elseif ptype == PlayerType.PLAYER_LAZARUS or ptype == PlayerType.PLAYER_LAZARUS2 or ptype == PlayerType.PLAYER_LAZARUS_B or ptype == PlayerType.PLAYER_LAZARUS2_B then
                name = "Lazarus' cake"
            else 
                name = player:GetName() .. "'s cake"
            end
            local isTainted = mod:IsTainted(player)
            if isTainted then
                name = "Tainted " .. name
            end
            Game():GetHUD():ShowItemText(name, desc, false) 
        end
    end
    if mod:GetData(player).isBirthcakeOverHead and not player.QueuedItem.Item then
        mod:GetData(player).isBirthcakeOverHead = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, BirthcakeLocals.ItemDesc);

local function round(number, precision)
    local fmtStr = string.format('%%0.%sf',precision)
    number = string.format(fmtStr,number)
    return number
end

function BirthcakeLocals:ChangeSpritePickup(entity)
    local player = Isaac.GetPlayer(0)
	local playerType = player:GetPlayerType()
    local level = Game():GetLevel()
	
	if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TRINKET and mod:IsBirthcake(entity.SubType) and math.floor(level:GetCurses()/LevelCurse.CURSE_OF_BLIND)%2 == 0 then
        local sprite = entity:GetSprite()

        if playerType >= 41 then
            sprite:ReplaceSpritesheet(0, iconsPath .. player:GetName():lower() .. "_birthcake.png")
        else
            sprite:ReplaceSpritesheet(0, iconsPath .. playerType .. PlayerList[playerType + 1].. "_birthcake.png")
        end


        sprite:LoadGraphics()
        if playerType == PlayerType.PLAYER_THELOST_B and sprite:GetFilename() ~= iconsPath .. "thelost_trinket.anm2" and sprite:GetAnimation() == "Idle" then
            sprite:Load(iconsPath .. "thelost_trinket.anm2",true)
            sprite:Play("Idle",true)
        end
        if sprite:IsFinished("Idle") then
            sprite:Play("Idle",true)
        end
        sprite:Update()

        if EID then
            local ptype = player:GetPlayerType()
            local name = ""
            if ptype == PlayerType.PLAYER_JUDAS or ptype == PlayerType.PLAYER_JUDAS_B or ptype == PlayerType.PLAYER_BLACKJUDAS then
                name = "Judas' cake"
            elseif ptype == PlayerType.PLAYER_LAZARUS or ptype == PlayerType.PLAYER_LAZARUS2 or ptype == PlayerType.PLAYER_LAZARUS_B or ptype == PlayerType.PLAYER_LAZARUS2_B then
                name = "Lazarus' cake"
            else 
                name = player:GetName() .. "'s cake"
            end
            local isTainted = mod:IsTainted(player)
            if isTainted then
                name = "Tainted " .. name
            end

            if ptype == PlayerType.PLAYER_EDEN then
                if ImitedItem ~= 0 then
                    local desc = "Imitates a random passive item # Is guaranteed to imitate a Q4 item if eden started with a Q0 or Q1 item # Imited item: {{Collectible".. tostring(ImitedItem) .."}}"
                    EID:addTrinket(TrinketType.TRINKET_BIRTHCAKE, desc,name)
                end
            else
                local desc = ""
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and mod.TrinketDesc[ptype]["Birthright"] ~= nil then
                    desc = mod.TrinketDesc[ptype]["Birthright"]
                elseif (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) or mod:IsGolden(entity.SubType)) and mod.TrinketDesc[ptype]["Upgraded"] ~= nil then
                    desc = mod.TrinketDesc[ptype]["Upgraded"]
                elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and mod.TrinketDesc[ptype]["Mom's Box"] ~= nil then
                    desc = mod.TrinketDesc[ptype]["Mom's Box"]
                elseif mod:IsGolden(entity.SubType) and mod.TrinketDesc[ptype]["Golden"] then
                    desc = mod.TrinketDesc[ptype]["Golden"]
                else 
                    desc = mod.TrinketDesc[ptype]["Normal"]
                end

                if mod:IsGolden(entity.SubType) and mod.TrinketDesc[ptype]["+Golden"] then
                    desc = desc .. mod.TrinketDesc[ptype]["+Golden"]
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and mod.TrinketDesc[ptype]["+Mom's Box"] then
                    desc = desc .. mod.TrinketDesc[ptype]["+Mom's Box"]
                end
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and mod.TrinketDesc[ptype]["+Birthright"] then
                    desc = desc .. mod.TrinketDesc[ptype]["+Birthright"]
                end
                
                for index, value in pairs(mod.TrinketDesc[ptype]) do
                    if index:find("+{{Trinket") then
                        local trinket = index:match("+{{Trinket(%d+)}}")
                        trinket = tonumber(trinket)
                        if trinket and player:HasTrinket(trinket) then
                            desc = desc .. value
                        end
                    end
                end

                if desc:find("{{Chance") then
                    local chance = desc:match("{{Chance(%d+)}}")
                    chance = tonumber(chance)
                    if chance then
                        local multiplier = 1
                        if mod:IsGolden(entity.SubType) then
                            multiplier = multiplier + 1
                        end
                        if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                            multiplier = multiplier + 1
                        end
                        local newChance = chance * multiplier
                        desc = desc:gsub("{{Chance"..tostring(chance).."}}", tostring(newChance))
                    end
                end

                if desc:find("{{DamageUp") then
                    local multiplier = 1
                    if mod:IsGolden(entity.SubType) then
                        multiplier = multiplier + 1
                    end
                    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) then
                        multiplier = multiplier + 1
                    end
                    local dmg = round((player.Damage * 0.2) * multiplier, 2)
                    desc = desc:gsub("{{DamageUp}}", tostring(dmg))
                end

                EID:addTrinket(TrinketType.TRINKET_BIRTHCAKE, desc,name)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, BirthcakeLocals.ChangeSpritePickup)

function BirthcakeLocals:ChangeDesc()
    local player = Isaac.GetPlayer(0)
    if EID and player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
        local name = ""
        local ptype = player:GetPlayerType()
        local entity = player:GetTrinket(0)
        if ptype == PlayerType.PLAYER_JUDAS or ptype == PlayerType.PLAYER_JUDAS_B or ptype == PlayerType.PLAYER_BLACKJUDAS then
            name = "Judas' cake"
        elseif ptype == PlayerType.PLAYER_LAZARUS or ptype == PlayerType.PLAYER_LAZARUS2 or ptype == PlayerType.PLAYER_LAZARUS_B or ptype == PlayerType.PLAYER_LAZARUS2_B then
            name = "Lazarus' cake"
        else
            name = player:GetName() .. "'s cake"
        end
        local isTainted = mod:IsTainted(player)
        if isTainted then
            name = "Tainted " .. name
        end

        if ptype == PlayerType.PLAYER_JUDAS or ptype == PlayerType.PLAYER_BLACKJUDAS then
            local dmg = round(player.Damage * 0.2, 2)
            local desc = "↑ +"..tostring(dmg).." damage #Grants +1 black heart when selling all of your red health to a devil deal"
            EID:addTrinket(TrinketType.TRINKET_BIRTHCAKE, desc,name)
        elseif ptype == PlayerType.PLAYER_EDEN then
            if ImitedItem ~= 0 then
                local desc = "Imitates a random passive item # Is guaranteed to imitate a Q4 item if eden started with a Q0 or Q1 item # Imited item: {{Collectible".. tostring(ImitedItem) .."}}"
                EID:addTrinket(TrinketType.TRINKET_BIRTHCAKE, desc,name)
            end
        else
            local desc = ""
            if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) and mod.TrinketDesc[ptype]["Birthright"] ~= nil then
                desc = mod.TrinketDesc[ptype]["Birthright"]
            elseif (player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) or mod:IsGolden(entity)) and mod.TrinketDesc[ptype]["Upgraded"] then
                desc = mod.TrinketDesc[ptype]["Upgraded"]
            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_BOX) and mod.TrinketDesc[ptype]["Mom's Box"] ~= nil then
                desc = mod.TrinketDesc[ptype]["Mom's Box"]
            elseif player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG) and mod.TrinketDesc[ptype]["Golden"] then
                desc = mod.TrinketDesc[ptype]["Golden"]
            else 
                desc = mod.TrinketDesc[ptype]["Normal"]
            end

            if player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE + TrinketType.TRINKET_GOLDEN_FLAG) and mod.TrinketDesc[ptype]["+Golden"] then
                desc = desc .. mod.TrinketDesc[ptype]["+Golden"]
            end
            
            for index, value in pairs(mod.TrinketDesc[ptype]) do
                if index:find("+{{Trinket") then
                    local trinket = index:match("+{{Trinket(%d+)}}")
                    trinket = tonumber(trinket)
                    if trinket and player:HasTrinket(trinket) then
                        desc = desc .. value
                    end
                end
            end

            if desc:find("{{Chance") then
                local chance = desc:match("{{Chance(%d+)}}")
                chance = tonumber(chance)
                if chance then
                    local newChance = chance * player:GetTrinketMultiplier(entity)
                    desc = desc:gsub("{{Chance"..tostring(chance).."}}", tostring(newChance))
                 end
            end

            EID:addTrinket(TrinketType.TRINKET_BIRTHCAKE, desc,name)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, BirthcakeLocals.ChangeDesc)

--- Birthday party
local Variants = {30,40,69,70,90,300}

function Start()
    local game = Game()
    if game.Challenge == Challenge.CHALLENGE_BIRTHDAY_PARTY then
        local room = game:GetRoom()
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_BIRTHCAKE, room:GetCenterPos(), Vector(0,0), nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Start)

local function SpawnFromPool(pool,pos,price,seed)
    local item = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, game:GetItemPool():GetCollectible(pool,false), pos, Vector(0,0),nil):ToPickup()
    local itemConfig = Isaac.GetItemConfig():GetCollectible(item.SubType)
    Isaac.ConsoleOutput(itemConfig.ShopPrice .. "\n")
    if price == -1 then
        price = math.floor(itemConfig.ShopPrice / 2)
    end
    item.Price = price
    item.AutoUpdatePrice = false
    item.ShopItemId = -1
    return item
end

local function SpawnRandomPickup(pos,price,seed)
    local player = game:GetPlayer(0)
    local rng = player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_BIRTHRIGHT)
    local variant = Variants[rng:RandomInt(#Variants)+1]
    local SubType = 0
    if variant == 30 then
        SubType = 1
    elseif variant == 40 then
        SubType = 1
    elseif variant == 69 then
        SubType = rng:RandomInt(2)
    elseif variant == 70 then
        SubType = rng:RandomInt(PillColor.NUM_STANDARD_PILLS)
    elseif variant == 90 then
        SubType = 1
    elseif variant == 300 then
        SubType = rng:RandomInt(Card.NUM_CARDS)
    end
    local Pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, SubType, pos, Vector(0,0),nil):ToPickup()
    if price == -1 then
        price = 3
    end
    Pickup.Price = price
    Pickup.AutoUpdatePrice = false
    Pickup.ShopItemId = -1
    return Pickup
end

function SwitchCharacter()
    local game = Game()
    if game.Challenge == Challenge.CHALLENGE_BIRTHDAY_PARTY then
        if game:GetLevel():GetStage() ~= LevelStage.STAGE1_1 then
            local player = Isaac.GetPlayer(0)
            if player:HasTrinket(TrinketType.TRINKET_BIRTHCAKE) then
                player:TryRemoveTrinket(TrinketType.TRINKET_BIRTHCAKE)
            end
            local ptype = player:GetPlayerType()
            local room = game:GetRoom()
            if ptype == PlayerType.PLAYER_THELOST then
                player:ChangePlayerType(ptype + 3)
            elseif ptype == PlayerType.PLAYER_THEFORGOTTEN then
                player:ChangePlayerType(ptype + 2)
            elseif ptype == PlayerType.PLAYER_JACOB then
                player:ChangePlayerType(ptype + 2)
            elseif ptype == PlayerType.PLAYER_JACOB_B then
                player:ChangePlayerType(PlayerType.PLAYER_ISAAC)
            else
                player:ChangePlayerType(ptype + 1)
            end


            if player:GetMaxHearts() == 0 then
                player:AddMaxHearts(4)
                player:AddHearts(4)
            elseif player:CanPickSoulHearts() and player:GetMaxHearts() == 0 and player:GetSoulHearts() <= 5 then
                player:AddSoulHearts(6)
            end



            ptype = player:GetPlayerType()

            if ptype == PlayerType.PLAYER_MAGDALENE then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_YUM_HEART, room:GetCenterPos()+Vector(-0,-80), Vector(0,0), nil)
            elseif ptype == PlayerType.PLAYER_THELOST then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_ETERNAL_D6, room:GetCenterPos()+Vector(-0,-80), Vector(0,0), nil)
            elseif ptype == PlayerType.PLAYER_LILITH then
                player:AddBlackHearts(2)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS, room:GetCenterPos()+Vector(-0,-80), Vector(0,0), nil)
            elseif ptype == PlayerType.PLAYER_KEEPER then
                player:AddHearts(4)
            elseif ptype == PlayerType.PLAYER_APOLLYON then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_VOID, room:GetCenterPos()+Vector(-0,-80), Vector(0,0), nil)
            elseif ptype == PlayerType.PLAYER_BETHANY then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES, room:GetCenterPos()+Vector(-0,-80), Vector(0,0), nil)
            elseif ptype == PlayerType.PLAYER_LILITH_B then
                player:AddBlackHearts(2)
            elseif ptype == PlayerType.PLAYER_THEFORGOTTEN then
                player:AddSoulHearts(2)
            elseif ptype == PlayerType.PLAYER_KEEPER_B then
                player:AddHearts(2)
                local room = game:GetRoom()
                local seed = game:GetSeeds():GetStartSeed()
                local centerPos = room:GetCenterPos()

                room:TurnGold()
                local item = SpawnFromPool(ItemPoolType.POOL_SHOP,centerPos+Vector(0,-60),-1,seed)
                local pickup1 = SpawnRandomPickup(centerPos+Vector(80,-40),-1,seed)
                local pickup2 = SpawnRandomPickup(centerPos+Vector(-80,-40),-1,seed)
                mod:GetData(item).IsKeeperShop = true
                mod:GetData(pickup1).IsKeeperShop = true
                mod:GetData(pickup2).IsKeeperShop = true
            end

            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, TrinketType.TRINKET_BIRTHCAKE, room:GetCenterPos()+Vector(-0,-50), Vector(0,0), nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SwitchCharacter)

function BirthcakeLocals:ReplaceCake(selectedTrinket, rng)
    local player = Isaac.GetPlayer(0)
    local ptype = player:GetPlayerType()
    if selectedTrinket == TrinketType.TRINKET_BIRTHCAKE and mod.BirthcakeDescs[ptype] == nil then
        Isaac.ConsoleOutput(tostring(mod.BirthcakeDescs[ptype]))
        local trinket = rng:RandomInt(TrinketType.NUM_TRINKETS)
        if trinket == TrinketType.TRINKET_BIRTHCAKE then
            trinket = trinket + 1
        end
        return trinket
    end
end

mod:AddCallback(ModCallbacks.MC_GET_TRINKET, BirthcakeLocals.ReplaceCake)