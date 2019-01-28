local M = class("WingmanAnimation",StageDefine.AnimationController)

function M:_onInit()
    M.super._onInit(self)
end

function M:_onState()
    return {
        initial = "Idle",
        events  = {
            {name = "Idle", from = {},  to = "Idle"},
        },
        callbacks = {
            onIdle = handler(self,self._onIdle),
        },
    }
end

function M:getWingmanType()
    return self.wingmanType
end
----
function M:_onStart()
    M.super._onStart(self)
  
    local wingmanControScript = self:getScript("WingmanController")
    self.wingmanType = wingmanControScript.wingmanType
end
----
function M:_onMove(dx,dy)
 
end



function M:_onIdle(event)
    self:getSprite():playAnimationForever(AnimationCache.getResBySheet(StageConfig.getRoleAnimSheetArgs(self:getRoleType(),"stand_normal")))
end

----


return M