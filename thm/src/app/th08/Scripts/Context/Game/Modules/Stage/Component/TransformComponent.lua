local M = class("TransformComponent",THSTG.ECS.Component)

function M:_onInit()

end
------
function M:setPositionX(x)
    self:getEntity():setPositionX(x)
end
function M:setPositionY(y)
    self:getEntity():setPositionY(y)
end
function M:getPositionX()
    return self:getEntity():getPositionX()
end
function M:getPositionY()
    return self:getEntity():getPositionY()
end
--
function M:setRotation(val)
    self:getEntity():setRotation(val)
end
function M:getRotation()
    return self:getEntity():getRotation()
end

function M:setScale(val)
    self:getEntity():setScale(val)
end
function M:getScale()
    return self:getEntity():getScale()
end

------
function M:_onUpdate(delay,entity)

end

function M:_onLateUpdate(delay,entity)

end

return M