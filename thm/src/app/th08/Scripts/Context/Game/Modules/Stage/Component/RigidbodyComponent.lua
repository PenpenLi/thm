local M = class("RigidbodyComponent",THSTG.ECS.Component)

function M:_onInit()
    self.speed = StageDefine.Speed.new()
    self.body = cc.rect(0,0,20,20)
end

return M