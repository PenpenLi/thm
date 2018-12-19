module(..., package.seeall)

local M = class("Reimu",StageDefine.PlayerPrefab)
function M:_onInit()
    --初始化变量
    self.playerController.roleType = StageDefine.RoleType.Reimu
    self.playerController.bubbleEntity = StageDefine.PlayerBullet


end

function M:shot()
    
end
return M