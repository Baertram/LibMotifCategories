------------------------------------------------------------------------------------------------------------------------
--Library name and version
------------------------------------------------------------------------------------------------------------------------
local MAJOR, MINOR = "LibMotifCategories", 4
--Omly load once check
if _G[MAJOR] ~= nil then
    if _G[MAJOR].version and _G[MAJOR].version >= MINOR then
        d("["  ..MAJOR.. "]Library already loaded with version " ..tostring(_G[MAJOR].version))
    else
        d("[" ..MAJOR.. "]Library already loaded")
    end
    return
end
local lib = {}
lib.name    = MAJOR
lib.version = MINOR


------------------------------------------------------------------------------------------------------------------------
-- When was the data table updated the last time, so what is the "comparison APIVersion for the new" checks?
------------------------------------------------------------------------------------------------------------------------
local lastAPIVersionBaseForNewCheck = '100031' -- Greymoor
lib.lastAPIVersionBaseForNewCheck = lastAPIVersionBaseForNewCheck


------------------------------------------------------------------------------------------------------------------------
-- Global constants
------------------------------------------------------------------------------------------------------------------------
LMC_MOTIF_CATEGORY_NORMAL   = 1
LMC_MOTIF_CATEGORY_RARE     = 2
LMC_MOTIF_CATEGORY_ALLIANCE = 3
LMC_MOTIF_CATEGORY_EXOTIC   = 4
LMC_MOTIF_CATEGORY_DROPPED  = 5
LMC_MOTIF_CATEGORY_CROWN    = 6
LMC_MOTIF_CATEGORY_EVENT    = 7


------------------------------------------------------------------------------------------------------------------------
-- Constants internally for the library
------------------------------------------------------------------------------------------------------------------------
--Indices of the ESOStyles data table
lib.CONSTANTS = {}
local constants = lib.CONSTANTS

--Styles
constants.ITEMSTYLE_UNKNOWN                 = -1
constants.MOTIF_UNKNOWN                     = -1
constants.ITEMID_UNKNOWN                    = -1

constants.STYLE_CATEGORY                    = 1
constants.STYLE_ACHIEVEMENT_ID              = 2
constants.STYLE_EXAMPLE_ITEM_ID             = 3
constants.STYLE_BOOK_ITEM_ID                = 4
constants.STYLE_BOOK_CHAPTER_ITEM_ID        = 5
constants.STYLE_BOOK_CROWN_ITEM_ID          = 6
constants.STYLE_BOOK_CHAPTER_CROWN_ITEM_ID  = 7
constants.STYLE_MOTIF_ID                    = 8
constants.STYLE_APIVERSION                  = 9

--Maximum chapters of a book
constants.MAX_STYLE_BOOK_CHAPTERS           = ITEM_STYLE_CHAPTER_BOWS --or 14

--Template string of an itemlink used to create an item of the style
constants.styleItemLinkTemplate     = "|H1:item:%u:6:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
constants.styleItemLinkTemplateEpic = "|H1:item:%u:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h"
constants.styleItemLinkItemTemplate = '|H1:item:%u:370:50:0:0:0:0:0:0:0:0:0:0:0:0:%u:0:0:0:10000:0|h|h'


------------------------------------------------------------------------------------------------------------------------
-- Library instance function
------------------------------------------------------------------------------------------------------------------------
function lib:GetLibInstance()
    return self
end


------------------------------------------------------------------------------------------------------------------------
-- Global variable "LibMotifCategories"
------------------------------------------------------------------------------------------------------------------------
_G[MAJOR] = lib
