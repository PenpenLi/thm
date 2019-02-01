local M = class("EnemyBulletController",StageDefine.BulletController)

function M:_onInit()
    M.super._onInit(self)

end

function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    

    entity:setActive(false)
end
---


return M