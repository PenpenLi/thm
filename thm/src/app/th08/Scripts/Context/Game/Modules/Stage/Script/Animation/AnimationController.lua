local M = class("AnimationController",THSTG.ECS.Script)

function M:_onInit()
    self._curAnimation = nil            --当前动作
    self._lastAnimation = nil           --动作
    self._animationDict = false

end
--
function M:play()
    
end

--
function M:_onLateUpdate()

end

----

return M