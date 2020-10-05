local MainFrameWidth = 500
local MainFrameHeight = 500
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

print("WowGuides loaded! Type /wg to access to the guides.")

-- MainFrame
local WGFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
WGFrame:Hide()
WGFrame:SetSize(MainFrameWidth, MainFrameHeight)
WGFrame:SetPoint("CENTER", 0, 0)
WGFrame:SetMovable(true)
WGFrame:EnableMouse(true)
WGFrame:RegisterForDrag("LeftButton")
WGFrame:SetScript("OnDragStart", WGFrame.StartMoving)
WGFrame:SetScript("OnDragStop", WGFrame.StopMovingOrSizing)
-- end MainFrame

-- Title's MainFrame
WGFrame.title = WGFrame:CreateFontString(nil, "OVERLAY")
WGFrame.title:SetFontObject("GameFontHighLight")
WGFrame.title:SetPoint("CENTER", WGFrame.TitleBg, "CENTER", 0, 0)
WGFrame.title:SetText("Wow Guides - 0.1")
-- end Title's MainFrame

-- load the guide according to the id
local function loadGuide(id)
    -- TODO
    print(id)
end
-- end

-- Onlick Dropdown Items
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.dropDown, "Donjon : " .. arg2)
    dungeonSelected = arg1

    for dungeonId, dungeon in ipairs(dungeons) do
        if arg1 == dungeonId then
            loadGuide(dungeonId)
        end
    end
end
-- end

-- Display the dungeons' list
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
-- end

-- Dropdown List Frame
WGFrame.dropDown = CreateFrame("Frame", "WPDemoDropDown", WGFrame, "UIDropDownMenuTemplate")
WGFrame.dropDown:SetPoint("RIGHT", WGFrame, "TOP", 10, -50)
UIDropDownMenu_SetWidth(WGFrame.dropDown, 200)
UIDropDownMenu_Initialize(WGFrame.dropDown, DungeonsListDropDown)
UIDropDownMenu_SetText(WGFrame.dropDown, "-- Sélectionner un donjon --")
-- End Dropdown List Frame

-- slash commands
SLASH_WOWGUIDES1 = '/wg'
SlashCmdList["WOWGUIDES"] = function()
    WGFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands