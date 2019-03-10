
local CCBaseColliderComponent = require("thstg.Framework.Package.ECS.Component.CCPhysics.Collider.CCBaseColliderComponent")
local M = class("CCBoxColliderComponent",CCBaseColliderComponent)

function M:ctor(params)
    M.super.ctor(self)
    self._createParams = params
    self._physicsBody = THSTG.PHYSICS.newBox(params)
end

function M:_onAdded(entity)
    M.super._onAdded(self,entity)
    self._physicsBody = self._physicsBody or THSTG.PHYSICS.newBox(self._createParams)
    self._physicsBody:retain()
end

function M:_onInit()

end


return M