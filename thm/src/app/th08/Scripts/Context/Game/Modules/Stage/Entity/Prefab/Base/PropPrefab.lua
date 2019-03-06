module(..., package.seeall)

local M = class("PropPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)

    self:setName("PROP")

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)
    
    self.destroyByTime = StageDefine.DestroyByTime.new()
    self:addScript(self.destroyByTime)

    self.collisionController = StageDefine.PropCollision.new()
    self:addScript(self.collisionController)

    self.propController = StageDefine.PropController.new()
    self:addScript(self.propController)

    self.animationController = StageDefine.PropAnimation.new()
    self:addScript(self.animationController)

    --
    self.entityCtrl.entityType = Const.Stage.EEntityType.Prop
end

----------


return M