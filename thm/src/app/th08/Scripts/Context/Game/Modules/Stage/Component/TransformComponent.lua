local M = class("TransformComponent",THSTG.ECS.Component)

function M:_onInit()

end
------
function M:setPosition(x,y)
    self:getEntity():setPosition(x,y)
end
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
function M:getPosition()
    return self:getEntity():getPosition()
end
function M:convertToWorldSpace(anchorPoint)
    anchorPoint = anchorPoint or cc.p(0.5,0.5)
    return self:getEntity():convertToWorldSpace(anchorPoint)
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
function M:setOpacity(val)
    self:getEntity():setOpacity(val)
end
function M:getOpacity()
    return self:getEntity():getOpacity()
end
------
function M:_onUpdate(delay,entity)

end

function M:_onLateUpdate(delay,entity)

end

return M