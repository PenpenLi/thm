local M = class("PlayerController",THSTG.ECS.Script)

function M:_onInit()
    self.bubbleEntity = StageDefine.BulletPrefab
end

function M:_onUpdate()
end

return M