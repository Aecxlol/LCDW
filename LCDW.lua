local name, _ = ...
local customAddonName = "Le codex de Willios"
local addonVersion = "0.1 Alpha"

local MAIN_FRAME_WITH = 500
local MAIN_FRAME_HEIGHT = 500
local CHOICE_FRAME_WIDTH = 250
local FOLDER_GUIDES_PATH = "Interface\\AddOns\\LCDW\\guides\\pve\\"
local MINIMAP_ICON_PATH = "Interface\\AddOns\\LCDW\\misc\\minimap-icon"
local ARROW_IMAGE = nil
local CURRENT_BUILD, _, _, _ = GetBuildInfo()

local textures = {}
local textureShown = {}

local GREEN =  "|cff00ff00"
local YELLOW = "|cffffff00"
local RED =    "|cffff0000"
local BLUE =   "|cff0198e1"
local ORANGE = "|cffff9933"
local WHITE =  "|cffffffff"

local dungeonSelected = nil
local dungeons = {
    "Sillage nécrotique",
    "Malepeste",
    "Brumes de Tirna Scrithe",
    "Salles de l'Expiation",
    "Flèches de l'Ascension",
    "Théâtre de la Souffrance",
    "L'Autre côté",
    "Profondeurs Sanguines",
}

local classSelected = nil
local classes = {
    "Chaman",
    "Chasseur",
    "Chasseur de Démon",
    "Chevalier de la Mort",
    "Démoniste",
    "Druide",
    "Guerrier",
    "Mage",
    "Moine",
    "Paladin",
    "Prêtre",
    "Voleur",
}

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
local LCDWFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
LCDWFrame:Hide()
LCDWFrame:SetSize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
LCDWFrame:SetPoint("CENTER", 0, 0)
LCDWFrame:SetMovable(true)
LCDWFrame:SetResizable(true)
LCDWFrame:EnableMouse(true)
LCDWFrame:SetMinResize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
LCDWFrame:RegisterForDrag("LeftButton")
LCDWFrame:SetScript("OnDragStart", LCDWFrame.StartMoving)
LCDWFrame:SetScript("OnDragStop", LCDWFrame.StopMovingOrSizing)
-- end MainFrame --

-- Title's MainFrame
LCDWFrame.title = LCDWFrame:CreateFontString(nil, "OVERLAY")
LCDWFrame.title:SetFontObject("GameFontHighLight")
LCDWFrame.title:SetPoint("CENTER", LCDWFrame.TitleBg, "CENTER", 0, 0)
LCDWFrame.title:SetText(customAddonName .. " - " .. addonVersion)
-- end title's mainFrame

-- Resize frame --
LCDWFrame.rb = CreateFrame("Button", nil, LCDWFrame)
LCDWFrame.rb:SetPoint("BOTTOMRIGHT", -5, 5)
LCDWFrame.rb:SetSize(16, 16)
LCDWFrame.rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
LCDWFrame.rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
LCDWFrame.rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

LCDWFrame.rb:SetScript("OnMouseDown", function()
    LCDWFrame:StartSizing("BOTTOMRIGHT")
end)
LCDWFrame.rb:SetScript("OnMouseUp", function()
    LCDWFrame:StopMovingOrSizing()
end)
-- end resize frame --

-- openChoiceFrameButton arrow --
LCDWFrame.openChoiceFrameButton = CreateFrame("Button", nil, LCDWFrame)
LCDWFrame.openChoiceFrameButton:SetSize(45, 45)
LCDWFrame.openChoiceFrameButton:SetPoint("CENTER", LCDWFrame, "TOPRIGHT", -30, -50)
LCDWFrame.openChoiceFrameButton:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
LCDWFrame.openChoiceFrameButton.Hover = LCDWFrame.openChoiceFrameButton:CreateTexture(nil, "BACKGROUND")
LCDWFrame.openChoiceFrameButton.Hover:SetTexture("Interface\\Buttons\\CheckButtonGlow")
LCDWFrame.openChoiceFrameButton.Hover:SetAllPoints(LCDWFrame.openChoiceFrameButton)
LCDWFrame.openChoiceFrameButton.Hover:SetAlpha(0)

