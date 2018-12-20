--脚本组件是一个特殊的组件
local M = class("ScriptComponent",ECS.Component)
function M:ctor(...)
    M.super.ctor(self)
    self.__entity = nil
    

    --
    --让脚本在帧开始前执行一次初始化
    --以下不严谨,因为对象可能已经销毁了才执行
    -- local handle = nil
    -- local scheduler = cc.Director:getInstance():getScheduler()
    -- local onNextFrame = function()
    --     -- self:start()
    --     print(15,"1",self:getID())
    --     scheduler:unscheduleScriptEntry(handle)
    --     handle = nil
    -- end
    -- handle = scheduler:scheduleScriptFunc(onNextFrame, 0, false)
    
    --
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

function M:getEntity()
    return self:__getEntity()
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

function M:destroy()
    return self:__getEntity():destroy()
end

----
--以下不能被重写
function M:_onClass(className,id)
    return M.__cname,className
end

function M:_added(entity,param)
    self:__setEntity(entity)
    self:_onAdded(param)

end
function M:_removed(entity,param)
    self:_onRemoved(param)

end

function M:_onEnter()
    self:start()
end
--
function M:_onExit()
    self:_onEnd()
end
---------------
--如果不支持定时器只能手动执行了
function M:start(param)
    self:_onStart(param)
end

---
--[[脚本的生命周期]]
function M:_onInit(...)
    
end

function M:_onAdded(param)
    
end

function M:_onRemoved(param)
    
end
--执行start()时回调
function M:_onStart()

end

--[[以下需要被重载]]
function M:_onUpdate(delay)
   
end

function M:_onLateUpdate(delay)
    
end

function M:_onDestroy()

end

function M:_onEnd()
    
end
return M