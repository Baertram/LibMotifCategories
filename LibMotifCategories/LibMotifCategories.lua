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
local APIVersion = GetAPIVersion()
local svWasCreated = false

local constants = lib.CONSTANTS
local ESOStyleData = lib.ESOStyleData
local ESOStyleBookData = lib.ESOStyleBookData



------------------------------------------------------------------------------------------------------------------------
--Local helper functions
------------------------------------------------------------------------------------------------------------------------
local function getMaxItemStyleId()
    local maxItemStyleId = (GetHighestItemStyleId ~= nil and GetHighestItemStyleId())
                            or (ITEMSTYLE_MAX_VALUE ~= nil and ITEMSTYLE_MAX_VALUE)
                            or ITEMSTYLE_HOLIDAY_HOLLOWJACK
    return maxItemStyleId
end


-- motifItemId is the itemId which will be used to compare with table "motifIdToItemStyleLookup" 's list of itemIds
-- which were added via "AddRange" function to this table (see initialization of the library)
local function GetMotifItemIdByItemLink(itemLink)
    if itemLink == nil or itemLink == "" then return -1 end
    local motifItemId = GetItemLinkItemId(itemLink) or select(4, ZO_LinkHandler_ParseLink(itemLink))
    return motifItemId
end


--Update the table lib.ESOStyleData with the 4th column (lib.CONSTANTS.STYLE_MOTIF_ID) = motifId
local function getMotifNumbersOfStyles()
    --Get the motif number from an example item's name, and update it to index 4 () of table ESOStyles
    if not lib or not lib.ESOStyleData then return end
    for styleId, _ in pairs(lib.ESOStyleData) do
        local motifNumber = lib:GetMotifNumberOfStyle(styleId)
        motifNumber = motifNumber or 0
        lib.ESOStyleData[styleId][constants.STYLE_MOTIF_ID] = motifNumber
    end
end


--Check if a style category in a style category table (given at the index styleCatTableIndex) equals a given value
local function checkStyleCategoryEquals(styleId, styleCatTable, styleCatTableIndex, givenValueVar)
    --ESOStyleData[styleId][constants.STYLE_CATEGORY] == LMC_MOTIF_CATEGORY_NORMAL
    if not styleCatTable or not styleCatTable[styleId] or not styleCatTable[styleId][styleCatTableIndex] then return false end
    return styleCatTable[styleId][styleCatTableIndex] == givenValueVar
end


--Check if a style is known. If parameter number chapter is given use it for the checks.
--If parameter boolean completelyKnown is true check if ALL style pages of that style are known, else check if any is
--known.
local function checkIfStyleIsKnown(styleId, chapter, completelyKnown)
    completelyKnown = completelyKnown or false
    if not styleId or not ESOStyleData[styleId] then return end
    if lib:IsNormalStyleCategory(styleId) then
        return IsSmithingStyleKnown(styleId, nil)
    else
        if self:IsCrownStyleCategory(styleId) then
            return IsItemLinkBookKnown(string.format(constants.styleItemLinkTemplate, lib:GetStyleBookItemId(styleId, true)))
        else
            local chapterStart
            local chapterEnd
            if completelyKnown == true then
                chapterStart    = 1
                chapterEnd      = constants.MAX_STYLE_BOOK_CHAPTERS
            else
                if chapter == nil then return end
                chapterStart    = chapter
                chapterEnd      = chapter
            end
            local achievementId = ESOStyleData[styleId][constants.STYLE_ACHIEVEMENT_ID]
            if not achievementId then return end
            local numChecked = 0
            local numKnown = 0
            for chapterId = chapterStart, chapterEnd, 1 do
                numChecked = numChecked + 1
                --description string,numCompleted integer,numRequired integer
                local _, numCompleted = GetAchievementCriterion(achievementId, chapterId)
                if completelyKnown == true then
                    --Any is unknown? Return false
                    if not numCompleted or numCompleted == 0 then return false end
                    numKnown = numKnown + 1
                else
                    --Any is known? Return true
                    if numCompleted >= 1 then return true end
                end
            end
            --All should be, and also are known? Return true
            if completelyKnown == true and numKnown == numChecked then
                return true
            end
        end
    end
    --Only 1 was checked and not known
    return false
