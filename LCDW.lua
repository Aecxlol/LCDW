local name, _ = ...
local customAddonName = "Le codex de Willios"
local addonVersion = "0.1 Alpha"

local MAIN_FRAME_WITH = 715
local MAIN_FRAME_HEIGHT = 500
local CHOICE_FRAME_WIDTH = 250
local FRAME_TITLE_CONTAINER_WIDTH = 100
local FRAME_TITLE_CONTAINER_HEIGHT = 20
local FOLDER_GUIDES_PATH = "Interface\\AddOns\\LCDW\\guides\\pve\\"
local MINIMAP_ICON_PATH = "Interface\\AddOns\\LCDW\\misc\\minimap-icon"
local DUNGEONS_ICONS_PATH = "Interface\\ENCOUNTERJOURNAL\\UI-EJ-DUNGEONBUTTON-"
local CLASSES_ICONS_PATH = "Interface\\ICONS\\ClassIcon_"
local SECTION_ARROW_PATH = "Interface\\RAIDFRAME\\UI-RAIDFRAME-ARROW"
local ROW_MAX_DUNGEONS_ITEMS = 4
local ROW_MAX_CLASSES_ITEMS = 6
local DUNGEONS_ARRAY_SECOND_COL = 2
local SPACE_BETWEEN_CLASSES_ITEMS = 30
local CURRENT_BUILD, _, _, _ = GetBuildInfo()

local textures = {}
local textureShown = {}
local dungeonsFrames = {}
local classesFrames = {}

local GREEN =  "|cff00ff00"
local YELLOW = "|cffffff00"
local RED =    "|cffff0000"
local BLUE =   "|cff0198e1"
local ORANGE = "|cffff9933"
local WHITE =  "|cffffffff"

local dungeonSelected = nil
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

local classSelected = nil
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

-- // CLASS ICON DANS INTERFACE ICONS
-- // DJ ICON DANS INTERFACE ENCOUNTERJOURNAL UI-EJ-DUNGEONBUTTON-Maraudon

local LCDW = LibStub("AceAddon-3.0"):NewAddon("LCDW", "AceConsole-3.0")
local icon = LibStub("LibDBIcon-1.0")
local defaults = {
    profile = {
        minimap = {
            hide = false
        }
    }
}

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

-- MainFrame --
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
--LCDWFrame:SetBackdrop( {
--    bgFile = "Interface\\QUESTFRAME\\QuestBookBG",
--    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 32, edgeSize = 32,
--    insets = { left = 11, right = 12, top = 12, bottom = 11 }
--})
-- end MainFrame --


local function generateDungeonsFrames()
    for dungeonsK, dungeonV in ipairs(dungeons) do
        local frameWidth = 128
        local frameHeight = 64

        dungeonsFrames["dungeonFrame" .. dungeonsK] = CreateFrame("Button", nil, LCDWFrame)
        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetSize(frameWidth, frameHeight)

        -- If 4 dungeons frame are displayed then ddd a new line --
        if dungeonsK > ROW_MAX_DUNGEONS_ITEMS then
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT",  LCDWFrame, "TOPLEFT", ((dungeonsK - 4) * frameWidth * 1.3) - frameWidth, frameHeight * -3.3)
        else
            dungeonsFrames["dungeonFrame" .. dungeonsK]:SetPoint("LEFT",  LCDWFrame, "TOPLEFT", (dungeonsK * frameWidth * 1.3) - frameWidth, -130)
        end

        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetBackdrop({
            bgFile = dungeons[dungeonsK][DUNGEONS_ARRAY_SECOND_COL],
            --edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 15, edgeSize = 15,
            insets = { left = 2, right = -60, top = 2, bottom = -20 }
        })

        dungeonsFrames["dungeonFrame" .. dungeonsK]:SetScript("OnClick", function (self, button)
            print(dungeonsFrames["dungeonFrame" .. dungeonsK]:GetSize())
        end)
    end
end

generateDungeonsFrames()

