-- French version (by Kubik) 2008-06-24
-- à = \195\160
-- â = \195\162
-- ç = \195\167
-- è = \195\168
-- é = \195\169
-- ê = \195\170
-- î = \195\174
-- ï = \195\175
-- ô = \195\180
-- û = \195\187
-- espace avant ':' (?) = \194\160

------------
-- FRENCH --
------------

-- Ã©: \195\169
-- Ãª: \195\170
-- Ã : \195\160
-- Ã®: \195\174
-- Ã¨: \195\168
-- Ã«: \195\171
-- Ã´: \195\180
-- Ã»: \195\187
-- Ã¢: \195\162
-- Ã§: \185\167
-- Ã¹: \195\185


if (GetLocale() == "frFR") then

-------------------
-- Compatibility --
-------------------

HEALBOT_DRUID   = "Druide";
HEALBOT_HUNTER  = "Chasseur";
HEALBOT_MAGE    = "Mage";
HEALBOT_PALADIN = "Paladin";
HEALBOT_PRIEST  = "Pr\195\170tre";
HEALBOT_ROGUE   = "Voleur";
HEALBOT_SHAMAN  = "Chaman";
HEALBOT_WARLOCK = "D\195\169moniste";
HEALBOT_WARRIOR = "Guerrier";

HEALBOT_HEAVY_RUNECLOTH_BANDAGE = "Bandage en \195\169toffe runique \195\169pais";
HEALBOT_MAJOR_HEALING_POTION    = "Potion de Soins majeure";
HEALBOT_PURIFICATION_POTION     = "Potion de purification";
HEALBOT_ANTI_VENOM              = "Anti-venin";
HEALBOT_POWERFUL_ANTI_VENOM     = "Anti-venin puissant";
HEALBOT_ELIXIR_OF_POISON_RES    = "Elixir de r\195\169sistance au poison";

HEALBOT_FLASH_HEAL          = "Soins rapides";
HEALBOT_FLASH_OF_LIGHT      = "Eclair lumineux";
HEALBOT_GREATER_HEAL        = "Soins sup\195\169rieurs";
HEALBOT_BINDING_HEAL        = "Soins de lien"
HEALBOT_PRAYER_OF_MENDING   = "Pri\195\168re de gu\195\169rison";
HEALBOT_HEALING_TOUCH       = "Toucher gu\195\169risseur";
HEALBOT_HEAL                = "Soins";
HEALBOT_HEALING_WAVE        = "Vague de soins";
HEALBOT_HOLY_LIGHT          = "Lumi\195\168re sacr\195\169e";
HEALBOT_LESSER_HEAL         = "Soins inf\195\169rieurs";
HEALBOT_LESSER_HEALING_WAVE = "Vague de soins inf\195\169rieurs";
HEALBOT_POWER_WORD_SHIELD   = "Mot de pouvoir\194\160: Bouclier"
HEALBOT_REGROWTH            = "R\195\169tablissement";
HEALBOT_RENEW               = "R\195\169novation";
HEALBOT_REJUVENATION        = "R\195\169cup\195\169ration";
HEALBOT_LIFEBLOOM           = "Fleur de vie";
HEALBOT_PRAYER_OF_HEALING   = "Pri\195\168re de soins";
HEALBOT_CHAIN_HEAL          = "Salve de gu\195\169rison";

HEALBOT_PRAYER_OF_FORTITUDE   = "Pri\195\168re de robustesse";
HEALBOT_POWER_WORD_FORTITUDE = "Mot de pouvoir\194\160: Robustesse";
HEALBOT_DIVINE_SPIRIT         = "Esprit divin";
HEALBOT_PRAYER_OF_SPIRIT      = "Pri\195\168re d'Esprit"
HEALBOT_SHADOW_PROTECTION     = "Protection contre l\'Ombre";
HEALBOT_PRAYER_OF_SHADOW_PROTECTION = "Pri\195\168re de protection contre l\'Ombre";
HEALBOT_INNER_FIRE            = "Feu int\195\169rieur";
HEALBOT_INNER_FOCUS           = "Focalisation am\195\169lior\195\169e";
HEALBOT_FEAR_WARD           = "Gardien de peur";
HEALBOT_TOUCH_OF_WEAKNESS     = "Toucher d\195\169bilitant"
HEALBOT_ARCANE_INTELLECT      = "Intelligence des arcanes";
HEALBOT_ARCANE_BRILLIANCE     = "Illumination des arcanes";
HEALBOT_FROST_ARMOR           = "Armure de givre";
HEALBOT_ICE_ARMOR             = "Armure de glace";
HEALBOT_MAGE_ARMOR            = "Armure du Mage";
HEALBOT_MOLTEN_ARMOR          = "Armure de la fournaise";
HEALBOT_DEMON_ARMOR           = "Armure d\195\169moniaque";
HEALBOT_DEMON_SKIN            = "Peau de d\195\169mon";
HEALBOT_FEL_ARMOR             = "Gangrarmure"; 
HEALBOT_DAMPEN_MAGIC          = "Att\195\169nuation de la magie";
HEALBOT_AMPLIFY_MAGIC         = "Amplification de la magie";
HEALBOT_SHADOW_GUARD          = "Garde de l\'ombre";
HEALBOT_DETECT_INV            = "D\195\169tection de l\'invisibilit\195\169";

HEALBOT_LIGHTNING_SHIELD      = "Bouclier de Foudre";
HEALBOT_ROCKBITER_WEAPON      = "Arme Croque-roc";
HEALBOT_FLAMETONGUE_WEAPON    = "Arme Langue de feu";
HEALBOT_FROSTBRAND_WEAPON     = "Arme de givre"; 
HEALBOT_EARTH_SHIELD          = "Bouclier de terre"; 
HEALBOT_WATER_SHIELD          = "Bouclier d'eau";
HEALBOT_WIND_FURY             = "Furie des vents";

HEALBOT_MARK_OF_THE_WILD      = "Marque du fauve";
HEALBOT_GIFT_OF_THE_WILD      = "Don du fauve";
HEALBOT_THORNS                = "Epines";
HEALBOT_OMEN_OF_CLARITY       = "Augure de clart\195\169";

HEALBOT_BLESSING_OF_MIGHT       = "B\195\169n\195\169diction de puissance";
HEALBOT_BLESSING_OF_WISDOM      = "B\195\169n\195\169diction de sagesse";
HEALBOT_BLESSING_OF_SALVATION   = "B\195\169n\195\169diction de salut";
HEALBOT_BLESSING_OF_SANCTUARY   = "B\195\169n\195\169diction du sanctuaire";
HEALBOT_BLESSING_OF_LIGHT       = "B\195\169n\195\169diction de lumi\195\168re";
HEALBOT_BLESSING_OF_PROTECTION  = "B\195\169n\195\169diction de protection";
HEALBOT_BLESSING_OF_FREEDOM     = "B\195\169n\195\169diction de libert\195\169";
HEALBOT_BLESSING_OF_SACRIFICE   = "B\195\169n\195\169diction de sacrifice";
HEALBOT_BLESSING_OF_KINGS       = "B\195\169n\195\169diction des rois";
HEALBOT_GREATER_BLESSING_OF_MIGHT     = "B\195\169n\195\169diction de puissance sup\195\169rieure";
HEALBOT_GREATER_BLESSING_OF_WISDOM    = "B\195\169n\195\169diction de sagesse sup\195\169rieure";
HEALBOT_GREATER_BLESSING_OF_KINGS     = "B\195\169n\195\169diction des rois sup\195\169rieure";
HEALBOT_GREATER_BLESSING_OF_LIGHT     = "B\195\169n\195\169diction de lumi\195\168re sup\195\169rieure";
HEALBOT_GREATER_BLESSING_OF_SALVATION = "B\195\169n\195\169diction de salut sup\195\169rieure";
HEALBOT_GREATER_BLESSING_OF_SANCTUARY = "B\195\169n\195\169diction du sanctuaire sup\195\169rieure";
HEALBOT_RIGHTEOUS_FURY          = "Fureur vertueuse"
HEALBOT_DEVOTION_AURA           = "Aura de d\195\169votion"
HEALBOT_RETRIBUTION_AURA        = "Aura de vindicte"
HEALBOT_CONCENTRATION_AURA      = "Aura de concentration"
HEALBOT_SHR_AURA                = "Aura de r\195\169sistance \195\160 l\'Ombre"
HEALBOT_FRR_AURA                = "Aura de r\195\169sistance au Givre"
HEALBOT_FIR_AURA                = "Aura de r\195\169sistance au Feu"
HEALBOT_CRUSADER_AURA           = "Aura de crois\195\169"
HEALBOT_SANCTITY_AURA           = "Aura de saintet\195\169"

HEALBOT_A_MONKEY            = "Aspect du singe"
HEALBOT_A_HAWK              = "Aspect du faucon"
HEALBOT_A_CHEETAH           = "Aspect du gu\195\169pard"
HEALBOT_A_BEAST             = "Aspect de la b\195\170te"
HEALBOT_A_PACK              = "Aspect de la meute"
HEALBOT_A_WILD              = "Aspect de la nature"
HEALBOT_A_VIPER             = "Aspect de la vip\195\168re"
HEALBOT_MENDPET             = "Gu\195\169rison du familier"

HEALBOT_UNENDING_BREATH     = "Respiration interminable"
HEALBOT_HEALTH_FUNNEL       = "Captation de vie"

HEALBOT_RESURRECTION       = "R\195\169surrection";
HEALBOT_REDEMPTION         = "R\195\169demption";
HEALBOT_REBIRTH            = "Renaissance";
HEALBOT_ANCESTRALSPIRIT    = "Esprit Ancestral";

HEALBOT_PURIFY             = "Purification";
HEALBOT_CLEANSE            = "Epuration";
HEALBOT_CURE_POISON        = "Gu\195\169rison du poison";
HEALBOT_REMOVE_CURSE       = "D\195\169livrance de la mal\195\169diction";
HEALBOT_ABOLISH_POISON     = "Abolir le poison";
HEALBOT_CURE_DISEASE       = "Gu\195\169rison des maladies";
HEALBOT_ABOLISH_DISEASE    = "Abolir maladie";
HEALBOT_DISPEL_MAGIC       = "Dissipation de la magie";
HEALBOT_REMOVE_LESSER_CURSE = "D\195\169livrance de la mal\195\169diction mineure"; 
HEALBOT_DISEASE            = "Maladie";
HEALBOT_MAGIC              = "Magie";
HEALBOT_CURSE              = "Mal\195\169diction";
HEALBOT_POISON             = "Poison";





HEALBOT_DEBUFF_ANCIENT_HYSTERIA = "Hyst\195\169rie ancienne";
HEALBOT_DEBUFF_IGNITE_MANA      = "Enflammer le mana";
HEALBOT_DEBUFF_TAINTED_MIND     = "Esprit corrompu";
HEALBOT_DEBUFF_VIPER_STING      = "Morsure de vip\195\168re";
HEALBOT_DEBUFF_SILENCE          = "Silence";
HEALBOT_DEBUFF_MAGMA_SHACKLES   = "Entraves de magma";
HEALBOT_DEBUFF_FROSTBOLT        = "Eclair de givre";
HEALBOT_DEBUFF_PSYCHIC_HORROR   = "Cri Psychique";
HEALBOT_DEBUFF_HUNTERS_MARK     = "Marque du chasseur";
HEALBOT_DEBUFF_SLOW             = "Lent";
HEALBOT_DEBUFF_ARCANE_BLAST     = "D\195\169flagration des arcanes";
HEALBOT_DEBUFF_IMPOTENCE        = "Mal\195\169diction d'impuissance";
HEALBOT_DEBUFF_DECAYED_STR      = "Force diminu\195\169e";
HEALBOT_DEBUFF_DECAYED_INT      = "Intelligence diminu\195\169e";
HEALBOT_DEBUFF_CRIPPLE          = "Estropi\195\169";
HEALBOT_DEBUFF_CHILLED          = "Gel\195\169";
HEALBOT_DEBUFF_CONEOFCOLD       = "C\195\180ne de froid";
HEALBOT_DEBUFF_CONCUSSIVESHOT   = "Fl\195\168che de dispersion";
HEALBOT_DEBUFF_THUNDERCLAP      = "Coup de tonnerre";
HEALBOT_DEBUFF_HOWLINGSCREECH   = "Etreinte vampirirque";
HEALBOT_DEBUFF_DAZED            = "h\195\169b\195\169t\195\169";
HEALBOT_DEBUFF_FALTER           = "D\195\169serteur"; 
HEALBOT_DEBUFF_UNSTABLE_AFFL    = "Affliction instable";
HEALBOT_DEBUFF_DREAMLESS_SLEEP  = "Sommeil sans r\195\170ve";
HEALBOT_DEBUFF_GREATER_DREAMLESS = "Sommeil sans r\195\170ve sup\195\169rieur";
HEALBOT_DEBUFF_MAJOR_DREAMLESS  = "Sommeil sans r\195\170ve majeure";
HEALBOT_DEBUFF_FROST_SHOCK      = "Horion de givre"

HEALBOT_RANK_1              = "(Rang 1)";
HEALBOT_RANK_2              = "(Rang 2)";
HEALBOT_RANK_3              = "(Rang 3)";
HEALBOT_RANK_4              = "(Rang 4)";
HEALBOT_RANK_5              = "(Rang 5)";
HEALBOT_RANK_6              = "(Rang 6)";
HEALBOT_RANK_7              = "(Rang 7)";
HEALBOT_RANK_8              = "(Rang 8)";
HEALBOT_RANK_9              = "(Rang 9)";
HEALBOT_RANK_10             = "(Rang 10)";
HEALBOT_RANK_11             = "(Rang 11)";
HEALBOT_RANK_12             = "(Rang 12)";
HEALBOT_RANK_13             = "(Rang 13)";

HB_SPELL_PATTERN_LESSER_HEAL         = "Rend \195\160 votre cible (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_HEAL                = "Rend \195\160 votre cible (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_GREATER_HEAL        = "Une longue incantation qui rend (%d+) \195\160 (%d+) points de vie \195\160 une cible unique";
HB_SPELL_PATTERN_FLASH_HEAL          = "Rend (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_RENEW               = "Rend (%d+) \195\160 (%d+) points de vie \195\160 la cible en (%d+) sec";
HB_SPELL_PATTERN_RENEW1              = "Rend (%d+) points de vie \195\160 la cible en (%d+) sec";
HB_SPELL_PATTERN_RENEW2              = "Not needed for fr";
HB_SPELL_PATTERN_RENEW3              = "Not needed for fr";
HB_SPELL_PATTERN_SHIELD              = "absorbe (%d+) points de d\195\169g\195\162ts. Dure (%d+) sec";
HB_SPELL_PATTERN_HEALING_TOUCH       = "Rend (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_REGROWTH            = "Soigne une cible amie pour (%d+) \195\160 (%d+) puis pour (%d+) points suppl.+mentaires pendant (%d+) sec";
HB_SPELL_PATTERN_REGROWTH1           = "Soigne une cible amie pour (%d+) \195\160 (%d+) puis pour (%d+) \195\160 (%d+) points suppl.+mentaires pendant (%d+) sec";
HB_SPELL_PATTERN_HOLY_LIGHT          = "Rend (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_FLASH_OF_LIGHT      = "Rend (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_HEALING_WAVE        = "Rend (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_LESSER_HEALING_WAVE = "Rend (%d+) \195\160 (%d+) points de vie";
HB_SPELL_PATTERN_REJUVENATION        = "Rend (%d+) points de vie \195\160 la cible en (%d+) sec";
HB_SPELL_PATTERN_REJUVENATION1       = "Rend (%d+) \195\160 (%d+) points de vie \195\160 la cible en (%d+) sec";
HB_SPELL_PATTERN_REJUVENATION2       = "Not needed for fr";
HB_SPELL_PATTERN_MEND_PET            = "Soigne votre pet de (%d+) points de vie chaques secondes que vous le ciblez. Dure (%d+) sec"

HB_TOOLTIP_MANA                      = "^Mana : (%d+)$";
HB_TOOLTIP_RANGE                     = "de (%d+) m"
HB_TOOLTIP_INSTANT_CAST              = "Incantation imm\195\169diate";
HB_TOOLTIP_CAST_TIME                 = "Incantation (%d+.?%d*) sec";
HB_TOOLTIP_CHANNELED                 = "Focaliser"
HB_HASLEFTRAID                       = "^([^%s]+) a quitt\195\169 le groupe de raid$";
HB_HASLEFTPARTY                      = "^([^%s]+) a quitt\195\169 le groupe$";
HB_YOULEAVETHEGROUP                  = "Vous quittez le groupe"
HB_YOULEAVETHERAID                   = "Vous avez quitt\195\169 le groupe de raid"
HB_YOUJOINTHERAID                    = "Vous avez rejoint le groupe de raid"
HB_YOUJOINTHEGROUP                   = "Vous avez rejoint le groupe"

-----------------
-- Translation --
-----------------

HEALBOT_ADDON = "HealBot " .. HEALBOT_VERSION;
HEALBOT_LOADED = " charg\195\169.";

HEALBOT_CASTINGSPELLONYOU  = "Lance %s sur vous ...";
HEALBOT_CASTINGSPELLONUNIT = "Lance %s sur %s ...";

HEALBOT_ACTION_OPTIONS    = "Options";

HEALBOT_OPTIONS_TITLE         = HEALBOT_ADDON;
HEALBOT_OPTIONS_DEFAULTS      = "D\195\169faut";
HEALBOT_OPTIONS_CLOSE         = "Fermer";
HEALBOT_OPTIONS_HARDRESET     = "ReloadUI";
HEALBOT_OPTIONS_SOFTRESET     = "ResetHB";
HEALBOT_OPTIONS_INFO          = "Infos";
HEALBOT_OPTIONS_TAB_GENERAL   = "G\195\169n\195\169ral";
HEALBOT_OPTIONS_TAB_SPELLS    = "Sorts";
HEALBOT_OPTIONS_TAB_HEALING   = "Soins";
HEALBOT_OPTIONS_TAB_CDC       = "Gu\195\169rison";
HEALBOT_OPTIONS_TAB_SKIN      = "Skin";
HEALBOT_OPTIONS_TAB_TIPS      = "Affich.";
HEALBOT_OPTIONS_TAB_BUFFS     = "Buffs"

HEALBOT_OPTIONS_PANEL_TEXT    = "Options de soins"
HEALBOT_OPTIONS_BARALPHA      = "opacit\195\169 barre";
HEALBOT_OPTIONS_BARALPHAINHEAL= "Opacit\195\169 des sorts en cours";
HEALBOT_OPTIONS_ACTIONLOCKED  = "Verr. la position";
HEALBOT_OPTIONS_AUTOSHOW      = "Fermer automatiquement";
HEALBOT_OPTIONS_PANELSOUNDS   = "Son \195\160 l\'ouverture";
HEALBOT_OPTIONS_HIDEOPTIONS   = "Masquer le bouton d\'options";
HEALBOT_OPTIONS_PROTECTPVP    = "Eviter le passage accidentel en JcJ";
HEALBOT_OPTIONS_HEAL_CHATOPT  = "Options de chat";

HEALBOT_OPTIONS_SKINTEXT      = "Utilise skin"
HEALBOT_SKINS_STD             = "Standard"
HEALBOT_OPTIONS_SKINTEXTURE   = "Texture"
HEALBOT_OPTIONS_SKINHEIGHT    = "Hauteur"
HEALBOT_OPTIONS_SKINWIDTH     = "Largeur"
HEALBOT_OPTIONS_SKINNUMCOLS   = "No. colonne"
HEALBOT_OPTIONS_SKINNUMHCOLS  = "No. en-t\195\170tes par colonne"
HEALBOT_OPTIONS_SKINBRSPACE   = "Espacement rang\195\169es"
HEALBOT_OPTIONS_SKINBCSPACE   = "Espacement col."
HEALBOT_OPTIONS_EXTRASORT     = "Trier barres suppl. par"
HEALBOT_SORTBY_NAME           = "Nom"
HEALBOT_SORTBY_CLASS          = "Classe"
HEALBOT_SORTBY_GROUP          = "Groupe"
HEALBOT_SORTBY_MAXHEALTH      = "Vie max."
HEALBOT_OPTIONS_DELSKIN       = "Supprimer"
HEALBOT_OPTIONS_NEWSKINTEXT   = "Nouveau skin"
HEALBOT_OPTIONS_SAVESKIN      = "Sauver"
HEALBOT_OPTIONS_SKINBARS      = "Options des barres"
HEALBOT_OPTIONS_SKINPANEL     = "Couleurs du panneau"
HEALBOT_SKIN_ENTEXT           = "Activ\195\169"
HEALBOT_SKIN_DISTEXT          = "D\195\169sactiv\195\169"
HEALBOT_SKIN_DEBTEXT          = "Debuff"
HEALBOT_SKIN_BACKTEXT         = "Arri\195\168re plan"
HEALBOT_SKIN_BORDERTEXT       = "Bordure"
HEALBOT_OPTIONS_SKINFHEIGHT   = "Taille Caract\195\168res"
HEALBOT_OPTIONS_BARALPHADIS   = "Opacit\195\169 des joueurs d\195\169sactiv\195\169s"
HEALBOT_OPTIONS_SHOWHEADERS   = "Montrer titres"

HEALBOT_OPTIONS_ITEMS  = "Objets";
HEALBOT_OPTIONS_SPELLS = "Sorts";

HEALBOT_OPTIONS_COMBOCLASS    = "Combinaison de touche pour";
HEALBOT_OPTIONS_CLICK         = "Clic";
HEALBOT_OPTIONS_SHIFT         = "Maj";
HEALBOT_OPTIONS_CTRL          = "Ctrl";
HEALBOT_OPTIONS_ENABLEHEALTHY = "Toujours utiliser config. 'en combat'";

HEALBOT_OPTIONS_CASTNOTIFY1   = "Pas de messages";
HEALBOT_OPTIONS_CASTNOTIFY2   = "Avertir soi-m\195\170me";
HEALBOT_OPTIONS_CASTNOTIFY3   = "Avertir la cible";
HEALBOT_OPTIONS_CASTNOTIFY4   = "Avertir le groupe";
HEALBOT_OPTIONS_CASTNOTIFY5   = "Avertir le raid";
HEALBOT_OPTIONS_CASTNOTIFY6   = "Avertir sur canal";
HEALBOT_OPTIONS_CASTNOTIFYRESONLY = "Avertir uniquement de la r\195\169surrection";
HEALBOT_OPTIONS_TARGETWHISPER = "Chuchoter au moment du heal";

HEALBOT_OPTIONS_CDCBARS       = "Couleur de la barre de vie";
HEALBOT_OPTIONS_CDCCLASS      = "Surveiller les classes";
HEALBOT_OPTIONS_CDCWARNINGS   = "Alertes Debuff";
HEALBOT_OPTIONS_SHOWDEBUFFWARNING = "Afficher une alerte de debuff";
HEALBOT_OPTIONS_SOUNDDEBUFFWARNING = "Jouer un son pour debuff";
HEALBOT_OPTIONS_SOUND1        = "Son 1"
HEALBOT_OPTIONS_SOUND2        = "Son 2"
HEALBOT_OPTIONS_SOUND3        = "Son 3"

HEALBOT_OPTIONS_HEAL_BUTTONS  = "Barres de soins:"
HEALBOT_OPTIONS_SELFHEALS     = "soi-m\195\170me"
HEALBOT_OPTIONS_PETHEALS      = "Familiers"
HEALBOT_OPTIONS_GROUPHEALS    = "Groupe";
HEALBOT_OPTIONS_TANKHEALS     = "Tank principal";
HEALBOT_OPTIONS_TARGETHEALS   = "Cibles";
HEALBOT_OPTIONS_EMERGENCYHEALS= "Urgences/Extra";
HEALBOT_OPTIONS_ALERTLEVEL    = "Niveau d'alerte";
HEALBOT_OPTIONS_EMERGFILTER   = "Barre suppl. pour";
-- HEALBOT_OPTIONS_EMERGFILTER   = "Bouton d'urgence pour";
HEALBOT_OPTIONS_EMERGFCLASS   = "Config. classes pour";
HEALBOT_OPTIONS_COMBOBUTTON   = "Bouton";
HEALBOT_OPTIONS_BUTTONLEFT    = "Gauche";
HEALBOT_OPTIONS_BUTTONMIDDLE  = "Milieu";
HEALBOT_OPTIONS_BUTTONRIGHT   = "Droite";
HEALBOT_OPTIONS_BUTTON4       = "Bouton4";
HEALBOT_OPTIONS_BUTTON5       = "Bouton5";

HEALBOT_CLASSES_ALL     = "Toutes les classes";
HEALBOT_CLASSES_MELEE   = "Corps \195\160 corps";
HEALBOT_CLASSES_RANGES  = "A distance";
HEALBOT_CLASSES_HEALERS = "Soigneurs";
HEALBOT_CLASSES_CUSTOM  = "Personnalis\195\169";

HEALBOT_OPTIONS_SHOWTOOLTIP     = "Montrer infos";
HEALBOT_OPTIONS_SHOWDETTOOLTIP  = "Montrer le d\195\169tails des sorts";
HEALBOT_OPTIONS_SHOWUNITTOOLTIP = "Montrer les infos de la cible";
HEALBOT_OPTIONS_SHOWRECTOOLTIP  = "Montrer le soin HoT recommand\195\169";
HEALBOT_OPTIONS_SHOWPDCTOOLTIP  = "Afficher les combinaisons de touches pr\195\169d\195\169finies";
HEALBOT_TOOLTIP_POSDEFAULT      = "Par d\195\169faut";
HEALBOT_TOOLTIP_POSLEFT         = "A gauche de Healbot";
HEALBOT_TOOLTIP_POSRIGHT        = "A droite de Healbot";
HEALBOT_TOOLTIP_POSABOVE        = "Au dessus de Healbot";
HEALBOT_TOOLTIP_POSBELOW        = "Au dessous de Healbot";
HEALBOT_TOOLTIP_POSCURSOR       = "Pr\195\170t du Curseur";
HEALBOT_TOOLTIP_RECOMMENDTEXT   = "Soin HoT recommand\195\169";
HEALBOT_TOOLTIP_NONE            = "Non disponible";
HEALBOT_TOOLTIP_ITEMBONUS       = "Bonus d'objets";
HEALBOT_TOOLTIP_ACTUALBONUS     = "Bonus r\195\169el";
HEALBOT_TOOLTIP_SHIELD          = "Salle"
HEALBOT_TOOLTIP_LOCATION        = "Lieu";
HEALBOT_WORDS_OVER              = "par";
HEALBOT_WORDS_SEC               = "sec";
HEALBOT_WORDS_TO                = "\195\160";
HEALBOT_WORDS_CAST              = "lancer"
HEALBOT_WORDS_FOR               = "sur";
HEALBOT_WORDS_UNKNOW            = "inconnu";
HEALBOT_WORDS_YES               = "Oui";
HEALBOT_WORDS_NO                = "Non";

HEALBOT_WORDS_NONE              = "Aucun";
HEALBOT_OPTIONS_ALT             = "Alt";
HEALBOT_DISABLED_TARGET         = "Cible"
-- HEALBOT_DISABLED_TARGET         = "Target"
HEALBOT_OPTIONS_SHOWCLASSONBAR  = "Afficher la classe";
HEALBOT_OPTIONS_SHOWHEALTHONBAR = "Afficher la vie";
HEALBOT_OPTIONS_BARHEALTHINCHEALS = "Inclure soins en cours";
HEALBOT_OPTIONS_BARHEALTH1      = "en \195\169cart";
HEALBOT_OPTIONS_BARHEALTH2      = "en pourcentage";
HEALBOT_OPTIONS_TIPTEXT         = "Bulle d\'info";
HEALBOT_OPTIONS_BARINFOTEXT     = "Barre d\'info";
HEALBOT_OPTIONS_POSTOOLTIP      = "Position";
HEALBOT_OPTIONS_SHOWCLASSNAME   = "Inclure le nom";
HEALBOT_OPTIONS_BARCLASSCOLOUR	= "Color bar by class";
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1 = "Affiche une couleur par classe"
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR2 = "Param. de 'Skin' remplac\195\169s par ceux de debuff et 'en combat'"
HEALBOT_OPTIONS_EMERGFILTERGROUPS   = "Inclure groupes";










HEALBOT_OPTIONS_SETDEFAULTS    = "R\195\169g. par d\195\169faut";
HEALBOT_OPTIONS_SETDEFAULTSMSG = "R\195\169-initialise toutes les options par d\195\169faut";
HEALBOT_OPTIONS_RIGHTBOPTIONS  = "Clic droit ouvre les options";

HEALBOT_OPTIONS_HEADEROPTTEXT  = "Options des titre";
HEALBOT_SKIN_HEADERBARCOL      = "Couleur des barres";
HEALBOT_SKIN_HEADERTEXTCOL     = "Couleur du texte";
HEALBOT_OPTIONS_BUFFSTEXT1      = "Type de buff";
HEALBOT_OPTIONS_BUFFSTEXT2      = "V\195\169rifier membres";
HEALBOT_OPTIONS_BUFFSTEXT3      = "Couleur des barres";
HEALBOT_OPTIONS_BUFF           = "Buff ";
HEALBOT_OPTIONS_BUFFSELF       = "sur soi";
HEALBOT_OPTIONS_BUFFPARTY      = "sur le groupe";
HEALBOT_OPTIONS_BUFFRAID       = "sur le raid";
HEALBOT_OPTIONS_MONITORBUFFS   = "Afficher les buffs manquants";
HEALBOT_OPTIONS_MONITORBUFFSC  = "\195\169galement en combat";
HEALBOT_OPTIONS_ENABLESMARTCAST  = "Sorts 'SmartCast' hors combat";
HEALBOT_OPTIONS_SMARTCASTSPELLS  = "Inclure les sorts";
HEALBOT_OPTIONS_SMARTCASTDISPELL = "Enlever les debuffs";
HEALBOT_OPTIONS_SMARTCASTBUFF    = "Ajouter les buffs";
HEALBOT_OPTIONS_SMARTCASTHEAL    = "Sorts de soin";
HEALBOT_OPTIONS_BAR2SIZE         = "Taille de la barre de mana";
HEALBOT_OPTIONS_SETSPELLS        = "Conf. sorts pour";
HEALBOT_OPTIONS_ENABLEDBARS     = "Barres en combat";
HEALBOT_OPTIONS_DISABLEDBARS    = "Barres hors combat";
HEALBOT_OPTIONS_MONITORDEBUFFS  = "Afficher les debuffs";
HEALBOT_OPTIONS_DEBUFFTEXT1     = "Sort pour retirer les debuffs";

HEALBOT_OPTIONS_IGNOREDEBUFF         = "Ignorer debuffs:";
HEALBOT_OPTIONS_IGNOREDEBUFFCLASS    = "Non pertinent";
HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT = "Effet de ralentissement";
HEALBOT_OPTIONS_IGNOREDEBUFFDURATION = "Dur\195\169e courte";
HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM   = "Effets non nocifs";

HEALBOT_OPTIONS_RANGECHECKFREQ       = "Fr\195\169quence de v\195\169rification";
HEALBOT_OPTIONS_RANGECHECKUNITS      = "Freq. v\195\169rif. sur cibles avec blessures mineures"

HEALBOT_OPTIONS_HIDEPARTYFRAMES      = "Masquer avatars WoW";
HEALBOT_OPTIONS_HIDEPLAYERTARGET     = "Y compris joueur & Cible";
HEALBOT_OPTIONS_DISABLEHEALBOT       = "D\195\169sactiver HealBot";

HEALBOT_OPTIONS_CHECKEDTARGET        = "V\195\169rifi\195\169";

HEALBOT_ASSIST  = "Assist";
HEALBOT_FOCUS   = "Focus";

HEALBOT_TITAN_SMARTCAST      = "Incantations astucieuses";
HEALBOT_TITAN_MONITORBUFFS   = "Afficher les Buffs";
HEALBOT_TITAN_MONITORDEBUFFS = "Afficher les Debuffs"
HEALBOT_TITAN_SHOWBARS       = "Afficher barres pour";
HEALBOT_TITAN_EXTRABARS      = "Barres suppl.";
HEALBOT_BUTTON_TOOLTIP       = "Clic gauche : options HealBot";
HEALBOT_OPTIONS_SHOWMINIMAPBUTTON = "Afficher bouton minicarte";
HEALBOT_OPTIONS_BARBUTTONSHOWHOT  = "Afficher ic\195\180nes HoT";
HEALBOT_OPTIONS_HOTONBAR     = "Sur barre"
HEALBOT_OPTIONS_HOTOFFBAR    = "Hors barre"
HEALBOT_OPTIONS_HOTBARRIGHT  = "Droite"
HEALBOT_OPTIONS_HOTBARLEFT   = "Gauche"

HEALBOT_OPTIONS_ENABLETARGETSTATUS = "Utiliser r\195\169glages 'actif' si cible en combat";

HEALBOT_ZONE_AB = "Bassin d\'Arathi"; 
HEALBOT_ZONE_AV = "Vall\195\169e d\'Alterac";   
HEALBOT_ZONE_ES = "Oeil du cyclone";
HEALBOT_ZONE_WG = "Goulet des Chanteguerres";

HEALBOT_OPTION_AGGROTRACK     = "Moniteur d'aggro"
HEALBOT_OPTION_AGGROBAR       = "Barres 'Flash'"
HEALBOT_OPTION_AGGROTXT       = ">> Montrer texte <<"
HEALBOT_OPTION_BARUPDFREQ     = "Fr\195\169quence de mise \195\160 jour des barres"
HEALBOT_OPTION_USEFLUIDBARS   = "Utiliser barres 'fluides'"
HEALBOT_OPTION_CPUPROFILE  = "Utilser CPU profiler (Addons CPU usage Info)"
HEALBOT_OPTIONS_SETCPUPROFILERMSG = "Requiert un re-chargement de l\'UI, Charger maintenant ?"

HEALBOT_SELF_PVP              = "Self PvP"
HEALBOT_OPTIONS_ANCHOR        = "Ancrer"
HEALBOT_OPTIONS_TOPLEFT       = "Haut \195\160 gauche"
HEALBOT_OPTIONS_BOTTOMLEFT    = "Bas \195\160 gauche"
HEALBOT_OPTIONS_TOPRIGHT      = "Haut \195\160 droite"
HEALBOT_OPTIONS_BOTTOMRIGHT   = "Bas \195\160 droite"

HEALBOT_PANEL_BLACKLIST       = "BlackList"

HEALBOT_WORDS_REMOVEFROM      = "Retirer de";
HEALBOT_WORDS_ADDTO           = "Ajouter \195\160";
HEALBOT_WORDS_INCLUDE         = "Inclure";

HEALBOT_OPTIONS_TTALPHA       = "Opacit\195\169"
HEALBOT_TOOLTIP_TARGETBAR     = "Barre de cible"
HEALBOT_OPTIONS_MYTARGET      = "Mes cibles"

end

