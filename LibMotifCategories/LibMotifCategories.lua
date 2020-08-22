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

local constants                 = lib.CONSTANTS
local ESOStyleData              = lib.ESOStyleData
local ESOStyleBookData          = lib.ESOStyleBookData

local motifIdToItemStyleLookup  = lib.motifIdToItemStyleLookup
local categoryLookup            = lib.categoryLookup
local newLookup                 = lib.newLookup


------------------------------------------------------------------------------------------------------------------------
--Local helper functions
------------------------------------------------------------------------------------------------------------------------
local function getMaxItemStyleId()
    local maxItemStyleId = GetHighestItemStyleId()
    local maxAlternativeValue = GetNumValidItemStyles()
    if maxAlternativeValue > maxItemStyleId then maxItemStyleId = maxAlternativeValue end
    return maxItemStyleId
end


-- motifItemId is the itemId which will be used to compare with table "motifIdToItemStyleLookup" 's list of itemIds
-- which were added via "AddRange" function to this table (see initialization of the library)
local function GetMotifItemIdByItemLink(itemLink)
    if itemLink == nil or itemLink == "" then return -1 end
    local motifItemId = GetItemLinkItemId(itemLink) or select(4, ZO_LinkHandler_ParseLink(itemLink))
    return motifItemId
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
--"New" means it was added after the APIVersion saved in lib.lastAPIVersionBaseForNewCheck
-->Entries added later will be added to table lib.newLookup automatically at the start of the addon,
-->based on the APIVersionAdded parameter 5 in table lib.ESOStyleData[5]
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
    local bookTableIndexToUse = constants.STYLE_BOOK_ITEM_ID
    if isCrownBook == true then
        bookTableIndexToUse = constants.STYLE_BOOK_CROWN_ITEM_ID
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
    lib:updateMotifNumbersOfStyles()

    --Add the ranges of itemIds of the styles to the internal lookup table
    lib:addItemIdsOfStylesToInternalLookupTables()
end

--Initialize the library
lib:Initialize()