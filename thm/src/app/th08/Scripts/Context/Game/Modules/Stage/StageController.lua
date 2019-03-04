module(..., package.seeall)

local M = class("StageController", THSTG.MVC.Controller)

function M:_onInit()

end

function M:_onOpen()
    Dispatcher.addEventListener(EventType.STAGE_ADD_ENTITY, handler(self,self.addEntity))
    Dispatcher.addEventListener(EventType.STAGE_REMOVE_ENTITY, handler(self,self.removentity))
end

function M:_onClose()
    Dispatcher.removeEventListener(EventType.STAGE_ADD_ENTITY, handler(self,self.addEntity))
    Dispatcher.removeEventListener(EventType.STAGE_REMOVE_ENTITY, handler(self,self.removentity))
end

----
function M:addEntity(e,params)

end

function M:removentity(e,params)

end

return M