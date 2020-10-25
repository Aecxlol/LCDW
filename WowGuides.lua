local name, _ = ...

local MainFrameWidth = 500
local MainFrameHeight = 500
local isTheFrameOpen = false
local folderGuidesPath = "Interface\\AddOns\\WowGuides\\guides\\pve\\"

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

-- @todo pve and pvp categories
-- @todo issue caused when closing the window via the cross (isTheFrameOpen var)

-- load the guide according to the id --
local function loadGuide(id)
    -- @todo create a 2 dimensions array for the dungeons list
    -- Texture object --
    local texture = WGFrame:CreateTexture(nil, "ARTWORK")
    texture:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
    texture:SetSize(64, 64)
    texture:SetTexture(folderGuidesPath .. id)
    WGFrame.texture = texture
    -- end --
end
-- end loading --

-- Onlick Dropdown Items --
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.dropDown, "Donjon : " .. arg2)
    dungeonSelected = arg1

    for dungeonId, dungeon in ipairs(dungeons) do
        if arg1 == dungeonId then
            loadGuide(dungeonId)
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

-- Onlick Dropdown Items --
local function ClassesListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.classDropDown, "Classe : " .. arg2)
    classSelected = arg1

    for classId, dungeon in ipairs(classes) do
        if arg1 == classId then
            UIDropDownMenu_EnableDropDown(WGFrame.dropDown)
        end
    end
end
-- end onclick event --

-- display the dungeons' list --
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

-- Dropdown function --
--local function createDropDownFrame(dropDownName, frameName, ofX, ofY, size, initFunc, defaultTextContent, isEnable)
--    dropDownName = CreateFrame("Frame", frameName, WGFrame, "UIDropDownMenuTemplate")
--    dropDownName:SetPoint("RIGHT", WGFrame, "TOP", ofX, ofY)
--    UIDropDownMenu_SetWidth(dropDownName, size)
--    UIDropDownMenu_Initialize(dropDownName, initFunc)
--    UIDropDownMenu_SetText(dropDownName, defaultTextContent)
--    if isEnable == false then
--        UIDropDownMenu_DisableDropDown(dropDownName)
--    end
--end
-- end Dropdown function --

--createDropDownFrame(WGFrame.classDropDown, "WPClassDropDown", 10, -50, 180, ClassesListDropDown, "-- Sélectionner votre classe --", true)
--createDropDownFrame(WGFrame.dropDown, "WPDungeonsListDropDown", 230, -50, 200, DungeonsListDropDown, "-- Sélectionner un donjon --", true)

-- slash commands --
SLASH_WOWGUIDES1 = '/wg'
SlashCmdList["WOWGUIDES"] = function()
    if isTheFrameOpen == false then
        WGFrame:Show()
        isTheFrameOpen = true
    else
        WGFrame:Hide()
        isTheFrameOpen = false
    end
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --