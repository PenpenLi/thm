local M = class("ConstraintByBorder",THSTG.ECS.Script)

function M:_onInit()
    self.border = cc.rect(0,0,display.width,display.height)
    self.size = cc.size(32,48)      --TODO:由纹理决定

    self._transComp = nil
    self._prevPos = cc.p(0,0)
end

function M:_onStart()
    local spriteComp = self:getComponent("SpriteComponent")
    if spriteComp then
        local size = spriteComp:getSprite():getContentSize()
        self.size.width = math.max(self.size.width,size.width)
        self.size.height = math.max(self.size.height,size.height)
    end

    local transComp = self:getComponent("TransformComponent")
    if transComp then
        self._prevPos = cc.p(transComp:getPositionX(),transComp:getPositionY())
        self._transComp = transComp
    end
end
---

---
function M:_onLateUpdate()
    local transComp = self._transComp
    local posPoint = cc.p(transComp:getPositionX(),transComp:getPositionY())
    
    if posPoint.x - self.size.width/2 < self.border.x then
        transComp:setPositionX(self._prevPos.x)
    elseif posPoint.x + self.size.width/2 > self.border.x + self.border.width then
        transComp:setPositionX(self._prevPos.x)
    end

    if posPoint.y - self.size.height/2 < self.border.y then
        transComp:setPositionY(self._prevPos.y)
    elseif posPoint.y + self.size.height/2 > self.border.y + self.border.height then
        transComp:setPositionY(self._prevPos.y)
    end

    self._prevPos = cc.p(transComp:getPositionX(),transComp:getPositionY())
end

return M