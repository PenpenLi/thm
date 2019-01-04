local M = class("BulletController",THSTG.ECS.Script)

function M:_onInit()
    self.belong = 0
    self.type = false
    self.speed = cc.p(0,10)     --正方向为上

end

--
function M:stopMove()
    self.speed = cc.p(0,0)
end

function M:setSpeed(x,y)
    self.speed = cc.p(x,y)
end
---
function M:_onUpdate(delay)
    self:_moveHandle()


end

function M:_onLateUpdate()

end

-----
function M:_moveHandle()
    local posComp = self:getComponent("TransformComponent")
    posComp:setPositionY(posComp:getPositionY() + self.speed.y)
end


return M