--[[

  HealBot Contined
	
]]

local HealBot_CalcEquipBonus=false;
local HealBot_HasDivineSpirit=2;
local HealBot_CheckForDivineSpirit=false;
local HealBot_FlagEquipUpdate1=1;
local HealBot_FlagEquipUpdate2=1;
local HealBot_NeedEquipUpdate=0;
local HealBot_CastingSpell  = nil;
local HealBot_HealValue = 0;
local HealBot_IamRessing = nil;
local HealBot_RequestVer=nil;
local HealBot_IamHealing = nil;
local HealBot_Loaded=nil;
local HealBot_FullyLoaded=nil;
local HealBot_InnerFocusTalent=false;
local HealBot_HoT1={};
local HealBot_HoT2={};
local HealBot_HoT3={};
local HealBot_HoT1_Spell={};
local HealBot_HoT2_Spell={};
local HealBot_HoT3_Spell={};
local HealBot_HoT_iconTexture1={};
local HealBot_HoT_iconTexture2={};
local HealBot_HoT_iconTexture3={};
local HealBot_HoT_Waiting={};
local HealBot_HoT_WaitingSpell={};
local HealBot_HoT_WaitingSpellName={};
local HealBot_HoT_Mending=0;
local HealBot_HoT_MendingWith="nil";
local HealBot_HoT_MendingWatch=0;
local HealBot_CheckZoneFlag=0
local HealBot_InCombatUpdate=false
local HealBot_SmartCast_Spells={};
local HealBot_AddonMsgType=3;
local HealBot_InBG=false;
local HealBot_HealingBonus=0;
local HealBot_HoT_Texture={};
local HealBot_SpamCnt=0;
local HealBot_ErrorCnt=0;
local HealBot_Healers = {};
local HealBot_TabHealers = {};
local HealBot_HealsIn = {};
local HealBot_CurrentSpells = {};
local HealBot_Ressing = {};
local HealBot_DelayBuffCheck = {};
local HealBot_DelayDebuffCheck = {};
local HealBot_HealsIncCnt={}
local HealBot_HealersIncCnt={}
local HealBot_Vers={}
local w=nil
local x=nil
local y=nil
local z=nil
local retSpell=nil
local Process=false
local target=8
local strfind=strfind
local strsub=strsub
local strlen=strlen
local gsub=gsub
local format=format
local tonumber=tonumber
local strlen=strlen
local HealBot_ThrottleCnt=5
local HealBot_Aggro={}
local HealBot_Reset_flag=nil
local initHealBot=nil
local HB_Timer1=0.02
local HB_Timer2=200
local HealBot_UpUnitInCombat={}
local HealBot_InCombatUpdCnt=0
local b=nil
local HealBot_Comms_Blacklist={}
local HealBot_Buff_Spells_List ={}
local HealBot_BuffNameSwap = { [HEALBOT_POWER_WORD_FORTITUDE] = HEALBOT_PRAYER_OF_FORTITUDE,
                               [HEALBOT_PRAYER_OF_FORTITUDE] = HEALBOT_POWER_WORD_FORTITUDE,
                               [HEALBOT_SHADOW_PROTECTION] = HEALBOT_PRAYER_OF_SHADOW_PROTECTION,
                               [HEALBOT_PRAYER_OF_SHADOW_PROTECTION] = HEALBOT_SHADOW_PROTECTION,
                               [HEALBOT_DIVINE_SPIRIT] = HEALBOT_PRAYER_OF_SPIRIT,
                               [HEALBOT_PRAYER_OF_SPIRIT] = HEALBOT_DIVINE_SPIRIT,
                               [HEALBOT_MARK_OF_THE_WILD] = HEALBOT_GIFT_OF_THE_WILD,
                               [HEALBOT_GIFT_OF_THE_WILD] = HEALBOT_MARK_OF_THE_WILD,
                               [HEALBOT_BLESSING_OF_MIGHT] = HEALBOT_GREATER_BLESSING_OF_MIGHT,
                               [HEALBOT_GREATER_BLESSING_OF_MIGHT] = HEALBOT_BLESSING_OF_MIGHT,
                               [HEALBOT_BLESSING_OF_WISDOM] = HEALBOT_GREATER_BLESSING_OF_WISDOM,
                               [HEALBOT_GREATER_BLESSING_OF_WISDOM] = HEALBOT_BLESSING_OF_WISDOM,
                               [HEALBOT_BLESSING_OF_KINGS] = HEALBOT_GREATER_BLESSING_OF_KINGS,
                               [HEALBOT_GREATER_BLESSING_OF_KINGS] = HEALBOT_BLESSING_OF_KINGS,
                               [HEALBOT_BLESSING_OF_LIGHT] = HEALBOT_GREATER_BLESSING_OF_LIGHT,
                               [HEALBOT_GREATER_BLESSING_OF_LIGHT] = HEALBOT_BLESSING_OF_LIGHT,
                               [HEALBOT_BLESSING_OF_SALVATION] = HEALBOT_GREATER_BLESSING_OF_SALVATION,
                               [HEALBOT_GREATER_BLESSING_OF_SALVATION] = HEALBOT_BLESSING_OF_SALVATION,
                               [HEALBOT_BLESSING_OF_SANCTUARY] = HEALBOT_GREATER_BLESSING_OF_SANCTUARY,
                               [HEALBOT_GREATER_BLESSING_OF_SANCTUARY] = HEALBOT_BLESSING_OF_SANCTUARY,
                               [HEALBOT_ARCANE_INTELLECT] = HEALBOT_ARCANE_BRILLIANCE,
                               [HEALBOT_ARCANE_BRILLIANCE] = HEALBOT_ARCANE_INTELLECT,
                       }
					   

