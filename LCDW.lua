----------------------------------------------------------
----/////////////////////// VARS ///////////////////////--
----------------------------------------------------------
local name, addonNamespace = ...
addonNamespace.Helpers = {}
addonNamespace.UIElements = {}

local Helpers = addonNamespace.Helpers
local UIElements = addonNamespace.UIElements

local customAddonName = "Le codex de Willios"
local addonVersion = "0.6 Alpha"

local INITIAL_RATIO = 1.43016759777
local MAIN_FRAME_WITH = 1024
local MAIN_FRAME_HEIGHT = MAIN_FRAME_WITH / INITIAL_RATIO
local FRAME_TITLE_CONTAINER_WIDTH = 100
local FRAME_TITLE_CONTAINER_HEIGHT = 30
local GUIDE_WIDTH = 850
local GUIDE_HEIGHT = 850
local PVE_FOLDER_PATH = "Interface\\AddOns\\LCDW\\guides\\pve\\"
local PVP_FOLDER_PATH = "Interface\\AddOns\\LCDW\\guides\\pvp\\"
local GLOSSARY_FOLDER_PATH = "Interface\\AddOns\\LCDW\\guides\\glossary\\"
local MINIMAP_ICON_PATH = "Interface\\AddOns\\LCDW\\misc\\minimap-icon"
local DUNGEONS_ICONS_PATH = "Interface\\ENCOUNTERJOURNAL\\UI-EJ-DUNGEONBUTTON-"
local CLASSES_ICONS_PATH = "Interface\\ICONS\\ClassIcon_"
local ARROW_TITLE_SECTION = "Interface\\RAIDFRAME\\UI-RAIDFRAME-ARROW"
local QUESTIONMARK_PATH = "Interface\\Calendar\\EventNotification"
local PVP_ICON = "Interface\\Calendar\\UI-Calendar-Event-PVP"
local PVE_ICON = "Interface\\LFGFRAME\\UI-LFG-ICON-HEROIC"
local DUNGEON_THUMBNAIL_PATH = "Interface\\LFGFRAME\\LFGIcon-"
local SOCIAL_NETWORK_FOLDER_PATH = "Interface\\AddOns\\LCDW\\misc\\social-networks\\"
local NAME_COL = 1
local ICON_COL = 2
local DUNGEON_THUMBNAIL_COL = 3
local _, _, _, TOC_VERSION = GetBuildInfo()

local GREEN = "|cff00ff00"
local YELLOW = "|cffffff00"
local RED = "|cffff0000"
local BLUE = "|cff0198e1"
local ORANGE = "|cffff9933"
local WHITE = "|cffffffff"

local SOCIAL_NETWORK_TEXT = "Pour me suivre : "
local CREDITS_TEST = "Made by Aecx & Willios"

local textureShown = {}
local dungeonsFrames = {}
local classesFrames = {}

local pveGuidesTextures = {}
local pvpGuidesTextures = {}
local glossaryTextures = {}

local dungeons = {
    { "Sillage nécrotique", DUNGEONS_ICONS_PATH .. "NecroticWake", DUNGEON_THUMBNAIL_PATH .. "NecroticWake" },
    { "Malepeste", DUNGEONS_ICONS_PATH .. "Plaguefall", DUNGEON_THUMBNAIL_PATH .. "Plaguefall" },
    { "Brumes de Tirna Scrithe", DUNGEONS_ICONS_PATH .. "MistsofTirnaScithe", DUNGEON_THUMBNAIL_PATH .. "MistsofTirnaScithe" },
    { "Salles de l'Expiation", DUNGEONS_ICONS_PATH .. "HallsofAtonement", DUNGEON_THUMBNAIL_PATH .. "HallsofAtonement" },
    { "Flèches de l'Ascension", DUNGEONS_ICONS_PATH .. "SpiresofAscension", DUNGEON_THUMBNAIL_PATH .. "SpiresofAscension" },
    { "Théâtre de la Souffrance", DUNGEONS_ICONS_PATH .. "TheaterofPain", DUNGEON_THUMBNAIL_PATH .. "TheaterofPain" },
    { "L'Autre côté", DUNGEONS_ICONS_PATH .. "TheOtherSide", DUNGEON_THUMBNAIL_PATH .. "TheOtherSide" },
    { "Profondeurs Sanguines", DUNGEONS_ICONS_PATH .. "SanguineDepths", DUNGEON_THUMBNAIL_PATH .. "SanguineDepths" }
}
local classes = {
    { "Chaman", CLASSES_ICONS_PATH .. "Shaman" },
    { "Chasseur", CLASSES_ICONS_PATH .. "Hunter" },
    { "Chasseur de Démon", CLASSES_ICONS_PATH .. "DemonHunter" },
    { "Chevalier de la Mort", CLASSES_ICONS_PATH .. "DeathKnight" },
    { "Démoniste", CLASSES_ICONS_PATH .. "Warlock" },
    { "Druide", CLASSES_ICONS_PATH .. "Druid" },
    { "Guerrier", CLASSES_ICONS_PATH .. "Warrior" },
    { "Mage", CLASSES_ICONS_PATH .. "Mage" },
    { "Moine", CLASSES_ICONS_PATH .. "Monk" },
    { "Paladin", CLASSES_ICONS_PATH .. "Paladin" },
    { "Prêtre", CLASSES_ICONS_PATH .. "Priest" },
    { "Voleur", CLASSES_ICONS_PATH .. "Rogue" }
}

local isGuideSelected = false
local isGuideTextureCreated = false
local isContextMenuOpen = false
local titleWidth
local textureWidth

-- folders data --
local foldersItemsNb = {
    pve = {
        d1 = 3,
        d2 = 3,
        d3 = 3,
        d4 = 3,
        d5 = 3,
        d6 = 3,
        d7 = 3,
        d8 = 3,
    },
    pvp = {
        c1 = 3,
        c2 = 3,
        c3 = 3,
        c4 = 3,
        c5 = 3,
        c6 = 3,
        c7 = 3,
        c8 = 3,
        c9 = 3,
        c10 = 3,
        c11 = 3,
        c12 = 3,
    },
    glossary = 6
}

local LCDW = LibStub("AceAddon-3.0"):NewAddon("LCDW", "AceConsole-3.0")
local icon = LibStub("LibDBIcon-1.0")
local defaults = {
    profile = {
        minimapOption = {
            hide = false
        }
    }
}

-- namespace's functions --
-- HELPERS --
function Helpers:degreesToRadians(angle)
    return angle * 0.0174533
end

function Helpers:hexadecimalToBlizzardColor(hexaNumber)
    return hexaNumber / 255
end

-- UI ELEMENTS --
function UIElements:CreateFontString(frameName, frameToAttach, font, width, height, point, relativePoint, ofsx, ofsy, text, r, g, b, getWidth)
    local fontColor
    local alpha = 1

    frameName = frameToAttach:CreateFontString(nil, "OVERLAY")
    frameName:SetFontObject(font)

    if width then
        frameName:SetWidth(width)
    end

    if height then
        frameName:SetHeight(height)
    end

    frameName:SetText(text)

    if getWidth then
        titleWidth = frameName:GetWidth()
    end

    if r and g and b then
        fontColor = frameName:GetFontObject():SetTextColor(Helpers:hexadecimalToBlizzardColor(r), Helpers:hexadecimalToBlizzardColor(g), Helpers:hexadecimalToBlizzardColor(b), alpha)
        frameName:SetFontObject(fontColor)
    end

    frameName:SetPoint(point, frameToAttach, relativePoint, ofsx, ofsy)
end

function UIElements:CreateTexture(textureName, frameToAttach, width, height, point, relativePoint, ofsx, ofsy, texture, getWidth)
    textureName = frameToAttach:CreateTexture(nil, "ARTWORK")
    textureName:SetSize(width, height)
    textureName:SetPoint(point, frameToAttach, relativePoint, ofsx, ofsy)
    textureName:SetTexture(texture)
    if getWidth then
        textureWidth = textureName:GetWidth()
    end
end
----------------------------------------------------------
----///////////////////// END VARS /////////////////////--
----------------------------------------------------------

local function initTextureShown()
    for dungeonId, v in ipairs(dungeons) do
        textureShown["isTexture" .. dungeonId .. "Shown"] = false
    end
end

local function onEvent(self, event, arg1, ...)
    if (event == "ADDON_LOADED" and name == arg1) then
        initTextureShown()
        print(BLUE .. customAddonName .. "|r chargé ! Tapez /lcdw ou cliquez sur le bouton de la minimap pour accéder aux guides.")
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", onEvent)
----------------------------------------------------------
----/////////////// MAIN FRAME (Général) ///////////////--
----------------------------------------------------------
local LCDWFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame:Hide()
LCDWFrame:SetSize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
LCDWFrame:SetPoint("CENTER", 0, 0)
LCDWFrame:SetMovable(true)
LCDWFrame:SetClampedToScreen(true)
LCDWFrame:SetFrameStrata("DIALOG")
LCDWFrame:SetResizable(true)
LCDWFrame:EnableMouse(true)
LCDWFrame:SetMinResize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
LCDWFrame:RegisterForDrag("LeftButton")
LCDWFrame:SetScript("OnDragStart", LCDWFrame.StartMoving)
LCDWFrame:SetScript("OnDragStop", LCDWFrame.StopMovingOrSizing)
--LCDWFrame:SetBackdrop({
--    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
--    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 0, edgeSize = 0,
--    insets = { left = 30, right = 30, top = 30, bottom = 30 }
--})

