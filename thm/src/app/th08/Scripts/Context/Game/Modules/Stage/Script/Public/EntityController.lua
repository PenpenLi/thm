local M = class("EntityController",THSTG.ECS.Script)

function M:_onInit()
    self.entityType = false
    
end
---
function M:setEntityType(type)
    self.entityType = type
end

function M:getEntityType()
    return self.entityType
end

---

function M:_onStart()
 
end

function M:_onEnd()
    Dispatcher.dispatchEvent(EventType.STAGE_REMOVE_ENTITY,self:getEntity())
end


return M