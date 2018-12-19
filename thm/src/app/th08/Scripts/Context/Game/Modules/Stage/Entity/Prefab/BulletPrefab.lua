module(..., package.seeall)

local M = class("BulletPrefab",StageDefine.BulletEntity)

function M:ctor()
    M.super.ctor(self)
    
    self.bulletController = StageDefine.BulletController.new()
    self:addScript(self.bulletController)

    self.destoryByBorder = StageDefine.DestoryByBorder.new()
    self:addScript(self.destoryByBorder)

    --
    
    -- debugUI(self)
end

----------


return M