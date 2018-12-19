module(..., package.seeall)

local M = class("Player",StageDefine.PlayerPrefab)
function M:ctor(roleType)
    M.super.ctor(self)
    --初始化变量
    self.playerController.roleType = roleType
    self.playerController.bulletEntity = StageDefine.PlayerBullet
end

function M:_onInit()


end


return M