local function createBorder(frameToAttach, isACorner, borderSide, frameName, point, relativePoint, ofsx, ofsy)

    local width = (isACorner) and 100 or 256
    local height = 7
    local frameToAttach = frameToAttach

    local coord = {
        right = (isACorner) and 0.565 or 1,
        top = (isACorner) and 0.5 or 0.467,
        bottom = (isACorner) and 0.545 or 0.5
    }
    local borderSideTextureAngle = {
        top = Helpers:degreesToRadians(-180),
        left = Helpers:degreesToRadians(-90),
        right = Helpers:degreesToRadians(90),
    }

    frameName = frameToAttach:CreateTexture(nil, "BACKGROUND")
    frameName:SetTexture("Interface\\Calendar\\CALENDARFRAME_TOPANDBOTTOM")
    frameName:SetPoint(point, frameToAttach, relativePoint, ofsx, ofsy)
    frameName:SetSize(width, height)
    frameName:SetTexCoord(0, coord["right"], coord["top"], coord["bottom"])

    if borderSide ~= "bottom" then
        frameName:SetRotation(borderSideTextureAngle[borderSide])
    end
end
-- corner border textures --
createBorder(LCDWFrame, true, "left", LCDWFrame.leftBottomBorderCorner, "BOTTOMLEFT", "BOTTOMLEFT", -53, 40)
createBorder(LCDWFrame, true, "top", LCDWFrame.topLeftBorderCorner, "TOPLEFT", "TOPLEFT", -5, 7)
createBorder(LCDWFrame, true, "right", LCDWFrame.rightTopBorderCorner, "TOPRIGHT", "TOPRIGHT", 52.5, -40)
createBorder(LCDWFrame, true, "bottom", LCDWFrame.bottomRightBorderCorner, "BOTTOMRIGHT", "BOTTOMRIGHT", 5, -7)
-- side border textures --
-- LEFT --
createBorder(LCDWFrame, false, "left", LCDWFrame.leftBorder, "LEFT", "LEFT", -130, -30)
createBorder(LCDWFrame, false, "left", LCDWFrame.leftBorderTwo, "LEFT", "LEFT", -130, 124)
-- TOP --
createBorder(LCDWFrame, false, "top", LCDWFrame.topBorder, "TOP", "TOP", -135, 6)
createBorder(LCDWFrame, false, "top", LCDWFrame.topBorderTwo, "TOP", "TOP", 121, 6)
createBorder(LCDWFrame, false, "top", LCDWFrame.topBorderThree, "TOP", "TOP", 230, 6)
-- RIGHT --
createBorder(LCDWFrame, false, "right", LCDWFrame.rightBorder, "RIGHT", "RIGHT", 129, 30)
createBorder(LCDWFrame, false, "right", LCDWFrame.rightBorderTwo, "RIGHT", "RIGHT", 129, -125)
-- BOTTOM --
createBorder(LCDWFrame, false, "bottom", LCDWFrame.bottomBorder, "BOTTOMLEFT", "BOTTOMLEFT", 0, -6)
createBorder(LCDWFrame, false, "bottom", LCDWFrame.bottomBorderTwo, "BOTTOMLEFT", "BOTTOMLEFT", 256, -6)
createBorder(LCDWFrame, false, "bottom", LCDWFrame.bottomBorderThree, "BOTTOMLEFT", "BOTTOMLEFT", 380, -6)
--------------------------------
-----//  second main frame //---
--------------------------------
-- background container frame --
LCDWFrame.backgroundContainerFrame = CreateFrame("Frame", nil, LCDWFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.backgroundContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
LCDWFrame.backgroundContainerFrame:SetAllPoints()
-- background texture --
LCDWFrame.backgroundContainerFrame.mainBackground = LCDWFrame.backgroundContainerFrame:CreateTexture(nil, "BACKGROUND")
LCDWFrame.backgroundContainerFrame.mainBackground:SetTexture("Interface\\ENCOUNTERJOURNAL\\DungeonJournalTierBackgrounds4")
LCDWFrame.backgroundContainerFrame.mainBackground:SetAllPoints()
LCDWFrame.backgroundContainerFrame.mainBackground:SetSize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
LCDWFrame.backgroundContainerFrame.mainBackground:SetTexCoord(0.42, 0.73, 0, 0.4)

-- title container --
LCDWFrame.backgroundContainerFrame.titleContainerFrame = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame, "GlowBoxTemplate")
LCDWFrame.backgroundContainerFrame.titleContainerFrame:SetPoint("CENTER", LCDWFrame, "TOP", 0, 0)
-- title --
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.titleContainerFrame.title, LCDWFrame.backgroundContainerFrame.titleContainerFrame, "ItemTextFontNormal", false, false, "CENTER", "CENTER", 0, 0, "Le codex de Willios", 255, 255, 255, true)
LCDWFrame.backgroundContainerFrame.titleContainerFrame:SetSize(titleWidth + 30, FRAME_TITLE_CONTAINER_HEIGHT)
-- scroll frame --
LCDWFrame.backgroundContainerFrame.scrollFrame = CreateFrame("ScrollFrame", nil, LCDWFrame.backgroundContainerFrame, "UIPanelScrollFrameTemplate")
-- scrollable zone size --
LCDWFrame.backgroundContainerFrame.scrollFrame:SetPoint("TOPLEFT", LCDWFrame.backgroundContainerFrame, "TOPLEFT", 4, -105)
LCDWFrame.backgroundContainerFrame.scrollFrame:SetPoint("BOTTOMRIGHT", LCDWFrame.backgroundContainerFrame, "BOTTOMRIGHT", -3, 35)
LCDWFrame.backgroundContainerFrame.scrollFrame:SetClipsChildren(true)
LCDWFrame.backgroundContainerFrame.scrollFrame:Hide()
-- close button --
LCDWFrame.backgroundContainerFrame.CloseButton = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame, "UIPanelCloseButton")
LCDWFrame.backgroundContainerFrame.CloseButton:SetPoint("CENTER", LCDWFrame.backgroundContainerFrame, "TOPRIGHT", -20, -20)
LCDWFrame.backgroundContainerFrame.CloseButton:SetScript("OnClick", function(self, Button, Down)
    LCDWFrame:Hide()
end)
-- social networks container --
LCDWFrame.backgroundContainerFrame.socialNetworks = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.backgroundContainerFrame.socialNetworks:SetSize(LCDWFrame:GetWidth(), 29)
LCDWFrame.backgroundContainerFrame.socialNetworks:SetPoint("BOTTOM", LCDWFrame.backgroundContainerFrame, "BOTTOM", 0, 0)
LCDWFrame.backgroundContainerFrame.socialNetworks:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
-- social networks text --
local leftSpace = 5

UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.text0, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlight", false, false, "LEFT", "LEFT", leftSpace, 0, SOCIAL_NETWORK_TEXT, nil, nil, nil, true)
leftSpace = leftSpace + titleWidth
UIElements:CreateTexture(LCDWFrame.backgroundContainerFrame.socialNetworks.twitch, LCDWFrame.backgroundContainerFrame.socialNetworks, 18, 18, "LEFT", "LEFT", leftSpace, 0, SOCIAL_NETWORK_FOLDER_PATH .. "twitch", true)
leftSpace = leftSpace + textureWidth + 3
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.text1, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlight", false, false, "LEFT", "LEFT", leftSpace, 0, "/williosz", nil, nil, nil, true)
leftSpace = leftSpace + titleWidth + 10
UIElements:CreateTexture(LCDWFrame.backgroundContainerFrame.socialNetworks.twitter, LCDWFrame.backgroundContainerFrame.socialNetworks, 21, 21, "LEFT", "LEFT", leftSpace, 0, SOCIAL_NETWORK_FOLDER_PATH .. "twitter", true)
leftSpace = leftSpace + textureWidth
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.text2, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlight", false, false, "LEFT", "LEFT", leftSpace, 0, "@williosx", nil, nil, nil, true)
leftSpace = leftSpace + titleWidth + 10
UIElements:CreateTexture(LCDWFrame.backgroundContainerFrame.socialNetworks.discord, LCDWFrame.backgroundContainerFrame.socialNetworks, 18, 18, "LEFT", "LEFT", leftSpace, 0, SOCIAL_NETWORK_FOLDER_PATH .. "discord", true)
leftSpace = leftSpace + textureWidth + 5
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.text3, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlight", false, false, "LEFT", "LEFT", leftSpace, 0, "/SmZfhAG", nil, nil, nil, true)
leftSpace = leftSpace + titleWidth + 10
UIElements:CreateTexture(LCDWFrame.backgroundContainerFrame.socialNetworks.website, LCDWFrame.backgroundContainerFrame.socialNetworks, 18, 18, "LEFT", "LEFT", leftSpace, 0, SOCIAL_NETWORK_FOLDER_PATH .. "op", true)
leftSpace = leftSpace + textureWidth + 5
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.text4, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlight", false, false, "LEFT", "LEFT", leftSpace, 0, "bazardewillios.fr", nil, nil, nil, true)
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.text5, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlight", false, false, "RIGHT", "RIGHT", -5, 0, CREDITS_TEST)
--------------------------------
------// third main frame //----
--------------------------------
-- this frame contains all the dungeons and classes thumbnails + the frames titles (guides pve / pvp) --
-- it will be easier to hide all elements when a dungeons is selected --
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:SetPoint("CENTER", LCDWFrame, "CENTER")
-- create a section name container --
local function createSectionNameContainer(frameName, frameToAttach, point, relativePoint, ofsx, ofsy, title, icon, iconWidth, iconHeight, iconOfsx, iconOfsy)
    local titleIcon

    if icon == "blank" then
        titleIcon = nil
    elseif icon and icon ~= "blank" then
        titleIcon = icon
    else
        titleIcon = ARROW_TITLE_SECTION
    end
    -- dungeons section name container --
    frameName = CreateFrame("Frame", nil, frameToAttach, BackdropTemplateMixin and "BackdropTemplate")
    frameName:SetSize(225, 44)
    frameName:SetPoint(point, frameToAttach, relativePoint, ofsx, ofsy)
    frameName:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    })
    -- arrow on the left of the container --
    frameName.arrowTitle = CreateFrame("Frame", nil, frameName, BackdropTemplateMixin and "BackdropTemplate")
    frameName.arrowTitle:SetSize(iconWidth and iconWidth or 0, iconHeight and iconHeight or 0)
    frameName.arrowTitle:SetPoint("LEFT", frameName, "LEFT", iconOfsx and iconOfsx or 0, iconOfsy and iconOfsy or 0)
    frameName.arrowTitle:SetBackdrop({
        bgFile = titleIcon
    })
    -- dungeons section name --
    UIElements:CreateFontString(frameName.sectionTitle, frameName, "GameFontHighLight", false, false, "CENTER", "CENTER", 0, 0, title)
end
createSectionNameContainer(LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.dungeonsSectionNameContainer, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "LEFT", "TOPLEFT", 42, -93, "Guides des donjons", PVE_ICON, 25, 25, 17, -5)
createSectionNameContainer(LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.classesSectionNameContainer, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "LEFT", "LEFT", 42, -76, "Guides des classes", PVP_ICON, 17, 17, 17, 0)
-- glossary frame --
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame = CreateFrame("BUTTON", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetSize(110, 30)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetPoint("TOPRIGHT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "TOPRIGHT", -50, -75)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetScript("OnClick", function()
    LCDWFrame.backgroundContainerFrame:showGuide(true, "Glossaire", nil, "glossary", "glossary")
end)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame.icon = LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:CreateTexture(nil, "ARTWORK")
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame.icon:SetSize(30, 30)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame.icon:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame, "LEFT", 10, 0)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame.icon:SetTexture(QUESTIONMARK_PATH)
UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame.title, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame, "GameFontHighLight", false, false, "LEFT", "LEFT", 40, 0, "Glossaire")
--------------------------------
--// third main frame prime //--
--------------------------------
local function openContextMenu(pageNumber)
    local openContextMenuButton = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton
    openContextMenuButton.dropDown = CreateFrame("Frame", "GlossaryMenu", openContextMenuButton, "UIDropDownMenuTemplate")

    UIDropDownMenu_Initialize(openContextMenuButton.dropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()

        -- first lvl menu --
        if (level or 1) == 1 then
            info.isTitle = 1
            info.text = "Sommaire"
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, level)

            info.disabled = nil
            info.isTitle = nil

            for i = 1, pageNumber do
                info.func = function()
                    local scrollFrame = LCDWFrame.backgroundContainerFrame.scrollFrame
                    scrollFrame:SetVerticalScroll((i - 1) * (GUIDE_HEIGHT + 20))
                    isContextMenuOpen = false
                end
                info.text, info.checked = "Page " .. i, false
                info.hasArrow = false
                info.notCheckable = 1
                UIDropDownMenu_AddButton(info, level)
            end

            -- Close menu item
            info.hasArrow = nil
            info.value = nil
            info.notCheckable = 1
            info.text = CLOSE
            info.func = function()
                CloseDropDownMenus()
                isContextMenuOpen = false
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end, "MENU")
    ToggleDropDownMenu(1, nil, openContextMenuButton.dropDown, openContextMenuButton, 3, 5)
end

