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


--所有实体统一的移除入口
function M:destroy()
    if ObjectCache.release(self:getEntity()) then 
        self:getEntity():setActive(false) 
    else 
        self:killEntity() 
    end
end 
---

function M:_onStart()
 
end


return M