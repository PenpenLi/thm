local M = class("OnmyouGyokuBulletController",StageDefine.PlayerBulletController)

function M:_onInit()
    M.super._onInit(self)

    self.rotation = -90
    self.speed = cc.p(0,10)
    ---------
    self.searchR = 100      --搜索半径
end

function M:_onUpdate()
    --追踪弹

end
---


return M