local function generateClassesFrames()
    for classesK, classesV in ipairs(classes) do
        local frameWidth = 48
        local frameHeight = 48

        classesFrames["classeFrame" .. classesK] = CreateFrame("Button", nil, LCDWFrame)
        classesFrames["classeFrame" .. classesK]:SetSize(frameWidth, frameHeight)

        -- If 4 dungeons frame are displayed then ddd a new line --
        if classesK > ROW_MAX_CLASSES_ITEMS then
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT",  LCDWFrame, "LEFT", 139 + ((frameWidth * (classesK - 7)) + (SPACE_BETWEEN_CLASSES_ITEMS * (classesK - 7))), -185)
        else
            classesFrames["classeFrame" .. classesK]:SetPoint("LEFT",  LCDWFrame, "LEFT", 139 + ((frameWidth * (classesK - 1)) + (SPACE_BETWEEN_CLASSES_ITEMS * (classesK - 1))), -125)
        end

        classesFrames["classeFrame" .. classesK]:SetBackdrop({
            --bgFile = FOLDER_GUIDES_PATH .. dungeonsK,
            bgFile = classes[classesK][DUNGEONS_ARRAY_SECOND_COL],
            --edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 10, edgeSize = 10,
            insets = { left = 2, right = 0, top = 2, bottom = 0 }
        })

        classesFrames["classeFrame" .. classesK]:SetScript("OnClick", function (self, button)
            print(classesFrames["classeFrame" .. classesK]:GetSize())
        end)
    end
end

generateClassesFrames()

-- MainFrame title container --
LCDWFrame.LCDWMainFrameNameContainer = CreateFrame("Frame", nil, LCDWFrame, "GlowBoxTemplate")
LCDWFrame.LCDWMainFrameNameContainer:SetSize(FRAME_TITLE_CONTAINER_WIDTH, FRAME_TITLE_CONTAINER_HEIGHT)
LCDWFrame.LCDWMainFrameNameContainer:SetPoint("CENTER",  LCDWFrame, "TOP", 0, 0)
-- end MainFrame title container --

-- Title's MainFrame --
LCDWFrame.LCDWMainFrameNameContainer.title = LCDWFrame.LCDWMainFrameNameContainer:CreateFontString(nil, "OVERLAY")
LCDWFrame.LCDWMainFrameNameContainer.title:SetFontObject("GameFontHighLight")
LCDWFrame.LCDWMainFrameNameContainer.title:SetPoint("CENTER", LCDWFrame.LCDWMainFrameNameContainer, "CENTER", 0, 0)
LCDWFrame.LCDWMainFrameNameContainer.title:SetText("Général")
-- end title's mainFrame --

-- Close button --
LCDWFrame.CloseButton = CreateFrame("Button", nil, LCDWFrame, "UIPanelCloseButton")
LCDWFrame.CloseButton:SetPoint("CENTER", LCDWFrame, "TOPRIGHT", -20, -20)
LCDWFrame.CloseButton:SetScript("OnClick", function(self, Button, Down)
    LCDWFrame:Hide()
end)
-- End Close button --

-- Resize frame --
--LCDWFrame.resizeButton = CreateFrame("Button", nil, LCDWFrame)
--LCDWFrame.resizeButton:SetPoint("BOTTOMRIGHT", 0, 0)
--LCDWFrame.resizeButton:SetSize(16, 16)
--LCDWFrame.resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
--LCDWFrame.resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
--LCDWFrame.resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
--
--LCDWFrame.resizeButton:SetScript("OnMouseDown", function()
--    LCDWFrame:StartSizing("BOTTOMRIGHT")
--end)
--LCDWFrame.resizeButton:SetScript("OnMouseUp", function()
--    LCDWFrame:StopMovingOrSizing()
--end)
-- end resize frame --

-- openChoicesFrameButton arrow --
LCDWFrame.openChoicesFrameButton = CreateFrame("Button", nil, LCDWFrame)
LCDWFrame.openChoicesFrameButton:SetSize(45, 45)
LCDWFrame.openChoicesFrameButton:SetPoint("CENTER", LCDWFrame, "TOPRIGHT", -25, -55)
LCDWFrame.openChoicesFrameButton:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
LCDWFrame.openChoicesFrameButton.Hover = LCDWFrame.openChoicesFrameButton:CreateTexture(nil, "BACKGROUND")
LCDWFrame.openChoicesFrameButton.Hover:SetTexture("Interface\\Buttons\\CheckButtonGlow")
LCDWFrame.openChoicesFrameButton.Hover:SetAllPoints(LCDWFrame.openChoicesFrameButton)
LCDWFrame.openChoicesFrameButton.Hover:SetAlpha(0)

LCDWFrame.openChoicesFrameButton:SetScript("OnEnter", function()
    LCDWFrame.openChoicesFrameButton.Hover:SetAlpha(1)
end);
--
LCDWFrame.openChoicesFrameButton:SetScript("OnLeave", function()
    LCDWFrame.openChoicesFrameButton.Hover:SetAlpha(0)
end);

