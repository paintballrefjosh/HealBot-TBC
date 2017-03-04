local HealBot_headerno=0;

local HealBot_ClassColR = {};
local HealBot_ClassColG = {};
local HealBot_ClassColB = {};
local class=nil
local HealBot_UnitStatus={};
local HealBot_PlayerDead=false;
local HealBot_CheckGroup=0;
local HealBot_Enabled={};
local HealBot_PetMaxH={};
local HealBot_PetMaxHcnt1={};
local HealBot_PetMaxHcnt2={};
local HealBot_AttribStatus={};
local HealBot_UnitRange={}
local HealBot_UnitRangeSpell={}
local HealBot_UnitRanger={}
local HealBot_UnitRangeg={}
local HealBot_UnitRangeb={}
local HealBot_UnitRangea={}
local HealBot_UnitRangeitr={}
local HealBot_UnitRangeitg={}
local HealBot_UnitRangeitb={}
local HealBot_UnitRangeotr={}
local HealBot_UnitRangeotg={}
local HealBot_UnitRangeotb={}
local HealBot_UnitRangeota={}
local HealBot_curUnitHealth={}
local HealBot_UnitBarUpdate={}
local HealBot_TrackBars={}
local HealBot_ResetBars={}
local ceil=ceil;
local unit=nil
local b=nil
local btHBbarText=nil
local btname=nil
local bttextlen=0
local bthlthdelta=0
local floor=floor
local strlower=strlower
local strlen=strlen
local strsub=strsub
local HealBot_ButtonStore={}
local HealBot_hSpell="Heal"
local HealBot_bSpell="Power Word: Fortitude"
local HealBot_dSpell="Cure Disease"
local HealBot_rSpell="Resurrection"

local HealBot_ButtonArray1={}
local HealBot_ButtonArray2={}
local HealBot_SmallArray=nil
local HealBot_ButtonArray=1
local HealBot_Aggro={}
local HealBot_AggroBar4={}
local HealBot_AggroBar3={}
local HealBot_AggroBarA=0.5
local HealBot_AggroBarAup=true
local HealBot_MyTargets={}
local HB_Action_Timer1 = 2000

local HealBot_Unit_Bar1={}
local HealBot_Unit_Bar2={}
local HealBot_Unit_Bar3={}
local HealBot_Unit_Bar4={}
local HealBot_FrameMoving=nil

function HealBot_Action_AddDebug(msg)
  HealBot_AddDebug("Action: " .. msg);
end

local uaName=nil
local uaBar4=nil
function HealBot_Action_UpdateAggro(unit,status)
  uaName=HealBot_UnitName[unit]
  uaBar4=HealBot_Unit_Bar4[unit]
  HealBot_UnitRange[unit]=-2
  HealBot_UnitStatus[unit]=1
  if not uaBar4 or not uaName then 
    return 
  else
    HealBot_Aggro[uaName]=status
  end
  if not status then
    if HealBot_AggroBar4[uaName] then
	  uaBar4=HealBot_AggroBar4[uaName]
	  uaBar4:SetValue(0)
	  HealBot_AggroBar4[uaName]=nil
	end
  elseif HealBot_Config.ShowAggroBars==1 then
    if not HealBot_AggroBar4[uaName] then
      HealBot_AggroBar4[uaName]=uaBar4
      uaBar4:SetValue(100)
	elseif HealBot_AggroBar4[uaName]~=uaBar4 then
	  uaBar4=HealBot_AggroBar4[uaName]
	  uaBar4:SetValue(0)
      HealBot_AggroBar4[uaName]=uaBar4
      uaBar4:SetValue(100)
	end
  end
end

function HealBot_Action_SetrSpell()
  if strsub(HealBot_PlayerClassEN,1,4)=="DRUI" then
    HealBot_hSpell=HEALBOT_REJUVENATION
	HealBot_bSpell=HEALBOT_MARK_OF_THE_WILD
	HealBot_dSpell=HEALBOT_CURE_POISON
	HealBot_rSpell=HEALBOT_REBIRTH
  elseif strsub(HealBot_PlayerClassEN,1,4)=="HUNT" then
    HealBot_hSpell=HEALBOT_MENDPET
  elseif strsub(HealBot_PlayerClassEN,1,4)=="MAGE" then
    HealBot_hSpell=HEALBOT_ARCANE_INTELLECT
	HealBot_bSpell=HEALBOT_ARCANE_INTELLECT
	HealBot_dSpell=HEALBOT_REMOVE_LESSER_CURSE
  elseif strsub(HealBot_PlayerClassEN,1,4)=="PALA" then
    HealBot_hSpell=HEALBOT_HOLY_LIGHT
	HealBot_bSpell=HEALBOT_BLESSING_OF_MIGHT
	HealBot_dSpell=HEALBOT_PURIFY
	HealBot_rSpell=HEALBOT_REDEMPTION
  elseif strsub(HealBot_PlayerClassEN,1,4)=="PRIE" then
    HealBot_hSpell=HEALBOT_LESSER_HEAL
	HealBot_bSpell=HEALBOT_POWER_WORD_FORTITUDE
	HealBot_dSpell=HEALBOT_CURE_DISEASE
	HealBot_rSpell=HEALBOT_RESURRECTION
  elseif strsub(HealBot_PlayerClassEN,1,4)=="ROGU" then
    HealBot_hSpell=HEALBOT_HEAVY_NETHERWEAVE_BANDAGE
    HealBot_bSpell=HEALBOT_HEAVY_NETHERWEAVE_BANDAGE
  elseif strsub(HealBot_PlayerClassEN,1,4)=="SHAM" then
    HealBot_hSpell=HEALBOT_HEALING_WAVE
	HealBot_bSpell=HEALBOT_EARTH_SHIELD
	HealBot_dSpell=HEALBOT_CURE_DISEASE
	HealBot_rSpell=HEALBOT_ANCESTRALSPIRIT
  elseif strsub(HealBot_PlayerClassEN,1,4)=="WARL" then
    HealBot_hSpell=HEALBOT_UNENDING_BREATH
    HealBot_bSpell=HEALBOT_UNENDING_BREATH
  elseif strsub(HealBot_PlayerClassEN,1,4)=="WARR" then
    HealBot_hSpell=HEALBOT_HEAVY_NETHERWEAVE_BANDAGE
    HealBot_bSpell=HEALBOT_HEAVY_NETHERWEAVE_BANDAGE
  else
    HealBot_AddDebug("UnitClass(HealBot_PlayerName) NOT FOUND in HealBot_Action_SetrSpell()")
  end
--  HealBot_SetrSpells(HealBot_hSpell,HealBot_bSpell,HealBot_dSpell,HealBot_rSpell)
end

local hcr=nil
local hcg=nil
local hcb=nil
local hca=nil
local hcta=nil
local hcpct=nil
local hrpct=100
function HealBot_HealthColor(unit,hlth,maxhlth,tooltipcol,Member_Name,UnitDead,Member_Buff,Member_Debuff,healin)
  if UnitDead then
    hcpct=0
    hrpct=0
  else
    hcpct = hlth+healin
    if hcpct<maxhlth then
      hcpct=hcpct/maxhlth
    else
      hcpct=1;
    end
    if maxhlth == 0 then
    	hrpct = 100;
    else
    	hrpct=floor((hlth/maxhlth)*100)
    end
  end
  
  if not tooltipcol then
    HealBot_UnitStatus[unit]=1
    if UnitDead then
	  if HealBot_HoT_Active_Button[Member_Name] then HealBot_HoT_RemoveIcon(Member_Name) end
    elseif Member_Debuff then
        return HealBot_Config.CDCBarColour[Member_Debuff].R,
               HealBot_Config.CDCBarColour[Member_Debuff].G,
               HealBot_Config.CDCBarColour[Member_Debuff].B,
               HealBot_Config.bareora[HealBot_Config.Current_Skin],
			   hrpct,
			   HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]
    elseif Member_Buff and UnitIsConnected(unit) then
		hcr,hcg,hcb=HealBot_Options_RetBuffRGB(Member_Buff)
        return hcr,hcg,hcb,HealBot_Config.bareora[HealBot_Config.Current_Skin],hrpct,HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]
    elseif hlth>maxhlth*HealBot_Config.AlertLevel and healin==0 then
        HealBot_UnitStatus[unit]=0;
    end
  end

  hcr,hcg,hcb = 1.0, 1.0, 0.0;
  if hcpct<=HealBot_Config.AlertLevel or HealBot_Aggro[Member_Name] then
    hca=HealBot_Config.bareora[HealBot_Config.Current_Skin]
	hcta=HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]
  else
    hca=HealBot_Config.bardisa[HealBot_Config.Current_Skin]
	hcta=HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin]
  end

  if hcpct>=0.98 then hcr = 0.0;
  elseif hcpct<0.98 and hcpct>=0.65 then hcr=2.94-(hcpct*3);
  elseif hcpct<=0.64 and hcpct>0.31 then hcg=(hcpct-0.31)*3; 
  elseif hcpct<=0.31 then hcg = 0.0; 
  end
  
  if (HealBot_Config.SetBarClassColour == 1) then
  	hcr,hcg,hcb = HealBot_Action_ClassColour(unit);
  end
  
  return hcr,hcg,hcb,hca,hrpct,hcta
end

local barName=nil
function HealBot_Action_HealthBar(button)
  if not button then return; end
  barName = button:GetName();
  return getglobal(barName.."Bar");
end

function HealBot_Action_HealthBar2(button)
  if not button then return; end
  barName = button:GetName();
  return getglobal(barName.."Bar2");
end

function HealBot_Action_HealthBar3(button)
  if not button then return; end
  barName = button:GetName();
  return getglobal(barName.."Bar3");
end

function HealBot_Action_HealthBar4(button)
  if not button then return; end
  barName = button:GetName();
  return getglobal(barName.."Bar4");
end

function HealBot_Action_ShouldHealSome(unit)
  if HealBot_Enabled[unit] then 
    return true
  else
    for hbunit,button in pairs(HealBot_Unit_Button) do
  	  if HealBot_Enabled[UnitName(hbunit)] then
  	    return true
 	  end
    end
  end
end

function HealBot_MayHeal(unit, name)
  if name then
    if unit ~= 'target' then return true end
    if UnitCanAttack("player",unit) then return false end
    return true;
  else
    return false;
  end
end

function HealBot_Action_RefreshBar3(unit)
--  if HealBot_Config.bar2size[HealBot_Config.Current_Skin]>0 and HealBot_UnitName[unit] then
	HealBot_Action_SetBar3Value(HealBot_Unit_Button[unit]);
--  end
end

local b3r=nil
local b3g=nil
local b3b=nil
local mm=nil
local mpct=0
function HealBot_Action_SetBar3Value(button)
  if not button then return end
  barName = HealBot_Unit_Bar3[button.unit]
  if UnitManaMax(button.unit)==0 then
    mm=100
  else
    mm=UnitManaMax(button.unit)
  end
  mpct=floor((UnitMana(button.unit)/mm)*100)
  b3r,b3g,b3b=HealBot_Action_GetManaBarCol(button.unit)
  barName:SetValue(mpct);
  barName:SetStatusBarColor(b3r,b3g,b3b)  
end

local powertype=nil
function HealBot_Action_GetManaBarCol(unit)
  powertype=UnitPowerType(unit);
  if powertype==0 then
    return 0,0,0.8
  elseif powertype==1 then
    return 0.8,0,0
  elseif powertype==3 then
    return 0.8,0.8,0
  elseif powertype==4 then
    return 0.8,0,0.8
  end
  return 0.8,0.8,0
end

function HealBot_CorrectPetHealth(unit,hlth,maxhlth,pName)
  if not HealBot_PetMaxH[pName] then
    HealBot_PetMaxH[pName]=hlth;
  elseif hlth>HealBot_PetMaxH[pName] then
    HealBot_PetMaxH[pName]=hlth;
  elseif not HealBot_IsFighting then
    if not HealBot_PetMaxHcnt1[pName] then
      HealBot_PetMaxHcnt1[pName]=1
      HealBot_PetMaxHcnt2[pName]=HealBot_PetMaxH[pName];
    else
      if HealBot_PetMaxHcnt2[pName]~=hlth then
        HealBot_PetMaxHcnt2[pName]=hlth;
        HealBot_PetMaxHcnt1[pName]=1;
      else
        HealBot_PetMaxHcnt1[pName]=HealBot_PetMaxHcnt1[pName]+1;
        if HealBot_PetMaxHcnt1[pName]>20 then
          HealBot_PetMaxH[pName]=HealBot_PetMaxHcnt2[pName];
        end
      end
    end
  end
  return HealBot_PetMaxH[pName]
end

local ebuName=nil
local ebuhlth=nil
local ebumaxhlth=nil
local ebubar=nil
local ebubar2=nil
local ebusr=nil
local ebusg=nil
local ebusb=nil
local ebusa=nil
local ebur=nil
local ebug=nil
local ebub=nil
local ebua=nil
local ebpct=1
local ebipct=0
local ebtext=nil
local ebuhealin=nil
local ebub2=nil
local ebufastenable=nil
local ebuProcessThis=nil
local ebuUnitDead=nil
local ebuHealBot_UnitDebuff=nil
local ebuHealBot_UnitBuff=nil
local ebuUnit_BuffRange=false
local ebuUnit_HealRange=false
function HealBot_Action_EnableButton(button, ebuName)

  ebUnit=button.unit
  if not ebUnit then return end

  if not ebuName then 
    ebuName=HEALBOT_WORDS_UNKNOWN
  end
  ebuUnitDead = UnitIsDeadOrGhost(ebUnit)
  ebubar = HealBot_Unit_Bar1[ebUnit]
  ebubar2 = HealBot_Unit_Bar2[ebUnit]
  ebuhlth,ebumaxhlth=HealBot_UnitHealth(ebUnit)
  HealBot_UnitRangeSpell[ebUnit]=HealBot_hSpell

  if ebuName~=HEALBOT_WORDS_UNKNOWN then
  
    ebuHealBot_UnitDebuff=HealBot_UnitDebuff[ebuName]
    ebuHealBot_UnitBuff=HealBot_UnitBuff[ebuName]
    ebuhealin = HealBot_RetHealsIn(ebuName)
	
    if ebuUnitDead then
      if UnitIsFeignDeath(ebUnit) then
        ebuUnitDead = nil
      else
	    if ebuhealin>0 then
	      ebuhealin=0
        end
        if HealBot_Aggro[ebuName] then
	      HealBot_Action_UpdateAggro(ebUnit,false)
	      HealBot_Aggro[ebuName]=nil
	    end
	    if HealBot_UnitDebuff[ebuName] then
		  HealBot_UnitDebuff[ebuName]=nil
        end
	  end
  	  if ebuName==HealBot_PlayerName and not HealBot_PlayerDead then
	    HealBot_Action_ResetActiveUnitStatus()
	    HealBot_PlayerDead=true
	  end
    elseif ebuName==HealBot_PlayerName and HealBot_PlayerDead then
	  HealBot_Action_ResetActiveUnitStatus()
	  HealBot_PlayerDead=false
    end
	
    if HealBot_UnitInRange(HealBot_bSpell, ebUnit)==1 then
    	ebuUnit_BuffRange=true
		ebuUnit_HealRange=true
    elseif HealBot_UnitInRange(HealBot_hSpell, ebUnit)==1 then
    	ebuUnit_BuffRange=false
		ebuUnit_HealRange=true
	else
    	ebuUnit_BuffRange=false
		ebuUnit_HealRange=false
    end

    if ebuhealin>0 then
      ebipct = ebuhlth+ebuhealin
      if ebipct<ebumaxhlth then
        ebipct=ebipct/ebumaxhlth
      else
        ebipct=1;
	  end
      ebipct=floor(ebipct*100)
      ebubar2:SetValue(ebipct);
