module(..., package.seeall)

local M = class("Yukari",StageDefine.PlayerPrefab)
function M:_onInit()
    --初始化变量
    self.playerController.roleType = RoleType.YUKARI
    self.playerController.bubbleEntity = StageDefine.PlayerBullet


end

function M:shot()
    
end
return M