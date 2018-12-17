
local M = class("System")

function M:ctor(...)
    self.__entity = nil
    
    self:_onInit(...)
end

----
function M:__setEntity(entity)
    assert(not self.__entity, "[System] System already added. It can't be added again!")
    self.__entity = entity
end


function M:__getEntity()
    assert(self.__entity, "[System] You must have a parent entity")
    return self.__entity
end

--移除组件
function M:removeComponent(name)
	return self:__getEntity():removeComponent(name)
end
--获取组件
function M:getComponent(name)
	return self:__getEntity():getComponent(name)
end
--是否存在组件
function M:isHaveComponent(name)
    return self:__getEntity():getComponent(name) and true or false
end
----

function M:update(delay,entity)
    self:_onUpdate(delay,entity)
end

---
--[[系统生命周期]]
function M:_onInit(...)
    
end

function M:_onAdded(entity)

end

function M:_onRemoved(entity)
    
end

--[[以下需要被重载]]
function M:_onUpdate(delay,entity)
    --通过对Entity获取到相应的Component
end


return M