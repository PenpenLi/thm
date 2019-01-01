module(..., package.seeall)

local M = class("BulletPrefab",StageDefine.BulletEntity)

function M:ctor()
    M.super.ctor(self)
    
    self.bulletController = StageDefine.BulletController.new()
    self:addScript(self.bulletController)

    self.destroyByBorder = StageDefine.DestroyByBorder.new()
    self:addScript(self.destroyByBorder)

    --
    
    -- debugUI(self)
end

----------


return M