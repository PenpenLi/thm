module(..., package.seeall)

local M = class("WingmanPrefab",StageDefine.MovableEntity)

function M:ctor()
    M.super.ctor(self)

    --
    self.entityCtrl.entityType = Const.Stage.EEntityType.Wingman
end

----------


return M