-- this function creates the frame displayed when a dungeon is selected
function LCDWFrame.backgroundContainerFrame:showGuide(icon, name, id, thumbnailCategory, guideType)
    local iconWidth = 30
    local iconHeight = 30
    local scrollFrame = LCDWFrame.backgroundContainerFrame.scrollFrame
    isGuideSelected = true

    -- everytime a guide is loaded, reset the scroll --
    if scrollFrame:GetVerticalScroll() > 0 then
        scrollFrame:SetVerticalScroll(0)
    end

    -- hide all the homepage elements --
    LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:Hide()
    -- show the scroll frame --
    LCDWFrame.backgroundContainerFrame.scrollFrame:Show()
    -- parent frame that appears after selecting a guide, it contains the title and the guide selected --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:SetPoint("CENTER", LCDWFrame.backgroundContainerFrame, "CENTER")
    -- reset function which does hide everyframe but the homepage frame --
    function LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:resetAll()
        isContextMenuOpen = false
        -- hide the guide texture
        if isGuideTextureCreated then
            if LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:IsShown() then
                LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:Hide()
            end
        end
        -- hide the scroll frame --
        if LCDWFrame.backgroundContainerFrame.scrollFrame:IsShown() then
            LCDWFrame.backgroundContainerFrame.scrollFrame:Hide()
        end
        -- hide guide currently displayed --
        if isGuideSelected then
            if LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:IsShown() then
                LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:Hide()
                isGuideSelected = false
            end
        end
        -- show the homepage --
        if not LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:IsShown() then
            LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:Show()
        end
    end
    -- reset button --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.resetButton = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "UIPanelButtonTemplate")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.resetButton:SetSize(100, 30)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.resetButton:SetPoint("TOPRIGHT", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "TOPRIGHT", -80, -11)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.resetButton:SetText("Accueil")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.resetButton:SetScript("OnClick", function()
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:resetAll()
    end)
    -- title and icon container --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer:SetPoint("TOPLEFT", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "TOPLEFT", 0, 0)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    })
    -- icon --
    if icon then
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.icon = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer:CreateTexture(nil, "ARTWORK")
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.icon:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer, "LEFT", 10, 0)
        if thumbnailCategory == "glossary" then
            LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.icon:SetTexture(QUESTIONMARK_PATH)
        elseif thumbnailCategory == "class" then
            LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.icon:SetTexture(classes[id][ICON_COL])
        else
            LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.icon:SetTexture(dungeons[id][DUNGEON_THUMBNAIL_COL])
        end
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.icon:SetSize(iconWidth, 30)
    end
    -- title --
    UIElements:CreateFontString(LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.title, LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer, "GameFontHighlightLarge", false, false, "LEFT", "LEFT", iconWidth + 20, 0, name, nil, nil, nil, true)
    -- open context menu icon --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer, BackdropTemplateMixin and "BackdropTemplate")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:SetSize(35, 35)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer, "LEFT", titleWidth + iconWidth + 20, -1)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    -- open context menu icon hover --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.Hover = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:CreateTexture(nil, "BACKGROUND")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.Hover:SetTexture("Interface\\Buttons\\CheckButtonGlow")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.Hover:SetAllPoints(LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.Hover:SetAlpha(0)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:SetScript("OnEnter", function()
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.Hover:SetAlpha(1)
    end);
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:SetScript("OnLeave", function()
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.Hover:SetAlpha(0)
    end);
    -- click handler --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:SetScript("OnClick", function()
        if isContextMenuOpen then
            LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton.dropDown:Hide()
            isContextMenuOpen = false
        else
            isContextMenuOpen = true
            if guideType == "pve" then
                openContextMenu(foldersItemsNb[guideType]["d" .. id])
            elseif guideType == "pvp" then
                openContextMenu(foldersItemsNb[guideType]["c" .. id])
            else
                openContextMenu(foldersItemsNb[guideType])
            end
        end
    end)

    local arrowIconWidth = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer.openContextMenuButton:GetWidth()
    -- title container size --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.titleContainer:SetSize(titleWidth + iconWidth + 25 + arrowIconWidth, 50)
    -- guide frame --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.scrollFrame)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight() - 100)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:SetPoint("BOTTOM", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "BOTTOM")
    -- core image --
    LCDWFrame.backgroundContainerFrame:generateGuides(guideType, id)

    isGuideTextureCreated = true
    -- set the scroll child to be able to scroll --
    LCDWFrame.backgroundContainerFrame.scrollFrame:SetScrollChild(LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame)
    LCDWFrame.backgroundContainerFrame.scrollFrame.ScrollBar:ClearAllPoints()
    -- scrollbar element size --
    LCDWFrame.backgroundContainerFrame.scrollFrame.ScrollBar:SetPoint("TOPLEFT", LCDWFrame.backgroundContainerFrame.scrollFrame, "TOPRIGHT", -12, -15)
    LCDWFrame.backgroundContainerFrame.scrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", LCDWFrame.backgroundContainerFrame.scrollFrame, "BOTTOMRIGHT", -7, 18)
end

function LCDWFrame.backgroundContainerFrame:generateGuides(guideType, id)
    if guideType == "pve" then
        for i = 1, foldersItemsNb[guideType]["d" .. id] do
            pveGuidesTextures["pveTexture" .. i] = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:CreateTexture(nil, "ARTWORK")
            if i == 1 then
                pveGuidesTextures["pveTexture" .. i]:SetPoint("TOP", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame, "TOP")
            else
                pveGuidesTextures["pveTexture" .. i]:SetPoint("TOP", pveGuidesTextures["pveTexture" .. i - 1], "BOTTOM", 0, -20)
            end
            pveGuidesTextures["pveTexture" .. i]:SetSize(GUIDE_WIDTH, GUIDE_HEIGHT)
            pveGuidesTextures["pveTexture" .. i]:SetTexture(PVE_FOLDER_PATH .. "d" .. id .. "\\" .. i)
        end
    elseif guideType == "pvp" then
        for i = 1, foldersItemsNb[guideType]["c" .. id] do
            pvpGuidesTextures["pvpTexture" .. i] = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:CreateTexture(nil, "ARTWORK")
            -- first texture at the top of the guide parent frame --
            if i == 1 then
                pvpGuidesTextures["pvpTexture" .. i]:SetPoint("TOP", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame, "TOP")
                -- and the rest under 20 px from one another --
            else
                pvpGuidesTextures["pvpTexture" .. i]:SetPoint("TOP", pvpGuidesTextures["pvpTexture" .. i - 1], "BOTTOM", 0, -20)
            end
            pvpGuidesTextures["pvpTexture" .. i]:SetSize(GUIDE_WIDTH, GUIDE_HEIGHT)
            pvpGuidesTextures["pvpTexture" .. i]:SetTexture(PVP_FOLDER_PATH .. "c" .. id .. "\\" .. i)
        end
    else
        for i = 1, foldersItemsNb[guideType] do
            glossaryTextures["glossaryTexture" .. i] = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame:CreateTexture(nil, "ARTWORK")
            if i == 1 then
                glossaryTextures["glossaryTexture" .. i]:SetPoint("TOP", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guideParentFrame, "TOP")
            else
                glossaryTextures["glossaryTexture" .. i]:SetPoint("TOP", glossaryTextures["glossaryTexture" .. i - 1], "BOTTOM", 0, -20)
            end
            glossaryTextures["glossaryTexture" .. i]:SetSize(GUIDE_WIDTH, GUIDE_HEIGHT)
            glossaryTextures["glossaryTexture" .. i]:SetTexture(GLOSSARY_FOLDER_PATH .. "glossary" .. i)
        end
    end
end
-- display all the dungeons frames --
local function generateDungeonsFrames()

    local FRAME_WIDTH = 220
    local FRAME_HEIGHT = 120
    local SPACE_BETWEEN_ITEMS = 20
    local ROW_MAX_DUNGEONS_ITEMS = 4
    local FIRST_ROW_OFSY = -220
    local SECOND_ROW_OFSY = FIRST_ROW_OFSY - 138
    local FIRST_LEFT_SPACE = 40

    local buttonTexture = "Interface\\ENCOUNTERJOURNAL\\UI-EncounterJournalTextures"

    for dungeonsK, dungeonV in ipairs(dungeons) do

        -- dungeons thumbnail --
        dungeonsFrames["dungeonFrame" .. dungeonsK] = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetSize(FRAME_WIDTH, FRAME_HEIGHT)

        -- dungeons thumbnails borders and click hander --
        dungeonsFrames["dungeonFrame" .. dungeonsK].border = CreateFrame("Button", nil, dungeonsFrames["dungeonFrame" .. dungeonsK])

        -- If 4 dungeons frame are displayed then ddd a new line --
        if dungeonsK > ROW_MAX_DUNGEONS_ITEMS then
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "TOPLEFT", FIRST_LEFT_SPACE + ((FRAME_WIDTH * (dungeonsK - 5)) + (SPACE_BETWEEN_ITEMS * (dungeonsK - 5))), SECOND_ROW_OFSY)
        else
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "TOPLEFT", FIRST_LEFT_SPACE + ((FRAME_WIDTH * (dungeonsK - 1)) + (SPACE_BETWEEN_ITEMS * (dungeonsK - 1))), FIRST_ROW_OFSY)
        end

        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetBackdrop({
            bgFile = dungeons[dungeonsK][ICON_COL],
            insets = { left = 0, right = -105, top = 0, bottom = -40 }
        })

        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetPoint("TOPLEFT", dungeonsFrames["dungeonFrame" .. dungeonsK], "TOPLEFT", 0, 0)
        -- divide the frameWidth and frameHeight by the coef associated to keep the same size ratio as the parent frame
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetNormalTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetHighlightTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetPushedTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetNormalTexture():SetTexCoord(0, 0.34, 0.428, 0.522)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetHighlightTexture():SetTexCoord(0.345, 0.68, 0.333, 0.425)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetPushedTexture():SetTexCoord(0, 0.34, 0.332, 0.425)

        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetScript("OnClick", function(self, button)
            LCDWFrame.backgroundContainerFrame:showGuide(true, dungeons[dungeonsK][NAME_COL], dungeonsK, "dungeon", "pve")
        end)

        -- dungeons title --
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title = dungeonsFrames["dungeonFrame" .. dungeonsK].border:CreateFontString(nil, "OVERLAY")
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetFont("Fonts\\MORPHEUS.TTF", 20, "OUTLINE")
        --dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetTextColor(0.95, 0.78, 0, 1)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetTextColor(Helpers:hexadecimalToBlizzardColor(249), Helpers:hexadecimalToBlizzardColor(204), Helpers:hexadecimalToBlizzardColor(0), 1)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetWidth(130)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetHeight(55)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetPoint("CENTER", dungeonsFrames["dungeonFrame" .. dungeonsK].border, "CENTER")
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetText(dungeons[dungeonsK][NAME_COL])
        dungeonsFrames["dungeonFrame" .. dungeonsK].border.title:SetJustifyH("CENTER")
    end
end
-- display all the classes frames --
local function generateClassesFrames()

    local FRAME_WIDTH = 54
    local FRAME_HEIGHT = 54
    local SPACE_BETWEEN_ITEMS = 60
    local ROW_MAX_CLASSES_ITEMS = 6
    local FIRST_ROW_OFSY = -175
    local SECOND_ROW_OFSY = FIRST_ROW_OFSY - 90
    local FIRST_LEFT_SPACE = 200

    for classesK, classesV in ipairs(classes) do

        classesFrames["classeFrame" .. classesK] = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
        classesFrames["classeFrame" .. classesK]:SetSize(FRAME_WIDTH, FRAME_HEIGHT)

        -- If 4 dungeons frame are displayed then ddd a new line --
        if classesK > ROW_MAX_CLASSES_ITEMS then
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "LEFT", FIRST_LEFT_SPACE + ((FRAME_WIDTH * (classesK - 7)) + (SPACE_BETWEEN_ITEMS * (classesK - 7))), SECOND_ROW_OFSY)
        else
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "LEFT", FIRST_LEFT_SPACE + ((FRAME_WIDTH * (classesK - 1)) + (SPACE_BETWEEN_ITEMS * (classesK - 1))), FIRST_ROW_OFSY)
        end

        classesFrames["classeFrame" .. classesK]:SetBackdrop({
            bgFile = classes[classesK][ICON_COL],
        })

        classesFrames["classeFrame" .. classesK]:SetScript("OnClick", function(self, button)
            LCDWFrame.backgroundContainerFrame:showGuide(true, classes[classesK][NAME_COL], classesK, "class", "pvp")
        end)
    end
end

generateDungeonsFrames()
generateClassesFrames()
----------------------------------------------------------
----///////////// END MAIN FRAME (Général) /////////////--
----------------------------------------------------------

----------------------------------------------------------
---------///////////// MINIMAP ICON /////////////---------
----------------------------------------------------------
local LCDWLDB = LibStub("LibDataBroker-1.1"):NewDataObject("LCDWIcon", {
    type = "global",
    icon = MINIMAP_ICON_PATH,
    OnClick = function(clickedframe, button)
        if button == "RightButton" then

        elseif button == "LeftButton" then
            if LCDWFrame:IsShown() then
                LCDWFrame:Hide()
            else
                LCDWFrame:Show()
            end
        end
    end,
    OnTooltipShow = function(tooltip)
        if tooltip and tooltip.AddLine then
            tooltip:AddLine(BLUE .. customAddonName .. " - " .. addonVersion)
            tooltip:AddLine(YELLOW .. "Click gauche" .. " " .. WHITE
                    .. "pour ouvrir/fermer la fenêtre de guides")
            tooltip:AddLine(YELLOW .. "Click droit" .. " " .. WHITE
                    .. "pour ouvrir/fermer la configuration")
        end
    end
})

function LCDW:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("LCDWDB", defaults)
    icon:Register("LCDWIcon", LCDWLDB, self.db.profile.minimapOption)
end
----------------------------------------------------------
-------///////////// END MINIMAP ICON /////////////-------
----------------------------------------------------------

----------------------------------------------------------
-------///////////// SLASH COMMANDS /////////////---------
----------------------------------------------------------
SLASH_LECODEXDEWILLIOS1 = '/lcdw'
SlashCmdList["LECODEXDEWILLIOS"] = function()
    LCDWFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI