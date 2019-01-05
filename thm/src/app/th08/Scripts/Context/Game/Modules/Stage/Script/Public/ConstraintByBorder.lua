local M = class("ConstraintByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.border = cc.rect(0,0,display.width,display.height)
    self.size = cc.size(20,20)
   
    self._prevPos = cc.p(0,0)
end

function M_onStart()
    local boxColliderComponent = self:getComponent("BoxColliderComponent")
    if boxColliderComponent then
        self.size = boxColliderComponent.size
    end
    local posComp = self:getComponent("TransformComponent")
    if posComp then
        self._prevPos = cc.p(posComp:getPositionX(),posComp:getPositionY())
    end
end
---

---
function M:_onLateUpdate()
    local posComp = self:getComponent("TransformComponent")
    local posPoint = cc.p(posComp:getPositionX(),posComp:getPositionY())
    
    if posPoint.x - self.size.width/2 < self.border.x then
        posComp:setPositionX(self._prevPos.x)
    elseif posPoint.x + self.size.width/2 > self.border.x + self.border.width then
        posComp:setPositionX(self._prevPos.x)
    end

    if posPoint.y - self.size.height/2 < self.border.y then
        posComp:setPositionY(self._prevPos.y)
    elseif posPoint.y + self.size.height/2 > self.border.y + self.border.height then
        posComp:setPositionY(self._prevPos.y)
    end

    self._prevPos = cc.p(posComp:getPositionX(),posComp:getPositionY())
end

return M