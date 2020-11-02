local name, _ = ...
local wowGuidesVersion = "0.1 Alpha"

local MainFrameWidth = 500
local MainFrameHeight = 500
local FOLDER_GUIDES_PATH = "Interface\\AddOns\\WowGuides\\guides\\pve\\"
local CURRENT_BUILD, _, _, _ = GetBuildInfo()

local GREEN =  "|cff00ff00"
local YELLOW = "|cffffff00"
local RED =    "|cffff0000"
local BLUE =   "|cff0198e1"
local ORANGE = "|cffff9933"
local WHITE =  "|cffffffff"


local test1 = nil
local test2 = nil
local test3 = nil
local test4 = nil
local test5 = nil
local test6 = nil
local test7 = nil
local test8 = nil

local isTest1Shown = false
local isTest2Shown = false
local isTest3Shown = false
local isTest4Shown = false
local isTest5Shown = false
local isTest6Shown = false
local isTest7Shown = false
local isTest8Shown = false

local mb = nil

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

local wowGuides = LibStub("AceAddon-3.0"):NewAddon("WowGuides", "AceConsole-3.0")
local icon = LibStub("LibDBIcon-1.0")


--function wowGuides:CommandTheBunnies()
--    self.db.profile.minimap.hide = not self.db.profile.minimap.hide
--    if self.db.profile.minimap.hide then
--        icon:Hide("Bunnies!")
--    else
--        icon:Show("Bunnies!")
--    end
--end

local function onEvent(self, event, arg1, ...)
    if(event == "ADDON_LOADED" and name == arg1) then
        print("|cff00cc66".. name .."|r loaded! Type /wg to access to the guides.")
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", onEvent)

-- MainFrame --
local WGFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
WGFrame:Hide()
WGFrame:SetSize(MainFrameWidth, MainFrameHeight)
WGFrame:SetPoint("CENTER", 0, 0)
WGFrame:SetMovable(true)
WGFrame:EnableMouse(true)
WGFrame:RegisterForDrag("LeftButton")
WGFrame:SetScript("OnDragStart", WGFrame.StartMoving)
WGFrame:SetScript("OnDragStop", WGFrame.StopMovingOrSizing)
-- end MainFrame --

-- Title's MainFrame
WGFrame.title = WGFrame:CreateFontString(nil, "OVERLAY")
WGFrame.title:SetFontObject("GameFontHighLight")
WGFrame.title:SetPoint("CENTER", WGFrame.TitleBg, "CENTER", 0, 0)
WGFrame.title:SetText("Wow Guides - 0.1")
-- end title's mainFrame

-- LIBSTUB --
local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Bunnies!", {
    type = "data source",
    icon = "Interface\\AddOns\\WowGuides\\misc\\minimap-icon",
    OnClick = function(clickedframe, button)
        if button == "RightButton" then

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
            tooltip:AddLine(BLUE .. name .. " " .. wowGuidesVersion)
            tooltip:AddLine(YELLOW .. "Click gauche" .. " " .. WHITE
                    .. "pour ouvrir/fermer la fenêtre de guides")
            tooltip:AddLine(YELLOW .. "Click droit" .. " " .. WHITE
                    .. "pour ouvrir/fermer la configuration")
        end
    end
})

function wowGuides:OnInitialize()
    -- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh!
    self.db = LibStub("AceDB-3.0"):New("BunniesDB", {
        profile = {
            minimap = {
                hide = false,
            },
        },
    })
    icon:Register("Bunnies!", bunnyLDB, self.db.profile.minimap)
    --self:RegisterChatCommand("bunnies", "CommandTheBunnies")
end
-- END LIBSTUB --

-- @todo pve and pvp categories

-- Onlick Dungeons dropdown items --
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.dropDown, "Donjon : " .. arg2)
    dungeonSelected = arg1

    for dungeonId, dungeon in ipairs(dungeons) do
        if arg1 == dungeonId then

            -- @todo REFACTORISER CI DESSOUS --

            if dungeonId == 1 then
                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest1Shown == false then
                    test1 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test1:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test1:SetSize(450, 450)
                    test1:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest1Shown = true
                end
            end

            if dungeonId == 2 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest2Shown == false then
                    test2 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test2:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test2:SetSize(450, 450)
                    test2:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest2Shown = true
                end
                table.insert(mb, "lol")
            end

            if dungeonId == 3 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest3Shown == false then
                    test3 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test3:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test3:SetSize(450, 450)
                    test3:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest3Shown = true
                end
            end

            if dungeonId == 4 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest4Shown == false then
                    test4 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test4:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test4:SetSize(450, 450)
                    test4:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest4Shown = true
                end
            end

            if dungeonId == 5 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest5Shown == false then
                    test5 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test5:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test5:SetSize(450, 450)
                    test5:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest5Shown = true
                end
            end

            if dungeonId == 6 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest6Shown == false then
                    test6 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test6:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test6:SetSize(450, 450)
                    test6:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest6Shown = true
                end
            end

            if dungeonId == 7 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest8Shown == true then
                    test8:Hide()
                    isTest8Shown = false
                end

                if isTest7Shown == false then
                    test7 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test7:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test7:SetSize(450, 450)
                    test7:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest7Shown = true
                end
            end

            if dungeonId == 8 then
                if isTest1Shown == true then
                    test1:Hide()
                    isTest1Shown = false
                end

                if isTest2Shown == true then
                    test2:Hide()
                    isTest2Shown = false
                end

                if isTest3Shown == true then
                    test3:Hide()
                    isTest3Shown = false
                end

                if isTest4Shown == true then
                    test4:Hide()
                    isTest4Shown = false
                end

                if isTest5Shown == true then
                    test5:Hide()
                    isTest5Shown = false
                end

                if isTest6Shown == true then
                    test6:Hide()
                    isTest6Shown = false
                end

                if isTest7Shown == true then
                    test7:Hide()
                    isTest7Shown = false
                end


                if isTest8Shown == false then
                    test8 =  WGFrame:CreateTexture(nil, "ARTWORK")
                    test8:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
                    test8:SetSize(450, 450)
                    test8:SetTexture(FOLDER_GUIDES_PATH .. dungeonId)
                    isTest8Shown = true
                end
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

WGFrame.classDropDown = CreateFrame("Frame", "WPClassDropDown", WGFrame, "UIDropDownMenuTemplate")
WGFrame.classDropDown:SetPoint("RIGHT", WGFrame, "TOP", 10, -50)
UIDropDownMenu_SetWidth(WGFrame.classDropDown, 180)
UIDropDownMenu_Initialize(WGFrame.classDropDown, ClassesListDropDown)
UIDropDownMenu_SetText(WGFrame.classDropDown, "-- Sélectionner votre classe --")

WGFrame.dropDown = CreateFrame("Frame", "WPDungeonsListDropDown", WGFrame, "UIDropDownMenuTemplate")
WGFrame.dropDown:SetPoint("RIGHT", WGFrame, "TOP", 230, -50)
UIDropDownMenu_SetWidth(WGFrame.dropDown, 200)
UIDropDownMenu_Initialize(WGFrame.dropDown, DungeonsListDropDown)
UIDropDownMenu_SetText(WGFrame.dropDown, "-- Sélectionner un donjon --")
UIDropDownMenu_DisableDropDown(WGFrame.dropDown)

-- slash commands --
SLASH_WOWGUIDES1 = '/wg'
SlashCmdList["WOWGUIDES"] = function()
    WGFrame:Show()
end

SLASH_TEST1 = "/test"
SlashCmdList["TEST"] = function()

end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --