local spellLeft = nil
local spellMiddle = nil
local spellRight = nil
local spellButton4 = nil
local spellButton5 = nil
local hlth, maxhlth, linenum = 1,2,1
local templeft=nil
local id=nil
local lspell=nil
local lspellrank=nil
local r=nil
local g=nil
local b=nil
local a=nil
local Member_Name=nil
local br=nil
local bg=nil
local bb=nil
local text=nil
local Heals=nil
local ri=nil
local DebuffType=nil
local Member_Buff=nil
local spellLeftRecInstant=nil
local spellMiddleRecInstant=nil
local spellRightRecInstant=nil
local spellButton4RecInstant=nil
local spellButton5RecInstant=nil
local hlthdelta, tmpnum=0,0
local spellLeftTxt=nil
local spellLeftHeal=nil
local spellMiddleTxt=nil
local spellMiddleHeal=nil
local spellRightTxt=nil
local spellRightHeal=nil
local spellButton4Txt=nil
local spellButton4Heal=nil
local spellButton5Txt=nil
local spellButton5Heal=nil
local height = 20 
local width = 0
local txtL = nil
local txtR = nil
local ret_val, ret_heal = "  ", 0;
local tonumber=tonumber
local combo=nil
local linenum=1
local ModKey=""
local spell4 = nil
local spell5 = nil
local ManaLeft = 0;
local ManaMiddle = 0;
local ManaRight = 0;
local Mana4 = 0;
local Mana5 = 0;
local raidID=nil
local zone=nil;
local Instant_check=false
local top = nil
local x, y = nil,nil
local format=format
local strsub=strsub
local strlen=strlen
local HealBot_CheckBuffs = {}
local d=nil
local HealBot_Tooltip_DirtyLines={}

function HealBot_Tooltip_Clear_CheckBuffs()
  for x,_ in pairs(HealBot_CheckBuffs) do
    HealBot_CheckBuffs[x]=nil;
  end
end

function HealBot_Tooltip_CheckBuffs(buff)
  HealBot_CheckBuffs[buff]=buff;
  d=HealBot_AltBuffNames(buff)
  if d then HealBot_CheckBuffs[d]=buff; end
end
  
function HealBot_Action_RefreshTooltip(unit)
  if HealBot_Config.ShowTooltip==0 then return end
  if not unit then return end;
  
  Member_Name=UnitName(unit);
  if (not Member_Name) then return end;

  if unit=="target" then
    HealBot_Action_RefreshTargetTooltip(Member_Name, unit)
	return
  end
  
  hlth,maxhlth=HealBot_UnitHealth(unit)

  if hlth>maxhlth then
    maxhlth=HealBot_CorrectPetHealth(unit,hlth,maxhlth,Member_Name)
  end
  
  Member_Buff=HealBot_UnitBuff[Member_Name]
  DebuffType=HealBot_UnitDebuff[Member_Name];

  spellLeft = HealBot_Action_SpellPattern("Left");
  spellMiddle = HealBot_Action_SpellPattern("Middle");
  spellRight = HealBot_Action_SpellPattern("Right");
  spellButton4 = HealBot_Action_SpellPattern("Button4");
  spellButton5 = HealBot_Action_SpellPattern("Button5");
  linenum = 1
  
  if not IsModifierKeyDown() and not HealBot_IsFighting and HealBot_Config.SmartCast==1 then 
    templeft=spellLeft;
    spellLeft=nil;
    spellLeft=HealBot_Action_SmartCast(unit);
    if not spellLeft then spellLeft=templeft; end;
  end
  if spellLeft and spellLeft~=HEALBOT_DISABLED_TARGET and spellLeft~=HEALBOT_ASSIST and spellLeft~=HEALBOT_FOCUS then
    
    if spellLeft then
      id=nil
      if not HealBot_Spells[spellLeft] then
        id = HealBot_GetSpellId(spellLeft);
      elseif HealBot_Spells[spellLeft].id then
        id = HealBot_Spells[spellLeft].id
      else
        id = HealBot_GetSpellId(spellLeft);
      end
	  if id then
        lspell, lspellrank = HealBot_GetSpellName(id)
        if lspellrank then
          spellLeft=lspell .. "(" .. lspellrank .. ")";
        else
          spellLeft=lspell;
        end
	  else
	    x=GetMacroIndexByName(spellLeft)
		if x==0 then spellLeft="" end
	  end
    else 
      spellLeft = HealBot_GetHealSpell(unit,HealBot_Action_SpellPattern("Left"));
    end
  end
  if spellMiddle and spellMiddle~=HEALBOT_DISABLED_TARGET and spellMiddle~=HEALBOT_ASSIST and spellMiddle~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spellMiddle)
	if x==0 then spellMiddle = HealBot_GetHealSpell(unit,spellMiddle) end
  end
  if spellRight and spellRight~=HEALBOT_DISABLED_TARGET and spellRight~=HEALBOT_ASSIST and spellRight~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spellRight)
    if x==0 then spellRight = HealBot_GetHealSpell(unit,spellRight) end
  end
  if spellButton4 and spellButton4~=HEALBOT_DISABLED_TARGET and spellButton4~=HEALBOT_ASSIST and spellButton4~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spellButton4)
    if x==0 then spellButton4 = HealBot_GetHealSpell(unit,spellButton4) end
  end
  if spellButton5 and spellButton5~=HEALBOT_DISABLED_TARGET and spellButton5~=HEALBOT_ASSIST and spellButton5~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spellButton5)
    if x==0 then spellButton5 = HealBot_GetHealSpell(unit,spellButton5) end
  end
  
  HealBot_Tooltip_ClearLines();
    
  if HealBot_Config.Tooltip_ShowTarget==1 then
    if Member_Name then
      if UnitClass(unit) then
	    if UnitName("target") and UnitName("target")==Member_Name and HealBot_UnitSpec[Member_Name]==" " and UnitInRange("target") == 1 then
		  NotifyInspect("target")
		end
	    r,g,b=HealBot_Action_RetHealBot_ClassCol(Member_Name)
		text = HealBot_UnitSpec[Member_Name] or " "
        HealBot_Tooltip_SetLineLeft(Member_Name.." (Level "..UnitLevel(unit)..text..UnitClass(unit)..")",r,g,b,linenum,1)   
      else 
        HealBot_Tooltip_SetLineLeft(Member_Name,1,1,1,linenum,1)   
      end      
      if hlth and maxhlth then
        r,g,b,a=HealBot_HealthColor(unit,hlth,maxhlth,true,Member_Name,false,Member_Buff,DebuffType,HealBot_RetHealsIn(ebuName));
        HealBot_Tooltip_SetLineRight(hlth.."/"..maxhlth.." (-"..maxhlth-hlth..")",r,g,b,linenum,1) 
      end
      if DebuffType then
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(Member_Name.." suffers from "..HealBot_UnitDebuff[Member_Name.."_debuff_name"],
                                           HealBot_Config.CDCBarColour[DebuffType].R+0.2,
                                           HealBot_Config.CDCBarColour[DebuffType].G+0.2,
                                           HealBot_Config.CDCBarColour[DebuffType].B+0.2,
                                           linenum,1)
		HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
      end
      if Member_Buff then
        linenum=linenum+1
		br,bg,bb=HealBot_Options_RetBuffRGB(Member_Buff)
        HealBot_Tooltip_SetLineLeft(Member_Name.." is missing buff "..Member_Buff,br,bg,bb,linenum,1)
		HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
      end
	  linenum=linenum+1
	  if not HealBot_IsFighting and HealBot_Config.Tooltip_ShowTarget==1 and HealBot_Config.Tooltip_ShowMyBuffs==1 then
	    d=false
        for x,y in pairs(HealBot_CheckBuffs) do
		  ri,text=HealBot_HasMyBuff(x, unit)
          if ri then
		    d=true
            linenum=linenum+1
		    br,bg,bb=HealBot_Options_RetBuffRGB(y)
			if text>=60 then 
			  text=ceil(text/60)
              HealBot_Tooltip_SetLineLeft("  "..x.."  "..text.." mins",br,bg,bb,linenum,1)
			  HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
			else
			  text=ceil(text)
			  HealBot_Tooltip_SetLineLeft("  "..x.."  "..text.." secs",br,bg,bb,linenum,1)
			  HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
			end
		  end
        end
	  end
      if d then linenum=linenum+1 end
      if HealBot_Config.ProtectPvP==1 and UnitIsPVP(unit) and not UnitIsPVP("player") then 
        HealBot_Tooltip_SetLineLeft("    ----- PVP -----",1,0.5,0.5,linenum,1);
        HealBot_Tooltip_SetLineRight("----- PVP -----    ",1,0.5,0.5,linenum,1);
		linenum=linenum+1;
	  end
    end
  else
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_TAB_SPELLS,1,1,1,linenum,1)
	HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
  end
  
  spellLeftRecInstant=false;
  spellMiddleRecInstant=false;
  spellRightRecInstant=false;
  spellButton4RecInstant=false;
  spellButton5RecInstant=false;
  
  if spellLeft=="" then spellLeft=nil; end
  if spellMiddle=="" then spellMiddle=nil; end
  if spellRight=="" then spellRight=nil; end
  if spellButton4=="" then spellButton4=nil; end
  if spellButton5=="" then spellButton5=nil; end
    
    if HealBot_Config.Tooltip_ShowSpellDetail==1 then

      if spellLeft then
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONLEFT.." "..HEALBOT_OPTIONS_COMBOBUTTON..": "..spellLeft,1,1,0,linenum,1) 
        linenum=HealBot_Tooltip_SpellInfo(spellLeft,linenum);
        spellLeftRecInstant=HealBot_Tooltip_CheckForInstant(unit,spellLeft)
        linenum=linenum+1;
      end
      if spellMiddle then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONMIDDLE.." "..HEALBOT_OPTIONS_COMBOBUTTON..": "..spellMiddle,1,1,0,linenum,1) 
        linenum=HealBot_Tooltip_SpellInfo(spellMiddle,linenum);
        spellMiddleRecInstant=HealBot_Tooltip_CheckForInstant(unit,spellMiddle)
        linenum=linenum+1;
      end
      if spellRight then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONRIGHT.." "..HEALBOT_OPTIONS_COMBOBUTTON..": "..spellRight,1,1,0,linenum,1) 
        linenum=HealBot_Tooltip_SpellInfo(spellRight,linenum);
        spellRightRecInstant=HealBot_Tooltip_CheckForInstant(unit,spellRight)
        linenum=linenum+1;
      end
      if spellButton4 then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTON4.." "..HEALBOT_OPTIONS_COMBOBUTTON..": "..spellButton4,1,1,0,linenum,1) 
        linenum=HealBot_Tooltip_SpellInfo(spellButton4,linenum);
        spellButton4RecInstant=HealBot_Tooltip_CheckForInstant(unit,spellButton4)
        linenum=linenum+1;
      end
      if spellButton5 then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTON5.." "..HEALBOT_OPTIONS_COMBOBUTTON..": "..spellButton5,1,1,0,linenum,1) 
        linenum=HealBot_Tooltip_SpellInfo(spellButton5,linenum);
        spellButton5RecInstant=HealBot_Tooltip_CheckForInstant(unit,spellButton5);
        linenum=linenum+1;
      end
    else
      hlthdelta=maxhlth-hlth;
      spellLeftTxt, spellLeftHeal="",0
      spellMiddleTxt, spellMiddleHeal="",0
      spellRightTxt, spellRightHeal="",0
      spellButton4Txt, spellButton4Heal="",0
      spellButton5Txt, spellButton5Heal="",0
      tmpnum=0;
      if spellLeft then 
        spellLeftTxt, spellLeftHeal=HealBot_Tooltip_SpellSummary(spellLeft);
        r,g,b,a,spellLeftRecInstant,spellLeftHeal=HealBot_Tooltip_SetQuickTipsColours(spellLeftHeal,hlthdelta,unit,spellLeft)
        linenum=linenum+1
        HealBot_Tooltip_SetLineRight(spellLeftTxt,r,g,b,linenum,a) 
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONLEFT..": "..spellLeft,1,1,0,linenum,a) 
      end
      if spellMiddle then
        spellMiddleTxt, spellMiddleHeal=HealBot_Tooltip_SpellSummary(spellMiddle);
        r,g,b,a,spellMiddleRecInstant,spellMiddleHeal=HealBot_Tooltip_SetQuickTipsColours(spellMiddleHeal,hlthdelta,unit,spellMiddle)
        linenum=linenum+1
        HealBot_Tooltip_SetLineRight(HealBot_Tooltip_SpellSummary(spellMiddle),r,g,b,linenum,a) 
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONMIDDLE..": "..spellMiddle,1,1,0,linenum,a) 
      end
      if spellRight then
        spellRightTxt, spellRightHeal=HealBot_Tooltip_SpellSummary(spellRight);
        r,g,b,a,spellRightRecInstant,spellRightHeal=HealBot_Tooltip_SetQuickTipsColours(spellRightHeal,hlthdelta,unit,spellRight)
        linenum=linenum+1
        HealBot_Tooltip_SetLineRight(HealBot_Tooltip_SpellSummary(spellRight),r,g,b,linenum,a) 
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONRIGHT..": "..spellRight,1,1,0,linenum,a) 
      end
      if spellButton4 then
        spellButton4Txt, spellButton4Heal=HealBot_Tooltip_SpellSummary(spellButton4);
        r,g,b,a,spellButton4RecInstant,spellButton4Heal=HealBot_Tooltip_SetQuickTipsColours(spellButton4Heal,hlthdelta,unit,spellButton4)
        linenum=linenum+1
        HealBot_Tooltip_SetLineRight(HealBot_Tooltip_SpellSummary(spellButton4),r,g,b,linenum,a) 
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTON4..": "..spellButton4,1,1,0,linenum,a) 
      end
      if spellButton5 then
        spellButton5Txt, spellButton5Heal=HealBot_Tooltip_SpellSummary(spellButton5);
        r,g,b,a,spellButton5RecInstant,spellButton5Heal=HealBot_Tooltip_SetQuickTipsColours(spellButton5Heal,hlthdelta,unit,spellButton5)
        linenum=linenum+1
        HealBot_Tooltip_SetLineRight(HealBot_Tooltip_SpellSummary(spellButton5),r,g,b,linenum,a) 
        HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTON5..": "..spellButton5,1,1,0,linenum,a) 
      end
    end      
    if HealBot_Config.Tooltip_Recommend==1 then
      Instant_check=false;
      if HealBot_Config.Tooltip_ShowSpellDetail==0 then linenum=linenum+1; end
      linenum=linenum+1
      HealBot_Tooltip_SetLineLeft(HEALBOT_TOOLTIP_RECOMMENDTEXT,0.8,0.8,0,linenum,1) 
      if spellLeftRecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTONLEFT..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellLeft.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellMiddleRecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTONMIDDLE..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellMiddle.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellRightRecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTONRIGHT..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellRight.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellButton4RecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTON4..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellButton4.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellButton5RecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTON5..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellButton5.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if not Instant_check then
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft("  None",0.4,0.4,0.4,linenum,1) 
      end
    else
      if HealBot_Config.Tooltip_ShowSpellDetail==1 then linenum=linenum-1; end
    end
  
    linenum=HealBot_ToolTip_PreDefined(Member_Name,linenum)
  
    height = 20 
    width = 0
    for i = 1, linenum do
      txtL = getglobal("HealBot_TooltipTextL" .. i)
      txtR = getglobal("HealBot_TooltipTextR" .. i)
      height = height + txtL:GetHeight() + 2
      if (txtL:GetWidth() + txtR:GetWidth() + 25 > width) then
        width = txtL:GetWidth() + txtR:GetWidth() + 25
      end
    end
    HealBot_ToolTip_SetTooltipPos();
    HealBot_Tooltip:SetWidth(width)
    HealBot_Tooltip:SetHeight(height)
    HealBot_Tooltip:Show();
