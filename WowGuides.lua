local MainFrameWidth = 500
local MainFrameHeight = 500
local dungeonSelected = nil
local dungeons = {
    "The Necrotic Wake",
    "Plaguefall",
    "Mists of Tirna Scithe",
    "Halls of Atonement",
    "De Other Side",
    "Sanguine Depths",
    "Spires of Ascension",
    "Theater of Pain",
}

print("WowGuides loaded! Type /wg to access to the guides.")

-- MainFrame
local WGFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
--WGFrame:Hide()
WGFrame:SetSize(MainFrameWidth, MainFrameHeight)
WGFrame:SetPoint("CENTER", 0, 0)
-- end MainFrame

-- Title's MainFrame
WGFrame.title = WGFrame:CreateFontString(nil, "OVERLAY")
WGFrame.title:SetFontObject("GameFontHighLight")
WGFrame.title:SetPoint("CENTER", WGFrame.TitleBg, "CENTER", 10, 0)
WGFrame.title:SetText("Wow Guides - 0.1")
-- end Title's MainFrame

-- Onlick Dropdown Items
local function DungeonsListDropDown_OnClick(self, arg1, arg2, checked)
    UIDropDownMenu_SetText(WGFrame.dropDown, "Selected : " .. arg2)
    dungeonSelected = arg1
end
-- end

-- Display the dungeons' list
function DungeonsListDropDown(frame, level, menuList)
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

-- Dropdown List
WGFrame.dropDown = CreateFrame("Frame", "WPDemoDropDown", UIParent, "UIDropDownMenuTemplate")
WGFrame.dropDown:SetPoint("RIGHT", WGFrame, "TOP", 10, -50)
UIDropDownMenu_SetWidth(WGFrame.dropDown, 200)
UIDropDownMenu_Initialize(WGFrame.dropDown, DungeonsListDropDown)
UIDropDownMenu_SetText(WGFrame.dropDown, "-- Select a dungeon --")
-- End Dropdown List

-- slash commands
SLASH_WOWGUIDES1 = '/wg'
SlashCmdList["WOWGUIDES"] = function()
    WGFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands