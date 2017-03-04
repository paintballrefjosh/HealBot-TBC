function HealBot_Errors_OnLoad(this)
  -- do nothing
end

local HBclient=nil
local HB_errtext=nil
function HealBot_Errors_OnShow(this)
  HBclient = getglobal("HealBot_Error_Clientx")
  HBclient:SetText("Client="..GetLocale())
  HealBot_Error_Versionx:SetText("Healbot verion="..HEALBOT_VERSION)
  HealBot_Error_Classx:SetText("Player class="..HealBot_PlayerClassEN)
end

function HealBot_Errors_OnHide(this)
  HealBot_StopMoving(this);
  HealBot_Errors_Clear()
end

function HealBot_Errors_Clear()
  for j=1,3 do
    HB_errtext = getglobal("HealBot_Error"..j);
    HB_errtext:SetText(" ")
  end
  HealBot_ErrorCntReset();
end

function HealBot_Errors_OnDragStart(this,arg1)
  HealBot_StartMoving(this);
end

function HealBot_Errors_OnDragStop(this)
  HealBot_StopMoving(this);
end

function HealBot_ErrorsIn(msg,id)
  HB_errtext = getglobal("HealBot_Error"..id);
  HB_errtext:SetText(msg)
  if not HealBot_Error:IsVisible() then ShowUIPanel(HealBot_Error) end
end
