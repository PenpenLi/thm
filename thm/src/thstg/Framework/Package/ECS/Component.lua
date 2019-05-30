local ECSUtil = require "thstg.Framework.Package.ECS.ECSUtil"
local M = class("Component")
function M:ctor(...)
    --用于标识组件类别
    self.__id__ = UIDUtil.getComponentUID()
    self.__compName__ = self.__cname or "UnknowComponent"
    self.__entity__ = nil
    self.__isEnabled__ = true
    self.__priority__ = 1
    self.__classPath__,self.__classList__,self.__classMap__ = ECSUtil.trans2ClassInfo(self,{...})

    self:_onInit(...)
end

function M:getClassPath()
    return self.__classPath__
end

function M:getClassList()
    return self.__classList__
end

function M:getClassMap()
    return self.__classMap__
end

function M:getClassName()
    return self.__cname
end

function M:getName()
    return self.__compName__ 
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

function M:getPriority()
    return self.__priority__
end

function M:setPriority(val)
    self.__priority__ = val
    self:getEntity():_adjustComponentPriority(self)
end

function M:getEntity()
    assert(self.__entity__, "[Component] You must have a parent entity")
    return self.__entity__
end

function M:isAdded()
    return self.__entity__ and true or false
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
---
--[[扩展]]
function M:getComponentsInChildren(...)
	local ret = {}
	local args = {...}
	local function visit(node)
		local comps = node:getComponents(unpack(args))
		if comps and next(comps) then
			for _,v in pairs(comps) do
				table.insert( ret, v )
			end
		end
		local children = node:getChildren()
		if children and next(children) then
			for _,v in pairs(children) do
                if tolua.iskindof(v,"cc.Node") then
                    if v:isActive() then
                        visit(v)
                    end
				end
			end
		end
	end
	visit(self:getEntity())
	return ret
end

function M:getComponentInParent(...)
	local perent = self:getEntity():getParent()
	while perent do
		local comp = perent:getComponent(...)
		if comp then
			return comp
		end
		perent = perent:getParent()
	end
end
function M:getScriptsInChildren(...)
    return self:getComponentsInChildren(...)
end
function M:getScriptInParent(...)
    return self:getComponentInParent(...)
end
---
function M:destroyEntity()
    self:getEntity():destroy()
end
--
--[[
    以下函数由子类重载
]]

function M:_onClass(className, id, ctorArgs)
    --能够决定是否可以多次被添加
    return {className}
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

function M:_removed(entity,force)
    if self:_onRemoved(entity) then
        self.__entity__ = nil
    end
end

return M