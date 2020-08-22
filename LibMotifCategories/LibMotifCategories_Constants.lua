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
-- Global constants
------------------------------------------------------------------------------------------------------------------------
LMC_MOTIF_CATEGORY_NORMAL   = 1
LMC_MOTIF_CATEGORY_RARE     = 2
LMC_MOTIF_CATEGORY_ALLIANCE = 3
LMC_MOTIF_CATEGORY_EXOTIC   = 4
LMC_MOTIF_CATEGORY_DROPPED  = 5
LMC_MOTIF_CATEGORY_CROWN    = 6


------------------------------------------------------------------------------------------------------------------------
-- Constants internally for the library
------------------------------------------------------------------------------------------------------------------------
--Indices of the ESOStyles data table
lib.CONSTANTS = {}
local constants = lib.CONSTANTS

--Styles
constants.STYLE_CATEGORY                = 1
constants.STYLE_ACHIEVEMENT_ID          = 2
constants.STYLE_EXAMPLE_ITEM_ID         = 3
constants.STYLE_MOTIF_ID                = 4
--Style books
constants.STYLE_BOOK_ID                 = 1
constants.STYLE_BOOK_CHAPTER_ID         = 2
constants.STYLE_BOOK_CROWN_ID           = 3
constants.STYLE_BOOK_CHAPTER_CROWN_ID   = 4

--Maximum chapters of a book
constants.MAX_STYLE_BOOK_CHAPTERS       = 14

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