--	  HealBot_UnitRange[ebUnit]=-2
    elseif ebubar2:GetValue()>0 then
      ebubar2:SetValue(0)
    end	
    
	ebur,ebug,ebub,ebua,ebpct,ebusa = HealBot_HealthColor(ebUnit,ebuhlth,ebumaxhlth,false,ebuName,ebuUnitDead,ebuHealBot_UnitBuff,ebuHealBot_UnitDebuff,ebuhealin)

    if HealBot_Config.SetClassColourText==1 and HealBot_ClassColB[ebuName] then
      ebusr,ebusg,ebusb = HealBot_ClassColR[ebuName],HealBot_ClassColG[ebuName],HealBot_ClassColB[ebuName];
    elseif ebuHealBot_UnitDebuff then
      ebusr=HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin];
      ebusg=HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin];
      ebusb=HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin];
    else
      ebusr=HealBot_Config.btextenabledcolr[HealBot_Config.Current_Skin] or 0;
      ebusg=HealBot_Config.btextenabledcolg[HealBot_Config.Current_Skin] or 0;
      ebusb=HealBot_Config.btextenabledcolb[HealBot_Config.Current_Skin] or 0;
    end

    if ebumaxhlth<1 then ebuhlth=1 end
    if ebuhlth>ebumaxhlth then
       ebumaxhlth=HealBot_CorrectPetHealth(ebUnit,ebuhlth,ebumaxhlth,ebuName)
    end
  
    if HealBot_Config.UseFluidBars==0 then
	  if ebuUnitDead then
	    ebubar:SetValue(0)
	  else
        ebubar:SetValue(ebpct)
	  end
    else
      if HealBot_curUnitHealth[ebubar]~=ebpct then
        if ebuUnitDead then
	      ebubar:SetValue(0)
	    else
          HealBot_UnitBarUpdate[ebubar]=HealBot_curUnitHealth[ebubar]
	    end
      end
      HealBot_curUnitHealth[ebubar]=ebpct
    end
	
    ebuProcessThis=true
	ebufastenable=false
    if HealBot_Config.ProtectPvP==1 then
      if UnitIsPVP(ebUnit) and not UnitIsPVP("player") then ebuProcessThis=false; end
    end
    if not ebuUnitDead and not HealBot_PlayerDead and ebuProcessThis then
      if ebuHealBot_UnitDebuff and ebuUnit_BuffRange then
	    HealBot_UnitRangeSpell[ebUnit]=HealBot_dSpell
		ebufastenable=true
      elseif ebuHealBot_UnitBuff and ebuUnit_BuffRange then
	    HealBot_UnitRangeSpell[ebUnit]=HealBot_bSpell
		ebufastenable=true
	  elseif (ebuhlth<=(ebumaxhlth*HealBot_Config.AlertLevel) or HealBot_Aggro[ebuName] or HealBot_MyTargets[ebuName]) and ebuUnit_HealRange then
	    ebufastenable=true
	  end
	end
    if ebufastenable then
	  HealBot_UnitRange[ebUnit]=1
      ebusa = HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin];
	  HealBot_Enabled[ebuName]=true
      ebubar:SetStatusBarColor(ebur,ebug,ebub,HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
      ebubar2:SetStatusBarColor(ebur,ebug,ebub,HealBot_Config.BarcolaInHeal[HealBot_Config.Current_Skin]);
      HealBot_UnitRangeitr[ebUnit]=ebusr
      HealBot_UnitRangeitg[ebUnit]=ebusg
      HealBot_UnitRangeitb[ebUnit]=ebusb
      HealBot_UnitRangeotr[ebUnit]=HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin]
      HealBot_UnitRangeotg[ebUnit]=HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin]
      HealBot_UnitRangeotb[ebUnit]=HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin]
      if ebUnit==HealBot_Action_DisableTooltipUnit then
        HealBot_Action_TooltipUnit = ebUnit;
        HealBot_Action_DisableTooltipUnit = nil;
      end
      if ebUnit==HealBot_Action_TooltipUnit then
	    HealBot_Action_RefreshTooltip(ebUnit)
      end
	else
	  HealBot_Enabled[ebuName]=false
	  if HealBot_Config.SetClassColourText==0 then
        ebusr=HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin]
        ebusg=HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin]
        ebusb=HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin]
	  end
      if HealBot_RetHealBot_Ressing(ebuName) then
        if ebuUnitDead then
          ebusr=0.2
          ebusg=1.0
          ebusb=0.2
          ebusa=1
        else
          HealBot_UnsetHealBot_Ressing(ebuName)
		end
        HealBot_UnitRangeitr[ebUnit]=0.2
        HealBot_UnitRangeitg[ebUnit]=1
        HealBot_UnitRangeitb[ebUnit]=0.2
        HealBot_UnitRangeotr[ebUnit]=0.2
        HealBot_UnitRangeotg[ebUnit]=1
        HealBot_UnitRangeotb[ebUnit]=0.2
      elseif ebuUnitDead and ebuName~=HealBot_PlayerName then
        if HealBot_rSpell then
		  HealBot_UnitRangeSpell[ebUnit]=HealBot_rSpell
          if ebuUnit_BuffRange and not UnitIsGhost(ebUnit) then
            ebusr=0;
            ebusg=0;
            ebusb=0;
            ebusa=1;
          else
            ebusr=0.7;
            ebusg=0.7;
            ebusb=0.7;
            ebusa=1;
          end
          if not UnitIsGhost(ebUnit) then
          	HealBot_UnitRangeitr[ebUnit]=0
          	HealBot_UnitRangeitg[ebUnit]=0
          	HealBot_UnitRangeitb[ebUnit]=0
          else
          	HealBot_UnitRangeitr[ebUnit]=0.7
          	HealBot_UnitRangeitg[ebUnit]=0.7
          	HealBot_UnitRangeitb[ebUnit]=0.7
          end
          HealBot_UnitRangeotr[ebUnit]=0.7
          HealBot_UnitRangeotg[ebUnit]=0.7
          HealBot_UnitRangeotb[ebUnit]=0.7
		end
      else
        HealBot_UnitRangeitr[ebUnit]=ebusr
        HealBot_UnitRangeitg[ebUnit]=ebusg
        HealBot_UnitRangeitb[ebUnit]=ebusb
        HealBot_UnitRangeotr[ebUnit]=ebusr
        HealBot_UnitRangeotg[ebUnit]=ebusg
        HealBot_UnitRangeotb[ebUnit]=ebusb
        --ebua=HealBot_Config.bardisa[HealBot_Config.Current_Skin]
	  end
	  if UnitIsVisible(ebUnit) or HealBot_Config.NotVisibleDisable==0 then
        ebubar:SetStatusBarColor(ebur,ebug,ebub,ebua);
        ebubar2:SetStatusBarColor(ebur,ebug,ebub,ebua);
	  else
        ebubar:SetStatusBarColor(ebur,ebug,ebub,HealBot_Config.bardisa[HealBot_Config.Current_Skin]);
        ebubar2:SetStatusBarColor(ebur,ebug,ebub,HealBot_Config.bardisa[HealBot_Config.Current_Skin]);
	  end
	  if not HealBot_IsFighting and HealBot_Config.EnableHealthy==0 then
        if ebUnit==HealBot_Action_TooltipUnit then
          HealBot_Action_TooltipUnit = nil;
          HealBot_Action_DisableTooltipUnit = ebUnit;
        end
	    if ebUnit==HealBot_Action_DisableTooltipUnit then
	      HealBot_Tooltip_RefreshDisabledTooltip(ebUnit)
        end
	  end
	  HealBot_UnitRange[ebUnit]=HealBot_UnitInRange(HealBot_UnitRangeSpell[ebUnit], ebUnit)
    end
    HealBot_UnitRanger[ebUnit]=ebur
    HealBot_UnitRangeg[ebUnit]=ebug
    HealBot_UnitRangeb[ebUnit]=ebub
    HealBot_UnitRangea[ebUnit]=ebua
	HealBot_UnitRangeota[ebUnit]=ebusa
  elseif Delay_RecalcParty==0 then
    Delay_RecalcParty=3
  end
  
  ebubar.txt = getglobal(ebubar:GetName().."_text");
  ebtext=HealBot_Action_HBText(ebuhlth,ebumaxhlth,ebuName,ebUnit,ebuhealin)
  ebubar.txt:SetText(ebtext);
  if UnitIsVisible(ebUnit) or HealBot_Config.NotVisibleDisable==0 then
    ebubar.txt:SetTextColor(ebusr,ebusg,ebusb,ebusa);
  else
    ebubar.txt:SetTextColor(ebusr,ebusg,ebusb,HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin]);
  end

end

function HealBot_Action_HBText(hlth,maxhlth,Member_Name,unit,healin)
  btHBbarText=" "
  bttextlen = floor(5+(((HealBot_Config.bwidth[HealBot_Config.Current_Skin]*1.8)/HealBot_Config.btextheight[HealBot_Config.Current_Skin])-(HealBot_Config.btextheight[HealBot_Config.Current_Skin]/2)))-2
  if HealBot_Config.ShowClassOnBar==1 and UnitClass(unit) then
      if HealBot_Config.ShowClassOnBarWithName==1 then
        btname=UnitClass(unit)..":"..Member_Name;
      else
        btname=UnitClass(unit);
      end
  else
    btname=Member_Name;
  end

  if HealBot_Config.ShowHealthOnBar==1 and maxhlth then
    if HealBot_Config.BarHealthType==1 then
      if HealBot_Config.BarHealthIncHeals==1 then
	    healin = HealBot_RetHealsIn(Member_Name)
        bthlthdelta=(hlth+healin)-maxhlth;
      else
        bthlthdelta=hlth-maxhlth;
      end
      if bthlthdelta>0 then
        btHBbarText=btHBbarText.." +"..bthlthdelta;
      else
        btHBbarText=btHBbarText.."("..bthlthdelta..")";
      end
    else
      if HealBot_Config.BarHealthIncHeals==1 then
        healin = HealBot_RetHealsIn(Member_Name);
        btHBbarText=btHBbarText.."("..floor(((hlth+healin)/maxhlth)*100).."%)"
      else
        btHBbarText=btHBbarText.."("..floor((hlth/maxhlth)*100).."%)"
      end
    end
  end
	if HealBot_UnitIsOffline(unit) then
  	btname=HEALBOT_DISCONNECTED_TEXT.." "..btname;
  end	-- added by Diacono of Ursin
  if HealBot_Aggro[Member_Name] and HealBot_Config.ShowAggroText==1 then
    btname=">> "..btname.." <<"
  end
  bttextlen=bttextlen-strlen(btHBbarText)
  if bttextlen<1 then bttextlen=1; end
  if strlen(btname)>bttextlen then
    btHBbarText = string.sub(btname,1,bttextlen) .. '..'..btHBbarText;
  else
    btHBbarText = btname..btHBbarText;
  end
  return btHBbarText;
end

function HealBot_Action_RefreshButton(button, uName)
  if not button then return end
--  if type(button)~="table" then DEFAULT_CHAT_FRAME:AddMessage("***** "..type(button)) end
  HealBot_Action_EnableButton(button, uName)
  if HealBot_UnitName["target"] and HealBot_UnitName["target"]==uName and button.unit~="target" and UnitName("target") and UnitName("target")==uName and HealBot_Unit_Button["target"] then
    HealBot_Action_EnableButton(HealBot_Unit_Button["target"], uName)
  end
end

function HealBot_Action_ResetSkin()
local bwidth = HealBot_Config.bwidth[HealBot_Config.Current_Skin];
local bheight=HealBot_Config.bheight[HealBot_Config.Current_Skin];
local br=HealBot_Config.headbarcolr[HealBot_Config.Current_Skin];  
local bg=HealBot_Config.headbarcolg[HealBot_Config.Current_Skin];
local bb=HealBot_Config.headbarcolb[HealBot_Config.Current_Skin];
local ba=HealBot_Config.headbarcola[HealBot_Config.Current_Skin];
local sr=HealBot_Config.headtxtcolr[HealBot_Config.Current_Skin];  
local sg=HealBot_Config.headtxtcolg[HealBot_Config.Current_Skin];
local sb=HealBot_Config.headtxtcolb[HealBot_Config.Current_Skin];
local sa=HealBot_Config.headtxtcola[HealBot_Config.Current_Skin];
local btexture=HealBot_Config.btexture[HealBot_Config.Current_Skin];
local btextheight=HealBot_Config.btextheight[HealBot_Config.Current_Skin];
local b,bar,bar2,bar3,bar4,icon1,icon2,icon3,icon1t,icon2t,icon3t,barScale,h,hwidth,hheight

  HealBot_Tooltip:SetBackdropColor(0,0,0,HealBot_Config.ttalpha)
  
  for j=1,51 do
    b=getglobal("HealBot_Action_HealUnit"..j);
    bar = HealBot_Action_HealthBar(b);
    bar2 = HealBot_Action_HealthBar2(b);
    bar3 = HealBot_Action_HealthBar3(b);
	bar4 = HealBot_Action_HealthBar4(b)
    icon1 = getglobal(bar:GetName().."Icon1");
    icon2 = getglobal(bar:GetName().."Icon2");
    icon3 = getglobal(bar:GetName().."Icon3");
    icon1t = getglobal(bar:GetName().."Count1");
    icon1ta = getglobal(bar:GetName().."Count1a");
    icon2t = getglobal(bar:GetName().."Count2");
    icon2ta = getglobal(bar:GetName().."Count2a");
    icon3t = getglobal(bar:GetName().."Count3"); 
    icon3ta = getglobal(bar:GetName().."Count3a");
    HealBot_Panel_SetBarArrays(b)
    bar.txt = getglobal(bar:GetName().."_text");
    bar:SetHeight(bheight);
    bar:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..btexture);
    bar.txt:SetTextHeight(btextheight);
    barScale = bar:GetScale();
    bar:SetScale(barScale + 0.01);
    bar:SetScale(barScale);
    bar2:SetHeight(bheight);
    bar2:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..btexture);
    bar3:SetHeight(HealBot_Config.bar2size[HealBot_Config.Current_Skin]);
    bar3:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..btexture);
	if HealBot_Config.bar2size[HealBot_Config.Current_Skin]==0 then
	  bar4:SetHeight(3)
	else
      bar4:SetHeight(HealBot_Config.bar2size[HealBot_Config.Current_Skin]+1)
	end
	bar4:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..btexture)
	bar4:SetStatusBarColor(1,0,0,0.5)
	bar4:SetMinMaxValues(0,100)
	bar4:SetValue(0)
    b:SetHeight(bheight);  
    b:Enable();
	b.name="init"
    icon1:SetHeight(bheight-2);
    icon1:SetWidth(bheight-2);
    icon2:SetHeight(bheight-2);
    icon2:SetWidth(bheight-2);
    icon3:SetHeight(bheight-2);
    icon3:SetWidth(bheight-2);
	bar:SetMinMaxValues(0,100)
	bar2:SetMinMaxValues(0,100);
	bar3:SetMinMaxValues(0,100)
	bar2:SetValue(0);
    bar:SetStatusBarColor(0,1,0,HealBot_Config.bardisa[HealBot_Config.Current_Skin]);
    bar2:SetStatusBarColor(0,1,0,0);

    if HealBot_Config.HoTonBar==1 then
      HealBot_Panel_SetMultiColHoToffset(0)
      if HealBot_Config.HoTposBar==1 then
        icon1:ClearAllPoints();
        icon1:SetPoint("LEFT",b,"LEFT",1,0);
        icon2:ClearAllPoints();
        icon2:SetPoint("LEFT",icon1,"RIGHT",1,0);
        icon3:ClearAllPoints();
        icon3:SetPoint("LEFT",icon2,"RIGHT",1,0);
        icon1t:ClearAllPoints();
        icon1t:SetPoint("BOTTOMLEFT",icon1,"BOTTOMLEFT",0,0);
        icon1ta:ClearAllPoints();
        icon1ta:SetPoint("TOPRIGHT",icon1,"TOPRIGHT",5,0);
        icon2t:ClearAllPoints();
        icon2t:SetPoint("BOTTOMLEFT",icon2,"BOTTOMLEFT",0,0);
        icon2ta:ClearAllPoints();
        icon2ta:SetPoint("TOPRIGHT",icon2,"TOPRIGHT",5,0);
        icon3t:ClearAllPoints();
        icon3t:SetPoint("BOTTOMLEFT",icon3,"BOTTOMLEFT",0,0); 
        icon3ta:ClearAllPoints();
        icon3ta:SetPoint("TOPRIGHT",icon3,"TOPRIGHT",5,0);
      else
        icon1:ClearAllPoints();
        icon1:SetPoint("RIGHT",b,"RIGHT",-1,0);
        icon2:ClearAllPoints();
        icon2:SetPoint("RIGHT",icon1,"LEFT",-1,0);
        icon3:ClearAllPoints();
        icon3:SetPoint("RIGHT",icon2,"LEFT",-1,0);
        icon1t:ClearAllPoints();
        icon1t:SetPoint("BOTTOMRIGHT",icon1,"BOTTOMRIGHT",5,0);
        icon1ta:ClearAllPoints();
        icon1ta:SetPoint("TOPLEFT",icon1,"TOPLEFT",0,0);
        icon2t:ClearAllPoints();
        icon2t:SetPoint("BOTTOMRIGHT",icon2,"BOTTOMRIGHT",5,0);
        icon2ta:ClearAllPoints();
        icon2ta:SetPoint("TOPLEFT",icon2,"TOPLEFT",0,0);
        icon3t:ClearAllPoints();
        icon3t:SetPoint("BOTTOMRIGHT",icon3,"BOTTOMRIGHT",5,0); 
        icon3ta:ClearAllPoints();
        icon3ta:SetPoint("TOPLEFT",icon3,"TOPLEFT",0,0);
      end
    else
      HealBot_Panel_SetMultiColHoToffset(bheight*3)
      if HealBot_Config.HoTposBar==1 then
        icon1:ClearAllPoints();
        icon1:SetPoint("RIGHT",b,"LEFT",-1,0);
        icon2:ClearAllPoints();
        icon2:SetPoint("RIGHT",icon1,"LEFT",-2,0);
        icon3:ClearAllPoints();
        icon3:SetPoint("RIGHT",icon2,"LEFT",-2,0);
        icon1t:ClearAllPoints();
        icon1t:SetPoint("BOTTOMRIGHT",icon1,"BOTTOMRIGHT",5,0);
        icon1ta:ClearAllPoints();
        icon1ta:SetPoint("TOPLEFT",icon1,"TOPLEFT",0,0);
        icon2t:ClearAllPoints();
        icon2t:SetPoint("BOTTOMRIGHT",icon2,"BOTTOMRIGHT",5,0);
        icon2ta:ClearAllPoints();
        icon2ta:SetPoint("TOPLEFT",icon2,"TOPLEFT",0,0);
        icon3t:ClearAllPoints();
        icon3t:SetPoint("BOTTOMRIGHT",icon3,"BOTTOMRIGHT",5,0); 
        icon3ta:ClearAllPoints();
        icon3ta:SetPoint("TOPLEFT",icon3,"TOPLEFT",0,0);
      else
        icon1:ClearAllPoints();
        icon1:SetPoint("LEFT",b,"RIGHT",2,0);
        icon2:ClearAllPoints();
        icon2:SetPoint("LEFT",icon1,"RIGHT",2,0);
        icon3:ClearAllPoints();
        icon3:SetPoint("LEFT",icon2,"RIGHT",2,0);
        icon1t:ClearAllPoints();
        icon1t:SetPoint("BOTTOMLEFT",icon1,"BOTTOMLEFT",0,0);
        icon1ta:ClearAllPoints();
        icon1ta:SetPoint("TOPRIGHT",icon1,"TOPRIGHT",5,0);
        icon2t:ClearAllPoints();
        icon2t:SetPoint("BOTTOMLEFT",icon2,"BOTTOMLEFT",0,0);
        icon2ta:ClearAllPoints();
        icon2ta:SetPoint("TOPRIGHT",icon2,"TOPRIGHT",5,0);
        icon3t:ClearAllPoints();
        icon3t:SetPoint("BOTTOMLEFT",icon3,"BOTTOMLEFT",0,0); 
        icon3ta:ClearAllPoints();
        icon3ta:SetPoint("TOPRIGHT",icon3,"TOPRIGHT",5,0);
      end
    end

    if HealBot_Config.bar2size[HealBot_Config.Current_Skin]==0 then
      bar3:SetHeight(1);
      bar3:SetValue(0);
      bar3:SetStatusBarColor(0,0,0,0)
    end
	if HealBot_Config.ShowAggroBars==0 then
	  bar4:SetMinMaxValues(0,100)
	  bar4:SetValue(0)
	  bar4:SetStatusBarColor(0,0,0,0)
	end
  end
  for j=1,15 do
    h=getglobal("HealBot_Action_Header"..j);
    bar = HealBot_Action_HealthBar(h);
    hwidth = bwidth*HealBot_Config.headwidth[HealBot_Config.Current_Skin]
    hheight = ceil(bheight*0.8)
    HealBot_Panel_SetHeadArrays(h)
    h:SetHeight(hheight);
    h:SetWidth(hwidth);
    bar:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.headtexture[HealBot_Config.Current_Skin]);
    bar:SetMinMaxValues(0,100);
    bar:SetValue(100);
    bar:SetStatusBarColor(br,bg,bb,ba);
    bar:SetHeight(hheight);
    bar.txt = getglobal(bar:GetName().."_text");
    bar.txt:SetTextColor(sr,sg,sb,sa);
    h:Disable();
  end
  bar = HealBot_Action_HealthBar(HealBot_Action_OptionsButton);
  bar:SetStatusBarColor(0.1,0.1,0.4,0);
  bar.txt = getglobal(bar:GetName().."_text");
  bar.txt:SetTextColor(0.8,0.8,0.2,0.85);
  bar.txt:SetText(HEALBOT_ACTION_OPTIONS);
  HealBot_Action_SetAddHeight()
  Delay_RecalcParty=1;
  
  if not HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin] then HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin] then HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin] then HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin] then HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin] then HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin] then HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin] then HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin]=0.5 end
  if not HealBot_Config.btextcursecola[HealBot_Config.Current_Skin] then HealBot_Config.btextcursecola[HealBot_Config.Current_Skin]=0.5 end


  if HealBot_Options:IsVisible() then 
    HealBot_DiseaseColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_MagicColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_PoisonColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_CurseColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_CustomColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_EnTextColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_EnTextColorpickin:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_DisTextColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_DebTextColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_HeadBarColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.headtexture[HealBot_Config.Current_Skin]);
    HealBot_HeadTextColorpick:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.headtexture[HealBot_Config.Current_Skin]);
    HealBot_Buff1Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff2Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff3Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff4Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff5Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff6Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff7Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff8Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_Buff9Colour:SetStatusBarTexture("Interface\\AddOns\\HealBot\\images\\bar"..HealBot_Config.btexture[HealBot_Config.Current_Skin]);
    HealBot_SetSkinColours()
  end
