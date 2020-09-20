local MainFrameWidth = 500
local MainFrameHeight = 500

print("WowGuides loaded! Type /wg to access to the guides")

-- MainFrame
local WGFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
WGFrame:Hide()
WGFrame:SetSize(MainFrameWidth, MainFrameHeight)
WGFrame:SetPoint("CENTER", 0, 0)

-- end MainFrame

WGFrame.title = WGFrame:CreateFontString(nil, "OVERLAY")
WGFrame.title:SetFontObject("GameFontHighLight")
WGFrame.title:SetPoint("LEFT", WGFrame.TitleBg, "LEFT", 10, 0)
WGFrame.title:SetText("Wow Guides - 0.1")

-- slash commands
SLASH_WOWGUIDES1 = '/wg'
SlashCmdList["WOWGUIDES"] = function()
    WGFrame:Show()
end

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI
-- end slash commands