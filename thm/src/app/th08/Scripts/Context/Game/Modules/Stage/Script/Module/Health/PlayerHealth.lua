
local M = class("PlayerHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

end
--

----
function M:_onHurt()


end

function M:_onDead()
    print(15,"玩家死亡")
end

return M