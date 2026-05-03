local f = CreateFrame("Frame")

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("INSPECT_READY")

local function SetTinyItemLevelText()
    if not InspectPaperDollFrame or not InspectPaperDollFrame:IsShown() then return end

    local ilvl = C_PaperDollInfo and C_PaperDollInfo.GetInspectItemLevel and C_PaperDollInfo.GetInspectItemLevel(InspectFrame.unit)

    if ilvl and ilvl > 0 then
        InspectPaperDollFrame.tinyItemLevel:SetText(string.format("iLvl: %d", ilvl))
    else
        InspectPaperDollFrame.tinyItemLevel:SetText("iLvl: ...")
    end
end

f:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Blizzard_InspectUI" then
        InspectPaperDollFrame.tinyItemLevel = InspectPaperDollFrame:CreateFontString("Tiny Item Level", "OVERLAY", "GameFontNormal")
        InspectPaperDollFrame.tinyItemLevel:SetPoint("BOTTOMLEFT", InspectPaperDollFrame, "BOTTOMLEFT", 10, 10)

        InspectPaperDollFrame:HookScript("OnShow", SetTinyItemLevelText)
    end
end)