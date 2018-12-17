
local M = class("SystemComponent",ECS.Component)

function M:ctor(entity)
    M.super.ctor(self)
    self.__entity__ = entity
    self.__systems__ = false
end


function M:addSystem(system)
    assert(not tolua.cast(component, "ECS.System"), "[Entity] the addChild function param value must be a THSTG ECS.System object!!")
    self.__systems__ = self.__systems__ or {}
    table.insert(self.__systems__, system )
    system:__setEntity(self.__entity__)
    system:_onAdded(self.__entity__)
end

function M:removeSystem(system)
    for i = #self.__systems__,1,-1 do
		if system == self.__systems__[i] then
			table.remove( self.__systems__,i )
			system:_onRemoved(self.__entity__)
			break
		end
	end
end

function M:_onAdded()

end

function M:_onRemoved()

end

function M:_onUpdate(delay)
    if self.__systems__ then
		for k,v in ipairs(self.__systems__) do
			v:_onUpdate(delay,entity)
		end
	end
end

--逻辑更新完成
function M:_onFinished(delay,entity)
    
end

return M