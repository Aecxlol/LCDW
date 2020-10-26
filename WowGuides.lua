local name, _ = ...

local MainFrameWidth = 500
local MainFrameHeight = 500
local folderGuidesPath = "Interface\\AddOns\\WowGuides\\guides\\pve\\"
local guideIds = {}
local penultimateGuideIdLoaded = nil
local penultimateBlpTextureNameLoaded = nil

local blpTextureName1 = "blpTextureName1:Hide"
local blpTextureName2 = "blpTextureName2"
local blpTextureName3 = "blpTextureName3"
local blpTextureName4 = "blpTextureName4"
local blpTextureName5 = "blpTextureName5"
local blpTextureName6 = "blpTextureName6"
local blpTextureName7 = "blpTextureName7"
local blpTextureName8 = "blpTextureName8"

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

local function removePreviousGuide(previousGuide)
    previousGuide:Hide()
end

-- load the guide according to the id --
--local function loadGuide(blpTextureName, guideName, previousGuide)
--    blpTextureName = WGFrame:CreateTexture(nil, "ARTWORK")
--    blpTextureName:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
--    blpTextureName:SetSize(450, 450)
--    blpTextureName:SetTexture(folderGuidesPath .. guideName)
--    removePreviousGuide(previousGuide)
--    WGFrame.blpTextureName = blpTextureName
--end
-- end loading --

-- Onlick Dungeons dropdown items --
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.dropDown, "Donjon : " .. arg2)
    dungeonSelected = arg1

    for dungeonId, dungeon in ipairs(dungeons) do
        if arg1 == dungeonId then
            -- save every dungeon's id checked into an array
            table.insert(guideIds, dungeonId)

            -- once atleast one guide got checked
            if #guideIds > 1 then
                -- get the id of the previous one
                penultimateGuideIdLoaded = guideIds[#guideIds - 1]
                -- get his name
                penultimateBlpTextureNameLoaded = "blpTextureName" .. penultimateGuideIdLoaded .. ":Hide"
                print(penultimateBlpTextureNameLoaded)
                -- and then hide the previous guide checked
                --penultimateBlpTextureNameLoaded:Hide()
            end

            local textureName = "blpTextureName" .. dungeonId

            textureName = WGFrame:CreateTexture(nil, "ARTWORK")
            textureName:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
            textureName:SetSize(450, 450)
            textureName:SetTexture(folderGuidesPath .. dungeonId)
            WGFrame.textureName = textureName
            _G[penultimateBlpTextureNameLoaded]()
            --loadGuide(textureName, dungeonId, penultimateBlpTextureNameLoaded)
            --removePreviousGuide(penultimateBlpTextureNameLoaded)
        end
    end
end
-- end onclick event --

local aze = WGFrame:CreateTexture(nil, "ARTWORK")
aze:SetPoint("CENTER", WGFrame, "CENTER", 10, 0)
aze:SetSize(450, 450)
aze:SetTexture(folderGuidesPath .. 1)

print("mdrAZE" .. type(aze))


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
    WGFrame:Show()
end

SLASH_TEST1 = "/test"
SlashCmdList["TEST"] = function()
    _G[blpTextureName1]()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands --