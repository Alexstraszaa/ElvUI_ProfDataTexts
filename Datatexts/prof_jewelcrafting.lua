local E, L, V, P, G, _ =  unpack(ElvUI);
local DT = E:GetModule('DataTexts')

local join = string.join
local SkillName, SkillModifier, SkillLevel, SkillMaxLevel
local displayModifierString = ''
local lastPanel;
local FontString = '';
local ClickActionLeft = '';
local ClickActionRight = '';
local race = E.myrace
local myclass = select(2, UnitClass("player"));
local profession = "Jewelcrafting";
local BonusRace = 'Draenei';
local SkillCap = 600
local Racial = 10

local function ClassColors(cls)
	local color;
	if cls == "WARRIOR" then
		color = "|cffC79C6E"
	elseif cls == "PALADIN" then
		color = "|cffF58CBA"
	elseif cls == "HUNTER" then
		color = "|cffABD473"
	elseif cls == "ROGUE" then
		color = "|cffFFF569"
	elseif cls == "PRIEST" then
		color = "|cffFCFCFC"
	elseif cls == "DEATHKNIGHT" then
		color = "|cffC41F3B"
	elseif cls == "SHAMAN" then
		color = "|cff0070DE"
	elseif cls == "MAGE" then
		color = "|cff69CCF0"
	elseif cls == "WARLOCK" then
		color = "|cff9482C9"
	elseif cls == "MONK" then
		color = "|cff00FF96"
	elseif cls == "DRUID" then
		color = "|cffFF7D0A"
	end
	
	return color;
end

ShortProfs = {
	["Archaeology"] = "Arch.",
	["Cooking"] = "Cooking",
	["Fishing"] = "Fishing",
	["First Aid"] = "First Aid",
	["Herbalism"] = "Herbalism.",
	["Inscription"] = "Inscript.",
	["Jewelcrafting"] = "J.crafting",
	["Mining"] = "Mining",
	["Skinning"] = "Skinning",
	["Alchemy"] = "Alchemy",
	["Blacksmithing"] = "Blacksmith",
	["Enchanting"] = "Enchant",
	["Engineering"] = "Engineer",
	["Leatherworking"] = "L.working",
	["Tailoring"] = "Tailoring"
};

local function OnEvent(self, event, ...)
	local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions()
	local profs = {prof1, prof2, archaeology, fishing, cooking, firstAid}
	for k, v in pairs(profs) do
		local name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier = GetProfessionInfo(v)
		if name == profession then
			SkillName = name
			SkillLevel = rank
			SkillMaxLevel = maxRank
			if rankModifier == nil or rankModifier == 0 then
				SkillModifier = 0
			else
				SkillModifier = rankModifier
			end
		end
	end	
	
	if SkillMaxLevel ~= nil then
		if (race == BonusRace and SkillLevel >= (SkillMaxLevel - Racial) - 25 and (SkillMaxLevel + Racial) < (SkillCap + Racial)) or (SkillLevel >= SkillMaxLevel - 25 and SkillMaxLevel < SkillCap) then
			if SkillModifier > 0 then
				self.text:SetFormattedText("|cFFFF0000%s: |cFFFF0000(+%s) %s/%s", ShortProfs[SkillName], SkillModifier, SkillLevel, SkillMaxLevel)
			else
				self.text:SetFormattedText("|cFFFF0000%s: |cFFFF0000%s/%s", ShortProfs[SkillName], SkillLevel, SkillMaxLevel)
			end
		else -- otherwise keep bar default color
			if SkillModifier > 0 then
				self.text:SetFormattedText("|cFFFFFFFF%s: "..ClassColors(myclass).."(+%s) %s/%s", ShortProfs[SkillName], SkillModifier, SkillLevel, SkillMaxLevel)
			else
				self.text:SetFormattedText("|cFFFFFFFF%s: "..ClassColors(myclass).."%s/%s", ShortProfs[SkillName], SkillLevel, SkillMaxLevel)
			end
		end
	else
		self.text:SetFormattedText("|cffFFFFFF%s not learned", profession);
	end
	lastPanel = self
end

local function GetClickActions(p, side)
	if p == "Archaeology" then
		ClickActionLeft = p
		ClickActionRight = "Survey"
	elseif p == "Cooking" then
		ClickActionLeft = p
		ClickActionRight = "Cooking Fire"
	elseif p == "Fishing" then
		ClickActionLeft = p
		ClickActionRight = nil --"Find Fish" (tracking)
	elseif p == "First Aid" then
		ClickActionLeft = "First Aid"
		ClickActionRight = nil
	elseif p == "Herbalism" then
		ClickActionLeft = nil --"Find Herbs" (tracking)
		ClickActionRight = nil --"Herb Gathering" or "Lifeblood"
	elseif p == "Inscription" then
		ClickActionLeft = p
		ClickActionRight = "Milling"
	elseif p == "Jewelcrafting" then
		ClickActionLeft = p
		ClickActionRight = "Prospecting"
	elseif p == "Mining" then
		ClickActionLeft = "Smelting"
		ClickActionRight = nil --"Find Minirals" (tracking)
	elseif p == "Skinning" then
		ClickActionLeft = p
		ClickActionRight = nil --"Master of Anatomy"
	elseif p == "Alchemy" then
		ClickActionLeft = p
		ClickActionRight = nil
	elseif p == "Blacksmithing" then
		ClickActionLeft = p
		ClickActionRight = nil
	elseif p == "Enchanting" then
		ClickActionLeft = p
		ClickActionRight = "Disenchant"
	elseif p == "Engineering" then
		ClickActionLeft = p
		ClickActionRight = nil
	elseif p == "Leatherworking" then
		ClickActionLeft = p
		ClickActionRight = nil
	elseif p == "Tailoring" then
		ClickActionLeft = p
		ClickActionRight = nil
	end
	
	if side == "LEFT" then
		return ClickActionLeft
	elseif side == "RIGHT" then
		return ClickActionRight
	end
end

local function OnClick(self, btn)
	if ClickActionLeft ~= nil then
		--DT.tooltip:Hide();
		local Btn1 = CreateFrame("Button", nil, self, "SecureActionButtonTemplate")
		Btn1:SetFrameStrata("LOW")
		Btn1:ClearAllPoints()
		Btn1:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		Btn1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
		Btn1:SetWidth(self:GetWidth() / 4)
		Btn1:EnableMouse(true)
		Btn1:SetAttribute("type", "spell");
		Btn1:SetAttribute("spell", GetClickActions(profession, "LEFT"));
		self.btn1 = Btn1
		
		if ClickActionRight ~= nil then
			local Btn2 = CreateFrame("Button", nil, self, "SecureActionButtonTemplate")
			Btn2:SetFrameStrata("LOW")
			Btn2:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			Btn2:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			Btn2:SetWidth(self:GetWidth() / 4)
			Btn2:EnableMouse(true)
			Btn2:SetAttribute("type", "spell");
			Btn2:SetAttribute("spell", GetClickActions(profession, "RIGHT"));
			self.btn2 = Btn2
		end
	end
end

local function OnEnter(self)
	if SkillMaxLevel == nil or ClickActionLeft == nil then return end
	DT:SetupTooltip(self)
	
	DT.tooltip:AddLine(L['|cffFFFFFFClick left side of DT:|r Toggle Profession window'])
	DT.tooltip:AddLine(L['|cffFFFFFFClick right side of DT:|r '..GetClickActions(profession, "RIGHT")])

	DT.tooltip:Show()
end

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc, onLeaveFunc)
	
	name - name of the datatext (required)
	events - must be a table with string values of event names to register 
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
	onLeaveFunc - function to fire OnLeave, if not provided one will be set for you that hides the tooltip.
]]
DT:RegisterDatatext('Prof Jewelcrafting', {"PLAYER_ENTERING_WORLD", "SKILL_LINES_CHANGED", "BAG_UPDATE"}, OnEvent, nil, OnClick, OnEnter)