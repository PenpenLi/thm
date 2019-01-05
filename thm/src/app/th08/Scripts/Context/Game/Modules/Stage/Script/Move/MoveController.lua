local M = class("MoveController",THSTG.ECS.Script)

function M:_onInit()
    self.speed = cc.p(0,0)     --正方向为上
end

--
function M:stop()
    self.speed = cc.p(0,0)
end

function M:setSpeed(x,y)
    self.speed = cc.p(x,y)
end
---
function M:_onUpdate(delay)
    self:__moveHandle()
end

-----
function M:__moveHandle()
    local posComp = self:getComponent("TransformComponent")
    posComp:setPositionX(posComp:getPositionX() + self.speed.x)
    posComp:setPositionY(posComp:getPositionY() + self.speed.y)

end


return M