local M = class("EntityBasedata",THSTG.ECS.Script)
--实体信息
function M:_onInit()
    self._data = false  
end

function M:setData(data)
    self._data = data
end

function M:getData()
    return self._data
end

function M:getEntityCode()
    if self:getData() then
        return self:getData():getCode()
    end
end

function M:getEntityType()
    if self:getData() then
        return EntityUtil.code2Type(self:getEntityCode())
    end
end

return M