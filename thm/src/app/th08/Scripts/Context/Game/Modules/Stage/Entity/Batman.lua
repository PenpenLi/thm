module(..., package.seeall)

local M = class("Batman",StageDefine.BatmanPrefab)
function M:ctor(roleType)
    M.super.ctor(self)
    --初始化变量
    self.playerController.roleType = roleType
    self.playerController.bulletEntity = StageDefine.EnemyBullet
end


return M