end


--[[
--Build the library's Styles list including the book chapters etc.
local function BuildStyleTable()
    if not ESOStyleBookData then return end
    lib.Styles = {}
    local maxChaptersMinusOne = constants.MAX_STYLE_BOOK_CHAPTERS - 1
    local STYLE_BOOK_ID = constants.STYLE_BOOK_ID
    local STYLE_BOOK_CHAPTER_ID =  constants.STYLE_BOOK_CHAPTER_ID
    local STYLE_BOOK_CROWN_ID = constants.STYLE_BOOK_CROWN_ID
    local STYLE_BOOK_CHAPTER_CROWN_ID = constants.STYLE_BOOK_CHAPTER_CROWN_ID
    for _, bookData in pairs(ESOStyleBookData) do
        if bookData[STYLE_BOOK_ID] > 0 then
            table.insert(lib.Styles, bookData[STYLE_BOOK_ID])
        end
        if bookData[STYLE_BOOK_CHAPTER_ID] > 0 then
            for chapter = 0, maxChaptersMinusOne do
                table.insert(lib.Styles, bookData[STYLE_BOOK_CHAPTER_ID]+chapter)
            end
        end
        if bookData[STYLE_BOOK_CROWN_ID] > 0 then
            table.insert(lib.Styles, bookData[STYLE_BOOK_CROWN_ID])
        end
        if bookData[STYLE_BOOK_CHAPTER_CROWN_ID] > 0 then
            for chapter = 0, maxChaptersMinusOne do
                table.insert(lib.Styles, bookData[STYLE_BOOK_CHAPTER_CROWN_ID]+chapter)
            end
        end
    end
end
]]


------------------------------------------------------------------------------------------------------------------------
--Library lookup tables
------------------------------------------------------------------------------------------------------------------------
--Lookup table for the motifs and styles
local motifIdToItemStyleLookup = {
    --Add a range of itemIds to this table "motifIdToItemStyleLookup", see below at [ItemIds of style page]
    AddRange = function(self, min, max, itemStyle)
        for motifId = min, max do
            self[motifId] = itemStyle
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


    --[ItemIds of motif items]
    --The following itemIds are used to determine the itemStyle of an item, which itsself does not provide an itemStyle
    --e.g. style pages or motif books.
    --There will be added other itemId ranges vie function "AddRange" (see above)
    [16424] = ITEMSTYLE_RACIAL_HIGH_ELF,
    [16425] = ITEMSTYLE_RACIAL_BRETON,
    [16426] = ITEMSTYLE_RACIAL_ORC,
    [16427] = ITEMSTYLE_RACIAL_REDGUARD,
    [16428] = ITEMSTYLE_RACIAL_WOOD_ELF,
    [27244] = ITEMSTYLE_RACIAL_NORD,
    [27245] = ITEMSTYLE_RACIAL_DARK_ELF,
    [27246] = ITEMSTYLE_RACIAL_ARGONIAN,
    [44698] = ITEMSTYLE_RACIAL_KHAJIIT,
    [51345] = ITEMSTYLE_ENEMY_PRIMITIVE,
    [51565] = ITEMSTYLE_AREA_REACH,
    [51638] = ITEMSTYLE_AREA_ANCIENT_ELF,
    [51688] = ITEMSTYLE_ENEMY_DAEDRIC,
    [54868] = ITEMSTYLE_RACIAL_IMPERIAL,

    [64540] = ITEMSTYLE_RACIAL_HIGH_ELF,
    [64541] = ITEMSTYLE_RACIAL_BRETON,
    [64542] = ITEMSTYLE_RACIAL_ORC,
    [64543] = ITEMSTYLE_RACIAL_REDGUARD,
    [64544] = ITEMSTYLE_RACIAL_WOOD_ELF,
    [64545] = ITEMSTYLE_RACIAL_NORD,
    [64546] = ITEMSTYLE_RACIAL_DARK_ELF,
    [64547] = ITEMSTYLE_RACIAL_ARGONIAN,
    [64548] = ITEMSTYLE_RACIAL_KHAJIIT,
    [64549] = ITEMSTYLE_ENEMY_PRIMITIVE,
    [64550] = ITEMSTYLE_AREA_REACH,
    [64551] = ITEMSTYLE_AREA_ANCIENT_ELF,
    [64552] = ITEMSTYLE_ENEMY_DAEDRIC,
    [64553] = ITEMSTYLE_AREA_DWEMER,
    [64554] = ITEMSTYLE_AREA_AKAVIRI,
    [64555] = ITEMSTYLE_AREA_YOKUDAN,
    [64556] = ITEMSTYLE_AREA_XIVKYN,
    [64559] = ITEMSTYLE_RACIAL_IMPERIAL,
    [71765] = ITEMSTYLE_AREA_SOUL_SHRIVEN,
    --New ones for all the DLCs after Worm Cult etc. will be added via motifIdToItemStyleLookup:AddRange, see at the
    --bottom of this library
}
lib.motifIdToItemStyleLookup = motifIdToItemStyleLookup

--The lookup table for the itemStyle to category
local categoryLookup = {
    --Normal
    [ITEMSTYLE_RACIAL_ARGONIAN] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_WOOD_ELF] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_BRETON] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_HIGH_ELF] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_DARK_ELF] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_KHAJIIT] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_NORD] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_ORC] = LMC_MOTIF_CATEGORY_NORMAL,
    [ITEMSTYLE_RACIAL_REDGUARD] = LMC_MOTIF_CATEGORY_NORMAL,

    --Rare
    [ITEMSTYLE_AREA_REACH] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_ENEMY_PRIMITIVE] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_ENEMY_DAEDRIC] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_AREA_ANCIENT_ELF] = LMC_MOTIF_CATEGORY_RARE,
    [ITEMSTYLE_AREA_SOUL_SHRIVEN] = LMC_MOTIF_CATEGORY_RARE,

    --Alliance
    [ITEMSTYLE_RACIAL_IMPERIAL] = LMC_MOTIF_CATEGORY_ALLIANCE,
    [ITEMSTYLE_ALLIANCE_ALDMERI] = LMC_MOTIF_CATEGORY_ALLIANCE,
    [ITEMSTYLE_ALLIANCE_EBONHEART] = LMC_MOTIF_CATEGORY_ALLIANCE,
    [ITEMSTYLE_ALLIANCE_DAGGERFALL] = LMC_MOTIF_CATEGORY_ALLIANCE,

    --Exotic
    [ITEMSTYLE_AREA_DWEMER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_XIVKYN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_AKAVIRI] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_GLASS] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_UNDAUNTED] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ANCIENT_ORC] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_OUTLAW] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_TRINIMAC] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_MALACATH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_THIEVES_GUILD] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ASSASSINS] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ABAHS_WATCH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_YOKUDAN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_DEITY_AKATOSH] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_MINOTAUR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_DARK_BROTHERHOOD] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_RAIDS_CRAGLORN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_DRAUGR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_EBONY] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_SKINCHANGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_RA_GADA] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_DROMOTHRA] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_FROSTCASTER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_SILKEN_RING] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ENEMY_MAZZATUN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_GRIM_HARLEQUIN] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_HOLIDAY_HOLLOWJACK] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_MORAG_TONG] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ORDINATOR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ASHLANDER] = LMC_MOTIF_CATEGORY_EXOTIC,

    --Dropped
    [ITEMSTYLE_NONE] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ENEMY_BANDIT] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ENEMY_MAORMER] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_AREA_REACH_WINTER] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_AREA_TSAESCI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_REDORAN] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_HLAALU] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_TELVANNI] = LMC_MOTIF_CATEGORY_DROPPED,
    [ITEMSTYLE_ORG_WORM_CULT] = LMC_MOTIF_CATEGORY_DROPPED,

    --Universal
    [ITEMSTYLE_UNIVERSAL] = LMC_MOTIF_CATEGORY_CROWN,

    --TODO: Add other itemStyles which are not in the addon compatibility files to the list and assign their category
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
    --TODO: Add new ones for all the DLCs after Worm Cult etc.

    --Exotic
    [ITEMSTYLE_ORG_MORAG_TONG] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_ORDINATOR] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_ORG_BUOYANT_ARMIGER] = LMC_MOTIF_CATEGORY_EXOTIC,
    [ITEMSTYLE_AREA_ASHLANDER] = LMC_MOTIF_CATEGORY_EXOTIC,
    --TODO: Add new ones for all the DLCs after Worm Cult etc.
}
lib.newLookup = newLookup


--Dynamically build the table "styleItemIndices" where the original value of the addon compatibility line will be
--increased by e.g. 1 -> See function GetValidItemStyleId(styleIndex)). ITEMSTYLE_HOLIDAY_HOLLOWJACK is e.g. the
--itemStyleIndex, where the ID is needed for checks. IDs are not equal to the index, they can differ (starting at e.g.
--ITEMSTYLE_ORG_THIEVES_GUILD index =11, ID=12)
local styleItemIndices = {}
local minItemStyleId = ITEMSTYLE_MIN_VALUE or 1
for i=minItemStyleId, getMaxItemStyleId(), 1 do
    styleItemIndices[i] = GetValidItemStyleId(i)
end


------------------------------------------------------------------------------------------------------------------------
--Library localization
------------------------------------------------------------------------------------------------------------------------
function lib:GetLocalizedCategoryName(categoryConst)
    return self.strings[categoryConst]
end


------------------------------------------------------------------------------------------------------------------------
--Library functions
------------------------------------------------------------------------------------------------------------------------
--Old functions by Randactyl, modified by Baertram - before 2020-08-22

--Get the lib's category of the item's motif
function lib:GetMotifCategory(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)
    if itemStyle == -1 then return end

    return categoryLookup[itemStyle]
end


--Is this item's motif a later added (new) one?
function lib:IsNewMotif(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)
    if itemStyle == -1 then return false end

    if newLookup[itemStyle] then
        return true
    end

    return false
end


--Is this item's motif craftable with the current character?
function lib:IsMotifCraftable(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)
    if itemStyle == -1 then return false end

    if styleItemIndices[itemStyle] then
        return true
    end

    return false
end


--Is this item's motif known to your current character?
function lib:IsMotifKnown(itemLink)
    local itemStyle = motifIdToItemStyleLookup:GetItemStyle(itemLink)
    if itemStyle == -1 then return false end
    local styleItemIndex = styleItemIndices[itemStyle]
    if not styleItemIndex then return false end

    --Hardcoded value 200:
    --GetNumSmithingPatterns() returns 0 if not at a crafting table, else 14 for an example char, so not enough to use
    --in order to use here
    -->Check if any of the patternIndices of the determined itemStyleId is known
    for patternIndex = 1, 200 do
        if IsSmithingStyleKnown(styleItemIndex, patternIndex) then
            return true
        end
    end

    return false
end


--Check if the item's motif is available (what does available mean? The code says: Assigned to any category)
--> Duplicate function to lib:GetMotifCategory somehow?
function lib:IsMotifAvailable(itemLink)
    return self:GetMotifCategory(itemLink) ~= nil
end


--Get the item's motif full information
--Category, isNew, isCraftable, isKNown, isAvailable
function lib:GetFullMotifInfo(itemLink)
    local motifCategory = self:GetMotifCategory(itemLink)
    local isNew = self:IsNewMotif(itemLink)
    local isCraftable = self:IsMotifCraftable(itemLink)
    local isKnown = self:IsMotifKnown(itemLink)
    local isAvailable = self:IsMotifAvailable(itemLink)

    return motifCategory, isNew, isCraftable, isKnown, isAvailable
end


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--New functions by Baertram - 2020-08-22

--Get the style's category of LibMotifCategories
function lib:GetStyleCategory(styleId)
    if not styleId or not ESOStyleData[styleId] then return end
    return ESOStyleData[styleId][constants.STYLE_CATEGORY]
end


--Return if the style is a normale style category
function lib:IsNormalStyleCategory(styleId)
    return checkStyleCategoryEquals(styleId, ESOStyleData, constants.STYLE_CATEGORY, LMC_MOTIF_CATEGORY_NORMAL)
end


--Return if the style is a rare style category
function lib:IsRareStyleCategory(styleId)
    return checkStyleCategoryEquals(styleId, ESOStyleData, constants.STYLE_CATEGORY, LMC_MOTIF_CATEGORY_RARE)
end


--Return if the style is an alliance style category
function lib:IsAllianceStyleCategory(styleId)
    return checkStyleCategoryEquals(styleId, ESOStyleData, constants.STYLE_CATEGORY, LMC_MOTIF_CATEGORY_ALLIANCE)
end


--Return if the style is an exotic style category
function lib:IsExoticStyleCategory(styleId)
    return checkStyleCategoryEquals(styleId, ESOStyleData, constants.STYLE_CATEGORY, LMC_MOTIF_CATEGORY_EXOTIC)
end


--Return if the style is a dropped style category
function lib:IsDroppedStyleCategory(styleId)
    return checkStyleCategoryEquals(styleId, ESOStyleData, constants.STYLE_CATEGORY, LMC_MOTIF_CATEGORY_DROPPED)
end


--Return if the style is the crown style category
function lib:IsCrownStyleCategory(styleId)
    return checkStyleCategoryEquals(styleId, ESOStyleData, constants.STYLE_CATEGORY, LMC_MOTIF_CATEGORY_CROWN)
end


--Return the example itemId (3rd index of the table ESOStyleData) of a style
function lib:GetStyleItemId(styleId)
    if not ESOStyleData[styleId] then return end
    return ESOStyleData[styleId][constants.STYLE_EXAMPLE_ITEM_ID]
end


--Return the motifId (4th index of the table ESOStyleData) of a style
function lib:GetStyleMotifNumber(styleId)
    if not styleId then return end
    local motifId = ESOStyleData[styleId] and ESOStyleData[styleId][constants.STYLE_MOTIF_ID]
    motifId = motifId or 0
    return motifId
end


--Get the motif number of an itemStyle, extracted from an example item created for the style
function lib:GetMotifNumberOfStyle(styleId)
    local styleItemId = self:GetStyleItemId(styleId)
    if not styleItemId or styleItemId <= 0 then return end
    local itemLinkOfStyleItem = string.format(constants.styleItemLinkTemplate, styleItemId)
    local itemNameOfStyleId = ZO_CachedStrFormat(GetItemLinkName(itemLinkOfStyleItem))
    local motifNumber = itemNameOfStyleId:match("%d+")
    return motifNumber
end


