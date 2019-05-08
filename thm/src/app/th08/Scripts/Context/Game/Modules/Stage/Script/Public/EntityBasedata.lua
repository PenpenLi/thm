local M = class("EntityBasedata",THSTG.ECS.Script)
--实体信息
function M:_onInit()
    self._entityData = false
end

function M:setData(data)
    self._entityData = data
end

function M:setDataByCode(code)
    self:setData(EntityUtil.getRealData(code))
end

function M:getData()
    return self._entityData or {}
end

function M:getEntityCode()
    local data = self:getData()
    return data.code or 0
end

function M:getEntityType()
    return EntityUtil.code2Type(self:getEntityCode())
end

return M