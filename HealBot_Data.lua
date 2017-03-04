HealBot_ConfigDefaults = {
  Version = HEALBOT_VERSION,
  FastAttrib=1,
  AlertLevel = 0.80,
  AutoClose = 0,
  PanelSounds = 1,
  SelfHeals = 0,
  GroupHeals = 1,
  TankHeals = 0,
  SelfPet = 0,
  EmergencyHeals = 1,
  PetHeals = 0,
  ActionLocked = 0,
  CastNotify = 0,
  CastNotifyResOnly = 0,
  HideOptions = 0,
  ShowTooltip = 1,
  Tooltip_ShowSpellDetail = 0,
  Tooltip_ShowTarget = 1,
  Tooltip_Recommend = 0,
  Tooltip_PreDefined=1,
  TooltipPos = 3,  
  Panel_Anchor = 1,
  ProtectPvP = 0,
  EmergIncMonitor = 1,
  EmergencyFClass = 4,
  ExtraOrder      = 3,
  ShowDebuffWarning = 1,
  SoundDebuffWarning = 0,
  SoundDebuffPlay = 1,
  CDCMonitor = 1,
  PanelAnchorY = -1,
  PanelAnchorX = -1,
  ShowClassOnBar = 0,
  ShowHealthOnBar = 1,
  BarHealthType = 1,
  BarHealthIncHeals = 1,
  ShowClassOnBarWithName = 0,
  SetClassColourText = 1,
  RightButtonOptions = 1,
  BuffWatch = 1,
  BuffWatchInCombat = 0,
  DebuffWatch = 1,
  DebuffWatchInCombat = 1,
  IgnoreClassDebuffs = 1,
  IgnoreMovementDebuffs = 1,
  IgnoreFastDurDebuffs = 1,
  IgnoreNonHarmfulDebuffs = 1,
  SmartCast = 1,
  SmartCastDebuff = 1,
  SmartCastBuff = 1,
  SmartCastHeal = 1,
  SmartCastRes = 1,
  RangeCheckFreq=0.15,
  HidePartyFrames=0,
  HidePlayerTarget=0,
  DisableHealBot=0,
  HealBot_ButtonRadius=78,
  HealBot_ButtonPosition=300,
  ButtonShown=1,
  NotifyChan="",
  ShowHoTicons=1,
  HoTonBar=1,
  HoTposBar=2,
  UseTargetCombatStatus=1,
  ShowAggro=1,
  ShowAggroText=1,
  ShowAggroBars=0,
  BarFreq=3,
  UseFluidBars=0,
  ttalpha=0.8,
  TargetHeals=0,
  TargetIncSelf=0,
  TargetIncGroup=0,
  TargetIncRaid=1,
  TargetIncPet=0,
  CDCBarColour = {
    [HEALBOT_DISEASE_en] = { R = 0.1, G = 0.05, B = 0.2, },
    [HEALBOT_MAGIC_en] = { R = 0.05, G = 0.05, B = 0.1, },
    [HEALBOT_POISON_en] = { R = 0.05, G = 0.2, B = 0.1, },
    [HEALBOT_CURSE_en] = { R = 0.2, G = 0.05, B = 0.05, },
    [HEALBOT_CUSTOM_en] = { R = 0.45, G = 0, B = 0.26, }, -- added by Diacono
  },
  EmergIncRange = {
    [HEALBOT_DRUID]    = 0, [HEALBOT_HUNTER]   = 1, [HEALBOT_MAGE]     = 1,
    [HEALBOT_PALADIN]  = 0, [HEALBOT_PRIEST]   = 0, [HEALBOT_ROGUE]    = 0,
    [HEALBOT_SHAMAN]   = 0, [HEALBOT_WARLOCK]  = 1, [HEALBOT_WARRIOR]  = 0,
  },
  EmergIncMelee = {
    [HEALBOT_DRUID]    = 0, [HEALBOT_HUNTER]   = 0, [HEALBOT_MAGE]     = 0,
    [HEALBOT_PALADIN]  = 0, [HEALBOT_PRIEST]   = 0, [HEALBOT_ROGUE]    = 1,
    [HEALBOT_SHAMAN]   = 0, [HEALBOT_WARLOCK]  = 0, [HEALBOT_WARRIOR]  = 1,
  },
  EmergIncHealers = {
    [HEALBOT_DRUID]    = 1, [HEALBOT_HUNTER]   = 0, [HEALBOT_MAGE]     = 0,
    [HEALBOT_PALADIN]  = 0, [HEALBOT_PRIEST]   = 1, [HEALBOT_ROGUE]    = 0,
    [HEALBOT_SHAMAN]   = 0, [HEALBOT_WARLOCK]  = 0, [HEALBOT_WARRIOR]  = 0,
  },
  EmergIncCustom = {
    [HEALBOT_DRUID]    = 1, [HEALBOT_HUNTER]   = 0, [HEALBOT_MAGE]     = 1,
    [HEALBOT_PALADIN]  = 1, [HEALBOT_PRIEST]   = 1, [HEALBOT_ROGUE]    = 0,
    [HEALBOT_SHAMAN]   = 1, [HEALBOT_WARLOCK]  = 1, [HEALBOT_WARRIOR]  = 0,
  },
  EnabledKeyCombo=nil,
  DisabledKeyCombo = nil,
  EnableHealthy = 1,
  ActionVisible = 0,
  Current_Skin = HEALBOT_SKINS_STD,
  Skin_ID = 1,
  Skins = {HEALBOT_SKINS_STD, HEALBOT_OPTIONS_GROUPHEALS, HEALBOT_OPTIONS_EMERGENCYHEALS, HEALBOT_ZONE_AV},
  numcols = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 4, [HEALBOT_ZONE_AV] = 2},
  btexture = {[HEALBOT_SKINS_STD] = 8,[HEALBOT_OPTIONS_GROUPHEALS] = 5, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 7, [HEALBOT_ZONE_AV] = 9},
  bcspace = {[HEALBOT_SKINS_STD] = 3, [HEALBOT_OPTIONS_GROUPHEALS] = 3, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 2, [HEALBOT_ZONE_AV] = 2},
  brspace = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 2, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 2, [HEALBOT_ZONE_AV] = 1},
  bwidth =  {[HEALBOT_SKINS_STD] = 131, [HEALBOT_OPTIONS_GROUPHEALS] = 142, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 95, [HEALBOT_ZONE_AV] = 85},
  bheight = {[HEALBOT_SKINS_STD] = 21, [HEALBOT_OPTIONS_GROUPHEALS] = 23, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 17, [HEALBOT_ZONE_AV] = 16},
  btextenabledcolr = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  btextenabledcolg = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  btextenabledcolb = {[HEALBOT_SKINS_STD] = 0, [HEALBOT_OPTIONS_GROUPHEALS] = 0, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0, [HEALBOT_ZONE_AV] = 0},
  btextenabledcola = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  btextdisbledcolr = {[HEALBOT_SKINS_STD] = 0.5, [HEALBOT_OPTIONS_GROUPHEALS] = 0.5, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.5, [HEALBOT_ZONE_AV] = 0.4},
  btextdisbledcolg = {[HEALBOT_SKINS_STD] = 0.5, [HEALBOT_OPTIONS_GROUPHEALS] = 0.5, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.5, [HEALBOT_ZONE_AV] = 0.4},
  btextdisbledcolb = {[HEALBOT_SKINS_STD] = 0.5, [HEALBOT_OPTIONS_GROUPHEALS] = 0.5, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.5, [HEALBOT_ZONE_AV] = 0.4},
  btextdisbledcola = {[HEALBOT_SKINS_STD] = 0.45, [HEALBOT_OPTIONS_GROUPHEALS] = 0.75, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.75, [HEALBOT_ZONE_AV] = 0},
  btextcursecolr = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  btextcursecolg = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  btextcursecolb = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  btextcursecola = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  backcola = {[HEALBOT_SKINS_STD] = 0.05, [HEALBOT_OPTIONS_GROUPHEALS] = 0.25, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.25, [HEALBOT_ZONE_AV] = 0},
  Barcola    = {[HEALBOT_SKINS_STD] = 0.85, [HEALBOT_OPTIONS_GROUPHEALS] = 0.85, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.85, [HEALBOT_ZONE_AV] = 0.85},
  BarcolaInHeal = {[HEALBOT_SKINS_STD] = 0.40, [HEALBOT_OPTIONS_GROUPHEALS] = 0.35, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.35, [HEALBOT_ZONE_AV] = 0.5},
  backcolr = {[HEALBOT_SKINS_STD] = 0.1, [HEALBOT_OPTIONS_GROUPHEALS] = 0.1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.1, [HEALBOT_ZONE_AV] = 0.2},
  backcolg = {[HEALBOT_SKINS_STD] = 0.1, [HEALBOT_OPTIONS_GROUPHEALS] = 0.1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.1, [HEALBOT_ZONE_AV] = 0.2},
  backcolb = {[HEALBOT_SKINS_STD] = 0.7, [HEALBOT_OPTIONS_GROUPHEALS] = 0.7, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.7, [HEALBOT_ZONE_AV] = 0.2},
  borcolr = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 0.2},
  borcolg = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 0.2},
  borcolb = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 0.2},
  borcola = {[HEALBOT_SKINS_STD] = 0.25, [HEALBOT_OPTIONS_GROUPHEALS] = 0.3, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.3, [HEALBOT_ZONE_AV] = 0.1},
  btextheight = {[HEALBOT_SKINS_STD] = 10, [HEALBOT_OPTIONS_GROUPHEALS] = 12, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 9, [HEALBOT_ZONE_AV] = 10},
  bardisa = {[HEALBOT_SKINS_STD] = 0.15, [HEALBOT_OPTIONS_GROUPHEALS] = 0.05, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.75, [HEALBOT_ZONE_AV] = 0},
  bareora = {[HEALBOT_SKINS_STD] = 0.40, [HEALBOT_OPTIONS_GROUPHEALS] = 0.45, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.30, [HEALBOT_ZONE_AV] = 0.05},
  bar2size = {[HEALBOT_SKINS_STD] = 0, [HEALBOT_OPTIONS_GROUPHEALS] = 0, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0, [HEALBOT_ZONE_AV] = 0},
  ShowHeader = {[HEALBOT_SKINS_STD] = 0, [HEALBOT_OPTIONS_GROUPHEALS] = 0, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 0},
  headbarcolr = {[HEALBOT_SKINS_STD] = 0.3, [HEALBOT_OPTIONS_GROUPHEALS] = 0.1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.1, [HEALBOT_ZONE_AV] = 0.1},
  headbarcolg = {[HEALBOT_SKINS_STD] = 0.3, [HEALBOT_OPTIONS_GROUPHEALS] = 0.1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.1, [HEALBOT_ZONE_AV] = 0.1},
  headbarcolb = {[HEALBOT_SKINS_STD] = 0.5, [HEALBOT_OPTIONS_GROUPHEALS] = 0.1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.1, [HEALBOT_ZONE_AV] = 0.1},
  headbarcola = {[HEALBOT_SKINS_STD] = 0.35, [HEALBOT_OPTIONS_GROUPHEALS] = 0.25, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.25, [HEALBOT_ZONE_AV] = 0},
  headtxtcolr = {[HEALBOT_SKINS_STD] = 0.9, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  headtxtcolg = {[HEALBOT_SKINS_STD] = 0.9, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  headtxtcolb = {[HEALBOT_SKINS_STD] = 0.4, [HEALBOT_OPTIONS_GROUPHEALS] = 0.1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.1, [HEALBOT_ZONE_AV] = 0.1},
  headtxtcola = {[HEALBOT_SKINS_STD] = 1, [HEALBOT_OPTIONS_GROUPHEALS] = 1, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 1, [HEALBOT_ZONE_AV] = 1},
  headtexture = {[HEALBOT_SKINS_STD] = 6, [HEALBOT_OPTIONS_GROUPHEALS] = 11, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 12, [HEALBOT_ZONE_AV] = 12},
  headwidth   = {[HEALBOT_SKINS_STD] = 0.65, [HEALBOT_OPTIONS_GROUPHEALS] = 0.9, [HEALBOT_OPTIONS_EMERGENCYHEALS] = 0.9, [HEALBOT_ZONE_AV] = 0.9},
  ExtraIncGroup = {[1] = true, [2] = true, [3] = true, [4] = true, 
                   [5] = true, [6] = true, [7] = true, [8] = true},
  HealBotDebuffText=nil,
  HealBotBuffText=nil,
  HealBotBuffDropDown=nil,
  HealBotDebuffDropDown=nil,
  HealBotBuffColR=nil,
  HealBotBuffColG=nil,
  HealBotBuffColB=nil,

	HealBot_Custom_Debuffs = {
  	--[GetSpellInfo(32407)] = true, -- Strange Aura in Cenarion Thicket - used for debugging
  	[GetSpellInfo(31249)] = true, -- Rage Winterchill - Icebolt
  	[GetSpellInfo(40604)] = true, -- Bloodboil - Fel Rage
  	[GetSpellInfo(40616)] = true, -- Bloodboil - Fel Rage 2
  	[GetSpellInfo(40585)] = true, -- Illidan - Dark Barrage 
  	[GetSpellInfo(46394)] = true, -- Brutallus - Burn                                 
	}, -- Added by Diacono - Custom Debuffs
};

HealBot_Config = {};

HealBot_UnitDebuff = {};
HealBot_UnitBuff = {};
HealBot_EmergInc = {}
HealBot_Class_En = {}

HEALBOT_ADDON_ID="HealBot_Heals"

HealBot_OtherSpells = {};
HealBot_Spells = {};
HealBot_DebuffSpell = {};
HealBot_IsFighting = false;

HealBot_Action_TooltipUnit=nil;
Delay_RecalcParty=0;
HealBot_MainTanks={};
SmartCast_Res=nil;
HealBot_PlayerClass=nil;
HealBot_PlayerClassEN=nil;
HealBot_PlayerRace=nil;
HealBot_PlayerRaceEN=nil;
HealBot_UnitName = {};
HealBot_UnitID = {};
HealBot_PlayerName=nil;
HealBot_CastingTarget = nil;
HealBot_InnerFocus=false;
HealBot_Unit_Button={};
HealBot_HoT_Active_Button={};
HealBot_BuffWatchTarget={}
HealBot_DebuffPriority="none"
HealBot_BuffWatch={}
HealBot_DebuffWatchTarget={}
HealBot_DebuffWatchPvP={}
HealBot_BuffWatchPvP={}
