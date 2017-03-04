
-- Chinese sim by CWDG 月色狼影
-- CWDG site: http://Cwowaddon.com
-------------
-- CHINESE --
-------------

if (GetLocale() == "zhCN") then

-------------------
-- Compatibility --
-------------------

HEALBOT_DRUID   = "德鲁伊";
HEALBOT_HUNTER  = "猎人";
HEALBOT_MAGE    = "法师";
HEALBOT_PALADIN = "圣骑士";
HEALBOT_PRIEST  = "牧师";
HEALBOT_ROGUE   = "潜行者";
HEALBOT_SHAMAN  = "萨满祭司";
HEALBOT_WARLOCK = "术士";
HEALBOT_WARRIOR = "战士";

HEALBOT_HEAVY_NETHERWEAVE_BANDAGE = "厚灵纹布绷带";
HEALBOT_HEAVY_RUNECLOTH_BANDAGE = "厚符文布绷带";
HEALBOT_MAJOR_HEALING_POTION    = "特效治疗药水";
HEALBOT_PURIFICATION_POTION     = "净化药水";
HEALBOT_ANTI_VENOM              = "抗毒药剂";
HEALBOT_POWERFUL_ANTI_VENOM     = "强效抗毒药剂";
HEALBOT_ELIXIR_OF_POISON_RES    = "抗毒药剂";
HEALBOT_STONEFORM = GetSpellInfo(20594);

--spell heal
HEALBOT_FLASH_HEAL          = "快速治疗";
HEALBOT_FLASH_OF_LIGHT      = "圣光闪现";
HEALBOT_GREATER_HEAL        = "强效治疗术";
HEALBOT_BINDING_HEAL        = "联结治疗"--TBC spell
HEALBOT_PRAYER_OF_MENDING   = "愈合祷言";
HEALBOT_HEALING_TOUCH       = "治疗之触";
HEALBOT_HEAL                = "治疗术";
HEALBOT_HEALING_WAVE        = "治疗波";
HEALBOT_HOLY_LIGHT          = "圣光术";
HEALBOT_LESSER_HEAL         = "次级治疗术";
HEALBOT_LESSER_HEALING_WAVE = "次级治疗波";
HEALBOT_POWER_WORD_SHIELD   = "真言术：盾";
HEALBOT_REGROWTH            = "愈合";
HEALBOT_RENEW               = "恢复";
HEALBOT_REJUVENATION        = "回春术";
HEALBOT_LIFEBLOOM           = "生命绽放";--tbc spell
HEALBOT_PRAYER_OF_HEALING   = "治疗祷言";
HEALBOT_CHAIN_HEAL          = "治疗链";

HEALBOT_POWER_WORD_FORTITUDE  = "真言术：韧";
HEALBOT_PRAYER_OF_FORTITUDE   = "坚韧祷言";
HEALBOT_DIVINE_SPIRIT         = "神圣之灵";
HEALBOT_PRAYER_OF_SPIRIT        = "精神祷言";
HEALBOT_SHADOW_PROTECTION       = "防护暗影";
HEALBOT_PRAYER_OF_SHADOW_PROTECTION = "暗影防护祷言";
HEALBOT_INNER_FIRE            = "心灵之火";
HEALBOT_INNER_FOCUS           = "心灵专注";
HEALBOT_FEAR_WARD           = "防护恐惧结界";
HEALBOT_TOUCH_OF_WEAKNESS     = "虚弱之触";
HEALBOT_ARCANE_INTELLECT      = "奥术智慧";
HEALBOT_ARCANE_BRILLIANCE     = "奥术光辉";
HEALBOT_FROST_ARMOR           = "霜甲术";
HEALBOT_ICE_ARMOR             = "冰甲术";
HEALBOT_MAGE_ARMOR            = "法师护甲";--check
HEALBOT_MOLTEN_ARMOR          = "熔岩护甲";--tbc
HEALBOT_DEMON_ARMOR           = "魔甲术";
HEALBOT_DEMON_SKIN            = "恶魔皮肤";
HEALBOT_FEL_ARMOR             = "邪甲术";--tbc spell
HEALBOT_DAMPEN_MAGIC          = "魔法抑制";
HEALBOT_AMPLIFY_MAGIC         = "魔法增效";
HEALBOT_SHADOW_GUARD          = "暗影戒卫";
HEALBOT_DETECT_INV            = "侦测隐形";

--SM spell
HEALBOT_LIGHTNING_SHIELD      = "闪电之盾";
HEALBOT_ROCKBITER_WEAPON      = "石化武器";
HEALBOT_FLAMETONGUE_WEAPON    = "火舌武器";
HEALBOT_FROSTBRAND_WEAPON     = "冰封武器";
HEALBOT_EARTH_SHIELD          = "大地之盾";--tbc spell
HEALBOT_WATER_SHIELD          = "水之护盾";
HEALBOT_WIND_FURY             = "风怒武器";--Wind Fury

--dru spell
HEALBOT_MARK_OF_THE_WILD      = "野性印记";
HEALBOT_GIFT_OF_THE_WILD        = "野性赐福";
HEALBOT_THORNS                = "荆棘术";
HEALBOT_OMEN_OF_CLARITY       = "清晰预兆";

--pra spell
HEALBOT_BLESSING_OF_MIGHT       = "力量祝福";
HEALBOT_BLESSING_OF_WISDOM      = "智慧祝福";
HEALBOT_BLESSING_OF_SALVATION   = "拯救祝福";
HEALBOT_BLESSING_OF_SANCTUARY   = "庇护祝福";
HEALBOT_BLESSING_OF_LIGHT       = "光明祝福";
HEALBOT_BLESSING_OF_PROTECTION  = "保护祝福";
HEALBOT_BLESSING_OF_FREEDOM     = "自由祝福";
HEALBOT_BLESSING_OF_SACRIFICE   = "牺牲祝福";
HEALBOT_BLESSING_OF_KINGS       = "王者祝福";
HEALBOT_GREATER_BLESSING_OF_MIGHT     = "强效力量祝福";
HEALBOT_GREATER_BLESSING_OF_WISDOM    = "强效智慧祝福";
HEALBOT_GREATER_BLESSING_OF_KINGS     = "强效王者祝福";
HEALBOT_GREATER_BLESSING_OF_LIGHT     = "强效光明祝福";
HEALBOT_GREATER_BLESSING_OF_SALVATION = "强效拯救祝福";
HEALBOT_GREATER_BLESSING_OF_SANCTUARY = "强效庇护祝福";
HEALBOT_RIGHTEOUS_FURY          = "正义之怒"
HEALBOT_DEVOTION_AURA           = "虔诚光环"
HEALBOT_RETRIBUTION_AURA        = "十字军打击"
HEALBOT_CONCENTRATION_AURA      = "专注光环"
HEALBOT_SHR_AURA                = "暗影抗性光环"
HEALBOT_FRR_AURA                = "冰霜抗性光环"
HEALBOT_FIR_AURA                = "火焰抗性光环"
HEALBOT_CRUSADER_AURA           = "十字军光环"
HEALBOT_SANCTITY_AURA           = "圣洁光环"

HEALBOT_INTERVENE = GetSpellInfo(3411);

HEALBOT_A_MONKEY            = "灵猴守护"
HEALBOT_A_HAWK              = "雄鹰守护"
HEALBOT_A_CHEETAH           = "猎豹守护"
HEALBOT_A_BEAST             = "野兽守护"
HEALBOT_A_PACK              = "群豹守护"
HEALBOT_A_WILD              = "野性守护"
HEALBOT_A_VIPER             = "蝰蛇守护"
HEALBOT_MENDPET             = "治疗宠物"

HEALBOT_UNENDING_BREATH     = "魔息术"
HEALBOT_HEALTH_FUNNEL       = "生命通道"
-- four resurrections
HEALBOT_RESURRECTION       = "复活术";
HEALBOT_REDEMPTION         = "救赎";
HEALBOT_REBIRTH            = "复生";
HEALBOT_ANCESTRALSPIRIT    = "先祖之魂";

--debuff and remove spell
HEALBOT_PURIFY             = "纯净术";
HEALBOT_CLEANSE            = "清洁术";
HEALBOT_CURE_POISON        = "消毒术";
HEALBOT_REMOVE_CURSE       = "解除诅咒";
HEALBOT_ABOLISH_POISON     = "驱毒术";
HEALBOT_CURE_DISEASE       = "祛病术";
HEALBOT_ABOLISH_DISEASE    = "驱除疾病";
HEALBOT_DISPEL_MAGIC       = "驱散魔法";
HEALBOT_REMOVE_LESSER_CURSE = "解除次级诅咒";
HEALBOT_DISEASE            = "疾病";
HEALBOT_MAGIC              = "魔法";
HEALBOT_CURSE              = "诅咒";
HEALBOT_POISON             = "中毒";

HEALBOT_DEBUFF_ANCIENT_HYSTERIA = "上古狂乱";
HEALBOT_DEBUFF_IGNITE_MANA      = "点燃法力";
HEALBOT_DEBUFF_TAINTED_MIND     = "污浊之魂";
HEALBOT_DEBUFF_VIPER_STING      = "蝰蛇钉刺";
HEALBOT_DEBUFF_SILENCE          = "沉默";
HEALBOT_DEBUFF_MAGMA_SHACKLES   = "熔岩镣铐";
HEALBOT_DEBUFF_FROSTBOLT        = "冰霜箭";
HEALBOT_DEBUFF_PSYCHIC_HORROR   = "心灵恐惧";--tbc Psychic Horror
HEALBOT_DEBUFF_HUNTERS_MARK     = "猎人印记";
HEALBOT_DEBUFF_SLOW             = "减速术";
HEALBOT_DEBUFF_ARCANE_BLAST     = "奥术冲击";
HEALBOT_DEBUFF_IMPOTENCE        = "无力诅咒";--tbc spell
HEALBOT_DEBUFF_DECAYED_STR      = "力量衰减";
HEALBOT_DEBUFF_DECAYED_INT      = "智力衰减";--tbc Decayed Intellect
HEALBOT_DEBUFF_CRIPPLE          = "残废术";
HEALBOT_DEBUFF_CHILLED          = "冰冻";
HEALBOT_DEBUFF_CONEOFCOLD       = "冰锥术";
HEALBOT_DEBUFF_CONCUSSIVESHOT   = "震荡射击";
HEALBOT_DEBUFF_THUNDERCLAP      = "雷霆一击";
HEALBOT_DEBUFF_HOWLINGSCREECH   = "尖啸";--tbc
HEALBOT_DEBUFF_DAZED            = "眩晕";
HEALBOT_DEBUFF_FALTER           = "定身";--tbc
HEALBOT_DEBUFF_UNSTABLE_AFFL    = "痛苦无常";--tbc
HEALBOT_DEBUFF_DREAMLESS_SLEEP  = "无梦睡眠";
HEALBOT_DEBUFF_GREATER_DREAMLESS = "强效昏睡";
HEALBOT_DEBUFF_MAJOR_DREAMLESS  = "特效无梦睡眠";--tbc
HEALBOT_DEBUFF_FROST_SHOCK      = "冰霜震击"

HEALBOT_RANK_1              = "(等级 1)";
HEALBOT_RANK_2              = "(等级 2)";
HEALBOT_RANK_3              = "(等级 3)";
HEALBOT_RANK_4              = "(等级 4)";
HEALBOT_RANK_5              = "(等级 5)";
HEALBOT_RANK_6              = "(等级 6)";
HEALBOT_RANK_7              = "(等级 7)";
HEALBOT_RANK_8              = "(等级 8)";
HEALBOT_RANK_9              = "(等级 9)";
HEALBOT_RANK_10             = "(等级 10)";
HEALBOT_RANK_11             = "(等级 11)";
HEALBOT_RANK_12             = "(等级 12)";
HEALBOT_RANK_13             = "(等级 13)";

HB_SPELL_PATTERN_LESSER_HEAL         = "治疗目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_HEAL                = "治疗目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_GREATER_HEAL        = "施法缓慢的法术，可以为单一目标治疗(%d+)到(%d+)点伤害";
HB_SPELL_PATTERN_FLASH_HEAL          = "治疗友方目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_RENEW               = "治疗目标，在(%d+)秒内恢复总计(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_RENEW1              = "治疗目标，在(%d+)秒内恢复总计(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_RENEW2              = "Not needed for en";
HB_SPELL_PATTERN_RENEW3              = "Not needed for en";
HB_SPELL_PATTERN_SHIELD              = "可吸收(%d+)点伤害，持续(%d+)秒。";
HB_SPELL_PATTERN_HEALING_TOUCH       = "治疗友方目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_REGROWTH            = "治疗友方目标，恢复(%d+)到(%d+)点生命值，并在(%d+)秒内恢复额外的(%d+)点生命值";
HB_SPELL_PATTERN_REGROWTH1           = "Heals a friendly target for (%d+) to (%d+) and another (%d+) to (%d+) over (%d+) sec";
HB_SPELL_PATTERN_HOLY_LIGHT          = "治疗友方目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_FLASH_OF_LIGHT      = "治疗友方目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_HEALING_WAVE        = "治疗友方目标，恢复(%d+)到(%d+)点生命值";--check
HB_SPELL_PATTERN_LESSER_HEALING_WAVE = "治疗友方目标，恢复(%d+)到(%d+)点生命值";
HB_SPELL_PATTERN_REJUVENATION        = "治疗目标，在(%d+)秒内恢复总计(%d+)点生命值";
HB_SPELL_PATTERN_REJUVENATION1       = "Heals the target for (%d+) to (%d+) over (%d+) sec";
HB_SPELL_PATTERN_REJUVENATION2       = "Not needed for en";
HB_SPELL_PATTERN_MEND_PET            = "集中注意力为宠物治疗，在(%d+)秒内为其恢复(%d+)点生命值";

HB_TOOLTIP_MANA                    = "^(%d+)法力值$";
HB_TOOLTIP_RANGE                   = "(%d+)码距离";
HB_TOOLTIP_INSTANT_CAST            = "瞬发法术";
HB_TOOLTIP_CAST_TIME               = "(%d+.?%d*)秒施法时间";
HB_TOOLTIP_CHANNELED               = "需引导";
HB_HASLEFTRAID                     = "^([^%s]+)离开了团队。";
HB_HASLEFTPARTY                    = "^([^%s]+)离开了队伍。";
HB_YOULEAVETHEGROUP                = "你离开了队伍。"
HB_YOULEAVETHERAID                 = "你已经离开了这个团队。"
HB_YOUJOINTHERAID                  = "你加入了一个团队。"
HB_YOUJOINTHEGROUP                 = "你加入了队伍。"

-----------------
-- Translation --
-----------------

HEALBOT_ADDON = "HealBot " .. HEALBOT_VERSION;
HEALBOT_LOADED = " 已加载。欢迎访问CWDG网站http://cwowaddon.com，了解最新插件资讯。";

HEALBOT_CASTINGSPELLONYOU  = "正在对你施放%s ...";
HEALBOT_CASTINGSPELLONUNIT = "对 >%2$s< 施放 [%1$s]";

HEALBOT_ACTION_OPTIONS    = "设置";

HEALBOT_OPTIONS_TITLE         = HEALBOT_ADDON;
HEALBOT_OPTIONS_DEFAULTS      = "预设";
HEALBOT_OPTIONS_CLOSE         = "关闭";
HEALBOT_OPTIONS_HARDRESET     = "重载界面"
HEALBOT_OPTIONS_SOFTRESET     = "重载HealBot"
HEALBOT_OPTIONS_INFO          = "信息"
HEALBOT_OPTIONS_TAB_GENERAL   = "综合";
HEALBOT_OPTIONS_TAB_SPELLS    = "法术";
HEALBOT_OPTIONS_TAB_HEALING   = "治疗";
HEALBOT_OPTIONS_TAB_CDC       = "Debuff";--curse
HEALBOT_OPTIONS_TAB_SKIN      = "样式";
HEALBOT_OPTIONS_TAB_TIPS      = "提示";
HEALBOT_OPTIONS_TAB_BUFFS     = "Buff"

HEALBOT_OPTIONS_PANEL_TEXT    = "治疗面板设置"
HEALBOT_OPTIONS_BARALPHA      = "样式条透明度";
HEALBOT_OPTIONS_BARALPHAINHEAL= "进入治疗状态时透明度";
HEALBOT_OPTIONS_BARALPHAEOR   = "超出范围透明度";
HEALBOT_OPTIONS_ACTIONLOCKED  = "锁定";
HEALBOT_OPTIONS_AUTOSHOW      = "关闭自动显示";
HEALBOT_OPTIONS_PANELSOUNDS   = "使用声音提示";
HEALBOT_OPTIONS_HIDEOPTIONS   = "隐藏设置按钮";
HEALBOT_OPTIONS_PROTECTPVP    = "防止意外进入PVP状态";
HEALBOT_OPTIONS_HEAL_CHATOPT  = "聊天设置";

HEALBOT_OPTIONS_SKINTEXT      = "样式"
HEALBOT_SKINS_STD             = "标准"
HEALBOT_OPTIONS_SKINTEXTURE   = "材质"
HEALBOT_OPTIONS_SKINHEIGHT    = "高度"
HEALBOT_OPTIONS_SKINWIDTH     = "宽度"
HEALBOT_OPTIONS_SKINNUMCOLS   = "分栏数目"
HEALBOT_OPTIONS_SKINNUMHCOLS  = "编号显示标题头"
HEALBOT_OPTIONS_SKINBRSPACE   = "横向"
HEALBOT_OPTIONS_SKINBCSPACE   = "纵向"
HEALBOT_OPTIONS_EXTRASORT     = "排列方式"
HEALBOT_SORTBY_NAME           = "名称"
HEALBOT_SORTBY_CLASS          = "职业"
HEALBOT_SORTBY_GROUP          = "队伍"
HEALBOT_SORTBY_MAXHEALTH      = "最大治疗"
HEALBOT_OPTIONS_DELSKIN       = "删除"
HEALBOT_OPTIONS_NEWSKINTEXT   = "新皮肤"
HEALBOT_OPTIONS_SAVESKIN      = "保存"
HEALBOT_OPTIONS_SKINBARS      = "样式条设置"
HEALBOT_OPTIONS_SKINPANEL     = "面板风格"
HEALBOT_SKIN_ENTEXT           = "启用"
HEALBOT_SKIN_DISTEXT          = "禁用"
HEALBOT_SKIN_DEBTEXT          = "Debuff"
HEALBOT_SKIN_BACKTEXT         = "背景颜色"
HEALBOT_SKIN_BORDERTEXT       = "边框颜色"
HEALBOT_OPTIONS_SKINFHEIGHT   = "字体尺寸"
HEALBOT_OPTIONS_BARALPHADIS   = "禁用透明度"
HEALBOT_OPTIONS_SHOWHEADERS   = "显示标题头"

HEALBOT_OPTIONS_ITEMS  = "物品";
HEALBOT_OPTIONS_SPELLS = "法术";

HEALBOT_OPTIONS_COMBOCLASS    = "组合键设置";
HEALBOT_OPTIONS_CLICK         = "点击";
HEALBOT_OPTIONS_SHIFT         = "Shift";
HEALBOT_OPTIONS_CTRL          = "Ctrl";
HEALBOT_OPTIONS_ENABLEHEALTHY = "总是使用已启用的设置";

HEALBOT_OPTIONS_CASTNOTIFY1   = "无信息";
HEALBOT_OPTIONS_CASTNOTIFY2   = "通知自己";
HEALBOT_OPTIONS_CASTNOTIFY3   = "通知目标";
HEALBOT_OPTIONS_CASTNOTIFY4   = "通知队伍";
HEALBOT_OPTIONS_CASTNOTIFY5   = "通知团队";
HEALBOT_OPTIONS_CASTNOTIFY6   = "通知频道";
HEALBOT_OPTIONS_CASTNOTIFYRESONLY = "只在复活目标发出信息";
HEALBOT_OPTIONS_TARGETWHISPER = "治疗时密语目标";

HEALBOT_OPTIONS_CDCBARS       = "Debuff颜色设置";
HEALBOT_OPTIONS_CDCCLASS      = "监视职业";
HEALBOT_OPTIONS_CDCWARNINGS   = "Debuff警报";
HEALBOT_OPTIONS_SHOWDEBUFFWARNING = "有debuff时显示警告";
HEALBOT_OPTIONS_SOUNDDEBUFFWARNING = "有debuff时声音提示";
HEALBOT_OPTIONS_SOUND1        = "声音 1"
HEALBOT_OPTIONS_SOUND2        = "声音 2"
HEALBOT_OPTIONS_SOUND3        = "声音 3"

HEALBOT_OPTIONS_HEAL_BUTTONS  = "治疗按钮:";
HEALBOT_OPTIONS_SELFHEALS     = "自我"
HEALBOT_OPTIONS_PETHEALS      = "宠物"
HEALBOT_OPTIONS_GROUPHEALS    = "小队";
HEALBOT_OPTIONS_TANKHEALS     = "MT";
HEALBOT_OPTIONS_TARGETHEALS   = "目标";
HEALBOT_OPTIONS_EMERGENCYHEALS= "额外";
HEALBOT_OPTIONS_ALERTLEVEL    = "OT警报等级设置";
HEALBOT_OPTIONS_EMERGFILTER   = "设置团队框架";
HEALBOT_OPTIONS_EMERGFCLASS   = "设置职业";
HEALBOT_OPTIONS_COMBOBUTTON   = "按钮";
HEALBOT_OPTIONS_BUTTONLEFT    = "左";
HEALBOT_OPTIONS_BUTTONMIDDLE  = "中";
HEALBOT_OPTIONS_BUTTONRIGHT   = "右";
HEALBOT_OPTIONS_BUTTON4       = "按钮4";
HEALBOT_OPTIONS_BUTTON5       = "按钮5";

HEALBOT_CLASSES_ALL     = "所有职业";
HEALBOT_CLASSES_MELEE   = "近战";
HEALBOT_CLASSES_RANGES  = "远程";
HEALBOT_CLASSES_HEALERS = "治疗";
HEALBOT_CLASSES_CUSTOM  = "定制";

HEALBOT_OPTIONS_SHOWTOOLTIP     = "显示提示";
HEALBOT_OPTIONS_SHOWDETTOOLTIP  = "显示详细法术信息";
HEALBOT_OPTIONS_SHOWUNITTOOLTIP = "显示目标信息";
HEALBOT_OPTIONS_SHOWRECTOOLTIP  = "显示治疗结束时间的建议";
HEALBOT_OPTIONS_SHOWPDCTOOLTIP  = "显示说明信息";--check
HEALBOT_TOOLTIP_POSDEFAULT      = "本地预设";
HEALBOT_TOOLTIP_POSLEFT         = "Healbot左边";
HEALBOT_TOOLTIP_POSRIGHT        = "Healbot右边";
HEALBOT_TOOLTIP_POSABOVE        = "Healbot上部";
HEALBOT_TOOLTIP_POSBELOW        = "Healbot下部";
HEALBOT_TOOLTIP_POSCURSOR       = "随鼠标指针";
HEALBOT_TOOLTIP_RECOMMENDTEXT   = "治疗结束时间的建议";
HEALBOT_TOOLTIP_NONE            = "无可用";
HEALBOT_TOOLTIP_ITEMBONUS       = "物品奖励";
HEALBOT_TOOLTIP_ACTUALBONUS     = "目前奖励是";
HEALBOT_TOOLTIP_SHIELD          = "治疗";
HEALBOT_TOOLTIP_LOCATION        = "位置";
HEALBOT_WORDS_OVER              = "持续时间";
HEALBOT_WORDS_SEC               = "秒";
HEALBOT_WORDS_TO                = "到";
HEALBOT_WORDS_CAST              = "施放时间";
HEALBOT_WORDS_FOR               = "为";
HEALBOT_WORDS_UNKNOWN           = "未知";
HEALBOT_WORDS_YES               = "是";
HEALBOT_WORDS_NO                = "否";

HEALBOT_WORDS_NONE              = "空";
HEALBOT_OPTIONS_ALT             = "Alt";
HEALBOT_DISABLED_TARGET         = "TARGET";
HEALBOT_OPTIONS_SHOWCLASSONBAR  = "在条上显示职业";
HEALBOT_OPTIONS_SHOWHEALTHONBAR = "在条上显示生命";
HEALBOT_OPTIONS_BARHEALTHINCHEALS = "包含进入治疗";
HEALBOT_OPTIONS_BARHEALTH1      = "详细数值";
HEALBOT_OPTIONS_BARHEALTH2      = "百分比";
HEALBOT_OPTIONS_TIPTEXT         = "提示信息";
HEALBOT_OPTIONS_BARINFOTEXT     = "样式条信息";
HEALBOT_OPTIONS_POSTOOLTIP      = "启用提示";
HEALBOT_OPTIONS_SHOWCLASSNAME   = "包含名称";
HEALBOT_OPTIONS_BARCLASSCOLOUR	= "样式条按职业着色";
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1 = "玩家名着色";
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR2 = "在列表中的玩家名按职业着色";
HEALBOT_OPTIONS_EMERGFILTERGROUPS   = "包含小队";

HEALBOT_ONE   = "1";
HEALBOT_TWO   = "2";
HEALBOT_THREE = "3";
HEALBOT_FOUR  = "4";
HEALBOT_FIVE  = "5";
HEALBOT_SIX   = "6";
HEALBOT_SEVEN = "7";
HEALBOT_EIGHT = "8";

HEALBOT_OPTIONS_SETDEFAULTS    = "设置默认";
HEALBOT_OPTIONS_SETDEFAULTSMSG = "恢复所有设置为默认值";
HEALBOT_OPTIONS_RIGHTBOPTIONS  = "右击图标打开设置面板";

HEALBOT_OPTIONS_HEADEROPTTEXT  = "标题头设置";
HEALBOT_SKIN_HEADERBARCOL      = "样式条颜色";
HEALBOT_SKIN_HEADERTEXTCOL     = "字体颜色";
HEALBOT_OPTIONS_BUFFSTEXT1      = "设置施放buff的技能";
HEALBOT_OPTIONS_BUFFSTEXT2      = "检查范围";
HEALBOT_OPTIONS_BUFFSTEXT3      = "样式条颜色";
HEALBOT_OPTIONS_BUFF           = "Buff ";
HEALBOT_OPTIONS_BUFFSELF       = "对自身";
HEALBOT_OPTIONS_BUFFPARTY      = "对队伍";
HEALBOT_OPTIONS_BUFFRAID       = "对团队";
HEALBOT_OPTIONS_MONITORBUFFS   = "监测缺少BUFF";
HEALBOT_OPTIONS_MONITORBUFFSC  = "战斗中同样监测";
HEALBOT_OPTIONS_ENABLESMARTCAST  = "当结束战斗启用SmartCast";
HEALBOT_OPTIONS_SMARTCASTSPELLS  = "包含法术";
HEALBOT_OPTIONS_SMARTCASTDISPELL = "解除debuff";
HEALBOT_OPTIONS_SMARTCASTBUFF    = "增加buff";
HEALBOT_OPTIONS_SMARTCASTHEAL    = "治疗法术";
HEALBOT_OPTIONS_BAR2SIZE         = "法力条尺寸";
HEALBOT_OPTIONS_SETSPELLS        = "设置法术";
HEALBOT_OPTIONS_ENABLEDBARS     = "总是启用样式条";
HEALBOT_OPTIONS_DISABLEDBARS    = "忽略时间极短的Debuff";
HEALBOT_OPTIONS_MONITORDEBUFFS  = "监测debuff";
HEALBOT_OPTIONS_DEBUFFTEXT1     = "设置解debuff的技能";

HEALBOT_OPTIONS_IGNOREDEBUFF         = "忽略debuff:";
HEALBOT_OPTIONS_IGNOREDEBUFFCLASS    = "不关联职业";
HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT = "减速效果";
HEALBOT_OPTIONS_IGNOREDEBUFFDURATION = "短时间";
HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM   = "忽略无害效果";

HEALBOT_OPTIONS_RANGECHECKFREQ       = "范围检测频率";
HEALBOT_OPTIONS_RANGECHECKUNITS      = "在施法距离内寻找伤害最大及最小单位"

HEALBOT_OPTIONS_HIDEPARTYFRAMES      = "隐藏队伍框体";
HEALBOT_OPTIONS_HIDEPLAYERTARGET     = "包含玩家和目标";
HEALBOT_OPTIONS_DISABLEHEALBOT       = "禁用HealBot";

HEALBOT_OPTIONS_CHECKEDTARGET        = "检查";

HEALBOT_ASSIST  = "ASSIST";
HEALBOT_FOCUS   = "FOCUS";

HEALBOT_TITAN_SMARTCAST      = "SmartCast";
HEALBOT_TITAN_MONITORBUFFS   = "监视buff";
HEALBOT_TITAN_MONITORDEBUFFS = "监视debuff"
HEALBOT_TITAN_SHOWBARS       = "显示样式条";
HEALBOT_TITAN_EXTRABARS      = "额外样式条";
HEALBOT_BUTTON_TOOLTIP       = "左击打开HealBot设置面板";
HEALBOT_OPTIONS_SHOWMINIMAPBUTTON = "显示小地图按钮";
HEALBOT_OPTIONS_BARBUTTONSHOWHOT  = "显示HoT图标";
HEALBOT_OPTIONS_HOTONBAR     = "打开"
HEALBOT_OPTIONS_HOTOFFBAR    = "关闭"
HEALBOT_OPTIONS_HOTBARRIGHT  = "右边"
HEALBOT_OPTIONS_HOTBARLEFT   = "左边"

HEALBOT_OPTIONS_ENABLETARGETSTATUS = "当目标进入战斗，使用启用设置"

HEALBOT_ZONE_AB = "阿拉希盆地";
HEALBOT_ZONE_AV = "奥特兰克山谷";
HEALBOT_ZONE_ES = "风暴之眼";
HEALBOT_ZONE_WG = "战歌峡谷";

HEALBOT_OPTION_AGGROTRACK = "仇恨提醒"
HEALBOT_OPTION_AGGROBAR = "闪烁条"
HEALBOT_OPTION_AGGROTXT = ">> 显示文字 <<"
HEALBOT_OPTION_BARUPDFREQ = "闪烁频率"
HEALBOT_OPTION_USEFLUIDBARS = "采用动态监视"
HEALBOT_OPTION_CPUPROFILE  = "使用CPU性能测试（插件CPU使用信息）"
HEALBOT_OPTIONS_SETCPUPROFILERMSG = "该选项需要重载UI，现在重载?"

HEALBOT_SELF_PVP              = "自身PvP"
HEALBOT_OPTIONS_ANCHOR        = "锚点"
HEALBOT_OPTIONS_TOPLEFT       = "左上"
HEALBOT_OPTIONS_BOTTOMLEFT    = "左下"
HEALBOT_OPTIONS_TOPRIGHT      = "右上"
HEALBOT_OPTIONS_BOTTOMRIGHT   = "右下"

HEALBOT_PANEL_BLACKLIST       = "黑名单"
HEALBOT_WORDS_REMOVEFROM      = "移除";
HEALBOT_WORDS_ADDTO           = "增加";
HEALBOT_WORDS_INCLUDE         = "包含";

HEALBOT_OPTIONS_TTALPHA       = "透明度"
HEALBOT_TOOLTIP_TARGETBAR     = "目标监视条"
HEALBOT_OPTIONS_MYTARGET      = "我的目标"

end

