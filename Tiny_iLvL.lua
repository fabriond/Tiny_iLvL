local f = CreateFrame("Frame")

f:RegisterEvent("ADDON_LOADED")

local function CalculateItemLevelFromEquippedItems(unit)
    if not unit or not UnitExists(unit) then return 0 end

    local total = 0
    for slot = 1, 17 do -- 1-17 are the equipped slots
        -- For the iLvL in the Blizzard character frame, it does still add the ilvl of the shirt slot (4) for some reason,
        -- which was causing some slight discrepancies that looked like rounding errors when I was skipping the slot 

        local itemLink = GetInventoryItemLink(unit, slot)

        if slot == 17 and not itemLink then
            local mainHandLink = GetInventoryItemLink(unit, 16)
            if mainHandLink then
                local _, _, _, _, _, _, _, _, mainHandEquipLoc = GetItemInfo(mainHandLink)
                if mainHandEquipLoc == "INVTYPE_2HWEAPON" or mainHandEquipLoc == "INVTYPE_RANGEDRIGHT" then
                    -- This corrects for the missing off-hand in the case of two-handed weapons
                    itemLink = mainHandLink
                end
            end
        end

        if itemLink then
            local _, _, _, itemLevel = GetItemInfo(itemLink)
            if itemLevel then
                total = total + itemLevel
            end
        end
    end

    return total / 16 -- 16 is the effective number of equippable slots (1-17 except for 4, which is the shirt slot)
end

local function SetTinyItemLevelText()
    if not InspectPaperDollFrame or not InspectPaperDollFrame:IsShown() then return end

    local ilvl = CalculateItemLevelFromEquippedItems(InspectFrame.unit)

    if ilvl then
        InspectPaperDollFrame.tinyItemLevel:SetText(string.format("iLvl: %d", ilvl))
    else
        InspectPaperDollFrame.tinyItemLevel:SetText("iLvl: ...")
    end
end

f:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Blizzard_InspectUI" then
        InspectPaperDollFrame.tinyItemLevel = InspectPaperDollFrame:CreateFontString("Tiny Item Level", "OVERLAY", "GameFontNormal")
        InspectPaperDollFrame.tinyItemLevel:SetPoint("BOTTOMLEFT", InspectPaperDollFrame, "BOTTOMLEFT", 10, 10)

        InspectPaperDollFrame:HookScript("OnUpdate", SetTinyItemLevelText)
    end
end)
