
---
local Speed = require("Scripts.Context.Game.Modules.Stage.Component.Data.Speed")
local M = class("RigidbodyComponent",THSTG.ECS.Component)

function M:_onInit()
    self.mass = 1
    self.speed = Speed.new()
    self.gravityScale = 1.0
end

--力和施力位置
function M:addForce(power,pos)
    
end
----
function M:_onAdded()

end

function M:_onRemoved()

end

function M:_onUpdate()
    --获取某个组件
end


return M