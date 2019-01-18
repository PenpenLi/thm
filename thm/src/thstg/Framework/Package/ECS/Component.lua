local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
local M = class("Component")

function M:ctor(...)
    --用于标识组件类别
    self.__id__ = ECSUtil.getComponentId()
    self.__compName__ = nil
    self.__entity__ = nil
    self.__isEnabled__ = true
    self.__className__ = self:_getClass(...)

    self:_onInit(...)
end

function M:getClass()
    return self.__className__
end

function M:getName()
    return self.__compName__ 
end

function M:setName(name)
    self.__compName__ = name
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
    assert(self.__entity__, "[Component] You must have a parent entity")
    return self.__entity__
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

function M:_onClass(className, id, ctorArgs)
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
function M:_onAdded(entity,param)

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
--消息
function M:_onEvent(e,params)

end

--逻辑更新
function M:_onUpdate(delay,entity)
    
end

--逻辑更新完成
function M:_onLateUpdate(delay,entity)
    
end

function M:_onActive(val)
	
end
------------
function M:_added(entity,param)
    assert(not self.__entity__, "[System] System already added. It can't be added again!")
    self.__entity__ = entity
    self:_onAdded(entity,param)
end
function M:_removed(entity)
    self:_onRemoved(entity)
    self.__entity__ = nil
end
function M:_getClass(...)
    local function reverseTable(tab)
        local tmp = {}
        for i = 1, #tab do
            local key = #tab
            tmp[i] = table.remove(tab)
        end
        return tmp
    end

    local classList = {}
    local this = self
    while this do
        if not this.super then break end    --不包括最顶层,没有意义
        local keys = {this:_onClass( this.__cname or "UnknowComponent" , this.__id__ , {...})}
        for i = #keys,1,-1 do
            table.insert( classList, keys[i])
        end
        this = this.super
        
    end
    classList = reverseTable(classList)
    return ECSUtil.trans2Name(unpack(classList))
end

return M