local M = class("Entity")
local _entityId = 10000
function M:ctor()
    _entityId = _entityId + 1

    self.__id__ = _entityId
    self.__components.__ = false

    self:_onInit()
end
--
function M:addComponent(component)
    self.__components.__ = self.__components.__ or {}
    local componentName = component:getName()
    self.__components.__[componentName] = component
end
--移除组件
function M:removeComponent(name)
    self.__components.__[componentName] = nil
end
--获取组件
function M:getComponent(name)
    return self.__components.__[componentName]
end

function M:isHaveComponent(name)
    return getComponent(name) and true or false
end
--

function getId()
    return self.__id__
end

---
--[[以下由子类重载]]
function M:_onInit()
end

return M