local HealBot_Ignore_Class_Debuffs = {
    ["WARR"] = { [HEALBOT_DEBUFF_ANCIENT_HYSTERIA] = true,	
                          [HEALBOT_DEBUFF_IGNITE_MANA] = true, 
                          [HEALBOT_DEBUFF_TAINTED_MIND] = true, 
                          [HEALBOT_DEBUFF_VIPER_STING] = true,
                          [HEALBOT_DEBUFF_IMPOTENCE] = true,
                          [HEALBOT_DEBUFF_DECAYED_INT] = true,
                          [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["ROGU"] = {   [HEALBOT_DEBUFF_SILENCE] = true,	
                          [HEALBOT_DEBUFF_ANCIENT_HYSTERIA] = true, 
                          [HEALBOT_DEBUFF_IGNITE_MANA] = true, 
                          [HEALBOT_DEBUFF_TAINTED_MIND] = true, 
                          [HEALBOT_DEBUFF_VIPER_STING] = true,
                          [HEALBOT_DEBUFF_IMPOTENCE] = true,
                          [HEALBOT_DEBUFF_DECAYED_INT] = true,
                          [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["HUNT"] = {  [HEALBOT_DEBUFF_MAGMA_SHACKLES] = true, 
                          [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["MAGE"] = {    [HEALBOT_DEBUFF_MAGMA_SHACKLES] = true, 
                          [HEALBOT_DEBUFF_DECAYED_STR] = true,
                          [HEALBOT_DEBUFF_CRIPPLE] = true,
                          [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["DRUI"] = {   [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["PALA"] = { [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["PRIE"] = {  [HEALBOT_DEBUFF_DECAYED_STR] = true,
                          [HEALBOT_DEBUFF_CRIPPLE] = true,
                          [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["SHAM"] = {  [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
    ["WARL"] = { [HEALBOT_DEBUFF_DECAYED_STR] = true,
                          [HEALBOT_DEBUFF_CRIPPLE] = true,
                          [HEALBOT_DEBUFF_UNSTABLE_AFFL] = true,},
};

local HealBot_Ignore_Movement_Debuffs = {
                                  [HEALBOT_DEBUFF_FROSTBOLT] = true,
                                  [HEALBOT_DEBUFF_MAGMA_SHACKLES] = true,
                                  [HEALBOT_DEBUFF_SLOW] = true,
                                  [HEALBOT_DEBUFF_CHILLED] = true,
                                  [HEALBOT_DEBUFF_CONEOFCOLD] = true,
                                  [HEALBOT_DEBUFF_CONCUSSIVESHOT] = true,
                                  [HEALBOT_DEBUFF_THUNDERCLAP] = true,
                                  [HEALBOT_DEBUFF_HOWLINGSCREECH] = true,
                                  [HEALBOT_DEBUFF_DAZED] = true,
								  [HEALBOT_DEBUFF_FROST_SHOCK] = true,
};

local HealBot_Ignore_FastDur_Debuffs = {
                                  [HEALBOT_DEBUFF_PSYCHIC_HORROR] = true,
                                  [HEALBOT_DEBUFF_CHILLED] = true,
                                  [HEALBOT_DEBUFF_CONEOFCOLD] = true,
                                  [HEALBOT_DEBUFF_CONCUSSIVESHOT] = true,
                                  [HEALBOT_DEBUFF_FALTER] = true,
};

local HealBot_Ignore_NonHarmful_Debuffs = {
                                  [HEALBOT_DEBUFF_HUNTERS_MARK] = true,
                                  [HEALBOT_DEBUFF_ARCANE_BLAST] = true,
                                  [HEALBOT_DEBUFF_MAJOR_DREAMLESS] = true,
                                  [HEALBOT_DEBUFF_GREATER_DREAMLESS] = true,
                                  [HEALBOT_DEBUFF_DREAMLESS_SLEEP] = true,
};

local spellName=nil
local subSpellName=nil
local Current=nil
local Desired=nil
local healingbonus_penalty=nil
local dforms=nil
local dactive=nil
local ghid=nil
local ghspell=nil
local usable=nil
local noMana=nil
local HealBot_Timer1,HealBot_Timer2,HealBot_Timer3 = 0,0,0;
local HealBot_StopCastTimer=0
local Ti=nil
local Tcnt=nil
local Tname=nil
local runit=nil
local inc_msg=nil
local datatype=nil
local datamsg=nil
local sender=nil
local pName=nil
local arr=nil
local unitname=nil
local arrg = {}
local iStart=nil
local iEnd=nil
local num=nil
local punitname=nil
local zone=nil
local HoTActive=nil
local hbi=nil
local hbName=nil
local DebuffType=nil
local icd=nil
local checkthis=nil
local WatchTarget=nil
local debuff_type=nil
local dName=nil
local HealBot_Ignore_Debuffs_Class=nil
local bName=nil
local icb=nil
local buffname=nil
local PlayerBuffs = {}
local deserter=nil
local unitname=nil
local heal_val=nil
local tUnit=nil
local scsspell=nil
local Notify=nil
local chanid=nil
local addIcon=true
local button=nil
local bar=nil
local iconName=nil
local id=0
local spellRank=nil
local ispell=nil
local nameTalent=nil
local currRank=nil
local uName=nil
local hbUnit=nil
local QuickHealth = LibStub("LibQuickHealth-1.0");

function HealBot_GetHealingBonus()
  return HealBot_HealingBonus;
end

function HealBot_SetResetFlag(mode)
  if mode=="HARD" and not HealBot_InCombat then
    ReloadUI()
  else
    HealBot_Reset_flag=true
  end
end

function HealBot_GetHealBot_AddonMsgType()
  return HealBot_AddonMsgType;
end

function HealBot_RetHealBot_Ressing(uName)
  return HealBot_Ressing[uName];
end

function HealBot_RetNumCurrentSpells()
  return table.getn(HealBot_CurrentSpells)
end

function HealBot_UnsetHealBot_Ressing(uName)
  HealBot_Ressing[uName]=nil;
end

function HealBot_TooltipInit()
  if ( HealBot_ScanTooltip:IsOwned(this) ) then return; end;
  HealBot_ScanTooltip:SetOwner(this, 'ANCHOR_NONE' );
  HealBot_ScanTooltip:ClearLines();
end

function HealBot_AddChat(HBmsg)
  x=HealBot_Comms_GetChan("HBmsg");
  if x and HealBot_SpamCnt < 7 then
    HealBot_SpamCnt=HealBot_SpamCnt+1;
    w,y = GetGameTime();
	if y==0 then
      HBmsg="["..w..":00] "..HBmsg;
    elseif y<10 then
      HBmsg="["..w..":0"..y.."] "..HBmsg; 
    else
      HBmsg="["..w..":"..y.."] "..HBmsg; 
    end
    SendChatMessage(HBmsg , "CHANNEL", nil, x); 
  elseif ( DEFAULT_CHAT_FRAME ) then
    DEFAULT_CHAT_FRAME:AddMessage(HBmsg, 0.5, 0.5, 1.0);
  end
end

function HealBot_AddDebug(HBmsg)
  x=HealBot_Comms_GetChan("HBmsg");
  if x and HealBot_SpamCnt < 7 then
    HealBot_SpamCnt=HealBot_SpamCnt+1;
    w,y = GetGameTime();
	if y==0 then
      HBmsg="["..w..":00] DEBUG: "..HBmsg;
    elseif y<10 then
      HBmsg="["..w..":0"..y.."] DEBUG: "..HBmsg; 
    else
      HBmsg="["..w..":"..y.."] DEBUG: "..HBmsg; 
    end
    SendChatMessage(HBmsg , "CHANNEL", nil, x);
  end
end

function HealBot_Report_Error(HBmsg)
  if HealBot_ErrorCnt<28 then
    HealBot_ErrorCnt=HealBot_ErrorCnt+1;
    HealBot_ErrorsIn(HBmsg,HealBot_ErrorCnt);
  end
end

function HealBot_ErrorCntReset()
  HealBot_ErrorCnt=0;
end

function HealBot_AddError(HBmsg)
  UIErrorsFrame:AddMessage(HBmsg, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
  HealBot_AddDebug(HBmsg);
end

function HealBot_TogglePanel(HBpanel)
  if not HBpanel then return end
  if ( HBpanel:IsVisible() ) then
    HideUIPanel(HBpanel);
  else
    ShowUIPanel(HBpanel);
  end
end

function HealBot_StartMoving(HBframe)
  if ( not HBframe.isMoving ) and ( HBframe.isLocked ~= 1 ) then
    HBframe:StartMoving();
    HBframe.isMoving = true;
  end
end

function HealBot_StopMoving(HBframe)
  if ( HBframe.isMoving ) then
    HBframe:StopMovingOrSizing();
    HBframe.isMoving = false;
  end
  if HealBot_Config.Panel_Anchor==1 then
    z = HealBot_Action:GetTop();
	w = HealBot_Action:GetLeft()
    if w and z then
      HealBot_Config.PanelAnchorY=z;
	  HealBot_Config.PanelAnchorX=w
    end
  elseif HealBot_Config.Panel_Anchor==2 then
    x = HealBot_Action:GetBottom();
	w = HealBot_Action:GetLeft()
    if w and x then
      HealBot_Config.PanelAnchorY=x;
	  HealBot_Config.PanelAnchorX=w
    end
  elseif HealBot_Config.Panel_Anchor==3 then
    z = HealBot_Action:GetTop();
	y = HealBot_Action:GetRight()
    if y and z then
      HealBot_Config.PanelAnchorY=z;
	  HealBot_Config.PanelAnchorX=y
    end
  elseif HealBot_Config.Panel_Anchor==4 then
    x = HealBot_Action:GetBottom();
	y = HealBot_Action:GetRight()
    if y and x then
      HealBot_Config.PanelAnchorY=x;
	  HealBot_Config.PanelAnchorX=y
    end
  end
end

function HealBot_SlashCmd(HBcmd)
  if (HBcmd=="") then
    HealBot_TogglePanel(HealBot_Action);
  elseif (HBcmd=="o" or HBcmd=="options" or HBcmd=="opt" or HBcmd=="config" or HBcmd=="cfg") then
    HealBot_TogglePanel(HealBot_Options);
  elseif HBcmd=="defaults" then
    HealBot_Options_Defaults_OnClick(HealBot_Options_Defaults);
  elseif (HBcmd=="ui") then
    HealBot_SetResetFlag("HARD")
  elseif (HBcmd=="ri" or HBcmd=="reset" or HBcmd=="x") then
    HealBot_SetResetFlag("SOFT")
  elseif (HBcmd=="info" or HBcmd=="ver") then
    HealBot_Comms_Info()
  elseif (HBcmd=="chan") then
    HealBot_AddDebug( "Channel active" );
  elseif (HBcmd=="status") then
    HealBot_Comms_DebugStatus();
  elseif (HBcmd=="show") then
    HealBot_Action_Reset()
  elseif (HBcmd=="fast") then
    if HealBot_Config.FastAttrib==0 then
	  HealBot_Config.FastAttrib=1
	  HealBot_AddChat("[HealBot]Fast attrib setting is ON")
	else
	  HealBot_Config.FastAttrib=0
	  HealBot_AddChat("[HealBot]Fast attrib setting is OFF")
	end
  elseif (HBcmd=="cb") then
    HealBot_Panel_ClearBlackList()
	Delay_RecalcParty=3
  elseif (HBcmd=="disable") then
    HealBot_Options_DisableHealBot:SetChecked(1)
    HealBot_Options_ToggleHealBot(1)
  elseif (HBcmd=="enable") then
    HealBot_Options_DisableHealBot:SetChecked(0)
    HealBot_Options_ToggleHealBot(0)
  elseif (HBcmd=="tinfo") then
    if UnitName("target") then
      HealBot_Comms_TargetInfo()
	else
	  HealBot_AddDebug( "No Target" );
	end
  elseif (HBcmd=="test") then
    if HealBot_Unit_Button["player"] then HealBot_Action_SetMacroButtonAttribs(HealBot_Unit_Button["player"]) end
  else
    HealBot_AddChat("[HealBot]Unknown slash command: /hb "..HBcmd)
  end
end

function HealBot_Reset()
	HB_Timer2=2000
	HealBot_NeedEquipUpdate=5
    HealBot_UnRegister_Events()
	HealBot_Panel_ClearBlackList()
	HealBot_Panel_ClearHealTarget()
	HealBot_Action_SetAllBars()
	HealBot_Action_SetAllAttribs()
	HealBot_OnEvent_PlayerEnteringWorld()
end

function HealBot_GetSpellName(id)
  if (not id) then
    return nil;
  end
  spellName, subSpellName = GetSpellName(id,BOOKTYPE_SPELL);
  if (not spellName) then
    return nil;
  end
  if (not subSpellName or subSpellName=="") then
    return spellName;
  end
  return spellName, subSpellName;
end

function HealBot_GetSpellId(spell)
  x,y = 1,0;
  if HealBot_Spells[spell] then   
    if HealBot_Spells[spell].x then return HealBot_Spells[spell].x; end
  end
  while true do 
    spellName, subSpellName = GetSpellName(x,BOOKTYPE_SPELL);
    if (spellName) then
      if (spell == spellName .. " (" .. subSpellName .. ")") or (spell == spellName .. "(" .. subSpellName .. ")") then
       return x;
      end
      if (spell == spellName) then
        y=x;
      end   
    else
      do break end
    end
    x = x + 1;
  end
  if y>0 then
    return y
  else
    return nil;
  end
end

function HealBot_ClearIncHeal()
    if HealBot_HealValue > 0 then
      HealBot_Comms_SendAddonMsg(HEALBOT_ADDON_ID, ">> "..0-HealBot_HealValue.." <<=>> "..HealBot_IamHealing, HealBot_AddonMsgType, HealBot_PlayerName)
	  HealBot_IamHealing=nil
      HealBot_HealValue=0;
    end
end

function HealBot_StopCasting()
  HealBot_ClearIncHeal();
  HealBot_CastingSpell  = nil;
  HealBot_CastingTarget = nil;
end

function HealBot_UnitHealth(unit)
  Current,Desired = QuickHealth:UnitHealth(unit),UnitHealthMax(unit);
  if unit=='target' and Desired==100 then
    if UnitLevel(unit)>0 then
      Desired = math.floor(10000/70*UnitLevel(unit)+0.5)
    else
      Desired = UnitHealthMax('player');
    end
    Current = Desired/100*Current;
  end
  return Current,Desired;
end

function HealBot_FindHealSpells()
  
  HealBot_HealingBonus=GetSpellBonusHealing();
        
  table.foreach(HealBot_Spells, function (spell,_)
      if HealBot_CalcEquipBonus then
        if HealBot_Spells[spell].NoBonus then
          HealBot_Spells[spell].RealHealing = 0
        else
          healingbonus_penalty=1;
          if HealBot_Spells[spell].Level < 20 then
            healingbonus_penalty=(1-((20-HealBot_Spells[spell].Level)*0.0375));
          end
          w=3;
          if HealBot_Spells[spell].Cast == 0 then
            w=3;
          end
          if HealBot_Spells[spell].Cast >= 1.5 and HealBot_Spells[spell].Cast < 3 then
            w=HealBot_Spells[spell].Cast;
          end
        
          x = ((HealBot_HealingBonus * healingbonus_penalty) * (w/3));
          z = ((HealBot_Spells[spell].Level)+6)/(UnitLevel("player"))
          if z<1 then x=x*z; end
          HealBot_Spells[spell].RealHealing = floor(x);
        end
      end
      HealBot_Spells[spell].HealsDur = floor((HealBot_Spells[spell].HealsCast+HealBot_Spells[spell].HealsExt) + HealBot_Spells[spell].RealHealing);
  end);

  HealBot_CalcEquipBonus=false;
end

function HealBot_GetShapeshiftForm()
  dforms = GetNumShapeshiftForms();
  if dforms then
    for i=1,dforms do
      _,_,dactive = GetShapeshiftFormInfo(i);
      if dactive then return i; end
    end
  end
  return 0;
end

function HealBot_GetHealSpell(unit,pattern)
  uName=UnitName(unit);
  
  if HealBot_PlayerDead then return nil end;
 
  if not HealBot_Spells[pattern] then
    ghid = HealBot_GetSpellId(pattern);
  elseif HealBot_Spells[pattern].id then
    ghid = HealBot_Spells[pattern].id
  else
    ghid = HealBot_GetSpellId(pattern);
  end
  ghspell, spellRank = HealBot_GetSpellName(ghid)
  if not ghspell then 
    if pattern then
      if uName~=HealBot_PlayerName then
        if IsItemInRange(pattern,unit)~=1 then
          return nil
        else
          return pattern;
        end
      else
        usable, noMana = IsUsableItem(pattern, unit)
        if not usable then 
          return nil
        else
          return pattern;
        end
      end
    else
      return nil
    end
  end

  if spellRank then
    spellName=ghspell;
    ghspell=ghspell .. "(" .. spellRank .. ")";
  end
  
  if uName~=HealBot_PlayerName then
    if spellName==HEALBOT_PRAYER_OF_HEALING then
      if UnitInParty(unit) then
        --if UnitInRange(unit)~=1 then return nil end;
      	if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, unit)~=1 then return nil end;
      else
        return nil;
      end
    else
      --if UnitInRange(unit)~=1 then return nil end;
      if HealBot_UnitInRange(ghspell, unit)~=1 then return nil end;
    end
  end
 
  return ghspell;
end

function HealBot_RecalcHeals(unit)
  HealBot_Action_Refresh(unit);
end

function HealBot_RecalcParty(HealBot_PreCombat)
  HealBot_Action_PartyChanged(HealBot_PreCombat);
end

function HealBot_RecalcSpells()
  HealBot_FindHealSpells();
end

function HealBot_OnLoad(this)
    HealBot_PlayerClass, HealBot_PlayerClassEN=UnitClass("player")
    HealBot_PlayerRace, HealBot_PlayerRaceEN=UnitRace("player")
    HealBot_PlayerName=UnitName("player")
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("PLAYER_LEAVING_WORLD");
    HealBot:RegisterEvent("PLAYER_REGEN_DISABLED");
    SLASH_HEALBOT1 = "/healbot";
    SLASH_HEALBOT2 = "/hb";
    SlashCmdList["HEALBOT"] = function(msg)
      HealBot_SlashCmd(msg);
    end
	QuickHealth.RegisterCallback(this, "HealthUpdated", function(event, GUID, newHealth)
	    HealBot_OnEvent(this, "HealthUpdated", GUID, newHealth)
	end);
end

local ouName=nil
local aSwitch=0

function HealBot_Set_Timers()
  if HealBot_Config.DisableHealBot==0 then
    HB_Timer1=1
	HB_Timer2=HealBot_Config.RangeCheckFreq
  else
    HB_Timer1=5000
	HB_Timer2=5000
  end
end

local HealBot_ErrorNum=0
function HealBot_OnUpdate(this,arg1)
  if HealBot_Config.DisableHealBot==1 then return end
  HealBot_Timer1 = HealBot_Timer1+arg1;
  HealBot_Timer2 = HealBot_Timer2+arg1;
  HealBot_Timer3 = HealBot_Timer3+arg1;
  if HealBot_Timer2>HB_Timer2 then
    HealBot_Timer2=0
		if not HealBot_Loaded then return end
		if HealBot_Config.ShowAggro==1 then aSwitch=aSwitch+1 end
		if aSwitch>2 then
	  	HealBot_CheckAggro()
	  	aSwitch=0
		else
	  	HealBot_Action_RefreshButtons()
		end
  elseif HealBot_Timer1>=HB_Timer1 then
    HealBot_Timer1 = 0;
	Ti=0;
    if initHealBot then
	    initHealBot=nil
        HealBot_Options_Init(8)
        HealBot_InitSpells()
	    HealBot_Buff_Spells_List=HealBot_Options_InitBuffList()
	    HealBot_AddDebug(HEALBOT_ADDON .. HEALBOT_LOADED);
	    HealBot_Comms_SendAddonMsg("HealBot", ">> SendVersion <<=>> "..HealBot_PlayerName.." <<=>> Version="..HEALBOT_VERSION, HealBot_AddonMsgType, HealBot_PlayerName)	    
        if strsub(HealBot_PlayerClassEN,1,4)=="PRIE" then HealBot_HasInnerFocus(); end
        HealBot_CheckForDivineSpirit=true;
	    HealBot_Comms_SendAddonMsg("HealBot", ">> RequestVersion <<=>> "..HealBot_PlayerName.." <<=>> nil <<", HealBot_AddonMsgType, HealBot_PlayerName)
        if HealBot_Config.AutoClose==0 then HealBot_Config.ActionVisible=1; end
        if HealBot_Config.DisableHealBot==0 and HealBot_Config.ActionVisible==1 then HealBot_Action:Show() end
		HealBot_Options_EmergencyFilter_Reset()
		HealBot_Options_Debuff_Reset()
		HealBot_Options_Buff_Reset()
        if HealBot_Config.DebuffWatch==1 then HealBot_CheckDebuffs=true end
        if HealBot_Config.BuffWatch==1 then HealBot_CheckBuffs=true end
        Delay_RecalcParty=2
	end
    if not HealBot_IsFighting then
      for unit,_ in pairs(HealBot_DelayDebuffCheck) do
		ouName=UnitName(unit)
		if not HealBot_UnitDebuff[ouName] then
           HealBot_CheckUnitDebuffs(unit)
		   Ti=Ti+1
		end
        HealBot_DelayDebuffCheck[unit] = nil;
        if Ti>9 then 
	      do break end;
	    end
      end
      for unit,_ in pairs(HealBot_DelayBuffCheck) do
        if Ti>7 then 
		  do break end;
		end
		ouName=UnitName(unit)
		if not HealBot_UnitBuff[ouName] then
          HealBot_DelayBuffCheck[unit] = nil;
          Ti=Ti+1
        end        
		HealBot_CheckUnitBuffs(unit)
      end
      if HealBot_Reset_flag then
		HealBot_Reset_flag=nil
        HealBot_Reset()
      elseif Delay_RecalcParty>0 and not HealBot_InCombatUpdate then
        Delay_RecalcParty=Delay_RecalcParty+1
        if Delay_RecalcParty>3 then
          Delay_RecalcParty=0;
		  HealBot_Timer2=0-HB_Timer2
          HealBot_RecalcParty();
		  HealBot_InCombatUpdCnt=0
        end
      elseif HealBot_FlagEquipUpdate1>0 and HealBot_FlagEquipUpdate2>0 then
	    HealBot_FlagEquipUpdate1=0;
	    HealBot_FlagEquipUpdate2=0;
	    HealBot_NeedEquipUpdate=1;
	  elseif HealBot_FlagEquipUpdate1>0 then
	    HealBot_FlagEquipUpdate1=HealBot_FlagEquipUpdate1+1;
        if HealBot_FlagEquipUpdate1>3 then
	      HealBot_FlagEquipUpdate1=0;
	    end
      elseif HealBot_FlagEquipUpdate2>0 then
	    HealBot_FlagEquipUpdate2=HealBot_FlagEquipUpdate2+1;
        if HealBot_FlagEquipUpdate2>3 then
	      HealBot_FlagEquipUpdate2=0;
          HealBot_Options_Debuff_Reset();
	    end
      elseif HealBot_CheckZoneFlag>0 then
        HealBot_CheckZoneFlag=HealBot_CheckZoneFlag+1;
        if HealBot_CheckZoneFlag>7 then
          HealBot_CheckZoneFlag=0; 
          HealBot_CheckZone();
        end          
      elseif HealBot_NeedEquipUpdate>0 then
        HealBot_NeedEquipUpdate=HealBot_NeedEquipUpdate+1;
        if HealBot_NeedEquipUpdate>5 then
          HealBot_CalcEquipBonus=true;
          HealBot_NeedEquipUpdate=0; 
          HealBot_RecalcSpells();
        end          
      elseif HealBot_CheckForDivineSpirit then
        HealBot_CheckForDivineSpirit=false
        Tcnt=0;
        Ti=1;
        while true do
          Tname,_,_,_,_,_ = UnitBuff("player",Ti) 
          if Tname then
            if Tname==HEALBOT_DIVINE_SPIRIT or Tname==HEALBOT_PRAYER_OF_SPIRIT then
              Tcnt=1;
              do break end;
            end
            Ti = Ti + 1;
          else
            do break end
          end
        end
        if Tcnt~=HealBot_HasDivineSpirit then
          HealBot_HasDivineSpirit=Tcnt;
          HealBot_NeedEquipUpdate=1;
        end
      end
    else
	  HealsIn_Timer=0;
    end
    HealBot_SpamCnt = 0;
    if HealBot_RequestVer then
      HealBot_Comms_SendAddonMsg("HealBot", ">> SendVersion <<=>> "..HealBot_RequestVer.." <<=>> Version="..HEALBOT_VERSION, HealBot_AddonMsgType, HealBot_PlayerName)
      HealBot_RequestVer=nil;
    end
    
    for j in pairs(HealBot_Ressing) do
      if HealBot_Ressing[j]=="_NIL_" then 
        HealBot_Ressing[j]=nil;
		if HealBot_UnitID[j] then HealBot_Action_ResetUnitStatus(HealBot_UnitID[j]) end
       elseif HealBot_Ressing[j]=="_RESSED2_" then 
        HealBot_Ressing[j]="_NIL_"
      elseif HealBot_Ressing[j]=="_RESSED1_" then 
        HealBot_Ressing[j]="_RESSED2_";
      elseif HealBot_Ressing[j]=="_RESSED_" then 
        HealBot_Ressing[j]="_RESSED1_";
      end
    end

    for k in pairs(HealBot_HoT1) do
      HealBot_HoT1[k]=HealBot_HoT1[k]-1; 
      if HealBot_HoT1[k]<15 then
         HealBot_HoT_Update(1, HealBot_HoT1[k], k)    
      end
    end
    for k in pairs(HealBot_HoT2) do
      HealBot_HoT2[k]=HealBot_HoT2[k]-1; 
      if HealBot_HoT2[k]<15 then
         HealBot_HoT_Update(2, HealBot_HoT2[k], k)    
      end
    end
    for k in pairs(HealBot_HoT3) do
      HealBot_HoT3[k]=HealBot_HoT3[k]-1; 
      if HealBot_HoT3[k]<15 then
         HealBot_HoT_Update(3, HealBot_HoT3[k], k)    
      end
    end

    for k in pairs(HealBot_HoT_Waiting) do
      HealBot_HoT_Waiting[k]=HealBot_HoT_Waiting[k]-1; 
      if HealBot_HoT_Waiting[k]<=0 then
         HealBot_HoT_Waiting[k]=nil   
         HealBot_HoT_WaitingSpell[k]=nil         
         HealBot_HoT_WaitingSpellName[k]=nil 
       end
    end

    if HealBot_HoT_MendingWatch>0 then
      HealBot_HoT_MendingWatch=HealBot_HoT_MendingWatch-1
      if HealBot_HoT_MendingWatch==0 then
        HealBot_HoT_Mending=0;
      end
    end
	
    for k in pairs(HealBot_HealersIncCnt) do
	  HealBot_HealersIncCnt[k]=HealBot_HealersIncCnt[k]+1; 
      if HealBot_HealersIncCnt[k]>4 then
	     HealBot_Comms_Blacklist[k]=HEALBOT_ADDON_ID
         HealBot_OnEvent_AddonMsg(nil,HEALBOT_ADDON_ID,"ManualStop","HelloWorld",k)
      end
    end
	
    for k in pairs(HealBot_HealsIn) do
      if not HealBot_HealsIncCnt[k] then HealBot_HealsIncCnt[k]=2 end
	  HealBot_HealsIncCnt[k]=HealBot_HealsIncCnt[k]+1; 
      if HealBot_HealsIncCnt[k]>5 then
	     HealBot_HealsIn[k]=nil
		 HealBot_HealsIncCnt[k]=nil
         HealBot_Action_ResetUnitStatus(HealBot_UnitID[k])
      end
    end
	
	if HealBot_InCombatUpdate then
		HealBot_IC_PartyMembersChanged()
    end
  elseif HealBot_Timer3>=0.4 then
    HealBot_Timer3=0
    if HealBot_StopCastTimer>0 then
	  HealBot_StopCastTimer=HealBot_StopCastTimer-1
	end
    HealBot_ThrottleCnt=0
  end
end

function HealBot_RetVersion()
  return HEALBOT_VERSION
end

function HealBot_OnEvent(this, event, arg1,arg2,arg3,arg4)
  if (event=="CHAT_MSG_ADDON") then
    HealBot_OnEvent_AddonMsg(this,arg1,arg2,arg3,arg4);
  elseif (event=="UNIT_AURA") then
    HealBot_OnEvent_UnitAura(this,arg1);
  elseif (event=="UNIT_MANA") then
    HealBot_OnEvent_UnitMana(this,arg1);
  elseif (event=="UNIT_HEALTH" or event=="HealthUpdated") then
    HealBot_OnEvent_UnitHealth(this,arg1);
  elseif (event=="UNIT_COMBAT") then
    HealBot_OnEvent_UnitCombat(this,arg1);
  elseif (event=="UNIT_RAGE") then
    HealBot_OnEvent_UnitMana(this,arg1);
  elseif (event=="UNIT_SPELLCAST_START") then
	HealBot_OnEvent_UnitSpellcastStart(this,arg1)
  elseif (event=="UNIT_SPELLCAST_STOP") then
    HealBot_OnEvent_UnitSpellcastStop(this,arg1);
  elseif (event=="UNIT_ENERGY") then
    HealBot_OnEvent_UnitMana(this,arg1);
  elseif (event=="UNIT_SPELLCAST_FAILED") then
    HealBot_OnEvent_UnitSpellcastFail(this,arg1);
  elseif (event=="UNIT_SPELLCAST_SENT") then
    HealBot_OnEvent_UnitSpellcastSent(this,arg1,arg2,arg3,arg4);  
  elseif (event=="UNIT_SPELLCAST_INTERRUPTED") then
    HealBot_OnEvent_UnitSpellcastFail(this,arg1);
  elseif (event=="UNIT_SPELLCAST_SUCCEEDED") then
    HealBot_OnEvent_UnitSpellcastStop(this,arg1);
  elseif (event=="PLAYER_REGEN_DISABLED") then
    HealBot_OnEvent_PlayerRegenDisabled(this);
  elseif (event=="PLAYER_REGEN_ENABLED") then
    HealBot_OnEvent_PlayerRegenEnabled(this);
  elseif (event=="UNIT_NAME_UPDATE") then
    HealBot_OnEvent_UnitNameUpdate(this,arg1)
  elseif (event=="CHAT_MSG_SYSTEM") then
    HealBot_OnEvent_SystemMsg(this,arg1);
  elseif (event=="PARTY_MEMBERS_CHANGED") then
    HealBot_OnEvent_PartyMembersChanged(this);
  elseif (event=="PLAYER_TARGET_CHANGED") then
    HealBot_OnEvent_PlayerTargetChanged(this);
  elseif (event=="MODIFIER_STATE_CHANGED") then
    HealBot_OnEvent_ModifierStateChange(this,arg1,arg2);
  elseif (event=="UPDATE_INVENTORY_ALERTS") then
    HealBot_OnEvent_PlayerEquipmentChanged(this);
  elseif (event=="UNIT_INVENTORY_CHANGED") then
    HealBot_OnEvent_PlayerEquipmentChanged2(this,arg1);
  elseif (event=="UNIT_PET") then
    HealBot_OnEvent_PartyPetChanged(this);
  elseif (event=="RAID_ROSTER_UPDATE") then
    HealBot_OnEvent_RaidRosterUpdate(this);
  elseif (event=="LEARNED_SPELL_IN_TAB") then
    HealBot_OnEvent_SpellsChanged(this,arg1);
  elseif (event=="PLAYER_ENTERING_WORLD") then
    HealBot_OnEvent_PlayerEnteringWorld(this);
  elseif (event=="PLAYER_LEAVING_WORLD") then
    HealBot_OnEvent_PlayerLeavingWorld(this);
  elseif (event=="CHARACTER_POINTS_CHANGED") then
    HealBot_OnEvent_TalentsChanged(this, arg1);
  elseif (event=="ZONE_CHANGED_NEW_AREA") then
    HealBot_OnEvent_ZoneChanged(this);
  elseif (event=="VARIABLES_LOADED") then
    HealBot_OnEvent_VariablesLoaded(this);
  else
    HealBot_AddDebug("OnEvent (" .. event .. ")");
  end
end

function HealBot_OnEvent_VariablesLoaded(this)
    table.foreach(HealBot_ConfigDefaults, function (key,val)
      if not HealBot_Config[key] then
        HealBot_Config[key] = val;
      end
    end);
    if not HealBot_Config.CDCBarColour[HEALBOT_CUSTOM_en] then
    	HealBot_Config.CDCBarColour[HEALBOT_CUSTOM_en] = HealBot_ConfigDefaults.CDCBarColour[HEALBOT_CUSTOM_en]
    end	
    HealBot_Class_En[HEALBOT_DRUID]="DRUI"
    HealBot_Class_En[HEALBOT_HUNTER]="HUNT"
    HealBot_Class_En[HEALBOT_MAGE]="MAGE"
    HealBot_Class_En[HEALBOT_PALADIN]="PALA"
    HealBot_Class_En[HEALBOT_PRIEST]="PRIE"
    HealBot_Class_En[HEALBOT_ROGUE]="ROGU"
    HealBot_Class_En[HEALBOT_SHAMAN]="SHAM"
    HealBot_Class_En[HEALBOT_WARLOCK]="WARL"
    HealBot_Class_En[HEALBOT_WARRIOR]="WARR"
	HealBot_Loaded=true;
	HealBot_OnEvent_PlayerEnteringWorld(nil);
	QuickHealth.RegisterCallback(this, "HealthUpdated", function(event, GUID, newHealth)
	    HealBot_OnEvent(this, "HealthUpdated", GUID, newHealth)
	end);
end

function HealBot_Register_Events()
 if HealBot_Config.DisableHealBot==0 then
    HealBot:RegisterEvent("PLAYER_REGEN_DISABLED");
    HealBot:RegisterEvent("PLAYER_REGEN_ENABLED");
    HealBot:RegisterEvent("PLAYER_TARGET_CHANGED");
    HealBot:RegisterEvent("PARTY_MEMBERS_CHANGED");
    HealBot:RegisterEvent("UNIT_HEALTH");
    if HealBot_Config.bar2size[HealBot_Config.Current_Skin]>0 then HealBot_Register_Mana() end
    HealBot:RegisterEvent("LEARNED_SPELL_IN_TAB");
    HealBot:RegisterEvent("UNIT_SPELLCAST_START");
    HealBot:RegisterEvent("UNIT_AURA");
    HealBot:RegisterEvent("CHARACTER_POINTS_CHANGED");
    HealBot:RegisterEvent("UPDATE_INVENTORY_ALERTS");
    HealBot:RegisterEvent("UNIT_INVENTORY_CHANGED");
    HealBot:RegisterEvent("CHAT_MSG_ADDON");
    HealBot:RegisterEvent("CHAT_MSG_SYSTEM");
    HealBot:RegisterEvent("MODIFIER_STATE_CHANGED");
    HealBot:RegisterEvent("UNIT_PET");
    HealBot:RegisterEvent("UNIT_NAME_UPDATE");
    if HealBot_Config.ShowAggro==1 then HealBot_Register_Aggro() end
	HealBot:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	HealBot:RegisterEvent("RAID_ROSTER_UPDATE");
--    HealBot:RegisterEvent("PARTY_MEMBER_DISABLE");
--    HealBot:RegisterEvent("PARTY_MEMBER_ENABLE");
    HealBot_Comms_SendAddonMsg("CTRA", "SR", HealBot_AddonMsgType, HealBot_PlayerName)
  end
  HealBot:RegisterEvent("UNIT_SPELLCAST_SENT");
  HealBot:RegisterEvent("CHAT_MSG_ADDON");
  HealBot:RegisterEvent("UNIT_SPELLCAST_STOP");
  HealBot:RegisterEvent("UNIT_SPELLCAST_FAILED");
  HealBot:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
  HealBot:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
  
  HealBot_Set_Timers()
  HealBot_Action_Set_Timers()
  HealBot_Options_Set_Timers()
end

function HealBot_Register_Aggro()
  HealBot:RegisterEvent("UNIT_COMBAT")
end

function HealBot_UnRegister_Aggro()
  HealBot:UnregisterEvent("UNIT_COMBAT")
end

function HealBot_Register_Mana()
  HealBot:RegisterEvent("UNIT_MANA")
  HealBot:RegisterEvent("UNIT_RAGE")
  HealBot:RegisterEvent("UNIT_ENERGY")
end

function HealBot_UnRegister_Mana()
  HealBot:UnregisterEvent("UNIT_MANA")
  HealBot:UnregisterEvent("UNIT_RAGE")
  HealBot:UnregisterEvent("UNIT_ENERGY")
end

function HealBot_UnRegister_Events()

    HealBot:UnregisterEvent("ZONE_CHANGED_NEW_AREA");
    HealBot:UnregisterEvent("PLAYER_REGEN_DISABLED");
    HealBot:UnregisterEvent("PLAYER_REGEN_ENABLED");
    HealBot:UnregisterEvent("PLAYER_TARGET_CHANGED");
    HealBot:UnregisterEvent("PARTY_MEMBERS_CHANGED");
    HealBot:UnregisterEvent("UNIT_HEALTH");
    HealBot_UnRegister_Mana()
    HealBot:UnregisterEvent("LEARNED_SPELL_IN_TAB");
    HealBot:UnregisterEvent("UNIT_SPELLCAST_SENT");
    HealBot:UnregisterEvent("UNIT_SPELLCAST_START");
    HealBot:UnregisterEvent("UNIT_SPELLCAST_STOP");
    HealBot:UnregisterEvent("UNIT_SPELLCAST_FAILED");
    HealBot:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
    HealBot:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    HealBot:UnregisterEvent("UNIT_AURA");
    HealBot:UnregisterEvent("CHARACTER_POINTS_CHANGED");
    HealBot:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
    HealBot:UnregisterEvent("UNIT_INVENTORY_CHANGED");
    HealBot:UnregisterEvent("CHAT_MSG_ADDON");
    HealBot:UnregisterEvent("CHAT_MSG_SYSTEM");
    HealBot:UnregisterEvent("MODIFIER_STATE_CHANGED");
    HealBot:UnregisterEvent("UNIT_PET");
    HealBot:UnregisterEvent("UNIT_NAME_UPDATE");
	HealBot:UnregisterEvent("RAID_ROSTER_UPDATE");
    HealBot_UnRegister_Aggro()
	
	HB_Timer2=50
	HealBot_Action_Set_Timers(true)
	HealBot_Options_Set_Timers(true)
	
--    HealBot:UnregisterEvent("PARTY_MEMBER_DISABLE");
--    HealBot:UnregisterEvent("PARTY_MEMBER_ENABLE");
end

function HealBot_CheckAggro()
  for aUnit,oUnit in pairs(HealBot_Aggro) do 
    if UnitIsEnemy(aUnit, aUnit.."target") then
	  tauName=UnitName(aUnit.."targettarget")
	  if tauName~=UnitName(aUnit) then
	    if UnitIsEnemy(oUnit, oUnit.."target") then
		  tauName=UnitName(oUnit.."targettarget")
		  if tauName~=UnitName(aUnit) then
		    HealBot_SetAggro(oUnit)
            HealBot_Aggro[aUnit]=nil
            HealBot_Action_UpdateAggro(aUnit,false)
		  end
		else
		  HealBot_SetAggro(aUnit)
          HealBot_Aggro[aUnit]=nil
          HealBot_Action_UpdateAggro(aUnit,false)
		end
      end
	elseif UnitIsEnemy(oUnit, oUnit.."target") then
	  tauName=UnitName(oUnit.."targettarget")
	  if tauName~=UnitName(aUnit) then
	    HealBot_SetAggro(oUnit)
        HealBot_Aggro[aUnit]=nil
        HealBot_Action_UpdateAggro(aUnit,false)
	  end
	else
      HealBot_Aggro[aUnit]=nil
      HealBot_Action_UpdateAggro(aUnit,false)
	end
  end
end

function HealBot_SetAggro(unit)
    tauName=UnitName(unit.."targettarget")
	hbUnit=HealBot_UnitID[tauName]
	if hbUnit and not HealBot_Aggro[hbUnit] then
      HealBot_Aggro[hbUnit]=unit
	  HealBot_Action_UpdateAggro(hbUnit,true)
	end
end

function HealBot_RetSetAggroSize()
  z=0
  for aUnit,oUnit in pairs(HealBot_Aggro) do 
	  z=z+1
  end
  return z
end

function HealBot_ClearAggro()
  for aUnit,oUnit in pairs(HealBot_Aggro) do 
	HealBot_Aggro[aUnit]=nil
	HealBot_Action_UpdateAggro(aUnit,false)
  end
end

local HealBotAddonSummary={}
local HealBotAddonIncHeals={}
function HealBot_OnEvent_AddonMsg(this,addon_id,msg,distribution,sender_id)
--  inc_msg = gsub(msg, "%$", "s");
--  inc_msg = gsub(inc_msg, "§", "S");
  inc_msg=msg
  sender_id = string.match(sender_id, "^[^-]*")
  heal_val=nil
  if not HealBotAddonSummary[addon_id] then
    HealBotAddonSummary[addon_id]=1
  else
    HealBotAddonSummary[addon_id]=HealBotAddonSummary[addon_id]+1
  end
  if addon_id==HEALBOT_ADDON_ID or addon_id=="VisualHeal" or addon_id=="HealComm" or addon_id=="CastCommLib" or addon_id=="X-PerlHeal" then
    if HealBot_Healers[sender_id] then
	  if HealBot_Comms_Blacklist[sender_id]==addon_id then
        _,_,heal_val,unitname = string.find(HealBot_Healers[sender_id], ">> (.%d+) <<=>> (.+)$" )
        if heal_val then heal_val=0-tonumber(heal_val) end
	  end
	  if unitname and heal_val then
		HealBot_Healers[sender_id]=nil
		HealBot_HealersIncCnt[sender_id]=nil
        if HealBot_TabHealers[sender_id] then
          unitname = HealBot_TabHealers[sender_id]
		  HealBot_TabHealers[sender_id] = nil
		end
	  end
	elseif HealBot_UnitID[sender_id] then
	  if addon_id==HEALBOT_ADDON_ID then
	    _,_,heal_val,unitname = strfind(inc_msg, ">> (.%d+) <<=>> (.+)$" )
		if strfind(unitname,":") then unitname = HealBot_Split(unitname, ":"); end
	  elseif addon_id=="CastCommLib" then
	    arr = strsub(inc_msg, 1, 2)
	    if arr=="C " then
	      spell, rank, _, _, _, _, _ = UnitCastingInfo(HealBot_UnitID[sender_id])
	      if spell and rank and HealBot_Spells[spell.."("..rank..")"] then 
		    unitname = strsub(inc_msg, 3, -1)
	        heal_val=HealBot_Spells[spell.."("..rank..")"].HealsDur 
          end
		end
	  elseif addon_id=="HealComm" then
	    arr = tonumber(strsub(inc_msg, 1, 3))
	    if arr==0 then
          heal_val = tonumber(strsub(inc_msg, 4, 8))
          unitname = strsub(inc_msg, 9, -1)
        elseif arr==2 then
          heal_val = tonumber(strsub(inc_msg, 4, 8))
		  unitname = HealBot_Split(strsub(inc_msg, 9, -1), ":");
        end	
	  elseif addon_id=="X-PerlHeal" then
	    datatype, unitname = strmatch(msg, "^(%a+) (%a+)$")
        if datatype=="HEAL" then
          spell, rank, _, _, _, _, _ = UnitCastingInfo(HealBot_UnitID[sender_id])
	      if spell and rank and HealBot_Spells[spell.."("..rank..")"] then 
	        heal_val=HealBot_Spells[spell.."("..rank..")"].HealsDur 
		  end
	    end
	  elseif addon_id=="VisualHeal" then
	    _, _, unitname, heal_val = strfind(inc_msg, "^%d+:(.+):(%d+):")
	  end
	  if heal_val and tonumber(heal_val)<1 then heal_val=nil end
	  if unitname and heal_val then
		if (type(unitname) == "table") then
		  HealBot_Healers[sender_id] = ">> "..heal_val.." <<=>> table"
		  HealBot_TabHealers[sender_id] = unitname
		  table.foreach(unitname, function (index,unitn) HealBot_HealsIncCnt[unitn]=0 end)
		else
          HealBot_Healers[sender_id] = ">> "..heal_val.." <<=>> "..unitname
		  HealBot_HealsIncCnt[unitname]=0
		end
		HealBot_Comms_Blacklist[sender_id]=addon_id
		HealBot_HealersIncCnt[sender_id]=0
        arr=addon_id.." : "..sender_id
        if not HealBotAddonIncHeals[arr] then
          HealBotAddonIncHeals[arr]=1
        else
          HealBotAddonIncHeals[arr]=HealBotAddonIncHeals[arr]+1
        end
	  end
	end
    if unitname and heal_val then
      if (type(unitname) == "table") then
        table.foreach(unitname, function (index,unitn)
		  unitn = string.match(unitn, "^[^-]*");
          HealBot_HealsInUpdate(unitn,heal_val)
        end)
      else
	    unitname = string.match(unitname, "^[^-]*")
        HealBot_HealsInUpdate(unitname,heal_val)
--		if addon_id~=HEALBOT_ADDON_ID then HealBot_AddDebug(addon_id..":IncHeal from "..sender_id.."  heal:"..unitname..":"..heal_val) end
      end 
    end
  elseif addon_id=="HealBot" then
    pName=UnitName("player");
    _,_, datatype, sender, datamsg = strfind(inc_msg, ">> (%a+) <<=>> (%a+) <<=>> (.+)");
    if datatype=="RequestVersion" then
      HealBot_RequestVer=sender;
    elseif datatype=="SendVersion" then
	  HealBot_Vers[sender_id]=datamsg
      HealBot_AddDebug(sender_id..":  "..datamsg);
    end
  elseif addon_id=="CTRA" then
    if ( strfind(inc_msg, "#") ) then
      arr = HealBot_Split(inc_msg, "#");
      for k in pairs(arr) do
        HealBot_ParseCTRAMsg(sender_id, arr[k]);
      end
    else
        HealBot_ParseCTRAMsg(sender_id, inc_msg);
    end
  end
end

function HealBot_RetHealBotAddonSummary()
  return HealBotAddonSummary
end

function HealBot_RetHealBotAddonIncHeals()
  return HealBotAddonIncHeals
end

function HealBot_GetInfo()
  return HealBot_Vers
end

function HealBot_Split(msg, char)
  for x,_ in pairs(arrg) do
    arrg[x]=nil;
  end
	while (strfind(msg, char) ) do
		iStart, iEnd = strfind(msg, char);
		tinsert(arrg, strsub(msg, 1, iStart-1));
		msg = strsub(msg, iEnd+1, strlen(msg));
	end
	if ( strlen(msg) > 0 ) then
		tinsert(arrg, msg);
	end
	return arrg;
end

local HealBot_MT=nil
function HealBot_ParseCTRAMsg(sender_id, inc_msg)
    if ( strsub(inc_msg, 1, 3) == "RES" ) then
      if ( inc_msg == "RESNO" ) then
        for j in pairs(HealBot_Ressing) do
          if HealBot_Ressing[j]==sender_id then
            HealBot_Ressing[j] = "_RESSED_";
            break
          end
        end
      else
        _,_, punitname = strfind(inc_msg, "^RES (.+)$");
        if ( punitname ) then
          HealBot_Ressing[punitname] = sender_id;
          HealBot_RecalcHeals(HealBot_UnitID[punitname]);
         end
      end
    elseif ( strsub(inc_msg, 1, 4) == "SET " ) then
      _,_, num, punitname = strfind(inc_msg, "^SET (%d+) (.+)$");
      if ( num and punitname ) then
        for k in pairs(HealBot_MainTanks) do
          if ( HealBot_MainTanks[k] == punitname ) then
            HealBot_MainTanks[k] = nil;
          end
        end
        HealBot_MainTanks[tonumber(num)] = punitname;
		HealBot_MT=true
        Delay_RecalcParty=2;
      end
    elseif ( strsub(inc_msg, 1, 2) == "R " ) then
      _,_, punitname = strfind(inc_msg, "^R (.+)$");
      if ( punitname ) then
        for k in pairs(HealBot_MainTanks) do
          if ( HealBot_MainTanks[k] == punitname ) then
            HealBot_MainTanks[k] = nil;
            Delay_RecalcParty=2;
          end
        end
      end
    end
end

local unit, name, subgroup, className, role;
local mtnum = 0;
function HealBot_OnEvent_RaidRosterUpdate(this)
   HealBot_OnEvent_PartyMembersChanged(this)
   if HealBot_MT then return end
   for x,_ in pairs(HealBot_MainTanks) do
     HealBot_MainTanks[x]=nil;
   end
   mtnum = 0
   for index=1,40 do
      unit = "raid"..index
      if UnitExists(unit) then
         name, _, subgroup, _, _, className, _, _, _, role = GetRaidRosterInfo(index)
         if role == "MAINTANK" then
            mtnum = mtnum + 1
            HealBot_MainTanks[mtnum] = name
         end
      end
   end
   Delay_RecalcParty=2;
end

function HealBot_RetHealsIn(uName)
  return HealBot_HealsIn[uName] or 0;
end

function HealBot_ClearHealsIn(uName)
  if HealBot_HealsIn[uName] then HealBot_HealsIn[uName]=nil end
end

function HealBot_OnEvent_UnitHealth(this,unit)
  unit=HealBot_RaidUnit(unit,UnitName(unit))
    if not HealBot_UnitName[unit] or HealBot_Config.DisableHealBot==1 then return end
    HealBot_RecalcHeals(unit);
	if HealBot_Config.ShowAggro==1 and UnitAffectingCombat(unit) and UnitIsEnemy(unit, unit.."target") then
	  HealBot_SetAggro(unit)
	end
end

function HealBot_OnEvent_UnitMana(this,unit)
  unit=HealBot_RaidUnit(unit,UnitName(unit))
  if not HealBot_UnitName[unit] or HealBot_Config.DisableHealBot==1 then return end
  if HealBot_UnitName[unit]==HealBot_PlayerName then
    if HealBot_Action_TooltipUnit then
       HealBot_Action_RefreshTooltip(HealBot_Action_TooltipUnit);
    elseif HealBot_Action_DisableTooltipUnit then
       HealBot_Tooltip_RefreshDisabledTooltip(HealBot_Action_DisableTooltipUnit);
    end
  end
  HealBot_Action_RefreshBar3(unit)
end

function HealBot_OnEvent_UnitCombat(this,unit)
  unit=HealBot_RaidUnit(unit,UnitName(unit))
  if not HealBot_UnitName[unit] then return end
  if UnitIsEnemy(unit, unit.."target") then
    HealBot_SetAggro(unit)
  end
end

function HealBot_OnEvent_ModifierStateChange(this,arg1,arg2)
  if HealBot_Action_TooltipUnit then
    HealBot_Action_RefreshTooltip(HealBot_Action_TooltipUnit);
  elseif HealBot_Action_DisableTooltipUnit then
    HealBot_Tooltip_RefreshDisabledTooltip(HealBot_Action_DisableTooltipUnit);
  end
end

function HealBot_OnEvent_ZoneChanged(this)
  HealBot_CheckZoneFlag=5
  HealBot_Action_ResetUnitStatus(HealBot_UnitID[HealBot_PlayerName])
end

function HealBot_CheckZone()
  zone = GetRealZoneText()
  if zone==HEALBOT_ZONE_AB or zone==HEALBOT_ZONE_WG  or zone==HEALBOT_ZONE_AV or zone==HEALBOT_ZONE_ES then
    HealBot_InBG=true;
  else
    HealBot_InBG=false;
  end
  HealBot_SetAddonComms()
  Delay_RecalcParty=1
end

function HealBot_OnEvent_UnitAura(this,unit)
  unit=HealBot_RaidUnit(unit,UnitName(unit))
  if not HealBot_Unit_Button[unit] then
    if UnitName("target")==UnitName(unit) then
	  unit="target"
	else
      return;
	end
  end
  uName=HealBot_UnitName[unit]
  if not uName then return end
  
  if HealBot_Config.DebuffWatch==1 then
    if HealBot_Config.DebuffWatchInCombat==0 and HealBot_IsFighting then
      HealBot_DelayDebuffCheck[unit]=true;
    else
      HealBot_CheckUnitDebuffs(unit);
    end
  end
  if HealBot_Config.BuffWatch==1 then 
    if HealBot_Config.BuffWatchInCombat==0 and HealBot_IsFighting then
      HealBot_DelayBuffCheck[unit]=true;
    else
      HealBot_CheckUnitBuffs(unit);
    end
  end
  
  if uName==HealBot_PlayerName and strsub(HealBot_PlayerClassEN,1,4)=="PRIE" then
    HealBot_CheckForDivineSpirit=true;
    if HealBot_InnerFocusTalent then HealBot_CheckForInnerFocus(); end
  end
  
  if unit==HealBot_Action_TooltipUnit then
    HealBot_Action_RefreshTooltip(HealBot_Action_TooltipUnit);
  elseif unit==HealBot_Action_DisableTooltipUnit then
    HealBot_Tooltip_RefreshDisabledTooltip(HealBot_Action_DisableTooltipUnit);
  end
  
  if HealBot_HoT1[uName] then
    HoTActive=HealBot_HasMyBuff(HealBot_HoT1_Spell[uName], unit)
    if not HoTActive then 
      HealBot_HoT1[uName]=0 
      HealBot_HoT_Update(1, HealBot_HoT1[uName], uName)    
    end
  end

  if HealBot_HoT2[uName] then
    HoTActive=HealBot_HasMyBuff(HealBot_HoT2_Spell[uName], unit)
    if not HoTActive then 
      HealBot_HoT2[uName]=0 
      HealBot_HoT_Update(2, HealBot_HoT2[uName], uName)    
    end
  end

  if HealBot_HoT3[uName] then
    HoTActive=HealBot_HasMyBuff(HealBot_HoT3_Spell[uName], unit)
    if not HoTActive then 
      HealBot_HoT3[uName]=0 
      HealBot_HoT_Update(3, HealBot_HoT3[uName], uName)    
    end
  end  
  
  if HealBot_HoT_Waiting[uName] then
    HoTActive=HealBot_HasMyBuff(HealBot_HoT_WaitingSpellName[uName], unit)
    if HoTActive then
      HealBot_HoT_Update(nil, HealBot_Spells[HealBot_HoT_WaitingSpell[uName]].Duration, uName, HealBot_HoT_WaitingSpellName[uName])
      if HealBot_HoT_WaitingSpellName[uName]==HEALBOT_PRAYER_OF_MENDING then
        HealBot_HoT_MendingWith=uName;
      end
      HealBot_HoT_Waiting[uName]=nil   
      HealBot_HoT_WaitingSpell[uName]=nil         
      HealBot_HoT_WaitingSpellName[uName]=nil 
    end
  end  

  if HealBot_HoT_Mending>0 and HealBot_HoT_MendingWith~=uName then
    HoTActive=HealBot_HasMyBuff(HEALBOT_PRAYER_OF_MENDING, unit)
    if HoTActive then
        HealBot_HoT_Update(nil, HealBot_Spells[HEALBOT_PRAYER_OF_MENDING..HEALBOT_RANK_1].Duration, uName, HEALBOT_PRAYER_OF_MENDING)
        HealBot_HoT_MendingWith=uName;
        HealBot_HoT_MendingWatch=40;
    end
  end
  
end

function HealBot_CheckForInnerFocus()
  HealBot_InnerFocus=HealBot_HasBuff(HEALBOT_INNER_FOCUS,"player")
end

function HealBot_HasBuff(buffName, unit)
  hbi=1;
  while true do
    hbName,_,_,_,_,_ = UnitBuff(unit,hbi)
    hbi=hbi+1
    if hbName then
      if hbName==buffName then
        return true;
      end
    else
      do break end;
    end
  end
  return false;
end

function HealBot_HasMyBuff(buffName, unit)
  hbi=1;
  while true do
    hbName,_,_,_,duration,_ = UnitBuff(unit,hbi)
    hbi=hbi+1
    if hbName then
      if hbName==buffName and duration then
        return true;
      end
    else
      do break end;
    end
  end
  return false;
end

function HealBot_CheckAllBuffs(unit)
  if HealBot_Config.BuffWatch==1 then 
    if unit then
	  HealBot_DelayBuffCheck[unit]=true
	else
      for x,_ in pairs(HealBot_DelayBuffCheck) do
        HealBot_DelayBuffCheck[x]=nil;
      end
      for unit,_ in pairs(HealBot_UnitName) do
           HealBot_DelayBuffCheck[unit]=true;
      end
	end
  end
end

function HealBot_ClearAllBuffs()
    for x,_ in pairs(HealBot_DelayBuffCheck) do
      HealBot_DelayBuffCheck[x]=nil;
    end
end

function HealBot_CheckAllDebuffs(unit)
  if HealBot_Config.DebuffWatch==1 then 
    if unit then
	  HealBot_DelayDebuffCheck[unit]=true
	else
      for x,_ in pairs(HealBot_DelayDebuffCheck) do
        HealBot_DelayDebuffCheck[x]=nil;
      end
      for unit,_ in pairs(HealBot_UnitName) do
           HealBot_DelayDebuffCheck[unit]=true;
      end
	end
  end
end

function HealBot_ClearAllDebuffs()
    for x,_ in pairs(HealBot_DelayDebuffCheck) do
      HealBot_DelayDebuffCheck[x]=nil;
    end
end

local DebuffIn=nil
local DebuffClass=nil
local myhTargets=nil
function HealBot_CheckUnitDebuffs(unit)
  unit=HealBot_RaidUnit(unit,UnitName(unit))
  if not HealBot_Unit_Button[unit] then
    return;
  end
  uName=UnitName(unit);
  _,DebuffClass=UnitClass(unit)
  if not DebuffClass then DebuffClass=HealBot_Class_En[HEALBOT_WARRIOR] end
  DebuffType=nil;
  icd = 1;
  DebuffIn=HealBot_UnitDebuff[uName] or "x"
  while true do
    dName,_,_,_,debuff_type = UnitDebuff(unit,icd)
    if dName then
      icd = icd + 1;
      checkthis=false;
      WatchTarget=HealBot_DebuffWatchTarget[debuff_type];
      if HealBot_Config.HealBot_Custom_Debuffs[dName] then
    		debuff_type = HEALBOT_CUSTOM_en;
    		WatchTarget={["Raid"]=true,};
      end
      
      if WatchTarget then 
        if WatchTarget["Raid"] then
          checkthis=true;
        elseif WatchTarget["Party"] and (UnitInParty(unit) or uName==HealBot_PlayerName) then
          checkthis=true;
        elseif WatchTarget["Self"] and uName==HealBot_PlayerName then
		  checkthis=true
		elseif WatchTarget[strsub(DebuffClass,1,4)] then
          checkthis=true;
		elseif WatchTarget["PvP"] and UnitIsPVP("player") then
		  checkthis=true;
        elseif WatchTarget["MainTanks"] then
		 	for i=1, #HealBot_MainTanks do
		 		if uName==HealBot_MainTanks[i] then
		 			checkthis=true;
		 			break;
		 		end
		 	end
        elseif WatchTarget["MyTargets"] then
		 	myhTargets=HealBot_GetMyHealTargets();
		 	for i=1, #myhTargets do
		 		if uName==myhTargets[i] then
		 			checkthis=true;
		 			break;
		 		end
		 	end
        end
       
        if checkthis then
          if HealBot_Config.IgnoreMovementDebuffs==1 and HealBot_Ignore_Movement_Debuffs[dName] then
            checkthis=false;
          elseif HealBot_Config.IgnoreFastDurDebuffs==1 and HealBot_Ignore_FastDur_Debuffs[dName] then
            checkthis=false;
          elseif HealBot_Config.IgnoreNonHarmfulDebuffs==1 and HealBot_Ignore_NonHarmful_Debuffs[dName] then
            checkthis=false;
          elseif HealBot_Config.IgnoreClassDebuffs==1 then
            HealBot_Ignore_Debuffs_Class=HealBot_Ignore_Class_Debuffs[strsub(DebuffClass,1,4)];
            if HealBot_Ignore_Debuffs_Class[dName] then
              checkthis=false;
            end
          end
          if checkthis then
            HealBot_UnitDebuff[uName]=debuff_type
            HealBot_UnitDebuff[uName.."_debuff_name"]=dName
            DebuffType=debuff_type;
            if HealBot_DebuffPriority==debuff_type then
              do break end
            end
          end
        end
      end
    else
      if not DebuffType then 
       if HealBot_UnitDebuff[uName] then
		  HealBot_UnitDebuff[uName] = nil;
	      if HealBot_ThrottleCnt>5 then
	        HealBot_Action_ResetUnitStatus(unit)
	      else
	        HealBot_RecalcHeals(unit)
	    	HealBot_ThrottleCnt=HealBot_ThrottleCnt+1
	      end
	    end
      end
      do break end
    end 
  end

  if HealBot_UnitDebuff[uName] and HealBot_UnitDebuff[uName]~=DebuffIn then
    local inSpellRange = 0; -- added by Diacono
    if (HealBot_UnitDebuff[uName] ~= HEALBOT_CUSTOM_en) and (HealBot_DebuffSpell[HealBot_UnitDebuff[uName]] ~= HEALBOT_STONEFORM) then
    	inSpellRange = HealBot_UnitInRange(HealBot_DebuffSpell[HealBot_UnitDebuff[uName]], unit)
    end
    if inSpellRange == 1 then
      if HealBot_Config.ShowDebuffWarning==1 then
        UIErrorsFrame:AddMessage(uName.." suffers from "..HealBot_UnitDebuff[uName.."_debuff_name"], 
                                 HealBot_Config.CDCBarColour[DebuffType].R,
                                 HealBot_Config.CDCBarColour[DebuffType].G,
                                 HealBot_Config.CDCBarColour[DebuffType].B,
                                 1, UIERRORS_HOLD_TIME);
      end
      if HealBot_Config.SoundDebuffWarning==1 then HealBot_PlaySound(HealBot_Config.SoundDebuffPlay); end
	  if HealBot_ThrottleCnt>5 then
	    HealBot_Action_ResetUnitStatus(unit)
	  else
	    HealBot_RecalcHeals(unit)
		HealBot_ThrottleCnt=HealBot_ThrottleCnt+1
	  end
	else
	  HealBot_Action_ResetUnitStatus(unit)
    end
  end
end

local BuffClass=nil
function HealBot_CheckUnitBuffs(unit)
  unit=HealBot_RaidUnit(unit,UnitName(unit))
  if not HealBot_Unit_Button[unit] then
      return;
  end
    uName=UnitName(unit);
	if not uName then return end
	_,BuffClass=UnitClass(unit)
	if not BuffClass then BuffClass=HealBot_Class_En[HEALBOT_WARRIOR] end
	buffname=nil;
    icb = 1;

  for x,_ in pairs(PlayerBuffs) do
    PlayerBuffs[x]=nil;
  end

    while true do
	  bName,_,_,_,_,_ = UnitBuff(unit,icb) 
      if bName then
        PlayerBuffs[bName]=true
        icb = icb + 1;
      else
        do break end
      end
    end 
     
    for k in pairs(HealBot_BuffWatch) do
      checkthis=false;
      WatchTarget=HealBot_BuffWatchTarget[HealBot_BuffWatch[k]];
      if WatchTarget["Raid"] then
        checkthis=true;
      elseif WatchTarget["Party"] and (UnitInParty(unit) or uName==HealBot_PlayerName) then
        checkthis=true;
      elseif WatchTarget["Self"] and uName==HealBot_PlayerName then 
	    checkthis=true
	  elseif WatchTarget[strsub(BuffClass,1,4)] then
        checkthis=true
	  elseif WatchTarget["PvP"] and UnitIsPVP("player") then
		checkthis=true;
	  elseif WatchTarget["MainTanks"] then
	 	for i=1, #HealBot_MainTanks do
	 		if uName==HealBot_MainTanks[i] then
	 			checkthis=true;
	 			break;
	 		end
	 	end
       elseif WatchTarget["MyTargets"] then
			myhTargets=HealBot_GetMyHealTargets();
			for i=1, #myhTargets do
				if uName==myhTargets[i] then
					checkthis=true;
					break;
				end
			end
     end
       if checkthis then
         if not PlayerBuffs[HealBot_BuffWatch[k]] then
           checkthis=false;
           if HealBot_BuffNameSwap[HealBot_BuffWatch[k]] then
             checkthis=HealBot_BuffNameSwap[HealBot_BuffWatch[k]];
             if not PlayerBuffs[checkthis] then
               buffname=HealBot_BuffWatch[k];
               do break end
             end
           else
             buffname=HealBot_BuffWatch[k];
             do break end
           end
         end
       end
     end
     if buffname then
	   if HealBot_UnitBuff[uName] and HealBot_UnitBuff[uName]==buffname then
	     return
	   else
         HealBot_UnitBuff[uName]=buffname;
	    if HealBot_ThrottleCnt>3 then
	      HealBot_Action_ResetUnitStatus(unit)
	    else
		  HealBot_RecalcHeals(unit)
		  HealBot_ThrottleCnt=HealBot_ThrottleCnt+1
	    end
	   end
     elseif HealBot_UnitBuff[uName] then 
	    HealBot_UnitBuff[uName]=nil
	    if HealBot_ThrottleCnt>3 then
	      HealBot_Action_ResetUnitStatus(unit)
	    else
		  HealBot_RecalcHeals(unit)
		  HealBot_ThrottleCnt=HealBot_ThrottleCnt+1
	    end
     end
     
end

function HealBot_OnEvent_PlayerRegenDisabled(this)
  if not HealBot_Loaded then return end
  if not HealBot_UnitID[HealBot_PlayerName] or HealBot_UnitName["target"] then
    HealBot_RecalcParty(true);
  else
    HealBot_IsFighting = true;
  end
  if HealBot_Config.BuffWatch==1 and HealBot_Config.BuffWatchInCombat==0 then
    for member,_ in pairs(HealBot_UnitBuff) do
	  HealBot_UnitBuff[member]=nil
	  if HealBot_UnitID[member] and HealBot_Unit_Button[HealBot_UnitID[member]] then
        HealBot_RecalcHeals(HealBot_UnitID[member])
        HealBot_DelayBuffCheck[HealBot_UnitID[member]]=true
      end
    end
	if HealBot_UnitID[HealBot_PlayerName] then HealBot_DelayBuffCheck[HealBot_UnitID[HealBot_PlayerName]]=true; end
  end
    
  if HealBot_Config.DebuffWatch==1 and HealBot_Config.DebuffWatchInCombat==0 then
    for member,_ in pairs(HealBot_UnitDebuff) do
	  HealBot_UnitDebuff[member]=nil
	  if HealBot_UnitID[member] and HealBot_Unit_Button[HealBot_UnitID[member]] then
	    HealBot_RecalcHeals(HealBot_UnitID[member])
        HealBot_DelayDebuffCheck[HealBot_UnitID[member]]=true
      end
    end
	if HealBot_UnitID[HealBot_PlayerName] then HealBot_DelayDebuffCheck[HealBot_UnitID[HealBot_PlayerName]]=true; end
  end
  if HealBot_Config.AutoClose==1 and HealBot_Config.ActionVisible==0 and HealBot_Config.DisableHealBot==0 then HealBot_TogglePanel(HealBot_Action) end
end

function HealBot_OnEvent_PlayerRegenEnabled(this)
  HealBot_IsFighting = false;
end

local unUnit=nil
function HealBot_OnEvent_UnitNameUpdate(this,unit)
  unUnit=HealBot_RaidUnit(unit,UnitName(unit))
  if not HealBot_Unit_Button[unUnit] then return end
  if HealBot_UnitName[unUnit] then
    if HealBot_UnitID[UnitName(unUnit)]~=unit then		
	  HealBot_Action_ResetUnitStatus(HealBot_UnitID[UnitName(unUnit)])
    end
    HealBot_UnitName[unUnit]=UnitName(unUnit)
    HealBot_UnitID[UnitName(unUnit)]=unUnit
    HealBot_CheckAllDebuffs(unUnit)
    HealBot_CheckAllBuffs(unUnit)
	b=HealBot_Unit_Button[unUnit]
	b.name=UnitName(unUnit)
	if HealBot_HoT_Active_Button[UnitName(unUnit)] then
	  if HealBot_HoT_Active_Button[UnitName(unUnit)]~=b then
		HealBot_HoT_MoveIcon(HealBot_HoT_Active_Button[UnitName(unUnit)], b, UnitName(unUnit))
		HealBot_HoT_Active_Button[UnitName(unUnit)]=b
      end
    end	
    HealBot_Action_ResetUnitStatus(unUnit)	
  end
end

local ruUnit=nil
function HealBot_RaidUnit(unit,uName)
  if uName==HealBot_PlayerName then
    unit="player"
  elseif GetNumRaidMembers()>0 then
		if unit=="party1" or unit=="party2" or unit=="party3" or unit=="party4" or unit=="unknown" then
      if HealBot_UnitID[uName] and UnitName(HealBot_UnitID[uName])==uName then
        unit=HealBot_UnitID[uName]
	  	else
        for j=1,GetNumRaidMembers() do
          ruUnit = "raid"..j
	      if UnitName(ruUnit)==uName then
	        unit=ruUnit
		    do break end
          end
        end
	  	end
    end
  elseif unit=="unknown" and GetNumPartyMembers()>0 then
    for j=1,GetNumPartyMembers() do
      ruUnit = "party"..j
	  if UnitName(ruUnit)==uName then
	    unit=ruUnit
	    do break end
      end
    end
  end
  return unit
end

local icpmc=false
function HealBot_IC_PartyMembersChanged()
  icpmc=false
  HealBot_InCombatUpdCnt=HealBot_InCombatUpdCnt+1
  if HealBot_InCombatUpdCnt<15 then
    for unit,_ in pairs(HealBot_UpUnitInCombat) do
	  HealBot_UpUnitInCombat[unit]=nil
    end
    for unit,name in pairs(HealBot_UnitName) do
	  if not UnitName(unit) then 
	    HealBot_Action_ResetUnitStatus(unit)
      elseif name~=UnitName(unit) then
	    table.insert(HealBot_UpUnitInCombat,unit)
      end
    end
    table.foreach(HealBot_UpUnitInCombat, function (index,unit)
      HealBot_OnEvent_UnitNameUpdate(nil,unit)
	  icpmc=true
    end)
  end
  if icpmc then
--    HealBot_AddDebug("ReVisit HealBot_IC_PartyMembersChanged")
	HealBot_InCombatUpdCnt=HealBot_InCombatUpdCnt+1
  else
	HealBot_InCombatUpdate=false
	if Delay_RecalcParty<3 then Delay_RecalcParty=3 end
	HealBot_InCombatUpdCnt=0
  end
end

function HealBot_OnEvent_PartyMembersChanged(this)
  if HealBot_IsFighting then HealBot_InCombatUpdate=true end
  Delay_RecalcParty=2
  if HealBot_CheckZoneFlag==0 then HealBot_CheckZoneFlag=1 end
end

function HealBot_OnEvent_PlayerTargetChanged(this)
  if HealBot_Config.TargetHeals==1 and HealBot_FullyLoaded then
    HealBot_RecalcParty();
	if UnitName("target") and not UnitIsEnemy("target", "player") then
	  HealBot_OnEvent_UnitAura(nil,"target")
	end
  end
end

local HealBot_PrevComm=0
function HealBot_SetAddonComms()
  if not HealBot_InBG then
    if GetNumRaidMembers()>0 then
      HealBot_AddonMsgType=2;
    elseif GetNumPartyMembers()>0 then
      HealBot_AddonMsgType=3;
    else
      HealBot_AddonMsgType=4;
    end
  else
    HealBot_AddonMsgType=1;
  end
  if HealBot_PrevComm~=HealBot_AddonMsgType then
    HealBot_PrevComm=HealBot_AddonMsgType
    HealBot_Comms_SendAddonMsg("HealBot", ">> RequestVersion <<=>> "..HealBot_PlayerName.." <<=>> nil <<", HealBot_AddonMsgType, HealBot_PlayerName)
  end
end

function HealBot_OnEvent_PartyPetChanged(this)
  if HealBot_Config.PetHeals==1 and Delay_RecalcParty==0 then
    Delay_RecalcParty=2
  end
end

function HealBot_OnEvent_SystemMsg(this,msg)
  if type(msg)=="string" then
    _,_, deserter = strfind(msg, HB_HASLEFTRAID);
    if not deserter then
      _,_, deserter = strfind(msg, HB_HASLEFTPARTY);
    end
    if msg==HB_YOULEAVETHEGROUP or msg==HB_YOULEAVETHERAID or msg==HB_YOUJOINTHERAID or msg==HB_YOUJOINTHEGROUP then
        Delay_RecalcParty=3;
		HealBot_CheckZoneFlag=5
--    else
      -- find other messges
    end
    if (string.find(msg, HB_ONLINE)) or (string.find(msg, HB_OFFLINE)) then
			msg = string.gsub(msg, "|Hplayer:(%a+)|h(.+)|h", "%1")
			uName = msg:match("(%a+)")
			if UnitInParty(uName) or UnitInRaid(uName) then
				HealBot_Action_RefreshButtons(HealBot_RaidUnit("unknown",uName));
			end
		end
  end
end

function HealBot_OnEvent_PlayerEquipmentChanged(this)
  HealBot_FlagEquipUpdate1=1;
end

function HealBot_OnEvent_PlayerEquipmentChanged2(this,unit)
  if UnitName(unit)==HealBot_PlayerName then
    HealBot_FlagEquipUpdate2=1;
  end
end

function HealBot_OnEvent_SpellsChanged(this, arg1)
  if arg1==0 then return; end
  HealBot_InitSpells()
  HealBot_Buff_Spells_List=HealBot_Options_InitBuffList() -- added by Diacono of Ursin
  HealBot_Options_BuffTxt1_Refresh()
  HealBot_Options_BuffTxt2_Refresh()
  HealBot_Options_BuffTxt3_Refresh()
  HealBot_Options_BuffTxt4_Refresh()
  HealBot_Options_BuffTxt5_Refresh()
  HealBot_Options_BuffTxt6_Refresh()
  HealBot_Options_BuffTxt7_Refresh()
  HealBot_Options_BuffTxt8_Refresh()
	HealBot_Options_BuffTxt9_Refresh()
end

function HealBot_OnEvent_TalentsChanged(this, arg1)
  if strsub(HealBot_PlayerClassEN,1,4)=="PRIE" then HealBot_HasInnerFocus(); end
end

function HealBot_OnEvent_PlayerEnteringWorld(this)
  if not HealBot_Loaded then return end
  if not HealBot_FullyLoaded then
    HealBot_PlayerClass, HealBot_PlayerClassEN=UnitClass("player")
    HealBot_PlayerRace, HealBot_PlayerRaceEN=UnitRace("player")
    HealBot_PlayerName=UnitName("player")
    if not HealBot_Config.DisabledKeyCombo then HealBot_InitNewChar(HealBot_PlayerClassEN) end
    HealBot_InitData();
    HealBot_HoT_Texture[HEALBOT_REJUVENATION]      = "Interface\\Icons\\Spell_Nature_Rejuvenation";
    HealBot_HoT_Texture[HEALBOT_REGROWTH]          = "Interface\\Icons\\Spell_Nature_ResistNature";
    HealBot_HoT_Texture[HEALBOT_LIFEBLOOM]          = "Interface\\Icons\\INV_Misc_Herb_Felblossom.jpg";
    HealBot_HoT_Texture[HEALBOT_RENEW]             = "Interface\\Icons\\Spell_Holy_Renew";
    HealBot_HoT_Texture[HEALBOT_POWER_WORD_SHIELD] = "Interface\\Icons\\Spell_Holy_PowerWordShield";
    HealBot_HoT_Texture[HEALBOT_PRAYER_OF_MENDING] = "Interface\\Icons\\Spell_Holy_PrayerOfMendingtga.jpg";
    HealBot_Action_ResetSkin()
    HealBot_FullyLoaded=true
	initHealBot=true
  end
  if HealBot_Config.HidePartyFrames==1 then
    HealBot_Options_DisablePartyFrame()
  end
  if HealBot_Config.HidePlayerTarget==1 then
    HealBot_Options_DisablePlayerFrame()
    HealBot_Options_DisablePetFrame()
    HealBot_Options_DisableTargetFrame()
  end
  HealBot_Register_Events()
  HealBot_CheckZoneFlag=2
end

function HealBot_OnEvent_PlayerLeavingWorld(this)
  if HealBot_Config.HidePartyFrames==1 then
    HealBot_Options_EnablePartyFrame()
  end
  if HealBot_Config.HidePlayerTarget==1 then
    HealBot_Options_EnablePlayerFrame()
    HealBot_Options_EnablePetFrame()
    HealBot_Options_EnableTargetFrame()
  end
  HealBot_UnRegister_Events();
  HB_Timer1=5
end

function HealBot_OnEvent_UnitSpellcastSent(this,caster,spellname,rank,target)
  target = string.match(target, "^[^-]*");
  if spellname==HEALBOT_PRAYER_OF_HEALING then target=HealBot_PlayerName end
  tUnit = HealBot_UnitID[target];
  if not tUnit then
    if UnitName("target") and UnitName("target")==target then
      tUnit=target
    end
  end
  if caster=="player" and tUnit then
    scsspell=spellname.."("..rank..")"
    HealBot_ClearIncHeal();
    if spellname==HEALBOT_RESURRECTION or spellname==HEALBOT_ANCESTRALSPIRIT or spellname==HEALBOT_REBIRTH or spellname==HEALBOT_REDEMPTION then
      HealBot_IamRessing = target;
      HealBot_IsCasting = true;
      if HealBot_IamRessing then
        HealBot_Comms_SendAddonMsg("CTRA", "RES "..HealBot_IamRessing, HealBot_AddonMsgType, HealBot_PlayerName)
      end
      HealBot_CastingSpell  = scsspell;
      HealBot_CastingTarget = tUnit;
      if HealBot_Config.CastNotify>1 then
        HealBot_CastNotify(scsspell,target)
      end
    elseif HealBot_Spells[scsspell] then
      HealBot_IsCasting = true;
      if HealBot_Spells[scsspell].CastTime>1 then
        HealBot_HealValue=HealBot_Spells[scsspell].HealsDur;
        if spellname==HEALBOT_BINDING_HEAL then
          HealBot_AddIamHealingList(HealBot_PlayerName)
          HealBot_AddIamHealingList(target);
        elseif spellname==HEALBOT_PRAYER_OF_HEALING then
          HealBot_AddIamHealingList(HealBot_PlayerName)
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "party1")==1 then
            HealBot_AddIamHealingList(UnitName("party1"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "party2")==1 then
            HealBot_AddIamHealingList(UnitName("party2"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "party3")==1 then
            HealBot_AddIamHealingList(UnitName("party3"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "party4")==1 then 
            HealBot_AddIamHealingList(UnitName("party4"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "partypet1")==1 then
            HealBot_AddIamHealingList(UnitName("partypet1"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "partypet2")==1 then
            HealBot_AddIamHealingList(UnitName("partypet2"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "partypet3")==1 then
            HealBot_AddIamHealingList(UnitName("partypet3"));
          end
          if HealBot_UnitInRange(HEALBOT_POWER_WORD_FORTITUDE, "partypet4")==1 then
            HealBot_AddIamHealingList(UnitName("partypet4"));
          end
        elseif target then
          HealBot_AddIamHealingList(target)
        end
		HealBot_Comms_SendAddonMsg(HEALBOT_ADDON_ID, ">> "..HealBot_HealValue.." <<=>> "..HealBot_IamHealing, HealBot_AddonMsgType, HealBot_PlayerName)
		HealBot_Timer3=0
		HealBot_StopCastTimer=2
      end
      if HealBot_Spells[scsspell].Duration>0 and HealBot_Config.ShowHoTicons==1 and HealBot_Unit_Button[HealBot_UnitID[target]] then

        if HealBot_HoT1_Spell[target]==spellname then
          HealBot_HoT_Update(nil, HealBot_Spells[scsspell].Duration, target, spellname)
        elseif HealBot_HoT2_Spell[target]==spellname then
          HealBot_HoT_Update(nil, HealBot_Spells[scsspell].Duration, target, spellname)
        elseif HealBot_HoT3_Spell[target]==spellname then
          HealBot_HoT_Update(nil, HealBot_Spells[scsspell].Duration, target, spellname)
        end
        HealBot_HoT_Waiting[target]=HealBot_Spells[scsspell].CastTime+5;
        HealBot_HoT_WaitingSpell[target]=scsspell;
        HealBot_HoT_WaitingSpellName[target]=spellname;
        if spellname==HEALBOT_PRAYER_OF_MENDING then
          HealBot_HoT_Mending=5;
        end;
      end
      HealBot_CastingSpell  = scsspell;
      HealBot_CastingTarget = tUnit;
      if HealBot_Config.CastNotify>1 and HealBot_Config.CastNotifyResOnly==0 then
        HealBot_CastNotify(scsspell,target)
      end
    end
--    if HealBot_IsCasting then HealBot_RecalcHeals(); end
--  else
--    HealBot_AddDebug("UNIT_SPELL_CAST_SENT from player="..UnitName(caster))
  end
end

function HealBot_AddIamHealingList(unitname)
  if HealBot_IamHealing then
    HealBot_IamHealing=HealBot_IamHealing..":"..unitname
  else
    HealBot_IamHealing=unitname
  end
end

local hVal=0
function HealBot_HealsInUpdate(target,healVal)
  hVal=tonumber(healVal)
  if not HealBot_HealsIn[target] then HealBot_HealsIn[target]=0 end
  HealBot_HealsIn[target] = HealBot_HealsIn[target] + hVal
  if HealBot_HealsIn[target]<0 then HealBot_HealsIn[target]=0 end
  if HealBot_Unit_Button[HealBot_UnitID[target]] then
    if HealBot_HealsIn[target]>0 then
	  HealBot_RecalcHeals(HealBot_UnitID[target])
	else
	  HealBot_HealsIn[target]=nil
      HealBot_Action_ResetUnitStatus(HealBot_UnitID[target])
	end
  end
end

function HealBot_CastNotify(spell,target)
  Notify = HealBot_Config.CastNotify;
  chanid=nil;
    if Notify==6 then
      chanid=HealBot_Comms_GetChan(HealBot_Config.NotifyChan) 
      if not chanid then Notify=2 end
    end
    if Notify==5 and GetNumRaidMembers()==0 then Notify = 4 end
    if Notify==4 and GetNumPartyMembers()==0 then Notify = 2 end
    if Notify==3 and not (UnitPlayerControlled(HealBot_CastingTarget) and HealBot_CastingTarget~='player' and HealBot_CastingTarget~='pet') then Notify = 2 end
    if Notify==3 then
      SendChatMessage(format(HEALBOT_CASTINGSPELLONYOU,spell),"WHISPER",nil,target);
    elseif Notify==4 then
      SendChatMessage(format(HEALBOT_CASTINGSPELLONUNIT,spell,target),"PARTY",nil,nil);
    elseif Notify==5 then
      SendChatMessage(format(HEALBOT_CASTINGSPELLONUNIT,spell,target),"RAID",nil,nil);
    elseif Notify==6 then
      SendChatMessage(format(HEALBOT_CASTINGSPELLONUNIT,spell,target),"CHANNEL",nil,chanid);
    else
      HealBot_AddChat(format(HEALBOT_CASTINGSPELLONUNIT,spell,target));
    end
end

function HealBot_Titan_Check()
  if HealBot_HealValue and HealBot_CastingTarget then
    return UnitName(HealBot_CastingTarget), HealBot_HealValue
  else
    return nil
  end
end

local uscSpell=nil
local uscRank=nil
local uscTarget=nil
function HealBot_OnEvent_UnitSpellcastStart(this,caster)
  if not HealBot_UnitID[caster] then return end
end

local uscsuName=nil
function HealBot_OnEvent_UnitSpellcastStop(this,unit)
  uscsuName=UnitName(unit)
  if uscsuName==HealBot_PlayerName then
    if HealBot_IsCasting and HealBot_StopCastTimer==0 then
      HealBot_IsCasting = false;
      HealBot_StopCasting();
--      HealBot_RecalcHeals();
      if HealBot_IamRessing then
        HealBot_Comms_SendAddonMsg("CTRA", "RESNO", HealBot_AddonMsgType, HealBot_PlayerName)
        HealBot_IamRessing=nil;
      end
	end
  end
end

function HealBot_OnEvent_UnitSpellcastFail(this,unit)
  uscsuName=UnitName(unit)
  if uscsuName==HealBot_PlayerName then
    if HealBot_IsCasting then
      HealBot_IsCasting = false;
      HealBot_StopCasting();
      if HealBot_IamRessing then
        HealBot_Comms_SendAddonMsg("CTRA", "RESNO", HealBot_AddonMsgType, HealBot_PlayerName)
        HealBot_IamRessing=nil;
      end
	end
  end
end


local huUnit=nil
function HealBot_HoT_Update(index, secLeft, memberName, spellName)
  huUnit=HealBot_UnitID[memberName]
  if index then
    if secLeft==0 then
      HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], index, 0)
      if index==1 then     
        if HealBot_HoT2[memberName] then
          HealBot_HoT1[memberName]=HealBot_HoT2[memberName];
          HealBot_HoT2[memberName]=nil;
          HealBot_HoT_iconTexture1[memberName]=HealBot_HoT_iconTexture2[memberName];
          HealBot_HoT1_Spell[memberName]=HealBot_HoT2_Spell[memberName];
          HealBot_HoT2_Spell[memberName]=nil;
          HealBot_HoT_ChangeIcon(HealBot_Unit_Button[huUnit], 1, HealBot_HoT_AlphaValue(HealBot_HoT1[memberName]), HealBot_HoT_iconTexture1[memberName])
          if HealBot_HoT3[memberName] then
            HealBot_HoT2[memberName]=HealBot_HoT3[memberName];
            HealBot_HoT3[memberName]=nil;
            HealBot_HoT_iconTexture2[memberName]=HealBot_HoT_iconTexture3[memberName];
            HealBot_HoT2_Spell[memberName]=HealBot_HoT3_Spell[memberName];
            HealBot_HoT3_Spell[memberName]=nil;
            HealBot_HoT_ChangeIcon(HealBot_Unit_Button[huUnit], 2, HealBot_HoT_AlphaValue(HealBot_HoT2[memberName]), HealBot_HoT_iconTexture2[memberName])
            HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], 3, 0)
          else
            HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], 2, 0)
          end
        else
          HealBot_HoT1[memberName]=nil;
          HealBot_HoT1_Spell[memberName]=nil;
          HealBot_HoT_Active_Button[memberName]=nil;
        end
      elseif index==2 then
        if HealBot_HoT3[memberName] then
          HealBot_HoT2[memberName]=HealBot_HoT3[memberName];
          HealBot_HoT3[memberName]=nil;
          HealBot_HoT_iconTexture2[memberName]=HealBot_HoT_iconTexture3[memberName];
          HealBot_HoT2_Spell[memberName]=HealBot_HoT3_Spell[memberName];
          HealBot_HoT3_Spell[memberName]=nil;
          HealBot_HoT_ChangeIcon(HealBot_Unit_Button[huUnit], 2, HealBot_HoT_AlphaValue(HealBot_HoT2[memberName]), HealBot_HoT_iconTexture2[memberName])
          HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], 3, 0)
        else
          HealBot_HoT2[memberName]=nil;
          HealBot_HoT2_Spell[memberName]=nil;
        end
      else
        HealBot_HoT3[memberName]=nil;
        HealBot_HoT3_Spell[memberName]=nil;
      end           
    else
      HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], index, HealBot_HoT_AlphaValue(secLeft))
    end
  else
    addIcon=true
    secLeft=secLeft+4;
    if HealBot_HoT1[memberName] and HealBot_HoT_iconTexture1[memberName]==HealBot_HoT_Texture[spellName] then
        HealBot_HoT1[memberName]=secLeft;
        addIcon=false;
        HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], 1, 1)
    elseif HealBot_HoT2[memberName] and HealBot_HoT_iconTexture2[memberName]==HealBot_HoT_Texture[spellName] then
        HealBot_HoT2[memberName]=secLeft;
        addIcon=false;
        HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], 2, 1)
    elseif HealBot_HoT3[memberName] and HealBot_HoT_iconTexture3[memberName]==HealBot_HoT_Texture[spellName] then
        HealBot_HoT3[memberName]=secLeft;
        addIcon=false;
        HealBot_HoT_UpdateIcon(HealBot_Unit_Button[huUnit], 3, 1)
    end
    if addIcon then
      if not HealBot_HoT1[memberName] then
        HealBot_HoT1[memberName]=secLeft;
        HealBot_HoT_iconTexture1[memberName]=HealBot_HoT_Texture[spellName];
        HealBot_HoT1_Spell[memberName]=spellName;
        HealBot_HoT_ChangeIcon(HealBot_Unit_Button[huUnit], 1, HealBot_HoT_AlphaValue(HealBot_HoT1[memberName]), HealBot_HoT_iconTexture1[memberName])
        HealBot_HoT_Active_Button[memberName]=HealBot_Unit_Button[huUnit];
      elseif not HealBot_HoT2[memberName] then
        HealBot_HoT2[memberName]=secLeft;
        HealBot_HoT_iconTexture2[memberName]=HealBot_HoT_Texture[spellName];
        HealBot_HoT2_Spell[memberName]=spellName;
        HealBot_HoT_ChangeIcon(HealBot_Unit_Button[huUnit], 2, HealBot_HoT_AlphaValue(HealBot_HoT2[memberName]), HealBot_HoT_iconTexture2[memberName])
      elseif not HealBot_HoT3[memberName] then
        HealBot_HoT3[memberName]=secLeft;
        HealBot_HoT3_Spell[memberName]=spellName;
        HealBot_HoT_iconTexture3[memberName]=HealBot_HoT_Texture[spellName];
        HealBot_HoT_ChangeIcon(HealBot_Unit_Button[huUnit], 3, HealBot_HoT_AlphaValue(HealBot_HoT3[memberName]), HealBot_HoT_iconTexture3[memberName])
      end
    end
  end
end

function HealBot_HoT_MoveIcon(oldButton, newButton, memberName)
  if HealBot_HoT1[memberName] then
    HealBot_HoT_UpdateIcon(oldButton, 1, 0)
    HealBot_HoT_ChangeIcon(newButton, 1, HealBot_HoT_AlphaValue(HealBot_HoT1[memberName]), HealBot_HoT_iconTexture1[memberName])
  end
  if HealBot_HoT2[memberName] then
    HealBot_HoT_UpdateIcon(oldButton, 2, 0)
    HealBot_HoT_ChangeIcon(newButton, 2, HealBot_HoT_AlphaValue(HealBot_HoT2[memberName]), HealBot_HoT_iconTexture2[memberName])
  end
  if HealBot_HoT3[memberName] then
    HealBot_HoT_UpdateIcon(oldButton, 3, 0)
    HealBot_HoT_ChangeIcon(newButton, 3, HealBot_HoT_AlphaValue(HealBot_HoT3[memberName]), HealBot_HoT_iconTexture3[memberName])
  end
end

function HealBot_HoT_RemoveIcon(memberName)
  button=HealBot_HoT_Active_Button[memberName];
  if HealBot_HoT1[memberName] then
    HealBot_HoT_UpdateIcon(button, 1, 0)
  end
  if HealBot_HoT2[memberName] then
    HealBot_HoT_UpdateIcon(button, 2, 0)
  end
  if HealBot_HoT3[memberName] then
    HealBot_HoT_UpdateIcon(button, 3, 0)
  end
  HealBot_HoT_Active_Button[memberName]=nil;
end

function HealBot_HoT_RemoveIconButton(button)
  HealBot_HoT_UpdateIcon(button, 1, 0)
  HealBot_HoT_UpdateIcon(button, 2, 0)
  HealBot_HoT_UpdateIcon(button, 3, 0)
end

local Texture=nil
local hbiconcount=nil
function HealBot_HoT_ChangeIcon(name, index, a, Texture)
  if not name then return; end;
  bar = HealBot_Action_HealthBar(name);
  iconName = getglobal(bar:GetName().."Icon"..index);
  iconName:SetTexture(Texture);
  iconName:SetAlpha(a);
  hbiconcount = getglobal(bar:GetName().."Count"..index);
  hbiconcount:SetText(HealBot_HoT_timer(a));
  if a>0 and a<0.5 then
    if (Texture==HealBot_HoT_Texture[HEALBOT_REJUVENATION] or Texture==HealBot_HoT_Texture[HEALBOT_REGROWTH]) then
      y, x, _ = GetSpellCooldown("Swiftmend");
      if x and y and (x+y)==0 then
         hbiconcount:SetTextColor(0,1,0,1);
      else
         hbiconcount:SetTextColor(1,0,0,1);        
      end
    else
      hbiconcount:SetTextColor(1,0,0,1);           
    end
  else
    hbiconcount:SetTextColor(1,1,1,1);
  end    
end

function HealBot_HoT_UpdateIcon(name, index, a)
  if not name then return; end;
  bar = HealBot_Action_HealthBar(name);
  iconName = getglobal(bar:GetName().."Icon"..index);
  iconName:SetAlpha(a);
  Texture=iconName:GetTexture();
  hbiconcount = getglobal(bar:GetName().."Count"..index);
  hbiconcount:SetText(HealBot_HoT_timer(a));
  if a>0 and a<0.5 then
    if (Texture==HealBot_HoT_Texture[HEALBOT_REJUVENATION] or Texture==HealBot_HoT_Texture[HEALBOT_REGROWTH]) then
      y, x, _ = GetSpellCooldown("Swiftmend");
      if x and y and (x+y)==0 then
         hbiconcount:SetTextColor(0,1,0,1);
      else
         hbiconcount:SetTextColor(1,0,0,1);        
      end
    else
      hbiconcount:SetTextColor(1,0,0,1);           
    end
  else
    hbiconcount:SetTextColor(1,1,1,1);
  end    
end 

function HealBot_HoT_AlphaValue(secLeft)
  if secLeft>0 and secLeft<15 then
    return secLeft/15
  else
    return 1
  end
end

function HealBot_HoT_timer(alpha)
  if alpha==0 or alpha==1 then
    return ""
  else
    return tostring(ceil(alpha * 15)-4)
  end
end 

function HealBot_PlaySound(id)
  if id==1 then
    PlaySoundFile("Sound\\Doodad\\BellTollTribal.wav");
  elseif id==2 then
    PlaySoundFile("Sound\\Spells\\Thorns.wav");
  elseif id==3 then
    PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
  end
end

local isRange=0
local isMana=1000
local isSpell="Heal"
function HealBot_InitSpells()
  
  for x,_ in pairs(HealBot_CurrentSpells) do
    HealBot_CurrentSpells[x]=nil;
  end
  
  HealBot_Init_Spells_Defaults(HealBot_PlayerClassEN);
  
  for j in pairs(HealBot_Spells) do
    if not HealBot_Spells[j].HealsExt then
      HealBot_Spells[j].HealsExt=0;
    end
    if not HealBot_Spells[j].RealHealing then
      HealBot_Spells[j].RealHealing=0;
    end
    if not HealBot_Spells[j].HealsDur then
      if HealBot_Spells[j].HealsMax then
        HealBot_Spells[j].HealsDur=HealBot_Spells[j].HealsMax;
      else
        HealBot_Spells[j].HealsDur=0;
      end
    end
	HealBot_InitClearSpellNils(j)
  end

  id = 1
  z = 0;  
  while true do
    spellName, spellRank = HealBot_GetSpellName(id);
    ispell=nil;
    if not spellName then
      do break end
    end
    if spellRank then
      ispell=spellName .. "(" .. spellRank .. ")";
    end
    if (HealBot_Spells[ispell]) then
      HealBot_Spells[ispell].id = id;
      HealBot_InitGetSpellData(ispell, id, HealBot_PlayerClassEN, spellName);
      table.insert(HealBot_CurrentSpells,ispell);
      if HealBot_Spells[ispell].HealsDur>0 and spellName~=HEALBOT_BINDING_HEAL 
                                          and spellName~=HEALBOT_POWER_WORD_SHIELD 
                                          and spellName~=HEALBOT_PRAYER_OF_MENDING then
        table.insert(HealBot_SmartCast_Spells,ispell);
		if HealBot_Spells[ispell].Range>isRange and HealBot_Spells[ispell].Mana<isMana then
		  isRange=HealBot_Spells[ispell].Range
		  isMana=HealBot_Spells[ispell].Mana
		  isSpell=ispell
		end
      end
      z = z + 1;
    end
    id = id + 1;
  end
  HealBot_Action_SetrSpell(isSpell)
  HealBot_AddDebug("Initiated HealBot_CurrentSpells with ".. z .." Spells");
  HealBot_Options_CheckCombos();
  HealBot_Init_SmartCast();
  HealBot_NeedEquipUpdate=1
end

function HealBot_InitData() 
  HealBot_Options_SetSkins();
--  if(CT_RegisterMod) then
--    CT_RegisterMod(HEALBOT_ADDON,"HealBot Options",5,"Interface\\AddOns\\HealBot\\Images\\HealBot","Opens HealBot Options","off",nil,HealBot_ToggleOptions);
--  end
end

function HealBot_InitNewChar(PlayerClassEN)
  if strsub(PlayerClassEN,1,4)=="DRUI" then
    HealBot_Config.EnabledKeyCombo = {
      ["Left"] = HEALBOT_REGROWTH,
      ["ShiftLeft"] = HEALBOT_REGROWTH .. HEALBOT_RANK_7,
      ["CtrlLeft"] = HEALBOT_DISABLED_TARGET,
      ["AltLeft"] =  HEALBOT_ABOLISH_POISON,
      ["Right"] = HEALBOT_HEALING_TOUCH,
      ["ShiftRight"] = HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_8,
      ["CtrlRight"] = HEALBOT_ASSIST,
      ["AltRight"] =  HEALBOT_REMOVE_CURSE,
      ["Middle"] = HEALBOT_REJUVENATION,
      ["ShiftMiddle"] = HEALBOT_REJUVENATION .. HEALBOT_RANK_8,
      ["CtrlMiddle"] = HEALBOT_REJUVENATION .. HEALBOT_RANK_6,
      ["AltMiddle"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["Button4"] = HEALBOT_MARK_OF_THE_WILD,
      ["ShiftButton4"] = HEALBOT_MAJOR_HEALING_POTION,
      ["Button5"] = HEALBOT_FOCUS,
	                                 }
	HealBot_Config.DisabledKeyCombo = {
      ["Left"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_FOCUS,
      ["CtrlLeft"] = HEALBOT_ASSIST,
      ["AltLeft"] = HEALBOT_THORNS,
      ["Right"] = HEALBOT_MARK_OF_THE_WILD,
      ["Middle"] = HEALBOT_REJUVENATION,
      ["AltMiddle"] = HEALBOT_REBIRTH,
	                                 }
  elseif strsub(PlayerClassEN,1,4)=="PALA" then
    HealBot_Config.EnabledKeyCombo = {
      ["Left"] = HEALBOT_FLASH_OF_LIGHT,
      ["ShiftLeft"] = HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_5,
      ["CtrlLeft"] = HEALBOT_DISABLED_TARGET,
      ["AltLeft"] =  HEALBOT_CLEANSE,
      ["Right"] = HEALBOT_HOLY_LIGHT,
      ["ShiftRight"] = HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_8,
      ["CtrlRight"] = HEALBOT_ASSIST,
      ["Middle"] =  HEALBOT_BLESSING_OF_SALVATION,
      ["ShiftMiddle"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["CtrlMiddle"] = HEALBOT_FOCUS,
      ["AltMiddle"] = HEALBOT_MAJOR_HEALING_POTION,
	                                 }
	HealBot_Config.DisabledKeyCombo = {
      ["Left"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_FOCUS,
      ["CtrlLeft"] = HEALBOT_ASSIST,
      ["Right"] = HEALBOT_REDEMPTION,
      ["Middle"] =  HEALBOT_BLESSING_OF_SALVATION,
	                                 }
  elseif strsub(PlayerClassEN,1,4)=="PRIE" then
    HealBot_Config.EnabledKeyCombo = {
      ["Left"] = HEALBOT_FLASH_HEAL,
      ["ShiftLeft"] = HEALBOT_FLASH_HEAL .. HEALBOT_RANK_5,
      ["CtrlLeft"] = HEALBOT_DISABLED_TARGET,
      ["AltLeft"] =  HEALBOT_ABOLISH_DISEASE,
      ["Right"] = HEALBOT_GREATER_HEAL,
      ["ShiftRight"] = HEALBOT_GREATER_HEAL .. HEALBOT_RANK_2,
      ["CtrlRight"] = HEALBOT_ASSIST,
      ["AltRight"] =  HEALBOT_DISPEL_MAGIC,
      ["Middle"] = HEALBOT_RENEW,
      ["ShiftMiddle"] = HEALBOT_RENEW .. HEALBOT_RANK_7,
      ["CtrlMiddle"] = HEALBOT_POWER_WORD_SHIELD,
      ["AltMiddle"] = HEALBOT_PRAYER_OF_HEALING,
      ["Button4"] = HEALBOT_POWER_WORD_FORTITUDE,
      ["ShiftButton4"] = HEALBOT_POWER_WORD_FORTITUDE,
      ["Button5"] = HEALBOT_MAJOR_HEALING_POTION,
      ["ShiftButton5"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["AltButton5"] = HEALBOT_FOCUS,
	                                 }
	HealBot_Config.DisabledKeyCombo = {
      ["Left"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_FOCUS,
      ["CtrlLeft"] = HEALBOT_ASSIST,
      ["AltLeft"] = HEALBOT_RESURRECTION,
      ["Right"] = HEALBOT_POWER_WORD_SHIELD,
      ["AltRight"] = HEALBOT_POWER_WORD_FORTITUDE,
      ["Middle"] = HEALBOT_RENEW,
      ["AltMiddle"] = HEALBOT_DIVINE_SPIRIT,
	                                 }
  elseif strsub(PlayerClassEN,1,4)=="SHAM" then
    HealBot_Config.EnabledKeyCombo = {
      ["Left"] = HEALBOT_LESSER_HEALING_WAVE,
      ["ShiftLeft"] = HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_5,
      ["CtrlLeft"] = HEALBOT_DISABLED_TARGET,
      ["AltLeft"] =  HEALBOT_CURE_POISON,
      ["Right"] = HEALBOT_HEALING_WAVE,
      ["ShiftRight"] = HEALBOT_HEALING_WAVE .. HEALBOT_RANK_8,
      ["CtrlRight"] = HEALBOT_ASSIST,
      ["AltRight"] =  HEALBOT_CURE_DISEASE,
      ["Middle"] = HEALBOT_CHAIN_HEAL,
      ["ShiftMiddle"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["CtrlMiddle"] = HEALBOT_MAJOR_HEALING_POTION,
      ["Button4"] = HEALBOT_FOCUS,
	                                 }
	HealBot_Config.DisabledKeyCombo = {
      ["Left"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_FOCUS,
      ["CtrlLeft"] = HEALBOT_ASSIST,
      ["Right"] = HEALBOT_ANCESTRALSPIRIT,
	                                 }
  elseif strsub(PlayerClassEN,1,4)=="MAGE" then
    HealBot_Config.EnabledKeyCombo = {
      ["Left"] = HEALBOT_REMOVE_LESSER_CURSE,
      ["CtrlLeft"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["Right"] = HEALBOT_ASSIST,
      ["ShiftRight"] = HEALBOT_MAJOR_HEALING_POTION,
	                                 }
	HealBot_Config.DisabledKeyCombo = {
      ["Left"] = HEALBOT_REMOVE_LESSER_CURSE,
      ["CtrlLeft"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["Right"] = HEALBOT_ASSIST,
      ["ShiftRight"] = HEALBOT_MAJOR_HEALING_POTION,
	                                 }
  else
    HealBot_Config.EnabledKeyCombo = {
      ["Left"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["Right"] = HEALBOT_ASSIST,
      ["ShiftRight"] = HEALBOT_MAJOR_HEALING_POTION,
	                                 }
	HealBot_Config.DisabledKeyCombo = {
      ["Left"] = HEALBOT_DISABLED_TARGET,
      ["ShiftLeft"] = HEALBOT_HEAVY_RUNECLOTH_BANDAGE,
      ["Right"] = HEALBOT_ASSIST,
      ["ShiftRight"] = HEALBOT_MAJOR_HEALING_POTION,
	                                 }
  end
  HealBot_Config.HealBotDebuffText = {[1]="",[2]="",[3]=""}
  HealBot_Config.HealBotBuffText = {[1]="",[2]="",[3]="",[4]="",[5]="",[6]="",[7]="",[8]="",[9]=""}
  HealBot_Config.HealBotBuffDropDown = {[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1}
  HealBot_Config.HealBotDebuffDropDown = {[1]=1,[2]=1,[3]=1}
  HealBot_Config.HealBotBuffColR = {[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1}
  HealBot_Config.HealBotBuffColG = {[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1}
  HealBot_Config.HealBotBuffColB = {[1]=1,[2]=1,[3]=1,[4]=1,[5]=1,[6]=1,[7]=1,[8]=1,[9]=1}
end

function HealBot_ToggleOptions()
  HealBot_TogglePanel(HealBot_Options)
end

function HealBot_HasInnerFocus()
	nameTalent,_,_,_,currRank,_ = GetTalentInfo(1,8);
    if nameTalent then
      if nameTalent~=HEALBOT_INNER_FOCUS then
        HealBot_Report_Error( "================================" );
        HealBot_Report_Error( "ERROR: in function HealBot_InnerFocus" );
        HealBot_Report_Error( "ERROR: found talent "..nameTalent.." when expecting "..HEALBOT_INNER_FOCUS );
      end
    end
    if currRank>0 then
      HealBot_InnerFocusTalent=true;
    else
      HealBot_InnerFocusTalent=false;
    end
end

function HealBot_MMButton_UpdatePosition()
	HealBot_ButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (HealBot_Config.HealBot_ButtonRadius * cos(HealBot_Config.HealBot_ButtonPosition)),
		(HealBot_Config.HealBot_ButtonRadius * sin(HealBot_Config.HealBot_ButtonPosition)) - 55
	);
end

function HealBot_MMButton_Init()
	if(HealBot_Config.ButtonShown==1) then
		HealBot_ButtonFrame:Show();
	else
		HealBot_ButtonFrame:Hide();
	end
end

function HealBot_MMButton_OnEnter()
    GameTooltip:SetOwner(this, "ANCHOR_LEFT");
    GameTooltip:SetText(HEALBOT_BUTTON_TOOLTIP);
	GameTooltipTextLeft1:SetTextColor(1, 1, 1);
    GameTooltip:Show();
end

function HealBot_MMButton_OnClick(this,button)
  if button~="RightButton" then
    HealBot_ToggleOptions()
  else
    HealBot_AddDebug("right click")
  end
end

function HealBot_MMButton_BeingDragged()
    -- Thanks to Gello for this code
    w,x = GetCursorPosition() 
    y,z = Minimap:GetLeft(), Minimap:GetBottom() 

    w = y-w/UIParent:GetScale()+70 
    x = x/UIParent:GetScale()-z-70 

    HealBot_MMButton_SetPosition(math.deg(math.atan2(x,w)));
end

function HealBot_MMButton_SetPosition(v)
    if(v < 0) then
        v = v + 360;
    end

    HealBot_Config.HealBot_ButtonPosition = v;
    HealBot_MMButton_UpdatePosition();
end

function HealBot_SmartCast(unit,hdelta)
  retSpell=nil;
  x=0;
  y=0;
  Process=false;
  target=(hdelta-200)*0.88
    table.foreach(HealBot_SmartCast_Spells, function (index,spell)
      if (HealBot_Spells[spell]) then
        if HealBot_Spells[spell].HealsDur<target then
          if HealBot_Spells[spell].Buff then
            if HealBot_HasBuff(HealBot_Spells[spell].Buff,unit) then 
              Process=false;  
            else
              Process=true;
            end;  
          else
            Process=true
          end
          if Process then
            x=(HealBot_Spells[spell].HealsDur/target)*800;
            x=x-(HealBot_Spells[spell].Mana/25);
            x=x/(HealBot_Spells[spell].CastTime+1);
            if x>y then
              y=x;
              retSpell=spell;
            end
          end
        end
      end
    end)
  return retSpell;
end

function HealBot_UnitInRange(spell, unit) -- added by Diacono of Ursin
   local inRange = 0
   if IsSpellInRange(spell, unit) ~= nil then
      inRange = IsSpellInRange(spell, unit)
   elseif IsItemInRange(spell, unit) ~= nil then
      inRange = IsItemInRange(spell, unit)
   elseif UnitInRange(unit) == 1 then
      inRange = 1
   end
   return inRange
end
