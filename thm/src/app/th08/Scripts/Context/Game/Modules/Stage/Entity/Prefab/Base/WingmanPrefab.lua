module(..., package.seeall)

local M = class("WingmanPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)

    self.wingmanController = StageDefine.WingmanController.new()
    self:addScript(self.wingmanController)

    --
    self.entityCtrl.entityType = GameDef.Stage.EEntityType.Wingman
end

----------


return M