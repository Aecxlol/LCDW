--------------------------------------------------------
--/////////////////////// VARS ///////////////////////--
--------------------------------------------------------
local name, _ = ...
local customAddonName = "Le codex de Willios"
local addonVersion = "0.4 Alpha"

local LCDWOptionsFrame = nil

local MAIN_FRAME_WITH = 715
local MAIN_FRAME_HEIGHT = 500
local CHOICE_FRAME_WIDTH = 250
local FRAME_TITLE_CONTAINER_WIDTH = 100
local FRAME_TITLE_CONTAINER_HEIGHT = 20
local FOLDER_GUIDES_PATH = "Interface\\AddOns\\LCDW\\guides\\pve\\"
local MINIMAP_ICON_PATH = "Interface\\AddOns\\LCDW\\misc\\minimap-icon"
local DUNGEONS_ICONS_PATH = "Interface\\ENCOUNTERJOURNAL\\UI-EJ-DUNGEONBUTTON-"
local CLASSES_ICONS_PATH = "Interface\\ICONS\\ClassIcon_"
local ARROW_TITLE_SECTION = "Interface\\RAIDFRAME\\UI-RAIDFRAME-ARROW"
local ROW_MAX_DUNGEONS_ITEMS = 4
local ROW_MAX_CLASSES_ITEMS = 6
local ARRAY_FIRST_COL = 1
local ARRAY_SECOND_COL = 2
local SPACE_BETWEEN_CLASSES_ITEMS = 30
local CURRENT_BUILD, _, _, _ = GetBuildInfo()

local GREEN =  "|cff00ff00"
local YELLOW = "|cffffff00"
local RED =    "|cffff0000"
local BLUE =   "|cff0198e1"
local ORANGE = "|cffff9933"
local WHITE =  "|cffffffff"

local textures = {}
local textureShown = {}
local dungeonsFrames = {}
local classesFrames = {}

local dungeonSelected = nil
local classSelected = nil

