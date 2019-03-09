
local CCBaseRigidbodyComponent = require("thstg.Framework.Package.ECS.Component.CCPhysics.CCBaseRigidbodyComponent")
local M = class("CCBoxRigidbodyComponent",CCBaseRigidbodyComponent)

function M:_onInit()
    self._physicsBody = THSTG.PHYSICS.newBox()--理论质点
end

function M:setPhysicsBodySize()

end

return M