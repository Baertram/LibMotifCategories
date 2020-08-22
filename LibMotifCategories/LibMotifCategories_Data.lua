------------------------------------------------------------------------------------------------------------------------
--Library was loaded?
------------------------------------------------------------------------------------------------------------------------
local lib = LibMotifCategories:GetLibInstance()
local MAJOR = lib.name
if not lib or lib.version == nil then
    d("[" .. MAJOR .. "] ERROR - Library's constants file not loaded properly!")
    return
end


------------------------------------------------------------------------------------------------------------------------
--Local variables
------------------------------------------------------------------------------------------------------------------------
local constants                 = lib.CONSTANTS


------------------------------------------------------------------------------------------------------------------------
-- Data for styles, stylebooks, etc.
------------------------------------------------------------------------------------------------------------------------
--BASE DATA WAS TAKEN FROM "CRAFTSTORE FIXED AND IMPROVED", AND THE INTERNET!
--ALL RIGHTS AND THANKS TO THE MAINTAINERS OF THIS ADDON AND THE FOLLOWING WEBSEITES:
--UESP, The Elder Scrolls Online WIKI, ESO MMO Fashion

-- ESO Style IDs and their data
-- -> styleId is determined via GetValidItemStyleId(styleIndex)
-- [styleId] = {LibMotifCategoryCategoryId styleCategory, number achievementId, number itemIdOfAnItemOfThatStyle,
--              number motifNumber (value -1 will be replaced via function getMotifNumbersOfStyles in file
--              LibMotifCategories.lua, as the library is initialized)
-- } -- name of the style in language EN
local ESOStyleData = {
    [1]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,16425,-1},   -- Breton
    [2]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,16427,-1},   -- Redguard
    [3]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,16426,-1},   -- Orc
    [4]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,27245,-1},   -- Dark Elf
    [5]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,27244,-1},   -- Nord
    [6]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,27246,-1},   -- Argonian
    [7]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,16424,-1},   -- High Elf
    [8]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,16428,-1},   -- Wood Elf
    [9]   = {LMC_MOTIF_CATEGORY_NORMAL,1025,44698,-1},   -- Khajiit
    [11]  = {LMC_MOTIF_CATEGORY_EXOTIC,1423,74556,-1},   -- Thieves Guild
    [12]  = {LMC_MOTIF_CATEGORY_EXOTIC,1661,82055,-1},   -- Dark Brotherhood
    [13]  = {LMC_MOTIF_CATEGORY_EXOTIC,1412,71567,-1},   -- Malacath
    [14]  = {LMC_MOTIF_CATEGORY_EXOTIC,1144,57573,-1},   -- Dwemer
    [15]  = {LMC_MOTIF_CATEGORY_RARE,1025,51638,-1},     -- Ancient Elf
    [16]  = {LMC_MOTIF_CATEGORY_EXOTIC,1660,82088,-1},   -- Order of the Hour / Akatosh
    [17]  = {LMC_MOTIF_CATEGORY_RARE,1025,51565,-1},     -- Barbaric
-->???
    [18]  = {LMC_MOTIF_CATEGORY_DROPPED,0,0,-1},         -- Bandit - Still exists?
