local M = class("Script",ECS.Component)
function M:ctor(...)
    M.super.ctor(self)
    self.__entity = nil
    
    self:_onInit(...)
end

----
function M:setEntity(entity)
    assert(not self.__entity, "[System] System already added. It can't be added again!")
    self.__entity = entity
end


function M:getEntity()
    assert(self.__entity, "[System] You must have a parent entity")
    return self.__entity
end

--移除组件
function M:removeComponent(name)
	return self:getEntity():removeComponent(name)
end
--获取组件
function M:getComponent(name)
	return self:getEntity():getComponent(name)
end
--是否存在组件
function M:isHaveComponent(name)
    return self:getEntity():getComponent(name) and true or false
end

----
--以下不能被重写
function M:_onName(className,id)
    return ("Script" .. "_" .. className)
end

function M:_onAdded(entity,parmam)
    self:setEntity(entity)
    self:_onStart(parmam)

end

function M:_onRemoved(entity,parmam)
    self:_onEnd(parmam)
end

---
--[[脚本的生命周期]]
function M:_onInit(...)
    
end

function M:_onStart(params)

end

function M:_onEnd(params)

end

--[[以下需要被重载]]
function M:_onUpdate(delay)
    --通过对Entity获取到相应的Component
end

function M:_onLateUpdate(delay)
    --通过对Entity获取到相应的Component
end

return M