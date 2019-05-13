module(..., package.seeall)
local EEntityType = GameDef.Stage.EEntityType
local M = class("StageController", THSTG.MVC.Controller)

function M:_onInit()

end

function M:_onOpen()
    Dispatcher.addEventListener(EventType.STAGE_ADD_ENTITY, self._addEntity, self)
    Dispatcher.addEventListener(EventType.STAGE_REMOVE_ENTITY, self._removEntity, self)
end

function M:_onClose()
    Dispatcher.removeEventListener(EventType.STAGE_ADD_ENTITY, self._addEntity, self)
    Dispatcher.removeEventListener(EventType.STAGE_REMOVE_ENTITY, self._removEntity, self)
end
--

function M:_addEntity(e,entity)
    self:getView():addEntity2Layer(entity)
    ModuleCache.Stage:addToEntityCache(entity)

end

function M:_removEntity(e,entity)
    ModuleCache.Stage:removeFromEntityCache(entity)
end

return M