local M = class("EntityBasedata",THSTG.ECS.Script)
--实体信息
function M:_onInit()
    self._entityData = false
    self._animData = false
end

function M:setData(entityDta,animData)
    self._entityData = entityDta
    self._animData = animData
end

function M:getData()
    return self._entityData,self._animData
end

function M:getEntityCode()
    local data = self:getData() or {}
    return data.code
end

function M:getEntityType()
    return EntityUtil.code2Type(self:getEntityCode())
end

return M