--<???
    [19]  = {LMC_MOTIF_CATEGORY_RARE,1025,51345,-1},     -- Primal
    [20]  = {LMC_MOTIF_CATEGORY_RARE,1025,51688,-1},     -- Daedric
    [21]  = {LMC_MOTIF_CATEGORY_EXOTIC,1411,71551,-1},   -- Trinimac
    [22]  = {LMC_MOTIF_CATEGORY_EXOTIC,1341,69528,-1},   -- Ancient Orc
    [23]  = {LMC_MOTIF_CATEGORY_ALLIANCE,1416,71705,-1}, -- Daggerfall Covenant
    [24]  = {LMC_MOTIF_CATEGORY_ALLIANCE,1414,71721,-1}, -- Ebonheart Pact
    [25]  = {LMC_MOTIF_CATEGORY_ALLIANCE,1415,71689,-1}, -- Aldmeri Dominion
    [26]  = {LMC_MOTIF_CATEGORY_EXOTIC,1348,64716,-1},   -- Mercenary / Undaunted
    [27]  = {LMC_MOTIF_CATEGORY_EXOTIC,1714,82007,-1},   -- Celestial / Raids Craglorn
    [28]  = {LMC_MOTIF_CATEGORY_EXOTIC,1319,64670,-1},   -- Glass
    [29]  = {LMC_MOTIF_CATEGORY_EXOTIC,1181,57835,-1},   -- Xivkyn
    [30]  = {LMC_MOTIF_CATEGORY_RARE,1418,71765,-1},     -- Soul Shriven
    [31]  = {LMC_MOTIF_CATEGORY_EXOTIC,1715,76895,-1},   -- Draugr
-->???
    [32]  = {LMC_MOTIF_CATEGORY_DROPPED,0,0,-1},         -- Maormer - Still exists?
--<???
    [33]  = {LMC_MOTIF_CATEGORY_EXOTIC,1318,57591,-1},   -- Akaviri
    [34]  = {LMC_MOTIF_CATEGORY_ALLIANCE,1025,54868,-1}, -- Imperial
    [35]  = {LMC_MOTIF_CATEGORY_EXOTIC,1713,57606,-1},   -- Yokudan
-->???
    [36]  = {LMC_MOTIF_CATEGORY_CROWN,0,0,0},            -- Universal / Crown store - Still exists?
    [32]  = {LMC_MOTIF_CATEGORY_DROPPED,0,0,-1},         -- Barbaric Winter - Still exists?
--<???

    [38]  = {LMC_MOTIF_CATEGORY_DROPPED,0,132532,-1},    -- Tsaesci
    [39]  = {LMC_MOTIF_CATEGORY_EXOTIC,1662,82072,-1},   -- Minotaur
    [40]  = {LMC_MOTIF_CATEGORY_EXOTIC,1798,75229,-1},   -- Ebony
    [41]  = {LMC_MOTIF_CATEGORY_EXOTIC,1422,74540,-1},   -- Abah's Watch
    [42]  = {LMC_MOTIF_CATEGORY_EXOTIC,1676,73855,-1},   -- Skinchanger
    [43]  = {LMC_MOTIF_CATEGORY_EXOTIC,1933,73839,-1},   -- Morag Tong
    [44]  = {LMC_MOTIF_CATEGORY_EXOTIC,1797,71673,-1},   -- Ra Gada
    [45]  = {LMC_MOTIF_CATEGORY_EXOTIC,1659,74653,-1},   -- Dro-m'Athra
    [46]  = {LMC_MOTIF_CATEGORY_EXOTIC,1424,76879,-1},   -- Assassin's League
    [47]  = {LMC_MOTIF_CATEGORY_EXOTIC,1417,71523,-1},   -- Outlaw
    [48]  = {LMC_MOTIF_CATEGORY_DROPPED,2022,130011,-1}, -- Redoran
    [49]  = {LMC_MOTIF_CATEGORY_DROPPED,2021,129995,-1}, -- Hlaalu
    [50]  = {LMC_MOTIF_CATEGORY_EXOTIC,1935,121349,-1},  -- Militant Ordinator
    [51]  = {LMC_MOTIF_CATEGORY_DROPPED,2023,121333,-1}, -- Telvanni
    [52]  = {LMC_MOTIF_CATEGORY_EXOTIC,1934,121317,-1},  -- Buoyant Armiger
    [53]  = {LMC_MOTIF_CATEGORY_CROWN,0,96954,-1},       -- Frostcaster
    [54]  = {LMC_MOTIF_CATEGORY_EXOTIC,1932,124680,-1},  -- Ashlander
    [55]  = {LMC_MOTIF_CATEGORY_DROPPED,2120,134740,-1}, -- Worm Cult
    [56]  = {LMC_MOTIF_CATEGORY_EXOTIC,1796,114968,-1},  -- Silken Ring
    [57]  = {LMC_MOTIF_CATEGORY_EXOTIC,1795,114952,-1},  -- Mazzatun
    [58]  = {LMC_MOTIF_CATEGORY_CROWN,0,82053,-1},       -- Grim Harlequin
    [59]  = {LMC_MOTIF_CATEGORY_EXOTIC,1545,82023,-1},   -- Hollowjack
------------------------------------------------------------------------------------------------------------------------
-- NEW STYLES BELOW! ADDED AFTER LAST LibMotifCategories Update - since version 2
---------------------------------------------------------------------------------------------------------------------------
    [60]  = {2,2024,130027,-1},  -- Refabricated
    [61]  = {2,2098,132534,-1},  -- Bloodforge
    [62]  = {2,2097,132566,-1},  -- Dreadhorn
    [65]  = {2,2044,132550,-1},  -- Apostle
    [66]  = {2,2045,132582,-1},  -- Ebonshadow
    [69]  = {2,2190,134756,-1},  -- Fang Lair
    [70]  = {2,2189,134772,-1},  -- Scalecaller
    [71]  = {2,2186,137852,-1},  -- Psijic Order
    [72]  = {2,2187,137921,-1},  -- Sapiarch
    [73]  = {2,2319,140497,-1},  -- Welkynar
    [74]  = {2,2188,140445,-1},  -- Dremora
    [75]  = {2,2285,140429,-1},  -- Pyandonean
    [77]  = {2,2317,140463,-1},  -- Huntsman
    [78]  = {2,2318,140479,-1},  -- Silver Dawn
    [79]  = {2,2360,142203,-1},  -- Dead-Water
    [80]  = {2,2359,142187,-1},  -- Honor Guard
    [81]  = {2,2361,142219,-1},  -- Elder Argonian
    [82]  = {2,2503,147667,-1},  -- Coldsnap
    [83]  = {2,2504,147683,-1},  -- Meridian
    [84]  = {2,2505,147699,-1},  -- Anequina
    [85]  = {2,2506,147715,-1},  -- Pellitine
    [86]  = {2,2507,147731,-1},  -- Sunspire
    [89]  = {2,2629,156574,-1},  -- Stags of Z'en
    [92]  = {2,2630,156556,-1},  -- Dragonguard
    [93]  = {2,2628,156591,-1},  -- Moongrave Fane
    [94]  = {2,2748,156609,-1},  -- New Moon
    [95]  = {2,2750,156628,-1},  -- Shield of Senchal
    [97]  = {2,2747,157518,-1},  -- Icereach Coven
    [98]  = {2,2749,158292,-1},  -- Pyre Watch
    --[99] = {2,?,?,-1},        -- Swordthane
    [100] = {2,2757,160494,-1}, -- Blackreach Vanguard
    --[101] = {2,?,?,-1},       -- Greymoor
    --[102] = {2,?,?,-1},       -- Sea Giant
    [103] = {2,2763,160577,-1}, -- Ancestral Nord
    [104] = {2,2773,160594,-1}, -- Ancestral High Elf
    [105] = {2,2776,160611,-1}, -- Ancestral Orc
}
lib.ESOStyleData = ESOStyleData

-- ESO Style book IDs and their data
-- -> styleId is determined via GetValidItemStyleId(styleIndex)
-- [styleId] = {number bookId, number chapterNumber, number crownBookId, number crownChapterNumber
-- } -- name of the style in language EN
local ESOStyleBookData = {
    [1]   = {16425 , 0     , 64541 , 0},                -- Breton
    [2]   = {16427 , 0     , 64543 , 0},                -- Redguard
    [3]   = {16426 , 0     , 64542 , 0},                -- Orc
    [4]   = {27245 , 0     , 64546 , 0},                -- Dark Elf
    [5]   = {27244 , 0     , 64545 , 0},                -- Nord
    [6]   = {27246 , 0     , 64547 , 0},                -- Argonian
    [7]   = {16424 , 0     , 64540 , 0},                -- High Elf
    [8]   = {16428 , 0     , 64544 , 0},                -- Wood Elf
    [9]   = {44698 , 0     , 64548 , 0},                -- Khajiit
    [11]  = {74555 , 74556 , 74570 , 0},                -- Thieves Guild
    [12]  = {82054 , 82055 , 82069 , 0},                -- Dark Brotherhood
    [13]  = {71566 , 71567 , 71581 , 0},                -- Malacath
    [14]  = {57572 , 57573 , 64553 , 0},                -- Dwemer
    [15]  = {51638 , 0     , 64551 , 0},                -- Ancient Elf
    [16]  = {82087 , 82088 , 82102 , 0},                -- Order of the Hour
    [17]  = {51565 , 0     , 64550 , 0},                -- Barbaric
    [19]  = {51345 , 0     , 64549 , 0},                -- Primal
    [20]  = {51688 , 0     , 64552 , 0},                -- Daedric
    [21]  = {71550 , 71551 , 71565 , 0},                -- Trinimac
    [22]  = {69527 , 69528 , 69542 , 0},                -- Ancient Orc
    [23]  = {71704 , 71705 , 71719 , 0},                -- Daggerfall Covenant
    [24]  = {71720 , 71721 , 71735 , 0},                -- Ebonheart Pact
    [25]  = {71688 , 71689 , 71703 , 0},                -- Aldmeri Dominion
    [26]  = {64715 , 64716 , 64730 , 0},                -- Mercenary
    [27]  = {82006 , 82007 , 82021 , 0},                -- Celestial
    [28]  = {64669 , 64670 , 64684 , 0},                -- Glass
    [29]  = {57834 , 57835 , 64556 , 0},                -- Xivkyn
    [30]  = {71765 , 0     , 0     , 0},                -- Soul Shriven
    [31]  = {76894 , 76895 , 76909 , 0},                -- Draugr
    [33]  = {57590 , 57591 , 64554 , 0},                -- Akaviri
    [34]  = {54868 , 0     , 64559 , 0},                -- Imperial
    [35]  = {57605 , 57606 , 64555 , 0},                -- Yokudan
    --[36]  = {-1,-1,-1,-1},                            -- Universal
    [38]  = {0     , 0     , 132532, 0},                -- Tsaesci
    [39]  = {82071 , 82072 , 82086 , 0},                -- Minotaur
    [40]  = {75228 , 75229 , 75243 , 0},                -- Ebony
    [41]  = {74539 , 74540 , 74554 , 0},                -- Abah's Watch
    [42]  = {73854 , 73855 , 73869 , 0},                -- Skinchanger
    [43]  = {73838 , 73839 , 73853 , 0},                -- Morag Tong
    [44]  = {71672 , 71673 , 71687 , 0},                -- Ra Gada
    [45]  = {74652 , 74653 , 74667 , 0},                -- Dro-m'Athra
    [46]  = {76878 , 76879 , 76893 , 0},                -- Assassin's League
    [47]  = {71522 , 71523 , 71537 , 0},                -- Outlaw
    [48]  = {130010, 130011, 130025, 0},                -- Redoran
    [49]  = {129994, 129995, 130009, 0},                -- Hlaalu
    [50]  = {121348, 121349, 121363, 0},                -- Militant Ordinator
    [51]  = {121332, 121333, 121347, 0},                -- Telvanni
    [52]  = {121316, 121317, 121331, 0},                -- Buoyant Armiger
    [53]  = {0     , 0     , 96954 , 0},                -- Frostcaster
    [54]  = {124679, 124680, 124694, 0},                -- Ashlander
    [55]  = {134739, 134740, 134754, 0},                -- Worm Cult
    [56]  = {114967, 114968, 114982, 0},                -- Silken Ring
    [57]  = {114951, 114952, 114966, 0},                -- Mazzatun
    [58]  = {82038 , 82039 , 82053 , 0},                -- Grim Harlequin
    [59]  = {82022 , 82023 , 82037 , 82103 },           -- Hollowjack
------------------------------------------------------------------------------------------------------------------------
-- NEW STYLES BELOW! ADDED AFTER LAST LibMotifCategories Update - since version 2
---------------------------------------------------------------------------------------------------------------------------
    [60]  = {130026, 130027, 130041, 0},                -- Refabricated
    [61]  = {132533, 132534, 132548, 0},                -- Bloodforge
    [62]  = {132565, 132566, 132580, 0},                -- Dreadhorn
    [65]  = {132549, 132550, 132564, 0},                -- Apostle
    [66]  = {132581, 132582, 132596, 0},                -- Ebonshadow
    [69]  = {134755, 134756, 134770, 0},                -- Fang Lair
    [70]  = {134771, 134772, 134786, 0},                -- Scalecaller
    [71]  = {137851, 137852, 137866, 0},                -- Psijic Order
    [72]  = {137920, 137921, 137935, 0},                -- Sapiarch
    [73]  = {140496, 140497, 140511, 0},                -- Welkynar
    [74]  = {140444, 140445, 140459, 0},                -- Dremora
    [75]  = {140428, 140429, 139055, 140268},           -- Pyandonean
    [77]  = {140462, 140463, 140477, 0},                -- Huntsman
    [78]  = {140478, 140479, 140493, 0},                -- Silver Dawn
    [79]  = {142202, 142203, 142217, 0},                -- Dead-Water
    [80]  = {142186, 142187, 142201, 0},                -- Honor Guard
    [81]  = {142218, 142219, 142233, 0},                -- Elder Argonian
    [82]  = {147666, 147667, 147681, 0},                -- Coldsnap
    [83]  = {147682, 147683, 147697, 0},                -- Meridian
    [84]  = {147698, 147699, 147713, 0},                -- Anequina
    [85]  = {147714, 147715, 147729, 0},                -- Pellitine
    [86]  = {147730, 147731, 147745, 0},                -- Sunspire
    [89]  = {156573, 156574, 156588, 0},                -- Stags of Z'en
    [92]  = {156555, 156556, 156570, 0},                -- Dragonguard
    [93]  = {156590, 156591, 156605, 0},                -- Moongrave Fane
    [94]  = {156608, 156609, 156623, 0},                -- New Moon
    [95]  = {156627, 156628, 156642, 0},                -- Shield of Senchal
    [97]  = {157517, 157518, 157532, 0},                -- Icereach Coven
    [98]  = {158291, 158292, 158306, 0},                -- Pyre Watch
    [100] = {160493, 160494, 160508, 0},                -- Blackreach Vanguard
    [103] = {160576, 160577, 160591, 0},                -- Ancestral Nord
    [104] = {160593, 160594, 160608, 0},                -- Ancestral High Elf
    [105] = {160610, 160611, 160625, 0},                -- Ancestral Orc
}
lib.ESOStyleBookData = ESOStyleBookData


------------------------------------------------------------------------------------------------------------------------
--Library functions for the data tables
------------------------------------------------------------------------------------------------------------------------

--Update the table lib.ESOStyleData with the 4th column (lib.CONSTANTS.STYLE_MOTIF_ID) = motifId
function lib:updateMotifNumbersOfStyles()
    --Get the motif number from an example item's name, and update it to index 4 () of table ESOStyles
    if not lib or not lib.ESOStyleData then return end
    for styleId, _ in pairs(lib.ESOStyleData) do
        local motifNumber = lib:GetMotifNumberOfStyle(styleId)
        motifNumber = motifNumber or 0
        lib.ESOStyleData[styleId][constants.STYLE_MOTIF_ID] = motifNumber
    end
    --Unset the function so noone else calls it
    lib.updateMotifNumbersOfStyles = nil
end


------------------------------------------------------------------------------------------------------------------------
--Library lookup tables
------------------------------------------------------------------------------------------------------------------------
--Lookup table for the motifs and styles
local motifIdToItemStyleLookup = {
    --Add a range of itemIds to this table "motifIdToItemStyleLookup", see below at [ItemIds of style page]
    AddRange = function(self, min, max, itemStyle)
        max = max or min
        for motifItemId = min, max do
            self[motifItemId] = itemStyle
        end
    end,
    --Get the item's style by help of the itemLink
    GetItemStyle = function(self, itemLink)
        local itemStyle = GetItemLinkItemStyle(itemLink)
        --No itemStyle given?
        if itemStyle == ITEMSTYLE_NONE then
            local itemType = GetItemLinkItemType(itemLink)
            --Racial motif
            if  itemType == ITEMTYPE_RACIAL_STYLE_MOTIF then
                local motifItemId = GetMotifItemIdByItemLink(itemLink)
                itemStyle = self[motifItemId]
            else
                --No armor part
                if itemType ~= ITEMTYPE_ARMOR and itemType ~= ITEMTYPE_WEAPON then
                    itemStyle = -1
                end
            end
        end
        return itemStyle
    end,
}
lib.motifIdToItemStyleLookup = motifIdToItemStyleLookup

--The lookup table for the itemStyle to category
local categoryLookup = {
    --Set the itemstyle none category
    [ITEMSTYLE_NONE]        = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_UNIVERSAL]   = LMC_MOTIF_CATEGORY_CROWN,
    --Other table contents will be filled dynamically from function "lib:addItemIdsOfStylesToInternalLookupTables()"
}
lib.categoryLookup = categoryLookup

--The lookup table for the "new" itemStyles (added later to the game) to category
--TODO: Maybe change this to only define the last added items (per APIversion) as "new"?
local newLookup = {
    --Dropped
    [ITEMSTYLE_AREA_TSAESCI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_REDORAN] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_HLAALU] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_TELVANNI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_WORM_CULT] = LMC_MOTIF_CATEGORY_DROPPED,

    --Exotic
    [ITEMSTYLE_ORG_MORAG_TONG] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ORDINATOR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ASHLANDER] = LMC_MOTIF_CATEGORY_EXOTIC,

    --TODO: Add new ones for all the DLCs after Worm Cult etc.
}
lib.newLookup = newLookup


------------------------------------------------------------------------------------------------------------------------
--Library functions for the lookup tables
------------------------------------------------------------------------------------------------------------------------
function lib:addItemIdsOfStylesToInternalLookupTables()
    --[[
    ITEMSTYLE_NONE                      = 0
    ITEMSTYLE_RACIAL_BRETON             = 1
    ITEMSTYLE_RACIAL_REDGUARD           = 2
    ITEMSTYLE_RACIAL_ORC                = 3
    ITEMSTYLE_RACIAL_DARK_ELF           = 4
    ITEMSTYLE_RACIAL_NORD               = 5
    ITEMSTYLE_RACIAL_ARGONIAN           = 6
    ITEMSTYLE_RACIAL_HIGH_ELF           = 7
    ITEMSTYLE_RACIAL_WOOD_ELF           = 8
    ITEMSTYLE_RACIAL_KHAJIIT            = 9
    ITEMSTYLE_UNIQUE                    = 10
    ITEMSTYLE_ORG_THIEVES_GUILD         = 11
    ITEMSTYLE_ORG_DARK_BROTHERHOOD      = 12
    ITEMSTYLE_DEITY_MALACATH            = 13
    ITEMSTYLE_AREA_DWEMER               = 14
    ITEMSTYLE_AREA_ANCIENT_ELF          = 15
    ITEMSTYLE_DEITY_AKATOSH             = 16
    ITEMSTYLE_AREA_REACH                = 17
    ITEMSTYLE_ENEMY_BANDIT              = 18
    ITEMSTYLE_ENEMY_PRIMITIVE           = 19
    ITEMSTYLE_ENEMY_DAEDRIC             = 20
    ITEMSTYLE_DEITY_TRINIMAC            = 21
    ITEMSTYLE_AREA_ANCIENT_ORC          = 22
    ITEMSTYLE_ALLIANCE_DAGGERFALL       = 23
    ITEMSTYLE_ALLIANCE_EBONHEART        = 24
    ITEMSTYLE_ALLIANCE_ALDMERI          = 25
    ITEMSTYLE_UNDAUNTED                 = 26
    ITEMSTYLE_RAIDS_CRAGLORN            = 27
    ITEMSTYLE_GLASS                     = 28
    ITEMSTYLE_AREA_XIVKYN               = 29
    ITEMSTYLE_AREA_SOUL_SHRIVEN         = 30
    ITEMSTYLE_ENEMY_DRAUGR              = 31
    ITEMSTYLE_ENEMY_MAORMER             = 32
    ITEMSTYLE_AREA_AKAVIRI              = 33
    ITEMSTYLE_RACIAL_IMPERIAL           = 34
    ITEMSTYLE_AREA_YOKUDAN              = 35
    ITEMSTYLE_UNIVERSAL                 = 36
    ITEMSTYLE_AREA_REACH_WINTER         = 37
    ITEMSTYLE_AREA_TSAESCI              = 38
    ITEMSTYLE_ENEMY_MINOTAUR            = 39
    ITEMSTYLE_EBONY                     = 40
    ITEMSTYLE_ORG_ABAHS_WATCH           = 41
    ITEMSTYLE_HOLIDAY_SKINCHANGER       = 42
    ITEMSTYLE_ORG_MORAG_TONG            = 43
    ITEMSTYLE_AREA_RA_GADA              = 44
    ITEMSTYLE_ENEMY_DROMOTHRA           = 45
    ITEMSTYLE_ORG_ASSASSINS             = 46
    ITEMSTYLE_ORG_OUTLAW                = 47
    ITEMSTYLE_ORG_REDORAN               = 48
    ITEMSTYLE_ORG_HLAALU                = 49
    ITEMSTYLE_ORG_ORDINATOR             = 50
    ITEMSTYLE_ORG_TELVANNI              = 51
    ITEMSTYLE_ORG_BUOYANT_ARMIGER       = 52
    ITEMSTYLE_HOLIDAY_FROSTCASTER       = 53
    ITEMSTYLE_AREA_ASHLANDER            = 54
    ITEMSTYLE_ORG_WORM_CULT             = 55
    ITEMSTYLE_ENEMY_SILKEN_RING         = 56
    ITEMSTYLE_ENEMY_MAZZATUN            = 57
    ITEMSTYLE_HOLIDAY_GRIM_HARLEQUIN    = 58
    ITEMSTYLE_HOLIDAY_HOLLOWJACK        = 59

    ITEMSTYLE_MIN_VALUE                 = 1
    ITEMSTYLE_MAX_VALUE                 = GetHighestItemStyleId()
    ]]

    --Use the new data tables ESOStyleData and ESOStyleBookData to add the itemId, or an itemId range, dynamically for
    --each styleId. The "from" itemId is ESOStyleBookData[styleId][1] and the "to" itemId is
    --ESOStyleBookData[styleId][3].
    --The lookup table where this data is added is "motifIdToItemStyleLookup"
    for styleId, styleBookData in pairs(ESOStyleBookData) do
        if styleBookData then
            local LibMotifCategoriesCategory  = (ESOStyleData[styleId] and ESOStyleData[styleId][constants.STYLE_CATEGORY])
            if LibMotifCategoriesCategory ~= nil then
                local fromRange = styleBookData[constants.STYLE_BOOK_ITEM_ID]
                local toRange   = styleBookData[constants.STYLE_BOOK_CHAPTER_ITEM_ID]
                if toRange == 0 then toRange = nil end
                motifIdToItemStyleLookup:AddRange(fromRange ,toRange, styleId)

                --Add the category to the categories table
                categoryLookup[styleId] = LibMotifCategoriesCategory
            end
        end
    end

    --Unset the function so noone else calls it
    lib.addItemIdsOfStylesToInternalLookupTables = nil
end