LCDWFrame.openChoicesFrameButton:SetScript("OnClick", function()
    if LCDWFrame.choicesFrame:IsShown() then
        LCDWFrame.choicesFrame:Hide()
        LCDWFrame.openChoicesFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    else
        LCDWFrame.choicesFrame:Show()
        LCDWFrame.openChoicesFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    end
end);
-- end openChoicesFrameButton arrow --

-- Choices Frame --
LCDWFrame.choicesFrame = CreateFrame("Frame", nil, LCDWFrame, "InsetFrameTemplate")
LCDWFrame.choicesFrame:SetSize(CHOICE_FRAME_WIDTH, LCDWFrame:GetHeight())
LCDWFrame.choicesFrame:SetPoint("LEFT", LCDWFrame, "RIGHT", -5, 0)
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer = CreateFrame("Frame", nil, LCDWFrame.choicesFrame, "GlowBoxTemplate")
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer:SetSize(FRAME_TITLE_CONTAINER_WIDTH, FRAME_TITLE_CONTAINER_HEIGHT)
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer:SetPoint("CENTER",  LCDWFrame.choicesFrame, "TOP", 0, 0)
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer.title = LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer:CreateFontString(nil, "OVERLAY")
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer.title:SetFontObject("GameFontHighLight")
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer.title:SetPoint("CENTER", LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer, "CENTER", 0, 0)
LCDWFrame.choicesFrame.LCDWChoicesFrameNameContainer.title:SetText("Options")
LCDWFrame.choicesFrame.resetButton = CreateFrame("Button", nil, LCDWFrame.choicesFrame, "UIPanelButtonTemplate")
LCDWFrame.choicesFrame.resetButton:SetSize(100, 30)
LCDWFrame.choicesFrame.resetButton:SetPoint("CENTER", 0, 0)
LCDWFrame.choicesFrame.resetButton:SetText("Reset")
LCDWFrame.choicesFrame.resetButton:SetScript("OnClick", function ()

end)
-- end Choices Frame --

-- checkboxes --
--LCDWFrame.choicesFrame.pveCheckButton = CreateFrame("CheckButton", nil, LCDWFrame.choicesFrame, "UIRadioButtonTemplate")
--LCDWFrame.choicesFrame.pveCheckButton:SetPoint("LEFT", LCDWFrame.choicesFrame, "TOPLEFT", 20, -50)
--LCDWFrame.choicesFrame.pveCheckButton:SetText("PVECheckbox")
--LCDWFrame.choicesFrame.pveCheckButton.tooltip = "PVE"
--LCDWFrame.choicesFrame.pveCheckButton:SetScript("OnClick", function ()
--    if LCDWFrame.choicesFrame.pveCheckButton:GetChecked() then
--        UIDropDownMenu_EnableDropDown(LCDWFrame.dropDown)
--        LCDWFrame.choicesFrame.pvpCheckButton:Disable()
--    else
--        UIDropDownMenu_DisableDropDown(LCDWFrame.dropDown)
--        LCDWFrame.choicesFrame.pvpCheckButton:Enable()
--    end
--end)
--
--LCDWFrame.choicesFrame.pvpCheckButton = CreateFrame("CheckButton", nil, LCDWFrame.choicesFrame, "ChatConfigCheckButtonTemplate")
--LCDWFrame.choicesFrame.pvpCheckButton:SetPoint("LEFT", LCDWFrame.choicesFrame, "TOPLEFT", 20, -80)
--LCDWFrame.choicesFrame.pvpCheckButton:SetText("PVPCheckbox")
--LCDWFrame.choicesFrame.pvpCheckButton.tooltip = "PVP"
--LCDWFrame.choicesFrame.pvpCheckButton:SetScript("OnClick", function ()
--    if LCDWFrame.choicesFrame.pvpCheckButton:GetChecked() then
--        UIDropDownMenu_EnableDropDown(LCDWFrame.classDropDown)
--        LCDWFrame.choicesFrame.pveCheckButton:Disable()
--    else
--        UIDropDownMenu_DisableDropDown(LCDWFrame.classDropDown)
--        LCDWFrame.choicesFrame.pveCheckButton:Enable()
--    end
--end)
-- end checkboxes --

