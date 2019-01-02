local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
local M = class("Component")

function M:ctor(...)
    --用于标识组件类别
    self.__id__ = ECSUtil.getComponentId()
    self.__entity = nil
    self.__isEnabled__ = true
    
    self:_onInit(...)
end

function M:getClass()
    return ECSUtil.trans2Name(self:_onClass( self.class.__cname or "UnknowComponent" , self.__id__ ))
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

function M:getEntity()
    assert(self.__entity, "[Component] You must have a parent entity")
    return self.__entity
end

--移除组件
function M:removeComponent(...)
	return self:getEntity():removeComponent(...)
end
--获取组件数组
function M:getComponents(...)
	return self:getEntity():getComponents(...)
end
--获取组件
function M:getComponent(...)
	return self:getEntity():getComponent(...)
end
--是否存在组件
function M:isHaveComponent(...)
    return self:getEntity():getComponent(...) and true or false
end
--
function M:getSystem(...)
	return self:getEntity():getSystem(...)
end
--
function M:killEntity()
    self:getEntity():destroy()
end
--
--[[
    以下函数由子类重载
]]

function M:_onClass(className,id)
    --能够决定是否可以多次被添加
    return className
end

--[[
    以下函数不建议重载,违反了设计模式的思想
]]

--用于初始化数据
function M:_onInit(...)

end
--被添加时的回调
function M:_onAdded(entity)

end
--被移除时的回调
function M:_onRemoved(entity)

end
--被加载进场景时回调
function M:_onEnter()

end
--被移除场景时回调
function M:_onExit()

end

--逻辑更新
function M:_onUpdate(delay,entity)
    
end

--逻辑更新完成
function M:_onLateUpdate(delay,entity)
    
end

------------
function M:_added(entity,param)
    assert(not self.__entity, "[System] System already added. It can't be added again!")
    self.__entity = entity
    self:_onAdded(entity)
end
function M:_removed(entity)
    self:_onRemoved(entity)
    self.__entity = nil
end

return M