end

local rName=nil
local rbsir=0
local rUnit=nil
local rButton=nil
function HealBot_Action_RefreshButtons(unit)
  if unit then
    HealBot_Action_RefreshButton(HealBot_Unit_Button[unit], UnitName(unit))
  else
    if HealBot_ButtonArray==1 then
      for rUnit,rButton in pairs(HealBot_ButtonArray1) do
	    HealBot_Action_CheckRange(rUnit, rButton)
      end
	  HealBot_ButtonArray=2
    elseif HealBot_ButtonArray==2 then
      for rUnit,rButton in pairs(HealBot_ButtonArray2) do
	    HealBot_Action_CheckRange(rUnit, rButton)
      end
	  HealBot_ButtonArray=1
	end
  end
end

function HealBot_Action_CheckRange(unit, button)
  if not HealBot_UnitStatus[unit] then return end
  if HealBot_UnitStatus[unit]>0 then
    rbsir=HealBot_UnitInRange(HealBot_UnitRangeSpell[unit], unit)
    if HealBot_UnitRange[unit]==-2 then
	  HealBot_Action_RefreshButton(button, UnitName(unit))
	elseif rbsir~=HealBot_UnitRange[unit] then
	  ebubar = HealBot_Unit_Bar1[unit]
	  ebubar.txt=getglobal(ebubar:GetName().."_text");
      HealBot_UnitRange[unit]=rbsir
	  if rbsir==1 and not HealBot_PlayerDead then
        ebubar:SetStatusBarColor(HealBot_UnitRanger[unit],HealBot_UnitRangeg[unit],HealBot_UnitRangeb[unit],HealBot_Config.Barcola[HealBot_Config.Current_Skin])
        ebubar.txt:SetTextColor(HealBot_UnitRangeitr[unit],HealBot_UnitRangeitg[unit],HealBot_UnitRangeitb[unit],HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]);
	  elseif rbsir==0 or HealBot_Config.NotVisibleDisable==0 then
	    --ebubar:SetStatusBarColor(HealBot_UnitRanger[unit],HealBot_UnitRangeg[unit],HealBot_UnitRangeb[unit],HealBot_Config.bardisa[HealBot_Config.Current_Skin])
        ebubar:SetStatusBarColor(HealBot_UnitRanger[unit],HealBot_UnitRangeg[unit],HealBot_UnitRangeb[unit],HealBot_UnitRangea[unit])
        ebubar.txt:SetTextColor(HealBot_UnitRangeotr[unit],HealBot_UnitRangeotg[unit],HealBot_UnitRangeotb[unit],HealBot_UnitRangeota[unit]);
	  else
		ebubar:SetStatusBarColor(HealBot_UnitRanger[unit],HealBot_UnitRangeg[unit],HealBot_UnitRangeb[unit],HealBot_Config.bardisa[HealBot_Config.Current_Skin])
        ebubar.txt:SetTextColor(HealBot_UnitRangeotr[unit],HealBot_UnitRangeotg[unit],HealBot_UnitRangeotb[unit],HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin]);
      end
    end
  end
end

local HBid=nil
function HealBot_Action_ResetUnitStatus(unit)
  if unit then
    HealBot_UnitStatus[unit]=1;
    HealBot_UnitRange[unit]=-2
  else
    for unit,_ in pairs(HealBot_Unit_Button) do
      HealBot_UnitStatus[unit]=1;
      HealBot_UnitRange[unit]=-2
    end
  end
end

function HealBot_Action_ResetActiveUnitStatus()
  for unit,_ in pairs(HealBot_Unit_Button) do
    if HealBot_UnitStatus[unit]>0 or UnitHealth(unit)<2 then
	  HealBot_UnitRange[unit]=-2
	end
  end
end

local shb=nil
local shbar=nil
local uTargetB=nil
function HealBot_Action_SetHealButton(index,unit,Member_Name,isTarget)

  if UnitClass(unit) then
	  if not HealBot_Unit_Button[unit] then
	    if not HealBot_ButtonStore[1] then
          return nil
		else
          shb=HealBot_ButtonStore[1]
	      table.remove(HealBot_ButtonStore,1)
	      HealBot_Unit_Button[unit]="init"
		end
	  else
	    shb=HealBot_Unit_Button[unit]
	  end
      if not HealBot_ClassColR[Member_Name] then
        HealBot_ClassColR[Member_Name],HealBot_ClassColG[Member_Name],HealBot_ClassColB[Member_Name] = HealBot_Action_ClassColour(unit);
	    HealBot_UnitID[Member_Name]="init"
		HealBot_Unit_Button[unit]="init"
		if not HealBot_UnitSpec[Member_Name] then
		  HealBot_UnitSpec[Member_Name] = " "
		end
      end
	  if HealBot_UnitID[Member_Name]~=unit then
        HealBot_CheckAllBuffs(unit)
        HealBot_CheckAllDebuffs(unit)
	    HealBot_UnitID[Member_Name]=unit
	  end
      if HealBot_Unit_Button[unit]~=shb then
	    shb.unit=unit
		shb:SetAttribute("unit", unit);
		if not shb.index or HealBot_Config.FastAttrib==0 then 
		  HealBot_Action_SetAllButtonAttribs(shb,"Enabled")
		else
          HealBot_Action_SetMacroButtonAttribs(shb)
		end
	    shb.index=index
		shb.name=Member_Name
        HealBot_Unit_Button[unit]=shb
        HealBot_UnitStatus[unit]=9
		HealBot_Unit_Bar1[unit]=HealBot_Action_HealthBar(shb)
        HealBot_Unit_Bar2[unit]=HealBot_Action_HealthBar2(shb)
        HealBot_Unit_Bar3[unit]=HealBot_Action_HealthBar3(shb)
        HealBot_Unit_Bar4[unit]=HealBot_Action_HealthBar4(shb)
	    shbar=HealBot_Unit_Bar1[unit]
  	    HealBot_UnitBarUpdate[shbar]=100
		HealBot_curUnitHealth[shbar]=100
		HealBot_UnitRangeSpell[unit]=HealBot_hSpell
	  elseif Member_Name~=shb.name then
	    shb.name=Member_Name
        HealBot_UnitStatus[unit]=9
      end
  else
    return nil
  end
  HealBot_TrackBars[shb]=nil
  return shb
end

function HealBot_Action_SetTargetHealButton(unit,Member_Name)
  if UnitClass(unit) then
    shb=getglobal("HealBot_Action_HealUnit51");
    if not HealBot_ClassColR[Member_Name] then
      HealBot_ClassColR[Member_Name],HealBot_ClassColG[Member_Name],HealBot_ClassColB[Member_Name] = HealBot_Action_ClassColour(unit);
	  HealBot_Unit_Button[unit]="init"
	  if not HealBot_UnitSpec[Member_Name] then
		HealBot_UnitSpec[Member_Name] = " "
      end
    end
    if HealBot_Unit_Button[unit]~=shb then
	  shb.unit=unit
  	  shb.index=51
	  shb.name=Member_Name
      shb:SetAttribute("unit", unit);
      HealBot_Unit_Button[unit]=shb
      HealBot_UnitStatus[unit]=9
	  HealBot_Unit_Bar1[unit]=HealBot_Action_HealthBar(shb)
      HealBot_Unit_Bar2[unit]=HealBot_Action_HealthBar2(shb)
      HealBot_Unit_Bar3[unit]=HealBot_Action_HealthBar3(shb)
      HealBot_Unit_Bar4[unit]=HealBot_Action_HealthBar4(shb)
	  shbar=HealBot_Unit_Bar1[unit]
  	  HealBot_UnitBarUpdate[shbar]=100
	  HealBot_curUnitHealth[shbar]=100
	  HealBot_UnitRangeSpell[unit]=HealBot_hSpell
	elseif Member_Name~=shb.name then
      HealBot_CheckAllBuffs(unit)
      HealBot_CheckAllDebuffs(unit)
	  shb.name=Member_Name
      HealBot_UnitStatus[unit]=9
    end
  else
    return nil
  end
  HealBot_TrackBars[shb]=nil
  return shb
end

function HealBot_Action_rmTargetButton(unit)
  HealBot_Action_InsButtonStore(uTargetB)
  uTargetB:Hide()
end

local HealBotButtonMacroAttribs={}
function HealBot_Action_SetAllAttribs()
    HealBot_AddDebug("In HealBot_Action_SetAllAttribs")
    for j=1,50 do
	  b=getglobal("HealBot_Action_HealUnit"..j)
	  b.index=nil
	end
    for x,_ in pairs(HealBot_UnitID) do
      HealBot_UnitID[x]=nil;
    end
    for x,_ in pairs(HealBotButtonMacroAttribs) do
      HealBotButtonMacroAttribs[x]=nil;
    end
    Delay_RecalcParty=1
end

function HealBot_Action_SetAllBars()
  HB_Action_Timer1 = 2000
  HealBot_Action_ResethbInitButtons()
  for j=1,51 do
    b=getglobal("HealBot_Action_HealUnit"..j)
    HealBot_Panel_SetBarArrays(b)
	b:Hide()
  end
  for unit,_ in pairs(HealBot_Unit_Button) do
    HealBot_Unit_Button[unit]=nil
  end 
end

local HB_button,HB_prefix=nil
local HB_combo_prefix=nil
local SpellTxt=nil
local lowerTarget="target"
local lowerAssist="assist"
local lowerFocus="focus"
local saSpellID=nil
local HealBot_Keys_List = {"","Shift","Ctrl","Alt"}
function HealBot_Action_SetAllButtonAttribs(button,status)
  for j=1,5 do
    if j==1 then HB_button="Left";
    elseif j==2 then HB_button="Right";
    elseif j==3 then HB_button="Middle";
    elseif j==4 then HB_button="Button4";
    elseif j==5 then HB_button="Button5";
    end
    
    for i=1, getn(HealBot_Keys_List), 1 do
	  HealBot_Action_SetButtonAttrib(button,HB_button,HealBot_Keys_List[i],status,j)
    end
  end
end

function HealBot_Action_SetMacroButtonAttribs(button)
  for prefix,mName in pairs(HealBotButtonMacroAttribs) do
    HealBot_Action_SetMacroButtonAttrib(button,prefix,mName)
  end
end

local mUnit=nil
local mText=nil
local mId=nil
function HealBot_Action_SetMacroButtonAttrib(button,prefix,mName)
  if strlen(prefix)>1 then
    HB_prefix=strsub(prefix,1,strlen(prefix)-1)
    j=strsub(prefix,strlen(prefix),1)
  else
    HB_prefix=""
	j=prefix
  end
  mId=GetMacroIndexByName(mName)
  if mId ~= 0 then
    _,_,mText=GetMacroInfo(mId)
    mUnit = button.unit
--    HealBot_AddDebug("Set Macro "..mName.." on unit "..mUnit.." prefix="..prefix)
    mText=string.gsub(mText,"hbtarget",mUnit)
    button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
    button:SetAttribute(HB_prefix.."type"..j,"macro")
    button:SetAttribute(HB_prefix.."macrotext"..j, mText)
  else
    HealBot_Action_SetAllButtonAttribs(button,"Enabled")
  end
end

function HealBot_Action_SetButtonAttrib(button,bbutton,bkey,status,j)
 
      if strlen(bkey)>1 then
        HB_prefix = strlower(bkey).."-"
      else
        HB_prefix = "";
      end
      HB_combo_prefix = bkey..bbutton;
      if status=="Enabled" then
        SpellTxt = HealBot_Action_AttribSpellPattern(HB_combo_prefix)
      elseif status=="Disabled" then
        SpellTxt = HealBot_Action_AttribDisSpellPattern(HB_combo_prefix)
      else
        SpellTxt=nil;
      end
      if SpellTxt then
        if strlower(SpellTxt)==strlower(HEALBOT_DISABLED_TARGET) then
          button:SetAttribute(HB_prefix.."helpbutton"..j, "target"..j);
		  button:SetAttribute(HB_prefix.."type"..j, "target")
          button:SetAttribute(HB_prefix.."type-target"..j, lowerTarget)
        elseif strlower(SpellTxt)==strlower(HEALBOT_FOCUS) then
          button:SetAttribute(HB_prefix.."helpbutton"..j, "focus"..j);
		  button:SetAttribute(HB_prefix.."type"..j, "focus")
          button:SetAttribute(HB_prefix.."type-focus"..j, lowerFocus)
        elseif strlower(SpellTxt)==strlower(HEALBOT_ASSIST) then
          button:SetAttribute(HB_prefix.."helpbutton"..j, "assist"..j);
		  button:SetAttribute(HB_prefix.."type"..j, "assist")
          button:SetAttribute(HB_prefix.."type-assist"..j, lowerAssist)
        else
          saSpellID=HealBot_GetSpellId(SpellTxt)
          if saSpellID then
            button:SetAttribute(HB_prefix.."helpbutton"..j, "heal"..j);
            button:SetAttribute(HB_prefix.."type-heal"..j, "spell");
            button:SetAttribute(HB_prefix.."spell-heal"..j, SpellTxt);
	      else
	        mId=GetMacroIndexByName(SpellTxt)
			if mId ~= 0 then
               _,_,mText=GetMacroInfo(mId)
              mUnit = button.unit
              mText=string.gsub(mText,"hbtarget",mUnit)
              button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
              button:SetAttribute(HB_prefix.."type"..j,"macro")
              button:SetAttribute(HB_prefix.."macrotext"..j, mText)
			  if status=="Enabled" then
			    HealBotButtonMacroAttribs[HB_prefix..j]=SpellTxt
			  end
            else
              button:SetAttribute(HB_prefix.."helpbutton"..j, "item"..j);
              button:SetAttribute(HB_prefix.."type-item"..j, "item");
              button:SetAttribute(HB_prefix.."item-item"..j, SpellTxt);
            end
		  end
        end
      else
        button:SetAttribute(HB_prefix.."helpbutton"..j, nil);
      end
end

local combos=nil
function HealBot_Action_AttribSpellPattern(HB_combo_prefix)
  combos = HealBot_Config.EnabledKeyCombo
  if not combos then return nil end
  return combos[HB_combo_prefix]
end

function HealBot_Action_AttribDisSpellPattern(HB_combo_prefix)
  combos = HealBot_Config.DisabledKeyCombo
  if not combos then return nil end
  return combos[HB_combo_prefix]
end

local hbInitButtons=false

function HealBot_Action_ResethbInitButtons()
  hbInitButtons=false
  for x,_ in pairs(HealBot_ButtonStore) do
    HealBot_ButtonStore[x]=nil;
  end
end

local uCnt=0
local tName=nil
function HealBot_Action_PartyChanged(HealBot_PreCombat)
  if HealBot_Config.DisableHealBot==1 then return end
  if not HealBot_IsFighting and not HealBot_FrameMoving then

	for unit,_ in pairs(HealBot_ResetBars) do
	  if HealBot_Unit_Button[unit] then HealBot_Unit_Button[unit]=nil end
	  HealBot_ResetBars[unit]=nil
	end 
	
	for unit,button in pairs(HealBot_Unit_Button) do
	  HealBot_TrackBars[button]=unit
	end 
	
    if not hbInitButtons then
      for j=1,50 do
        b=getglobal("HealBot_Action_HealUnit"..j);
	    table.insert(HealBot_ButtonStore,b);
      end
      hbInitButtons=true
    end
    if HealBot_PreCombat then 
      HealBot_IsFighting=true;
    end
  
    if HealBot_Config.ShowHeader[HealBot_Config.Current_Skin]==1 then
	  HealBot_Panel_PartyChanged(true)
	else
	  HealBot_Panel_PartyChanged(false)
	end
	uCnt=0
	HealBot_ButtonArray=1
    for x,_ in pairs(HealBot_ButtonArray1) do
      HealBot_ButtonArray1[x]=nil;
    end
    for x,_ in pairs(HealBot_ButtonArray2) do
      HealBot_ButtonArray2[x]=nil;
    end
	
	for unit,button in pairs(HealBot_Unit_Button) do
	  uCnt=uCnt+1
	    b=HealBot_Unit_Button[unit]
        if HealBot_Config.bar2size[HealBot_Config.Current_Skin]>0 then HealBot_Action_RefreshBar3(unit) end
		if HealBot_ButtonArray==1 then
		  HealBot_ButtonArray1[unit]=HealBot_Unit_Button[unit]
		  HealBot_ButtonArray=2
		else
 		  HealBot_ButtonArray2[unit]=HealBot_Unit_Button[unit]
		  HealBot_ButtonArray=1
		end
		if HealBot_UnitStatus[unit]==9 then
          HealBot_Action_ResetUnitStatus(unit)
		end
		if uCnt==1 then
		  HealBot_SmallArray=unit
		end 
	end
	if uCnt==1 then
	  HealBot_ButtonArray2[HealBot_SmallArray]=HealBot_Unit_Button[HealBot_SmallArray]
	end

	for button,unit in pairs(HealBot_TrackBars) do
	  if not HealBot_Unit_Button[unit] or HealBot_Unit_Button[unit]==button then
		if UnitName(unit) then
	      Delay_RecalcParty=3
		  HealBot_ResetBars[unit]=true
--		  HealBot_AddDebug("removed bar - set Delay_RecalcParty=2 : unit="..unit)
		else
		  HealBot_Unit_Button[unit]=nil
		end
	  end
	  HealBot_Action_InsButtonStore(button)
--	  HealBot_AddDebug("removed bar : unit="..unit)
	  HealBot_TrackBars[button]=nil
	end
  else
    Delay_RecalcParty=3
  end
end

function HealBot_Action_InsButtonStore(b)
  table.insert(HealBot_ButtonStore,b)
  HealBot_HoT_RemoveIconButton(b)
  if b.index then b.index=nil end
  HealBot_Panel_SetBarArrays(b)
end

function HealBot_Action_Reset()
  HealBot_Config.AutoClose=0
  HealBot_Config.PanelAnchorY=-1
  HealBot_Config.PanelAnchorX=-1
  HealBot_Action:ClearAllPoints();
  HealBot_Action:SetPoint("CENTER","UIParent","CENTER",0,0);
  HealBot_Action_PartyChanged()
  if HealBot_Config.DisableHealBot==0 then
    HealBot_Action:Show()
  else
    HealBot_Action:Hide()
  end
end

function HealBot_Action_ClassColour(unit)
  _,class=UnitClass(unit)
  if class ~= nil then
  	if strsub(class,1,4)=="DRUI" then
    	return 1.0,0.49,0.04
  	elseif strsub(class,1,4)=="HUNT" then
   		return 0.67,0.83,0.45
  	elseif strsub(class,1,4)=="MAGE" then
    	return 0.41,0.8,0.94
  	elseif strsub(class,1,4)=="PALA" then
    	return 0.96,0.55,0.73
  	elseif strsub(class,1,4)=="PRIE" then
    	return 1.0,1.0,1.0
  	elseif strsub(class,1,4)=="ROGU" then
    	return 1.0,0.96,0.41
  	elseif strsub(class,1,4)=="SHAM" then
    	return 0.14,0.35,1.0
  	elseif strsub(class,1,4)=="WARL" then
    	return 0.58,0.51,0.79
  	end
  end
  return 0.78,0.61,0.43  -- WARR
end

function HealBot_Action_ShowTooltip(this)
  if HealBot_Config.ShowTooltip==0 then return end
  HealBot_Action_TooltipUnit = this.unit;
  HealBot_Action_DisableTooltipUnit = nil;
  HealBot_Action_RefreshTooltip(this.unit);
end

function HealBot_Action_ShowDisabledTooltip(this)
  if HealBot_Config.ShowTooltip==0 then return end
  HealBot_Action_TooltipUnit = nil;
  HealBot_Action_DisableTooltipUnit = this.unit;
  HealBot_Tooltip_RefreshDisabledTooltip(this.unit);
end

function HealBot_Action_HideTooltip(this)
  HealBot_Action_TooltipUnit = nil;
  HealBot_Action_DisableTooltipUnit = nil;
  HealBot_Tooltip:Hide();
end

function HealBot_Action_Refresh(unit)
  if HealBot_Config.DisableHealBot==1 then return end
  if HealBot_PlayerDead then
    if HealBot_Config.AutoClose==1 and HealBot_Config.ActionVisible~=0 and not HealBot_IsFighting then
      HideUIPanel(HealBot_Action); 
    else
      HealBot_Action_RefreshButtons(unit);
    end
    return;
  end
  HealBot_Action_RefreshButtons(unit);
  if not HealBot_IsFighting then
    if HealBot_Config.ActionVisible==0 then
      if HealBot_Action_ShouldHealSome(unit) then
        ShowUIPanel(HealBot_Action)
      end
    elseif HealBot_Config.AutoClose==1 then 
      if not HealBot_Action_ShouldHealSome(unit) then
        HideUIPanel(HealBot_Action);
      end
    end
  end
end

local press=nil
function HealBot_Action_SpellPattern(button)
  combos = HealBot_Config.EnabledKeyCombo
  if not combos then return nil end
  press = button;
  if IsAltKeyDown() then press = "Alt"..press end
  if IsControlKeyDown() then press = "Ctrl"..press end
  if IsShiftKeyDown() then press = "Shift"..press end
  return combos[press]
end

--------------------------------------------------------------------------------------------------
-- Widget_OnFoo functions
--------------------------------------------------------------------------------------------------

local hueuName=nil
function HealBot_Action_HealUnit_OnEnter(this)
  if not this.unit then return; end
  hueuName=UnitName(this.unit);
  if HealBot_IsFighting then
    HealBot_Action_ShowTooltip(this);
  elseif HealBot_Config.UseTargetCombatStatus==1 and UnitAffectingCombat(this.unit)==1 then
    HealBot_Action_ShowTooltip(this);
  elseif HealBot_Enabled[hueuName] or HealBot_Config.EnableHealthy==1 then 
    HealBot_Action_ShowTooltip(this);
  else
    if not HealBot_PlayerDead then
      HealBot_Action_ShowDisabledTooltip(this);
    end
  end
end

function HealBot_Action_HealUnit_OnLeave(this)
  HealBot_Action_HideTooltip(this);
end


function HealBot_Action_OptionsButton_OnClick(this)
    HealBot_TogglePanel(HealBot_Options);
end

function HealBot_CT_RaidAssist()
--  if (type(CT_RA_MemberFrame_OnClick)=="function") then
--    HealBot_CT_RA_CustomOnClickFunction_Old = CT_RA_CustomOnClickFunction;
--    CT_RA_CustomOnClickFunction = HealBot_CT_RA_CustomOnClickFunction;
--  end
end



--------------------------------------------------------------------------------------------------
-- Frame_OnFoo functions
--------------------------------------------------------------------------------------------------

function HealBot_Action_OnLoad(this)
--  HealBot_CT_RaidAssist();
end

local HealBot_Action_Timer1 = 0
local haouCnt=false

function HealBot_Action_Set_Timers(override)
  if HealBot_Config.DisableHealBot==0 and not override and HealBot_Config.UseFluidBars==1 then
    HB_Action_Timer1 = 0.012
  elseif HealBot_Config.ShowAggroBars==1 and HealBot_Config.ShowAggro==1 then
    HB_Action_Timer1 = 0.025
  else
    HB_Action_Timer1 = 2000
  end
end

function HealBot_Action_OnUpdate(this,arg1)
  HealBot_Action_Timer1 = HealBot_Action_Timer1+arg1
  if HealBot_Action_Timer1>HB_Action_Timer1 then
    HealBot_Action_Timer1 = 0
    for ebubar,value in pairs(HealBot_UnitBarUpdate) do 
	  if value>HealBot_curUnitHealth[ebubar] then
	    if value-HealBot_Config.BarFreq<=HealBot_curUnitHealth[ebubar] then
		  HealBot_UnitBarUpdate[ebubar]=HealBot_curUnitHealth[ebubar]
		else
		  HealBot_UnitBarUpdate[ebubar]=value-HealBot_Config.BarFreq
		end
	  elseif value+HealBot_Config.BarFreq>=HealBot_curUnitHealth[ebubar] then
		HealBot_UnitBarUpdate[ebubar]=HealBot_curUnitHealth[ebubar]
      else
		HealBot_UnitBarUpdate[ebubar]=value+HealBot_Config.BarFreq
	  end
	  ebubar:SetValue(HealBot_UnitBarUpdate[ebubar])
	  if HealBot_UnitBarUpdate[ebubar]==HealBot_curUnitHealth[ebubar] then
	    HealBot_UnitBarUpdate[ebubar]=nil
	  end
	end
	haouCnt=false
	for _,bar4 in pairs(HealBot_AggroBar4) do
	  bar4:SetStatusBarColor(1,HealBot_AggroBarA,HealBot_AggroBarA,1)
	  haouCnt=true
	end
	if haouCnt then
      if HealBot_AggroBarAup then
	    if HealBot_AggroBarA>=0.9 then
	      HealBot_AggroBarAup=false
	      HealBot_AggroBarA=HealBot_AggroBarA-0.05
        else
	      HealBot_AggroBarA=HealBot_AggroBarA+0.05
	    end
	  else
	    if HealBot_AggroBarA<=0.05 then
	      HealBot_AggroBarAup=true
	      HealBot_AggroBarA=HealBot_AggroBarA+0.05
	    else
	      HealBot_AggroBarA=HealBot_AggroBarA-0.05
	    end
	  end
	elseif not HealBot_AggroBarA~=0.1 then
      HealBot_AggroBarA=0.1
      HealBot_AggroBarAup=true
	end
  end
end

function HealBot_Action_OnShow(this)
  if HealBot_Config.PanelSounds==1 then
    PlaySound("igAbilityOpen");
  end
  HealBot_Config.ActionVisible = 1
  HealBot_Action:SetBackdropColor(
    HealBot_Config.backcolr[HealBot_Config.Current_Skin],
    HealBot_Config.backcolg[HealBot_Config.Current_Skin],
    HealBot_Config.backcolb[HealBot_Config.Current_Skin], 
    HealBot_Config.backcola[HealBot_Config.Current_Skin]);
  HealBot_Action:SetBackdropBorderColor(
    HealBot_Config.borcolr[HealBot_Config.Current_Skin],
    HealBot_Config.borcolg[HealBot_Config.Current_Skin],
    HealBot_Config.borcolb[HealBot_Config.Current_Skin],
    HealBot_Config.borcola[HealBot_Config.Current_Skin]);
end

function HealBot_Action_OnHide(this)
  HealBot_StopMoving(this);
  HealBot_Config.ActionVisible = 0
end

function HealBot_Action_OnMouseDown(this,button)
  if button~="RightButton" then
    if HealBot_Config.ActionLocked==0 then
      HealBot_StartMoving(this);
    end
  end
end

function HealBot_Action_OnMouseUp(this,button)
  if button~="RightButton" then
    HealBot_StopMoving(this);
  elseif not HealBot_IsFighting and HealBot_Config.RightButtonOptions~=0 then
    HealBot_Action_OptionsButton_OnClick();
  end
end

function HealBot_Action_OnDragStart(this,button)
  if HealBot_Config.ActionLocked==0 then
    HealBot_FrameMoving=true
    HealBot_StartMoving(this);
  end
end

function HealBot_Action_OnDragStop(this)
  HealBot_StopMoving(this);
  HealBot_FrameMoving=nil
end

local usedSmartCast=nil
local pcspell=nil
local pcuName=nil
local pcuSpellID=nil
local ModKey=nil
local abutton=nil
local aj=nil
function HealBot_Action_PreClick(self,button)
 usedSmartCast=false;
 ModKey=""
 pcuName=UnitName(self.unit)
 if IsControlKeyDown() then ModKey="Ctrl"
 elseif IsAltKeyDown() then ModKey="Alt"
 elseif IsShiftKeyDown() then ModKey="Shift" 
 end
 if button=="LeftButton" then 
   abutton="Left"
   aj=1
 elseif button=="RightButton" then 
   abutton="Right"
   aj=2
 elseif button=="MiddleButton" then 
   abutton="Middle"
   aj=3
 elseif button=="Button4" then 
   abutton="Button4"
   aj=4
 elseif button=="Button5" then 
   abutton="Button5"
   aj=5
 end
 if self.unit=="target" then
   if button=="RightButton" then
     if HealBot_UnitID[pcuName] then
       HealBot_Panel_ToggelHealTarget(pcuName)
	   Delay_RecalcParty=3
	   if HealBot_Config.ShowTooltip==1 then HealBot_Action_RefreshTargetTooltip(pcuName, self.unit) end
	 end
   elseif button=="LeftButton" and HealBot_Config.SmartCast==1 and not IsModifierKeyDown() then
    HealBot_Action_UseSmartCast(self)
   end
 elseif IsControlKeyDown() and IsAltKeyDown() and (button=="LeftButton" or button=="MiddleButton" or button=="RightButton") then
   if button=="LeftButton" then
     if HealBot_MyTargets[pcuName] then
       HealBot_MyTargets[pcuName]=nil
     else
       HealBot_MyTargets[pcuName]=true
     end
     HealBot_Action_ResetUnitStatus(HealBot_UnitID[pcuName])
   elseif button=="RightButton" then
     HealBot_Panel_ToggelHealTarget(pcuName)
	 Delay_RecalcParty=3
   elseif pcuName~=HealBot_PlayerName then
     HealBot_Panel_AddBlackList(pcuName)
	 Delay_RecalcParty=3
   end
 elseif not HealBot_IsFighting then
  if HealBot_Config.UseTargetCombatStatus==1 then
    if UnitAffectingCombat(self.unit)==1 then return; end
  end
  if HealBot_Config.ProtectPvP==1 then
    if UnitIsPVP(self.unit) and not UnitIsPVP("player") then 
	  HealBot_Action_SetButtonAttrib(self,abutton,ModKey,"nil",aj)
      usedSmartCast=true;
    end
  end
  if button=="LeftButton" and HealBot_Config.SmartCast==1 and not IsModifierKeyDown() then
    HealBot_Action_UseSmartCast(self)
  end
  if not HealBot_Enabled[pcuName] and HealBot_Config.EnableHealthy==0 and not usedSmartCast then
    HealBot_Action_SetButtonAttrib(self,abutton,ModKey,"Disabled",aj)
    usedSmartCast=true;
  end
 end
end

function HealBot_Action_UseSmartCast(bp)
    pcspell=HealBot_Action_SmartCast(bp.unit);
    if pcspell then
      pcuSpellID=HealBot_GetSpellId(pcspell)
      if pcuSpellID then
	    if HealBot_UnitInRange(pcspell, bp.unit)==1 or pcuName==HealBot_PlayerName then
          bp:SetAttribute("helpbutton1", "heal1");
          bp:SetAttribute("type-heal1", "spell");
          bp:SetAttribute("spell-heal1", pcspell);
	    end
      else
        mId=GetMacroIndexByName(pcspell)
	    if mId ~= 0 then
          _,_,mText=GetMacroInfo(mId)
          mUnit = bp.unit
          mText=string.gsub(mText,"hbtarget",mUnit)
          bp:SetAttribute("type1","macro")
          bp:SetAttribute("macrotext1", mText)
        else
	      bp:SetAttribute("helpbutton1", "item1");
          bp:SetAttribute("type-item1", "item");
          bp:SetAttribute("item-item1", pcspell);
        end
      end
	  usedSmartCast=true;
	end
end


function HealBot_Action_PostClick(self,button)
  if usedSmartCast then
    if self.unit=="target" then
      if aj==1 then
        self:SetAttribute(HB_prefix.."helpbutton"..aj, "target"..aj);
		self:SetAttribute(HB_prefix.."type"..aj, "target")
        self:SetAttribute(HB_prefix.."type-target"..aj, lowerTarget)
	  end
	else
	  HealBot_Action_SetButtonAttrib(self,abutton,ModKey,"Enabled",aj)
    end
  end
end

function HealBot_Action_RetMyTarget(uName)
  return HealBot_MyTargets[uName]
end

local scspell=nil
local scuName=nil
local schealin=nil
local schlth=nil
local scmaxhlth=nil
local schdelta=nil
local scrspell=nil
function HealBot_Action_SmartCast(unit)
  scuName=UnitName(unit);
  scspell=nil
  scrspell=HealBot_hSpell
  if HealBot_PlayerDead or not scuName then return nil; end
  
  if HealBot_Config.SmartCastRes==1 and UnitIsDead(unit) and not UnitIsGhost(unit) then
   scspell=SmartCast_Res;
   scrspell=HealBot_rSpell
  elseif HealBot_UnitDebuff[scuName] and HealBot_Config.SmartCastDebuff==1 then
    scspell=HealBot_DebuffSpell[HealBot_UnitDebuff[scuName]];
	scrspell=HealBot_dSpell
  elseif HealBot_UnitBuff[scuName] and HealBot_Config.SmartCastBuff==1 then
    scspell=HealBot_UnitBuff[scuName];
	scrspell=HealBot_bSpell
  elseif HealBot_Config.SmartCastHeal==1 then
	schealin = HealBot_RetHealsIn(scuName);
    schlth, scmaxhlth = HealBot_UnitHealth(unit);
    schdelta = scmaxhlth-(schlth+schealin);
    if schdelta>200 then
      scspell=HealBot_SmartCast(unit,schdelta)
    end
  end
  if scspell and scuName~=HealBot_PlayerName then
    if HealBot_UnitInRange(scrspell, unit)~=1 then return nil; end
  end
  return scspell;
end

function HealBot_Action_RetHealBot_ClassCol(uName)
  return HealBot_ClassColR[uName],HealBot_ClassColG[uName],HealBot_ClassColB[uName]
end

function HealBot_Action_ClearHealsIn(Member_Name)
  if Member_Name=="target" then
    HealBot_Unit_Button["target"]=nil
	if not HealBot_UnitID[HealBot_UnitName["target"]] then
	  Member_Name=HealBot_UnitName["target"]
	end
	HealBot_UnitName["target"]=nil
  end
  if HealBot_ClassColR[Member_Name] then
    HealBot_Enabled[Member_Name]=nil
    HealBot_ClassColR[Member_Name]=nil
    HealBot_ClassColG[Member_Name]=nil
    HealBot_ClassColB[Member_Name]=nil
    HealBot_UnitBuff[Member_Name]=nil
    HealBot_UnitDebuff[Member_Name]=nil
	HealBot_UnitSpec[Member_Name]=nil
    if HealBot_AggroBar4[Member_Name] then
      HealBot_AggroBar4[Member_Name]=nil
    end
    if HealBot_Aggro[Member_Name] then
      HealBot_Aggro[Member_Name]=nil
    end
    if HealBot_UnitID[Member_Name] then
      if HealBot_Unit_Button[HealBot_UnitID[Member_Name]] then
	    if not UnitName(HealBot_UnitID[Member_Name]) then
	      HealBot_Unit_Button[HealBot_UnitID[Member_Name]]=nil
	    end
  	  end
      HealBot_UnitID[Member_Name]=nil
    end
  end
end
