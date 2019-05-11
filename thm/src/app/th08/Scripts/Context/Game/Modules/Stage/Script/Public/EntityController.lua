local M = class("EntityController",THSTG.ECS.Script)
--实体信息
function M:_onInit()

end

-----
function M:_onStart()
 
end

function M:_onEnd()
    Dispatcher.dispatchEvent(EventType.STAGE_REMOVE_ENTITY,self:getEntity())
end


return M