
 
local i=nil
local HB_mana=nil
local HB_cast=nil
local HB_HealsMin=nil
local HB_HealsMax=nil
local HB_HealsExt=nil
local HB_duration=nil
local HB_range=nil
local HB_shield=nil
local HB_channel=nil
local tmpText=nil
local line=nil
local tmpTest=nil
local tonumber=tonumber
local strfind=strfind
local floor=floor

function HealBot_InitGetSpellData(spell, id, class, spellname)

  if ( not spell ) then return; end
  
  HB_cast=nil
  HB_mana=nil
  HB_range=nil
  HB_HealsMin=nil
  HB_HealsMax=nil
  HB_HealsExt=nil
  HB_duration=nil
  HB_shield=nil
  HB_channel=nil
   
  HealBot_TooltipInit();
  HealBot_ScanTooltip:SetSpell( id, BOOKTYPE_SPELL );
  tmpText = getglobal("HealBot_ScanTooltipTextLeft2");
  if (tmpText:GetText()) then
    line = tmpText:GetText();
    tmpTest,tmpTest,HB_mana = strfind(line, HB_TOOLTIP_MANA ); 
  end

  tmpText = getglobal("HealBot_ScanTooltipTextRight2");
  if (tmpText:GetText()) then
    line = tmpText:GetText();
    tmpTest,tmpTest,HB_range = strfind(line, HB_TOOLTIP_RANGE ); 
  else
    HB_range="30";
  end  

  tmpText = getglobal("HealBot_ScanTooltipTextLeft3");
  if (tmpText:GetText()) then
    line = tmpText:GetText();
    if ( line == HB_TOOLTIP_INSTANT_CAST ) then
      HB_cast = 0;
    elseif line == HB_TOOLTIP_CHANNELED then
	  HB_cast = 0;
	elseif ( tmpText ) then
      tmpTest,tmpTest,HB_cast = strfind(line, HB_TOOLTIP_CAST_TIME ); 
    end
  end  

  tmpText = getglobal("HealBot_ScanTooltipTextLeft4");
  tmpTest = nil;
  if (tmpText:GetText()) then
    line = tmpText:GetText();
	if strsub(class,1,4)=="PRIE" then
      if spellname==HEALBOT_POWER_WORD_SHIELD then
        tmpTest,tmpTest,HB_HealsMin,HB_shield = strfind(line, HB_SPELL_PATTERN_SHIELD );    
        HB_HealsExt=0;
        HB_duration = 30;
	    HB_HealsMax=HB_HealsMin;
      elseif spellname==HEALBOT_RENEW then
        tmpTest,tmpTest,HB_HealsExt,tmpTest,HB_duration = strfind(line, HB_SPELL_PATTERN_RENEW );  
        HB_HealsMin=0;
        HB_HealsMax=0;
        if ( HB_HealsExt == nil ) then
          tmpTest,tmpTest,HB_HealsExt,HB_duration = strfind(line, HB_SPELL_PATTERN_RENEW1 );
        end
        if ( HB_HealsExt == nil ) then
          tmpTest,tmpTest,HB_duration,HB_HealsExt = strfind(line, HB_SPELL_PATTERN_RENEW2 );
        end
        if ( HB_HealsExt == nil ) then
          tmpTest,tmpTest,HB_duration,HB_HealsExt = strfind(line, HB_SPELL_PATTERN_RENEW3 );
        end
      elseif spellname==HEALBOT_LESSER_HEAL then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line,HB_SPELL_PATTERN_LESSER_HEAL); 
      elseif spellname==HEALBOT_GREATER_HEAL then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_GREATER_HEAL ); 
      elseif spellname==HEALBOT_FLASH_HEAL then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_FLASH_HEAL ); 
      elseif spellname==HEALBOT_HEAL then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_HEAL ); 
      end
    elseif strsub(class,1,4)=="DRUI" then
      if spellname==HEALBOT_REGROWTH then
        tmpTest,tmpTest,HB_HealsMin,HB_HealsMax,HB_HealsExt = strfind(line, HB_SPELL_PATTERN_REGROWTH );
        if ( tmpTest == nil ) then
          tmpTest,tmpTest,HB_HealsMin,HB_HealsMax,tmpTest,HB_HealsExt = strfind(line, HB_SPELL_PATTERN_REGROWTH1 );
        end
      elseif spellname==HEALBOT_REJUVENATION then
        tmpTest,tmpTest,HB_HealsExt,HB_duration = strfind(line, HB_SPELL_PATTERN_REJUVENATION );  
        HB_HealsMin=0;
        HB_HealsMax=0;
        if ( HB_HealsExt == nil ) then
          tmpTest,tmpTest,HB_HealsExt,tmpTest,HB_duration = strfind(line, HB_SPELL_PATTERN_REJUVENATION1 );
        end
        if ( HB_HealsExt == nil ) then
          tmpTest,tmpTest,HB_duration,HB_HealsExt = strfind(line, HB_SPELL_PATTERN_REJUVENATION2 );
        end
      elseif spellname==HEALBOT_HEALING_TOUCH then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_HEALING_TOUCH ); 
      end
	elseif strsub(class,1,4)=="PALA" then
      if spellname==HEALBOT_HOLY_LIGHT then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_HOLY_LIGHT ); 
      elseif spellname==HEALBOT_FLASH_OF_LIGHT then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_FLASH_OF_LIGHT ); 
      end
	elseif strsub(class,1,4)=="SHAM" then
      if spellname==HEALBOT_HEALING_WAVE then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_HEALING_WAVE ); 
      elseif spellname==HEALBOT_LESSER_HEALING_WAVE then
        tmpTest,HB_HealsMin,HB_HealsMax = HealBot_Generic_Patten(line, HB_SPELL_PATTERN_LESSER_HEALING_WAVE ); 
      end
	end
  end  


  if HB_cast then
    HealBot_Spells[spell].CastTime=tonumber(HB_cast);
  end
  if HB_mana then
    HealBot_Spells[spell].Mana=tonumber(HB_mana);
  end
  if HB_range then
    HealBot_Spells[spell].Range=tonumber(HB_range);
  end
  if HB_HealsMin then
    HealBot_Spells[spell].HealsMin=tonumber(HB_HealsMin);
  end
  if HB_HealsMax then
    HealBot_Spells[spell].HealsMax=tonumber(HB_HealsMax);
  end
  if HB_HealsExt then
    HealBot_Spells[spell].HealsExt=tonumber(HB_HealsExt);
  end
  if HB_duration then
    HealBot_Spells[spell].Duration=tonumber(HB_duration);
  end
  if HB_shield then
    HealBot_Spells[spell].Shield=tonumber(HB_shield);
  end
  if HB_channel then
    HealBot_Spells[spell].Channel=tonumber(HB_channel);
  end
  HealBot_InitClearSpellNils(spell)
end

function HealBot_InitClearSpellNils(spell)
  if not HealBot_Spells[spell].CastTime then
    HealBot_Spells[spell].CastTime=0;
    HealBot_Spells[spell].Cast=0;
  end
  if not HealBot_Spells[spell].Cast then 
    HealBot_Spells[spell].Cast=0;
  end
  if not HealBot_Spells[spell].Mana then
    HealBot_Spells[spell].Mana=10*UnitLevel("player");
  end
  if not HealBot_Spells[spell].Range then
    HealBot_Spells[spell].Range=40;
  end
  if not HealBot_Spells[spell].HealsMin then
    HealBot_Spells[spell].HealsMin=0;
  end
  if not HealBot_Spells[spell].HealsMax then
    HealBot_Spells[spell].HealsMax=0;
  end
  if not HealBot_Spells[spell].HealsExt then
    HealBot_Spells[spell].HealsExt = 0;
  end
  if not HealBot_Spells[spell].Channel then
    HealBot_Spells[spell].Channel = HealBot_Spells[spell].CastTime;
  end
  if not HealBot_Spells[spell].Duration then
    HealBot_Spells[spell].Duration = 0;
  end
  if not HealBot_Spells[spell].Target then
    HealBot_Spells[spell].Target = {"player","party","pet"};
  end
  if not HealBot_Spells[spell].Price then
    HealBot_Spells[spell].Price = 0;
  end

  if not HealBot_Spells[spell].RealHealing then
    HealBot_Spells[spell].RealHealing=0;
  end
  HealBot_Spells[spell].HealsCast = (HealBot_Spells[spell].HealsMin+HealBot_Spells[spell].HealsMax)/2;
  HealBot_Spells[spell].HealsDur = floor((HealBot_Spells[spell].HealsCast+HealBot_Spells[spell].HealsExt) + HealBot_Spells[spell].RealHealing);
end

local tmpTest2=nil
local hbHealsMin=nil
local hbHealsMax=nil
function HealBot_Generic_Patten(matchStr,matchPattern)
  
    tmpTest2,tmpTest2,hbHealsMin,hbHealsMax = strfind(matchStr, matchPattern ); 
    return tmpTest2,hbHealsMin,hbHealsMax;
end


local spell=nil
local spellrank=nil
local line1=nil
local line2=nil
local line3=nil
local tmpTest=nil
function HealBot_FindSpellRangeCast(id)

  if ( not id ) then return; end
  
  spell,spellrank = HealBot_GetSpellName(id);
  if spellrank then spell=spell.."("..spellrank..")"; end
  
  HealBot_TooltipInit();
  HealBot_ScanTooltip:SetSpell( id, BOOKTYPE_SPELL );
 
  if HealBot_ScanTooltipTextLeft2:GetText() then
    line1=HealBot_ScanTooltipTextLeft2:GetText();
  end
  if HealBot_ScanTooltipTextRight2:GetText() then
    line2 = HealBot_ScanTooltipTextRight2:GetText()
  end
  if HealBot_ScanTooltipTextLeft3:GetText() then
    line3 = HealBot_ScanTooltipTextLeft3:GetText();
  end
  
  if line1 then
    tmpTest,tmpTest,HB_mana = strfind(line1, HB_TOOLTIP_MANA ); 
  end

  if line2 then
    tmpTest,tmpTest,HB_range = strfind(line2, HB_TOOLTIP_RANGE ); 
  end  

  if line3 then
    if ( line3 == HB_TOOLTIP_INSTANT_CAST ) then
      HB_cast = 0;
    elseif line3 == HB_TOOLTIP_CHANNELED then
	  HB_cast = 0;
	elseif ( line3 ) then
      tmpTest,tmpTest,HB_cast = strfind(line3, HB_TOOLTIP_CAST_TIME ); 
    end
  end  

  HealBot_OtherSpells[spell] = {spell = {}};
  if not HB_cast then
    HealBot_OtherSpells[spell].CastTime=0;
  else
    HealBot_OtherSpells[spell].CastTime=tonumber(HB_cast);
  end
  if not HB_mana then
    HealBot_OtherSpells[spell].Mana=10*UnitLevel("player");
  else
    HealBot_OtherSpells[spell].Mana=tonumber(HB_mana);
  end
  if not HB_range then
    HealBot_OtherSpells[spell].Range=40;
  else
    HealBot_OtherSpells[spell].Range=tonumber(HB_range);
  end
end

function HealBot_Init_Spells_Defaults(class)

