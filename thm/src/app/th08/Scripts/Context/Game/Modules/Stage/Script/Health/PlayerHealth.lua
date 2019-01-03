local HealthController = require("Scripts.Context.Game.Modules.Stage.Script.Health.HealthController")
local M = class("PlayerHealth",HealthController)

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