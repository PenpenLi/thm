
local M = class("PlayerHealth",StageDefine.HealthController)

function M:_onInit()
   M.super._onInit(self)

end
--

----
function M:_onHurt()


end

function M:_onDead()
    --TODO:用于检测决死
    print(15,"玩家死亡")
    SEXManager.playEffect({
        refNode = self:getEntity(),
        source = {EffectType.PUBLIC,"ccle_player_die_magic_01"},
    })
end

return M