local M = class("RigidbodyComponent",THSTG.ECS.Component)

function M:_onInit()
    self.speed = StageDefine.Speed.new()
    self.body = cc.rect(0,0,20,20)
end

function M:apply(power)
    
end
----
function M:_onAdded()

end

function M:_onRemoved()

end

function M:_onUpdate()

end


return M