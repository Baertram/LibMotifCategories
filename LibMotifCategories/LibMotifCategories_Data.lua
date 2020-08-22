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
    [11]  = {2,1423,74556,-1},   -- Thieves Guild
    [12]  = {2,1661,82055,-1},   -- Dark Brotherhood
    [13]  = {2,1412,71567,-1},   -- Malacath
    [14]  = {2,1144,57573,-1},   -- Dwemer
    [15]  = {LMC_MOTIF_CATEGORY_NORMAL,1025,51638,-1},   -- Ancient Elf
    [16]  = {2,1660,82088,-1},   -- Order of the Hour
    [17]  = {LMC_MOTIF_CATEGORY_NORMAL,1025,51565,-1},   -- Barbaric
    [19]  = {LMC_MOTIF_CATEGORY_NORMAL,1025,51345,-1},   -- Primal
    [20]  = {LMC_MOTIF_CATEGORY_NORMAL,1025,51688,-1},   -- Daedric
    [21]  = {2,1411,71551,-1},   -- Trinimac
    [22]  = {2,1341,69528,-1},   -- Ancient Orc
    [23]  = {2,1416,71705,-1},   -- Daggerfall Covenant
    [24]  = {2,1414,71721,-1},   -- Ebonheart Pact
    [25]  = {2,1415,71689,-1},   -- Aldmeri Dominion
    [26]  = {2,1348,64716,-1},   -- Mercenary
    [27]  = {2,1714,82007,-1},   -- Celestial
    [28]  = {2,1319,64670,-1},   -- Glass
    [29]  = {2,1181,57835,-1},   -- Xivkyn
    [30]  = {LMC_MOTIF_CATEGORY_NORMAL,1418,71765,-1},   -- Soul Shriven
    [31]  = {2,1715,76895,-1},   -- Draugr
    [33]  = {2,1318,57591,-1},   -- Akaviri
    [34]  = {LMC_MOTIF_CATEGORY_NORMAL,1025,54868,-1},   -- Imperial
    [35]  = {2,1713,57606,-1},   -- Yokudan
    [38]  = {LMC_MOTIF_CATEGORY_CROWN,0,132532,-1},     -- Tsaesci
    [39]  = {2,1662,82072,-1},   -- Minotaur
    [40]  = {2,1798,75229,-1},   -- Ebony
    [41]  = {2,1422,74540,-1},   -- Abah's Watch
    [42]  = {2,1676,73855,-1},   -- Skinchanger
    [43]  = {2,1933,73839,-1},   -- Morag Tong
    [44]  = {2,1797,71673,-1},   -- Ra Gada
    [45]  = {2,1659,74653,-1},   -- Dro-m'Athra
    [46]  = {2,1424,76879,-1},   -- Assassin's League
    [47]  = {2,1417,71523,-1},   -- Outlaw
    [48]  = {2,2022,130011,-1},  -- Redoran
    [49]  = {2,2021,129995,-1},  -- Hlaalu
    [50]  = {2,1935,121349,-1},  -- Militant Ordinator
    [51]  = {2,2023,121333,-1},  -- Telvanni
    [52]  = {2,1934,121317,-1},  -- Buoyant Armiger
    [53]  = {LMC_MOTIF_CATEGORY_CROWN,0,96954,-1},      -- Frostcaster
    [54]  = {2,1932,124680,-1},  -- Ashlander
    [55]  = {2,2120,134740,-1},  -- Worm Cult
    [56]  = {2,1796,114968,-1},  -- Silken Ring
    [57]  = {2,1795,114952,-1},  -- Mazzatun
    [58]  = {LMC_MOTIF_CATEGORY_CROWN,0,82053,-1},      -- Grim Harlequin
    [59]  = {2,1545,82023,-1},   -- Hollowjack
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