LCDWFrame.openChoiceFrameButton:SetScript("OnEnter", function()
    LCDWFrame.openChoiceFrameButton.Hover:SetAlpha(1)
end);
--
LCDWFrame.openChoiceFrameButton:SetScript("OnLeave", function()
    LCDWFrame.openChoiceFrameButton.Hover:SetAlpha(0)
end);

LCDWFrame.openChoiceFrameButton:SetScript("OnClick", function()
    if LCDWFrame.choiceFrame:IsShown() then
        LCDWFrame.choiceFrame:Hide()
        LCDWFrame.openChoiceFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    else
        LCDWFrame.choiceFrame:Show()
        LCDWFrame.openChoiceFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    end
end);
-- end openChoiceFrameButton arrow --

-- Choices Frame --
LCDWFrame.choiceFrame = CreateFrame("Frame", nil, LCDWFrame)
LCDWFrame.choiceFrame:SetSize(CHOICE_FRAME_WIDTH, LCDWFrame:GetHeight())
LCDWFrame.choiceFrame:SetPoint("LEFT", LCDWFrame, "RIGHT", -5, 0)
LCDWFrame.choiceFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
-- end Choices Frame --

-- check buttons --
LCDWFrame.choiceFrame.pveCheckButton = CreateFrame("CheckButton", nil, LCDWFrame.choiceFrame, "ChatConfigCheckButtonTemplate")
LCDWFrame.choiceFrame.pveCheckButton:SetPoint("LEFT", LCDWFrame.choiceFrame, "TOPLEFT", 20, -50)
LCDWFrame.choiceFrame.pveCheckButton:SetText("PVECheckbox")
LCDWFrame.choiceFrame.pveCheckButton.tooltip = "PVE"

LCDWFrame.choiceFrame.pvpCheckButton = CreateFrame("CheckButton", nil, LCDWFrame.choiceFrame, "ChatConfigCheckButtonTemplate")
LCDWFrame.choiceFrame.pvpCheckButton:SetPoint("LEFT", LCDWFrame.choiceFrame, "TOPLEFT", 20, -80)
LCDWFrame.choiceFrame.pvpCheckButton:SetText("PVPCheckbox")
LCDWFrame.choiceFrame.pvpCheckButton.tooltip = "PVP"
-- end check buttons --

-- Reset button --
LCDWFrame.choiceFrame.resetButton = CreateFrame("Button", nil, LCDWFrame.choiceFrame, "UIPanelButtonTemplate")
LCDWFrame.choiceFrame.resetButton:SetSize(150, 30)
LCDWFrame.choiceFrame.resetButton:SetPoint("CENTER", 0, 0)
LCDWFrame.choiceFrame.resetButton:SetText("Reset")
LCDWFrame.choiceFrame.resetButton:SetScript("OnClick", function ()

end)
-- end Reset button --

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
            UIDropDownMenu_EnableDropDown(LCDWFrame.dropDown)
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
LCDWFrame.classDropDown = CreateFrame("Frame", "WPClassDropDown", LCDWFrame.choiceFrame, "UIDropDownMenuTemplate")
LCDWFrame.classDropDown:SetPoint("CENTER", LCDWFrame.choiceFrame, "TOP", 0, -150)
UIDropDownMenu_SetWidth(LCDWFrame.classDropDown, 200)
UIDropDownMenu_Initialize(LCDWFrame.classDropDown, ClassesListDropDown)
UIDropDownMenu_SetText(LCDWFrame.classDropDown, "-- Sélectionner votre classe --")

LCDWFrame.dropDown = CreateFrame("Frame", "WPDungeonsListDropDown", LCDWFrame.choiceFrame, "UIDropDownMenuTemplate")
LCDWFrame.dropDown:SetPoint("CENTER", LCDWFrame.choiceFrame, "TOP", 0, -200)
UIDropDownMenu_SetWidth(LCDWFrame.dropDown, 200)
UIDropDownMenu_Initialize(LCDWFrame.dropDown, DungeonsListDropDown)
UIDropDownMenu_SetText(LCDWFrame.dropDown, "-- Sélectionner un donjon --")
UIDropDownMenu_DisableDropDown(LCDWFrame.dropDown)
-- end DROPDOWNS --

-- slash commands --
SLASH_LECODEXDEWILLIOS1 = '/lcdw'
SlashCmdList["LECODEXDEWILLIOS"] = function()
    LCDWFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --