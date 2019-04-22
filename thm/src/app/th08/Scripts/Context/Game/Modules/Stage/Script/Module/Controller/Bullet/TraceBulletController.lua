local M = class("PlayerBulletController",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)

end

function M:_onUpdate()
    --TODO:追踪弹
end

return M