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
local profession = "Engineering";
local BonusRace = 'Gnome';
local SkillCap = 600
local Racial = 15

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

local function OnClick(self, btn)
	if SkillName == "Archaeology" then
		ClickActionLeft = SkillName
		ClickActionRight = "Survey"
	elseif SkillName == "Cooking" then
		ClickActionLeft = SkillName
		ClickActionRight = "Cooking Fire"
	elseif SkillName == "Fishing" then
		ClickActionLeft = SkillName
		ClickActionRight = nil --"Find Fish" (tracking)
	elseif SkillName == "First Aid" then
		ClickActionLeft = "First Aid"
		ClickActionRight = nil
	elseif SkillName == "Herbalism" then
		ClickActionLeft = nil --"Find Herbs" (tracking)
		ClickActionRight = nil --"Herb Gathering" or "Lifeblood"
	elseif SkillName == "Inscription" then
		ClickActionLeft = SkillName
		ClickActionRight = "Milling"
	elseif SkillName == "Jewelcrafting" then
		ClickActionLeft = SkillName
		ClickActionRight = "Prospecting"
	elseif SkillName == "Mining" then
		ClickActionLeft = "Smelting"
		ClickActionRight = nil --"Find Minirals" (tracking)
	elseif SkillName == "Skinning" then
		ClickActionLeft = SkillName
		ClickActionRight = nil --"Master of Anatomy"
	elseif SkillName == "Alchemy" then
		ClickActionLeft = SkillName
		ClickActionRight = nil
	elseif SkillName == "Blacksmithing" then
		ClickActionLeft = SkillName
		ClickActionRight = nil
	elseif SkillName == "Enchanting" then
		ClickActionLeft = SkillName
		ClickActionRight = "Disenchant"
	elseif SkillName == "Engineering" then
		ClickActionLeft = SkillName
		ClickActionRight = nil
	elseif SkillName == "Leatherworking" then
		ClickActionLeft = SkillName
		ClickActionRight = nil
	elseif SkillName == "Tailoring" then
		ClickActionLeft = SkillName
		ClickActionRight = nil
	end
	
	if ClickActionLeft ~= nil then
		local Btn1 = CreateFrame("Button", nil, self, "SecureActionButtonTemplate")
		Btn1:SetFrameStrata("LOW")
		if ClickActionRight ~= nil then
			Btn1:ClearAllPoints()
			Btn1:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			Btn1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
			Btn1:SetWidth(self:GetWidth() / 2)
		else
			Btn1:ClearAllPoints()
			Btn1:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			Btn1:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
			Btn1:SetWidth(self:GetWidth())
		end
		Btn1:EnableMouse(true)
		Btn1:SetAttribute("type", "spell");
		Btn1:SetAttribute("spell", ClickActionLeft);
		self.btn1 = Btn1
		
		if ClickActionRight ~= nil then
			local Btn2 = CreateFrame("Button", nil, self, "SecureActionButtonTemplate")
			Btn2:SetFrameStrata("LOW")
			Btn2:SetPoint("TOPLEFT", Btn1, "TOPRIGHT", 0, 0)
			Btn2:SetPoint("BOTTOMLEFT", Btn1, "BOTTOMRIGHT", 0, 0)
			Btn2:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			Btn2:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			Btn2:EnableMouse(true)
			Btn2:SetAttribute("type", "spell");
			Btn2:SetAttribute("spell", ClickActionRight);
			self.btn2 = Btn2
		end
	end
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
DT:RegisterDatatext('Prof Engineering', {"PLAYER_ENTERING_WORLD", "SKILL_LINES_CHANGED", "BAG_UPDATE"}, OnEvent, nil, OnClick, nil)