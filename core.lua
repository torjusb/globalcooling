local addon = CreateFrame("Frame", nil, UIParent)

addon:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
addon:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
addon:RegisterEvent("PLAYER_LOGIN")


addon:SetHeight(5)
addon:SetWidth(250)
addon:SetBackdrop{ bgFile = "Interface\\ChatFrame\\ChatFrameBackground" }
addon:SetBackdropColor(0, 0, 0, .5)
addon:SetPoint("CENTER", 0, -250)
addon:Hide()


local spark = addon:CreateTexture(nil, "DIALOG")
spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
spark:SetVertexColor(1,1,1)
spark:SetBlendMode("ADD")
spark:SetWidth(25)
spark:SetHeight(10)
spark:SetPoint("CENTER", addon, "LEFT", 0, 0)

local starttime, duration, casting

local function OnUpdate()
	spark:ClearAllPoints()
	local pos = (GetTime() - starttime) / duration
	if pos > 1 then
		return addon:Hide()
	else
		spark:SetPoint("CENTER", addon, "LEFT", 250 * pos, 0)
	end
end

--making a difference

local function OnHide()
	addon:SetScript("OnUpdate", nil)
	casting = nil
end

local function OnShow()
	addon:SetScript("OnUpdate", OnUpdate)
end

function addon:PLAYER_LOGIN()
	addon:SetScript("OnHide", OnHide)
	addon:SetScript("OnShow", OnShow)
	addon:UnregisterEvent("PLAYER_LOGIN")
end

function addon:ACTIONBAR_UPDATE_COOLDOWN() 
	local start, dur = GetSpellCooldown("Renew")
	if dur > 0 and dur <= 2 then
		casting = 2
		duration = dur
		starttime = start
		addon:Show()
		return
	elseif casting == 2 and dur == 0 then
		addon:Hide()
	end        
end 