-- first section container  --
LCDWFrame.sectionNameContainer = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.sectionNameContainer:SetSize(200, 30)
LCDWFrame.sectionNameContainer:SetPoint("LEFT", LCDWFrame, "TOPLEFT", 40, -50)
LCDWFrame.sectionNameContainer:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
LCDWFrame.sectionNameContainer.arrowTitle = CreateFrame("Frame", nil, LCDWFrame.sectionNameContainer)
LCDWFrame.sectionNameContainer.arrowTitle:SetSize(32, 32)
LCDWFrame.sectionNameContainer.arrowTitle:SetPoint("LEFT", LCDWFrame.sectionNameContainer, "LEFT")
LCDWFrame.sectionNameContainer.arrowTitle:SetBackdrop({
    bgFile = SECTION_ARROW_PATH
})
LCDWFrame.sectionNameContainer.sectionTitle = LCDWFrame.sectionNameContainer:CreateFontString(nil, "OVERLAY")
LCDWFrame.sectionNameContainer.sectionTitle:SetFontObject("GameFontHighLight")
LCDWFrame.sectionNameContainer.sectionTitle:SetPoint("CENTER", LCDWFrame.sectionNameContainer, "CENTER")
LCDWFrame.sectionNameContainer.sectionTitle:SetText("Guides PVE")
-- end first section container --

-- second section container  --
LCDWFrame.sectionNameContainer = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.sectionNameContainer:SetSize(200, 30)
LCDWFrame.sectionNameContainer:SetPoint("LEFT", LCDWFrame, "LEFT", 40, -46)
LCDWFrame.sectionNameContainer:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
})
LCDWFrame.sectionNameContainer.arrowTitle = CreateFrame("Frame", nil, LCDWFrame.sectionNameContainer)
LCDWFrame.sectionNameContainer.arrowTitle:SetSize(32, 32)
LCDWFrame.sectionNameContainer.arrowTitle:SetPoint("LEFT", LCDWFrame.sectionNameContainer, "LEFT")
LCDWFrame.sectionNameContainer.arrowTitle:SetBackdrop({
    bgFile = SECTION_ARROW_PATH
})
LCDWFrame.sectionNameContainer.sectionTitle = LCDWFrame.sectionNameContainer:CreateFontString(nil, "OVERLAY")
LCDWFrame.sectionNameContainer.sectionTitle:SetFontObject("GameFontHighLight")
LCDWFrame.sectionNameContainer.sectionTitle:SetPoint("CENTER", LCDWFrame.sectionNameContainer, "CENTER")
LCDWFrame.sectionNameContainer.sectionTitle:SetText("Guides PVP")
-- end second section container --

-- MINIMAP --
local LCLWLDB = LibStub("LibDataBroker-1.1"):NewDataObject("WowGuides", {
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
    icon:Register("WG", LCLWLDB, self.db.profile.minimap)
    self:RegisterChatCommand("bunnies", "CommandTheBunnies")
end
-- END MINIMAP --

local function createTexture(dungeonId)
    textures["texture" .. dungeonId] = LCDWFrame:CreateTexture(nil, "ARTWORK")
    textures["texture" .. dungeonId]:SetPoint("CENTER", LCDWFrame, "CENTER", 0, 0)
    textures["texture" .. dungeonId]:SetSize(450, 450)
    textures["texture" .. dungeonId]:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
    return textures["texture" .. dungeonId]
end

-- Onlick Dungeons dropdown items --
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(LCDWFrame.dropDown, "Donjon : " .. arg2)
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
    UIDropDownMenu_SetText(LCDWFrame.classDropDown, "Classe : " .. arg2)
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
LCDWFrame.dropDown = CreateFrame("Frame", "WPDungeonsListDropDown", LCDWFrame.choicesFrame, "UIDropDownMenuTemplate")
LCDWFrame.dropDown:SetPoint("CENTER", LCDWFrame.choicesFrame, "TOP", 0, -150)
UIDropDownMenu_SetWidth(LCDWFrame.dropDown, 200)
UIDropDownMenu_Initialize(LCDWFrame.dropDown, DungeonsListDropDown)
UIDropDownMenu_SetText(LCDWFrame.dropDown, "-- Sélectionner un donjon --")
UIDropDownMenu_DisableDropDown(LCDWFrame.dropDown)

LCDWFrame.classDropDown = CreateFrame("Frame", "WPClassDropDown", LCDWFrame.choicesFrame, "UIDropDownMenuTemplate")
LCDWFrame.classDropDown:SetPoint("CENTER", LCDWFrame.choicesFrame, "TOP", 0, -200)
UIDropDownMenu_SetWidth(LCDWFrame.classDropDown, 200)
UIDropDownMenu_Initialize(LCDWFrame.classDropDown, ClassesListDropDown)
UIDropDownMenu_SetText(LCDWFrame.classDropDown, "-- Sélectionner votre classe --")
UIDropDownMenu_DisableDropDown(LCDWFrame.classDropDown)
-- end DROPDOWNS --

-- slash commands --
SLASH_LECODEXDEWILLIOS1 = '/lcdw'
SlashCmdList["LECODEXDEWILLIOS"] = function()
    LCDWFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --