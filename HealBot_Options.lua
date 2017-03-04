local HealBot_Options_ComboButtons_Button=1;
local HealBot_Options_ResetSkins=false;
local HealBot_Action_Refresh_Flag=false;
local HealBot_CheckBuffs=false;
local HealBot_CheckDebuffs=false;
local HealBot_Options_Opened=false;
local HealBot_SetBuffBarColours_Flag=false;
local HealBot_SetSkinColours_Flag=false;
local HealBot_Options_SetSkins_Flag=false;
local HealBot_Set_DelayData_Buff=false;
local HealBot_Options_CheckCombos_flag=false;
local HealBot_Set_DelayData_Debuff=false;
local HealBot_Set_DelayData_Em=false;
local HealBot_buffbarcolr = {};
local HealBot_buffbarcolg = {};
local HealBot_buffbarcolb = {};
local HealBot_Skins = {};
local BuffTextClass=nil
local strtrim=strtrim
local strsub=strsub
local tonumber=tonumber
local strlen=strlen
local floor=floor
local HealBot_Action_SetAllAttribs_flag=false
local class=nil

local HealBot_Debuff_Spells = {
  ["PALA"] = {
    HEALBOT_PURIFY,
    HEALBOT_CLEANSE,
	HEALBOT_BLESSING_OF_FREEDOM,
                      },
  ["DRUI"] = {
    HEALBOT_CURE_POISON,
    HEALBOT_REMOVE_CURSE,
    HEALBOT_ABOLISH_POISON,
                    },
  ["PRIE"] = {
    HEALBOT_CURE_DISEASE,
    HEALBOT_DISPEL_MAGIC,
    HEALBOT_ABOLISH_DISEASE,
                     },
  ["SHAM"] = {
    HEALBOT_CURE_POISON,
    HEALBOT_CURE_DISEASE,
                       },
  ["HUNT"] = {},
  ["MAGE"] = {HEALBOT_REMOVE_LESSER_CURSE,},
  ["ROGU"] = {},
  ["WARL"] = {},
  ["WARR"] = {},
}

local HealBot_Racial_Debuff_Spells = {
  ["Hum"] = {},
  ["Dwa"] = {HEALBOT_STONEFORM,},
  ["Nig"] = {},
  ["Gno"] = {},
  ["Dra"] = {},
  ["Orc"] = {},
  ["Sco"] = {}, -- Undead
  ["Tau"] = {},
  ["Tro"] = {}, 
  ["Blo"] = {},
}

local HealBot_Debuff_Types = {
  [HEALBOT_PURIFY] = {HEALBOT_DISEASE_en, HEALBOT_POISON_en},
  [HEALBOT_CLEANSE] = {HEALBOT_DISEASE_en, HEALBOT_POISON_en, HEALBOT_MAGIC_en},
  [HEALBOT_CURE_POISON] = {HEALBOT_POISON_en},
  [HEALBOT_REMOVE_CURSE] = {HEALBOT_CURSE_en},
  [HEALBOT_ABOLISH_POISON] = {HEALBOT_POISON_en},
  [HEALBOT_CURE_DISEASE] = {HEALBOT_DISEASE_en},
  [HEALBOT_ABOLISH_DISEASE] = {HEALBOT_DISEASE_en},
  [HEALBOT_DISPEL_MAGIC..HEALBOT_RANK_1] = {HEALBOT_MAGIC_en},
  [HEALBOT_DISPEL_MAGIC..HEALBOT_RANK_2] = {HEALBOT_MAGIC_en},  
  [HEALBOT_REMOVE_LESSER_CURSE] = {HEALBOT_CURSE_en},
  [HEALBOT_PURIFICATION_POTION] = {HEALBOT_CURSE_en, HEALBOT_DISEASE_en, HEALBOT_POISON_en},
  [HEALBOT_ANTI_VENOM] = {HEALBOT_POISON_en},
  [HEALBOT_POWERFUL_ANTI_VENOM] = {HEALBOT_POISON_en},
  [HEALBOT_ELIXIR_OF_POISON_RES] = {HEALBOT_POISON_en},
  [HEALBOT_BLESSING_OF_FREEDOM] = {HEALBOT_MAGIC_en},
  [HEALBOT_STONEFORM] = {HEALBOT_DISEASE_en, HEALBOT_POISON_en},
}

function HealBot_Options_AddDebug(msg)
  HealBot_AddDebug("Options: " .. msg);
end

function HealBot_Options_Pct_OnLoad(this,text)
  this.text = text;
  getglobal(this:GetName().."Text"):SetText(text);
  getglobal(this:GetName().."Low"):SetText("0%");
  getglobal(this:GetName().."High"):SetText("100%");
  this:SetMinMaxValues(0.00,1.00);
  this:SetValueStep(0.01);
end

local MinTxt=nil
local MaxTxt=nil
function HealBot_Options_Pct_OnLoad_MinMax(this,text,Min,Max)
  this.text = text;

  MinTxt=(Min*100).."%";
  MaxTxt=(Max*100).."%";

  getglobal(this:GetName().."Text"):SetText(text);
  getglobal(this:GetName().."Low"):SetText(MinTxt);
  getglobal(this:GetName().."High"):SetText(MaxTxt);
  this:SetMinMaxValues(Min,Max);
  this:SetValueStep(0.01);
end

function HealBot_Options_val_OnLoad(this,text,Min,Max)
  this.text = text;

  getglobal(this:GetName().."Text"):SetText(text);
  getglobal(this:GetName().."Low"):SetText(Min);
  getglobal(this:GetName().."High"):SetText(Max);
  this:SetMinMaxValues(Min,Max);
  this:SetValueStep(1);
end

function HealBot_Options_valNoCols_OnLoad(this,Min,Max)
  getglobal(this:GetName().."Text"):SetText(HealBot_Options_SetNoColsText);
  getglobal(this:GetName().."Low"):SetText(Min);
  getglobal(this:GetName().."High"):SetText(Max);
  this:SetMinMaxValues(Min,Max);
  this:SetValueStep(1);
end

function HealBot_Options_val2_OnLoad(this,text,Min,Max,Step)
  this.text = text;

  getglobal(this:GetName().."Text"):SetText(text);
  getglobal(this:GetName().."Low"):SetText(Min/10);
  getglobal(this:GetName().."High"):SetText(Max/10);
  this:SetMinMaxValues(Min,Max);
  this:SetValueStep(Step);
end

function HealBot_Options_SetText(this,text)
  getglobal(this:GetName().."Text"):SetText(text);
end

function HealBot_Options_SetNoColsText()
  if HealBot_Config.ShowHeader[HealBot_Config.Current_Skin]==1 then
    return HEALBOT_OPTIONS_SKINNUMHCOLS;
  else
    return HEALBOT_OPTIONS_SKINNUMCOLS;
  end
end

local pct=nil
function HealBot_Options_Pct_OnValueChanged(this)
  pct = floor(this:GetValue()*100+0.5);
  getglobal(this:GetName().."Text"):SetText(this.text .. " (" .. pct .. "%)");
  return this:GetValue();
end

local text
function HealBot_Options_NewSkin_OnTextChanged(this)
  text= this:GetText()
  if strlen(text)>0 then
    HealBot_Options_NewSkinb:Enable();
  else
    HealBot_Options_NewSkinb:Disable();
  end
end


local unique=nil
local NewSkinTxt=nil
function HealBot_Options_NewSkinb_OnClick(this)
  NewSkinTxt=HealBot_Options_NewSkin:GetText()
  HealBot_Config.numcols[NewSkinTxt] = HealBot_Config.numcols[HealBot_Config.Current_Skin]
  HealBot_Config.btexture[NewSkinTxt] = HealBot_Config.btexture[HealBot_Config.Current_Skin]
  HealBot_Config.bcspace[NewSkinTxt] = HealBot_Config.bcspace[HealBot_Config.Current_Skin]
  HealBot_Config.brspace[NewSkinTxt] = HealBot_Config.brspace[HealBot_Config.Current_Skin]
  HealBot_Config.bwidth[NewSkinTxt] = HealBot_Config.bwidth[HealBot_Config.Current_Skin]
  HealBot_Config.bheight[NewSkinTxt] = HealBot_Config.bheight[HealBot_Config.Current_Skin]
  HealBot_Config.btextenabledcolr[NewSkinTxt] = HealBot_Config.btextenabledcolr[HealBot_Config.Current_Skin]
  HealBot_Config.btextenabledcolg[NewSkinTxt] = HealBot_Config.btextenabledcolg[HealBot_Config.Current_Skin]
  HealBot_Config.btextenabledcolb[NewSkinTxt] = HealBot_Config.btextenabledcolb[HealBot_Config.Current_Skin]
  HealBot_Config.btextenabledcola[NewSkinTxt] = HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]
  HealBot_Config.btextdisbledcolr[NewSkinTxt] = HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin]
  HealBot_Config.btextdisbledcolg[NewSkinTxt] = HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin]
  HealBot_Config.btextdisbledcolb[NewSkinTxt] = HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin]
  HealBot_Config.btextdisbledcola[NewSkinTxt] = HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin]
  HealBot_Config.btextcursecolr[NewSkinTxt] = HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin]
  HealBot_Config.btextcursecolg[NewSkinTxt] = HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin]
  HealBot_Config.btextcursecolb[NewSkinTxt] = HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin]
  HealBot_Config.btextcursecola[NewSkinTxt] = HealBot_Config.btextcursecola[HealBot_Config.Current_Skin]
  HealBot_Config.backcola[NewSkinTxt] = HealBot_Config.backcola[HealBot_Config.Current_Skin]
  HealBot_Config.Barcola[NewSkinTxt] = HealBot_Config.Barcola[HealBot_Config.Current_Skin]
  HealBot_Config.BarcolaInHeal[NewSkinTxt] = HealBot_Config.BarcolaInHeal[HealBot_Config.Current_Skin]
  HealBot_Config.backcolr[NewSkinTxt] = HealBot_Config.backcolr[HealBot_Config.Current_Skin]
  HealBot_Config.backcolg[NewSkinTxt] = HealBot_Config.backcolg[HealBot_Config.Current_Skin]
  HealBot_Config.backcolb[NewSkinTxt] = HealBot_Config.backcolb[HealBot_Config.Current_Skin]
  HealBot_Config.borcolr[NewSkinTxt] = HealBot_Config.borcolr[HealBot_Config.Current_Skin]
  HealBot_Config.borcolg[NewSkinTxt] = HealBot_Config.borcolg[HealBot_Config.Current_Skin]
  HealBot_Config.borcolb[NewSkinTxt] = HealBot_Config.borcolb[HealBot_Config.Current_Skin]
  HealBot_Config.borcola[NewSkinTxt] = HealBot_Config.borcola[HealBot_Config.Current_Skin]
  HealBot_Config.btextheight[NewSkinTxt] = HealBot_Config.btextheight[HealBot_Config.Current_Skin]
  HealBot_Config.bardisa[NewSkinTxt] = HealBot_Config.bardisa[HealBot_Config.Current_Skin]
  HealBot_Config.bareora[NewSkinTxt] = HealBot_Config.bareora[HealBot_Config.Current_Skin]
  HealBot_Config.bar2size[NewSkinTxt] = HealBot_Config.bar2size[HealBot_Config.Current_Skin]
  HealBot_Config.ShowHeader[NewSkinTxt] = HealBot_Config.ShowHeader[HealBot_Config.Current_Skin]
  HealBot_Config.headbarcolr[NewSkinTxt] = HealBot_Config.headbarcolr[HealBot_Config.Current_Skin]
  HealBot_Config.headbarcolg[NewSkinTxt] = HealBot_Config.headbarcolg[HealBot_Config.Current_Skin]
  HealBot_Config.headbarcolb[NewSkinTxt] = HealBot_Config.headbarcolb[HealBot_Config.Current_Skin]
  HealBot_Config.headbarcola[NewSkinTxt] = HealBot_Config.headbarcola[HealBot_Config.Current_Skin]
  HealBot_Config.headtxtcolr[NewSkinTxt] = HealBot_Config.headtxtcolr[HealBot_Config.Current_Skin]
  HealBot_Config.headtxtcolg[NewSkinTxt] = HealBot_Config.headtxtcolg[HealBot_Config.Current_Skin]
  HealBot_Config.headtxtcolb[NewSkinTxt] = HealBot_Config.headtxtcolb[HealBot_Config.Current_Skin]
  HealBot_Config.headtxtcola[NewSkinTxt] = HealBot_Config.headtxtcola[HealBot_Config.Current_Skin]
  HealBot_Config.headtexture[NewSkinTxt] = HealBot_Config.headtexture[HealBot_Config.Current_Skin]
  HealBot_Config.headwidth[NewSkinTxt] = HealBot_Config.headwidth[HealBot_Config.Current_Skin]

  unique=true;
  table.foreach(HealBot_Skins, function (index,skin)
    if skin==HealBot_Options_NewSkin:GetText() then unique=false; end
  end)
  if unique then
    table.insert(HealBot_Skins,2,NewSkinTxt)
    HealBot_Config.Skin_ID = 2;
    HealBot_Config.Skins = HealBot_Skins
	HealBot_Config.Current_Skin = NewSkinTxt
  end
  HealBot_Options_SetSkins();
  HealBot_Options_NewSkin:SetText("")
end

function HealBot_Options_DeleteSkin_OnClick(this)
  if HealBot_Config.Current_Skin~=HEALBOT_SKINS_STD then
    HealBot_Config.numcols[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btexture[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.bcspace[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.brspace[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.bwidth[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.bheight[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextenabledcolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextenabledcolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextenabledcolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextenabledcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextdisbledcolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextdisbledcolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextdisbledcolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextdisbledcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextcursecolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextcursecolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextcursecolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextcursecola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.backcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.Barcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.BarcolaInHeal[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.backcolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.backcolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.backcolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.borcolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.borcolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.borcolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.borcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.btextheight[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.bardisa[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.bareora[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.bar2size[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.ShowHeader[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headbarcolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headbarcolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headbarcolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headbarcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headtxtcolr[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headtxtcolg[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headtxtcolb[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headtxtcola[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headtexture[HealBot_Options_SkinsText:GetText()] = nil
    HealBot_Config.headwidth[HealBot_Options_SkinsText:GetText()] = nil
    table.remove(HealBot_Skins,HealBot_Config.Skin_ID)
    HealBot_Config.Skin_ID = 1;
    HealBot_Config.Skins = HealBot_Skins;  
    HealBot_Config.Current_Skin = HEALBOT_SKINS_STD;
      HealBot_Options_SetSkins();
  end
end

function HealBot_Options_ShowHeaders_OnClick(this)
  HealBot_Config.ShowHeader[HealBot_Config.Current_Skin] = this:GetChecked() or 0;
  HealBot_Options_BarNumColsSText:SetText(HealBot_Options_SetNoColsText() .. ": " .. HealBot_Config.numcols[HealBot_Config.Current_Skin]);
  HealBot_Options_ResetSkins=true;
end
    
function HealBot_Options_BarTextureS_OnValueChanged(this)
  HealBot_Config.btexture[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_HeadTextureS_OnValueChanged(this)
  HealBot_Config.headtexture[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarHeightS_OnValueChanged(this)
  HealBot_Config.bheight[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarWidthS_OnValueChanged(this)
  HealBot_Config.bwidth[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarNumColsS_OnValueChanged(this)
  HealBot_Config.numcols[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(HealBot_Options_SetNoColsText() .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarBRSpaceS_OnValueChanged(this)
  HealBot_Config.brspace[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarBCSpaceS_OnValueChanged(this)
  HealBot_Config.bcspace[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_FontHeight_OnValueChanged(this)
  HealBot_Config.btextheight[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_Bar2Size_OnValueChanged(this)
  HealBot_Config.bar2size[HealBot_Config.Current_Skin] = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  HealBot_Options_ResetSkins=true;
  if HealBot_Config.bar2size[HealBot_Config.Current_Skin]==0 then
    HealBot_UnRegister_Mana()
  else
    HealBot_Register_Mana()
  end
end

function HealBot_Options_ActionAlpha_OnValueChanged(this)
  HealBot_Config.backcola[HealBot_Config.Current_Skin] = HealBot_Options_Pct_OnValueChanged(this);
end

function HealBot_Options_BarAlpha_OnValueChanged(this)
  HealBot_Config.Barcola[HealBot_Config.Current_Skin] = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_HeadWidthS_OnValueChanged(this)
  HealBot_Config.headwidth[HealBot_Config.Current_Skin] = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Options_ResetSkins=true;
end


function HealBot_Options_BarAlphaInHeal_OnValueChanged(this)
  HealBot_Config.BarcolaInHeal[HealBot_Config.Current_Skin] = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarAlphaDis_OnValueChanged(this)
  HealBot_Config.bardisa[HealBot_Config.Current_Skin] = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_BarAlphaEor_OnValueChanged(this)
  HealBot_Config.bareora[HealBot_Config.Current_Skin] = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Options_ResetSkins=true;
end

function HealBot_Options_TTAlpha_OnValueChanged(this)
  HealBot_Config.ttalpha = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Tooltip:SetBackdropColor(0,0,0,HealBot_Config.ttalpha)
end



local HealBot_ColourObjWaiting=nil
function HealBot_SkinColorpick_OnClick(SkinType)
  HealBot_ColourObjWaiting=SkinType;

  if SkinType=="En" then
    HealBot_UseColourPick(HealBot_Config.btextenabledcolr[HealBot_Config.Current_Skin],
                          HealBot_Config.btextenabledcolg[HealBot_Config.Current_Skin],
                          HealBot_Config.btextenabledcolb[HealBot_Config.Current_Skin],
                          HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]);
  elseif SkinType=="Dis" then
    HealBot_UseColourPick(HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin],
                          HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin],
                          HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin],
                          HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin])
  elseif SkinType=="Debuff" then
    HealBot_UseColourPick(HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin],
                          HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin],
                          HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin],
                          HealBot_Config.btextcursecola[HealBot_Config.Current_Skin])
  elseif SkinType=="Back" then
    HealBot_UseColourPick(HealBot_Config.backcolr[HealBot_Config.Current_Skin],
                          HealBot_Config.backcolg[HealBot_Config.Current_Skin],
                          HealBot_Config.backcolb[HealBot_Config.Current_Skin],
                          HealBot_Config.backcola[HealBot_Config.Current_Skin])
  elseif SkinType=="Bor" then
    HealBot_UseColourPick(HealBot_Config.borcolr[HealBot_Config.Current_Skin],
                          HealBot_Config.borcolg[HealBot_Config.Current_Skin],
                          HealBot_Config.borcolb[HealBot_Config.Current_Skin],
                          HealBot_Config.borcola[HealBot_Config.Current_Skin])
  elseif SkinType=="HeadB" then
    HealBot_UseColourPick(HealBot_Config.headbarcolr[HealBot_Config.Current_Skin],
                          HealBot_Config.headbarcolg[HealBot_Config.Current_Skin],
                          HealBot_Config.headbarcolb[HealBot_Config.Current_Skin],
                          HealBot_Config.headbarcola[HealBot_Config.Current_Skin])
  elseif SkinType=="HeadT" then
    HealBot_UseColourPick(HealBot_Config.headtxtcolr[HealBot_Config.Current_Skin],
                          HealBot_Config.headtxtcolg[HealBot_Config.Current_Skin],
                          HealBot_Config.headtxtcolb[HealBot_Config.Current_Skin],
                          HealBot_Config.headtxtcola[HealBot_Config.Current_Skin])
  end
end

local buffbarcolrClass=nil
local buffbarcolgClass=nil
local buffbarcolbClass=nil
function HealBot_BuffColorpick_OnClick(BuffID,id)
  HealBot_ColourObjWaiting=BuffID;
  buffbarcolrClass = HealBot_Config.HealBotBuffColR
  buffbarcolgClass = HealBot_Config.HealBotBuffColG
  buffbarcolbClass = HealBot_Config.HealBotBuffColB
  HealBot_UseColourPick(buffbarcolrClass[id],
                        buffbarcolgClass[id],
                        buffbarcolbClass[id]);
end

local btextheight=nil
function HealBot_SetSkinColours()
  btextheight=HealBot_Config.btextheight[HealBot_Config.Current_Skin] or 10;
  
  HealBot_EnTextColorpick:SetStatusBarColor(0,1,0,HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_EnTextColorpickin:SetStatusBarColor(0,1,0,HealBot_Config.BarcolaInHeal[HealBot_Config.Current_Skin]);
  HealBot_EnTextColorpickEor:SetStatusBarColor(0,1,0,HealBot_Config.bareora[HealBot_Config.Current_Skin]);
  HealBot_DisTextColorpick:SetStatusBarColor(0,1,0,HealBot_Config.bardisa[HealBot_Config.Current_Skin]);  
  HealBot_EnTextColorpickt:SetTextColor(
    HealBot_Config.btextenabledcolr[HealBot_Config.Current_Skin],
    HealBot_Config.btextenabledcolg[HealBot_Config.Current_Skin],
    HealBot_Config.btextenabledcolb[HealBot_Config.Current_Skin],
    HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin]);
  HealBot_DisTextColorpickt:SetTextColor(
    HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin],
    HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin],
    HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin],
    HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin]);
  HealBot_DebTextColorpickt:SetTextColor(
    HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin],
    HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin],
    HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin],
    HealBot_Config.btextcursecola[HealBot_Config.Current_Skin]);
  HealBot_HeadBarColorpickt:SetTextColor(
    HealBot_Config.headbarcolr[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolg[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolb[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcola[HealBot_Config.Current_Skin]);
  HealBot_HeadTextColorpickt:SetTextColor(
    HealBot_Config.headtxtcolr[HealBot_Config.Current_Skin],
    HealBot_Config.headtxtcolg[HealBot_Config.Current_Skin],
    HealBot_Config.headtxtcolb[HealBot_Config.Current_Skin],
    HealBot_Config.headtxtcola[HealBot_Config.Current_Skin]);
  HealBot_BackgroundColorpick:SetStatusBarColor(
    HealBot_Config.backcolr[HealBot_Config.Current_Skin],
    HealBot_Config.backcolg[HealBot_Config.Current_Skin],
    HealBot_Config.backcolb[HealBot_Config.Current_Skin],
    HealBot_Config.backcola[HealBot_Config.Current_Skin]);
  HealBot_BorderColorpick:SetStatusBarColor(
    HealBot_Config.borcolr[HealBot_Config.Current_Skin],
    HealBot_Config.borcolg[HealBot_Config.Current_Skin],
    HealBot_Config.borcolb[HealBot_Config.Current_Skin],
    HealBot_Config.borcola[HealBot_Config.Current_Skin]);
  HealBot_HeadBarColorpick:SetStatusBarColor(
    HealBot_Config.headbarcolr[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolg[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolb[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcola[HealBot_Config.Current_Skin])
  HealBot_HeadTextColorpick:SetStatusBarColor(
    HealBot_Config.headbarcolr[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolg[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolb[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcola[HealBot_Config.Current_Skin])

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

    HealBot_EnTextColorpickt:SetTextHeight(btextheight);
    HealBot_DisTextColorpickt:SetTextHeight(btextheight);
    HealBot_DebTextColorpickt:SetTextHeight(btextheight);
    HealBot_EnTextColorpickt:SetText(HEALBOT_SKIN_ENTEXT);
    HealBot_DisTextColorpickt:SetText(HEALBOT_SKIN_DISTEXT);
    HealBot_DebTextColorpickt:SetText(HEALBOT_SKIN_DEBTEXT);
    local barScale = HealBot_EnTextColorpick:GetScale();
    HealBot_EnTextColorpick:SetScale(barScale + 0.01);
    HealBot_EnTextColorpick:SetScale(barScale);
    HealBot_DisTextColorpick:SetScale(barScale + 0.01);
    HealBot_DisTextColorpick:SetScale(barScale);
    HealBot_DebTextColorpick:SetScale(barScale + 0.01);
    HealBot_DebTextColorpick:SetScale(barScale);
   
    Delay_RecalcParty=1;
end

function HealBot_Options_AlertLevel_OnValueChanged(this)
  HealBot_Config.AlertLevel = HealBot_Options_Pct_OnValueChanged(this);
  HealBot_Action_Refresh_Flag=true;
end

local val=nil
function HealBot_Options_RangeCheckFreq_OnValueChanged(this)
  val=this:GetValue();
  val=val/10;
  HealBot_Config.RangeCheckFreq = val;
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. val .." sec");
end

function HealBot_Options_BarFreq_OnValueChanged(this)
  val=this:GetValue();
  val=val/10;
  HealBot_Config.BarFreq = val;
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. val);
end

function HealBot_Options_RangeCheckUnits_OnValueChanged(this)
  HealBot_Config.RangeCheckUnits = this:GetValue();
  getglobal(this:GetName().."Text"):SetText(this.text .. ": " .. this:GetValue());
  Delay_RecalcParty=1;
end

function HealBot_Options_AutoShow_OnClick(this)
  HealBot_Config.AutoClose = this:GetChecked() or 0;
  HealBot_Action_Refresh_Flag=true;
  if HealBot_Config.AutoClose==0 and HealBot_Config.DisableHealBot==0 then
    ShowUIPanel(HealBot_Action)
  end
end

function HealBot_Options_IgnoreDebuffsClass_OnClick(this)
  HealBot_Config.IgnoreClassDebuffs = this:GetChecked() or 0;
end

function HealBot_Options_IgnoreDebuffsNoHarm_OnClick(this)
  HealBot_Config.IgnoreNonHarmfulDebuffs = this:GetChecked() or 0;
end

function HealBot_Options_IgnoreDebuffsDuration_OnClick(this)
  HealBot_Config.IgnoreFastDurDebuffs = this:GetChecked() or 0;
end

function HealBot_Options_IgnoreDebuffsMovement_OnClick(this)
  HealBot_Config.IgnoreMovementDebuffs = this:GetChecked() or 0;
end

function HealBot_Options_CastNotifyResOnly_OnClick(this)
  HealBot_Config.CastNotifyResOnly = this:GetChecked() or 0;
end

function HealBot_Options_ShowClassOnBar_OnClick(this)
  HealBot_Config.ShowClassOnBar = this:GetChecked() or 0;
  if HealBot_Config.ShowClassOnBar==0 then
    HealBot_Options_ShowClassOnBarWithName:Disable();
  else
    HealBot_Options_ShowClassOnBarWithName:Enable();
  end
  HealBot_Action_Refresh_Flag=true;
end

function HealBot_Options_ShowClassOnBarWithName_OnClick(this)
  HealBot_Config.ShowClassOnBarWithName = this:GetChecked() or 0;
  HealBot_Action_Refresh_Flag=true;
end

function HealBot_Options_ShowTooltipMyBuffs_OnClick(this)
  HealBot_Config.Tooltip_ShowMyBuffs = this:GetChecked() or 0;
end


function HealBot_BarHealthIncHeal_OnClick(this)
  HealBot_Config.BarHealthIncHeals = this:GetChecked() or 0;
  HealBot_Action_Refresh_Flag=true;
end

function HealBot_Options_PartyFrames_OnClick(this)
  HealBot_Config.HidePartyFrames = this:GetChecked() or 0;
  if HealBot_Config.HidePartyFrames==0 then
    if HealBot_Config.HidePlayerTarget==1 then
      HealBot_Options_EnablePlayerFrame();
      HealBot_Options_EnablePetFrame()
      HealBot_Options_EnableTargetFrame()
      HealBot_Config.HidePlayerTarget=0;
      HealBot_Options_PlayerTargetFrames:SetChecked(HealBot_Config.HidePlayerTarget);
    end
    HealBot_Options_PlayerTargetFrames:Disable();
    HealBot_Options_EnablePartyFrame()
  else
    HealBot_Options_PlayerTargetFrames:Enable();
    HealBot_Options_DisablePartyFrame()
  end
end

function HealBot_Options_AggroTrack_OnClick(this)
  HealBot_Config.ShowAggro = this:GetChecked() or 0;
  if HealBot_Config.ShowAggro==0 then
    HealBot_UnRegister_Aggro()
    HealBot_ClearAggro()
  else
    HealBot_Register_Aggro()
  end
  HealBot_Action_Refresh_Flag=true;
end

function HealBot_Options_UseFluidBars_OnClick(this)
  HealBot_Config.UseFluidBars = this:GetChecked() or 0;
  HealBot_Action_Refresh_Flag=true;
  HealBot_Action_Set_Timers()
end

function HealBot_Options_AggroBar_OnClick(this)
  HealBot_Config.ShowAggroBars = this:GetChecked() or 0;
  HealBot_Action_Refresh_Flag=true;
end

function HealBot_Options_AggroTxt_OnClick(this)
  HealBot_Config.ShowAggroText = this:GetChecked() or 0;
  HealBot_Action_Refresh_Flag=true;
end

local CPUProfiler=0
StaticPopupDialogs["HEALBOT_OPTIONS_SETCPUPROFILER"] = {
  text = HEALBOT_OPTIONS_SETCPUPROFILERMSG,
  button1 = HEALBOT_WORDS_YES,
  button2 = HEALBOT_WORDS_NO,
  OnAccept = function()
    ReloadUI();
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1
};

function HealBot_Options_CPUProfiler_OnClick(this)
  CPUProfiler = this:GetChecked() or 0;
  SetCVar("scriptProfile", CPUProfiler)
  StaticPopup_Show ("HEALBOT_OPTIONS_SETCPUPROFILER");
end

function HealBot_Options_PlayerTargetFrames_OnClick(this)
  HealBot_Config.HidePlayerTarget = this:GetChecked() or 0;
  if HealBot_Config.HidePlayerTarget==0 then
    HealBot_Options_EnablePlayerFrame()
    HealBot_Options_EnablePetFrame()
    HealBot_Options_EnableTargetFrame()
  else
    HealBot_Options_DisablePlayerFrame()
    HealBot_Options_DisablePetFrame()
    HealBot_Options_DisableTargetFrame()
  end
end

function HealBot_Options_MonitorBuffs_OnClick(this)
  HealBot_Config.BuffWatch = this:GetChecked() or 0;
  if HealBot_Config.BuffWatch==0 then
    HealBot_Options_MonitorBuffsInCombat:Disable();
    HealBot_ClearAllBuffs()
    for x,_ in pairs(HealBot_UnitBuff) do
      HealBot_UnitBuff[x]=nil;
    end
  else
    HealBot_Options_MonitorBuffsInCombat:Enable();
    HealBot_Set_DelayData_Buff=true;
  end
end

function HealBot_Options_MonitorDebuffs_OnClick(this)
  HealBot_Config.DebuffWatch = this:GetChecked() or 0;
  if HealBot_Config.DebuffWatch==0 then
    HealBot_Options_MonitorDebuffsInCombat:Disable();
    HealBot_ClearAllDebuffs()
  for x,_ in pairs(HealBot_UnitDebuff) do
    HealBot_UnitDebuff[x]=nil;
  end
  else
    HealBot_Options_MonitorDebuffsInCombat:Enable();
    HealBot_Set_DelayData_Debuff=true;
  end
end

function HealBot_Options_MonitorBuffsInCombat_OnClick(this)
  HealBot_Config.BuffWatchInCombat = this:GetChecked() or 0;
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_MonitorDebuffsInCombat_OnClick(this)
  HealBot_Config.DebuffWatchInCombat = this:GetChecked() or 0;
  HealBot_Set_DelayData_Debuff=true;
end

function HealBot_Options_PanelSounds_OnClick(this)
  HealBot_Config.PanelSounds = this:GetChecked() or 0;
end

function HealBot_Options_ActionLocked_OnClick(this)
  HealBot_Config.ActionLocked = this:GetChecked() or 0;
end

local curval = 0
function HealBot_Options_DisableHealBot_OnClick(this)
  curval = this:GetChecked() or 0;
  HealBot_Options_ToggleHealBot(curval)
end

function HealBot_Options_ToggleHealBot(checkval)
  HealBot_Config.DisableHealBot=checkval
  if checkval==0 then
    HealBot_SetResetFlag("SOFT")
    ShowUIPanel(HealBot_Action)
  else
    HealBot_UnRegister_Events()
	HealBot_Register_Events()
    HideUIPanel(HealBot_Action)
  end
  HealBot_Set_Timers()
  HealBot_Action_Set_Timers()
end

function HealBot_Options_GroupHeals_OnClick(this)
  HealBot_Config.GroupHeals = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_TankHeals_OnClick(this)
  HealBot_Config.TankHeals = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_SelfPet_OnClick(this)
  HealBot_Config.SelfPet = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_EmergencyHeals_OnClick(this)
  HealBot_Config.EmergencyHeals = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_SelfHeals_OnClick(this)
  HealBot_Config.SelfHeals = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_PetHeals_OnClick(this)
  HealBot_Config.PetHeals = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_TargetBar_OnClick(this)
  HealBot_Config.TargetHeals = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_TargetIncSelf_OnClick(this)
  HealBot_Config.TargetIncSelf = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_TargetIncGroup_OnClick(this)
  HealBot_Config.TargetIncGroup = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_TargetIncRaid_OnClick(this)
  HealBot_Config.TargetIncRaid = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_TargetIncPet_OnClick(this)
  HealBot_Config.TargetIncPet = this:GetChecked() or 0;
  Delay_RecalcParty=3;
end

function HealBot_Options_EFGroup_OnClick(this,id)
  if this:GetChecked() then
    HealBot_Config.ExtraIncGroup[id] = true;
  else
    HealBot_Config.ExtraIncGroup[id] = false;
  end
  Delay_RecalcParty=1;
end

function HealBot_Options_EFClass_OnClick(this)
    if HealBot_Config.EmergencyFClass==1 then
      HealBot_Config.EmergIncMelee[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
      HealBot_Config.EmergIncMelee[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
    elseif HealBot_Config.EmergencyFClass==2 then
      HealBot_Config.EmergIncRange[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
      HealBot_Config.EmergIncRange[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
    elseif HealBot_Config.EmergencyFClass==3 then
      HealBot_Config.EmergIncHealers[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
      HealBot_Config.EmergIncHealers[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
    elseif HealBot_Config.EmergencyFClass==4 then
      HealBot_Config.EmergIncCustom[HEALBOT_DRUID] = HealBot_Options_EFClassDruid:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_HUNTER] = HealBot_Options_EFClassHunter:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_MAGE] = HealBot_Options_EFClassMage:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_PALADIN] = HealBot_Options_EFClassPaladin:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_PRIEST] = HealBot_Options_EFClassPriest:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_ROGUE] = HealBot_Options_EFClassRogue:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_SHAMAN] = HealBot_Options_EFClassShaman:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_WARLOCK] = HealBot_Options_EFClassWarlock:GetChecked() or 0;
      HealBot_Config.EmergIncCustom[HEALBOT_WARRIOR] = HealBot_Options_EFClassWarrior:GetChecked() or 0;
    end
    Delay_RecalcParty=1;
end

function HealBot_Options_CastNotify_OnClick(this,id)
  if HealBot_Config.CastNotify>0 then
    getglobal("HealBot_Options_CastNotify"..HealBot_Config.CastNotify):SetChecked(nil);
  end
  HealBot_Config.CastNotify = id;
  if HealBot_Config.CastNotify>0 then
    getglobal("HealBot_Options_CastNotify"..HealBot_Config.CastNotify):SetChecked(1);
  end
end

function HealBot_ComboButtons_Button_OnClick(this,id)
  if HealBot_Options_ComboButtons_Button>0 then
    getglobal("HealBot_ComboButtons_Button"..HealBot_Options_ComboButtons_Button):SetChecked(nil);
  end
  HealBot_Options_ComboButtons_Button = id;
  if HealBot_Options_ComboButtons_Button>0 then
    getglobal("HealBot_ComboButtons_Button"..HealBot_Options_ComboButtons_Button):SetChecked(1);
  end
  HealBot_Options_ComboClass_Text()
end

function HealBot_Options_HideOptions_OnClick(this)
  HealBot_Config.HideOptions = this:GetChecked() or 0;
  Delay_RecalcParty=1;
end

function HealBot_Options_RightButtonOptions_OnClick(this)
  HealBot_Config.RightButtonOptions = this:GetChecked() or 0;
end

function HealBot_Options_ShowMinimapButton_OnClick(this)
  HealBot_Config.ButtonShown = this:GetChecked() or 0;
  HealBot_MMButton_Init();   
end

function HealBot_Options_ShowTooltip_OnClick(this)
  HealBot_Config.ShowTooltip = this:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipUpdate_OnClick(this)
  HealBot_Config.TooltipUpdate = this:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipTarget_OnClick(this)
  HealBot_Config.Tooltip_ShowTarget = this:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipSpellDetail_OnClick(this)
  HealBot_Config.Tooltip_ShowSpellDetail = this:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipInstant_OnClick(this)
  HealBot_Config.Tooltip_Recommend = this:GetChecked() or 0;
end

function HealBot_Options_ShowTooltipPreDefined_OnClick(this)
  HealBot_Config.Tooltip_PreDefined = this:GetChecked() or 0;
end

function HealBot_Options_ShowDebuffWarning_OnClick(this)
  HealBot_Config.ShowDebuffWarning = this:GetChecked() or 0;
end

function HealBot_Options_SoundDebuffWarning_OnClick(this)
  HealBot_Config.SoundDebuffWarning = this:GetChecked() or 0;
  if HealBot_Config.SoundDebuffWarning==0 then
    HealBot_WarningSound1:Disable();
    HealBot_WarningSound2:Disable();
    HealBot_WarningSound3:Disable();
  else
    HealBot_WarningSound1:Enable();
    HealBot_WarningSound2:Enable();
    HealBot_WarningSound3:Enable();
  end
end

function HealBot_WarningSound_OnClick(this,id)
  if HealBot_Config.SoundDebuffPlay>0 then
    getglobal("HealBot_WarningSound"..HealBot_Config.SoundDebuffPlay):SetChecked(nil);
  end
  HealBot_Config.SoundDebuffPlay = id;
  if HealBot_Config.SoundDebuffPlay>0 then
    getglobal("HealBot_WarningSound"..HealBot_Config.SoundDebuffPlay):SetChecked(1);
    if this then
      HealBot_PlaySound(HealBot_Config.SoundDebuffPlay)
    end
  end
end

function HealBot_Options_BarInClassColour_OnClick(this)
  HealBot_Config.SetBarClassColour = this:GetChecked() or 0;
  Delay_RecalcParty=1;
end

function HealBot_Options_BarTextInClassColour_OnClick(this)
  HealBot_Config.SetClassColourText = this:GetChecked() or 0;
  Delay_RecalcParty=1;
end

function HealBot_Options_BarButtonShowHoT_OnClick(this)
  HealBot_Config.ShowHoTicons = this:GetChecked() or 0;
end

function HealBot_Options_ShowHealthOnBar_OnClick(this)
  HealBot_Config.ShowHealthOnBar = this:GetChecked() or 0;
  if HealBot_Config.ShowHealthOnBar==0 then
    HealBot_BarHealthType1:Disable();
    HealBot_BarHealthType2:Disable();
    HealBot_BarHealthIncHeal:Disable();
  else
    HealBot_BarHealthType1:Enable();
    HealBot_BarHealthType2:Enable();
    HealBot_BarHealthIncHeal:Enable();
  end
  Delay_RecalcParty=1;
end

function HealBot_BarHealthType_OnClick(this,id)
  if HealBot_Config.ShowHealthOnBar>0 then
    getglobal("HealBot_BarHealthType"..HealBot_Config.BarHealthType):SetChecked(nil);
  end
  HealBot_Config.BarHealthType = id;
  if HealBot_Config.BarHealthType>0 then
    getglobal("HealBot_BarHealthType"..HealBot_Config.BarHealthType):SetChecked(1);
    Delay_RecalcParty=1;
  end
end

function HealBot_HoTonBar_OnClick(this,id)
  if HealBot_Config.HoTonBar>0 then
    getglobal("HealBot_BarButtonShowHoTonBar"..HealBot_Config.HoTonBar):SetChecked(nil);
  end
  HealBot_Config.HoTonBar = id;
  if HealBot_Config.HoTonBar>0 then
    getglobal("HealBot_BarButtonShowHoTonBar"..HealBot_Config.HoTonBar):SetChecked(1);
    HealBot_Options_ResetSkins=true;
  end
end

function HealBot_HoTposBar_OnClick(this,id)
  if HealBot_Config.HoTposBar>0 then
    getglobal("HealBot_BarButtonShowHoTposBar"..HealBot_Config.HoTposBar):SetChecked(nil);
  end
  HealBot_Config.HoTposBar = id;
  if HealBot_Config.HoTposBar>0 then
    getglobal("HealBot_BarButtonShowHoTposBar"..HealBot_Config.HoTposBar):SetChecked(1);
    HealBot_Options_ResetSkins=true;
  end
end

function HealBot_Options_ProtectPvP_OnClick(this)
  HealBot_Config.ProtectPvP = this:GetChecked() or 0;
  Delay_RecalcParty=1;
end

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

local HealBot_Options_EmergencyFClass_List = {
  HEALBOT_CLASSES_MELEE,
  HEALBOT_CLASSES_RANGES,
  HEALBOT_CLASSES_HEALERS,
  HEALBOT_CLASSES_CUSTOM,
}

local info={}
function HealBot_Options_EmergencyFClass_DropDown()
  for i=1, getn(HealBot_Options_EmergencyFClass_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_EmergencyFClass_List[i];
    info.func = HealBot_Options_EmergencyFClass_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_EmergencyFClass_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_EmergencyFClass,HealBot_Options_EmergencyFClass_DropDown)
end

function HealBot_Options_EmergencyFClass_Refresh(onselect)
  if not HealBot_Config.EmergencyFClass then return end
  if not onselect then HealBot_Options_EmergencyFClass_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_EmergencyFClass,HealBot_Config.EmergencyFClass)
end

function HealBot_Options_EmergencyFClass_OnLoad(this)
  HealBot_Options_EmergencyFClass_Initialize()
  UIDropDownMenu_SetWidth(110)
end

function HealBot_Options_EmergencyFClass_OnSelect()
  HealBot_Config.EmergencyFClass = this:GetID()
  HealBot_Options_EmergencyFClass_Refresh(true)
  HealBot_Options_EFClass_Reset()
end

function HealBot_Options_EFClass_Reset()
  if HealBot_Config.EmergencyFClass==1 then
    HealBot_Options_EFClassDruid:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_DRUID]);
    HealBot_Options_EFClassHunter:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_HUNTER]);
    HealBot_Options_EFClassMage:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_MAGE]);
    HealBot_Options_EFClassPaladin:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_PALADIN]);
    HealBot_Options_EFClassPriest:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_PRIEST]);
    HealBot_Options_EFClassRogue:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_ROGUE]);
    HealBot_Options_EFClassShaman:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_SHAMAN]);
    HealBot_Options_EFClassWarlock:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_WARLOCK]);
    HealBot_Options_EFClassWarrior:SetChecked(HealBot_Config.EmergIncMelee[HEALBOT_WARRIOR]);
  elseif HealBot_Config.EmergencyFClass==2 then
    HealBot_Options_EFClassDruid:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_DRUID]);
    HealBot_Options_EFClassHunter:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_HUNTER]);
    HealBot_Options_EFClassMage:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_MAGE]);
    HealBot_Options_EFClassPaladin:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_PALADIN]);
    HealBot_Options_EFClassPriest:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_PRIEST]);
    HealBot_Options_EFClassRogue:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_ROGUE]);
    HealBot_Options_EFClassShaman:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_SHAMAN]);
    HealBot_Options_EFClassWarlock:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_WARLOCK]);
    HealBot_Options_EFClassWarrior:SetChecked(HealBot_Config.EmergIncRange[HEALBOT_WARRIOR]);
  elseif HealBot_Config.EmergencyFClass==3 then
    HealBot_Options_EFClassDruid:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_DRUID]);
    HealBot_Options_EFClassHunter:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_HUNTER]);
    HealBot_Options_EFClassMage:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_MAGE]);
    HealBot_Options_EFClassPaladin:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_PALADIN]);
    HealBot_Options_EFClassPriest:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_PRIEST]);
    HealBot_Options_EFClassRogue:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_ROGUE]);
    HealBot_Options_EFClassShaman:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_SHAMAN]);
    HealBot_Options_EFClassWarlock:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_WARLOCK]);
    HealBot_Options_EFClassWarrior:SetChecked(HealBot_Config.EmergIncHealers[HEALBOT_WARRIOR]);
  elseif HealBot_Config.EmergencyFClass==4 then
    HealBot_Options_EFClassDruid:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_DRUID]);
    HealBot_Options_EFClassHunter:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_HUNTER]);
    HealBot_Options_EFClassMage:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_MAGE]);
    HealBot_Options_EFClassPaladin:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_PALADIN]);
    HealBot_Options_EFClassPriest:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_PRIEST]);
    HealBot_Options_EFClassRogue:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_ROGUE]);
    HealBot_Options_EFClassShaman:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_SHAMAN]);
    HealBot_Options_EFClassWarlock:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_WARLOCK]);
    HealBot_Options_EFClassWarrior:SetChecked(HealBot_Config.EmergIncCustom[HEALBOT_WARRIOR]);
  end
end

--------------------------------------------------------------------------------

local HealBot_Options_ExtraSort_List = {
  HEALBOT_SORTBY_NAME,
  HEALBOT_SORTBY_CLASS,
  HEALBOT_SORTBY_GROUP,
  HEALBOT_SORTBY_MAXHEALTH,
}

function HealBot_Options_ExtraSort_DropDown()
  for i=1, getn(HealBot_Options_ExtraSort_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_ExtraSort_List[i];
    info.func = HealBot_Options_ExtraSort_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_ExtraSort_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_ExtraSort,HealBot_Options_ExtraSort_DropDown)
end

function HealBot_Options_ExtraSort_Refresh(onselect)
  if not HealBot_Config.ExtraOrder then return end
  if not onselect then HealBot_Options_ExtraSort_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_ExtraSort,HealBot_Config.ExtraOrder)
end

function HealBot_Options_ExtraSort_OnLoad(this)
  HealBot_Options_ExtraSort_Initialize()
  UIDropDownMenu_SetWidth(110)
end

function HealBot_Options_ExtraSort_OnSelect()
  HealBot_Config.ExtraOrder = this:GetID()
  HealBot_Options_ExtraSort_Refresh(true)
  Delay_RecalcParty=1;
end

--------------------------------------------------------------------------------
local HealBot_ActionBarsCombo=1;

local HealBot_Options_ActionBarsCombo_List = {
  HEALBOT_OPTIONS_ENABLEDBARS,
  HEALBOT_OPTIONS_DISABLEDBARS,
}

function HealBot_Options_ActionBarsCombo_DropDown()
  for i=1, getn(HealBot_Options_ActionBarsCombo_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_ActionBarsCombo_List[i];
    info.func = HealBot_Options_ActionBarsCombo_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_ActionBarsCombo_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_ActionBarsCombo,HealBot_Options_ActionBarsCombo_DropDown)
end

function HealBot_Options_ActionBarsCombo_Refresh(onselect)
  if not onselect then HealBot_Options_ActionBarsCombo_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_ActionBarsCombo,HealBot_ActionBarsCombo)
end

function HealBot_Options_ActionBarsCombo_OnLoad(this)
  HealBot_Options_ActionBarsCombo_Initialize()
  UIDropDownMenu_SetWidth(240)
end

function HealBot_Options_ActionBarsCombo_OnSelect()
  HealBot_ActionBarsCombo = this:GetID()
  HealBot_Options_ActionBarsCombo_Refresh(true)
  HealBot_Options_ComboClass_Text();
end

--------------------------------------------------------------------------------

local HealBot_Options_ActionAnchor_List = {
  HEALBOT_OPTIONS_TOPLEFT,
  HEALBOT_OPTIONS_BOTTOMLEFT,
  HEALBOT_OPTIONS_TOPRIGHT,
  HEALBOT_OPTIONS_BOTTOMRIGHT,
}

function HealBot_Options_ActionAnchor_DropDown()
  for i=1, getn(HealBot_Options_ActionAnchor_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_ActionAnchor_List[i];
    info.func = HealBot_Options_ActionAnchor_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_ActionAnchor_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_ActionAnchor,HealBot_Options_ActionAnchor_DropDown)
end

function HealBot_Options_ActionAnchor_Refresh(onselect)
  if not onselect then HealBot_Options_ActionAnchor_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_ActionAnchor,HealBot_Config.Panel_Anchor)
end

function HealBot_Options_ActionAnchor_OnLoad(this)
  HealBot_Options_ActionAnchor_Initialize()
  UIDropDownMenu_SetWidth(140)
end

function HealBot_Options_ActionAnchor_OnSelect()
  HealBot_Config.Panel_Anchor = this:GetID()
  HealBot_Options_ActionAnchor_Refresh(true)
  HealBot_SetResetFlag("SOFT")
  HealBot_Config.PanelAnchorY=-1
  HealBot_Config.PanelAnchorX=-1
end

--------------------------------------------------------------------------------

local HealBot_Options_EmergencyFilter_List = {
  HEALBOT_CLASSES_ALL,
  HEALBOT_DRUID,
  HEALBOT_HUNTER,
  HEALBOT_MAGE,
  HEALBOT_PALADIN,
  HEALBOT_PRIEST,
  HEALBOT_ROGUE,
  HEALBOT_SHAMAN,
  HEALBOT_WARLOCK,
  HEALBOT_WARRIOR,
  HEALBOT_CLASSES_MELEE,
  HEALBOT_CLASSES_RANGES,
  HEALBOT_CLASSES_HEALERS,
  HEALBOT_CLASSES_CUSTOM,
}

function HealBot_Options_EmergencyFilter_DropDown()
  for i=1, getn(HealBot_Options_EmergencyFilter_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_EmergencyFilter_List[i];
    info.func = HealBot_Options_EmergencyFilter_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_EmergencyFilter_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_EmergencyFilter,HealBot_Options_EmergencyFilter_DropDown)
end

function HealBot_Options_EmergencyFilter_Refresh(onselect)
  if not HealBot_Config.EmergIncMonitor then return end
  if not onselect then HealBot_Options_EmergencyFilter_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_EmergencyFilter,HealBot_Config.EmergIncMonitor)
end

function HealBot_Options_EmergencyFilter_OnLoad(this)
  HealBot_Options_EmergencyFilter_Initialize()
  UIDropDownMenu_SetWidth(110)
end

function HealBot_Options_EmergencyFilter_OnSelect()
  HealBot_Config.EmergIncMonitor = this:GetID()
  HealBot_Options_EmergencyFilter_Refresh(true)
  HealBot_Set_DelayData_Em=true;
end

function HealBot_Options_EmergencyFilter_Reset()
  
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = 0;
  HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = 0;
  if HealBot_Config.EmergIncMonitor==1 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = 1;
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = 1;
  elseif HealBot_Config.EmergIncMonitor==2 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = 1;
  elseif HealBot_Config.EmergIncMonitor==3 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = 1;
  elseif HealBot_Config.EmergIncMonitor==4 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = 1;
  elseif HealBot_Config.EmergIncMonitor==5 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = 1;
  elseif HealBot_Config.EmergIncMonitor==6 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = 1;
  elseif HealBot_Config.EmergIncMonitor==7 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = 1;
  elseif HealBot_Config.EmergIncMonitor==8 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = 1;
  elseif HealBot_Config.EmergIncMonitor==9 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = 1;
  elseif HealBot_Config.EmergIncMonitor==10 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = 1;
  elseif HealBot_Config.EmergIncMonitor==11 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Config.EmergIncMelee[HEALBOT_DRUID];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Config.EmergIncMelee[HEALBOT_HUNTER];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Config.EmergIncMelee[HEALBOT_MAGE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Config.EmergIncMelee[HEALBOT_PALADIN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Config.EmergIncMelee[HEALBOT_PRIEST];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Config.EmergIncMelee[HEALBOT_ROGUE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Config.EmergIncMelee[HEALBOT_SHAMAN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Config.EmergIncMelee[HEALBOT_WARLOCK];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Config.EmergIncMelee[HEALBOT_WARRIOR];
  elseif HealBot_Config.EmergIncMonitor==12 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Config.EmergIncRange[HEALBOT_DRUID];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Config.EmergIncRange[HEALBOT_HUNTER];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Config.EmergIncRange[HEALBOT_MAGE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Config.EmergIncRange[HEALBOT_PALADIN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Config.EmergIncRange[HEALBOT_PRIEST];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Config.EmergIncRange[HEALBOT_ROGUE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Config.EmergIncRange[HEALBOT_SHAMAN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Config.EmergIncRange[HEALBOT_WARLOCK];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Config.EmergIncRange[HEALBOT_WARRIOR];
  elseif HealBot_Config.EmergIncMonitor==13 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Config.EmergIncHealers[HEALBOT_DRUID];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Config.EmergIncHealers[HEALBOT_HUNTER];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Config.EmergIncHealers[HEALBOT_MAGE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Config.EmergIncHealers[HEALBOT_PALADIN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Config.EmergIncHealers[HEALBOT_PRIEST];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Config.EmergIncHealers[HEALBOT_ROGUE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Config.EmergIncHealers[HEALBOT_SHAMAN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Config.EmergIncHealers[HEALBOT_WARLOCK];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Config.EmergIncHealers[HEALBOT_WARRIOR];
  elseif HealBot_Config.EmergIncMonitor==14 then
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_DRUID]] = HealBot_Config.EmergIncCustom[HEALBOT_DRUID];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_HUNTER]] = HealBot_Config.EmergIncCustom[HEALBOT_HUNTER];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_MAGE]] = HealBot_Config.EmergIncCustom[HEALBOT_MAGE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PALADIN]] = HealBot_Config.EmergIncCustom[HEALBOT_PALADIN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_PRIEST]] = HealBot_Config.EmergIncCustom[HEALBOT_PRIEST];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_ROGUE]] = HealBot_Config.EmergIncCustom[HEALBOT_ROGUE];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_SHAMAN]] = HealBot_Config.EmergIncCustom[HEALBOT_SHAMAN];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARLOCK]] = HealBot_Config.EmergIncCustom[HEALBOT_WARLOCK];
    HealBot_EmergInc[HealBot_Class_En[HEALBOT_WARRIOR]] = HealBot_Config.EmergIncCustom[HEALBOT_WARRIOR];
  end

  Delay_RecalcParty=1;
end

--------------------------------------------------------------------------------

function HealBot_Options_Skins_DropDown()
  for i=1, getn(HealBot_Skins), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Skins[i];
    info.func = HealBot_Options_Skins_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_Skins_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_Skins,HealBot_Options_Skins_DropDown)
end

function HealBot_Options_Skins_Refresh(onselect)
  if not HealBot_Config.Skin_ID then return end
  if not onselect then HealBot_Options_Skins_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_Skins,HealBot_Config.Skin_ID)
end

function HealBot_Options_Skins_OnLoad(this)
  HealBot_Options_Skins_Initialize()
  UIDropDownMenu_SetWidth(140)
end

function HealBot_Options_Skins_OnSelect()
  HealBot_Config.Skin_ID = this:GetID()
  HealBot_Options_Skins_Refresh(true)
  if this:GetID()>=1 then
    HealBot_Config.Current_Skin = this:GetText()
      HealBot_Options_SetSkins();
  end
end

--------------------------------------------------------------------------------

local HealBot_Options_TooltipPos_List = {
  HEALBOT_TOOLTIP_POSDEFAULT,
  HEALBOT_TOOLTIP_POSLEFT,
  HEALBOT_TOOLTIP_POSRIGHT,
  HEALBOT_TOOLTIP_POSABOVE,
  HEALBOT_TOOLTIP_POSBELOW,
  HEALBOT_TOOLTIP_POSCURSOR,
}

function HealBot_Options_TooltipPos_DropDown()
  for i=1, getn(HealBot_Options_TooltipPos_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_TooltipPos_List[i];
    info.func = HealBot_Options_TooltipPos_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_TooltipPos_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_TooltipPos,HealBot_Options_TooltipPos_DropDown)
end

function HealBot_Options_TooltipPos_Refresh(onselect)
  if not HealBot_Config.TooltipPos then return end
  if not onselect then HealBot_Options_TooltipPos_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_TooltipPos,HealBot_Config.TooltipPos)
end

function HealBot_Options_TooltipPos_OnLoad(this)
  HealBot_Options_TooltipPos_Initialize()
  UIDropDownMenu_SetWidth(128)
end

function HealBot_Options_TooltipPos_OnSelect()
  HealBot_Config.TooltipPos = this:GetID()
  HealBot_Options_TooltipPos_Refresh(true)
end

--------------------------------------------------------------------------------

local HealBot_Options_BuffTxt_List = {
HEALBOT_WORDS_NONE,
HEALBOT_OPTIONS_BUFFSELF,
HEALBOT_OPTIONS_BUFFPARTY,
HEALBOT_OPTIONS_BUFFRAID,
HEALBOT_DRUID,
HEALBOT_HUNTER,
HEALBOT_MAGE,
HEALBOT_PALADIN,
HEALBOT_PRIEST,
HEALBOT_ROGUE,
HEALBOT_SHAMAN,
HEALBOT_WARLOCK,
HEALBOT_WARRIOR,
HEALBOT_CLASSES_MELEE,
HEALBOT_CLASSES_RANGES,
HEALBOT_CLASSES_HEALERS,
HEALBOT_CLASSES_CUSTOM,
HEALBOT_SELF_PVP,
HEALBOT_OPTIONS_TANKHEALS,
HEALBOT_OPTIONS_MYTARGET,
}

local HealBot_Buff_Spells_Total_List = {
 HEALBOT_POWER_WORD_FORTITUDE,
 HEALBOT_PRAYER_OF_FORTITUDE,
 HEALBOT_INNER_FIRE,
 HEALBOT_TOUCH_OF_WEAKNESS,
 HEALBOT_FEAR_WARD,
 HEALBOT_DIVINE_SPIRIT,
 HEALBOT_PRAYER_OF_SPIRIT,
 HEALBOT_SHADOW_PROTECTION,
 HEALBOT_PRAYER_OF_SHADOW_PROTECTION,
 HEALBOT_MARK_OF_THE_WILD,
 HEALBOT_GIFT_OF_THE_WILD,
 HEALBOT_THORNS,
 HEALBOT_OMEN_OF_CLARITY,
 HEALBOT_BLESSING_OF_MIGHT,
 HEALBOT_BLESSING_OF_WISDOM,
 HEALBOT_BLESSING_OF_SALVATION,
 HEALBOT_BLESSING_OF_SANCTUARY,
 HEALBOT_BLESSING_OF_LIGHT,
 HEALBOT_BLESSING_OF_PROTECTION,
 HEALBOT_BLESSING_OF_FREEDOM,
 HEALBOT_BLESSING_OF_SACRIFICE,
 HEALBOT_BLESSING_OF_KINGS,
 HEALBOT_GREATER_BLESSING_OF_MIGHT,
 HEALBOT_GREATER_BLESSING_OF_WISDOM,
 HEALBOT_GREATER_BLESSING_OF_KINGS,
 HEALBOT_GREATER_BLESSING_OF_LIGHT,
 HEALBOT_GREATER_BLESSING_OF_SALVATION,
 HEALBOT_GREATER_BLESSING_OF_SANCTUARY,
 HEALBOT_ARCANE_INTELLECT,
 HEALBOT_ARCANE_BRILLIANCE,
 HEALBOT_FROST_ARMOR,
 HEALBOT_ICE_ARMOR,
 HEALBOT_MAGE_ARMOR,
 HEALBOT_DEMON_ARMOR,
 HEALBOT_DEMON_SKIN,
 HEALBOT_LIGHTNING_SHIELD,
 HEALBOT_ROCKBITER_WEAPON,
 HEALBOT_FLAMETONGUE_WEAPON,
 HEALBOT_FROSTBRAND_WEAPON,
 HEALBOT_EARTH_SHIELD,
 HEALBOT_WATER_SHIELD,
 HEALBOT_MOLTEN_ARMOR,
 HEALBOT_DAMPEN_MAGIC,
 HEALBOT_AMPLIFY_MAGIC,
 HEALBOT_FEL_ARMOR,
 HEALBOT_WIND_FURY,
 HEALBOT_SHADOW_GUARD,
 HEALBOT_DETECT_INV,
 HEALBOT_RIGHTEOUS_FURY,
 HEALBOT_DEVOTION_AURA,
 HEALBOT_RETRIBUTION_AURA,
 HEALBOT_CONCENTRATION_AURA,
 HEALBOT_SHR_AURA,
 HEALBOT_FRR_AURA,
 HEALBOT_FIR_AURA,
 HEALBOT_CRUSADER_AURA,
 HEALBOT_SANCTITY_AURA,
 HEALBOT_A_MONKEY,
 HEALBOT_A_HAWK,
 HEALBOT_A_CHEETAH,
 HEALBOT_A_BEAST,
 HEALBOT_A_PACK,
 HEALBOT_A_WILD,
 HEALBOT_A_VIPER,
 HEALBOT_UNENDING_BREATH,
}

local HealBot_Buff_Spells_List ={}

function HealBot_Options_InitBuffList()
 	HealBot_Buff_Spells_List ={}
  --if not HealBot_Buff_Spells_List[1] then
    for i=1, getn(HealBot_Buff_Spells_Total_List), 1 do
      spellid=HealBot_GetSpellId(HealBot_Buff_Spells_Total_List[i]);
      if spellid then
        table.insert(HealBot_Buff_Spells_List,HealBot_Buff_Spells_Total_List[i])
      end
    end
	return HealBot_Buff_Spells_List
 -- end
end

local spell=nil
local spellid=nil
function HealBot_Options_BuffTxt1_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[1];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt1_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt1_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt1_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt2_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[2];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt2_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt2_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt2_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt3_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[3];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt3_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt3_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt3_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt4_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[4];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt4_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt4_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt4_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt5_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[5];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt5_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt5_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt5_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt6_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[6];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt6_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt6_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt6_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt7_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[7];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt7_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt7_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt7_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt8_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[8];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt8_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt8_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt8_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffTxt9_DropDown()
     local savedBuff = nil;
     local foundBuff = false;
     if HealBot_Config.HealBotBuffText then
       savedBuff = HealBot_Config.HealBotBuffText[9];
       if savedBuff == HEALBOT_WORDS_NONE then
         foundBuff = true;
       end
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_BuffTxt9_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(HealBot_Buff_Spells_List), 1 do
     if HealBot_Buff_Spells_List[i] == savedBuff then 
       foundBuff = true;
     end
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = HealBot_Buff_Spells_List[i];
        info.func = HealBot_Options_BuffTxt9_OnSelect;
        UIDropDownMenu_AddButton(info);
    end
    if not foundBuff and savedBuff then
    	for x,_ in pairs(info) do
       info[x]=nil;
     	end
     	info.text = savedBuff;
     	info.func = HealBot_Options_BuffTxt9_OnSelect;
     	UIDropDownMenu_AddButton(info);
    end	
end

function HealBot_Options_BuffGroups1_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups1_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups2_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups2_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups3_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups3_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups4_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups4_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups5_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups5_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups6_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups6_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups7_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups7_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups8_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups8_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffGroups9_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_BuffGroups9_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_BuffTxt1_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt1,HealBot_Options_BuffTxt1_DropDown)
end

function HealBot_Options_BuffTxt2_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt2,HealBot_Options_BuffTxt2_DropDown)
end

function HealBot_Options_BuffTxt3_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt3,HealBot_Options_BuffTxt3_DropDown)
end

function HealBot_Options_BuffTxt4_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt4,HealBot_Options_BuffTxt4_DropDown)
end

function HealBot_Options_BuffTxt5_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt5,HealBot_Options_BuffTxt5_DropDown)
end

function HealBot_Options_BuffTxt6_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt6,HealBot_Options_BuffTxt6_DropDown)
end

function HealBot_Options_BuffTxt7_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt7,HealBot_Options_BuffTxt7_DropDown)
end

function HealBot_Options_BuffTxt8_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt8,HealBot_Options_BuffTxt8_DropDown)
end

function HealBot_Options_BuffTxt9_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffTxt9,HealBot_Options_BuffTxt9_DropDown)
end

function HealBot_Options_BuffGroups1_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups1,HealBot_Options_BuffGroups1_DropDown)
end

function HealBot_Options_BuffGroups2_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups2,HealBot_Options_BuffGroups2_DropDown)
end

function HealBot_Options_BuffGroups3_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups3,HealBot_Options_BuffGroups3_DropDown)
end

function HealBot_Options_BuffGroups4_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups4,HealBot_Options_BuffGroups4_DropDown)
end

function HealBot_Options_BuffGroups5_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups5,HealBot_Options_BuffGroups5_DropDown)
end

function HealBot_Options_BuffGroups6_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups6,HealBot_Options_BuffGroups6_DropDown)
end

function HealBot_Options_BuffGroups7_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups7,HealBot_Options_BuffGroups7_DropDown)
end

function HealBot_Options_BuffGroups8_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups8,HealBot_Options_BuffGroups8_DropDown)
end

function HealBot_Options_BuffGroups9_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_BuffGroups9,HealBot_Options_BuffGroups9_DropDown)
end

local BuffSpellDropDownClass=nil
function HealBot_Options_BuffTxt1_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[1] then return end;
  if not onselect then HealBot_Options_BuffTxt1_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt1,BuffTextClass[1])
end

function HealBot_Options_BuffTxt2_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[2] then return end;
  if not onselect then HealBot_Options_BuffTxt2_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt2,BuffTextClass[2])
end

function HealBot_Options_BuffTxt3_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[3] then return end;
  if not onselect then HealBot_Options_BuffTxt3_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt3,BuffTextClass[3])
end

function HealBot_Options_BuffTxt4_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[4] then return end;
  if not onselect then HealBot_Options_BuffTxt4_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt4,BuffTextClass[4])
end

function HealBot_Options_BuffTxt5_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[5] then return end;
  if not onselect then HealBot_Options_BuffTxt5_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt5,BuffTextClass[5])
end

function HealBot_Options_BuffTxt6_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[6] then return end;
  if not onselect then HealBot_Options_BuffTxt6_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt6,BuffTextClass[6])
end

function HealBot_Options_BuffTxt7_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[7] then return end;
  if not onselect then HealBot_Options_BuffTxt7_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt7,BuffTextClass[7])
end

function HealBot_Options_BuffTxt8_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[8] then return end;
  if not onselect then HealBot_Options_BuffTxt8_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt8,BuffTextClass[8])
end

function HealBot_Options_BuffTxt9_Refresh(onselect)
  BuffTextClass = HealBot_Config.HealBotBuffText
  if not BuffTextClass[9] then return end;
  if not onselect then HealBot_Options_BuffTxt9_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedValue(HealBot_Options_BuffTxt9,BuffTextClass[9])
end

local BuffDropDownClass=nil
function HealBot_Options_BuffGroups1_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[1] then return end;
  if not onselect then HealBot_Options_BuffGroups1_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups1,BuffDropDownClass[1])
end

function HealBot_Options_BuffGroups2_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[2] then return end;
  if not onselect then HealBot_Options_BuffGroups2_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups2,BuffDropDownClass[2])
end

function HealBot_Options_BuffGroups3_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[3] then return end;
  if not onselect then HealBot_Options_BuffGroups3_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups3,BuffDropDownClass[3])
end

function HealBot_Options_BuffGroups4_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[4] then return end;
  if not onselect then HealBot_Options_BuffGroups4_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups4,BuffDropDownClass[4])
end

function HealBot_Options_BuffGroups5_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[5] then return end;
  if not onselect then HealBot_Options_BuffGroups5_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups5,BuffDropDownClass[5])
end

function HealBot_Options_BuffGroups6_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[6] then return end;
  if not onselect then HealBot_Options_BuffGroups6_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups6,BuffDropDownClass[6])
end

function HealBot_Options_BuffGroups7_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[7] then return end;
  if not onselect then HealBot_Options_BuffGroups7_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups7,BuffDropDownClass[7])
end

function HealBot_Options_BuffGroups8_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[8] then return end;
  if not onselect then HealBot_Options_BuffGroups8_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups8,BuffDropDownClass[8])
end

function HealBot_Options_BuffGroups9_Refresh(onselect)
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  if not BuffDropDownClass[9] then return end;
  if not onselect then HealBot_Options_BuffGroups9_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_BuffGroups9,BuffDropDownClass[9])
end

function HealBot_Options_BuffTxt1_OnLoad(this)
  HealBot_Options_BuffTxt1_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt2_OnLoad(this)
  HealBot_Options_BuffTxt2_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt3_OnLoad(this)
  HealBot_Options_BuffTxt3_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt4_OnLoad(this)
  HealBot_Options_BuffTxt4_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt5_OnLoad(this)
  HealBot_Options_BuffTxt5_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt6_OnLoad(this)
  HealBot_Options_BuffTxt6_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt7_OnLoad(this)
  HealBot_Options_BuffTxt7_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt8_OnLoad(this)
  HealBot_Options_BuffTxt8_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffTxt9_OnLoad(this)
  HealBot_Options_BuffTxt9_Initialize()
  UIDropDownMenu_SetWidth(155)
end

function HealBot_Options_BuffGroups1_OnLoad(this)
  HealBot_Options_BuffGroups1_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups2_OnLoad(this)
  HealBot_Options_BuffGroups2_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups3_OnLoad(this)
  HealBot_Options_BuffGroups3_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups4_OnLoad(this)
  HealBot_Options_BuffGroups4_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups5_OnLoad(this)
  HealBot_Options_BuffGroups5_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups6_OnLoad(this)
  HealBot_Options_BuffGroups6_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups7_OnLoad(this)
  HealBot_Options_BuffGroups7_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups8_OnLoad(this)
  HealBot_Options_BuffGroups8_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffGroups9_OnLoad(this)
  HealBot_Options_BuffGroups9_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_BuffTxt1_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[1] = this:GetText()
  HealBot_Options_BuffTxt1_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt2_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[2] = this:GetText()
  HealBot_Options_BuffTxt2_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt3_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[3] = this:GetText()
  HealBot_Options_BuffTxt3_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt4_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[4] = this:GetText()
  HealBot_Options_BuffTxt4_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt5_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[5] = this:GetText()
  HealBot_Options_BuffTxt5_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt6_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[6] = this:GetText()
  HealBot_Options_BuffTxt6_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt7_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[7] = this:GetText()
  HealBot_Options_BuffTxt7_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt8_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[8] = this:GetText()
  HealBot_Options_BuffTxt8_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffTxt9_OnSelect()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffTextClass[9] = this:GetText()
  HealBot_Options_BuffTxt9_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups1_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[1] = this:GetID()
  HealBot_Options_BuffGroups1_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups2_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[2] = this:GetID()
  HealBot_Options_BuffGroups2_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups3_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[3] = this:GetID()
  HealBot_Options_BuffGroups3_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups4_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[4] = this:GetID()
  HealBot_Options_BuffGroups4_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups5_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[5] = this:GetID()
  HealBot_Options_BuffGroups5_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups6_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[6] = this:GetID()
  HealBot_Options_BuffGroups6_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups7_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[7] = this:GetID()
  HealBot_Options_BuffGroups7_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups8_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[8] = this:GetID()
  HealBot_Options_BuffGroups8_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

function HealBot_Options_BuffGroups9_OnSelect()
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  BuffDropDownClass[9] = this:GetID()
  HealBot_Options_BuffGroups9_Refresh(true)
  HealBot_Set_DelayData_Buff=true;
end

--------------------------------------------------------------------------------

local HealBot_Options_ComboClass_List = {
  HEALBOT_DRUID,
  HEALBOT_PALADIN,
  HEALBOT_PRIEST,
  HEALBOT_SHAMAN,
}

local HealBot_Debuff_Item_List = {
  HEALBOT_PURIFICATION_POTION,
  HEALBOT_ELIXIR_OF_POISON_RES,
  HEALBOT_ANTI_VENOM,
  HEALBOT_POWERFUL_ANTI_VENOM,
}

function HealBot_Options_GetDebuffSpells_List(class)
  return HealBot_Debuff_Spells[class]
end

function HealBot_Options_GetRacialDebuffSpells_List(race)
  return HealBot_Racial_Debuff_Spells[race]
end

local DebuffSpells_List=nil
local RacialDebuffSpells_List=nil
function HealBot_Options_CDCTxt1_DropDown()
    DebuffSpells_List = HealBot_Options_GetDebuffSpells_List(strsub(HealBot_PlayerClassEN,1,4))
    RacialDebuffSpells_List = HealBot_Options_GetRacialDebuffSpells_List(strsub(HealBot_PlayerRaceEN,1,3))
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_CDCTxt1_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(DebuffSpells_List), 1 do
      spell, spellrank=HealBot_GetSpellName(HealBot_GetSpellId(DebuffSpells_List[i]));
      if spell then
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = spell;
        info.func = HealBot_Options_CDCTxt1_OnSelect;
        UIDropDownMenu_AddButton(info);
      end
    end
    for i=1, getn(RacialDebuffSpells_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
     info.text = RacialDebuffSpells_List[i];
     info.func = HealBot_Options_CDCTxt1_OnSelect;
     UIDropDownMenu_AddButton(info);
    end
    for i=1, getn(HealBot_Debuff_Item_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
      info.text = HealBot_Debuff_Item_List[i];
      info.func = HealBot_Options_CDCTxt1_OnSelect;
      UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCTxt2_DropDown()
    DebuffSpells_List = HealBot_Options_GetDebuffSpells_List(strsub(HealBot_PlayerClassEN,1,4))
    RacialDebuffSpells_List = HealBot_Options_GetRacialDebuffSpells_List(strsub(HealBot_PlayerRaceEN,1,3))
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_CDCTxt2_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(DebuffSpells_List), 1 do
      spell, spellrank=HealBot_GetSpellName(HealBot_GetSpellId(DebuffSpells_List[i]));
      if spell then
     for x,_ in pairs(info) do
       info[x]=nil;
     end
        info.text = spell;
        info.func = HealBot_Options_CDCTxt2_OnSelect;
        UIDropDownMenu_AddButton(info);
      end
    end
    for i=1, getn(RacialDebuffSpells_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
     info.text = RacialDebuffSpells_List[i];
     info.func = HealBot_Options_CDCTxt2_OnSelect;
     UIDropDownMenu_AddButton(info);
    end
    for i=1, getn(HealBot_Debuff_Item_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
      info.text = HealBot_Debuff_Item_List[i];
      info.func = HealBot_Options_CDCTxt2_OnSelect;
      UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCTxt3_DropDown()
    DebuffSpells_List = HealBot_Options_GetDebuffSpells_List(strsub(HealBot_PlayerClassEN,1,4))
    RacialDebuffSpells_List = HealBot_Options_GetRacialDebuffSpells_List(strsub(HealBot_PlayerRaceEN,1,3))
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HEALBOT_WORDS_NONE;
    info.func = HealBot_Options_CDCTxt3_OnSelect;
    UIDropDownMenu_AddButton(info);
    for i=1, getn(DebuffSpells_List), 1 do
      spell, spellrank=HealBot_GetSpellName(HealBot_GetSpellId(DebuffSpells_List[i]));
      if spell then
        for x,_ in pairs(info) do
          info[x]=nil;
        end
        info.text = spell;
        info.func = HealBot_Options_CDCTxt3_OnSelect;
        UIDropDownMenu_AddButton(info);
      end
    end
    for i=1, getn(RacialDebuffSpells_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
     info.text = RacialDebuffSpells_List[i];
     info.func = HealBot_Options_CDCTxt3_OnSelect;
     UIDropDownMenu_AddButton(info);
    end
    for i=1, getn(HealBot_Debuff_Item_List), 1 do
      for x,_ in pairs(info) do
        info[x]=nil;
      end
      info.text = HealBot_Debuff_Item_List[i];
      info.func = HealBot_Options_CDCTxt3_OnSelect;
      UIDropDownMenu_AddButton(info);
    end
end

function HealBot_Options_CDCGroups1_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_CDCGroups1_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_CDCGroups2_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_CDCGroups2_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_CDCGroups3_DropDown()
  for i=1, getn(HealBot_Options_BuffTxt_List), 1 do
     for x,_ in pairs(info) do
       info[x]=nil;
     end
    info.text = HealBot_Options_BuffTxt_List[i];
    info.func = HealBot_Options_CDCGroups3_OnSelect;
    UIDropDownMenu_AddButton(info);
  end
end

function HealBot_Options_CDCTxt1_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDCTxt1,HealBot_Options_CDCTxt1_DropDown)
end

function HealBot_Options_CDCTxt2_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDCTxt2,HealBot_Options_CDCTxt2_DropDown)
end

function HealBot_Options_CDCTxt3_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDCTxt3,HealBot_Options_CDCTxt3_DropDown)
end

function HealBot_Options_CDCGroups1_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDCGroups1,HealBot_Options_CDCGroups1_DropDown)
end

function HealBot_Options_CDCGroups2_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDCGroups2,HealBot_Options_CDCGroups2_DropDown)
end

function HealBot_Options_CDCGroups3_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDCGroups3,HealBot_Options_CDCGroups3_DropDown)
end

local DebuffSpellDropDownClass=nil
function HealBot_Options_CDCTxt1_Refresh(onselect)
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  if not DebuffTextClass then return; end
  if not onselect then HealBot_Options_CDCTxt1_Initialize() end 
  UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt1,DebuffTextClass[1])
end

function HealBot_Options_CDCTxt2_Refresh(onselect)
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  if not DebuffTextClass then return; end
  if not onselect then HealBot_Options_CDCTxt2_Initialize() end 
  UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt2,DebuffTextClass[2])
end

function HealBot_Options_CDCTxt3_Refresh(onselect)
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  if not DebuffTextClass then return; end
  if not onselect then HealBot_Options_CDCTxt3_Initialize() end 
  UIDropDownMenu_SetSelectedValue(HealBot_Options_CDCTxt3,DebuffTextClass[3])
end

local DebuffDropDownClass=nil
function HealBot_Options_CDCGroups1_Refresh(onselect)
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
  if not DebuffDropDownClass[1] then return end;
  if not onselect then HealBot_Options_CDCGroups1_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_CDCGroups1,DebuffDropDownClass[1])
end

function HealBot_Options_CDCGroups2_Refresh(onselect)
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
  if not DebuffDropDownClass[2] then return end;
  if not onselect then HealBot_Options_CDCGroups2_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_CDCGroups2,DebuffDropDownClass[2])
end

function HealBot_Options_CDCGroups3_Refresh(onselect)
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
  if not DebuffDropDownClass[3] then return end;
  if not onselect then HealBot_Options_CDCGroups3_Initialize() end  -- or wrong menu may be used !
  UIDropDownMenu_SetSelectedID(HealBot_Options_CDCGroups3,DebuffDropDownClass[3])
end

local combo=nil
local button=nil
function HealBot_Options_ComboClass_Text()
  if HealBot_ActionBarsCombo==1 then
    combo = HealBot_Config.EnabledKeyCombo;
  else
    combo = HealBot_Config.DisabledKeyCombo;
  end
  button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
  if combo then
    HealBot_Options_Click:SetText(combo[button] or "")
    HealBot_Options_Shift:SetText(combo["Shift"..button] or "")
    HealBot_Options_Ctrl:SetText(combo["Ctrl"..button] or "")
    HealBot_Options_Alt:SetText(combo["Alt"..button] or "")
  end
end

function HealBot_Options_CDCTxt1_OnLoad(this)
  HealBot_Options_CDCTxt1_Initialize()
  UIDropDownMenu_SetWidth(170)
end

function HealBot_Options_CDCTxt2_OnLoad(this)
  HealBot_Options_CDCTxt2_Initialize()
  UIDropDownMenu_SetWidth(170)
end

function HealBot_Options_CDCTxt3_OnLoad(this)
  HealBot_Options_CDCTxt3_Initialize()
  UIDropDownMenu_SetWidth(170)
end

function HealBot_Options_CDCGroups1_OnLoad(this)
  HealBot_Options_CDCGroups1_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_CDCGroups2_OnLoad(this)
  HealBot_Options_CDCGroups2_Initialize()
  UIDropDownMenu_SetWidth(75)
end

function HealBot_Options_CDCGroups3_OnLoad(this)
  HealBot_Options_CDCGroups3_Initialize()
  UIDropDownMenu_SetWidth(75)
end

local DebuffTextClass=nil
function HealBot_Options_CDCTxt1_OnSelect()
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  DebuffTextClass[1] = this:GetText()
  HealBot_Options_CDCTxt1_Refresh(true)
  HealBot_Set_DelayData_Debuff=true;
end

function HealBot_Options_CDCTxt2_OnSelect()
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  DebuffTextClass[2] = this:GetText()
  HealBot_Options_CDCTxt2_Refresh(true)
  HealBot_Set_DelayData_Debuff=true;
end

function HealBot_Options_CDCTxt3_OnSelect()
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  DebuffTextClass[3] = this:GetText()
  HealBot_Options_CDCTxt3_Refresh(true)
  HealBot_Set_DelayData_Debuff=true;
end

function HealBot_Options_CDCGroups1_OnSelect()
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
  DebuffDropDownClass[1] = this:GetID()
  HealBot_Options_CDCGroups1_Refresh(true)
  HealBot_Set_DelayData_Debuff=true;
end

function HealBot_Options_CDCGroups2_OnSelect()
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
  DebuffDropDownClass[2] = this:GetID()
  HealBot_Options_CDCGroups2_Refresh(true)
  HealBot_Set_DelayData_Debuff=true;
end

function HealBot_Options_CDCGroups3_OnSelect()
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
  DebuffDropDownClass[3] = this:GetID()
  HealBot_Options_CDCGroups3_Refresh(true)
  HealBot_Set_DelayData_Debuff=true;
end


function HealBot_Options_CDebuffTxt1_DropDown() -- added by Diacono
  local t = HealBot_Config.HealBot_Custom_Debuffs
  if t then
  	local t2 = {}
		table.foreach (t, function (k) table.insert (t2, k) end )
		table.sort (t2)
  
  	for x,_ in pairs(info) do
    	info[x]=nil;
  	end

  	for i=1, getn(t2), 1 do
   		for x,_ in pairs(info) do
     		info[x]=nil;
   		end
    	info.text = t2[i];
    	info.func = HealBot_Options_CDebuffTxt1_OnSelect;
    	UIDropDownMenu_AddButton(info);
  	end
	end
end

function HealBot_Options_CDebuffTxt1_OnSelect()
  UIDropDownMenu_SetSelectedValue(HealBot_Options_CDebuffTxt1, this.value);
  HealBot_Options_DeleteCDebuffBtn:Enable();
end

function HealBot_Options_CDebuffTxt1_Initialize()
  UIDropDownMenu_Initialize(HealBot_Options_CDebuffTxt1,HealBot_Options_CDebuffTxt1_DropDown)
end

function HealBot_Options_CDebuffTxt1_OnLoad(this)
  HealBot_Options_CDebuffTxt1_Initialize()
  UIDropDownMenu_SetWidth(140)
end

function HealBot_Options_NewCDebuff_OnTextChanged(this)
  local text = strtrim(this:GetText())
  if strlen(text)>0 then
    HealBot_Options_NewCDebuffBtn:Enable();
  else
    HealBot_Options_NewCDebuffBtn:Disable();
  end
end

function HealBot_Options_GetSpellInfo_OnEnterPressed(this)
  local text = strtrim(this:GetText())
  if strlen(text)>0 then
  	local spellID = tonumber(text)
		if spellID then
   		local name, rank = GetSpellInfo(spellID)
   		text = name;
   		if rank then 
   			if rank:match("(%d+)") then
   				text = text.."("..rank..")";
   			end
   		end
		end
  end
  if text then
  	this:SetText(text)
  else
  	this:SetText("")
  end
end

function HealBot_Options_NewCDebuffBtn_OnClick(this)
  local NewCDebuffTxt=HealBot_Options_NewCDebuff:GetText()
  local unique=true;
  for k, v in pairs(HealBot_Config.HealBot_Custom_Debuffs) do
  	if index==NewCDebuffTxt then unique=false; end
  end
  if unique then
    HealBot_Config.HealBot_Custom_Debuffs[NewCDebuffTxt]=true;
  end
  HealBot_Options_NewCDebuff:SetText("")
  --UIDropDownMenu_ClearAll(HealBot_Options_CDebuffTxt1);
  HealBot_Options_CDebuffTxt1_Initialize()
  UIDropDownMenu_SetSelectedValue(HealBot_Options_CDebuffTxt1, NewCDebuffTxt);
end

function HealBot_Options_DeleteCDebuffBtn_OnClick(this)
  HealBot_Config.HealBot_Custom_Debuffs[HealBot_Options_CDebuffTxt1.selectedValue]=nil;
  UIDropDownMenu_ClearAll(HealBot_Options_CDebuffTxt1);
  HealBot_Options_DeleteCDebuffBtn:Disable();
  HealBot_Options_CDebuffTxt1_Initialize()
end

function HealBot_Options_ComboClass_Button(id)
  if id==2 then button = "Middle"
  elseif id==3 then button = "Right"
  elseif id==4 then button = "Button4"
  elseif id==5 then button = "Button5"
  else button = "Left"
  end
  return button;
end

local id=nil
local usable=nil
local noMana=nil
local HealBot_DebuffWatchTargetSpell=nil
function HealBot_Options_Debuff_Reset()
    HealBot_DebuffWatchTarget[HEALBOT_DISEASE_en] = {HEALBOT_DISEASE_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_POISON_en] = {HEALBOT_POISON_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_MAGIC_en] = {HEALBOT_MAGIC_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_CURSE_en] = {HEALBOT_CURSE_en = {}};
    HealBot_DebuffWatchTarget[HEALBOT_CUSTOM_en] = {HEALBOT_CUSTOM_en = {}}; -- added by Diacono
  for x,_ in pairs(HealBot_DebuffSpell) do
    HealBot_DebuffSpell[x]=nil;
  end
  for x,_ in pairs(HealBot_DebuffWatchPvP) do
    HealBot_DebuffWatchPvP[x]=nil;
  end
  HealBot_DebuffPriority = nil;
  DebuffTextClass = HealBot_Config.HealBotDebuffText
  DebuffDropDownClass = HealBot_Config.HealBotDebuffDropDown
    
  for k=1,3 do
    if DebuffDropDownClass[k] and DebuffDropDownClass[k]>1 then
      id=HealBot_GetSpellId(DebuffTextClass[k]);
      spell,spellrank = HealBot_GetSpellName(id);
      if spellrank and (spell ~= HEALBOT_STONEFORM) then -- added by Diacono
        spell=spell .. "(" .. spellrank .. ")";
      end
      if not spell then
        usable, noMana = IsUsableItem(DebuffTextClass[k]);
        if usable then
          spell=DebuffTextClass[k];
        end
      end
      if HealBot_Debuff_Types[spell] then
        table.foreach(HealBot_Debuff_Types[spell], function (index,debuff)
          if not HealBot_DebuffSpell[debuff] then
            HealBot_DebuffSpell[debuff]=spell;
          end
          HealBot_DebuffWatchTargetSpell=HealBot_DebuffWatchTarget[debuff];

          if not HealBot_DebuffPriority then
            HealBot_DebuffPriority=debuff;
          end
          if DebuffDropDownClass[k]==2 then
            HealBot_DebuffWatchTargetSpell["Self"]=true;
          elseif DebuffDropDownClass[k]==3 then
            HealBot_DebuffWatchTargetSpell["Party"]=true;
          elseif DebuffDropDownClass[k]==4 then
            HealBot_DebuffWatchTargetSpell["Raid"]=true;
          elseif DebuffDropDownClass[k]==5 then
	  	    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
          elseif DebuffDropDownClass[k]==6 then
		    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
          elseif DebuffDropDownClass[k]==7 then
	        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
          elseif DebuffDropDownClass[k]==8 then
		    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
          elseif DebuffDropDownClass[k]==9 then
	        HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
          elseif DebuffDropDownClass[k]==10 then
            HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
          elseif DebuffDropDownClass[k]==11 then
		    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
          elseif DebuffDropDownClass[k]==12 then
		    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
          elseif DebuffDropDownClass[k]==13 then
		    HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
          elseif DebuffDropDownClass[k]==14 then
            if HealBot_Config.EmergIncMelee[HEALBOT_DRUID]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_HUNTER]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_MAGE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_PALADIN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_PRIEST]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_ROGUE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_SHAMAN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_WARLOCK]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
            end
            if HealBot_Config.EmergIncMelee[HEALBOT_WARRIOR]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
            end
          elseif DebuffDropDownClass[k]==15 then
            if HealBot_Config.EmergIncRange[HEALBOT_DRUID]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_HUNTER]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_MAGE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_PALADIN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_PRIEST]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_ROGUE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_SHAMAN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_WARLOCK]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
            end
            if HealBot_Config.EmergIncRange[HEALBOT_WARRIOR]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
            end
          elseif DebuffDropDownClass[k]==16 then
            if HealBot_Config.EmergIncHealers[HEALBOT_DRUID]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_HUNTER]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_MAGE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_PALADIN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_PRIEST]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_ROGUE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_SHAMAN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_WARLOCK]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
            end
            if HealBot_Config.EmergIncHealers[HEALBOT_WARRIOR]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
            end
          elseif DebuffDropDownClass[k]==17 then
            if HealBot_Config.EmergIncCustom[HEALBOT_DRUID]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_HUNTER]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_MAGE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_PALADIN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_PRIEST]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_ROGUE]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_SHAMAN]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_WARLOCK]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
            end
            if HealBot_Config.EmergIncCustom[HEALBOT_WARRIOR]==1 then
              HealBot_DebuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
            end
		  elseif DebuffDropDownClass[k]==18 then
		    HealBot_DebuffWatchTargetSpell["PvP"]=true
		  elseif DebuffDropDownClass[k]==19 then
		  	HealBot_DebuffWatchTargetSpell["MainTanks"]=true
		  elseif DebuffDropDownClass[k]==20 then
		  	HealBot_DebuffWatchTargetSpell["MyTargets"]=true
      end

--          local WatchTarget=HealBot_DebuffWatchTarget[debuff];
        
        end)
      end
    end
    HealBot_CheckDebuffs=true;
  end
end


local spells={}
local Monitor_Buffs=nil
local HealBot_BuffWatchTargetSpell=nil
function HealBot_Options_Buff_Reset()
  BuffTextClass = HealBot_Config.HealBotBuffText
  BuffDropDownClass = HealBot_Config.HealBotBuffDropDown
  buffbarcolrClass = HealBot_Config.HealBotBuffColR
  buffbarcolgClass = HealBot_Config.HealBotBuffColG
  buffbarcolbClass = HealBot_Config.HealBotBuffColB
  Monitor_Buffs=false;
  for x,_ in pairs(spells) do
    spells[x]=nil;
  end
  for x,_ in pairs(HealBot_BuffWatch) do
    HealBot_BuffWatch[x]=nil;
  end
  for x,_ in pairs(HealBot_BuffWatchTarget) do
    HealBot_BuffWatchTarget[x]=nil;
  end
  for x,_ in pairs(HealBot_buffbarcolr) do
    HealBot_buffbarcolr[x]=nil;
  end
  for x,_ in pairs(HealBot_buffbarcolg) do
    HealBot_buffbarcolg[x]=nil;
  end
  for x,_ in pairs(HealBot_buffbarcolb) do
    HealBot_buffbarcolb[x]=nil;
  end
  for x,_ in pairs(HealBot_BuffWatchPvP) do
    HealBot_BuffWatchPvP[x]=nil;
  end
  HealBot_Tooltip_Clear_CheckBuffs()
	
  for k=1,9 do
    if BuffDropDownClass[k] and BuffDropDownClass[k]>1 then
      id=HealBot_GetSpellId(BuffTextClass[k]);
      spell,spellrank = HealBot_GetSpellName(id);

      if spell then
        if not spells[spell] then
          spells[spell]=spell;
          table.insert(HealBot_BuffWatch,spell);
          HealBot_BuffWatchTarget[spell] = {spell = {}};
          Monitor_Buffs=true;
        end

        HealBot_BuffWatchTargetSpell=HealBot_BuffWatchTarget[spell];
		HealBot_Tooltip_CheckBuffs(spell)

        if BuffDropDownClass[k]==2 then
          HealBot_BuffWatchTargetSpell["Self"]=true;
        elseif BuffDropDownClass[k]==3 then
          HealBot_BuffWatchTargetSpell["Party"]=true;
        elseif BuffDropDownClass[k]==4 then
          HealBot_BuffWatchTargetSpell["Raid"]=true;
        elseif BuffDropDownClass[k]==5 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
        elseif BuffDropDownClass[k]==6 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
        elseif BuffDropDownClass[k]==7 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
        elseif BuffDropDownClass[k]==8 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
        elseif BuffDropDownClass[k]==9 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
        elseif BuffDropDownClass[k]==10 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
        elseif BuffDropDownClass[k]==11 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
        elseif BuffDropDownClass[k]==12 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
        elseif BuffDropDownClass[k]==13 then
		  HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
        elseif BuffDropDownClass[k]==14 then
          if HealBot_Config.EmergIncMelee[HEALBOT_DRUID]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_HUNTER]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_MAGE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_PALADIN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_PRIEST]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_ROGUE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_SHAMAN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_WARLOCK]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
          end
          if HealBot_Config.EmergIncMelee[HEALBOT_WARRIOR]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
          end
        elseif BuffDropDownClass[k]==15 then
          if HealBot_Config.EmergIncRange[HEALBOT_DRUID]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_HUNTER]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_MAGE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_PALADIN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_PRIEST]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_ROGUE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_SHAMAN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_WARLOCK]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
          end
          if HealBot_Config.EmergIncRange[HEALBOT_WARRIOR]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
          end
        elseif BuffDropDownClass[k]==16 then
          if HealBot_Config.EmergIncHealers[HEALBOT_DRUID]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_HUNTER]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_MAGE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_PALADIN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_PRIEST]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_ROGUE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_SHAMAN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_WARLOCK]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
          end
          if HealBot_Config.EmergIncHealers[HEALBOT_WARRIOR]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
          end
        elseif BuffDropDownClass[k]==17 then
          if HealBot_Config.EmergIncCustom[HEALBOT_DRUID]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_DRUID]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_HUNTER]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_HUNTER]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_MAGE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_MAGE]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_PALADIN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PALADIN]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_PRIEST]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_PRIEST]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_ROGUE]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_ROGUE]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_SHAMAN]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_SHAMAN]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_WARLOCK]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARLOCK]]=true;
          end
          if HealBot_Config.EmergIncCustom[HEALBOT_WARRIOR]==1 then
            HealBot_BuffWatchTargetSpell[HealBot_Class_En[HEALBOT_WARRIOR]]=true;
          end
		elseif BuffDropDownClass[k]==18 then
		  HealBot_BuffWatchTargetSpell["PvP"]=true
		elseif BuffDropDownClass[k]==19 then
		  HealBot_BuffWatchTargetSpell["MainTanks"]=true
		elseif BuffDropDownClass[k]==20 then
		  HealBot_BuffWatchTargetSpell["MyTargets"]=true
    end
        HealBot_buffbarcolr[spell]=buffbarcolrClass[k];
        HealBot_buffbarcolg[spell]=buffbarcolgClass[k];
        HealBot_buffbarcolb[spell]=buffbarcolbClass[k];
      end
	  HealBot_CheckBuffs=true
	end
  end
end

function HealBot_Options_RetBuffRGB(spell)
  return HealBot_buffbarcolr[spell],HealBot_buffbarcolg[spell],HealBot_buffbarcolb[spell];
end

function HealBot_Colorpick_OnClick(CDCType)
  HealBot_ColourObjWaiting=CDCType;
  HealBot_UseColourPick(HealBot_Config.CDCBarColour[CDCType].R,HealBot_Config.CDCBarColour[CDCType].G,HealBot_Config.CDCBarColour[CDCType].B, nil)
end

local R=nil
local G=nil
local B=nil
local A=nil
function HealBot_Returned_Colours(R, G, B, A)
  --R, G, B = ColorPickerFrame:GetColorRGB(); -- added by Diacono
  --A = OpacitySliderFrame:GetValue();
  if A then
  	A = ((0-A)+1);
  end
  local setskincols=true;
  if HealBot_ColourObjWaiting=="En" then
    HealBot_Config.btextenabledcolr[HealBot_Config.Current_Skin],
    HealBot_Config.btextenabledcolg[HealBot_Config.Current_Skin],
    HealBot_Config.btextenabledcolb[HealBot_Config.Current_Skin], 
    HealBot_Config.btextenabledcola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif HealBot_ColourObjWaiting=="Dis" then
    HealBot_Config.btextdisbledcolr[HealBot_Config.Current_Skin],
    HealBot_Config.btextdisbledcolg[HealBot_Config.Current_Skin],
    HealBot_Config.btextdisbledcolb[HealBot_Config.Current_Skin],
    HealBot_Config.btextdisbledcola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif HealBot_ColourObjWaiting=="Debuff" then
    HealBot_Config.btextcursecolr[HealBot_Config.Current_Skin],
    HealBot_Config.btextcursecolg[HealBot_Config.Current_Skin],
    HealBot_Config.btextcursecolb[HealBot_Config.Current_Skin],
    HealBot_Config.btextcursecola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif HealBot_ColourObjWaiting=="Back" then
    HealBot_Config.backcolr[HealBot_Config.Current_Skin],
    HealBot_Config.backcolg[HealBot_Config.Current_Skin],
    HealBot_Config.backcolb[HealBot_Config.Current_Skin],
    HealBot_Config.backcola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif HealBot_ColourObjWaiting=="Bor" then
    HealBot_Config.borcolr[HealBot_Config.Current_Skin],
    HealBot_Config.borcolg[HealBot_Config.Current_Skin],
    HealBot_Config.borcolb[HealBot_Config.Current_Skin],
    HealBot_Config.borcola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif HealBot_ColourObjWaiting=="HeadB" then
    HealBot_Config.headbarcolr[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolg[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcolb[HealBot_Config.Current_Skin],
    HealBot_Config.headbarcola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif HealBot_ColourObjWaiting=="HeadT" then
    HealBot_Config.headtxtcolr[HealBot_Config.Current_Skin],
    HealBot_Config.headtxtcolg[HealBot_Config.Current_Skin],
    HealBot_Config.headtxtcolb[HealBot_Config.Current_Skin],
    HealBot_Config.headtxtcola[HealBot_Config.Current_Skin] = R, G, B, A;
  elseif strsub(HealBot_ColourObjWaiting ,1,4)=="Buff" then
    id=tonumber(strsub(HealBot_ColourObjWaiting ,5));
    buffbarcolrClass = HealBot_Config.HealBotBuffColR
    buffbarcolgClass = HealBot_Config.HealBotBuffColG
    buffbarcolbClass = HealBot_Config.HealBotBuffColB
    buffbarcolrClass[id],
    buffbarcolgClass[id],
    buffbarcolbClass[id] = R, G, B;
    HealBot_SetBuffBarColours_Flag=true;
    setskincols=false;
  else
    HealBot_Config.CDCBarColour[HealBot_ColourObjWaiting].R,
    HealBot_Config.CDCBarColour[HealBot_ColourObjWaiting].G,
    HealBot_Config.CDCBarColour[HealBot_ColourObjWaiting].B = R, G, B;
    HealBot_SetCDCBarColours();
    setskincols=false;
  end
  if setskincols then
    HealBot_SetSkinColours_Flag=true;
  end
end


function HealBot_UseColourPick(R, G, B, A)
  local prevR, prevG, prevB, prevA = R, G, B, A;
  if ColorPickerFrame:IsVisible() then 
    ColorPickerFrame:Hide();
  elseif A then
    ColorPickerFrame.hasOpacity = true;
    ColorPickerFrame.opacity = 1-A;
    ColorPickerFrame.func = function() local r,g,b=ColorPickerFrame:GetColorRGB(); local a=OpacitySliderFrame:GetValue() HealBot_Returned_Colours(r,g,b,a); end;
    ColorPickerFrame.cancelFunc = function() HealBot_Returned_Colours(prevR, prevG, prevB, 1-prevA); end; --added by Diacono
    ColorPickerFrame:ClearAllPoints();
    ColorPickerFrame:SetPoint("TOPLEFT","HealBot_Options","TOPRIGHT",0,-152);
    OpacitySliderFrame:SetValue(1-A);
    ColorPickerFrame:SetColorRGB(R, G, B);
    ColorPickerFrame:Show();
  else
    ColorPickerFrame.hasOpacity = false;
    ColorPickerFrame.func = function() HealBot_Returned_Colours(ColorPickerFrame:GetColorRGB()); end;
    ColorPickerFrame.cancelFunc = function() HealBot_Returned_Colours(prevR, prevG, prevB); end; --added by Diacono
    ColorPickerFrame:ClearAllPoints();
    ColorPickerFrame:SetPoint("TOPLEFT","HealBot_Options","TOPRIGHT",0,-152);
    ColorPickerFrame:SetColorRGB(R, G, B);
    ColorPickerFrame:Show();
  end
  return ColorPickerFrame:GetColorRGB();
end



function HealBot_SetCDCBarColours()
  HealBot_DiseaseColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].R or 0.1,
                                             HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].G or 0.05,
                                             HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].B or 0.2,
                                             HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_MagicColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].R or 0.05,
                                           HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].G or 0.05,
                                           HealBot_Config.CDCBarColour[HEALBOT_MAGIC_en].B or 0.1,
                                           HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_PoisonColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_POISON_en].R or 0.05,
                                            HealBot_Config.CDCBarColour[HEALBOT_POISON_en].G or 0.2,
                                            HealBot_Config.CDCBarColour[HEALBOT_POISON_en].B or 0.1,
                                            HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_CurseColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].R or 0.2,
                                           HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].G or 0.05,
                                           HealBot_Config.CDCBarColour[HEALBOT_CURSE_en].B or 0.05,
                                           HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_CustomColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_CUSTOM_en].R or 0.45,
                                           HealBot_Config.CDCBarColour[HEALBOT_CUSTOM_en].G or 0,
                                           HealBot_Config.CDCBarColour[HEALBOT_CUSTOM_en].B or 0.26,
                                           HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_DebTextColorpick:SetStatusBarColor(HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].R or 0.1,
                                             HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].G or 0.05,
                                             HealBot_Config.CDCBarColour[HEALBOT_DISEASE_en].B or 0.2,
                                             HealBot_Config.Barcola[HealBot_Config.Current_Skin])
end

