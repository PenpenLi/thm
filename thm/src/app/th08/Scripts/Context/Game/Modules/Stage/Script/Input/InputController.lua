local M = class("InputController",THSTG.ECS.Script)

function M:_onInit()
    self.keyMapper = THSTG.UTIL.newControlMapper()
end
--


--
function M:_onLateUpdate()

end

----

function M:_onKeyRegister(mapper)
    
end
return M