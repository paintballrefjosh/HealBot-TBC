local TempMaxH=0;
local bwidth=nil
local bheight=nil
local bcspace=nil
local brspace=nil
local left=nil
local right=nil
local bottom=nil
local top=nil
local hheight=nil
local hrspace=nil
local hwidth=nil
local hwidthadj=nil
local cols=nil
local nraid=nil
local tBars=nil
local Member_Name=nil
local b=nil
local bar=nil
local hdr=nil
local HealBot_TrackNames={};
local i=nil
local h=nil
local z=nil
local t=nil
local curcol=nil
local unit=nil
local tunit=nil
local getUnitID=nil
local punit=nil
local check=nil
local header=nil
local order = {};
local HealBot_UnitGroup={}
local units = {};
local HealBot_CheckedTargets={};
local name=nil
local rank=nil
local subgroup=nil
local level=nil
local class=nil
local fileName=nil
local zone=nil
local online=nil
local isDead=nil
local TempSort=nil
local MyGroup=0
local HeaderPos={}
local HealBot_CheckGroup=1
local numHeaders = 0
local HealBot_headerno=0
local GroupValid=nil
local TankValid=nil
local ExtraValid=nil
local TargetValid=nil
local PetValid=nil
local HeaderPos={}
local OffsetY = 10;
local OffsetX = 10;
local MaxOffsetY=0;
local HealBot_HeadX={};
local HealBot_HeadY={};
local HealBot_BarX={};
local HealBot_BarY={};
local HealBot_MultiColHoToffset=0;
local HealBot_TrackUnitNames={};
local HealBot_TrackButtons={};
local HealBot_TrackHButtons={};
local HealBot_TrackButtonsH={};
local HealBot_Panel_BlackList={};
local format=format
local ceil=ceil;
local HealBot_AddHeight=4
local HealBot_MyHealTargets={}
local MyHealTargets=nil
local mti=0
local classEN=nil

local HealBot_Action_HealGroup = {
  "player",
  "playerpet",
  "party1",
  "party2",
  "party3",
  "party4",
};

local HealBot_Action_HealButtons = {};

function HealBot_GetMyHealTargets()
	return HealBot_MyHealTargets;
end

function HealBot_Panel_SetBarArrays(bx)
  HealBot_BarX[bx]=0;
  HealBot_BarY[bx]=0;
end

function HealBot_Panel_SetHeadArrays(bx)
  HealBot_HeadX[bx]=0;
  HealBot_HeadY[bx]=0;
end

function HealBot_Panel_ClearBlackList()
  for x,_ in pairs(HealBot_Panel_BlackList) do
    HealBot_Panel_BlackList[x]=nil;
  end
end

function HealBot_Panel_AddBlackList(uName)
  HealBot_Panel_BlackList[uName]=true;
end

function HealBot_Panel_ClearHealTarget()
  HealBot_MyHealTargets = {}
end

function HealBot_Panel_ToggelHealTarget(uName)
  mti=0
  table.foreach(HealBot_MyHealTargets, function (index,pName)
    if pName==uName then
	  mti=index
	end  
  end)
  if mti>0 then
    table.remove(HealBot_MyHealTargets,mti)
	HealBot_AddDebug("Removed "..uName.." from MyTargets")
  else
	table.insert(HealBot_MyHealTargets,uName)
	HealBot_AddDebug("Added "..uName.." to MyTargets")
  end
end

function HealBot_Panel_RetMyHealTarget(uName)
  mti=0
  table.foreach(HealBot_MyHealTargets, function (index,pName)
    if pName==uName then
	  mti=index
	end  
  end)
  if mti>0 then
    return true
  else
	return false
  end
end
  
function HealBot_Panel_SetMultiColHoToffset(nx)
  HealBot_MultiColHoToffset=nx
end

local thisX=nil

function HealBot_Action_PositionButton(button,OsetX,OsetY,bwidth,bheight,header,curcol)
  brspace=HealBot_Config.brspace[HealBot_Config.Current_Skin];
  if header then
    HealBot_headerno=HealBot_headerno+1;
    hheight = ceil(bheight*0.8)
    hrspace = ceil(brspace*1.4)+3
    hdr=getglobal("HealBot_Action_Header"..HealBot_headerno);
    bar = HealBot_Action_HealthBar(hdr);
    hwidth = bwidth*HealBot_Config.headwidth[HealBot_Config.Current_Skin]
    hwidthadj = ceil((bwidth-hwidth)/2);
	thisX=OsetX+hwidthadj+(HealBot_MultiColHoToffset*curcol)
    if HealBot_HeadX[hdr]~=thisX or HealBot_HeadY[hdr]~=format("%s",OsetY)..header then
	     HealBot_HeadX[hdr]=thisX
		 HealBot_HeadY[hdr]=format("%s",OsetY)..header;
         hdr:ClearAllPoints();
		 if HealBot_Config.Panel_Anchor<3 then
           hdr:SetPoint("TOPLEFT","HealBot_Action","TOPLEFT",thisX,-OsetY);
		 else
           hdr:SetPoint("TOPRIGHT","HealBot_Action","TOPRIGHT",-thisX,-OsetY);
		 end
         bar.txt = getglobal(bar:GetName().."_text");
         bar.txt:SetText(header);
         hdr:Show();
    end
    HealBot_TrackButtonsH[hdr]=nil;
    HealBot_TrackHButtons[hdr]=true;
    OsetY = OsetY+hheight+hrspace;
  else
     thisX=OsetX+(HealBot_MultiColHoToffset*curcol)
     if HealBot_BarX[button]~=thisX or HealBot_BarY[button]~=OsetY then
	    HealBot_BarX[button]=thisX
		HealBot_BarY[button]=OsetY;
        button:ClearAllPoints();
        button:SetWidth(bwidth);
		if HealBot_Config.Panel_Anchor<3 then
		  button:SetPoint("TOPLEFT","HealBot_Action","TOPLEFT",thisX,-OsetY)
		else
		  button:SetPoint("TOPRIGHT","HealBot_Action","TOPRIGHT",-thisX,-OsetY)
		end
        button:Show();
	 end
     OsetY = OsetY+bheight+brspace+HealBot_AddHeight
  end
  return OsetY;
end

function HealBot_Action_SetAddHeight()
  if HealBot_Config.bar2size[HealBot_Config.Current_Skin]==0 then
    if HealBot_Config.ShowAggroBars==0 then
	  HealBot_AddHeight=0
	else
	  HealBot_AddHeight=2
	end
  else
    if HealBot_Config.ShowAggroBars==0 then
	  HealBot_AddHeight=HealBot_Config.bar2size[HealBot_Config.Current_Skin]
	else
      HealBot_AddHeight=HealBot_Config.bar2size[HealBot_Config.Current_Skin]*2
	end
  end
end

function HealBot_Action_SetHeightWidth(width,height,bwidth,curcol)
    if HealBot_Config.Panel_Anchor==1 then
 	  if HealBot_Config.PanelAnchorY==-1 or HealBot_Config.PanelAnchorX==-1 then
	    left,top = HealBot_Action:GetLeft(),HealBot_Action:GetTop();
        HealBot_Config.PanelAnchorY=top;
        HealBot_Config.PanelAnchorX=left; 
	  end
      HealBot_Action:ClearAllPoints();
      HealBot_Action:SetPoint("TOPLEFT","UIParent","BOTTOMLEFT",HealBot_Config.PanelAnchorX,HealBot_Config.PanelAnchorY);
    elseif HealBot_Config.Panel_Anchor==2 then
	  if HealBot_Config.PanelAnchorY==-1 or HealBot_Config.PanelAnchorX==-1 then
	    left,bottom = HealBot_Action:GetLeft(),HealBot_Action:GetBottom();
		HealBot_Config.PanelAnchorY=bottom
		HealBot_Config.PanelAnchorX=left
	  end
      HealBot_Action:ClearAllPoints();
      HealBot_Action:SetPoint("BOTTOMLEFT","UIParent","BOTTOMLEFT",HealBot_Config.PanelAnchorX,HealBot_Config.PanelAnchorY);
    elseif HealBot_Config.Panel_Anchor==3 then
  	  if HealBot_Config.PanelAnchorY==-1 or HealBot_Config.PanelAnchorX==-1 then
        right,top = HealBot_Action:GetLeft(),HealBot_Action:GetBottom();
        HealBot_Config.PanelAnchorY=top;
        HealBot_Config.PanelAnchorX=right; 
	  end
      HealBot_Action:ClearAllPoints();
      HealBot_Action:SetPoint("TOPRIGHT","UIParent","BOTTOMLEFT",HealBot_Config.PanelAnchorX,HealBot_Config.PanelAnchorY);
    elseif HealBot_Config.Panel_Anchor==4 then
   	  if HealBot_Config.PanelAnchorY==-1 or HealBot_Config.PanelAnchorX==-1 then
        right,bottom = HealBot_Action:GetLeft(),HealBot_Action:GetBottom();
		HealBot_Config.PanelAnchorY=bottom;
        HealBot_Config.PanelAnchorX=right; 
	  end
      HealBot_Action:ClearAllPoints();
      HealBot_Action:SetPoint("BOTTOMRIGHT","UIParent","BOTTOMLEFT",HealBot_Config.PanelAnchorX,HealBot_Config.PanelAnchorY);
    end
  HealBot_Action:SetHeight(height);
  if HealBot_Config.HoTposBar==2 then curcol=curcol+1; end;
  HealBot_Action:SetWidth(width+bwidth+10+(HealBot_MultiColHoToffset*curcol))
end


function HealBot_Panel_PartyChanged(showHeaders)

  nraid=GetNumRaidMembers();
  MyHealTargets=nil
   
  HealBot_CheckGroup=1;
  numHeaders = 0
  TempMaxH=0;
  bwidth = HealBot_Config.bwidth[HealBot_Config.Current_Skin];
  bheight=HealBot_Config.bheight[HealBot_Config.Current_Skin];
  bcspace=HealBot_Config.bcspace[HealBot_Config.Current_Skin];
  cols=HealBot_Config.numcols[HealBot_Config.Current_Skin];

  for x,_ in pairs(HeaderPos) do
    HeaderPos[x]=nil;
  end
  for x,_ in pairs(HealBot_Action_HealButtons) do
    HealBot_Action_HealButtons[x]=nil;
  end
  
  for x,_ in pairs(HealBot_TrackNames) do
    HealBot_TrackNames[x]=nil;
  end
  
  for blUname,_ in pairs(HealBot_Panel_BlackList) do
    HealBot_TrackNames[blUname]=true
  end 
  
  table.foreach(HealBot_MyHealTargets, function (index,blUname)
    HealBot_TrackNames[blUname]=true
	MyHealTargets=true
  end)
  
  HealBot_TrackNames[HEALBOT_WORDS_UNKNOWN]=true
  
  HealBot_headerno=0;
    i=0;
    h=1;
    z=1;
	curcol=2-HealBot_Config.HoTposBar;

    OffsetY = 10;
    OffsetX = 10;
    MaxOffsetY=0;
    
    if HealBot_Config.SelfHeals==1 then
        if showHeaders then 
		  HeaderPos[i+1] = HEALBOT_OPTIONS_SELFHEALS 
		  GroupValid=i
		end
        unit="player";
        Member_Name=UnitName(unit);
	    if not HealBot_TrackNames[Member_Name] and Member_Name then
          i = i+1;
          HealBot_UnitName[unit] = Member_Name;
		  HealBot_TrackNames[Member_Name]=true;
          b=HealBot_Action_SetHealButton(i,unit,Member_Name);
			if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames[Member_Name]=nil
              table.insert(HealBot_Action_HealButtons,b)
			end
		end
	  if showHeaders and i>GroupValid then 
	    numHeaders=numHeaders+1
		if HealBot_Config.SelfPet==1 then
			unit="playerpet";
			Member_Name=UnitName(unit);
			if not HealBot_TrackNames[Member_Name] and Member_Name then
			  i = i+1;
			  HealBot_UnitName[unit] = Member_Name;
			  HealBot_TrackNames[Member_Name]=true;
			  b=HealBot_Action_SetHealButton(i,unit,Member_Name);
				if b then
				  HealBot_TrackButtons[b]=nil
				  HealBot_TrackUnitNames[Member_Name]=nil
				  table.insert(HealBot_Action_HealButtons,b)
				end
			end
		end
	  end
    end
	


    if HealBot_Config.TankHeals==1 and nraid>0 then
      if showHeaders then 
		HeaderPos[i+1] = HEALBOT_OPTIONS_TANKHEALS 
		GroupValid=i
      end
      for j=1,10 do
	    Member_Name = HealBot_MainTanks[j];
		unit=nil
		getUnitID=true;
	    if not HealBot_TrackNames[Member_Name] and Member_Name then
		  if HealBot_UnitID[Member_Name] then
            tunit=HealBot_UnitID[Member_Name];
			if HealBot_UnitName[tunit]==UnitName(tunit) then
			  unit=tunit
			  getUnitID=false;
			end
		  end
		  if getUnitID then
		    for k=1,nraid do
	          tunit = "raid"..k;
			  if Member_Name==UnitName(tunit) then
			    unit=tunit;
				do break end;
			  end
			end
		  end
          if Member_Name and unit then
            i = i+1;
            HealBot_UnitName[unit] = Member_Name;
			HealBot_TrackNames[Member_Name]=true;
            b=HealBot_Action_SetHealButton(i,unit,Member_Name);
			if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames[Member_Name]=nil
              table.insert(HealBot_Action_HealButtons,b)
			end
          end
        end
      end
	  if showHeaders and i>GroupValid then numHeaders=numHeaders+1 end
    end
    
	MyGroup=0
    if HealBot_Config.GroupHeals==1 then
      if showHeaders then 
	    MyGroup=i+1
		HeaderPos[MyGroup] = HEALBOT_OPTIONS_GROUPHEALS 
		GroupValid=i
      end
      for _,unit in ipairs(HealBot_Action_HealGroup) do
	    if unit~="playerpet" or HealBot_Config.SelfPet==1 then
          Member_Name=UnitName(unit);
	      if Member_Name and not HealBot_TrackNames[Member_Name] then
            if nraid>0 and Member_Name~=HealBot_PlayerName then 
	          HealBot_UnitName[unit] = nil
	          unit=HealBot_RaidUnit(unit,Member_Name) 
            end
            i = i+1;
            HealBot_UnitName[unit] = Member_Name;
            HealBot_TrackNames[Member_Name]=true;
            b=HealBot_Action_SetHealButton(i,unit,Member_Name);
		    if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames[Member_Name]=nil
              table.insert(HealBot_Action_HealButtons,b)
            end
          end
		end
	  end
	  if showHeaders and i>GroupValid then 
	    numHeaders=numHeaders+1 
	  else
	    MyGroup=0
	  end
    end
	
    if MyHealTargets then
      if showHeaders then 
		HeaderPos[i+1] = HEALBOT_OPTIONS_MYTARGET 
		GroupValid=i
      end
      table.foreach(HealBot_MyHealTargets, function (index,Member_Name)
--		HealBot_AddDebug("In MyHealTargets - Member_Name="..Member_Name)
        unit=HealBot_RaidUnit("unknown",Member_Name) 
        if UnitName(unit) then
          i = i+1;
          HealBot_UnitName[unit] = Member_Name;
          b=HealBot_Action_SetHealButton(i,unit,Member_Name);
		  if b then
		    HealBot_TrackButtons[b]=nil
            HealBot_TrackUnitNames[Member_Name]=nil
            table.insert(HealBot_Action_HealButtons,b)
          end
        end
	  end)
	  if showHeaders and i>GroupValid then numHeaders=numHeaders+1 end
    end

    if HealBot_Config.EmergencyHeals==1 then
	  for x,_ in pairs(order) do
        order[x]=nil;
      end
      for x,_ in pairs(units) do
        units[x]=nil;
      end
      if showHeaders then
	    GroupValid=i
		if HealBot_Config.ExtraOrder==1 then
          HeaderPos[i+1] = HEALBOT_OPTIONS_EMERGENCYHEALS
          numHeaders=numHeaders+1;
        end
      end
      if HealBot_Config.EmergIncMonitor==1 then
        if nraid>0 then
          for j=1,nraid do
            unit = "raid"..j;
            Member_Name=UnitName(unit);
            if Member_Name==HealBot_PlayerName then
			  unit="player"
			  if MyGroup>0 then
			    name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(j);
                HeaderPos[MyGroup] = HEALBOT_OPTIONS_GROUPHEALS.." "..subgroup;
			  end
            end
            if Member_Name and not HealBot_TrackNames[Member_Name] then
              name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(j);
              if HealBot_Config.ExtraIncGroup[subgroup] and class then
                  if HealBot_Config.ExtraOrder==1 then
                    order[unit] = name;
                  elseif HealBot_Config.ExtraOrder==2 then
                    order[unit] = class;
                  elseif HealBot_Config.ExtraOrder==3 then
                    order[unit] = subgroup;
                  else
                    order[unit] = 0-UnitHealthMax(unit);
                    if UnitHealthMax(unit)>TempMaxH then TempMaxH=UnitHealthMax(unit); end
                  end
                  table.insert(units,unit);
                  HealBot_UnitGroup[unit]=subgroup
                  HealBot_UnitName[unit] = Member_Name;
				  HealBot_TrackNames[Member_Name]=true;
              end
            end
          end
        elseif HealBot_Config.GroupHeals==0 then
          for _,unit in ipairs(HealBot_Action_HealGroup) do
            Member_Name=UnitName(unit);
            if Member_Name and not HealBot_TrackNames[Member_Name] then
              class,_=UnitClass(unit)
              subgroup = 1;
              name = Member_Name;
            
              if HealBot_Config.ExtraIncGroup[subgroup] and class then
                  if HealBot_Config.ExtraOrder==1 then
                    order[unit] = name;
                  elseif HealBot_Config.ExtraOrder==2 then
                    order[unit] = class;
                  elseif HealBot_Config.ExtraOrder==3 then
                    order[unit] = subgroup;
                  else
                    order[unit] = 0-UnitHealthMax(unit);
                    if UnitHealthMax(unit)>TempMaxH then TempMaxH=UnitHealthMax(unit); end
                  end
                  table.insert(units,unit);
                  HealBot_UnitGroup[unit]=subgroup
                  HealBot_UnitName[unit] = Member_Name;
  				  HealBot_TrackNames[Member_Name]=true;
              end
            end
          end
        end
      else
        if nraid>0 then
          for j=1,nraid do
 
            unit = "raid"..j;
            Member_Name=UnitName(unit);
            if Member_Name==HealBot_PlayerName then
			  unit="player"
			  if MyGroup>0 then
			    name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(j);
                HeaderPos[MyGroup] = HEALBOT_OPTIONS_GROUPHEALS.." "..subgroup;
			  end
            end
			if Member_Name and not HealBot_TrackNames[Member_Name] then
              name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(j);
			  _,classEN=UnitClass(unit)
              if HealBot_Config.ExtraIncGroup[subgroup] and class and HealBot_EmergInc[strsub(classEN,1,4)]==1 then
                  if HealBot_Config.ExtraOrder==1 then
                    order[unit] = name;
                  elseif HealBot_Config.ExtraOrder==2 then
                    order[unit] = class;
                  elseif HealBot_Config.ExtraOrder==3 then
                    order[unit] = subgroup;
                  else
                    order[unit] = 0-UnitHealthMax(unit);
                    if UnitHealthMax(unit)>TempMaxH then TempMaxH=UnitHealthMax(unit); end
                  end
                  table.insert(units,unit);
				  HealBot_UnitGroup[unit]=subgroup
                  HealBot_UnitName[unit] = Member_Name;
  				  HealBot_TrackNames[Member_Name]=true;
              end
            end
          end
        elseif HealBot_Config.GroupHeals==0 then
          for _,unit in ipairs(HealBot_Action_HealGroup) do
            class,classEN = UnitClass(unit);
            Member_Name=UnitName(unit);
            if Member_Name and class and not HealBot_TrackNames[Member_Name] then
              name = Member_Name;
              subgroup = 1;
              
              if HealBot_Config.ExtraIncGroup[subgroup] and HealBot_EmergInc[strsub(classEN,1,4)]==1 then
                  if HealBot_Config.ExtraOrder==1 then
                    order[unit] = name;
                  elseif HealBot_Config.ExtraOrder==2 then
                    order[unit] = class;
                  elseif HealBot_Config.ExtraOrder==3 then
                    order[unit] = subgroup;
                  else
                    order[unit] = 0-UnitHealthMax(unit);
                    if UnitHealthMax(unit)>TempMaxH then TempMaxH=UnitHealthMax(unit); end
                  end
                  table.insert(units,unit);
				  HealBot_UnitGroup[unit]=subgroup
                  HealBot_UnitName[unit] = Member_Name;
				  HealBot_TrackNames[Member_Name]=true;
              end
            end
          end
        end
      end
      table.sort(units,function (a,b)
        if order[a]<order[b] then return true end
        if order[a]>order[b] then return false end
        return a<b
      end)
      TempMaxH=ceil(TempMaxH/1000)*1000;
	  TempSort="init"

		for j=1,40 do
          if not units[j] then break end
          unit=units[j];
          Member_Name = HealBot_UnitName[unit];
		  if showHeaders then
            if HealBot_Config.ExtraOrder==2 and TempSort~=UnitClass(unit) then 
              TempSort=UnitClass(unit)
              HeaderPos[i+1] = UnitClass(unit)
              numHeaders=numHeaders+1;
            end
            if HealBot_Config.ExtraOrder==3 and TempSort~=HealBot_UnitGroup[unit] then
              TempSort=HealBot_UnitGroup[unit]
              HeaderPos[i+1] = HEALBOT_OPTIONS_GROUPHEALS.." "..TempSort
              numHeaders=numHeaders+1;
            end
            if HealBot_Config.ExtraOrder==4 and TempMaxH>UnitHealthMax(unit) then
              TempMaxH=TempMaxH-1000
              HeaderPos[i+1] = ">"..format("%s",(TempMaxH/1000)).."k"
              numHeaders=numHeaders+1;
            end
		  end
          i = i+1;
          b=HealBot_Action_SetHealButton(i,unit,Member_Name);
	      if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames[Member_Name]=nil
              table.insert(HealBot_Action_HealButtons,b)
		  end
        end
      if showHeaders and i==GroupValid+1 then HeaderPos[i+1] = nil end
    end
    
    if HealBot_Config.PetHeals==1 then
      for x,_ in pairs(HealBot_CheckedTargets) do
        HealBot_CheckedTargets[x]=nil;
      end
      if showHeaders then 
		HeaderPos[i+1] = HEALBOT_OPTIONS_PETHEALS 
		GroupValid=i
      end
      HealBot_CheckedTargets[HEALBOT_WORDS_UNKNOWN]=true;
      unit="pet"
      punit="player"
      Member_Name=UnitName(unit);
      if not HealBot_TrackNames[Member_Name] and not HealBot_CheckedTargets[Member_Name] and Member_Name then
        i = i+1;
        HealBot_UnitName[unit] = Member_Name;
        b=HealBot_Action_SetHealButton(i,unit,Member_Name);
	    if b then
		  HealBot_TrackButtons[b]=nil
          HealBot_TrackUnitNames[Member_Name]=nil
          table.insert(HealBot_Action_HealButtons,b)
		end
        HealBot_CheckedTargets[Member_Name]=true;
      end
      if nraid>0 then
        for j=1,40 do
          unit="raidpet"..j;
          punit="raid"..j;
          Member_Name=UnitName(unit);
          if not HealBot_TrackNames[Member_Name] and not HealBot_CheckedTargets[Member_Name] and HealBot_TrackNames[UnitName(punit)] and Member_Name then
            i = i+1;
            HealBot_UnitName[unit] = Member_Name;
            b=HealBot_Action_SetHealButton(i,unit,Member_Name);
			if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames[Member_Name]=nil
		      table.insert(HealBot_Action_HealButtons,b)
			else
			  i=i-1
			end
            HealBot_CheckedTargets[Member_Name]=true;
          end
          if i>56 then break end
        end
      else
        for j=1,4 do
          unit="partypet"..j;
          punit="party"..j;
          Member_Name=UnitName(unit);
          if not HealBot_TrackNames[Member_Name] and not HealBot_CheckedTargets[Member_Name] and HealBot_TrackNames[UnitName(punit)] and Member_Name then
            i = i+1;
            HealBot_UnitName[unit] = Member_Name;
            b=HealBot_Action_SetHealButton(i,unit,Member_Name);
			if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames[Member_Name]=nil
              table.insert(HealBot_Action_HealButtons,b)
			else
			  i=i-1
			end
            HealBot_CheckedTargets[Member_Name]=true;
          end
        end
      end
	  if showHeaders and i>GroupValid then numHeaders=numHeaders+1 end
    end
    
    if HealBot_Config.TargetHeals==1 and not HealBot_IsFighting then
	  if (UnitIsFriend("player","target")) then
	    Member_Name=UnitName("target")
		TargetValid=false
		if Member_Name==HealBot_PlayerName then 
		  if HealBot_Config.TargetIncSelf==1 then TargetValid=true end
		elseif UnitInParty("target") then
		  if HealBot_Config.TargetIncGroup==1 then TargetValid=true end
		elseif UnitInRaid("target") then 
		  if HealBot_Config.TargetIncRaid==1 then TargetValid=true end
		elseif UnitPlayerOrPetInParty("target") or UnitPlayerOrPetInRaid("target") then
		  if HealBot_Config.TargetIncPet==1 then TargetValid=true end
		else
		  TargetValid=true
		end
	    if TargetValid and not HealBot_Panel_BlackList[Member_Name] then

          if showHeaders then HeaderPos[i+1] = HEALBOT_OPTIONS_TARGETHEALS end
          unit="target";
          if HealBot_MayHeal(unit, Member_Name) then
            HealBot_UnitName["target"] = Member_Name;	
	        b=HealBot_Action_SetTargetHealButton(unit,Member_Name);
		    if b then
		      HealBot_TrackButtons[b]=nil
              HealBot_TrackUnitNames["target"]=nil
              table.insert(HealBot_Action_HealButtons,b)
			  if showHeaders then numHeaders=numHeaders+1 end
            end
          end
		end
      end
    end
	
  for Member_Name,_ in pairs(HealBot_TrackUnitNames) do
    HealBot_TrackUnitNames[Member_Name]=nil
	HealBot_Action_RemoveMember(Member_Name)
  end
  
  i=0
  curcol=2-HealBot_Config.HoTposBar
  z=1;
  OffsetY = 10;
  OffsetX = 10;
  MaxOffsetY=0;

  if showHeaders then 
    h=0
    table.foreach(HealBot_Action_HealButtons, function (index,button)
      Member_Name=HealBot_UnitName[button.unit];
      if Member_Name then
	    i=i+1
        if HeaderPos[i] then
          h=h+1;
          header=HeaderPos[i];
          if h>cols then
            if MaxOffsetY<OffsetY then MaxOffsetY = OffsetY; end
            OffsetY = 10;
            OffsetX = OffsetX + bwidth+bcspace; 
            h=1;
            curcol=curcol+1
          end
          OffsetY = HealBot_Action_PositionButton(nil,OffsetX,OffsetY,bwidth,bheight,header,curcol);
        end
        OffsetY = HealBot_Action_PositionButton(button,OffsetX,OffsetY,bwidth,bheight,nil,curcol);
      end
    end)
  else
    h=1
	tBars=table.getn(HealBot_Action_HealButtons)
    table.foreach(HealBot_Action_HealButtons, function (index,button)
      Member_Name=HealBot_UnitName[button.unit];
      if Member_Name then
	    i=i+1
		OffsetY = HealBot_Action_PositionButton(button,OffsetX,OffsetY,bwidth,bheight,nil,curcol)
        if h==ceil((tBars)/cols) and z<tBars then
          h=0;
          if MaxOffsetY<OffsetY then MaxOffsetY = OffsetY; end
          OffsetY = 10;
          OffsetX = OffsetX + bwidth+bcspace; 
          curcol=curcol+1;
        end
		
        z=z+1
        h=h+1;
	  end
	end)
  end

  for button,_ in pairs(HealBot_TrackButtonsH) do
    button:Hide();
	HealBot_HeadY[button]="0"
    HealBot_TrackButtonsH[button]=nil;
  end
  for button,_ in pairs(HealBot_TrackButtons) do
    button:Hide();
	HealBot_Panel_SetBarArrays(button)
    HealBot_TrackButtons[button]=nil;
  end
  for unit,button in pairs(HealBot_Unit_Button) do
    if UnitName(unit) then
      HealBot_TrackButtons[button]=true;
      HealBot_TrackUnitNames[UnitName(unit)]=true;
      if HealBot_HoT_Active_Button[UnitName(unit)] then
        if HealBot_HoT_Active_Button[UnitName(unit)]~=button then
          HealBot_HoT_MoveIcon(HealBot_HoT_Active_Button[UnitName(unit)], button, UnitName(unit))
          HealBot_HoT_Active_Button[UnitName(unit)]=button       
        end
      end
	else
	  HealBot_Unit_Button[unit]=nil
	end
  end
  
  for button,_ in pairs(HealBot_TrackHButtons) do
    HealBot_TrackButtonsH[button]=true;
  end

  if MaxOffsetY<OffsetY then MaxOffsetY = OffsetY; end

  if HealBot_Config.HideOptions==1 then
    HealBot_Action_OptionsButton:Hide();
  else
--    if HealBot_Config.Panel_Anchor<3 then
      HealBot_Action_OptionsButton:SetPoint("BOTTOM","HealBot_Action","BOTTOM",0,10);
--	else
--	  HealBot_Action_OptionsButton:SetPoint("BOTTOMLEFT","HealBot_Action","BOTTOM",0,10)
--	end
    HealBot_Action_OptionsButton:Show();
    MaxOffsetY = MaxOffsetY+30;
  end  

  HealBot_Action_SetHeightWidth(OffsetX, MaxOffsetY+10, bwidth,curcol);
  HealBot_Action_RefreshButtons();
  
end

function HealBot_Action_RemoveMember(uName)
	HealBot_ClearHealsIn(uName)
	HealBot_Action_ClearHealsIn(uName)
end

