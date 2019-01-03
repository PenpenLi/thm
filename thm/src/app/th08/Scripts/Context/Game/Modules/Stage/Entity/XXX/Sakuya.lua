module(..., package.seeall)

local M = class("Sakuya",StageDefine.PlayerPrefab)

function M:_onInit()
    --初始化变量
    self.playerController.roleType = StageDefine.RoleType.SAKUYA
end

function M:shot()
    
end

return M