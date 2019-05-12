local M = class("AutoRotationScript",THSTG.ECS.Script)

function M:_onInit()
    M.super._onInit(self)

end

function M:_onAdded(entity)
    M.super._onAdded(self,entity)
end

function M:_onStart()
    M.super._onStart(self)
    
    local actionComp = self:getComponent("ActionComponent")
    actionComp:stopAll()
    actionComp:runForever(cc.RotateBy:create(1,360))  --永久自旋
end

function M:_onUpdate()

end

return M