--Return the bookId of a style (it's an itemId)
function lib:GetStyleBookItemId(styleId, isCrownBook)
    if not ESOStyleBookData[styleId] then return end
    isCrownBook = isCrownBook or false
    local bookTableIndexToUse = constants.STYLE_BOOK_ID
    if isCrownBook == true then
        bookTableIndexToUse = constants.STYLE_BOOK_CROWN_ID
    end
    return ESOStyleBookData[styleId][bookTableIndexToUse]
end


--Return if a style was learned completely (all items are craftable)
function lib:IsStyleKnownCompletely(styleId)
    return checkIfStyleIsKnown(styleId, nil, true)
end


--Return if a style was learned (1 chapter is craftable)
function lib:IsStyleKnown(styleId, chapter)
    return checkIfStyleIsKnown(styleId, chapter, false)
end


------------------------------------------------------------------------------------------------------------------------
--Library SavedVariables
------------------------------------------------------------------------------------------------------------------------
local function createSV()
    if svWasCreated == true then return end
    lib.sv = ZO_SavedVars:NewAccountWide(MAJOR .. "_SV", 0.1, "Debug", {}, GetWorldName(), "AllAccountsTheSame")
    if lib.sv ~= nil then svWasCreated = true end
end


------------------------------------------------------------------------------------------------------------------------
--Library Debugging
------------------------------------------------------------------------------------------------------------------------
--Create a SavedVariables subtable for the APIversion and a subtable in there for the styleIds, containing
--styleIndex, styleId, a table name containing the name of the stylId (in the current client language).
--This function will update the same table (if the APIVersion does not change) with the actual clientLanguage.
--Boolean parameter chatOutput defines if the styleIndex, styleId and styleName should be posted to the chat (true),
--or not (false)
function lib:DebugStyleIds(chatOutput)
    createSV()
    if not lib.sv then return end
    chatOutput = chatOutput or false
    --Build a table of the styleIds
    local lang = lib.lang or  GetCVar("language.2")
    local styleIdCount = 0
    local styleIds = {}
    local minStyleIndex = ITEMSTYLE_MIN_VALUE or 1
    if chatOutput == true then
        d(string.format("["..MAJOR.."]DebugStyleIds, lang: " ..tostring(lang)))
    end
    for i=minStyleIndex, getMaxItemStyleId(), 1 do
        local styleId = GetValidItemStyleId(i)
        if styleId > 0 then
            local styleName = GetItemStyleName(styleId)
            if lang ~= "en" then
                styleName = ZO_CachedStrFormat("<<C:1>>", styleName)
            end
            styleIds[i] = {
                index   = i,
                id      = styleId,
                name    = {
                   [lang] = styleName
                },
            }
            styleIdCount = styleIdCount + 1
            if chatOutput == true then
                d(string.format(">index: [%s], id: %s, name: %s", tostring(i), tostring(styleId), tostring(styleName)))
            end
        end
    end
    if styleIds and styleIdCount > 0 then
        --Create the APIVersion as table key or nil it
        lib.sv[APIVersion] = lib.sv[APIVersion] or {}
        lib.sv[APIVersion].StyleIds = lib.sv[APIVersion].StyleIds or {}
        local updatedNames = 0
        for styleIndex, styleData in pairs(styleIds) do
            if lib.sv[APIVersion].StyleIds[styleIndex] ~= nil then
                lib.sv[APIVersion].StyleIds[styleIndex].index   = styleData.index
                lib.sv[APIVersion].StyleIds[styleIndex].id      = styleData.id
                lib.sv[APIVersion].StyleIds[styleIndex].name    = lib.sv[APIVersion].StyleIds[styleIndex].name or {}
                lib.sv[APIVersion].StyleIds[styleIndex].name[lang] = styleData.name[lang]
                updatedNames = updatedNames + 1
            else
                lib.sv[APIVersion].StyleIds[styleIndex] = styleData
                updatedNames = updatedNames + 1
            end
        end
        d(string.format("["..MAJOR.."]>>> %s styleIds found! Updated %s names with the language \'%s\'", tostring(styleIdCount), tostring(updatedNames), tostring(lang)))
    else
        d("["..MAJOR.."]<<< No styleIds were found!")
    end
end


------------------------------------------------------------------------------------------------------------------------
--Library Initialization
------------------------------------------------------------------------------------------------------------------------
function lib:Initialize()
    --The localization data
    local strings = {
        ["de"] = {
            "Normal", "Selten", "Allianz", "Exotisch", "Erbeutet", "Kronen",
        },
        ["en"] = {
            "Normal", "Rare", "Alliance", "Exotic", "Dropped", "Crown",
        },
        ["es"] = {
            "Normal", "Raro", "Alianza", "Exótico", "Caído", "Corona",
        },
        ["fr"] = {
            "Normal", "Rare", "Alliance", "Exotique", "Looté", "Couronnes",
        },
        ["ru"] = {
            "Нормальный", "Редкий", "Альянс", "Экзотический", "Выпавший", "Корона",
        },
        ["jp"] = {
            "ノーマル", "レア", "アライアンス", "エキゾチック", "ドロップ", "クラウン",
        },
    }

    local lang = GetCVar("language.2")
    lib.lang = lang
    if strings[lang] then
        self.strings = strings[lang]
    else
        --Fallback language "English"
        self.strings = strings["en"]
    end

    --Update the table self.ESOStyleData with the 4th column "motifId"
    getMotifNumbersOfStyles()

    --Add the ranges of itemIds to the table "motifIdToItemStyleLookup" to lookup the itemStyles and motif info
    motifIdToItemStyleLookup:AddRange(57572, 57586,     ITEMSTYLE_AREA_DWEMER)
    motifIdToItemStyleLookup:AddRange(57590, 57604,     ITEMSTYLE_AREA_AKAVIRI)
    motifIdToItemStyleLookup:AddRange(57605, 57619,     ITEMSTYLE_AREA_YOKUDAN)
    motifIdToItemStyleLookup:AddRange(57834, 57848,     ITEMSTYLE_AREA_XIVKYN)
    motifIdToItemStyleLookup:AddRange(64669, 64684,     ITEMSTYLE_GLASS)
    motifIdToItemStyleLookup:AddRange(64715, 64730,     ITEMSTYLE_UNDAUNTED)
    motifIdToItemStyleLookup:AddRange(69527, 69542,     ITEMSTYLE_AREA_ANCIENT_ORC)
    motifIdToItemStyleLookup:AddRange(71522, 71537,     ITEMSTYLE_ORG_OUTLAW)
    motifIdToItemStyleLookup:AddRange(71550, 71565,     ITEMSTYLE_DEITY_TRINIMAC)
    motifIdToItemStyleLookup:AddRange(71566, 71581,     ITEMSTYLE_DEITY_MALACATH)
    motifIdToItemStyleLookup:AddRange(71672, 71687,     ITEMSTYLE_AREA_RA_GADA)
    motifIdToItemStyleLookup:AddRange(71688, 71703,     ITEMSTYLE_ALLIANCE_ALDMERI)
    motifIdToItemStyleLookup:AddRange(71704, 71719,     ITEMSTYLE_ALLIANCE_DAGGERFALL)
    motifIdToItemStyleLookup:AddRange(71720, 71735,     ITEMSTYLE_ALLIANCE_EBONHEART)
    motifIdToItemStyleLookup:AddRange(73838, 73853,     ITEMSTYLE_ORG_MORAG_TONG)
    motifIdToItemStyleLookup:AddRange(73854, 73869,     ITEMSTYLE_HOLIDAY_SKINCHANGER)
    motifIdToItemStyleLookup:AddRange(74539, 74554,     ITEMSTYLE_ORG_ABAHS_WATCH)
    motifIdToItemStyleLookup:AddRange(74555, 74570,     ITEMSTYLE_ORG_THIEVES_GUILD)
    motifIdToItemStyleLookup:AddRange(74652, 74667,     ITEMSTYLE_ENEMY_DROMOTHRA)
    motifIdToItemStyleLookup:AddRange(75228, 75243,     ITEMSTYLE_EBONY)
    motifIdToItemStyleLookup:AddRange(76878, 76893,     ITEMSTYLE_ORG_ASSASSINS)
    motifIdToItemStyleLookup:AddRange(76894, 76909,     ITEMSTYLE_ENEMY_DRAUGR)
    motifIdToItemStyleLookup:AddRange(82006, 82021,     ITEMSTYLE_RAIDS_CRAGLORN)
    motifIdToItemStyleLookup:AddRange(82022, 82037,     ITEMSTYLE_HOLIDAY_HOLLOWJACK)
    motifIdToItemStyleLookup:AddRange(82038, 82038,     ITEMSTYLE_HOLIDAY_GRIM_HARLEQUIN)
    motifIdToItemStyleLookup:AddRange(82054, 82069,     ITEMSTYLE_ORG_DARK_BROTHERHOOD)
    motifIdToItemStyleLookup:AddRange(82071, 82086,     ITEMSTYLE_ENEMY_MINOTAUR)
    motifIdToItemStyleLookup:AddRange(82087, 82102,     ITEMSTYLE_DEITY_AKATOSH)
    motifIdToItemStyleLookup:AddRange(82103, 82116,     ITEMSTYLE_HOLIDAY_HOLLOWJACK)
    motifIdToItemStyleLookup:AddRange(96954, 96954,     ITEMSTYLE_HOLIDAY_FROSTCASTER)
    motifIdToItemStyleLookup:AddRange(114951, 114956,   ITEMSTYLE_ENEMY_MAZZATUN)
    motifIdToItemStyleLookup:AddRange(114967, 114982,   ITEMSTYLE_ENEMY_SILKEN_RING)
    motifIdToItemStyleLookup:AddRange(121316, 121331,   ITEMSTYLE_ORG_BUOYANT_ARMIGER)
    motifIdToItemStyleLookup:AddRange(121332, 121347,   ITEMSTYLE_ORG_TELVANNI)
    motifIdToItemStyleLookup:AddRange(121348, 121363,   ITEMSTYLE_ORG_ORDINATOR)
    motifIdToItemStyleLookup:AddRange(124679, 124694,   ITEMSTYLE_AREA_ASHLANDER)
    --TODO: Add new ones for all the DLCs after Worm Cult etc.
end

--Initialize the library
lib:Initialize()