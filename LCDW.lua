----------------------------------------------------------
----/////////////////////// VARS ///////////////////////--
----------------------------------------------------------
local name, addonNamespace = ...
addonNamespace.Helpers = {}

local Helpers = addonNamespace.Helpers
local customAddonName = "Le codex de Willios"
local addonVersion = "0.4 Alpha"

local LCDWOptionsFrame = nil

local MAIN_FRAME_WITH = 715
local MAIN_FRAME_HEIGHT = 500
local OPTIONS_FRAME_WIDTH = 250
local FRAME_TITLE_CONTAINER_WIDTH = 100
local FRAME_TITLE_CONTAINER_HEIGHT = 20
local FOLDER_GUIDES_PATH = "Interface\\AddOns\\LCDW\\guides\\pve\\"
local MINIMAP_ICON_PATH = "Interface\\AddOns\\LCDW\\misc\\minimap-icon"
local DUNGEONS_ICONS_PATH = "Interface\\ENCOUNTERJOURNAL\\UI-EJ-DUNGEONBUTTON-"
local CLASSES_ICONS_PATH = "Interface\\ICONS\\ClassIcon_"
local ARROW_TITLE_SECTION = "Interface\\RAIDFRAME\\UI-RAIDFRAME-ARROW"
local ARRAY_FIRST_COL = 1
local ARRAY_SECOND_COL = 2
local CURRENT_BUILD, _, _, _ = GetBuildInfo()

local GREEN = "|cff00ff00"
local YELLOW = "|cffffff00"
local RED = "|cffff0000"
local BLUE = "|cff0198e1"
local ORANGE = "|cffff9933"
local WHITE = "|cffffffff"

local SOCIAL_NETWORK_TEXT = BLUE .. "Pour me suivre|r : twitchIcon /williosz twitterIcon @williosx discordIcon /SmZfhAG"
local CREDITS_TEST = "Made by Aecx & Willios - v." .. addonVersion

local textures = {}
local textureShown = {}
local dungeonsFrames = {}
local classesFrames = {}

local dungeonSelected = nil
local classSelected = nil

local dungeons = {
    { "Sillage nécrotique", DUNGEONS_ICONS_PATH .. "Maraudon" },
    { "Malepeste", DUNGEONS_ICONS_PATH .. "BlackrockDepths" },
    { "Brumes de Tirna Scrithe", DUNGEONS_ICONS_PATH .. "Deadmines" },
    { "Salles de l'Expiation", DUNGEONS_ICONS_PATH .. "DireMaul" },
    { "Flèches de l'Ascension", DUNGEONS_ICONS_PATH .. "RagefireChasm" },
    { "Théâtre de la Souffrance", DUNGEONS_ICONS_PATH .. "ScarletMonastery" },
    { "L'Autre côté", DUNGEONS_ICONS_PATH .. "Scholomance" },
    { "Profondeurs Sanguines", DUNGEONS_ICONS_PATH .. "ShadowFangKeep" }
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

local dropDownLvlOneMenu = {
    "Guides PVE",
    "Guides PVP",
    "Glossaire",
}

-- namespace's functions --
function Helpers:degreesToRadians(angle)
    return angle * 0.0174533
end

function Helpers:CreateFontString(frameName, frameToAttach, font, width, height, point, relativePoint, ofsx, ofsy, text)
    frameName = frameToAttach:CreateFontString(nil, "OVERLAY")
    frameName:SetFontObject(font)
    if width then
        frameName:SetWidth(width)
    end
    if height then
        frameName:SetHeight(height)
    end
    frameName:SetPoint(point, frameToAttach, relativePoint, ofsx, ofsy)
    frameName:SetText(text)
end

local LCDW = LibStub("AceAddon-3.0"):NewAddon("LCDW", "AceConsole-3.0")
local icon = LibStub("LibDBIcon-1.0")
local defaults = {
    profile = {
        minimapOption = {
            hide = false
        }
    }
}
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
        print(BLUE .. customAddonName .. "|r loaded! Type /lcdw to access to the guides.")
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", onEvent)

----------------------------------------------------------
----/////////////// MAIN FRAME (Général) ///////////////--
----------------------------------------------------------
--local LCDWFrame = CreateFrame("Frame", nil, UIParent, BackdropTemplateMixin and "BackdropTemplate")
local LCDWFrame = CreateFrame("Frame", nil, UIParent)
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
createBorder(LCDWFrame,true, "left", LCDWFrame.leftBottomBorderCorner, "BOTTOMLEFT", "BOTTOMLEFT", -53, 40)
createBorder(LCDWFrame,true, "top", LCDWFrame.topLeftBorderCorner, "TOPLEFT", "TOPLEFT", -5, 7)
createBorder(LCDWFrame,true, "right", LCDWFrame.rightTopBorderCorner, "TOPRIGHT", "TOPRIGHT", 52.5, -40)
createBorder(LCDWFrame,true, "bottom", LCDWFrame.bottomRightBorderCorner, "BOTTOMRIGHT", "BOTTOMRIGHT", 5, -7)
-- side border textures --
-- LEFT --
createBorder(LCDWFrame,false, "left", LCDWFrame.leftBorder, "LEFT", "LEFT", -130, -30)
createBorder(LCDWFrame,false, "left", LCDWFrame.leftBorderTwo, "LEFT", "LEFT", -130, 124)
-- TOP --
createBorder(LCDWFrame,false, "top", LCDWFrame.topBorder, "TOP", "TOP", -135, 6)
createBorder(LCDWFrame,false, "top", LCDWFrame.topBorderTwo, "TOP", "TOP", 121, 6)
createBorder(LCDWFrame,false, "top", LCDWFrame.topBorderThree, "TOP", "TOP", 230, 6)
-- RIGHT --
createBorder(LCDWFrame,false, "right", LCDWFrame.rightBorder, "RIGHT", "RIGHT", 129, 30)
createBorder(LCDWFrame,false, "right", LCDWFrame.rightBorderTwo, "RIGHT", "RIGHT", 129, -125)
-- BOTTOM --
createBorder(LCDWFrame,false, "bottom", LCDWFrame.bottomBorder, "BOTTOMLEFT", "BOTTOMLEFT", 0, -6)
createBorder(LCDWFrame,false, "bottom", LCDWFrame.bottomBorderTwo, "BOTTOMLEFT", "BOTTOMLEFT", 256, -6)
createBorder(LCDWFrame,false, "bottom", LCDWFrame.bottomBorderThree, "BOTTOMLEFT", "BOTTOMLEFT", 380, -6)
--------------------------------
-----//  second main frame //---
--------------------------------
-- background container frame --
LCDWFrame.backgroundContainerFrame = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.backgroundContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
LCDWFrame.backgroundContainerFrame:SetPoint("CENTER", LCDWFrame, "CENTER")
-- background texture --
LCDWFrame.backgroundContainerFrame.mainBackground = LCDWFrame.backgroundContainerFrame:CreateTexture(nil, "BACKGROUND")
LCDWFrame.backgroundContainerFrame.mainBackground:SetTexture("Interface\\ENCOUNTERJOURNAL\\DungeonJournalTierBackgrounds4")
LCDWFrame.backgroundContainerFrame.mainBackground:SetPoint("TOPLEFT", LCDWFrame.backgroundContainerFrame, "TOPLEFT")
LCDWFrame.backgroundContainerFrame.mainBackground:SetSize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
LCDWFrame.backgroundContainerFrame.mainBackground:SetTexCoord(0.42, 0.73, 0, 0.4)
-- title container --
LCDWFrame.backgroundContainerFrame.titleContainerFrame = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame, "GlowBoxTemplate")
LCDWFrame.backgroundContainerFrame.titleContainerFrame:SetSize(FRAME_TITLE_CONTAINER_WIDTH, FRAME_TITLE_CONTAINER_HEIGHT)
LCDWFrame.backgroundContainerFrame.titleContainerFrame:SetPoint("CENTER", LCDWFrame, "TOP", 0, 0)
-- title --
Helpers:CreateFontString(LCDWFrame.backgroundContainerFrame.titleContainerFrame.title, LCDWFrame.backgroundContainerFrame.titleContainerFrame, "GameFontHighLight", false, false, "CENTER", "CENTER", 0, 0, "Général")
-- scroll frame --
LCDWFrame.backgroundContainerFrame.scrollFrame = CreateFrame("ScrollFrame", nil, LCDWFrame.backgroundContainerFrame, "UIPanelScrollFrameTemplate")
LCDWFrame.backgroundContainerFrame.scrollFrame:SetPoint("TOPLEFT", LCDWFrame.backgroundContainerFrame, "TOPLEFT", 0, -120)
LCDWFrame.backgroundContainerFrame.scrollFrame:SetPoint("BOTTOMRIGHT", LCDWFrame.backgroundContainerFrame, "BOTTOMRIGHT", 0, 70)
LCDWFrame.backgroundContainerFrame.scrollFrame:Hide()

--local scrollFrameChild = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.scrollFrame)
--scrollFrameChild:SetSize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
--scrollFrameChild.background = scrollFrameChild:CreateTexture(nil, "BACKGROUND")
--scrollFrameChild.background:SetColorTexture(0.2, 0.6, 0, 0.8)

-- close button --
LCDWFrame.backgroundContainerFrame.CloseButton = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame, "UIPanelCloseButton")
LCDWFrame.backgroundContainerFrame.CloseButton:SetPoint("CENTER", LCDWFrame.backgroundContainerFrame, "TOPRIGHT", -20, -20)
LCDWFrame.backgroundContainerFrame.CloseButton:SetScript("OnClick", function(self, Button, Down)
    LCDWFrame:Hide()
end)
-- open options panel button --
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetSize(45, 45)
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetPoint("CENTER", LCDWFrame.backgroundContainerFrame, "TOPRIGHT", -25, -55)
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetBackdrop({
    bgFile = "Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up",
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
-- open options panel button hover --
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton.Hover = LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:CreateTexture(nil, "BACKGROUND")
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton.Hover:SetTexture("Interface\\Buttons\\CheckButtonGlow")
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton.Hover:SetAllPoints(LCDWFrame.backgroundContainerFrame.openOptionsFrameButton)
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton.Hover:SetAlpha(0)
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetScript("OnEnter", function()
    LCDWFrame.backgroundContainerFrame.openOptionsFrameButton.Hover:SetAlpha(1)
end);
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetScript("OnLeave", function()
    LCDWFrame.backgroundContainerFrame.openOptionsFrameButton.Hover:SetAlpha(0)
end);
LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetScript("OnClick", function()
    if LCDWOptionsFrame:IsShown() then
        LCDWOptionsFrame:Hide()
        LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    else
        LCDWOptionsFrame:Show()
        LCDWFrame.backgroundContainerFrame.openOptionsFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    end
end);
-- Resize frame --
--LCDWFrame.resizeButton = CreateFrame("Button", nil, LCDWFrame)
--LCDWFrame.resizeButton:SetPoint("BOTTOMRIGHT", 0, 0)
--LCDWFrame.resizeButton:SetSize(16, 16)
--LCDWFrame.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
--LCDWFrame.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
--LCDWFrame.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

--LCDWFrame.resizeButton:SetScript("OnMouseDown", function()
--    LCDWFrame:StartSizing("BOTTOMRIGHT")
--end)
--LCDWFrame.resizeButton:SetScript("OnMouseUp", function()
--    LCDWFrame:StopMovingOrSizing()
--end)
-- end resize frame --
-- social networks container --
LCDWFrame.backgroundContainerFrame.socialNetworks = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.backgroundContainerFrame.socialNetworks:SetSize(LCDWFrame:GetWidth(), 20)
LCDWFrame.backgroundContainerFrame.socialNetworks:SetPoint("BOTTOM", LCDWFrame.backgroundContainerFrame, "BOTTOM", 0, 0)
LCDWFrame.backgroundContainerFrame.socialNetworks:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
-- social networks text --
Helpers:CreateFontString(LCDWFrame.backgroundContainerFrame.socialNetworks.content, LCDWFrame.backgroundContainerFrame.socialNetworks, "GameFontHighlightSmall", false, false, "CENTER", "CENTER", 0, 0, SOCIAL_NETWORK_TEXT)
--------------------------------
------// third main frame //----
--------------------------------
-- this frame contains all the dungeons and classes thumbnails + the frames titles (guides pve / pvp) --
-- it will be easier to hide all elements when a dungeons is selected --
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:SetPoint("CENTER", LCDWFrame, "CENTER")
-- create a section name container --
local function createSectionNameContainer(frameName, relativePoint, ofsy, title)
    -- dungeons section name container --
    frameName = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
    frameName:SetSize(200, 30)
    frameName:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, relativePoint, 40, ofsy)
    frameName:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    })
    -- arrow on the left of the container --
    frameName.arrowTitle = CreateFrame("Frame", nil, frameName, BackdropTemplateMixin and "BackdropTemplate")
    frameName.arrowTitle:SetSize(32, 32)
    frameName.arrowTitle:SetPoint("LEFT", frameName, "LEFT")
    frameName.arrowTitle:SetBackdrop({
        bgFile = ARROW_TITLE_SECTION
    })
    -- dungeons section name --
    Helpers:CreateFontString(frameName.sectionTitle, frameName, "GameFontHighLight", false, false, "CENTER", "CENTER", 0, 0, title)
end
createSectionNameContainer(LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.dungeonsSectionNameContainer, "TOPLEFT", -50, "Guides PVE")
createSectionNameContainer(LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.classesSectionNameContainer, "LEFT", -46, "Guides PVP")
-- glossary frame --
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame = CreateFrame("BUTTON", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetSize(200, 30)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetPoint("RIGHT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "RIGHT", 0, -40)
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame:SetScript("OnClick", function ()
    LCDWFrame.backgroundContainerFrame:showGuide(false, "Glossaire", 5)
end)
Helpers:CreateFontString(LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame.title, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame.glossaryFrame, "GameFontHighLight", false, false, "CENTER", "CENTER", 0, 0, "Glossaire")
--------------------------------
--// third main frame prime //--
--------------------------------
---@todo faire une frame qui englobe le titre et l'icone
-- this function creates the frame displayed when a dungeon is selected
function LCDWFrame.backgroundContainerFrame:showGuide(icon, name, id)
    -- hide all the previous elements --
    LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:Hide()
    -- show the scroll frame --
    LCDWFrame.backgroundContainerFrame.scrollFrame:Show()
    -- frame that appears after selecting a guide --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.scrollFrame)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:SetPoint("CENTER", LCDWFrame, "CENTER")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.bg = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:CreateTexture(nil, "BACKGROUND")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.bg:SetAllPoints(true)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.bg:SetColorTexture(0.2, 0.6, 0, 0.8)
    -- title --
    Helpers:CreateFontString(LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.title, LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "GameFontHighlightLarge", false, false, "CENTER", "TOP", 0, -50, name)
    -- icon --
    if icon then
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.icon = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:CreateTexture(nil, "ARTWORK")
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.icon:SetSize(30, 30)
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.icon:SetPoint("CENTER", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "TOP", -100, -50)
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.icon:SetTexture(classes[id][ARRAY_SECOND_COL])
    end
    -- core image --
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guide = LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:CreateTexture(nil, "ARTWORK")
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guide:SetPoint("CENTER", LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame, "CENTER", 0, -150)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guide:SetSize(600, 600)
    LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame.guide:SetTexture(FOLDER_GUIDES_PATH .. 1)
    -- set the scroll child to be able to scroll --
    LCDWFrame.backgroundContainerFrame.scrollFrame:SetScrollChild(LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame)
    --LCDWFrame.backgroundContainerFrame.scrollFrame.scrollBar:ClearAllPoints()
    --LCDWFrame.backgroundContainerFrame.scrollFrame.scrollBar:SetPoint("TOPLEFT", LCDWFrame.backgroundContainerFrame.scrollFrame, "TOPLEFT", -30, -18)
    --LCDWFrame.backgroundContainerFrame.scrollFrame.scrollBar:SetPoint("BOTTOMRIGHT", LCDWFrame.backgroundContainerFrame.scrollFrame, "BOTTOMRIGHT", -30, -18)
end
----------------------------------------------------------
----///////////// END MAIN FRAME (Général) /////////////--
----------------------------------------------------------
--
--
--
----------------------------------------------------------
----///////////// OPTIONS FRAME (Options) //////////////--
----------------------------------------------------------
LCDWOptionsFrame = CreateFrame("Frame", nil, LCDWFrame)
LCDWOptionsFrame:SetSize(OPTIONS_FRAME_WIDTH, LCDWFrame:GetHeight())
LCDWOptionsFrame:SetPoint("LEFT", LCDWFrame, "RIGHT", 5, 0)
-- border textures --
createBorder(LCDWOptionsFrame, true, "right", LCDWOptionsFrame.rightTopBorderCorner, "TOPRIGHT", "TOPRIGHT", 52, -41)
createBorder(LCDWOptionsFrame, true, "bottom", LCDWOptionsFrame.bottomRightBorderCorner, "BOTTOMRIGHT", "BOTTOMRIGHT", 4, -7)

createBorder(LCDWOptionsFrame, false, "top", LCDWOptionsFrame.topBorder, "TOP", "TOP", -4, 6)
createBorder(LCDWOptionsFrame, false, "right", LCDWOptionsFrame.rightBorder, "RIGHT", "RIGHT", 129, 28)
createBorder(LCDWOptionsFrame, false, "right", LCDWOptionsFrame.rightBorderTwo, "RIGHT", "RIGHT", 129, -125)
createBorder(LCDWOptionsFrame, false, "bottom", LCDWOptionsFrame.bottomBorder, "BOTTOM", "BOTTOM", -10, -6)
-- background container frame --
LCDWOptionsFrame.backgroundContainerFrame = CreateFrame("Frame", nil, LCDWOptionsFrame)
LCDWOptionsFrame.backgroundContainerFrame:SetSize(LCDWOptionsFrame:GetWidth(), LCDWOptionsFrame:GetHeight())
LCDWOptionsFrame.backgroundContainerFrame:SetPoint("CENTER", LCDWOptionsFrame, "CENTER")
-- background texture --
LCDWOptionsFrame.backgroundContainerFrame.mainBackground = LCDWOptionsFrame.backgroundContainerFrame:CreateTexture(nil, "BACKGROUND")
LCDWOptionsFrame.backgroundContainerFrame.mainBackground:SetTexture("Interface\\ENCOUNTERJOURNAL\\DungeonJournalTierBackgrounds4")
LCDWOptionsFrame.backgroundContainerFrame.mainBackground:SetPoint("TOPLEFT", LCDWOptionsFrame, "TOPLEFT")
LCDWOptionsFrame.backgroundContainerFrame.mainBackground:SetSize(OPTIONS_FRAME_WIDTH, MAIN_FRAME_HEIGHT)
LCDWOptionsFrame.backgroundContainerFrame.mainBackground:SetTexCoord(0.42, 0.51, 0, 0.4)
-- title container --
LCDWOptionsFrame.backgroundContainerFrame.LCDWOptionsFrameNameContainer = CreateFrame("Frame", nil, LCDWOptionsFrame.backgroundContainerFrame, "GlowBoxTemplate")
LCDWOptionsFrame.backgroundContainerFrame.LCDWOptionsFrameNameContainer:SetSize(FRAME_TITLE_CONTAINER_WIDTH, FRAME_TITLE_CONTAINER_HEIGHT)
LCDWOptionsFrame.backgroundContainerFrame.LCDWOptionsFrameNameContainer:SetPoint("CENTER", LCDWOptionsFrame.backgroundContainerFrame, "TOP", 0, 0)
-- title --
Helpers:CreateFontString(LCDWOptionsFrame.backgroundContainerFrame.LCDWOptionsFrameNameContainer.title, LCDWOptionsFrame.backgroundContainerFrame.LCDWOptionsFrameNameContainer, "ItemTextFontNormal", false, false, "CENTER", "CENTER", 0, 0, "Options")
-- reset button --
LCDWOptionsFrame.backgroundContainerFrame.resetButton = CreateFrame("Button", nil, LCDWOptionsFrame.backgroundContainerFrame, "UIPanelButtonTemplate")
LCDWOptionsFrame.backgroundContainerFrame.resetButton:SetSize(100, 30)
LCDWOptionsFrame.backgroundContainerFrame.resetButton:SetPoint("CENTER", 0, 0)
LCDWOptionsFrame.backgroundContainerFrame.resetButton:SetText("Accueil")
LCDWOptionsFrame.backgroundContainerFrame.resetButton:SetScript("OnClick", function()
    -- hide the scroll frame --
    if LCDWFrame.backgroundContainerFrame.scrollFrame:IsShown() then
        LCDWFrame.backgroundContainerFrame.scrollFrame:Hide()
    end
    -- hide guide currently displayed --
    if LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:IsShown() then
        LCDWFrame.backgroundContainerFrame.titleAndGuideContainerFrame:Hide()
    end
    -- show the homepage --
    if not LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:IsShown() then
        LCDWFrame.backgroundContainerFrame.allElementsContainerFrame:Show()
    end
end)
-- credits container --
LCDWOptionsFrame.backgroundContainerFrame.credits = CreateFrame("Frame", nil, LCDWOptionsFrame.backgroundContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWOptionsFrame.backgroundContainerFrame.credits:SetSize(LCDWOptionsFrame:GetWidth(), 20)
LCDWOptionsFrame.backgroundContainerFrame.credits:SetPoint("BOTTOM", LCDWOptionsFrame.backgroundContainerFrame, "BOTTOM", 0, 0)
LCDWOptionsFrame.backgroundContainerFrame.credits:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
-- credits text --
Helpers:CreateFontString(LCDWOptionsFrame.backgroundContainerFrame.credits.content, LCDWOptionsFrame.backgroundContainerFrame.credits, "GameFontHighlightSmall", false, false, "CENTER", "CENTER", 0, 0, CREDITS_TEST)
-- hide minimap checkbox --
LCDWOptionsFrame.backgroundContainerFrame.mmButtonOption = CreateFrame("CheckButton", nil, LCDWOptionsFrame.backgroundContainerFrame, "UICheckButtonTemplate")
LCDWOptionsFrame.backgroundContainerFrame.mmButtonOption:SetPoint("LEFT", LCDWOptionsFrame.backgroundContainerFrame, "BOTTOMLEFT", 15, 50)
LCDWOptionsFrame.backgroundContainerFrame.mmButtonOption.text:SetText("Cacher l'icône de la minimap")
LCDWOptionsFrame.backgroundContainerFrame.mmButtonOption:SetChecked(false)
LCDWOptionsFrame.backgroundContainerFrame.mmButtonOption:SetScript("OnClick", function()
    --@todo Hide minimap icon
end)
----------------------------------------------------------
----//////////// END OPTIONS FRAME (Options) ///////////--
----------------------------------------------------------
local function createTexture(dungeonId)
    textures["texture" .. dungeonId] = LCDWFrame:CreateTexture(nil, "ARTWORK")
    textures["texture" .. dungeonId]:SetPoint("CENTER", LCDWFrame, "CENTER", 0, 0)
    textures["texture" .. dungeonId]:SetSize(450, 450)
    textures["texture" .. dungeonId]:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
    return textures["texture" .. dungeonId]
end

local function generateDungeonsFrames()

    local FRAME_WIDTH = 220
    local FRAME_HEIGHT = 110
    local SPACE_BETWEEN_ITEMS = 30
    local ROW_MAX_DUNGEONS_ITEMS = 4
    local WIDTH_COEF = 1.4814814814814814814814814814815
    local HEIGHT_COEF = 1.369863013698630136986301369863

    local buttonTexture = "Interface\\ENCOUNTERJOURNAL\\UI-EncounterJournalTextures"

    for dungeonsK, dungeonV in ipairs(dungeons) do

        -- dungeons thumbnail --
        dungeonsFrames["dungeonFrame" .. dungeonsK] = CreateFrame("Frame", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
        -- dungeons title --
        dungeonsFrames["dungeonFrame" .. dungeonsK].title = dungeonsFrames["dungeonFrame" .. dungeonsK]:CreateFontString(nil, "OVERLAY")
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetFontObject("ItemTextFontNormal")
        -- dungeons thumbnails borders and click hander --
        dungeonsFrames["dungeonFrame" .. dungeonsK].border = CreateFrame("Button", nil, dungeonsFrames["dungeonFrame" .. dungeonsK])

        -- If 4 dungeons frame are displayed then ddd a new line --
        if dungeonsK > ROW_MAX_DUNGEONS_ITEMS then
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "TOPLEFT", 45 + ((FRAME_WIDTH / 1.7 * (dungeonsK - 5)) + (SPACE_BETWEEN_ITEMS * (dungeonsK - 5))), -230)
        else
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "TOPLEFT", 45 + ((FRAME_WIDTH / 1.7 * (dungeonsK - 1)) + (SPACE_BETWEEN_ITEMS * (dungeonsK - 1))), -140)
        end

        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetBackdrop({
            bgFile = dungeons[dungeonsK][ARRAY_SECOND_COL],
        })

        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetWidth(100)
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetHeight(50)
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetPoint("CENTER", dungeonsFrames["dungeonFrame" .. dungeonsK], "CENTER", 0 - (dungeonsFrames["dungeonFrame" .. dungeonsK].title:GetWidth() / 2), 0 + (dungeonsFrames["dungeonFrame" .. dungeonsK].title:GetHeight() / 2))
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetText(dungeons[dungeonsK][ARRAY_FIRST_COL])
        local font = dungeonsFrames["dungeonFrame" .. dungeonsK].title:GetFontObject():SetTextColor(0.95, 0.78, 0, 1)
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetFontObject(font)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetPoint("TOPLEFT", dungeonsFrames["dungeonFrame" .. dungeonsK], "TOPLEFT", 0, 0)
        -- divide the frameWidth and frameHeight by the coef associated to keep the same size ratio as the parent frame
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetSize(FRAME_WIDTH / WIDTH_COEF, FRAME_HEIGHT / HEIGHT_COEF)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetNormalTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetHighlightTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetPushedTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetNormalTexture():SetTexCoord(0, 0.34, 0.428, 0.522)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetHighlightTexture():SetTexCoord(0.345, 0.68, 0.333, 0.425)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetPushedTexture():SetTexCoord(0, 0.34, 0.332, 0.425)

        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetScript("OnClick", function(self, button)
            LCDWFrame.backgroundContainerFrame:showGuide(nil, dungeons[dungeonsK][ARRAY_FIRST_COL], dungeonsK)
        end)
    end
end

local function generateClassesFrames()

    local FRAME_WIDTH = 48
    local FRAME_HEIGHT = 48
    local SPACE_BETWEEN_ITEMS = 30
    local ROW_MAX_CLASSES_ITEMS = 6

    for classesK, classesV in ipairs(classes) do

        classesFrames["classeFrame" .. classesK] = CreateFrame("Button", nil, LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
        classesFrames["classeFrame" .. classesK]:SetSize(FRAME_WIDTH, FRAME_HEIGHT)

        -- If 4 dungeons frame are displayed then ddd a new line --
        if classesK > ROW_MAX_CLASSES_ITEMS then
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "LEFT", 139 + ((FRAME_WIDTH * (classesK - 7)) + (SPACE_BETWEEN_ITEMS * (classesK - 7))), -185)
        else
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT", LCDWFrame.backgroundContainerFrame.allElementsContainerFrame, "LEFT", 139 + ((FRAME_WIDTH * (classesK - 1)) + (SPACE_BETWEEN_ITEMS * (classesK - 1))), -125)
        end

        classesFrames["classeFrame" .. classesK]:SetBackdrop({
            bgFile = classes[classesK][ARRAY_SECOND_COL],
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        })

        classesFrames["classeFrame" .. classesK]:SetScript("OnClick", function(self, button)
            LCDWFrame.backgroundContainerFrame:showGuide(true, classes[classesK][ARRAY_FIRST_COL], classesK)
        end)
    end
end

generateDungeonsFrames()
generateClassesFrames()

-- MINIMAP --
local LCDWLDB = LibStub("LibDataBroker-1.1"):NewDataObject("WowGuides", {
    type = "global",
    icon = MINIMAP_ICON_PATH,
    OnClick = function(clickedframe, button)
        if button == "RightButton" then
            print(RED .. "WIP")
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
    icon:Register("LCDWLDB", LCDWLDB, self.db.profile.minimapOption)
end
-- END MINIMAP --



-- Onlick Dungeons dropdown items --
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(LCDWOptionsFrame.dropDownName, "Donjon : " .. arg2)
    dungeonSelected = arg1
    print("salut")
    for dungeonId, dungeon in ipairs(dungeons) do
        if arg1 == classId then

        end
        -- if the dungeon is different that the one selected
        --if dungeonId ~= arg1 then
        --    -- then check which one is currently shown
        --    if textureShown["isTexture" .. dungeonId .. "Shown"] == true then
        --        -- Hide it
        --        textures["texture" .. dungeonId]:Hide()
        --        -- and set it to false (which means it's now hidden)
        --        textureShown["isTexture" .. dungeonId .. "Shown"] = false
        --    end
        --    -- for the dungeon selected
        --else
        --    -- check if the selected one is hidden
        --    if textureShown["isTexture" .. dungeonId .. "Shown"] == false then
        --        -- if it is, create the texture according to the dungeon selected
        --        createTexture(dungeonId)
        --        -- and set it to true (which means it's now shown)
        --        textureShown["isTexture" .. dungeonId .. "Shown"] = true
        --    end
        --end
    end
end
-- end onclick event --

-- display the dungeons' list --
local function DungeonsListDropDown(frame, level, menuList)

    local info = UIDropDownMenu_CreateInfo()

    if level == 1 then
        -- Outermost menu level
        for k, v in ipairs(dropDownLvlOneMenu) do
            info.text, info.arg1, info.arg2, info.hasArrow = v, k, v, true
            UIDropDownMenu_AddButton(info)
        end
    else
        info.func = DungeonsListDropDown_OnClick
        for i, dungeon in ipairs(dungeons) do
            info.text, info.arg1, info.arg2, info.checked = dungeon[1], i, dungeon[1], i == dungeonSelected
            UIDropDownMenu_AddButton(info, level)
        end
    end
end
-- end --

LCDWOptionsFrame.dropDownName = CreateFrame("Frame", "WPDungeonsListDropDown", LCDWOptionsFrame, "UIDropDownMenuTemplate")
LCDWOptionsFrame.dropDownName:SetPoint("CENTER", LCDWOptionsFrame, "TOP", 0, -150)
UIDropDownMenu_SetWidth(LCDWOptionsFrame.dropDownName, 200)
UIDropDownMenu_Initialize(LCDWOptionsFrame.dropDownName, DungeonsListDropDown)
UIDropDownMenu_SetText(LCDWOptionsFrame.dropDownName, "Accès rapide")
UIDropDownMenu_DisableDropDown(LCDWOptionsFrame.dropDownName)

-- end DROPDOWNS --

-- slash commands --
SLASH_LECODEXDEWILLIOS1 = '/lcdw'
SlashCmdList["LECODEXDEWILLIOS"] = function()
    LCDWFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --
local f = CreateFrame("Frame", nil, UIParent, "UIPanelDialogTemplate")
f:SetSize(400, 400)
f:SetPoint("CENTER")

f.scrollFrame = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
f.scrollFrame:SetPoint("TOPLEFT", f, "TOPLEFT", 4, 4)
f.scrollFrame:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 4, 40)


local child = CreateFrame("Frame", nil, f.scrollFrame)
child:SetSize(f:GetWidth(), f:GetHeight() * 2)

child.b = CreateFrame("Button", nil, child, "GameMenuButtonTemplate")
child.b:SetSize(150, 60)
child.b:SetPoint("CENTER")
child.b:SetText("child")


child.bg = child:CreateTexture(nil, "BACKGROUND")
child.bg:SetAllPoints(true)
child.bg:SetColorTexture(0.2, 0.6, 0, 0.8)
f.scrollFrame:SetScrollChild(child)

f.ScrollFrame.ScrollBar:ClearAllPoints();
f.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", f.ScrollFrame, "TOPRIGHT", -12, -18);
f.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", f.ScrollFrame, "BOTTOMRIGHT", -7, 18);
--f.ScrollFrame:SetClipsChildren(true);