end

function HealBot_Tooltip_SpellInfo(spell,linenum)
  text=nil
  if HealBot_Spells[spell] then
    if HealBot_Spells[spell].HealsDur>0 then
      linenum=linenum+1
      HealBot_Tooltip_SetLineLeft(HEALBOT_WORDS_CAST..": "..HealBot_Spells[spell].CastTime.." "..HEALBOT_WORDS_SEC..".",0.8,0.8,0.8,linenum,1)
      if HealBot_InnerFocus then
        HealBot_Tooltip_SetLineRight("Mana: 0",0.5,0.5,1,linenum,1) 
      else
        HealBot_Tooltip_SetLineRight("Mana: "..HealBot_Spells[spell].Mana,0.5,0.5,1,linenum,1) 
      end
      if HealBot_Spells[spell].HealsMax>0 then
        Heals = HEALBOT_HEAL.." "
        if HealBot_Spells[spell].Shield then
          Heals = HEALBOT_TOOLTIP_SHIELD.." "
          text=Heals..format("%d", HealBot_Spells[spell].HealsMax)
        else
          if HealBot_Spells[spell].HealsMin<HealBot_Spells[spell].HealsMax then
            text=Heals..format("%d", HealBot_Spells[spell].HealsMin + HealBot_Spells[spell].RealHealing) .." "..HEALBOT_WORDS_TO.." "..format("%d",HealBot_Spells[spell].HealsMax + HealBot_Spells[spell].RealHealing)
          else
            text=Heals..format("%d", HealBot_Spells[spell].HealsMax + HealBot_Spells[spell].RealHealing)
          end
        end
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(text,1,1,1,linenum,1)
      end
      if HealBot_Spells[spell].HealsExt>0 then
        text=HEALBOT_HEAL.." "..HealBot_Spells[spell].HealsDur.." "..HEALBOT_WORDS_OVER.." "..HealBot_Spells[spell].Duration-HealBot_Spells[spell].CastTime.." sec."
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(text,1,1,1,linenum,1)
      end
      if not HealBot_Spells[spell].Shield then
        text=HEALBOT_TOOLTIP_ITEMBONUS.." +"..HealBot_GetHealingBonus().." | "..HEALBOT_TOOLTIP_ACTUALBONUS.." +"..HealBot_Spells[spell].RealHealing.." "
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(text,0.8,0.8,0.8,linenum,1)
      end
    end
  elseif HealBot_OtherSpells[spell] then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(HEALBOT_WORDS_CAST..": "..HealBot_OtherSpells[spell].CastTime.." "..HEALBOT_WORDS_SEC..".",0.8,0.8,0.8,linenum,1) 
    HealBot_Tooltip_SetLineRight("Mana: "..HealBot_OtherSpells[spell].Mana,0.5,0.5,1,linenum,1)    
  end
  return linenum
end

function HealBot_Tooltip_SpellSummary(spell)
  ret_val, ret_heal = "  ", 0
  if HealBot_Spells[spell] then
    if HealBot_Spells[spell].HealsDur>0 then
      if HealBot_Spells[spell].HealsMax>0 then
        Heals = " "..HEALBOT_HEAL.." "
        if HealBot_Spells[spell].Shield then
          Heals = " "..HEALBOT_TOOLTIP_SHIELD.." "
          ret_heal=HealBot_Spells[spell].HealsMax
          ret_val=ret_val..Heals..format("%d", ret_heal)
          ret_heal=0-ret_heal
        else
          if HealBot_Spells[spell].HealsMin<HealBot_Spells[spell].HealsMax then
            ret_heal=((HealBot_Spells[spell].HealsMin+HealBot_Spells[spell].HealsMax)/2) + HealBot_Spells[spell].RealHealing
          else
            ret_heal=HealBot_Spells[spell].HealsMax + HealBot_Spells[spell].RealHealing
          end
          ret_val=ret_val..Heals..format("%d", ret_heal)
        end
      end
      if HealBot_Spells[spell].HealsExt>0 then
        ret_heal=HealBot_Spells[spell].HealsDur;
        ret_val=ret_val.." HoT "..format("%d", ret_heal);
        ret_heal=0-ret_heal;
      end
--      ret_val=ret_val.." "..HEALBOT_WORDS_FOR.." "..HealBot_Spells[spell].Mana.." Mana";
    end
  elseif HealBot_OtherSpells[spell] then
    if HealBot_InnerFocus then
      ret_val = " -   0 Mana"
    else
      ret_val = " -  "..HealBot_OtherSpells[spell].Mana.." Mana"
    end
  else
    ret_heal=-1;
  end
  if strlen(ret_val)<5 then ret_val = " - "..spell; end
  return ret_val,ret_heal;
end

function HealBot_Tooltip_CheckForInstant(unit,spell)
  if HealBot_Spells[spell] then
    if HealBot_Spells[spell].Buff then
      if HealBot_HasBuff(HealBot_Spells[spell].Buff,unit) then return false end;  
      return true;
    end
  end
  return false;
end

function HealBot_Tooltip_SetQuickTipsColours(healval,hlthdelta,unit,spell)
  r,g,b,a,ri=0.5,0.5,1,1,false;
  ri=HealBot_Tooltip_CheckForInstant(unit,spell)
  if healval==-1 then
--    r, g, b=0.58,0.58,1;
  elseif healval>0 then
    if healval>hlthdelta then
      tmpnum=(healval-hlthdelta);
      a=(hlthdelta-tmpnum)/(hlthdelta+1);
    else
      a=((healval)/(hlthdelta+1))*1.35;
    end
  elseif healval==0 then
--    r, g, b=0.8,1,0.2;
  else
    healval=0-healval;
    if (healval*.72)>hlthdelta then
      tmpnum=((healval)-hlthdelta);
      a=((hlthdelta-tmpnum)/(hlthdelta+1))*1.35;
    else
      A=(healval/(hlthdelta+1))*1.5;
    end
    if not ri then
      a=0.2
    end
  end
  if a<0.2 then 
    a=0.2;
  elseif a>1 then 
    a=1;
  end
  return r,g,b,a,ri,healval;
end

function HealBot_Tooltip_RefreshDisabledTooltip(unit)
  if HealBot_Config.ShowTooltip==0 then return end
  if not unit then return end;
  
  Member_Name=UnitName(unit);

  if (not Member_Name) then return end;
  
  if unit=="target" then
    HealBot_Action_RefreshTargetTooltip(Member_Name, unit)
	return
  end

  combo=HealBot_Config.DisabledKeyCombo
  linenum=1;
  ModKey="";
  if IsAltKeyDown() then ModKey="Alt"; end
  if IsControlKeyDown() then ModKey="Ctrl"..ModKey; end
  if IsShiftKeyDown() then ModKey="Shift"..ModKey; end

 
  spellLeft=nil
  spellMiddle = combo[ModKey.."Middle"];
  spellRight = combo[ModKey.."Right"];
  spell4 = combo[ModKey.."Button4"];
  spell5 = combo[ModKey.."Button5"];
  
  spellLeftRecInstant=false;
  spellMiddleRecInstant=false;
  spellRightRecInstant=false;
  spellButton4RecInstant=false;
  spellButton5RecInstant=false;
  
  if ModKey=="" and not HealBot_IsFighting and HealBot_Config.SmartCast==1 then 
    spellLeft=HealBot_Action_SmartCast(unit);
  end
  if not spellLeft then
    spellLeft = combo[ModKey.."Left"];
    if spellLeft and spellLeft~=HEALBOT_DISABLED_TARGET and spellLeft~=HEALBOT_ASSIST and spellLeft~=HEALBOT_FOCUS then
	  x=GetMacroIndexByName(spellLeft)
      if x==0 then spellLeft = HealBot_GetHealSpell(unit,spellLeft) end 
    end
  end
  if spellMiddle and spellMiddle~=HEALBOT_DISABLED_TARGET and spellMiddle~=HEALBOT_ASSIST and spellMiddle~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spellMiddle)
	if x==0 then spellMiddle = HealBot_GetHealSpell(unit,spellMiddle) end
  end
  if spellRight and spellRight~=HEALBOT_DISABLED_TARGET and spellRight~=HEALBOT_ASSIST and spellRight~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spellRight)
    if x==0 then spellRight = HealBot_GetHealSpell(unit,spellRight) end
  end
  if spell4 and spell4~=HEALBOT_DISABLED_TARGET and spell4~=HEALBOT_ASSIST and spell4~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spell4)
    if x==0 then spell4 = HealBot_GetHealSpell(unit,spell4) end
  end
  if spell5 and spell5~=HEALBOT_DISABLED_TARGET and spell5~=HEALBOT_ASSIST and spell5~=HEALBOT_FOCUS then
    x=GetMacroIndexByName(spell5)
    if x==0 then spell5 = HealBot_GetHealSpell(unit,spell5) end
  end
  
  ManaLeft = 0;
  ManaMiddle = 0;
  ManaRight = 0;
  Mana4 = 0;
  Mana5 = 0;
  
  if HealBot_Spells[spellLeft] then
    ManaLeft = HealBot_Spells[spellLeft].Mana
  elseif HealBot_OtherSpells[spellLeft] then
    ManaLeft = HealBot_OtherSpells[spellLeft].Mana
  elseif spellLeft=="" then
    spellLeft=nil;
  end
    
  if HealBot_Spells[spellMiddle] then
    ManaMiddle = HealBot_Spells[spellMiddle].Mana
  elseif HealBot_OtherSpells[spellMiddle] then
    ManaMiddle = HealBot_OtherSpells[spellMiddle].Mana
  elseif spellMiddle=="" then
    spellMiddle=nil;
  end

  if HealBot_Spells[spellRight] then
    ManaRight = HealBot_Spells[spellRight].Mana
  elseif HealBot_OtherSpells[spellRight] then
    ManaRight = HealBot_OtherSpells[spellRight].Mana
  elseif spellRight=="" then
    spellRight=nil;
  end

  if HealBot_Spells[spell4] then
    ManaRight = HealBot_Spells[spell4].Mana
  elseif HealBot_OtherSpells[spell4] then
    ManaRight = HealBot_OtherSpells[spell4].Mana
  elseif spell4=="" then
    spell4=nil;
  end

  if HealBot_Spells[spell5] then
    ManaRight = HealBot_Spells[spell5].Mana
  elseif HealBot_OtherSpells[spell5] then
    ManaRight = HealBot_OtherSpells[spell5].Mana
  elseif spell5=="" then
    spell5=nil;
  end
    
  HealBot_Tooltip_ClearLines();
  
  if HealBot_Config.Tooltip_ShowTarget==1 then
    raidID=nil
    zone=nil;
    if HealBot_PlayerName==Member_Name then
      zone=GetRealZoneText();
    elseif GetNumRaidMembers()>0 then
      if strsub(unit,1,4)~="raid" then
        if UnitInRaid(unit) then
          for r=1,40 do
            if UnitName("raid"..r)==Member_Name then
              raidID=r
              _, _, _, _, _, _, zone, _, _ = GetRaidRosterInfo(raidID);
              do break end;
            end
          end
        end
      elseif strsub(unit,1,7)~="raidpet" then
        raidID=tonumber(strsub(unit,5))
        _, _, _, _, _, _, zone, _, _ = GetRaidRosterInfo(raidID);
      end
    else
      HealBot_TooltipInit();
      HealBot_ScanTooltip:SetUnit(unit)
      zone = HealBot_ScanTooltipTextLeft3:GetText()
      if zone == "PvP" then
        zone = HealBot_ScanTooltipTextLeft4:GetText()
      end
    end
    if Member_Name then
	  if UnitName("target") and UnitName("target")==Member_Name and HealBot_UnitSpec[Member_Name]==" " and UnitInRange("target") == 1 then
		NotifyInspect("target")
      end
	  r,g,b=HealBot_Action_RetHealBot_ClassCol(Member_Name)
      HealBot_Tooltip_SetLineLeft(Member_Name,r,g,b,linenum,1)
      if UnitClass(unit) then
	    text = HealBot_UnitSpec[Member_Name] or " "
        HealBot_Tooltip_SetLineRight(" Level "..UnitLevel(unit)..text..UnitClass(unit),r,g,b,linenum,1);
      end
      if zone and not strfind(zone,"Level") then
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(HEALBOT_TOOLTIP_LOCATION..":",1,1,0.5,linenum,1);
        HealBot_Tooltip_SetLineRight(zone,1,1,1,linenum,1);
      end
      if HealBot_Config.ProtectPvP==1 and UnitIsPVP(unit) and not UnitIsPVP("player") then 
        HealBot_Tooltip_SetLineLeft("    ----- PVP -----",1,0.5,0.5,linenum,1);
        HealBot_Tooltip_SetLineRight("----- PVP -----    ",1,0.5,0.5,linenum,1);
	  end
      DebuffType=HealBot_UnitDebuff[Member_Name];
      if DebuffType then
        linenum=linenum+1
        HealBot_Tooltip_SetLineLeft(Member_Name.." suffers from "..HealBot_UnitDebuff[Member_Name.."_debuff_name"],
                                           HealBot_Config.CDCBarColour[DebuffType].R+0.2,
                                           HealBot_Config.CDCBarColour[DebuffType].G+0.2,
                                           HealBot_Config.CDCBarColour[DebuffType].B+0.2,
                                           linenum,1)
		HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
      end
      Member_Buff=HealBot_UnitBuff[Member_Name];
      if Member_Buff then
        linenum=linenum+1
		br,bg,bb=HealBot_Options_RetBuffRGB(Member_Buff);
        HealBot_Tooltip_SetLineLeft(Member_Name.." is missing buff "..Member_Buff,br,bg,bb,linenum,1)
		HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
      end
	  linenum=linenum+1
	  if not HealBot_IsFighting and HealBot_Config.Tooltip_ShowTarget==1 and HealBot_Config.Tooltip_ShowMyBuffs==1 then
	    d=false
        for x,y in pairs(HealBot_CheckBuffs) do
		  ri,text=HealBot_HasMyBuff(x, unit)
          if ri then
		    d=true
            linenum=linenum+1
		    br,bg,bb=HealBot_Options_RetBuffRGB(y)
			if text>=60 then 
			  text=ceil(text/60)
              HealBot_Tooltip_SetLineLeft("  "..x.."  "..text.." mins",br,bg,bb,linenum,1)
			  HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
			else
 			  text=ceil(text)
			  HealBot_Tooltip_SetLineLeft("  "..x.."  "..text.." secs",br,bg,bb,linenum,1)
			  HealBot_Tooltip_SetLineRight(" ",0,0,0,linenum,0)
			end
		  end
        end
	  end
      if d then linenum=linenum+1 end
    end
  else
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_TAB_SPELLS,1,1,1,linenum,1)
  end
  
  if spellLeft then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONLEFT..": "..spellLeft,1,1,0,linenum,1) 
    if ManaLeft>0 then 
      if HealBot_InnerFocus then ManaLeft=0; end
      HealBot_Tooltip_SetLineRight("  "..ManaLeft.." Mana",0.5,0.5,1,linenum,1); 
    end
    spellLeftRecInstant=HealBot_Tooltip_CheckForInstant(unit,spellLeft)
  end
  if spellMiddle then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONMIDDLE..": "..spellMiddle,1,1,0,linenum,1) 
    if ManaMiddle>0 then
      if HealBot_InnerFocus then ManaMiddle=0; end
      HealBot_Tooltip_SetLineRight("  "..ManaMiddle.." Mana",0.5,0.5,1,linenum,1); 
    end
    spellMiddleRecInstant=HealBot_Tooltip_CheckForInstant(unit,spellMiddle)
  end
  if spellRight then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTONRIGHT..": "..spellRight,1,1,0,linenum,1) 
    if ManaRight>0 then 
      if HealBot_InnerFocus then ManaRight=0; end
      HealBot_Tooltip_SetLineRight("  "..ManaRight.." Mana",0.5,0.5,1,linenum,1); 
    end
    spellRightRecInstant=HealBot_Tooltip_CheckForInstant(unit,spellRight)
  end
  if spell4 then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTON4..": "..spell4,1,1,0,linenum,1) 
    if Mana4>0 then 
      if HealBot_InnerFocus then Mana4=0; end
      HealBot_Tooltip_SetLineRight("  "..Mana4.." Mana",0.5,0.5,1,linenum,1); 
    end
    spellButton4RecInstant=HealBot_Tooltip_CheckForInstant(unit,spell4)
  end
  if spell5 then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(HEALBOT_OPTIONS_BUTTON5..": "..spell5,1,1,0,linenum,1) 
    if Mana5>0 then 
      if HealBot_InnerFocus then Mana5=0; end
      HealBot_Tooltip_SetLineRight("  "..Mana5.." Mana",0.5,0.5,1,linenum,1); 
    end
    spellButton5RecInstant=HealBot_Tooltip_CheckForInstant(unit,spell5);
  end

  if HealBot_Config.Tooltip_Recommend==1 then
    Instant_check=false;
    linenum=linenum+2
    HealBot_Tooltip_SetLineLeft(HEALBOT_TOOLTIP_RECOMMENDTEXT,0.8,0.8,0,linenum,1) 
      if spellLeftRecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTONLEFT..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellLeft.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellMiddleRecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTONMIDDLE..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellMiddle.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellRightRecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTONRIGHT..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spellRight.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellButton4RecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTON4..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spell4.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
      if spellButton5RecInstant then
        linenum=linenum+1;
        HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_BUTTON5..":",1,1,0.2,linenum,1);
        HealBot_Tooltip_SetLineRight(spell5.."    ",1,1,1,linenum,1);
        Instant_check=true;
      end
    if not Instant_check then
      linenum=linenum+1
      HealBot_Tooltip_SetLineLeft("  None",0.4,0.4,0.4,linenum,1) 
    end
  end
  
  linenum=HealBot_ToolTip_PreDefined(Member_Name,linenum) 

    height = 20 
    width = 0
    for i = 1, linenum do
      txtL = getglobal("HealBot_TooltipTextL" .. i)
      txtR = getglobal("HealBot_TooltipTextR" .. i)
      height = height + txtL:GetHeight() + 2
      if (txtL:GetWidth() + txtR:GetWidth() + 25 > width) then
        width = txtL:GetWidth() + txtR:GetWidth() + 25
      end
    end
    HealBot_ToolTip_SetTooltipPos();
    HealBot_Tooltip:SetWidth(width)
    HealBot_Tooltip:SetHeight(height)
    HealBot_Tooltip:Show();
