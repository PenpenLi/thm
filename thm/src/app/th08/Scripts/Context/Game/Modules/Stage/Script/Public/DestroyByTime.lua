local STAGE_VIEW_SIZE = Const.Stage.STAGE_VIEW_SIZE
local M = class("DestroyByTime",THSTG.ECS.Script)

function M:_onInit()
    self.dwellTime = 5  --在非安全区最长可停留时间s    
    self.safeArea = cc.rect(0,0,STAGE_VIEW_SIZE.width,STAGE_VIEW_SIZE.height)   --安全区
    
    self._totalTime = 0
    self._lastPos = cc.p(0,0)
    self._posComp = nil

end
---
function M:_onStart()
    self._posComp = self:getComponent("TransformComponent")
end

function M:_onUpdate(delay)
    local curPos = cc.p(self._posComp:getPositionX(),self._posComp:getPositionY())
    if not cc.rectContainsPoint(self.safeArea, curPos) then
        if curPos.x == self._lastPos.x and curPos.y == self._lastPos.y then
            self._totalTime = self._totalTime + delay
            if self._totalTime >= self.dwellTime then
                self._totalTime = 0
                self:killEntity()
            end
        else
            self._lastPos = curPos
            self._totalTime = 0
        end
    else
        self._lastPos = cc.p(0,0)
        self._totalTime = 0
    end
end

return M