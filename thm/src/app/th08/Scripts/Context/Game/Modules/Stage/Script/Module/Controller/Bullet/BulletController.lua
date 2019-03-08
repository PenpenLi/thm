local M = class("BulletController",StageDefine.BaseController)

function M:_onInit()
    M.super._onInit(self)

    self.bulletType = nil               --子弹类型
    self.lethality = 10                 --杀伤力               
end
---
function M:getBulletType()
    return self.bulletType
end

function M:getLethality()
    return self.lethality
end

function M:setLethality(val)
    self.lethality = val
end

function M:reset()
    local transComp = self:getComponent("TransformComponent")
    transComp:setRotation(0)
    transComp:setOpacity(255)
    transComp:setScale(1)

    --重置生命值
    local bulletHealthComp = self:getScript("BulletHealth")
    bulletHealthComp:reset()
end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    
end
---
function M:_onStart()
    M.super._onStart(self)

 
end


---


return M