-- LibQuickHealth is a library that tries to provide more up to date health data then the default blizz events.
-- To start listening to the event, do QuickHealth.RegisterCallback(YourAddonTableHere, "HealthUpdated", HandlerMethodHere);
-- the callback will provide information ADDITIONAL to the one from blizzard, don't stop listening to UNIT_HEALTH
-- The callback triggers with 4 arguments: self, event, guid, newHealth (first two events passed by the callbackhandler)
-- Additionaly, QuickHealth:UnitHealth(unitID) can be called to get what QuickHealth thinks is the current health.
-- If you are writing a module for an already existing mod, this is probably the function you will want to call instead of
-- using the arguments passed by the lib at the event.
-- Please note that QuickHealth:UnitHealth(unitID) might be innacurate at the frame that UNIT_HEALTH triggered, due to your
-- addon's code running earlyer then QuickHealth's update code.

local MAJOR, MINOR = "LibQuickHealth-1.0", 5
local QuickHealth, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not QuickHealth then return end -- No Upgrade needed.
local healthTable = {};
local maxHealthTable = {};

function QuickHealth:UnitHealth(unitID)
	return healthTable[UnitGUID(unitID)] or UnitHealth(unitID);
end

--local implementation starts here

-- callbackhandler
QuickHealth.events = QuickHealth.events or LibStub("CallbackHandler-1.0"):New(QuickHealth);

-- This table will contain our event handling functions.
QuickHealth.eventHandlers = QuickHealth.eventHandlers or {};
local eventHandlers = QuickHealth.eventHandlers;

-- we need a frame to listen to eventsif there isn't, create a new one
local eventFrame;
if(QuickHealth.eventFrame) then
	eventFrame = QuickHealth.eventFrame;
else
	eventFrame = CreateFrame("Frame");
	QuickHealth.eventFrame = eventFrame;
	eventFrame:SetScript("OnEvent", function(self, event, ...) eventHandlers[event](...) end);
end

-- When an addon starts to listen for HealthUpdated we register our events and actualy start doing something
function QuickHealth.events:OnUsed(target, eventName)
	if(eventName == "HealthUpdated") then
		eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		eventFrame:RegisterEvent("UNIT_HEALTH");
		eventFrame:RegisterEvent("UNIT_MAXHEALTH");
		eventFrame:RegisterEvent("PLAYER_UNGHOST");
	end
end

-- Unregister the events and empty the healthtable
function QuickHealth.events:OnUnused(target, eventName)
	if(eventName == "HealthUpdated") then
		eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		eventFrame:UnregisterEvent("UNIT_HEALTH");
		eventFrame:UnregisterEvent("UNIT_MAXHEALTH");
		eventFrame:UnregisterEvent("PLAYER_UNGHOST");
		for key in pairs(healthTable) do
			healthTable[key] = nil;
		end
		for key in pairs(maxHealthTable) do
			healthTable[key] = nil;
		end
	end
end

function eventHandlers.PLAYER_UNGHOST()
	eventHandlers.UNIT_HEALTH("player");
end

function eventHandlers.UNIT_HEALTH(unitID)
	local GUID = UnitGUID(unitID);
	local maxHealth = UnitHealthMax(unitID);
	if(maxHealth == 100) then
		healthTable[GUID] = nil;
		maxHealthTable[GUID] = nil;
		return;
	end
	
	if not maxHealthTable[GUID] then
		maxHealthTable[GUID] = maxHealth;
	end
	
	local oldHealth = healthTable[GUID];
	local newHealth = UnitHealth(unitID);
	--ChatFrame1:AddMessage(("UNIT_HEALTH: Trigger at %.3f with %d health"):format(GetTime(), newHealth));
	if(newHealth ~= oldHealth) then
		--ChatFrame1:AddMessage(("Discrepancy between stored value and value from UnitHealth on unit %s, saved value: %d, real value: %d"):format(GUID or "", oldHealth or 0, newHealth or 0));
		healthTable[GUID] = newHealth;
	end
end

function eventHandlers.UNIT_MAXHEALTH(unitID)
	local GUID = UnitGUID(unitID);
	local maxHealth = UnitHealthMax(unitID);
	if(maxHealth == 100) then
		healthTable[GUID] = nil;
		maxHealthTable[GUID] = nil;
		return;
	end
	
	maxHealthTable[GUID] = maxHealth;
end

function eventHandlers.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if(not healthTable[destGUID]) then return; end -- Can't do anything if we don't already have a value in our cache.
	local amount;
	-- We only care about damage or healing, check for either of those and react accordingly
	if(event == "SWING_DAMAGE") then --autoattack dmg
		amount = -(...); -- putting in braces will autoselect the first arg, no need to use select(1, ...);
	elseif(event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_DAMAGE"
		or event == "DAMAGE_SPLIT" or event == "DAMAGE_SHIELD") then -- all kinds of spelldamage
		amount = -select(4, ...);
	elseif(event == "ENVIRONMENTAL_DAMAGE") then --environmental damage
		amount = -select(2, ...);
	elseif(event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL") then --healing
		amount = select(4, ...);
	end
	if(amount) then
		newHealth = healthTable[destGUID] + amount
		
		-- If the health is above the maximum (which doesn't make sense) then we put it at the max instead.
		if(maxHealthTable[destGUID] and newHealth > maxHealthTable[destGUID]) then
			newHealth = maxHealthTable[destGUID];
		end
		
		healthTable[destGUID] = newHealth;
		--ChatFrame1:AddMessage(("CombatLog: Trigger at %.3f with %d health"):format(GetTime(), newHealth));
		--ChatFrame1:AddMessage(("Health change on unit %s: %d"):format(destGUID, amount));
		QuickHealth.events:Fire("HealthUpdated", destGUID, newHealth);
	end
end
