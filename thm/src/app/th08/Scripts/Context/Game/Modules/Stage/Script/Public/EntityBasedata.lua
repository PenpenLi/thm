local M = class("EntityBasedata",THSTG.ECS.Script)
--实体信息
function M:_onInit()
    self.entityType = false
    self._entityData = false
end

function M:setData(data)

end

function M:getData()

end


function M:getEntityType()
    return self.entityType
end


return M