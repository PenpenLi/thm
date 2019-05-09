
local M = class("BulletHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

end

function M:_onStart()
   M.super._onStart(self)

   self:setMaxBlood(self._basedata:getData().life)
   
   
end

----

return M