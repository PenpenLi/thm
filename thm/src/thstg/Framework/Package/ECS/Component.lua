local M = class("Component")

function M:ctor(...)
    --用于标识组件类别
    self.__id__ = ECS.ECSUtil.getComponentId()
    self.__componentName__ = ECS.ECSUtil.trans2Name(self:_onName( self.class.__cname or "UnknowComponent" , self.__id__ ))
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
function M:_added(entity,param)
    self:_onAdded(entity)
end
function M:_removed(entity,param)
    self:_onRemoved(entity)
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
--被销毁时回调
function M:_onDestroy()
    
end

function M:_onName(className,id)
    --能够决定是否可以多次被添加
    return className
end




return M