local bar=nil
function HealBot_SetBuffBarColours()
  buffbarcolrClass = HealBot_Config.HealBotBuffColR
  buffbarcolgClass = HealBot_Config.HealBotBuffColG
  buffbarcolbClass = HealBot_Config.HealBotBuffColB

  for k=1,9 do
    bar=getglobal("HealBot_Buff"..k.."Colour")
    if bar then
      bar:SetStatusBarColor(buffbarcolrClass[k],
                            buffbarcolgClass[k],
                            buffbarcolbClass[k],
                            HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
    end
  end
  HealBot_Set_DelayData_Buff=true;
end
--------------------------------------------------------------------------------

function HealBot_Options_NotifyChan_OnTextChanged(this)
  HealBot_Config.NotifyChan = this:GetText()
end

local spellText=nil
function HealBot_Options_Click_OnTextChanged(this)
  if HealBot_ActionBarsCombo==1 then
    combo = HealBot_Config.EnabledKeyCombo;
  else
    combo = HealBot_Config.DisabledKeyCombo;
  end
  button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
  spellText = strtrim(this:GetText())
  combo[button] = spellText
  HealBot_Options_CheckCombos_flag=true;
end

function HealBot_Options_Shift_OnTextChanged(this)
  if HealBot_ActionBarsCombo==1 then
    combo = HealBot_Config.EnabledKeyCombo;
  else
    combo = HealBot_Config.DisabledKeyCombo;
  end
  button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
  spellText = strtrim(this:GetText())
  combo["Shift"..button] = spellText
  HealBot_Options_CheckCombos_flag=true;
end

function HealBot_Options_Ctrl_OnTextChanged(this)
  if HealBot_ActionBarsCombo==1 then
    combo = HealBot_Config.EnabledKeyCombo;
  else
    combo = HealBot_Config.DisabledKeyCombo;
  end
  button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
  spellText = strtrim(this:GetText())
  combo["Ctrl"..button] = spellText
  HealBot_Options_CheckCombos_flag=true;
end

function HealBot_Options_Alt_OnTextChanged(this)
  if HealBot_ActionBarsCombo==1 then
    combo = HealBot_Config.EnabledKeyCombo;
  else
    combo = HealBot_Config.DisabledKeyCombo;
  end
  button = HealBot_Options_ComboClass_Button(HealBot_Options_ComboButtons_Button)
  spellText = strtrim(this:GetText())
  combo["Alt"..button] = spellText
  HealBot_Options_CheckCombos_flag=true;
end

function HealBot_Options_EnableTargetStatus_OnClick(this)
  HealBot_Config.UseTargetCombatStatus = this:GetChecked() or 0;
end

function HealBot_Options_EnableHealthy_OnClick(this)
  HealBot_Config.EnableHealthy = this:GetChecked() or 0;
  HealBot_Action_ResetUnitStatus();
end

function HealBot_Options_EnableSmartCast_OnClick(this)
  HealBot_Config.SmartCast = this:GetChecked() or 0;
end

function HealBot_Options_SmartCastDisspell_OnClick(this)
  HealBot_Config.SmartCastDebuff = this:GetChecked() or 0;
end

function HealBot_Options_SmartCastBuff_OnClick(this)
  HealBot_Config.SmartCastBuff = this:GetChecked() or 0;
end

function HealBot_Options_SmartCastHeal_OnClick(this)
  HealBot_Config.SmartCastHeal = this:GetChecked() or 0;
end

function HealBot_Options_SmartCastRes_OnClick(this)
  HealBot_Config.SmartCastRes = this:GetChecked() or 0;
end

local HealBot_CombosKeys_List = {"","Shift","Ctrl","Alt"}
local HB_combo_prefix=nil
local SpellTxtE=nil
local SpellTxtD=nil
local SpellTxtB=nil
local HB_button=nil
function HealBot_Options_CheckCombos()  

  id=0;
  
  for j=1,5 do
    if j==1 then HB_button="Left";
    elseif j==2 then HB_button="Right";
    elseif j==3 then HB_button="Middle";
    elseif j==4 then HB_button="Button4";
    elseif j==5 then HB_button="Button5";
    end
    
    for i=1, getn(HealBot_CombosKeys_List), 1 do
      HB_combo_prefix = HealBot_CombosKeys_List[i];
      HB_combo_prefix = HB_combo_prefix..HB_button;
      SpellTxtE = HealBot_Action_AttribSpellPattern(HB_combo_prefix)
      SpellTxtD = HealBot_Action_AttribDisSpellPattern(HB_combo_prefix)
      
      if SpellTxtE then
       if not HealBot_Spells[SpellTxtE] then
        if not HealBot_OtherSpells[SpellTxtE] then
          id = HealBot_GetSpellId(SpellTxtE);
          if id then
            HealBot_FindSpellRangeCast(id);
          end
        end
       end
      end
      if SpellTxtD then
       if not HealBot_Spells[SpellTxtD] then
        if not HealBot_OtherSpells[SpellTxtD] then
          id = HealBot_GetSpellId(SpellTxtD);
          if id then
            HealBot_FindSpellRangeCast(id);
          end
        end
       end
      end
    end
  end

  BuffTextClass = HealBot_Config.HealBotBuffText
  for k=1,9 do
    if BuffTextClass[k] then
      SpellTxtB = BuffTextClass[k]
      if not HealBot_Spells[SpellTxtB] then
        if not HealBot_OtherSpells[SpellTxtB] then
          id = HealBot_GetSpellId(SpellTxtB);
          if id then
            HealBot_FindSpellRangeCast(id);
          end
        end
      end
    end
  end    
  
  HealBot_Action_SetAllAttribs_flag=true
end

--------------------------------------------------------------------------------


local HealBot_Options_Timer1 = 2

function HealBot_Options_Set_Timers(override)
  if HealBot_Config.DisableHealBot==0 and not override then
    HealBot_Options_Timer1 = 0.8
  else
    HealBot_Options_Timer1 = 200
  end
end

local HealBot_OTimer1 = 0;
function HealBot_Options_OnUpdate(this,arg1)
  HealBot_OTimer1 = HealBot_OTimer1+arg1;
  if HealBot_OTimer1>=HealBot_Options_Timer1 and not HealBot_IsFighting then
    HealBot_OTimer1=0;
    if HealBot_Options_ResetSkins then
      HealBot_Options_ResetSkins=false;
      HealBot_Action_ResetSkin()
    elseif HealBot_SetBuffBarColours_Flag then
      HealBot_SetBuffBarColours_Flag=false;
      HealBot_SetBuffBarColours();
    elseif HealBot_SetSkinColours_Flag then
      HealBot_SetSkinColours_Flag=false;
      HealBot_SetSkinColours();
    elseif HealBot_Action_Refresh_Flag then
      HealBot_Action_Refresh_Flag=false;
      HealBot_Action_ResetUnitStatus();
    elseif HealBot_Options_CheckCombos_flag then
      HealBot_Options_CheckCombos_flag=false;
      HealBot_Options_CheckCombos();
    elseif HealBot_Set_DelayData_Em then
      HealBot_Set_DelayData_Em=false;
      HealBot_Options_EmergencyFilter_Reset()
    elseif HealBot_Set_DelayData_Debuff then
      HealBot_Set_DelayData_Debuff=false;
      HealBot_Options_Debuff_Reset()
    elseif HealBot_Set_DelayData_Buff then
      HealBot_Set_DelayData_Buff=false;
      HealBot_Options_Buff_Reset()
    elseif HealBot_CheckBuffs then
      HealBot_CheckBuffs=false;
      HealBot_CheckAllBuffs();
    elseif HealBot_CheckDebuffs then
      HealBot_CheckDebuffs=false;
      HealBot_CheckAllDebuffs();
    elseif HealBot_Action_SetAllAttribs_flag then
	  HealBot_Action_SetAllAttribs_flag=false
	  HealBot_Action_SetAllAttribs()
    end
  end
end

StaticPopupDialogs["HEALBOT_OPTIONS_SETDEFAULTS"] = {
  text = HEALBOT_OPTIONS_SETDEFAULTSMSG,
  button1 = HEALBOT_WORDS_YES,
  button2 = HEALBOT_WORDS_NO,
  OnAccept = function()
      HealBot_Options_SetDefaults();
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1
};

function HealBot_Options_Defaults_OnClick(this)
  StaticPopup_Show ("HEALBOT_OPTIONS_SETDEFAULTS");
end

function HealBot_Options_Reset_OnClick(this,mode)
  HealBot_SetResetFlag(mode)
end

function HealBot_Options_Info_OnClick(this)
  HealBot_Comms_Info()
end

function HealBot_Options_SetDefaults()
  HealBot_Options_CastNotify_OnClick(nil,0);
--  HealBot_Config = HealBot_ConfigDefaults;
  table.foreach(HealBot_ConfigDefaults, function (key,val)
    HealBot_Config[key] = val;
  end);
  HealBot_ClearAllBuffs()
  HealBot_ClearAllDebuffs()
  for x,_ in pairs(HealBot_UnitDebuff) do
    HealBot_UnitDebuff[x]=nil;
  end
  for x,_ in pairs(HealBot_UnitBuff) do
    HealBot_UnitBuff[x]=nil;
  end
  HealBot_Options_Opened=false;
--  HealBot_Options_Init()
  HealBot_RecalcSpells();
  HealBot_Action_Reset();
  ShowUIPanel(HealBot_Action)
  HealBot_Config.ActionVisible = HealBot_Action:IsVisible();
  DoInitTab1=true
  DoInitTab2=true
  DoInitTab3=true
  DoInitTab4=true
  DoInitTab5=true
  DoInitTab6=true
  DoInitTab7=true
  DoInitTab8=true
end

function HealBot_Options_OnLoad(this)
  table.insert(UISpecialFrames,this:GetName());

  -- Tabs
  PanelTemplates_SetNumTabs(this,7);
  this.selectedTab = 1; 
  PanelTemplates_UpdateTabs(this);
end

function HealBot_Options_OnShow(this)
  HealBot_Options_ShowPanel(this.selectedTab)
end

local DoInitTab1=true
local DoInitTab2=true
local DoInitTab3=true
local DoInitTab4=true
local DoInitTab5=true
local DoInitTab6=true
local DoInitTab7=true
local DoInitTab8=true

function HealBot_Options_Init(tabNo)
 if tabNo==1 then
    if DoInitTab1 then
--    HealBot_Options_DisableHealBot:SetChecked(HealBot_Config.DisableHealBot)
	  HealBot_Options_ShowMinimapButton:SetChecked(HealBot_Config.ButtonShown)
      HealBot_Options_ActionLocked:SetChecked(HealBot_Config.ActionLocked)
	  HealBot_Options_BarUpdateFreq:SetValue((HealBot_Config.BarFreq or 2)*10)
	  HealBot_Options_AutoShow:SetChecked(HealBot_Config.AutoClose)
	  HealBot_Options_PanelSounds:SetChecked(HealBot_Config.PanelSounds)
	  HealBot_Options_AggroTrack:SetChecked(HealBot_Config.ShowAggro)
	  HealBot_Options_AggroBar:SetChecked(HealBot_Config.ShowAggroBars)
	  HealBot_Options_AggroTxt:SetChecked(HealBot_Config.ShowAggroText)
	  HealBot_Options_UseFluidBars:SetChecked(HealBot_Config.UseFluidBars)
	  HealBot_Options_CastNotify_OnClick(nil,HealBot_Config.CastNotify)
	  HealBot_Options_HideOptions:SetChecked(HealBot_Config.HideOptions)
	  HealBot_Options_RightButtonOptions:SetChecked(HealBot_Config.RightButtonOptions)
	  HealBot_Options_NotifyChan:SetText(HealBot_Config.NotifyChan)
	  HealBot_Options_CastNotifyResOnly:SetChecked(HealBot_Config.CastNotifyResOnly)
      HealBot_Options_PartyFrames:SetChecked(HealBot_Config.HidePartyFrames)
      HealBot_Options_PlayerTargetFrames:SetChecked(HealBot_Config.HidePlayerTarget)
	  HealBot_Options_ActionAnchor_Refresh()
      DoInitTab1=nil
	end
	CPUProfiler=GetCVar("scriptProfile")
	HealBot_Options_CPUProfiler:SetChecked(CPUProfiler)
 elseif tabNo==2 and DoInitTab2 then
    HealBot_Options_ProtectPvP:SetChecked(HealBot_Config.ProtectPvP)
--	HealBot_Options_EnableSmartCast:SetChecked(HealBot_Config.SmartCast)
    HealBot_Options_SmartCastDisspell:SetChecked(HealBot_Config.SmartCastDebuff)
    HealBot_Options_SmartCastBuff:SetChecked(HealBot_Config.SmartCastBuff)
    HealBot_Options_SmartCastHeal:SetChecked(HealBot_Config.SmartCastHeal)
    HealBot_Options_SmartCastRes:SetChecked(HealBot_Config.SmartCastRes)
	HealBot_Options_EnableHealthy:SetChecked(HealBot_Config.EnableHealthy)
	HealBot_Options_ActionBarsCombo_Refresh()
	HealBot_ComboButtons_Button_OnClick(nil,HealBot_Options_ComboButtons_Button)
	HealBot_Options_EnableTargetStatus:SetChecked(HealBot_Config.UseTargetCombatStatus)
    DoInitTab2=nil
 elseif tabNo==3 and DoInitTab3 then
    HealBot_Options_SelfHeals:SetChecked(HealBot_Config.SelfHeals)
	HealBot_Options_PetHeals:SetChecked(HealBot_Config.PetHeals)
    HealBot_Options_GroupHeals:SetChecked(HealBot_Config.GroupHeals)
    HealBot_Options_TankHeals:SetChecked(HealBot_Config.TankHeals)
    HealBot_Options_SelfPet:SetChecked(HealBot_Config.SelfPet)
    HealBot_Options_EmergencyHeals:SetChecked(HealBot_Config.EmergencyHeals)
	HealBot_Options_TargetBar:SetChecked(HealBot_Config.TargetHeals)
	HealBot_Options_TargetIncSelf:SetChecked(HealBot_Config.TargetIncSelf)
	HealBot_Options_TargetIncGroup:SetChecked(HealBot_Config.TargetIncGroup)
	HealBot_Options_TargetIncRaid:SetChecked(HealBot_Config.TargetIncRaid)
	HealBot_Options_TargetIncPet:SetChecked(HealBot_Config.TargetIncPet)
	HealBot_Options_AlertLevel:SetValue(HealBot_Config.AlertLevel)
	HealBot_Options_RangeCheckFreq:SetValue((HealBot_Config.RangeCheckFreq or 0.2)*10)
    HealBot_Options_EmergencyFilter_Refresh()
    HealBot_Options_EmergencyFClass_Refresh()
    HealBot_Options_EFClass_Reset()
	HealBot_Options_ExtraSort_Refresh()
	HealBot_Options_SetEFGroups()
    DoInitTab3=nil
 elseif tabNo==4 and DoInitTab4 then
    HealBot_Options_SoundDebuffWarning:SetChecked(HealBot_Config.SoundDebuffWarning)
--	HealBot_Options_MonitorDebuffs:SetChecked(HealBot_Config.DebuffWatch)
    HealBot_Options_IgnoreDebuffsClass:SetChecked(HealBot_Config.IgnoreClassDebuffs)
    HealBot_Options_IgnoreDebuffsNoHarm:SetChecked(HealBot_Config.IgnoreNonHarmfulDebuffs)
    HealBot_Options_IgnoreDebuffsDuration:SetChecked(HealBot_Config.IgnoreFastDurDebuffs)
    HealBot_Options_IgnoreDebuffsMovement:SetChecked(HealBot_Config.IgnoreMovementDebuffs)
	HealBot_WarningSound_OnClick(nil,HealBot_Config.SoundDebuffPlay)
	HealBot_Options_MonitorDebuffsInCombat:SetChecked(HealBot_Config.DebuffWatchInCombat)
    HealBot_Options_CDCGroups1_Refresh()
    HealBot_Options_CDCGroups2_Refresh()
    HealBot_Options_CDCGroups3_Refresh()
	HealBot_Options_ShowDebuffWarning:SetChecked(HealBot_Config.ShowDebuffWarning)
	HealBot_SetCDCBarColours()
    HealBot_Options_CDCTxt1_Refresh()
    HealBot_Options_CDCTxt2_Refresh()
    HealBot_Options_CDCTxt3_Refresh()
    DoInitTab4=nil
 elseif tabNo==5 and DoInitTab5 then
    HealBot_Options_NewSkinb:Disable()
	HealBot_Options_Skins_Refresh()
	HealBot_Options_SetSkins()
    DoInitTab5=nil
 elseif tabNo==6 and DoInitTab6 then
    HealBot_Options_BarButtonShowHoT:SetChecked(HealBot_Config.ShowHoTicons)
	HealBot_Options_ShowTooltip:SetChecked(HealBot_Config.ShowTooltip)
	HealBot_Options_ShowTooltipUpdate:SetChecked(HealBot_Config.TooltipUpdate)
    HealBot_Options_ShowClassOnBar:SetChecked(HealBot_Config.ShowClassOnBar)
    HealBot_Options_ShowHealthOnBar:SetChecked(HealBot_Config.ShowHealthOnBar)
    HealBot_BarHealthIncHeal:SetChecked(HealBot_Config.BarHealthIncHeals)
    HealBot_Options_ShowTooltipTarget:SetChecked(HealBot_Config.Tooltip_ShowTarget)
    HealBot_Options_ShowTooltipMyBuffs:SetChecked(HealBot_Config.Tooltip_ShowMyBuffs)
    HealBot_Options_ShowTooltipSpellDetail:SetChecked(HealBot_Config.Tooltip_ShowSpellDetail)
    HealBot_Options_ShowTooltipInstant:SetChecked(HealBot_Config.Tooltip_Recommend)
	HealBot_Options_ShowTooltipPreDefined:SetChecked(HealBot_Config.Tooltip_PreDefined)
    HealBot_Options_ShowClassOnBarWithName:SetChecked(HealBot_Config.ShowClassOnBarWithName)
    HealBot_Options_BarInClassColour:SetChecked(HealBot_Config.SetBarClassColour)
    HealBot_Options_BarTextInClassColour:SetChecked(HealBot_Config.SetClassColourText)
    HealBot_BarHealthType_OnClick(nil,HealBot_Config.BarHealthType)
    HealBot_HoTonBar_OnClick(nil,HealBot_Config.HoTonBar)
    HealBot_HoTposBar_OnClick(nil,HealBot_Config.HoTposBar)
	HealBot_Options_TooltipPos_Refresh()
	HealBot_Options_TTAlpha:SetValue(HealBot_Config.ttalpha)
    DoInitTab6=nil
 elseif tabNo==7 and DoInitTab7 then
--    HealBot_Options_MonitorBuffs:SetChecked(HealBot_Config.BuffWatch)
    HealBot_Options_MonitorBuffsInCombat:SetChecked(HealBot_Config.BuffWatchInCombat)
    HealBot_Options_BuffGroups1_Refresh()
    HealBot_Options_BuffGroups2_Refresh()
    HealBot_Options_BuffGroups3_Refresh()
    HealBot_Options_BuffGroups4_Refresh()
    HealBot_Options_BuffGroups5_Refresh()
    HealBot_Options_BuffGroups6_Refresh()
    HealBot_Options_BuffGroups7_Refresh()
    HealBot_Options_BuffGroups8_Refresh()
    HealBot_Options_BuffGroups9_Refresh()
    HealBot_Options_BuffTxt1_Refresh()
    HealBot_Options_BuffTxt2_Refresh()
    HealBot_Options_BuffTxt3_Refresh()
    HealBot_Options_BuffTxt4_Refresh()
    HealBot_Options_BuffTxt5_Refresh()
    HealBot_Options_BuffTxt6_Refresh()
    HealBot_Options_BuffTxt7_Refresh()
    HealBot_Options_BuffTxt8_Refresh()
	HealBot_Options_BuffTxt9_Refresh()
    DoInitTab7=nil
 elseif tabNo==8 and DoInitTab8 then
    HealBot_Options_DisableHealBot:SetChecked(HealBot_Config.DisableHealBot)
	HealBot_Options_EnableSmartCast:SetChecked(HealBot_Config.SmartCast)
    HealBot_Options_MonitorDebuffs:SetChecked(HealBot_Config.DebuffWatch)
    HealBot_Options_MonitorBuffs:SetChecked(HealBot_Config.BuffWatch)
    DoInitTab8=nil
 end
 if not HealBot_Options_Opened then
   HealBot_Skins = HealBot_Config.Skins
   HealBot_SetBuffBarColours_Flag=true
   HealBot_Options_Opened=true
   if HealBot_Config.SoundDebuffWarning>0 then
    HealBot_WarningSound1:Enable();
    HealBot_WarningSound2:Enable();
    HealBot_WarningSound3:Enable();
   else
    HealBot_WarningSound1:Disable();
    HealBot_WarningSound2:Disable();
    HealBot_WarningSound3:Disable();
   end
   if HealBot_Config.ShowHealthOnBar>0 then
    HealBot_BarHealthType1:Enable();
    HealBot_BarHealthType2:Enable();
   else
    HealBot_BarHealthType1:Disable();
    HealBot_BarHealthType2:Disable();
   end
 end
end

function HealBot_Options_SetEFGroups()
  for id=1,8 do
    if HealBot_Config.ExtraIncGroup[id] then 
      getglobal("HealBot_Options_EFGroup"..id):SetChecked(1)
    else
      getglobal("HealBot_Options_EFGroup"..id):SetChecked(nil)
    end
  end
end

function HealBot_Options_SetSkins()
  if not HealBot_Config.bareora[HealBot_Config.Current_Skin] then HealBot_Config.bareora[HealBot_Config.Current_Skin]=0.2 end
  HealBot_Options_BarAlpha:SetValue(HealBot_Config.Barcola[HealBot_Config.Current_Skin]);
  HealBot_Options_BarAlphaInHeal:SetValue(HealBot_Config.BarcolaInHeal[HealBot_Config.Current_Skin]);
  HealBot_Options_BarTextureS:SetValue(HealBot_Config.btexture[HealBot_Config.Current_Skin])
  HealBot_Options_BarHeightS:SetValue(HealBot_Config.bheight[HealBot_Config.Current_Skin])
  HealBot_Options_BarWidthS:SetValue(HealBot_Config.bwidth[HealBot_Config.Current_Skin])
  HealBot_Options_BarNumColsS:SetValue(HealBot_Config.numcols[HealBot_Config.Current_Skin])
  HealBot_Options_BarBRSpaceS:SetValue(HealBot_Config.brspace[HealBot_Config.Current_Skin])
  HealBot_Options_BarBCSpaceS:SetValue(HealBot_Config.bcspace[HealBot_Config.Current_Skin])
  HealBot_Options_FontHeight:SetValue(HealBot_Config.btextheight[HealBot_Config.Current_Skin])
  HealBot_Options_BarAlphaDis:SetValue(HealBot_Config.bardisa[HealBot_Config.Current_Skin])
  HealBot_Options_BarAlphaEor:SetValue(HealBot_Config.bareora[HealBot_Config.Current_Skin])
  HealBot_Options_Bar2Size:SetValue(HealBot_Config.bar2size[HealBot_Config.Current_Skin])
  HealBot_Options_HeadTextureS:SetValue(HealBot_Config.headtexture[HealBot_Config.Current_Skin])
  HealBot_Options_HeadWidthS:SetValue(HealBot_Config.headwidth[HealBot_Config.Current_Skin])
  HealBot_Options_ShowHeaders:SetChecked(HealBot_Config.ShowHeader[HealBot_Config.Current_Skin])
  HealBot_SetSkinColours_Flag=true;
  if HealBot_Config.Current_Skin==HEALBOT_SKINS_STD then
    HealBot_Options_DeleteSkin:Disable();
  else
    HealBot_Options_DeleteSkin:Enable();
  end
  if HealBot_Config.bar2size[HealBot_Config.Current_Skin]==0 then
    HealBot_UnRegister_Mana()
  else
    HealBot_Register_Mana()
  end
end

HealBot_Options_CurrentPanel = 0;

function HealBot_Options_ShowPanel(id)
  if HealBot_Options_CurrentPanel>0 then
    getglobal("HealBot_Options_Panel"..HealBot_Options_CurrentPanel):Hide();
  end
  HealBot_Options_CurrentPanel = id;
  if HealBot_Options_CurrentPanel>0 then
    getglobal("HealBot_Options_Panel"..HealBot_Options_CurrentPanel):Show();
	HealBot_Options_Init(HealBot_Options_CurrentPanel)
  end
end

function HealBot_Options_OnMouseDown(this)
      HealBot_StartMoving(this);
end

function HealBot_Options_OnMouseUp(this)
    HealBot_StopMoving(this);
end

function HealBot_Options_OnDragStart(this)
  HealBot_StartMoving(this);
end

function HealBot_Options_OnDragStop(this)
  HealBot_StopMoving(this);
end

function HealBot_Options_DisablePlayerFrame()
  PlayerFrame:UnregisterAllEvents()
  PlayerFrameHealthBar:UnregisterAllEvents()
  PlayerFrameManaBar:UnregisterAllEvents()
  PlayerFrame:Hide()
end

function HealBot_Options_EnablePlayerFrame()
  PlayerFrame:RegisterAllEvents()
  PlayerFrameHealthBar:RegisterAllEvents()
  PlayerFrameManaBar:RegisterAllEvents()
  PlayerFrame:Show();
end

function HealBot_Options_DisablePetFrame()
  PetFrame:UnregisterAllEvents()
  PetFrame:Hide()
end

function HealBot_Options_EnablePetFrame()
  PetFrame:RegisterAllEvents()
  PetFrame:Show();
end

local f=nil
function HealBot_Options_DisablePartyFrame()
  HIDE_PARTY_INTERFACE = "1"
    hooksecurefunc("ShowPartyFrame", function()
      if (not InCombatLockdown()) then
          for i = 1,4 do
            getglobal("PartyMemberFrame"..i):Hide()
          end
      end
    end)
  for num = 1, 4 do
    f = getglobal("PartyMemberFrame"..num)
    f:Hide()
    f:UnregisterAllEvents()
    getglobal("PartyMemberFrame"..num.."HealthBar"):UnregisterAllEvents()
    getglobal("PartyMemberFrame"..num.."ManaBar"):UnregisterAllEvents()
  end
end

function HealBot_Options_EnablePartyFrame()
  HIDE_PARTY_INTERFACE = "0"
    hooksecurefunc("ShowPartyFrame", function()
      if (not InCombatLockdown()) then
          for i = 1,4 do
            getglobal("PartyMemberFrame"..i):Show()
          end
      end
    end)
  for num = 1, 4 do
    f = getglobal("PartyMemberFrame"..num)
    if GetPartyMember(num) then
      f:Show()
    end
    f:RegisterAllEvents()
    getglobal("PartyMemberFrame"..num.."HealthBar"):RegisterAllEvents()
    getglobal("PartyMemberFrame"..num.."ManaBar"):RegisterAllEvents()
  end
end

function HealBot_Options_DisableTargetFrame()
		TargetFrame:UnregisterAllEvents()
		TargetFrameHealthBar:UnregisterAllEvents()
		TargetFrameManaBar:UnregisterAllEvents()
		TargetFrame:Hide()
		TargetofTargetFrame:UnregisterAllEvents()
		TargetofTargetFrame:Hide()
end

function HealBot_Options_EnableTargetFrame()
		TargetFrame:RegisterAllEvents()
		TargetFrameHealthBar:RegisterAllEvents()
		TargetFrameManaBar:RegisterAllEvents()
		TargetofTargetFrame:RegisterAllEvents()
end