HealBot_Spells = {
-- PALADIN

  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_1] = {
    CastTime = 2.5, Cast = 2.5, Mana =  35, HealsMin =   39, HealsMax =   47, Level = 1 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_2] = { 
    CastTime = 2.5, Cast = 2.5, Mana =  60, HealsMin =   76, HealsMax =   90, Level = 6 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_3] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 110, HealsMin =  159, HealsMax =  187, Level = 14 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_4] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 190, HealsMin =  310, HealsMax =  356, Level = 22 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_5] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 275, HealsMin =  491, HealsMax =  553, Level = 30 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_6] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 365, HealsMin =  698, HealsMax =  780, Level = 38 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_7] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 465, HealsMin =  945, HealsMax = 1053, Level = 46 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_8] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 580, HealsMin = 1246, HealsMax = 1388, Level = 54 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_9] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 660, HealsMin = 1590, HealsMax = 1770, Level = 60 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_10] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 710, HealsMin = 1741, HealsMax = 1939, Level = 62 },
  [HEALBOT_HOLY_LIGHT .. HEALBOT_RANK_11] = { 
    CastTime = 2.5, Cast = 2.5, Mana = 840, HealsMin = 2196, HealsMax = 2446, Level = 70 },
    
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_1] = {
    CastTime = 1.5, Cast = 1.5, Mana =  35, HealsMin =   62, HealsMax =   72, Level = 20 },
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_2] = {
    CastTime = 1.5, Cast = 1.5, Mana =  50, HealsMin =   96, HealsMax =  110, Level = 26 },
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_3] = {
    CastTime = 1.5, Cast = 1.5, Mana =  70, HealsMin =  145, HealsMax =  163, Level = 34 },
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_4] = {
    CastTime = 1.5, Cast = 1.5, Mana =  90, HealsMin =  197, HealsMax =  221, Level = 42 },
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_5] = {
    CastTime = 1.5, Cast = 1.5, Mana = 115, HealsMin =  267, HealsMax =  299, Level = 50 },
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_6] = {
    CastTime = 1.5, Cast = 1.5, Mana = 140, HealsMin =  343, HealsMax =  383, Level = 58 },
  [HEALBOT_FLASH_OF_LIGHT .. HEALBOT_RANK_7] = {
    CastTime = 1.5, Cast = 1.5, Mana = 180, HealsMin =  448, HealsMax =  502, Level = 66 },

-- DRUID

  [HEALBOT_REJUVENATION .. HEALBOT_RANK_1 ] = { 
    CastTime = 0, Cast = 0, Duration = 12, Mana =  25, HealsMin = 0, HealsMax = 0, HealsExt =   32, Level =  4, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_2 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana =  40, HealsMin = 0, HealsMax = 0, HealsExt =   56, Level = 10, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_3 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana =  75, HealsMin = 0, HealsMax = 0, HealsExt =  116, Level = 16, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_4 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 105, HealsMin = 0, HealsMax = 0, HealsExt =  180, Level = 22, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_5 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 135, HealsMin = 0, HealsMax = 0, HealsExt =  244, Level = 28, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_6 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 160, HealsMin = 0, HealsMax = 0, HealsExt =  304, Level = 34, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_7 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 195, HealsMin = 0, HealsMax = 0, HealsExt =  388, Level = 40, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_8 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 235, HealsMin = 0, HealsMax = 0, HealsExt =  488, Level = 46, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_9 ] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 280, HealsMin = 0, HealsMax = 0, HealsExt =  608, Level = 52, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_10] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 335, HealsMin = 0, HealsMax = 0, HealsExt =  756, Level = 58, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_11] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 360, HealsMin = 0, HealsMax = 0, HealsExt =  888, Level = 60, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_12] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 370, HealsMin = 0, HealsMax = 0, HealsExt =  932, Level = 63, Buff = HEALBOT_REJUVENATION },
  [HEALBOT_REJUVENATION .. HEALBOT_RANK_13] = {
    CastTime = 0, Cast = 0, Duration = 12, Mana = 415, HealsMin = 0, HealsMax = 0, HealsExt = 1060, Level = 69, Buff = HEALBOT_REJUVENATION },

  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_1 ] = {
    CastTime = 1.5, Cast = 1.5, Mana =  25, HealsMin =   37, HealsMax =   51, Level  = 1 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_2 ] = {
    CastTime = 2.0, Cast = 2.0, Mana =  55, HealsMin =   88, HealsMax =  112, Level =  8 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_3 ] = {
    CastTime = 2.5, Cast = 2.5, Mana = 110, HealsMin =  195, HealsMax =  243, Level = 14 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_4 ] = {
    CastTime = 3.0, Cast = 3.0, Mana = 180, HealsMin =  363, HealsMax =  445, Level = 20 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_5 ] = {
    CastTime = 3.5, Cast = 3.5, Mana = 300, HealsMin =  572, HealsMax =  694, Level = 26 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_6 ] = {
    CastTime = 3.5, Cast = 3.5, Mana = 370, HealsMin =  742, HealsMax =  894, Level = 32 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_7 ] = {
    CastTime = 3.5, Cast = 3.5, Mana = 445, HealsMin =  935, HealsMax = 1120, Level = 38 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_8 ] = {
    CastTime = 3.5, Cast = 3.5, Mana = 545, HealsMin = 1199, HealsMax = 1427, Level = 44 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_9 ] = {
    CastTime = 3.5, Cast = 3.5, Mana = 660, HealsMin = 1516, HealsMax = 1796, Level = 50 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_10] = {
    CastTime = 3.5, Cast = 3.5, Mana = 790, HealsMin = 1890, HealsMax = 2230, Level = 56 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_11] = {
    CastTime = 3.5, Cast = 3.5, Mana = 840, HealsMin = 2267, HealsMax = 2677, Level = 60 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_12] = {
    CastTime = 3.5, Cast = 3.5, Mana = 890, HealsMin = 2364, HealsMax = 2790, Level = 62 },
  [HEALBOT_HEALING_TOUCH .. HEALBOT_RANK_13] = {
    CastTime = 3.5, Cast = 3.5, Mana = 935, HealsMin = 2707, HealsMax = 3197, Level = 69 },
    
  [HEALBOT_REGROWTH .. HEALBOT_RANK_1] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  120, HealsMin =   84, HealsMax =   98, HealsExt =   98, Level = 12, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_2] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  205, HealsMin =  164, HealsMax =  188, HealsExt =  175, Level = 18, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_3] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  280, HealsMin =  240, HealsMax =  274, HealsExt =  259, Level = 24, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_4] = { 
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  350, HealsMin =  318, HealsMax =  360, HealsExt =  343, Level = 30, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_5] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  420, HealsMin =  405, HealsMax =  457, HealsExt =  427, Level = 36, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_6] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  510, HealsMin =  511, HealsMax =  576, HealsExt =  546, Level = 42, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_7] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  615, HealsMin =  646, HealsMax =  724, HealsExt =  686, Level = 48, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_8] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  740, HealsMin =  809, HealsMax =  905, HealsExt =  861, Level = 54, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_9] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana =  880, HealsMin = 1003, HealsMax = 1119, HealsExt = 1064, Level = 60, Buff = HEALBOT_REGROWTH },
  [HEALBOT_REGROWTH .. HEALBOT_RANK_10] = {
    CastTime = 2, Cast = 2.0, Duration = 21, Mana = 1030, HealsMin = 1215, HealsMax = 1355, HealsExt = 1274, Level = 65, Buff = HEALBOT_REGROWTH },
    
  [HEALBOT_LIFEBLOOM .. HEALBOT_RANK_1] = {
    CastTime = 0, Cast = 0, Duration = 7, Mana = 220, HealsMin = 600, HealsMax = 600, HealsExt = 273, Level = 64, Buff = HEALBOT_LIFEBLOOM },

-- PRIEST

  [HEALBOT_LESSER_HEAL .. HEALBOT_RANK_1] = {
    CastTime = 1.5, Cast = 1.5, Mana =  35, HealsMin =   43, HealsMax =   53, Level =  1 }, 
  [HEALBOT_LESSER_HEAL .. HEALBOT_RANK_2] = {
    CastTime = 2.0, Cast = 2.0, Mana =  50, HealsMin =   71, HealsMax =   85, Level =  4 }, 
  [HEALBOT_LESSER_HEAL .. HEALBOT_RANK_3] = {
    CastTime = 2.5, Cast = 2.5, Mana =  85, HealsMin =  135, HealsMax =  157, Level = 10 }, 

  [HEALBOT_HEAL .. HEALBOT_RANK_1] = {
    CastTime = 3.0, Cast = 3.0, Mana = 155, HealsMin =  295, HealsMax =  341, Level = 16 }, 
  [HEALBOT_HEAL .. HEALBOT_RANK_2] = {
    CastTime = 3.0, Cast = 3.0, Mana = 205, HealsMin =  429, HealsMax =  491, Level = 22 }, 
  [HEALBOT_HEAL .. HEALBOT_RANK_3] = {
    CastTime = 3.0, Cast = 3.0, Mana = 255, HealsMin =  566, HealsMax =  642, Level = 28 }, 
  [HEALBOT_HEAL .. HEALBOT_RANK_4] = {
    CastTime = 3.0, Cast = 3.0, Mana = 305, HealsMin =  712, HealsMax = 804, Level = 34 }, 

  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_1] = {
    CastTime = 3.0, Cast = 3.0, Mana =  370, HealsMin = 899, HealsMax = 1013, Level = 40 }, 
  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_2] = {
    CastTime = 3.0, Cast = 3.0, Mana =  455, HealsMin = 1149, HealsMax = 1289, Level = 46 }, 
  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_3] = {
    CastTime = 3.0, Cast = 3.0, Mana =  545, HealsMin = 1473, HealsMax = 1609, Level = 52 }, 
  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_4] = {
    CastTime = 3.0, Cast = 3.0, Mana =  655, HealsMin = 1798, HealsMax = 2006, Level = 58 }, 
  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_5] = {
    CastTime = 3.0, Cast = 3.0, Mana = 710, HealsMin = 1966, HealsMax = 2194, Level = 60 }, 
  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_6] = {
    CastTime = 3.0, Cast = 3.0, Mana = 750, HealsMin = 2074, HealsMax = 2410, Level = 63 }, 
  [HEALBOT_GREATER_HEAL .. HEALBOT_RANK_7] = {
    CastTime = 3.0, Cast = 3.0, Mana = 825, HealsMin = 2396, HealsMax = 2784, Level = 68 }, 
    
  [HEALBOT_BINDING_HEAL .. HEALBOT_RANK_1] = {
    CastTime = 1.5, Cast = 1.5, Mana =  1034, HealsMin = 1042, HealsMax = 1338, Level = 64 }, 

  [HEALBOT_PRAYER_OF_MENDING .. HEALBOT_RANK_1] = {
    CastTime = 0, Cast = 0, Mana =  390, HealsMin = 800, HealsMax = 800, Level = 68, 
    Buff=HEALBOT_PRAYER_OF_MENDING, NoBonus=true, Duration = 30}, 
    
  [HEALBOT_PRAYER_OF_HEALING .. HEALBOT_RANK_1] = {
    CastTime = 3.0, Cast = 3.0, Mana =  410, HealsMin = 312, HealsMax = 333, Level = 30 }, 
  [HEALBOT_PRAYER_OF_HEALING .. HEALBOT_RANK_2] = {
    CastTime = 3.0, Cast = 3.0, Mana =  560, HealsMin = 458, HealsMax = 487, Level = 40 }, 
  [HEALBOT_PRAYER_OF_HEALING .. HEALBOT_RANK_3] = {
    CastTime = 3.0, Cast = 3.0, Mana =  770, HealsMin = 675, HealsMax = 713, Level = 50 }, 
  [HEALBOT_PRAYER_OF_HEALING .. HEALBOT_RANK_4] = {
    CastTime = 3.0, Cast = 3.0, Mana =  1030, HealsMin = 948, HealsMax = 1001, Level = 60 }, 
  [HEALBOT_PRAYER_OF_HEALING .. HEALBOT_RANK_5] = {
    CastTime = 3.0, Cast = 3.0, Mana = 1070, HealsMin = 1007, HealsMax = 1063, Level = 60 }, 
  [HEALBOT_PRAYER_OF_HEALING .. HEALBOT_RANK_6] = {
    CastTime = 3.0, Cast = 3.0, Mana = 1255, HealsMin = 1246, HealsMax = 1316, Level = 68 }, 

    
  [HEALBOT_RENEW .. HEALBOT_RANK_1] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana =  30, HealsMin = 0, HealsMax = 0, HealsExt =   45, Level =  8, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_2] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana =  65, HealsMin = 0, HealsMax = 0, HealsExt =  100, Level = 14, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_3] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 105, HealsMin = 0, HealsMax = 0, HealsExt =  175, Level = 20, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_4] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 140, HealsMin = 0, HealsMax = 0, HealsExt =  245, Level = 26, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_5] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 170, HealsMin = 0, HealsMax = 0, HealsExt =  315, Level = 32, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_6] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 205, HealsMin = 0, HealsMax = 0, HealsExt =  400, Level = 38, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_7] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 250, HealsMin = 0, HealsMax = 0, HealsExt =  510, Level = 44, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_8] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 305, HealsMin = 0, HealsMax = 0, HealsExt =  650, Level = 50, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_9] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 365, HealsMin = 0, HealsMax = 0, HealsExt =  810, Level = 56, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_10] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 410, HealsMin = 0, HealsMax = 0, HealsExt =  970, Level = 60, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_11] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 430, HealsMin = 0, HealsMax = 0, HealsExt = 1010, Level = 65, Buff = HEALBOT_RENEW }, 
  [HEALBOT_RENEW .. HEALBOT_RANK_12] = {
    CastTime = 0, Cast = 0, Duration = 15, Mana = 450, HealsMin = 0, HealsMax = 0, HealsExt = 1110, Level = 70, Buff = HEALBOT_RENEW }, 

  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_1] = {
    CastTime = 1.5, Cast = 1.5, Mana = 125, HealsMin = 193, HealsMax = 237, Level = 20 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_2] = {
    CastTime = 1.5, Cast = 1.5, Mana = 155, HealsMin = 258, HealsMax = 314, Level = 26 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_3] = {
    CastTime = 1.5, Cast = 1.5, Mana = 185, HealsMin = 327, HealsMax = 393, Level = 32 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_4] = {
    CastTime = 1.5, Cast = 1.5, Mana = 215, HealsMin = 400, HealsMax = 478, Level = 38 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_5] = {
    CastTime = 1.5, Cast = 1.5, Mana = 265, HealsMin = 518, HealsMax = 616, Level = 44 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_6] = {
    CastTime = 1.5, Cast = 1.5, Mana = 315, HealsMin = 644, HealsMax = 764, Level = 50 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_7] = { 
    CastTime = 1.5, Cast = 1.5, Mana = 380, HealsMin = 812, HealsMax = 958, Level = 56 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_8] = { 
    CastTime = 1.5, Cast = 1.5, Mana = 450, HealsMin = 913, HealsMax = 1059, Level = 61 }, 
  [HEALBOT_FLASH_HEAL .. HEALBOT_RANK_9] = { 
    CastTime = 1.5, Cast = 1.5, Mana = 470, HealsMin = 1101, HealsMax = 1279, Level = 67 }, 

  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_1] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana =  45, HealsMin =  44, HealsMax =  44, Level =  6,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30  }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_2] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana =  80, HealsMin =  88, HealsMax =  88, Level = 12,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_3] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 130, HealsMin = 158, HealsMax = 158, Level = 18,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_4] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 175, HealsMin = 234, HealsMax = 234, Level = 24,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_5] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 210, HealsMin = 301, HealsMax = 301, Level = 30,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_6] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 250, HealsMin = 381, HealsMax = 381, Level = 36,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_7] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 300, HealsMin = 484, HealsMax = 484, Level = 42,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_8] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 355, HealsMin = 605, HealsMax = 605, Level = 48,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_9] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 425, HealsMin = 763, HealsMax = 763, Level = 54,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_10] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 500, HealsMin = 942, HealsMax = 942, Level = 60,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_11] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 540, HealsMin = 1147, HealsMax = 1147, Level = 65,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30 }, 
  [HEALBOT_POWER_WORD_SHIELD .. HEALBOT_RANK_12] = {
    CastTime = 0, Cast = 0, Shield = 30, Mana = 600, HealsMin = 1315, HealsMax = 1315, Level = 70,
    Buff= HEALBOT_POWER_WORD_SHIELD, Duration = 30}, 

-- SHAMAN

  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_1] = {
    CastTime = 1.5, Cast = 1.5, Mana =  25, HealsMin =   36, HealsMax =   47, Level =  1 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_2] = {
    CastTime = 2.0, Cast = 2.0, Mana =  45, HealsMin =   67, HealsMax =   78, Level =  6 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_3] = {
    CastTime = 2.5, Cast = 2.5, Mana =  80, HealsMin =  129, HealsMax =  155, Level = 12 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_4] = {
    CastTime = 3.0, Cast = 3.0, Mana = 155, HealsMin =  268, HealsMax =  316, Level = 18 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_5] = {
    CastTime = 3.0, Cast = 3.0, Mana = 200, HealsMin =  376, HealsMax =  440, Level = 24 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_6] = {
    CastTime = 3.0, Cast = 3.0, Mana = 265, HealsMin =  536, HealsMax =  622, Level = 32 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_7] = {
    CastTime = 3.0, Cast = 3.0, Mana = 340, HealsMin =  740, HealsMax =  854, Level = 40 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_8] = {
    CastTime = 3.0, Cast = 3.0, Mana = 440, HealsMin = 1017, HealsMax = 1167, Level = 48 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_9] = {
    CastTime = 3.0, Cast = 3.0, Mana = 560, HealsMin = 1367, HealsMax = 1561, Level = 56 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_10] = {
    CastTime = 3.0, Cast = 3.0, Mana = 620, HealsMin = 1620, HealsMax = 1850, Level = 60 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_11] = {
    CastTime = 3.0, Cast = 3.0, Mana = 655, HealsMin = 1725, HealsMax = 1969, Level = 63 }, 
  [HEALBOT_HEALING_WAVE .. HEALBOT_RANK_12] = {
    CastTime = 3.0, Cast = 3.0, Mana = 720, HealsMin = 2134, HealsMax = 2436, Level = 70 }, 

  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_1] = {
    CastTime = 1.5, Cast = 1.5, Mana = 105, HealsMin = 162, HealsMax = 186, Level = 20 }, 
  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_2] = {
    CastTime = 1.5, Cast = 1.5, Mana = 145, HealsMin = 247, HealsMax = 281, Level = 28 }, 
  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_3] = {
    CastTime = 1.5, Cast = 1.5, Mana = 185, HealsMin = 337, HealsMax = 381, Level = 36 }, 
  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_4] = {
    CastTime = 1.5, Cast = 1.5, Mana = 235, HealsMin = 458, HealsMax = 514, Level = 44 }, 
  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_5] = {
    CastTime = 1.5, Cast = 1.5, Mana = 305, HealsMin = 631, HealsMax = 705, Level = 52 }, 
  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_6] = {
    CastTime = 1.5, Cast = 1.5, Mana = 380, HealsMin = 832, HealsMax = 928, Level = 60 }, 
  [HEALBOT_LESSER_HEALING_WAVE .. HEALBOT_RANK_7] = {
    CastTime = 1.5, Cast = 1.5, Mana = 440, HealsMin = 1039, HealsMax = 1185, Level = 66 }, 
    
  [HEALBOT_CHAIN_HEAL .. HEALBOT_RANK_1] = {
   CastTime = 2.5, Cast = 2.5, Mana = 260, HealsMin = 320, HealsMax = 368, Level = 40 },
  [HEALBOT_CHAIN_HEAL .. HEALBOT_RANK_2] = {
   CastTime = 2.5, Cast = 2.5, Mana = 315, HealsMin = 405, HealsMax = 465, Level = 46 },
  [HEALBOT_CHAIN_HEAL .. HEALBOT_RANK_3] = {
   CastTime = 2.5, Cast = 2.5, Mana = 405, HealsMin = 551, HealsMax = 629, Level = 54 },
  [HEALBOT_CHAIN_HEAL .. HEALBOT_RANK_4] = {
   CastTime = 2.5, Cast = 2.5, Mana = 435, HealsMin = 605, HealsMax = 691, Level = 61 },
  [HEALBOT_CHAIN_HEAL .. HEALBOT_RANK_5] = {
   CastTime = 2.5, Cast = 2.5, Mana = 540, HealsMin = 826, HealsMax = 942, Level = 68 },
    
};

--end

end


function HealBot_Init_SmartCast()
  if strsub(HealBot_PlayerClassEN,1,4)=="PRIE" then
    SmartCast_Res=HEALBOT_RESURRECTION;
  elseif strsub(HealBot_PlayerClassEN,1,4)=="DRUI" then
    SmartCast_Res=HEALBOT_REBIRTH;
  elseif strsub(HealBot_PlayerClassEN,1,4)=="PALA" then
    SmartCast_Res=HEALBOT_REDEMPTION;
  elseif strsub(HealBot_PlayerClassEN,1,4)=="SHAM" then
    SmartCast_Res=HEALBOT_ANCESTRALSPIRIT;
  end
end
