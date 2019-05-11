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

--有可能Code不是同一个,这里的话以Config的为标准
function M:getEntityCode()
    return self:getData():getConfigData().code
end

function M:getEntityType()
    return EntityUtil.code2Type(self:getEntityCode())
end

return M