QFAdjust_Size = QFAdjust_Size or 16

local function ApplyFont(size)
    size = tonumber(size)
    if not size then return end
    
    if size < 10 then size = 10 end
    if size > 28 then size = 28 end 

    QFAdjust_Size = size

    local fonts = {
        QuestFont,
        QuestFontNormalSmall,
        GossipGreetingFontNormal
    }
    
    for _, fontObj in ipairs(fonts) do
        if fontObj then
            local fN, _, fF = fontObj:GetFont()
            if fN then
                fontObj:SetFont(fN, size, fF)
            end
        end
    end

    local titleFonts = {
        QuestTitleFont,
        GossipGreetingTitleFont
    }
    
    for _, fontObj in ipairs(titleFonts) do
        if fontObj then
            local fN, _, fF = fontObj:GetFont()
            if fN then
                fontObj:SetFont(fN, size + 4, fF)
            end
        end
    end

    return size
end

local f = CreateFrame("Frame", "QFAdjustFrame", UIParent)
f:SetWidth(160)
f:SetHeight(85)
f:SetPoint("CENTER", 0, 150)
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function() this:StartMoving() end)
f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
f:Hide()

local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", f, "TOP", 0, -12)
title:SetText("Quest Font")

local eb = CreateFrame("EditBox", "QFAdjustInput", f, "InputBoxTemplate")
eb:SetWidth(35)
eb:SetHeight(20)
eb:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 25, 20)
eb:SetAutoFocus(false)
eb:SetNumeric(true)

local b = CreateFrame("Button", "QFAdjustApply", f, "UIPanelButtonTemplate")
b:SetWidth(60)
b:SetHeight(22)
b:SetPoint("LEFT", eb, "RIGHT", 10, 0)
b:SetText("Apply")

b:SetScript("OnClick", function()
    local val = eb:GetText()
    local final = ApplyFont(val)
    eb:SetText(final)
    eb:ClearFocus()
end)

local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)

local ev = CreateFrame("Frame")
ev:RegisterEvent("VARIABLES_LOADED")
ev:RegisterEvent("GOSSIP_SHOW")
ev:RegisterEvent("QUEST_DETAIL")
ev:RegisterEvent("QUEST_PROGRESS")
ev:RegisterEvent("QUEST_COMPLETE")
ev:RegisterEvent("QUEST_GREETING")

ev:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        eb:SetText(QFAdjust_Size)
        if pfUI and pfUI.api and pfUI.api.CreateBackdrop then
            pfUI.api.CreateBackdrop(f, nil, true)
        else
            f:SetBackdrop({
                bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
                edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
                tile = true, tileSize = 32, edgeSize = 32,
                insets = { left = 11, right = 12, top = 12, bottom = 11 }
            })
        end
    end
    ApplyFont(QFAdjust_Size)
end)

SLASH_QFADJUST1 = "/qfa"
SlashCmdList["QFADJUST"] = function()
    if f:IsVisible() then f:Hide() else f:Show() end
end