local dungeons = {
    {"Sillage nécrotique", DUNGEONS_ICONS_PATH .. "Maraudon"},
    {"Malepeste", DUNGEONS_ICONS_PATH .. "BlackrockDepths"},
    {"Brumes de Tirna Scrithe", DUNGEONS_ICONS_PATH .. "Deadmines"},
    {"Salles de l'Expiation", DUNGEONS_ICONS_PATH .. "DireMaul"},
    {"Flèches de l'Ascension", DUNGEONS_ICONS_PATH .. "RagefireChasm"},
    {"Théâtre de la Souffrance", DUNGEONS_ICONS_PATH .. "ScarletMonastery"},
    {"L'Autre côté", DUNGEONS_ICONS_PATH .. "Scholomance"},
    {"Profondeurs Sanguines", DUNGEONS_ICONS_PATH .. "ShadowFangKeep"}
}
local classes = {
    {"Chaman", CLASSES_ICONS_PATH .. "Shaman"},
    {"Chasseur", CLASSES_ICONS_PATH .. "Hunter"},
    {"Chasseur de Démon", CLASSES_ICONS_PATH .. "DemonHunter"},
    {"Chevalier de la Mort", CLASSES_ICONS_PATH .. "DeathKnight"},
    {"Démoniste", CLASSES_ICONS_PATH .. "Warlock"},
    {"Druide", CLASSES_ICONS_PATH .. "Druid"},
    {"Guerrier", CLASSES_ICONS_PATH .. "Warrior"},
    {"Mage", CLASSES_ICONS_PATH .. "Mage"},
    {"Moine", CLASSES_ICONS_PATH .. "Monk"},
    {"Paladin", CLASSES_ICONS_PATH .. "Paladin"},
    {"Prêtre", CLASSES_ICONS_PATH .. "Priest"},
    {"Voleur", CLASSES_ICONS_PATH .. "Rogue"}
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
--------------------------------------------------------
--///////////////////// END VARS /////////////////////--
--------------------------------------------------------

local function initTextureShown()
    for dungeonId, v in ipairs(dungeons) do
        textureShown["isTexture" .. dungeonId .. "Shown"] = false
    end
end

local function onEvent(self, event, arg1, ...)
    if(event == "ADDON_LOADED" and name == arg1) then
        initTextureShown()
        print(BLUE.. customAddonName .."|r loaded! Type /lcdw to access to the guides.")
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", onEvent)

--------------------------------------------------------
--/////////////// MAIN FRAME (Général) ///////////////--
--------------------------------------------------------
local LCDWFrame = CreateFrame("Frame", nil, UIParent, "InsetFrameTemplate")
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
-- title container --
LCDWFrame.titleContainerFrame = CreateFrame("Frame", nil, LCDWFrame, "GlowBoxTemplate")
LCDWFrame.titleContainerFrame:SetSize(FRAME_TITLE_CONTAINER_WIDTH, FRAME_TITLE_CONTAINER_HEIGHT)
LCDWFrame.titleContainerFrame:SetPoint("CENTER",  LCDWFrame, "TOP", 0, 0)
-- title --
LCDWFrame.titleContainerFrame.title = LCDWFrame.titleContainerFrame:CreateFontString(nil, "OVERLAY")
LCDWFrame.titleContainerFrame.title:SetFontObject("GameFontHighLight")
LCDWFrame.titleContainerFrame.title:SetPoint("CENTER", LCDWFrame.titleContainerFrame, "CENTER", 0, 0)
LCDWFrame.titleContainerFrame.title:SetText("Général")
-- close button --
LCDWFrame.CloseButton = CreateFrame("Button", nil, LCDWFrame, "UIPanelCloseButton")
LCDWFrame.CloseButton:SetPoint("CENTER", LCDWFrame, "TOPRIGHT", -20, -20)
LCDWFrame.CloseButton:SetScript("OnClick", function(self, Button, Down)
    LCDWFrame:Hide()
end)
-- open options panel button --
LCDWFrame.openOptionsFrameButton = CreateFrame("Button", nil, LCDWFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWFrame.openOptionsFrameButton:SetSize(45, 45)
LCDWFrame.openOptionsFrameButton:SetPoint("CENTER", LCDWFrame, "TOPRIGHT", -25, -55)
LCDWFrame.openOptionsFrameButton:SetBackdrop({
    bgFile = "Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up",
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
-- open options panel button hover --
LCDWFrame.openOptionsFrameButton.Hover = LCDWFrame.openOptionsFrameButton:CreateTexture(nil, "BACKGROUND")
LCDWFrame.openOptionsFrameButton.Hover:SetTexture("Interface\\Buttons\\CheckButtonGlow")
LCDWFrame.openOptionsFrameButton.Hover:SetAllPoints(LCDWFrame.openOptionsFrameButton)
LCDWFrame.openOptionsFrameButton.Hover:SetAlpha(0)
LCDWFrame.openOptionsFrameButton:SetScript("OnEnter", function()
    LCDWFrame.openOptionsFrameButton.Hover:SetAlpha(1)
end);
LCDWFrame.openOptionsFrameButton:SetScript("OnLeave", function()
    LCDWFrame.openOptionsFrameButton.Hover:SetAlpha(0)
end);
LCDWFrame.openOptionsFrameButton:SetScript("OnClick", function()
    if LCDWOptionsFrame:IsShown() then
        LCDWOptionsFrame:Hide()
        LCDWFrame.openOptionsFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    else
        LCDWOptionsFrame:Show()
        LCDWFrame.openOptionsFrameButton:SetBackdrop({
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
------------------------------
--// secondary main frame //--
------------------------------
-- this frame contains the whole content of the mainFrame but the frame title, the close button and the open options button --
-- it will be easier to hide all elements when a dungeons is selected --
LCDWFrame.allElementsContainerFrame = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.allElementsContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
LCDWFrame.allElementsContainerFrame:SetPoint("CENTER", LCDWFrame, "CENTER")
-- create a section name container --
local function createSectionNameContainer(frameName, relativePoint, ofsy, title)
    -- dungeons section name container dungeonsSectionNameContainer --
    LCDWFrame.frameName = CreateFrame("Frame", nil, LCDWFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
    LCDWFrame.frameName:SetSize(200, 30)
    LCDWFrame.frameName:SetPoint("LEFT", LCDWFrame.allElementsContainerFrame, relativePoint, 40, ofsy)
    LCDWFrame.frameName:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    })
    -- arrow on the left of the container --
    LCDWFrame.frameName.arrowTitle = CreateFrame("Frame", nil, LCDWFrame.frameName, BackdropTemplateMixin and "BackdropTemplate")
    LCDWFrame.frameName.arrowTitle:SetSize(32, 32)
    LCDWFrame.frameName.arrowTitle:SetPoint("LEFT", LCDWFrame.frameName, "LEFT")
    LCDWFrame.frameName.arrowTitle:SetBackdrop({
        bgFile = ARROW_TITLE_SECTION
    })
    -- dungeons section name --
    LCDWFrame.frameName.sectionTitle = LCDWFrame.frameName:CreateFontString(nil, "OVERLAY")
    LCDWFrame.frameName.sectionTitle:SetFontObject("GameFontHighLight")
    LCDWFrame.frameName.sectionTitle:SetPoint("CENTER", LCDWFrame.frameName, "CENTER")
    LCDWFrame.frameName.sectionTitle:SetText(title)
end
createSectionNameContainer("dungeonsSectionNameContainer", "TOPLEFT", -50, "Guides PVE")
createSectionNameContainer("classesSectionNameContainer", "LEFT", -46, "Guides PVP")
------------------------------
--// tertiary main frame  //--
------------------------------
---@todo faire une frame qui englobe le titre et l'icone
local function showGuide(icon, name, id)
    -- frame that appears after selecting a guide --
    LCDWFrame.titleAndGuideContainerFrame = CreateFrame("Frame", nil, LCDWFrame)
    LCDWFrame.titleAndGuideContainerFrame:SetSize(LCDWFrame:GetWidth(), LCDWFrame:GetHeight())
    LCDWFrame.titleAndGuideContainerFrame:SetPoint("CENTER", LCDWFrame, "CENTER")
    -- title --
    LCDWFrame.titleAndGuideContainerFrame.title = LCDWFrame.titleAndGuideContainerFrame:CreateFontString(nil, "OVERLAY")
    LCDWFrame.titleAndGuideContainerFrame.title:SetFontObject("GameFontHighlightLarge")
    LCDWFrame.titleAndGuideContainerFrame.title:SetPoint("CENTER", LCDWFrame.titleAndGuideContainerFrame, "TOP", 0, -50)
    LCDWFrame.titleAndGuideContainerFrame.title:SetText(name)
    -- icon --
    if icon then
        LCDWFrame.titleAndGuideContainerFrame.icon = LCDWFrame.titleAndGuideContainerFrame:CreateTexture(nil, "ARTWORK")
        LCDWFrame.titleAndGuideContainerFrame.icon:SetSize(30, 30)
        LCDWFrame.titleAndGuideContainerFrame.icon:SetPoint("CENTER", LCDWFrame.titleAndGuideContainerFrame, "TOP", -100, -50)
        LCDWFrame.titleAndGuideContainerFrame.icon:SetTexture(classes[id][ARRAY_SECOND_COL])
    end
    -- core image --
    textures["texture" .. id] = LCDWFrame.titleAndGuideContainerFrame:CreateTexture(nil, "ARTWORK")
    textures["texture" .. id]:SetPoint("CENTER", LCDWFrame.titleAndGuideContainerFrame, "CENTER", 0, -30)
    textures["texture" .. id]:SetSize(400, 400)
    textures["texture" .. id]:SetTexture(FOLDER_GUIDES_PATH .. 1)
end
--------------------------------------------------------
--///////////// END MAIN FRAME (Général) /////////////--
--------------------------------------------------------



--------------------------------------------------------
--///////////// OPTIONS FRAME (Options) //////////////--
--------------------------------------------------------
LCDWOptionsFrame = CreateFrame("Frame", nil, LCDWFrame, "InsetFrameTemplate")
LCDWOptionsFrame:SetSize(CHOICE_FRAME_WIDTH, LCDWFrame:GetHeight())
LCDWOptionsFrame:SetPoint("LEFT", LCDWFrame, "RIGHT", -5, 0)
LCDWOptionsFrame.LCDWOptionsFrameNameContainer = CreateFrame("Frame", nil, LCDWOptionsFrame, "GlowBoxTemplate")
LCDWOptionsFrame.LCDWOptionsFrameNameContainer:SetSize(FRAME_TITLE_CONTAINER_WIDTH, FRAME_TITLE_CONTAINER_HEIGHT)
LCDWOptionsFrame.LCDWOptionsFrameNameContainer:SetPoint("CENTER",  LCDWOptionsFrame, "TOP", 0, 0)
LCDWOptionsFrame.LCDWOptionsFrameNameContainer.title = LCDWOptionsFrame.LCDWOptionsFrameNameContainer:CreateFontString(nil, "OVERLAY")
LCDWOptionsFrame.LCDWOptionsFrameNameContainer.title:SetFontObject("GameFontHighLight")
LCDWOptionsFrame.LCDWOptionsFrameNameContainer.title:SetPoint("CENTER", LCDWOptionsFrame.LCDWOptionsFrameNameContainer, "CENTER", 0, 0)
LCDWOptionsFrame.LCDWOptionsFrameNameContainer.title:SetText("Options")
LCDWOptionsFrame.resetButton = CreateFrame("Button", nil, LCDWOptionsFrame, "UIPanelButtonTemplate")
LCDWOptionsFrame.resetButton:SetSize(100, 30)
LCDWOptionsFrame.resetButton:SetPoint("CENTER", 0, 0)
LCDWOptionsFrame.resetButton:SetText("Reset")
LCDWOptionsFrame.resetButton:SetScript("OnClick", function ()
    if LCDWFrame.titleAndGuideContainerFrame:IsShown() then
        LCDWFrame.titleAndGuideContainerFrame:Hide()
    end
    if not LCDWFrame.allElementsContainerFrame:IsShown() then
        LCDWFrame.allElementsContainerFrame:Show()
    end
end)
LCDWOptionsFrame.credits = CreateFrame("Frame", nil, LCDWOptionsFrame, BackdropTemplateMixin and "BackdropTemplate")
LCDWOptionsFrame.credits:SetSize(LCDWOptionsFrame:GetWidth() - 6, 20)
LCDWOptionsFrame.credits:SetPoint("BOTTOM", LCDWOptionsFrame, "BOTTOM", 0, 3)
LCDWOptionsFrame.credits:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
LCDWOptionsFrame.credits.content = LCDWOptionsFrame.credits:CreateFontString(nil, "OVERLAY")
LCDWOptionsFrame.credits.content:SetFontObject("GameFontHighlightSmall")
LCDWOptionsFrame.credits.content:SetPoint("CENTER", LCDWOptionsFrame.credits, "CENTER")
LCDWOptionsFrame.credits.content:SetText("Made by Aecx & Willios - v." .. addonVersion)
LCDWOptionsFrame.mmButtonOption = CreateFrame("CheckButton", nil, LCDWOptionsFrame, "UICheckButtonTemplate")
LCDWOptionsFrame.mmButtonOption:SetPoint("LEFT", LCDWOptionsFrame, "BOTTOMLEFT", 15, 50)
LCDWOptionsFrame.mmButtonOption.text:SetText("Cacher l'icône de la minimap")
LCDWOptionsFrame.mmButtonOption:SetChecked(false)
LCDWOptionsFrame.mmButtonOption:SetScript("OnClick", function()
    --icon:Show()
end)
--------------------------------------------------------
--//////////// END OPTIONS FRAME (Options) ///////////--
--------------------------------------------------------
local function createTexture(dungeonId)
    textures["texture" .. dungeonId] = LCDWFrame:CreateTexture(nil, "ARTWORK")
    textures["texture" .. dungeonId]:SetPoint("CENTER", LCDWFrame, "CENTER", 0, 0)
    textures["texture" .. dungeonId]:SetSize(450, 450)
    textures["texture" .. dungeonId]:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
    return textures["texture" .. dungeonId]
end

local function generateDungeonsFrames()

    local frameWidth = 200
    local frameHeight = 100
    local buttonTexture = "Interface\\ENCOUNTERJOURNAL\\UI-EncounterJournalTextures"

    for dungeonsK, dungeonV in ipairs(dungeons) do

        -- dungeons thumbnail --
        dungeonsFrames["dungeonFrame" .. dungeonsK] = CreateFrame("Frame", nil, LCDWFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetSize(frameWidth, frameHeight)
        -- dungeons title --
        dungeonsFrames["dungeonFrame" .. dungeonsK].title =  dungeonsFrames["dungeonFrame" .. dungeonsK]:CreateFontString(nil, "OVERLAY")
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetFontObject("GameFontHighlightSmall")
        -- dungeons thumbnails borders and click hander --
        dungeonsFrames["dungeonFrame" .. dungeonsK].border = CreateFrame("Button", nil, dungeonsFrames["dungeonFrame" .. dungeonsK])

        -- If 4 dungeons frame are displayed then ddd a new line --
        if dungeonsK > ROW_MAX_DUNGEONS_ITEMS then
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT",  LCDWFrame.allElementsContainerFrame, "TOPLEFT", 45 + ((frameWidth / 1.5 * (dungeonsK - 5)) + (SPACE_BETWEEN_CLASSES_ITEMS * (dungeonsK - 5))), -230)
        else
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT",  LCDWFrame.allElementsContainerFrame, "TOPLEFT", 45 + ((frameWidth / 1.5 * (dungeonsK - 1)) + (SPACE_BETWEEN_CLASSES_ITEMS * (dungeonsK - 1))), -140)
        end

        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetBackdrop({
            bgFile = dungeons[dungeonsK][ARRAY_SECOND_COL],
        })

        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetPoint("CENTER", dungeonsFrames["dungeonFrame" .. dungeonsK], "LEFT", 45, 0)
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetText(dungeons[dungeonsK][ARRAY_FIRST_COL])
        dungeonsFrames["dungeonFrame" .. dungeonsK].title:SetWidth(70)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetPoint("TOPLEFT", dungeonsFrames["dungeonFrame" .. dungeonsK], "TOPLEFT", 0, 0)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetSize(135, 73)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetNormalTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetHighlightTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetPushedTexture(buttonTexture)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetNormalTexture():SetTexCoord(0, 0.34, 0.428, 0.522)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetHighlightTexture():SetTexCoord(0.345, 0.68, 0.333, 0.425)
        dungeonsFrames["dungeonFrame" .. dungeonsK].border:GetPushedTexture():SetTexCoord(0, 0.34, 0.332, 0.425)

        dungeonsFrames["dungeonFrame" .. dungeonsK].border:SetScript("OnClick", function (self, button)
            LCDWFrame.allElementsContainerFrame:Hide()
            showGuide(nil, dungeons[dungeonsK][ARRAY_FIRST_COL], dungeonsK)
        end)
    end
end

generateDungeonsFrames()

local function generateClassesFrames()
    for classesK, classesV in ipairs(classes) do
        local frameWidth = 48
        local frameHeight = 48

        classesFrames["classeFrame" .. classesK] = CreateFrame("Button", nil, LCDWFrame.allElementsContainerFrame, BackdropTemplateMixin and "BackdropTemplate")
        classesFrames["classeFrame" .. classesK]:SetSize(frameWidth, frameHeight)

        -- If 4 dungeons frame are displayed then ddd a new line --
        if classesK > ROW_MAX_CLASSES_ITEMS then
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT",  LCDWFrame.allElementsContainerFrame, "LEFT", 139 + ((frameWidth * (classesK - 7)) + (SPACE_BETWEEN_CLASSES_ITEMS * (classesK - 7))), -185)
        else
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT",  LCDWFrame.allElementsContainerFrame, "LEFT", 139 + ((frameWidth * (classesK - 1)) + (SPACE_BETWEEN_CLASSES_ITEMS * (classesK - 1))), -125)
        end

        classesFrames["classeFrame" .. classesK]:SetBackdrop({
            --bgFile = FOLDER_GUIDES_PATH .. dungeonsK,
            bgFile = classes[classesK][ARRAY_SECOND_COL],
            --edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 10, edgeSize = 10,
            insets = { left = 2, right = 0, top = 2, bottom = 0 }
        })

        classesFrames["classeFrame" .. classesK]:SetScript("OnClick", function (self, button)
            LCDWFrame.allElementsContainerFrame:Hide()
            guideFrame(true, classes[classesK][ARRAY_FIRST_COL], classesK)
        end)
    end
end

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
    UIDropDownMenu_SetText(LCDWFrame.OptionsFrame.dropDown, "Donjon : " .. arg2)
    dungeonSelected = arg1

    for dungeonId, dungeon in ipairs(dungeons) do

        -- if the dungeon is different that the one selected
        if dungeonId ~= arg1 then
            -- then check which one is currently shown
            if textureShown["isTexture" .. dungeonId .. "Shown"] == true then
                -- Hide it
                textures["texture" .. dungeonId]:Hide()
                -- and set it to false (which means it's now hidden)
                textureShown["isTexture" .. dungeonId .. "Shown"] = false
            end
            -- for the dungeon selected
        else
            -- check if the selected one is hidden
            if textureShown["isTexture" .. dungeonId .. "Shown"] == false then
                -- if it is, create the texture according to the dungeon selected
                createTexture(dungeonId)
                -- and set it to true (which means it's now shown)
                textureShown["isTexture" .. dungeonId .. "Shown"] = true
            end
        end
    end
end
-- end onclick event --

-- display the dungeons' list --
local function DungeonsListDropDown(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo()
    info.func = DungeonsListDropDown_OnClick

    if level == 1 then
        -- Outermost menu level
        for i, dungeon in ipairs(dungeons) do
            info.text, info.arg1, info.arg2, info.checked = dungeon, i, dungeon, i == dungeonSelected
            UIDropDownMenu_AddButton(info)
        end
    end
end
-- end --

-- Onlick classes dropdown items --
local function ClassesListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(LCDWFrame.OptionsFrame.classDropDown, "Classe : " .. arg2)
    classSelected = arg1

    for classId, dungeon in ipairs(classes) do
        if arg1 == classId then
            -- display the dropdown LCDWFrame.dropDown which is greyed out
            --UIDropDownMenu_EnableDropDown(LCDWFrame.dropDown)
        end
    end
end
-- end onclick event --

-- display the classes' list --
local function ClassesListDropDown(frame, level, menuList)
    local info = UIDropDownMenu_CreateInfo()
    info.func = ClassesListDropDown_OnClick

    if level == 1 then
        -- Outermost menu level
        for i, class in ipairs(classes) do
            info.text, info.arg1, info.arg2, info.checked = class, i, class, i == classSelected
            UIDropDownMenu_AddButton(info)
        end
    end
end
-- end --

-- DROPDOWNS --
local function createDropdown(dropDownName, frameName, ofsy, setTextContent)
    LCDWOptionsFrame.dropDownName = CreateFrame("Frame", frameName, LCDWOptionsFrame, "UIDropDownMenuTemplate")
    LCDWOptionsFrame.dropDownName:SetPoint("CENTER", LCDWOptionsFrame, "TOP", 0, ofsy)
    UIDropDownMenu_SetWidth(LCDWOptionsFrame.dropDownName, 200)
    UIDropDownMenu_Initialize(LCDWOptionsFrame.dropDownName, DungeonsListDropDown)
    UIDropDownMenu_SetText(LCDWOptionsFrame.dropDownName, setTextContent)
    UIDropDownMenu_DisableDropDown(LCDWOptionsFrame.dropDownName)
end
createDropdown("dropDown", "WPDungeonsListDropDown", -150, "-- Sélectionner un donjon --")
createDropdown("classDropDown", "WPClassDropDown", -200, "-- Sélectionner une classe --")
-- end DROPDOWNS --

-- slash commands --
SLASH_LECODEXDEWILLIOS1 = '/lcdw'
SlashCmdList["LECODEXDEWILLIOS"] = function()
    LCDWFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --