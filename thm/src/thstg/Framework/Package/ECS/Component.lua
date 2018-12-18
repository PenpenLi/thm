local M = class("Component")
local _componentId = 0
function M:ctor(...)
    --用于标识组件类别
    _componentId = _componentId + 1
    self.__id__ = _componentId
    self.__componentName__ = self:_onName( self.class.__cname or "" ,self.__id__)
    self.__isEnabled__ = true
    
    self:_onInit(...)
end

function M:getName()
    return self.__componentName__
end
function M:getID()
    return self.__id__
end
function M:isEnabled()
	return self.__isEnabled__
end
function M:setEnabled(val)
	self.__isEnabled__ = val
end
--
--[[以下函数必须重载]]
--用于初始化数据
function M:_onInit(...)

end
--被添加时的回调
function M:_onAdded(entity)

end
--被移除时的回调
function M:_onRemoved(entity)

end

--逻辑更新
function M:_onUpdate(delay,entity)
    
end

--逻辑更新完成
function M:_onLateUpdate(delay,entity)
    
end

function M:_onName(className,id)
    --能够决定是否可以多次被添加
    return className
end




return M