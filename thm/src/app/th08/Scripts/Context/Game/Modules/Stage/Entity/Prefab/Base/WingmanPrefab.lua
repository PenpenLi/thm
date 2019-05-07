module(..., package.seeall)

local M = class("WingmanPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)

    self.animationController = StageDefine.WingmanAnimation.new()
    self:addScript(self.animationController)

    self.wingmanController = StageDefine.WingmanController.new()
    self:addScript(self.wingmanController)

    --
    self.entityData.entityType = GameDef.Stage.EEntityType.Wingman
end

----------


return M