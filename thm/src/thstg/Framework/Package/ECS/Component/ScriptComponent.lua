--脚本组件是一个特殊的组件
local M = class("ScriptComponent",ECS.Component)
function M:ctor(...)
    M.super.ctor(self)
    
end

--如果不支持定时器只能手动执行了
function M:start(param)
    self:_onStart(param)
end

function M:removeScript(scprit)
	return self:getEntity():removeScript(scprit)
end

function M:getScript(name)
	return self:getEntity():getScript(name)
end
----
--以下不能被重写
function M:_onClass(className,id)
    return className
end

function M:_onEnter()
    self:start()
end
--
function M:_onExit()
    self:_onEnd()
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

function M:_onEnd()
    
end

--[[以下需要被重载]]
function M:_onUpdate(delay)
   
end

function M:_onLateUpdate(delay)
    
end


return M