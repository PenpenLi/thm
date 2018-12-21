module(..., package.seeall)

local M = class("Batman",StageDefine.BatmanPrefab)
function M:ctor()
    M.super.ctor(self)
    --初始化变量
    -- self.batmanController.bulletEntity = StageDefine.EnemyBullet

    debugUI(self)
end


return M