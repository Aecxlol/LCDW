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
local WGFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
WGFrame:Hide()
WGFrame:SetSize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
WGFrame:SetPoint("CENTER", 0, 0)
WGFrame:SetMovable(true)
WGFrame:SetResizable(true)
WGFrame:EnableMouse(true)
WGFrame:SetMinResize(MAIN_FRAME_WITH, MAIN_FRAME_HEIGHT)
WGFrame:RegisterForDrag("LeftButton")
WGFrame:SetScript("OnDragStart", WGFrame.StartMoving)
WGFrame:SetScript("OnDragStop", WGFrame.StopMovingOrSizing)
-- end MainFrame --

-- Title's MainFrame
WGFrame.title = WGFrame:CreateFontString(nil, "OVERLAY")
WGFrame.title:SetFontObject("GameFontHighLight")
WGFrame.title:SetPoint("CENTER", WGFrame.TitleBg, "CENTER", 0, 0)
WGFrame.title:SetText(customAddonName .. " - " .. addonVersion)
-- end title's mainFrame

-- Resize frame --
WGFrame.rb = CreateFrame("Button", nil, WGFrame)
WGFrame.rb:SetPoint("BOTTOMRIGHT", -5, 5)
WGFrame.rb:SetSize(16, 16)
WGFrame.rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
WGFrame.rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
WGFrame.rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

WGFrame.rb:SetScript("OnMouseDown", function()
    WGFrame:StartSizing("BOTTOMRIGHT")
end)
WGFrame.rb:SetScript("OnMouseUp", function()
    WGFrame:StopMovingOrSizing()
end)
-- end resize frame --

-- openChoiceFrameButton arrow --
WGFrame.openChoiceFrameButton = CreateFrame("Button", nil, WGFrame)
WGFrame.openChoiceFrameButton:SetSize(45, 45)
WGFrame.openChoiceFrameButton:SetPoint("CENTER", WGFrame, "TOPRIGHT", -30, -50)
WGFrame.openChoiceFrameButton:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
WGFrame.openChoiceFrameButton.Hover = WGFrame.openChoiceFrameButton:CreateTexture(nil, "BACKGROUND")
WGFrame.openChoiceFrameButton.Hover:SetTexture("Interface\\Buttons\\CheckButtonGlow")
WGFrame.openChoiceFrameButton.Hover:SetAllPoints(WGFrame.openChoiceFrameButton)
WGFrame.openChoiceFrameButton.Hover:SetAlpha(0)

WGFrame.openChoiceFrameButton:SetScript("OnEnter", function()
    WGFrame.openChoiceFrameButton.Hover:SetAlpha(1)
end);
--
WGFrame.openChoiceFrameButton:SetScript("OnLeave", function()
    WGFrame.openChoiceFrameButton.Hover:SetAlpha(0)
end);

WGFrame.openChoiceFrameButton:SetScript("OnClick", function()
    if WGFrame.choiceFrame:IsShown() then
        WGFrame.choiceFrame:Hide()
        WGFrame.openChoiceFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    else
        WGFrame.choiceFrame:Show()
        WGFrame.openChoiceFrameButton:SetBackdrop({
            bgFile = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
    end
end);
-- end openChoiceFrameButton arrow --

-- Choices Frame --
WGFrame.choiceFrame = CreateFrame("Frame", nil, WGFrame)
WGFrame.choiceFrame:SetSize(CHOICE_FRAME_WIDTH, WGFrame:GetHeight())
WGFrame.choiceFrame:SetPoint("LEFT", WGFrame, "RIGHT", -5, 0)
WGFrame.choiceFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
-- end Choices Frame --

-- Reset button --
WGFrame.choiceFrame.resetButton = CreateFrame("Button", nil, WGFrame.choiceFrame, "UIPanelButtonTemplate")
WGFrame.choiceFrame.resetButton:SetSize(150,30)
WGFrame.choiceFrame.resetButton:SetPoint("CENTER",0,0)
WGFrame.choiceFrame.resetButton:SetText("Reset")
WGFrame.choiceFrame.resetButton:SetScript("OnClick", function ()

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
            if WGFrame:IsShown() then
                WGFrame:Hide()
            else
                WGFrame:Show()
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
    textures["texture" .. dungeonId] = WGFrame:CreateTexture(nil, "ARTWORK")
    textures["texture" .. dungeonId]:SetPoint("CENTER", WGFrame, "CENTER", 0, 0)
    textures["texture" .. dungeonId]:SetSize(450, 450)
    textures["texture" .. dungeonId]:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
    return textures["texture" .. dungeonId]
end

-- @todo pve and pvp categories

-- Onlick Dungeons dropdown items --
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.dropDown, "Donjon : " .. arg2)
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
    UIDropDownMenu_SetText(WGFrame.classDropDown, "Classe : " .. arg2)
    classSelected = arg1

    for classId, dungeon in ipairs(classes) do
        if arg1 == classId then
            -- display the dropdown WGFrame.dropDown which is greyed out
            UIDropDownMenu_EnableDropDown(WGFrame.dropDown)
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

WGFrame.classDropDown = CreateFrame("Frame", "WPClassDropDown", WGFrame.choiceFrame, "UIDropDownMenuTemplate")
WGFrame.classDropDown:SetPoint("CENTER", WGFrame.choiceFrame, "TOP", 0, -50)
UIDropDownMenu_SetWidth(WGFrame.classDropDown, 200)
UIDropDownMenu_Initialize(WGFrame.classDropDown, ClassesListDropDown)
UIDropDownMenu_SetText(WGFrame.classDropDown, "-- Sélectionner votre classe --")

WGFrame.dropDown = CreateFrame("Frame", "WPDungeonsListDropDown", WGFrame.choiceFrame, "UIDropDownMenuTemplate")
WGFrame.dropDown:SetPoint("CENTER", WGFrame.choiceFrame, "TOP", 0, -100)
UIDropDownMenu_SetWidth(WGFrame.dropDown, 200)
UIDropDownMenu_Initialize(WGFrame.dropDown, DungeonsListDropDown)
UIDropDownMenu_SetText(WGFrame.dropDown, "-- Sélectionner un donjon --")
UIDropDownMenu_DisableDropDown(WGFrame.dropDown)

-- slash commands --
SLASH_LECODEXDEWILLIOS1 = '/lcdw'
SlashCmdList["LECODEXDEWILLIOS"] = function()
    WGFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --