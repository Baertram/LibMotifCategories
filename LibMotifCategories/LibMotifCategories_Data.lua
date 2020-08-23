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
--BASE DATA TABLE WAS INSPIRED BY ADDON "CRAFTSTORE FIXED AND IMPROVED".
--THE DATA WAS IMPROVED BY INTERNET RESSOURCES AND INGAME TESTS.
--ALL RIGHTS AND THANKS TO THE MAINTAINERS OF THIS ADDON AND THE FOLLOWING WEBSEITES:
--UESP, The Elder Scrolls Online WIKI, ESO MMO Fashion

-- ESO Style IDs and their data
-- -> styleId is determined via GetValidItemStyleId(styleIndex)
-- [styleId] = {LibMotifCategoryCategoryId styleCategory, number achievementId, number itemIdOfAnItemOfThatStyle,
--              number bookItemId, number chapterItemId, number crownBookItemId, number crownChapterItemId
--              number motifNumber (value -1 will be replaced via function getMotifNumbersOfStyles in file
--              LibMotifCategories.lua, as the library is initialized), number APIVersionAsThisStyleWasAdded
-- } -- name of the style in language EN
local ESOStyleData = {
    [1] = {LMC_MOTIF_CATEGORY_NORMAL,1025,16425,16425,0,64541,0,-1,100003},     --Breton
    [2] = {LMC_MOTIF_CATEGORY_NORMAL,1025,16427,16427,0,64543,0,-1,100003},     --Redguard
    [3] = {LMC_MOTIF_CATEGORY_NORMAL,1025,16426,16426,0,64542,0,-1,100003},     --Orc
    [4] = {LMC_MOTIF_CATEGORY_NORMAL,1025,27245,27245,0,64546,0,-1,100003},     --Dunmer
    [5] = {LMC_MOTIF_CATEGORY_NORMAL,1025,27244,27244,0,64545,0,-1,100003},     --Nord
    [6] = {LMC_MOTIF_CATEGORY_NORMAL,1025,27246,27246,0,64547,0,-1,100003},     --Argonian
    [7] = {LMC_MOTIF_CATEGORY_NORMAL,1025,16424,16424,0,64540,0,-1,100003},     --Altmer
    [8] = {LMC_MOTIF_CATEGORY_NORMAL,1025,16428,16428,0,64544,0,-1,100003},     --Bosmer
    [9] = {LMC_MOTIF_CATEGORY_NORMAL,1025,44698,44698,0,64548,0,-1,100003},     --Khajiit
    [11] = {LMC_MOTIF_CATEGORY_EXOTIC,1423,74556,74555,74556,74570,0,-1,100014},     --Thieves Guild
    [12] = {LMC_MOTIF_CATEGORY_EXOTIC,1661,82055,82054,82055,82069,0,-1,100015},     --Dark Brotherhood
    [13] = {LMC_MOTIF_CATEGORY_EXOTIC,1412,71567,71566,71567,71581,0,-1,100013},     --Malacath
    [14] = {LMC_MOTIF_CATEGORY_EXOTIC,1144,57573,57572,57573,64553,0,-1,0},     --Dwemer
    [15] = {LMC_MOTIF_CATEGORY_RARE,1025,51638,51638,0,64551,0,-1,0},     --Ancient Elf
    [16] = {LMC_MOTIF_CATEGORY_EXOTIC,1660,82088,82087,82088,82102,0,-1,100015},     --Order of the Hour
    [17] = {LMC_MOTIF_CATEGORY_RARE,1025,51565,51565,0,64550,0,-1,0},     --Barbaric
    [19] = {LMC_MOTIF_CATEGORY_RARE,1025,51345,51345,0,64549,0,-1,0},     --Primal
    [20] = {LMC_MOTIF_CATEGORY_RARE,1025,51688,51688,0,64552,0,-1,0},     --Daedric
    [21] = {LMC_MOTIF_CATEGORY_EXOTIC,1411,71551,71550,71551,71565,0,-1,100013},     --Trinimac
    [22] = {LMC_MOTIF_CATEGORY_EXOTIC,1341,69528,69527,69528,69542,0,-1,100013},     --Ancient Orc
    [23] = {LMC_MOTIF_CATEGORY_ALLIANCE,1416,71705,71704,71705,71719,0,-1,0},     --Daggerfall Covenant
    [24] = {LMC_MOTIF_CATEGORY_ALLIANCE,1414,71721,71720,71721,71735,0,-1,0},     --Ebonheart Pact
    [25] = {LMC_MOTIF_CATEGORY_ALLIANCE,1415,71689,71688,71689,71703,0,-1,0},     --Aldmeri Dominion
    [26] = {LMC_MOTIF_CATEGORY_EXOTIC,1348,64716,64715,64716,64730,0,-1,0},     --Mercenary
    [27] = {LMC_MOTIF_CATEGORY_EXOTIC,1714,82007,82006,82007,82021,0,-1,0},     --Celestial
    [28] = {LMC_MOTIF_CATEGORY_EXOTIC,1319,64670,64669,64670,64684,0,-1,0},     --Glass
    [29] = {LMC_MOTIF_CATEGORY_EXOTIC,1181,57835,57834,57835,64556,0,-1,100012},     --Xivkyn
    [30] = {LMC_MOTIF_CATEGORY_RARE,1418,71765,71765,0,0,0,-1,0},     --Soul Shriven
    [31] = {LMC_MOTIF_CATEGORY_EXOTIC,1715,76895,76894,76895,76909,0,-1,0},     --Draugr
    [33] = {LMC_MOTIF_CATEGORY_EXOTIC,1318,57591,57590,57591,64554,0,-1,0},     --Akaviri
    [34] = {LMC_MOTIF_CATEGORY_RARE,1025,54868,54868,0,64559,0,-1,0},     --Imperial
    [35] = {LMC_MOTIF_CATEGORY_EXOTIC,1713,57606,57605,57606,64555,0,-1,0},     --Yokudan
    [38] = {LMC_MOTIF_CATEGORY_DROPPED,0,132532,0,0,132532,0,-1,100023},     --Tsaesci
    [39] = {LMC_MOTIF_CATEGORY_EXOTIC,1662,82072,82071,82072,82086,0,-1,100015},     --Minotaur
    [40] = {LMC_MOTIF_CATEGORY_EXOTIC,1798,75229,75228,75229,75243,0,-1,0},     --Ebony
    [41] = {LMC_MOTIF_CATEGORY_EXOTIC,1422,74540,74539,74540,74554,0,-1,100014},     --Abah's Watch
    [42] = {LMC_MOTIF_CATEGORY_EVENT,1676,73855,73854,73855,73869,0,-1,0},     --Skinchanger
    [43] = {LMC_MOTIF_CATEGORY_EXOTIC,1933,73839,73838,73839,73853,0,-1,100019},     --Morag Tong
    [44] = {LMC_MOTIF_CATEGORY_EXOTIC,1797,71673,71672,71673,71687,0,-1,0},     --Ra Gada
    [45] = {LMC_MOTIF_CATEGORY_EXOTIC,1659,74653,74652,74653,74667,0,-1,100014},     --Dro-m'Athra
    [46] = {LMC_MOTIF_CATEGORY_EXOTIC,1424,76879,76878,76879,76893,0,-1,100015},     --Assassin's League
    [47] = {LMC_MOTIF_CATEGORY_EXOTIC,1417,71523,71522,71523,71537,0,-1,100014},     --Outlaw
    [48] = {LMC_MOTIF_CATEGORY_DROPPED,2022,130011,130010,130011,130025,0,-1,100019},     --Redoran
    [49] = {LMC_MOTIF_CATEGORY_DROPPED,2021,129995,129994,129995,130009,0,-1,100019},     --Hlaalu
    [50] = {LMC_MOTIF_CATEGORY_EXOTIC,1935,121349,121348,121349,121363,0,-1,100019},     --Militant Ordinator
    [51] = {LMC_MOTIF_CATEGORY_DROPPED,2023,121333,121332,121333,121347,0,-1,100019},     --Telvanni
    [52] = {LMC_MOTIF_CATEGORY_EXOTIC,1934,121317,121316,121317,121331,0,-1,100019},     --Buoyant Armiger
    [53] = {LMC_MOTIF_CATEGORY_CROWN,0,96954,0,0,96954,0,-1,0},     --Frostcaster
    [54] = {LMC_MOTIF_CATEGORY_EXOTIC,1932,124680,124679,124680,124694,0,-1,100019},     --Ashlander
    [55] = {LMC_MOTIF_CATEGORY_EVENT,2120,134740,134739,134740,134754,0,-1,0},     --Worm Cult
    [56] = {LMC_MOTIF_CATEGORY_EXOTIC,1796,114968,114967,114968,114982,0,-1,100016},     --Silken Ring
    [57] = {LMC_MOTIF_CATEGORY_EXOTIC,1795,114952,114951,114952,114966,0,-1,100016},     --Mazzatun
    [58] = {LMC_MOTIF_CATEGORY_CROWN,0,82053,82038,82039,82053,0,-1,0},     --Grim Harlequin
    [59] = {LMC_MOTIF_CATEGORY_EVENT,1545,82023,82022,82023,82037,82103,-1,0},     --Hollowjack
    [60] = {LMC_MOTIF_CATEGORY_EXOTIC,2024,130027,130026,130027,130041,0,-1,0},     --Refabricated
    [61] = {LMC_MOTIF_CATEGORY_EXOTIC,2098,132534,132533,132534,132548,0,-1,100020},     --Bloodforge
    [62] = {LMC_MOTIF_CATEGORY_EXOTIC,2097,132566,132565,132566,132580,0,-1,100020},     --Dreadhorn
    [65] = {LMC_MOTIF_CATEGORY_EXOTIC,2044,132550,132549,132550,132564,0,-1,100021},     --Apostle
    [66] = {LMC_MOTIF_CATEGORY_EXOTIC,2045,132582,132581,132582,132596,0,-1,100021},     --Ebonshadow
    [69] = {LMC_MOTIF_CATEGORY_EXOTIC,2190,134756,134755,134756,134770,0,-1,100022},     --Fang Lair
    [70] = {LMC_MOTIF_CATEGORY_EXOTIC,2189,134772,134771,134772,134786,0,-1,100022},     --Scalecaller
    [71] = {LMC_MOTIF_CATEGORY_EXOTIC,2186,137852,137851,137852,137866,0,-1,100023},     --Psijic Order
    [72] = {LMC_MOTIF_CATEGORY_EXOTIC,2187,137921,137920,137921,137935,0,-1,100023},     --Sapiarch
    [73] = {LMC_MOTIF_CATEGORY_EXOTIC,2319,140497,140496,140497,140511,0,-1,0},     --Welkynar
    [74] = {LMC_MOTIF_CATEGORY_EXOTIC,2188,140445,140444,140445,140459,0,-1,0},     --Dremora
    [75] = {LMC_MOTIF_CATEGORY_EXOTIC,2285,140429,140428,140429,139055,140268,-1,100023},     --Pyandonean
    [77] = {LMC_MOTIF_CATEGORY_EXOTIC,2317,140463,140462,140463,140477,0,-1,0},     --Huntsman
    [78] = {LMC_MOTIF_CATEGORY_EXOTIC,2318,140479,140478,140479,140493,0,-1,0},     --Silver Dawn
    [79] = {LMC_MOTIF_CATEGORY_EXOTIC,2360,142203,142202,142203,142217,0,-1,0},     --Dead-Water
    [80] = {LMC_MOTIF_CATEGORY_EXOTIC,2359,142187,142186,142187,142201,0,-1,0},     --Honor Guard
    [81] = {LMC_MOTIF_CATEGORY_EXOTIC,2361,142219,142218,142219,142233,0,-1,0},     --Elder Argonian
    [82] = {LMC_MOTIF_CATEGORY_EXOTIC,2503,147667,147666,147667,147681,0,-1,0},     --Coldsnap
    [83] = {LMC_MOTIF_CATEGORY_EXOTIC,2504,147683,147682,147683,147697,0,-1,0},     --Meridian
    [84] = {LMC_MOTIF_CATEGORY_EXOTIC,2505,147699,147698,147699,147713,0,-1,0},     --Anequina
    [85] = {LMC_MOTIF_CATEGORY_EXOTIC,2506,147715,147714,147715,147729,0,-1,0},     --Pellitine
    [86] = {LMC_MOTIF_CATEGORY_EXOTIC,2507,147731,147730,147731,147745,0,-1,0},     --Sunspire
    [89] = {LMC_MOTIF_CATEGORY_EXOTIC,2629,156574,156573,156574,156588,0,-1,0},     --Stags of Z'en
    [92] = {LMC_MOTIF_CATEGORY_EXOTIC,2630,156556,156555,156556,156570,0,-1,0},     --Dragonguard
    [93] = {LMC_MOTIF_CATEGORY_EXOTIC,2628,156591,156590,156591,156605,0,-1,0},     --Moongrave Fane
    [94] = {LMC_MOTIF_CATEGORY_EXOTIC,2748,156609,156608,156609,156623,0,-1,0},     --New Moon
    [95] = {LMC_MOTIF_CATEGORY_EXOTIC,2750,156628,156627,156628,156642,0,-1,0},     --Shield of Senchal
    [97] = {LMC_MOTIF_CATEGORY_EXOTIC,2747,157518,157517,157518,157532,0,-1,0},     --Icereach Coven
    [98] = {LMC_MOTIF_CATEGORY_EXOTIC,2749,158292,158291,158292,158306,0,-1,0},     --Pyre Watch
    [100] = {LMC_MOTIF_CATEGORY_EXOTIC,2757,160494,160493,160494,160508,0,-1,0},     --Blackreach Vanguard
    [103] = {LMC_MOTIF_CATEGORY_EXOTIC,2763,160577,160576,160577,160591,0,-1,0},     --Ancestral Nord
    [104] = {LMC_MOTIF_CATEGORY_EXOTIC,2773,160594,160593,160594,160608,0,-1,0},     --Ancestral High Elf
    [105] = {LMC_MOTIF_CATEGORY_EXOTIC,2776,160611,160610,160611,160625,0,-1,0},     --Ancestral Orc
}
lib.ESOStyleData = ESOStyleData


------------------------------------------------------------------------------------------------------------------------
--Library "special" motif data
------------------------------------------------------------------------------------------------------------------------

-- Special motifs.
-- e.g. some motifs do not have a non-crown version
-- or there are several styleIds which all relate to the same motif
local specialMotifs = {
    noChapter           = {},
    nonCrownOnly        = {},
    crownOnly           = {},
    multipleAreTheSame  = {},
}
lib.specialMotifs = specialMotifs
--Fill the special motifs table dynamically in function "lib:addItemIdsOfStylesToInternalLookupTables()"


------------------------------------------------------------------------------------------------------------------------
--Local helper functions
------------------------------------------------------------------------------------------------------------------------
-- motifItemId is the itemId which will be used to compare with table "motifIdToItemStyleLookup" 's list of itemIds
-- which were added via "AddRange" function to this table (see initialization of the library)
local function GetMotifItemIdByItemLink(itemLink)
    if itemLink == nil or itemLink == "" then return -1 end
    local motifItemId = GetItemLinkItemId(itemLink) or select(4, ZO_LinkHandler_ParseLink(itemLink))
    return motifItemId
end


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
--When was the last time the tables were changed? "New" means since last APIversion check was done and saved in
--lib.lastAPIVersionBaseForNewCheck. All higher APIVersions count as new!
local newLookup = {
    --[[
    --Dropped
    [ITEMSTYLE_AREA_TSAESCI]            = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_REDORAN]             = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_HLAALU]              = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_TELVANNI]            = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_WORM_CULT]           = LMC_MOTIF_CATEGORY_DROPPED,

    --Exotic
    [ITEMSTYLE_ORG_MORAG_TONG]          = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ORDINATOR]           = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER]     = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ASHLANDER]          = LMC_MOTIF_CATEGORY_EXOTIC,
    ]]
    --Dynamically filled via function lib:addItemIdsOfStylesToInternalLookupTables() if APIVersionAdded of styleId
    --is > last checked APIVersion in lib.lastAPIVersionBaseForNewCheck
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
    --> All newer item styles DO NOT HAVE a dedicated constant anymore and are ONLY accessible via their styleId
    --> which hopefully will not change!
    ]]

    --The APIVersion the data tables were updated the last time, and thus new added styleIds are marked as "new"
    -->Comparison of APIVersion parameter 5 within ESOStyleData[styleId] table with lib.lastAPIVersionBaseForNewCheck
    local lastAPIVersionBaseForNewCheck = tonumber(lib.lastAPIVersionBaseForNewCheck)

    --Use the new data table ESOStyleData to add the itemId, or an itemId range, dynamically for
    --each styleId. The "from" itemId is ESOStyleData[styleId][4] and the "to" itemId is
    --ESOStyleData[styleId][5].
    --The lookup table where this data is added is "motifIdToItemStyleLookup"
    for styleId, styleData in pairs(ESOStyleData) do
        if styleData then
            local LibMotifCategoriesCategory  = styleData[constants.STYLE_CATEGORY]
            if LibMotifCategoriesCategory ~= nil then
                local fromRange = styleData[constants.STYLE_BOOK_ITEM_ID]
                local toRange   = styleData[constants.STYLE_BOOK_CHAPTER_ITEM_ID]
                if toRange == 0 then toRange = nil end
                motifIdToItemStyleLookup:AddRange(fromRange, toRange, styleId)

                --Add the category to the categories table
                categoryLookup[styleId] = LibMotifCategoriesCategory

                --Add the new styles to the "new" lookup table
                if lastAPIVersionBaseForNewCheck > 0
                    and tonumber(styleData[constants.STYLE_APIVERSION]) > lastAPIVersionBaseForNewCheck then
                    newLookup[styleId] = LibMotifCategoriesCategory
                end

                --Fill the special motifs table if necessary
                local bookItemId                = styleData[constants.STYLE_BOOK_ITEM_ID]
                local bookChapterItemId         = styleData[constants.STYLE_BOOK_CHAPTER_ITEM_ID]
                local crownBookItemId           = styleData[constants.STYLE_BOOK_CROWN_ITEM_ID]
                local crownBookChapterItemId    = styleData[constants.STYLE_BOOK_CHAPTER_CROWN_ITEM_ID]
                --No chapter itemId is given? -> NON-CHAPTER
                if bookItemId and bookItemId > 0 and not bookChapterItemId then
                    specialMotifs.noChapter[styleId] = true
                end
                --No crown itemId or crownChapterItemId is given but itemId is given? -> NON-CROWN only
                if bookItemId and bookItemId > 0 and crownBookItemId and crownBookItemId == 0
                    and crownBookChapterItemId and crownBookChapterItemId == 0 then
                    specialMotifs.nonCrownOnly[styleId] = true
                end
                --Only the crown book itemId is given? -> CROWN ONLY
                if bookItemId and bookItemId == 0 and bookChapterItemId and bookChapterItemId == 0
                    and crownBookItemId and crownBookItemId > 0 then
                    specialMotifs.crownOnly[styleId] = true
                end
            end
        end
    end

    --Unset the function so noone else calls it
    lib.addItemIdsOfStylesToInternalLookupTables = nil
end