end

function HealBot_Action_RefreshTargetTooltip(Member_Name, unit)
  HealBot_TooltipInit();
  HealBot_Tooltip_ClearLines();
  linenum=1
  r,g,b=HealBot_Action_RetHealBot_ClassCol(Member_Name)
  HealBot_Tooltip_SetLineLeft(Member_Name,r,g,b,linenum,1)
  if UnitClass(unit) then
    text = HealBot_UnitSpec[Member_Name] or " "
    HealBot_Tooltip_SetLineRight(" Level "..UnitLevel(unit)..text..UnitClass(unit),r,g,b,linenum,1);
  end
  linenum=linenum+1
  HealBot_Tooltip_SetLineLeft(HEALBOT_TOOLTIP_TARGETBAR,1,1,0.5,linenum,1);
  HealBot_Tooltip_SetLineRight(HEALBOT_OPTIONS_TAB_SPELLS.." "..HEALBOT_SKIN_DISTEXT,1,1,0.5,linenum,1);
  linenum=linenum+2
  
  if HealBot_Config.SmartCast==1 then
    HealBot_Tooltip_SetLineLeft(" "..HEALBOT_OPTIONS_BUTTONLEFT..":",1,1,0.2,linenum,1)
    HealBot_Tooltip_SetLineRight(HEALBOT_TITAN_SMARTCAST.." ",1,1,1,linenum,1);
  end
  if HealBot_UnitID[Member_Name] then
    linenum=linenum+1
    HealBot_Tooltip_SetLineLeft(" "..HEALBOT_OPTIONS_BUTTONRIGHT..":",1,1,0.2,linenum,1)
    if HealBot_Panel_RetMyHealTarget(Member_Name) then
      HealBot_Tooltip_SetLineRight(HEALBOT_WORDS_REMOVEFROM.." "..HEALBOT_OPTIONS_TARGETHEALS.." ",1,1,1,linenum,1);
    else
      HealBot_Tooltip_SetLineRight(HEALBOT_WORDS_ADDTO.." "..HEALBOT_OPTIONS_TARGETHEALS.." ",1,1,1,linenum,1);
    end
  end
  
    height = 20 
    width = 0
    for i = 1, linenum do
      txtL = getglobal("HealBot_TooltipTextL" .. i)
      txtR = getglobal("HealBot_TooltipTextR" .. i)
      height = height + txtL:GetHeight() + 2
      if (txtL:GetWidth() + txtR:GetWidth() + 25 > width) then
        width = txtL:GetWidth() + txtR:GetWidth() + 25
      end
    end
    HealBot_ToolTip_SetTooltipPos();
    HealBot_Tooltip:SetWidth(width)
    HealBot_Tooltip:SetHeight(height)
    HealBot_Tooltip:Show();
end

function HealBot_ToolTip_PreDefined(uName,linen)
  if HealBot_Config.Tooltip_PreDefined==1 then
    linen=linen+2
    HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_CTRL.."+"..HEALBOT_OPTIONS_ALT.."+"..HEALBOT_OPTIONS_BUTTONLEFT..":",1,1,0.2,linen,1)
    if HealBot_Action_RetMyTarget(uName) then
      HealBot_Tooltip_SetLineRight(HEALBOT_SKIN_DISTEXT.."    ",1,1,1,linen,1)
    else
      HealBot_Tooltip_SetLineRight(HEALBOT_SKIN_ENTEXT.."    ",1,1,1,linen,1)
    end
  
    linen=linen+1
    HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_CTRL.."+"..HEALBOT_OPTIONS_ALT.."+"..HEALBOT_OPTIONS_BUTTONMIDDLE..":",1,1,0.2,linen,1)
    HealBot_Tooltip_SetLineRight(HEALBOT_PANEL_BLACKLIST.."    ",1,1,1,linen,1)

    linen=linen+1
    HealBot_Tooltip_SetLineLeft("   "..HEALBOT_OPTIONS_CTRL.."+"..HEALBOT_OPTIONS_ALT.."+"..HEALBOT_OPTIONS_BUTTONRIGHT..":",1,1,0.2,linen,1)
    if HealBot_Panel_RetMyHealTarget(uName) then
      HealBot_Tooltip_SetLineRight(HEALBOT_WORDS_REMOVEFROM.." "..HEALBOT_OPTIONS_TARGETHEALS.."    ",1,1,1,linen,1)
    else
      HealBot_Tooltip_SetLineRight(HEALBOT_WORDS_ADDTO.." "..HEALBOT_OPTIONS_TARGETHEALS.."    ",1,1,1,linen,1)
    end
  end
  
  return linen
end

function HealBot_ToolTip_SetTooltipPos()
    HealBot_Tooltip:ClearAllPoints();
    if HealBot_Config.TooltipPos>1 then
      top = HealBot_Action:GetTop();
      x, y = GetCursorPosition();
      x=x/UIParent:GetScale();
      y=y/UIParent:GetScale();
      if HealBot_Config.TooltipPos==2 then
        HealBot_Tooltip:SetPoint("TOPRIGHT","HealBot_Action","TOPLEFT",0,0-(top-(y+35)));
      elseif HealBot_Config.TooltipPos==3 then
        HealBot_Tooltip:SetPoint("TOPLEFT","HealBot_Action","TOPRIGHT",0,0-(top-(y+35)));
      elseif HealBot_Config.TooltipPos==4 then
        HealBot_Tooltip:SetPoint("BOTTOM","HealBot_Action","TOP",0,0);
      elseif HealBot_Config.TooltipPos==5 then
        HealBot_Tooltip:SetPoint("TOP","HealBot_Action","BOTTOM",0,0);
      else
        HealBot_Tooltip:SetPoint("TOPLEFT","WorldFrame","BOTTOMLEFT",x+25,y-20);
      end
    else
      HealBot_Tooltip:SetPoint("BOTTOMRIGHT","WorldFrame","BOTTOMRIGHT",-105,105);
    end
end

function HealBot_Tooltip_SetLineLeft(Text,R,G,B,linenum,a)
  if linenum>40 then return end
  txtL = getglobal("HealBot_TooltipTextL" .. linenum)
  txtL:SetTextColor(R,G,B,a)
  txtL:SetText(Text)
  txtL:Show()
  HealBot_Tooltip_DirtyLines[linenum]=true
end

function HealBot_Tooltip_SetLineRight(Text,R,G,B,linenum,a)
  if linenum>40 then return end
  txtR = getglobal("HealBot_TooltipTextR" .. linenum)
  txtR:SetTextColor(R,G,B,a)
  txtR:SetText(Text)
  txtR:Show()
  HealBot_Tooltip_DirtyLines[linenum]=true
end

function HealBot_Tooltip_ClearLines()
  for j,_ in pairs(HealBot_Tooltip_DirtyLines) do
    txtR = getglobal("HealBot_TooltipTextR" .. j)
    txtR:SetText(" ")
    txtL = getglobal("HealBot_TooltipTextL" .. j)
    txtL:SetText(" ")
	HealBot_Tooltip_DirtyLines[j]=nil
  end
end
