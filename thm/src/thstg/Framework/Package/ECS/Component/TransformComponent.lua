local M = class("TransformComponent",ECS.Component)

function M:_onInit()

end
------
function M:setPosition(x,y)
    if type(x) == "table" then
        if x.x == self:getPositionX() and x.y == self:getPositionY() then return end
        return self:getEntity():setPosition(x)
    end
    if x == self:getPositionX() and x == self:getPositionY() then return end
    return self:getEntity():setPosition(x,y)
end
function M:setPositionX(x)
    if x == self:getPositionX() then return end
    self:getEntity():setPositionX(x)
end
function M:setPositionY(y)
    if y == self:getPositionY() then return end
    self:getEntity():setPositionY(y)
end
function M:getPositionX()
    return self:getEntity():getPositionX()
end
function M:getPositionY()
    return self:getEntity():getPositionY()
end
--默认是左下角坐标
function M:getPosition()
    return self:getEntity():getPosition()
end

function M:getWorldPosition()
    return self:getEntity():convertToWorldSpace(cc.p(0,0))
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

function M:_onRemoved( ... )
 
end

return M