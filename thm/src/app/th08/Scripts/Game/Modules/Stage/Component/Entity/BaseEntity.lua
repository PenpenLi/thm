module(..., package.seeall)

local M = class("BaseEntity",cc.Node)
function M:ctor()
    self._entityData = false	--实体数据
    
end


function M:getEntityData() 
    return self._entityData 
end

function M:setEntityData(value)

end


------------------------------------------------------------------

--?????????
function M:_onEnterScene()
	if self._entityData then
		
	end
end

--?????????
function M:_onExitScene()
	if self._entityData then
		
	end
end

--?????
function M:_onDestroy()
	if self._entityData then
		
		self._entityData = false
	end
end

------------------------------------------------------------------

return M