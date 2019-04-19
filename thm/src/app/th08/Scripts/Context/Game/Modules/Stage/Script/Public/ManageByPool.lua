
local M = class("ManageByPool",THSTG.ECS.Script)

function M:_onInit()
    self.poolMgr = nil
    
    self._actionComp = nil
    -- self._hookHandle = THSTG.UTIL.newFuncHookHandler()
end
---
function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    
    self._actionComp = entity:getComponent("ActionComponent")
    -- self._hookHandle:hook(entity,"destroy",function (entity,oldFunc)
    --      entity:setActive(false)
    -- end)
    entity:setActive(false)
end

function M:_onStart()
    self:getEntity():setActive(true)
end

function M:_onEnd()
    self:getEntity():setActive(false)
    self._actionComp:stop()
end

return M