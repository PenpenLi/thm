module(..., package.seeall)
local EEntityType = GameDef.Stage.EEntityType
local EEntityLayerType = GameDef.Stage.EEntityLayerType
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

----
function M:_addEntity(e,entity,layerType)
    local entityType = entity:getScript("EntityBasedata"):getEntityType()
    layerType = layerType or StageConfig.getEntityLayerType(entityType)

    --数据装配

    --初始化

    --送入图层显示
    if layerType then
        if layerType == EEntityLayerType.Player then
            entity:addTo(THSTG.SceneManager.get(SceneType.STAGE).playerLayer)
        elseif layerType == EEntityLayerType.Barrage then
            entity:addTo(THSTG.SceneManager.get(SceneType.STAGE).barrageLayer)
        end
        Cache.stageCache:addToEntityCache(entity)
    end
end

function M:_removEntity(e,entity)
    Cache.stageCache:removeToEntityCache(entity)
end

return M