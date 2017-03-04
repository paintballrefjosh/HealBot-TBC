

function HealBot_Comms_SendAddonMsg(addon_id, msg, aType, pName)
  if aType==1 then
    SendAddonMessage(addon_id, msg, "BATTLEGROUND" );
  elseif aType==2 then
    SendAddonMessage(addon_id, msg, "RAID" );
  elseif aType==3 then
    SendAddonMessage(addon_id, msg, "PARTY" );
  elseif aType==4 and pName then
    SendAddonMessage(addon_id, msg, "WHISPER", pName );
  end
end

function HealBot_Comms_GetChan(chan)
	if GetChannelName(chan)>0 then
		return GetChannelName(chan);
	else
		return nil;
	end
end

local HealBotAddonMsgType=nil
local tmpttl=0
local HealBotcAddonIncHeals={}
local HealBotcAddonSummary={}
local HealBotAddonSummaryNoComms={}
local sortorder={}
local AddonName=nil
local AddonEnabled=nil
local linenum=0
function HealBot_Comms_DebugStatus()
  HealBot_Comms_Info()
end

local hbcommver={}
local hbtmpver={}
local linenum=0
local addon_id=nil
local sender_id=nil
function HealBot_Comms_Info()
  if HealBot_Error:IsVisible() then
    HideUIPanel(HealBot_Error)
	return
  end
  UpdateAddOnCPUUsage()
  UpdateAddOnMemoryUsage()
  HealBotAddonMsgType=HealBot_GetHealBot_AddonMsgType()
  HealBotcAddonSummary=HealBot_RetHealBotAddonSummary()
  HealBotcAddonIncHeals=HealBot_RetHealBotAddonIncHeals()
  hbcommver=HealBot_GetInfo()
  HealBot_Report_Error("Zone="..GetRealZoneText())
  if HealBotAddonMsgType==1 then
    HealBot_Report_Error("AddonComms=BATTLEGROUND")
  elseif HealBotAddonMsgType==2 then
    HealBot_Report_Error("AddonComms=RAID")
  elseif HealBotAddonMsgType==3 then
    HealBot_Report_Error("AddonComms=PARTY")
  elseif HealBotAddonMsgType==4 then
    HealBot_Report_Error("AddonComms=WHISPER")
  end
  HealBot_Report_Error("#Raid="..GetNumRaidMembers().."   #Party="..GetNumPartyMembers())


  for x,_ in pairs(hbtmpver) do
    hbtmpver[x]=nil
  end
  sortorder={}
  for z,x in pairs(HealBotcAddonIncHeals) do
    table.insert(sortorder,z)
  end
  table.sort(sortorder,function (a,b)
    if HealBotcAddonIncHeals[a]>HealBotcAddonIncHeals[b] then return true end
    if HealBotcAddonIncHeals[a]<HealBotcAddonIncHeals[b] then return false end
    return a<b
  end)

  linenum=1
  table.foreach(sortorder, function (index,z)
    tmpttl=HealBotcAddonIncHeals[z] or 0
	_,_,addon_id, sender_id = string.find(z, "(.+) : (.+)")
	if linenum<25 and addon_id and sender_id then
	  if addon_id==HEALBOT_ADDON_ID and hbcommver[sender_id] then 
	    addon_id=string.sub(hbcommver[sender_id],9,-1) or "HealBot" 
		hbtmpver[sender_id]=true
	  end
	  HealBot_Comms_Print_IncHealsSum(sender_id,addon_id,tmpttl,linenum)
	  linenum=linenum+1
	end
  end)

  for x,v in pairs(hbcommver) do
    if not hbtmpver[x] and linenum<21 then
	  HealBot_Comms_Print_IncHealsSum(x,string.sub(v,9,-1),0,linenum)
	  linenum=linenum+1
	end
  end


  linenum=1
  for x,_ in pairs(HealBotAddonSummaryNoComms) do
    HealBotAddonSummaryNoComms[x]=nil;
  end
  sortorder={}
  for z,x in pairs(HealBotcAddonSummary) do
    table.insert(sortorder,z)
  end
  table.sort(sortorder,function (a,b)
    if HealBotcAddonSummary[a]>HealBotcAddonSummary[b] then return true end
    if HealBotcAddonSummary[a]<HealBotcAddonSummary[b] then return false end
    return a<b
  end)
  sortorder={}
  for z,x in pairs(HealBotcAddonSummary) do
    if x>100 then
      HealBotAddonSummaryNoComms[z]=HealBot_Comm_round(GetAddOnCPUUsage(z)/1000, 1)
	  table.insert(sortorder,z)
	end
  end
  for i=1, GetNumAddOns() do
    AddonName,_,_,AddonEnabled = GetAddOnInfo(i);
	if AddonEnabled and not HealBotAddonSummaryNoComms[AddonName] and GetAddOnCPUUsage(i)>100 then
	  HealBotAddonSummaryNoComms[AddonName]=HealBot_Comm_round(GetAddOnCPUUsage(AddonName)/1000, 1)
	  table.insert(sortorder,AddonName)
	end
  end
  table.sort(sortorder,function (a,b)
    if HealBotAddonSummaryNoComms[a]>HealBotAddonSummaryNoComms[b] then return true end
    if HealBotAddonSummaryNoComms[a]<HealBotAddonSummaryNoComms[b] then return false end
    return a<b
  end)
  table.foreach(sortorder, function (index,z)
    tmpttl=HealBotcAddonSummary[z] or 0
	if linenum<35 then 
	  HealBot_Comms_Print_AddonSum(z,HealBotAddonSummaryNoComms[z],floor(GetAddOnMemoryUsage(z)),tmpttl,linenum)
	  linenum=linenum+1
	end
  end)
  --  hbcommver=HealBot_GetInfo()
--  HealBot_Report_Error("-");
--  linenum=5
--  for x,v in pairs(hbcommver) do
--    HealBot_Report_Error(x.. " is using "..v)
--	linenum=linenum+1
--  end
--  for j=linenum,24 do
--    HealBot_Report_Error(" ")
--  end
--  HealBot_Report_Error("UK Internet shoppers... MAKE MONEY for FREE with NO EFFORT. ")
--  HealBot_Report_Error("Discover how easy it is...  see the FreeMoney.html in the healbot directory.")
--  HealBot_Report_Error("See how it works then introduce all your friends and make more money FOR FREE!..  This is Kosher  -Strife")
end

function HealBot_Comms_Print_IncHealsSum(sender_id,addon_id,HealsCnt,linenum)
  getglobal("HBIncH"..linenum.."Healer"):SetText(sender_id);
  getglobal("HBIncH"..linenum.."Ver"):SetText(addon_id);
  getglobal("HBIncH"..linenum.."Cnt"):SetText(HealsCnt);
end

function HealBot_Comms_Print_AddonSum(Addon,CPU,MEM,Comms,linenum)
  getglobal("HBMod"..linenum.."Name"):SetText(Addon);
  getglobal("HBMod"..linenum.."CPU"):SetText(CPU);
  getglobal("HBMod"..linenum.."Mem"):SetText(MEM);
  getglobal("HBMod"..linenum.."Comm"):SetText(Comms);
end

function HealBot_Comms_TargetInfo()
  if HealBot_Error:IsVisible() then
    HealBot_Errors_Clear()
  end
  HealBot_Report_Error("UnitHealth="..UnitHealth("target").."   UnitHealthMax="..UnitHealthMax("target"))
  HealBot_Report_Error("UnitMana="..UnitMana("target").."   UnitManaMax="..UnitManaMax("target"))
end

local mult = 0
function HealBot_Comm_round(num, idp)
  mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end



  