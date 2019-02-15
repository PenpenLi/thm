module(..., package.seeall)

local M = class("BulletPrefab",StageDefine.BulletEntity)

function M:ctor()
    M.super.ctor(self)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)

    self.destroyByTime = StageDefine.DestroyByTime.new()
    self:addScript(self.destroyByTime)

 
end

----------


return M